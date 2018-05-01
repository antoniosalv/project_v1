#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(dplyr)
library(googleVis)
library(maps)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(shinythemes)
library(rsconnect)
library(hexbin)
library(ggthemes)

data= read.csv("./NPAO_Cons_v4.csv", stringsAsFactors = FALSE)
summaryvariables= read.csv("summaryvariables4.csv", stringsAsFactors = FALSE)
data$Year = as.factor(data$Year)
data$State = as.factor(data$State)



shinyUI(dashboardPage(
  dashboardHeader(title="US Health: Exploring Risk Factors, Policies and Environment",
                  titleWidth = 650), 
  
  dashboardSidebar(
    sidebarMenu(
      fluidRow(
        column(12,
               selectizeInput(inputId = "State",
                              label = "State", 
                              choices = unique(data$State)
                              )  
              )
              ),
      
      fluidRow(
        column(12,
               selectizeInput(inputId = "Topic",
                              label = "Topic",
                              choices = c("ExistStateLevelFoodPolicyCouncil", 
                              "PolicyHealthierFoodRetail", 
                              "StateAdCompleteStreetsPolicy")
                              )
              )
            )
      )
    ),
  
#main panel section
  dashboardBody(fluidRow(
             column(width=4, height = 100,
              mainPanel(plotOutput("graph1", width = "150%", height = "300px"))
                    ),
              column(width=4, height =100,
                mainPanel(plotOutput("graph2", width = '150%', height = '300px'))
                     ),
              column(width=4, height = 100,
                mainPanel(plotOutput("graph3", width = '150%', height = '300px'))
                     )  
                    ),
             br(),
             br(),
             br(),
             
            fluidRow(
             column(4, height=300,
                  mainPanel(plotlyOutput("graph4", width = "200%", height = "300px"))
                    ),
            column(4, height=300,
                   mainPanel(plotlyOutput("graph5", width = '200%', height = '300px'))
                    ),
            column(width = 4, height=300,
                    mainPanel(plotlyOutput("graph6", width = '200%', height = '300px')) 
                   )
                   ),
            br(),
            br(),
            br(),
            
           fluidRow(
             column(width = 12, height=100,
                    mainPanel(htmlOutput('graph7', width = '150%', height = '200px'))
                    )
                   )
           
           )
    )
  )



