library(RKorAPClient)
library(tidyverse)
library(purrrlyr)

######### genderinclusive language since 2000#################


plotGenderSuffix <- function(word = ".*",
                             years = c(2000:2023),
                             as.alternatives = FALSE,
                             vc = "textType= /Zeit.*/ & pubDate in",
                             suffixes = c('Innen"', '[\\*]innen"', '[_]innen"', ':innen"'),
                             prefixes = c('"',      '"',            '"',        '"'),
                             kco = new("KorAPConnection", verbose=TRUE)) {
  hc <-
    frequencyQuery(kco, paste0(prefixes, word, suffixes), paste(vc, years), as.alternatives=as.alternatives) %>%
    hc_freq_by_year_ci(as.alternatives)
  print(hc)
  hc
 
}

hc <- plotGenderSuffix('[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+' , c(2000:2023), as.alternatives = FALSE)

############# which magazines use genderinclusive language the most###############

Zeit1 <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+[\\*]innen"', "textType = /Zeit.*/ & pubDate since 2022", fields="corpusTitle") %>% fetchAll()

########## die unteren wurden immer wieder versucht und haben über Stunden keine Ergebnisse geliefert, da die Anfrage zu groß war###############

Zeitalle <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+[\\*]innen"', "textType = /Zeit.*/ & pubDate since 2000", fields="corpusTitle") %>% fetchAll()
ZeitInnen <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+Innen"', "textType = /Zeit.*/ & pubDate since 2000", fields="corpusTitle") %>% fetchAll()
Zeitunterstrich <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+[_]innen"', "textType = /Zeit.*/ & pubDate since 2000", fields="corpusTitle") %>% fetchAll()



