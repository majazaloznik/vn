###############################################################################
## Data Extraction and clean up
###############################################################################
## 1. Create link to file
## 2. Filter heads of households and get summaries 
# IPUMS IMPORT
# retrospective clean up of code April 2018

# http://www.r-bloggers.com/laf-ing-about-fixed-width-formats/

###############################################################################
library(LaF) # for importing fixed width format
library(dplyr)
library(tidyr)
library(ENmisc) # for weighted boxplot function

###############################################################################
## set up for importing ipums, fixed widths, var.names and types.
ipums.file <- "../data/IPUMS/ipumsi_00003.dat"
wdts <- c(3, 4, 4, 10, 3, 8, 
          2, 1, 2, 6, 1, 6, 
          1, 1, 2, 3, 8, 
          3, 3, 3, 2, 2, 1, 
          1, 3, 3, 2, 1, 1, 1, 2, 
          4, 2, 2, 2, 2, 4, 
          1, 2, 2, 2, 1, 1, 
          1, 1, 2, 2, 3, 1, 
          1, 2,  2, 4, 3, 3, 5, 
          2, 1, 1, 2, 2, 3, 
          1,  1, 1, 1, 1, 1)
column.names <- c("cntry", "year", "sample", "serial", "persons", "wthh", 
                  "subsamp","urban", "regionw", "geolev1", "regnv","wtf", 
                  "mortnum", "anymort", "hhtype", "pernum", "wtper", 
                  "momloc", "poploc", "sploc", "parrule", "srule", "relate", 
                  "related", "wtf2", "age", "age2", "sex", "marst", "marstd", "wtf3",
                  "brthyr", "brthmo", "chborn", "chsurv", "lstbmth", "lstbyr",
                  "lstbsex", "chdead", "homechd", "awaychd", "school", "lit",
                  "edattan", "edatand",  "wtf2","yrschl", "educvn", "empstat", 
                  "empstatd", "wtf4", "occisco", "occ", "isco88a", "indgen", "ind",
                  "wtf5", "classwk", "classwkd", "empsect", "migrates", "migvn",
                  "disable", "disemp", "disblind", "disdeaf", "dislowr","dismntl")
column.classes <- c("categorical", "categorical", "categorical", "integer", "integer", "double",
                    "integer", "categorical", "categorical","categorical", "categorical", "integer",
                    "integer", "categorical", "categorical", "integer", "double",
                    "categorical", "categorical", "categorical", "categorical","categorical","categorical",
                    "categorical", "integer", "integer", "categorical", "categorical", "categorical", "categorical", "integer",
                    "integer", "categorical", "integer", "integer", "categorical", "integer",
                    "categorical", "integer", "integer", "integer", "categorical", "categorical",
                    "categorical", "categorical", "integer", "integer", "categorical", "categorical",
                    "categorical", "integer", "categorical", "categorical", "categorical", "categorical", "categorical",
                    "integer", "categorical", "categorical", "categorical", "categorical", "categorical",
                    "categorical", "categorical", "categorical", "categorical", "categorical", "categorical")
## test it works
# read.fwf(ipums.file,width=wdts, col.names=column.names,skip=30, n = 10)

## open link to file
d <- laf_open_fwf(ipums.file, column_widths=wdts,
                  column_types=column.classes, column_names = column.names)

rm(column.classes, column.names, ipums.file, wdts)

# Some naming conventions:
# G - grouped totals
# ww - probably superflous, but means with weights

###############################################################################
## 2. Filter heads of households and get summaries 
###############################################################################

# total population for each census
all.G.ww <- d[,c("year", "wtper")] %>%
  group_by(year) %>%
  summarise(n=sum(wtper)/100) %>%
  ungroup()

## get all heads of household ever
all.heads <- d[,c("year","relate","sex", "age",  "wtper","edattan", "lit")] %>%
  filter(relate==1) %>% 
  filter(age != 999)

## get all heads of household in agricultural occupations
agri.heads <- d[,c("year","relate","sex", "age", "occ", "wtper","edattan", "lit")] %>%
  dplyr::filter(relate==1) %>%
  filter(age != 999) %>% 
  dplyr::filter(occ %in% c("0025","0920", "0921",
                           "0600", "0611", "0612", "0613",
                           "0630","0631", "0632", "0633"))
# extract boxplot data
# first get boxplot stats with weighted population:

agri.box.stats <- wtd.boxplot(age ~ sex + year , weights=agri.heads$wtper, data = agri.heads, plot = FALSE)
all.head.box.stats <- wtd.boxplot(age ~ sex + year , weights=all.heads$wtper, data = all.heads, plot = FALSE)

# I only need the $stats part anyway
agri.box.stats <- agri.box.stats[1]
all.head.box.stats <- all.head.box.stats[1]

