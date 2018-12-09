library(httr)
library(xml2)
library(RCurl)
library(magrittr)
library(stringi)
library(stringr)
library(rvest)
library(tidyverse)
library(forcats)
board = "Gossiping"
index = 36250:37250#11/14~11/24
urls = paste('https://www.ptt.cc/bbs/',paste(board,sep=''),'/index', 
              paste(index,'.html',sep=''),  
              sep='')
url = paste('https://www.ptt.cc/bbs/',paste(board,sep=''),'/index', 
             paste(38913,'.html',sep=''),  
             sep='')
geturl<-function(url){
  GET(url,set_cookies("over18"="1"))%>%content()%>%
  xml_find_all("//div[@class='title']/a[@href]")%>%
  xml_attr("href")%>%
  paste('https://www.ptt.cc', ., sep='')
}

st <- proc.time()
article_urls <- sapply(urls, geturl)
proc.time() - st
#10min

all_urls<- function(x){
  res=NULL
  for(i in (1:length(x))){
    ifelse(!is.null(res),
           res <- c(res, x[[i]]), res <- x[[i]])
  }
  return(res)
}

urls<-all_urls(article_urls)

getDoc <- function(line){
  GET(line,set_cookies("over18"="1"))%>%content()%>%
  xml_find_all("//div[@id='main-content']")%>%
  xml_text() %>%stri_conv("UTF-8", "UTF-8")
  # stri_conv for windows
}

st <- proc.time()
articles <- sapply(urls, getDoc)
proc.time() - st

#  user  system elapsed 
#280.96   18.64 7362.88 

all_urls0<- function(x){
  res=NULL
  url=NULL
  for(i in (1:length(x))){
    ifelse(!is.null(res),
           res <- c(res, x[[i]]), res <- x[[i]])
           url <- c(url,names(x[i]))
  }
  return(list(url,res))
} 

all_articles<-all_urls0(articles)

pttdata<-data.frame(url=all_articles[[1]],articles=all_articles[[2]],row.names = 1:length(all_articles[[1]]),
                    stringsAsFactors = FALSE)

take_word<-function(articles){
  x<-gsub("[^\u4e00-\u9fa5:]+", "", articles)%>%
    gsub("(作者)|(看板)|(標題)|(發信站)|(批踢踢實業坊)|(來自)|(文章網址)|(編輯)|(啊)|(喔)|(啦)|(你)|(我)|(他)|(們)|(推)|(的)|(噓)|(了)|(是)|(就)|(人)|(不)|(在)|(有)|(都)|(要)|(沒)|(還)|(也)|(說)|(會)|(嗎)+", "", .)%>%
      gsub("\n|[ \t]+", "",. )%>%
      str_split(., boundary("word"))
  xx<-data.frame(word=x[[1]],row.names = 1:length(x[[1]]),
                 stringsAsFactors =FALSE )
  return(xx)
}

st <- proc.time()
pttword<-sapply(pttdata[,2], take_word)
proc.time() - st
#no detail
#  user  system elapsed 
# 37.42    1.02   38.58 
#data size 511.4 Mb
#detail
# user  system elapsed 
#64.33    0.99   65.60 
#data size 435.4 Mb
#14.86% reduction
all_word<- function(x){
  res=NULL
  for(i in (1:length(x))){
    ifelse(!is.null(res),
           res <- c(res, x[[i]]), res <- x[[i]])
  }
  resword<-data.frame(word=res,row.names = 1:length(res))
  return(resword)
}

st <- proc.time()
final_pttword<-all_word(pttword)
proc.time() - st
#no detail
#   user  system elapsed 
#1385.24  225.44 1612.92 

#detail
#   user  system elapsed 
# 961.17  114.98 1083.77 

#write.csv(final_pttword,file = "pttword1114_1124.csv",fileEncoding ="UTF-8",row.names = FALSE)

final_pttword[1206:1256,]
################################
#use factor to plot

summary(final_pttword,maxsum=200)

factor(final_pttword$word)
final_pttword%>%count(word, sort = TRUE)



wordcount<-fct_count(final_pttword$word,sort = TRUE)
wordcount0<-data.frame(word=wordcount$f,freq=wordcount$n,stringsAsFactors = FALSE)

final_pttword0<-final_pttword
x1<-c("柯","姚","丁","台灣","韓","陳","國民黨","民進黨")
x2<-c("高","邁","陳")

st <- proc.time()
final_pttword1<- factor(final_pttword0$word, levels = c(x1,x2))
final_pttword2<-na.omit(final_pttword1)%>%data.frame(word=.)
proc.time() - st
ggplot(final_pttword2, aes(word)) +
  geom_bar()


x1<-c("柯","姚","丁","台灣","韓","陳","國民黨","民進黨")
factor(final_pttword0$word,levels = x1)%>%
na.omit()%>%data.frame(word=.)%>%
ggplot(., aes(word)) +
  geom_bar()


library(xtable)


https://blog.csdn.net/fairewell/article/details/72820299
https://haoyu.love/blog431.html
http://larry850806.github.io/2016/06/23/regex/
  http://datascienceandr.org/articles/RegularExpression.html
  https://stackoverflow.com/questions/13992403/regex-validation-of-email-addresses-according-to-rfc5321-rfc5322