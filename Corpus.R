library(httr)
library(dplyr)
library(RKorAPClient)
library(tidyverse)
library(purrrlyr)

##### OAuth for metadata ##########

korap_app <- oauth_app("korap-client", key = "3bn6m649p3NrhrrR7NtPTF", secret = "orzCRl4yTzuYIRFzwHXPxg")
korap_endpoint <- oauth_endpoint(NULL,
                                 "settings/oauth/authorize",
                                 "api/v1.0/oauth2/token",
                                 base_url = "https://korap.ids-mannheim.de")
token_bundle = oauth2.0_token(korap_endpoint, korap_app, scope = "search match_info", cache = FALSE)

kco <- new("KorAPConnection", accessToken = token_bundle[["credentials"]][["access_token"]])

gendern1 <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+[\\*]innen"', vc = "textType = /Zeit.*/ & pubDate since 2022" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet")) %>% fetchAll()

##### Query for different forms of genderinclusive language ###############

number_of_pages <- 1000
gendern1 <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+[\\*]innen"', vc = "textType = /Zeit.*/ & pubDate since 2000" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  gendern1 <- fetchNext(gendern1, randomizePageOrder = TRUE)
}
number_of_pages <- 1000
gendern2 <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+[_]innen"', vc = "textType = /Zeit.*/ & pubDate since 2000" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  gendern2 <- fetchNext(gendern2, randomizePageOrder = TRUE)
}
number_of_pages <- 1000
gendern3 <- corpusQuery(kco,'"[ABCDEFGHIJKLMNOPQRSTUVW][abcdefghijklmnopqrstuvwxyz]+Innen"', vc = "textType = /Zeit.*/ & pubDate since 2000" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  gendern3 <- fetchNext(gendern3, randomizePageOrder = TRUE)
}

##### combining the different datasets and writing a csv ##########

comb <- rbind(gendern1@collectedMatches, gendern2@collectedMatches, gendern3@collectedMatches)
df <- as.data.frame(comb)
write.csv(df, 'gendern.csv')

######## Query for generic sentences ###############

number_of_pages <- 2000
generic <- corpusQuery(kco, '<base/s=s>' , vc = "textType = /Zeit.*/ & pubDate since 2000" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  generic <- fetchNext(generic, randomizePageOrder = TRUE)
}

number_of_pages <- 1000
generic2 <- corpusQuery(kco, '<base/s=s>' , vc = "textType = /Zeit.*/ & pubDate since 2010" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  generic2 <- fetchNext(generic2, randomizePageOrder = TRUE)
}

######## filtering all genderd language (including the word "innen" because of female forms like Ärztinnen) + csv ############

combg <- rbind(generic@collectedMatches, generic2@collectedMatches)
df <- as.data.frame(combg)
only__male <- filter(df, !grepl("[*_]?[iI]nnen",snippet))
write.csv(df, 'only__male.csv')

###############MINT BERUFE####################

berufe <- read_file('/Users/lisaeichhorn/Downloads/Uni Leipzig/Bachelorarbeit/liste mint berufe.txt')
berufeclean <- str_replace_all(berufe, '\n', ' ')

number_of_pages <- 1000
mint_berufe <- corpusQuery(kco, berufeclean , vc = "textType = /Zeit.*/ & pubDate since 2000" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  mint_berufe <- fetchNext(mint_berufe, randomizePageOrder = TRUE)
}
number_of_pages <- 1000
mint_berufe2 <- corpusQuery(kco, berufeclean , vc = "textType = /Zeit.*/ & pubDate since 2010" , metadataOnly = FALSE, fields = c("corpusSigle", "textSigle", "pubDate", "pubPlace", "availability","textClass", "snippet"))
for (x in 0:number_of_pages) {
  print(x)
  mint_berufe2 <- fetchNext(mint_berufe2, randomizePageOrder = TRUE)
}

####### filtering all gendered language ##############

all_mint <- rbind(mint_berufe@collectedMatches, mint_berufe2@collectedMatches)
dfm <- as.data.frame(all_mint)
mint_only_male <- filter(dfm, !grepl("[*_]?[iI]nnen",snippet))
write.csv(mint_only_male, 'mint_only_male.csv')
