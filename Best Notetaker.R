rm(list=ls())
library(googlesheets4)
settings <- choose.files("please open the 'settings.csv' file in your computer.")
settingsdata <- read.csv(settings,header=TRUE)
courseindex <- 1:length(settingsdata$course)
courselist <- cbind("Course No."=courseindex, "Course Name"=settingsdata$course)
print(courselist, quote = FALSE, row.names = FALSE)
course <- readline("please type the number of the course from the list: ")
course <- as.integer(course)
NoteFile <- settingsdata$notes_spreadsheet[course]
KeywordFile <- settingsdata$keywords_spreadsheet[course]
sheetlist <- sheet_names(settingsdata$notes_spreadsheet[course])
sheetindex <- 1:length(sheetlist)
chapterlist <- cbind("Worksheet No."=sheetindex,"Chapter/Lecture"=sheetlist)
print(chapterlist,quote=FALSE, row.names=FALSE)
chapter <- readline("Please type in the number of the chapter/lecture you are studying: ")
chapter <- as.integer(chapter)
keyworddata <- read_sheet(
  ss=KeywordFile,
  range=sheetlist[chapter],
)
notedata <- read_sheet(
  ss=NoteFile,
  range=sheetlist[chapter],
)


keywordlist1 <- as.list(colnames(keyworddata))
keywordlist <- keywordlist1
hit <- list()
hit[1] <- " "
hitnumber <- as.integer(list())
miss<- list()
miss[1] <- " "
missnumber <- as.integer(list())
correctscore <- as.integer(list())

for (keywordcol in 1: ncol(keyworddata)){
  keywordlist[keywordcol] <- names(keyworddata[keywordcol])
  for (keywordrow in 1: nrow(keyworddata[,keywordcol])){
    if (is.na(keyworddata[keywordrow,keywordcol])==FALSE){
    keywordlist[keywordcol] <- 
      paste(keywordlist[keywordcol],"|",keyworddata[keywordrow,keywordcol],sep="")}
  }
    for (noterow in 1: length(notedata$Notes)){
      match <- grepl(keywordlist[keywordcol],notedata$Notes[noterow],ignore.case=TRUE)
    if (match==TRUE){
            
      hit[noterow] <- paste(hit[noterow],keywordlist1[keywordcol])
      hit[noterow] <- gsub("NULL ","",hit[noterow])
      hitnumber[noterow] <- hitnumber[noterow]+1
      if (is.na(correctscore[keywordcol])==TRUE){correctscore[keywordcol] <- 0}  
      correctscore[keywordcol] <- correctscore[keywordcol]+1
                  }
      else{
       
        miss[noterow] <- paste(miss[noterow],keywordlist1[keywordcol])
        miss[noterow] <- gsub("NULL ","",miss[noterow])
        missnumber[noterow][is.na(missnumber[noterow])] <- 0 
        missnumber[noterow] <- missnumber[noterow]+1
        if (is.na(hitnumber[noterow])==TRUE){hitnumber[noterow] <- 0}  
      }
      
  }
}

notedata1 <- cbind(notedata,hit=as.matrix(hit))
notedata1 <- cbind(notedata1,miss=as.matrix(miss))
score=paste(hitnumber," / ",ncol(keyworddata))
notedata1 <- cbind(notedata1,score=as.matrix(score))
sheet_write(notedata1,NoteFile,chapter)
correctscore[is.na(correctscore)] <- 0 
correctscore1 <- correctscore/length(notedata$Notes)
correctscore2 <- as.data.frame(t(correctscore1))
sheet_append(KeywordFile,correctscore2,chapter)


