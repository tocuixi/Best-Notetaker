rm(list=ls())
library(shiny)
library(googlesheets4)

ui <- fluidPage(
  
  fluidRow(
    column(12, 
           h1("Who's the Best Notetaker?")
    )
  ),
  
  fluidRow(
    column(5, 
           textInput("NoteFile",
                     label="Please paste the Google Sheet url of the NOTES: ", value="")
    ),
    
    column(5, 
           textInput("KeywordFile",
                     label="Please paste the Google Sheet url of the KEYWORDS DATABASE: ",value="")
    )
    
  ),
  
    fluidRow(
    column(3, 
           actionButton("Read","Read Data", width=200
           )
    )
  ),
  fluidRow(
    column(10, tags$br(),tags$hr()
           
    )
  ),

  fluidRow(
    column(10, 
           selectInput("chapter","Please select the chapter/lecture: ", c("not loaded"), selectize=TRUE
          )
    )
  ),
    
  fluidRow(
    column(4, 
           actionButton("Run","Find the Best Notetaker",width=200
           )
    )
  ), 
  
  fluidRow(
    column(10, tags$br(),tags$hr()
           
    )
  ),
    
  fluidRow(
      tags$br(),
      tabsetPanel(
      tabPanel("Notes Stats",
               textOutput("Warning"),
               tableOutput("rank"),
               
               ),
      tabPanel("Keywords Stats",
              
               tableOutput("keywordstats")
               ) 
  )
  ),
  
  fluidRow(
    column(10, tags$br(),tags$hr()
           
    )
  ),
  
  fluidRow(
    column(3, 
         actionButton("Reset","Reset", width=100)
           ),
    column(3,actionButton("help","Open Instructions", width=200)
  )),
  
  fluidRow(
    column(10, tags$br(),tags$hr()
           
    )
  ),
  
  fluidRow(
    column(1),
    column(10,
           tags$a(href="https://docs.google.com/document/d/1pFfoJZZNkdp0qP7uQ7bOOEDkdoW1Uh5WTKa_0eujb0c/edit?usp=sharing",textOutput("instruction1"))),
    column(1)
  ),
  
  fluidRow(
    column(10, tags$br(),tags$hr()
           
    )
  ),
  
  fluidRow(
    column(1),
    column(10, "The app is created by Dr. Xi Cui at the Communication Department, College of Charleston. (Source codes can be found at https://github.com/tocuixi/Best-Notetaker, CC-SA-NC, 2020)"),
    column(1)
  )
)





server <- function(input, output, session) {

  observeEvent(input$help,{
    if (input$help%%2!=0){
      output$instruction1 <- 
        renderText({"Please follow the link to read the user instructions closely"})
      updateActionButton(session,"help",label="Close Instructions")
    } else{
      output$instruction <- renderText({})
      output$instruction1 <- renderText({})
      updateActionButton(session,"help",label="Open Instructions")
    }
  }
  )
  
  observeEvent(input$Reset,{
             output$keywordstats <- renderTable({})
             output$rank <- renderTable({})
              output$Warning <- renderText({})
              if (input$chapter!="not loaded"){
              newnotedata <- read_sheet(
                ss=input$NoteFile,
                range=input$chapter)
              
                if (ncol(newnotedata)>2){
                  newnotedata1 <- newnotedata[,1:2]
                  sheet_write(newnotedata1,input$NoteFile,input$chapter)
                }
              }
              updateTextInput(session,"NoteFile",label="Please paste the Google Sheet url of the NOTES: ", value="")
              updateTextInput(session,"KeywordFile",label="Please paste the Google Sheet url of the KEYWORDS DATABASE: ",value="")
              updateSelectizeInput(session,"chapter",choices="not loaded")
  }
  )
  
  
  
  observeEvent(input$Read,
               {if (input$KeywordFile==""|input$NoteFile=="")
                 {output$Warning <- renderText("URLs can not be empty!")
                 } else 
                   {
                   output$Warning <- renderText("")
                  sheetlist <- sheet_names(input$KeywordFile)
                  
                 updateSelectizeInput(session,"chapter",choices=sheetlist)
                   }
                }
  )
  
  observeEvent(input$Run,
               {keyworddata <- read_sheet(
                 ss=input$KeywordFile,
                 range=input$chapter)
  
                notedata <- read_sheet(
                 ss=input$NoteFile,
                 range=input$chapter)
  
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
                        paste(keywordlist[keywordcol],"|",keyworddata[keywordrow,keywordcol],sep="")
                    }
                  }
                  for (noterow in 1: length(notedata$Notes)){
                    match <- grepl(keywordlist[keywordcol],notedata$Notes[noterow],ignore.case=TRUE)
                    if (match==TRUE){
                      
                      hit[noterow] <- paste(hit[noterow],keywordlist1[keywordcol])
                      hit[noterow] <- gsub("NULL ","",hit[noterow])
                      hitnumber[noterow] <- hitnumber[noterow]+1
                      if (is.na(correctscore[keywordcol])==TRUE){
                        correctscore[keywordcol] <- 0
                      }  
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
  
                notedata1 <- cbind(
                  notedata,hit=as.matrix(hit))
                
                notedata1 <- cbind(
                  notedata1,miss=as.matrix(miss))
                
                score=paste(
                  hitnumber," / ",ncol(keyworddata))
                
                notedata1 <- cbind(
                  notedata1,score=as.matrix(score)) 
                
                output$rank <- renderTable(notedata1)
              
                sheet_write(notedata1,input$NoteFile,input$chapter)
                
                correctscore[is.na(correctscore)] <- 0 
                
                correctscore1 <- correctscore/length(notedata$Notes)
                
                correctscore2 <- as.data.frame(t(correctscore1))
                keywordlist2  <- as.data.frame(t(keywordlist1))
                correctscore3 <- rbind(keywordlist2,correctscore2)
                output$keywordstats <- renderTable(correctscore3,colnames = FALSE)
                 
               }
    
  )
  
  
  
  
 
  
}

shinyApp(ui = ui, server = server)