## summary mean age, with weights
all.heads.G.ww <- all.heads %>%
  group_by(year, sex) %>%
  dplyr::summarize(n=sum(wtper)/100, mean.age=weighted.mean(age, wtper)) %>%
  ungroup()
agri.heads.G.ww <- agri.heads %>%
  group_by(year, sex) %>%
  dplyr::summarize(n=sum(wtper)/100, mean.age=weighted.mean(age, wtper)) %>%
  ungroup()

## save these so i don't need to import them every time:
save(file="data/processed/ipums/heads.RData", all.heads.G.ww, 
     agri.heads.G.ww, 
     agri.box.stats, 
     all.head.box.stats, 
     all.G.ww )



###############################################################################
## 4. Some age related statistics
###############################################################################
# average age of all agri workers to compare to agri census
agri.workers <- d[,c("year","relate","sex", "age", "occ", "wtper", "edattan", "lit")] %>%
  dplyr::filter(occ %in% c("0025","0920", "0921",
                           "0600", "0611", "0612", "0613",
                           "0630","0631", "0632", "0633")) %>%
  group_by(year, sex) %>%
  filter(age != 999) %>% 
  dplyr::summarize(n=sum(wtper)/100, mean.age=weighted.mean(age, wtper))

## 95th percentile for women.
quantiles.agri.women <- agri.heads %>%
  group_by(year, sex) %>%
  dplyr::summarize(n=sum(wtper)/100, mean.age=weighted.mean(age, wtper),
                   quant95=wtd.quantile(age, weights=wtper, probs=c(.95)),
                   ecdf55 = wtd.Ecdf(age, weights=wtper)[[2]][which(wtd.Ecdf(age, weights=wtper)[[1]]==55)],
                   ecdf60 = wtd.Ecdf(age, weights=wtper)[[2]][which(wtd.Ecdf(age, weights=wtper)[[1]]==60)],
                   ecdf65 = wtd.Ecdf(age, weights=wtper)[[2]][which(wtd.Ecdf(age, weights=wtper)[[1]]==65)])


retirement <- quantiles.agri.women %>%
  mutate(retire=(1-ifelse(sex==2, ecdf55,ecdf60))*100,
         sex=factor(sex, labels=c("female","male"))) %>%
  select(year, sex, retire) %>%
  ungroup() %>%
  spread(year, retire) %>%
  as.data.frame

# what about all employed people - not heads empstat==1
quantiles.all.employed <- d[,c("year","relate","sex", "age",  "wtper","empstat")] %>%
  filter(empstat==1) %>%
  group_by(year, sex) %>%
  dplyr::summarize(n=sum(wtper)/100, mean.age=weighted.mean(age, wtper),
                   quant95=wtd.quantile(age, weights=wtper, probs=c(.95)),
                   ecdf55 = wtd.Ecdf(age, weights=wtper)[[2]][which(wtd.Ecdf(age, weights=wtper)[[1]]==55)],
                   ecdf60 = wtd.Ecdf(age, weights=wtper)[[2]][which(wtd.Ecdf(age, weights=wtper)[[1]]==60)],
                   ecdf65 = wtd.Ecdf(age, weights=wtper)[[2]][which(wtd.Ecdf(age, weights=wtper)[[1]]==65)])

retirement.all.employed <- quantiles.all.employed %>%
  mutate(retire=(1-ifelse(sex==2, ecdf55,ecdf60))*100,
         sex=factor(sex, labels=c("female","male"))) %>%
  select(year, sex, retire) %>%
  ungroup() %>%
  spread(year, retire) %>%
  as.data.frame
retirement.table <- rbind(retirement, retirement.all.employed)
retirement.table <- cbind(categ = c("Heads of HH in agriculture","Heads of HH in agriculture",
                                    "All employed", "All employed"),
                          retirement.table)
saveRDS(retirement.table, "data/processed/ipums/retirement.rds")

###############################################################################
## 5. Eductation distribution plot
###############################################################################

FunEduSum <- function(df){
  x <- df %>%
    group_by(year, sex, edattan) %>%
    dplyr::summarize(n=sum(wtper)/100, mean.age=weighted.mean(age, wtper)) %>%
    group_by(year, sex) %>%
    mutate(freq = n/sum(n)) %>%
    select(year, sex, edattan, freq) %>%
    ungroup() %>%
    spread(edattan, freq) %>%
    select(year, sex, 5,3,4,6)
  return(x)
}

agri.heads.edu.G.ww <- FunEduSum(agri.heads)
all.heads.edu.G.ww <- FunEduSum(all.heads)

# save 
saveRDS(agri.heads.edu.G.ww, "data/processed/ipums/agri.education.rds")
saveRDS(all.heads.edu.G.ww, "data/processed/ipums/all.education.rds")

