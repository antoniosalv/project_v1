#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
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

shinyServer(function(input, output){
  output$graph1 <- renderPlot(
    data %>% 
    filter(., Topic == 'PercentAdultsObesity') %>% 
    filter(State == input$State) %>%
    group_by(Year) %>% 
    ggplot(aes(x = Year, y = Value)) +
    geom_boxplot(fill="darkblue", alpha=0.5) + 
    ggtitle("Adults That Have Obesity")+
    theme(plot.title = element_text(hjust = 0.6))+
    ylab("%") +
    theme(axis.text=element_text(size=18),
    axis.title=element_text(size=18,face="bold"))+
    theme_economist() + scale_fill_economist()
    #theme_stata() +scale_fill_economist()+
    #theme_minimal() +scale_fill_solarized()+
    #theme_gdocs() + scale_fill_gdocs()#+
    #theme_tufte() #+ scale_fill_tableau()
  )
  output$graph2 <- renderPlot(
    data %>% 
      filter(., Topic == 'PercentAdultsNoPhysicalActivity') %>% 
      filter(State == input$State) %>%
      group_by(Year) %>% 
      ggplot(aes(x = Year, y = Value)) +
      geom_boxplot(fill="blue", alpha=0.8) + 
      ggtitle("No Physical Activity") +
      theme(plot.title = element_text(hjust = 0.3))+
      ylab("%") +
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=18,face="bold"))+
    theme_economist() + scale_fill_economist()
    #theme_stata() #+scale_fill_economist()+
    #theme_minimal() +scale_fill_solarized()+
    #theme_gdocs() + scale_fill_gdocs()#+
    #theme_tufte() #+ scale_fill_tableau()
    
  )
  output$graph3 <- renderPlot(
    data %>% 
      filter(., Topic == 'PercentConsumingVegLessOneTimeDaily') %>% 
      filter(State == input$State) %>%
      group_by(Year) %>% 
      ggplot(aes(x = Year, y = Value)) +
      geom_boxplot(fill="darkblue", alpha=0.8) + 
      ggtitle("Veg. Less Than One Day")+
      theme(plot.title = element_text(hjust = 0.5))+
      ylab("%")+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=18,face="bold"))+
    theme_economist() + scale_fill_economist()
    #theme_stata() +scale_fill_economist() #+
    #theme_minimal() +scale_fill_solarized()#+
    #theme_gdocs() + scale_fill_gdocs()+
    #theme_tufte() #+ scale_fill_tableau()
  )
  
  output$graph4 <- renderPlotly(
    data %>% 
      filter(., Topic == input$Topic) %>% 
      filter(., Topic != "StateAdCompleteStreetsPolicy") %>%
      filter(State != 'National') %>% 
      filter(., Year =='2012' & Year != '2016') %>% 
      plot_geo(., locationmode = 'USA-states') %>%
      add_trace(
        z = ~Value, text = ~ValueOrig, locations = ~StateAbbr,
        color = ~Value, colors='Purples', reversescale=TRUE, showscale=FALSE
      ) %>%
      #colorbar(title = "StatePolicy", xpad ='10') %>%
      layout(
        title = 'State Level Food Council',
        geo = list(scope = 'usa',
          projection = list(type = 'usa'),
          showlakes = TRUE,
          lakecolor = toRGB('white'))
              )
                      )
  
  output$graph5 <- renderPlotly(
    data %>% 
      filter(., Topic == input$Topic) %>% 
      filter(State != 'National') %>% 
      filter(., Year =='2011') %>% 
      plot_geo(., locationmode = 'USA-states') %>%
      add_trace(
        z = ~Value, text = ~ValueOrig, locations = ~StateAbbr,
        color = ~Value, colors='Greens', reversescale=TRUE, showscale=FALSE
      ) %>%
      #colorbar(title = "StatePolicy", xpad ='10') %>%
      layout(
        title = 'Policy for Healthier Food Retail',
        geo = list(scope = 'usa',
                   projection = list(type = 'albers usa'),
                   showlakes = TRUE,
                   lakecolor = toRGB('white'))
              )
                    )
  

  output$graph6 <- renderPlotly(
    data %>% 
      filter(., Topic == input$Topic) %>% 
      filter(., Topic != "ExistStateLevelFoodPolicyCouncil") %>%
      filter(State != 'National') %>% 
      filter(., Year =='2016' & Year !='2012') %>% 
      plot_geo(., locationmode = 'USA-states') %>%
      add_trace(
        z = ~Value, text = ~ValueOrig, locations = ~StateAbbr,
        color = ~Value, colors='Blues', reversescale=TRUE, showscale=FALSE
      ) %>%
      colorbar(title = "StatePolicy", xpad ='10') %>%
      layout(
        title = 'Complete Street Policy -2016',
        geo = list(scope = 'usa',
                   projection = list(type = 'albers usa'),
                   showlakes = TRUE,
                   lakecolor = toRGB('white'))
            ) 
                )
  
  output$graph7 <- renderGvis(gvisBubbleChart(summaryvariables, 
                    idvar="StateAbbr", 
                    xvar = "AvgOW", 
                    yvar="Value1",
                    colorvar = "TOPIC",
                    sizevar ="AvgOW",
                    options=list(width=1000, height=600,
                    title ="Risk Factor Obesity vs Environment Factors",
                    hAxis="{title: '% Obesity'}",
                    vAxis ="{title: '%'}",
                    legend= "{position: 'in'}", #bottom top left right none
                    bubble ="{textStyle: {fontSize:  10}}"
                             )
                   )
                )
  
  }
)
