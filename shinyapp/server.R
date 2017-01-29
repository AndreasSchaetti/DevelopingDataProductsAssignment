library(shiny)
library(titanic)
library(dplyr)

titanic.data <- subset(titanic_train, select = c(Survived, Pclass, Sex, Age))
titanic.data$Sex <- as.factor(titanic.data$Sex)
titanic.data$Pclass <- as.factor(titanic.data$Pclass)

# input missing age values

is.na.age <- is.na(titanic.data$Age)
is.female <- titanic.data$Sex == "female"

sampled.age.female <- sample(titanic.data$Age[!is.na.age & is.female],
                             length(titanic.data$Age[is.na.age & is.female]),
                             replace=TRUE)
sampled.age.male <- sample(titanic.data$Age[!is.na.age & !is.female],
                          length(titanic.data$Age[is.na.age & !is.female]),
                          replace=TRUE)

titanic.data$Age[is.na.age & is.female] <- sampled.age.female
titanic.data$Age[is.na.age & !is.female] <- sampled.age.male

shinyServer(function(input, output)
{
  data <- reactive({
    ageGroup <- as.numeric(input$selectAge)
    sex <- input$radioSex
    pclass <- input$radioClass

    if (is.na(ageGroup))
    {
      return(data.frame())
    }
    else if (ageGroup == 0)
    {
      # age group 0 goes from 0 to 19 years
      max.age.filter <- function(age) { age < 20 }
    }
    else if(ageGroup == 6)
    {
      # age group 6 contains all passengers from 60 years upwards
      max.age.filter <- function(age) { rep(TRUE, length.out = length(age)) }
    }
    else
    {
      max.age.filter <- function(age) { age < (ageGroup+1)*10 }
    }

    titanic.filtered <- titanic.data %>%
      filter(Age >= ageGroup*10,  # minimum age
             max.age.filter(Age),  # maximum age
             Sex == sex,
             Pclass == pclass)
  })

  output$plotSurvival <- renderPlot({
    if (nrow(data()) > 0)
    {
      n.died <- sum(data()$Survived == 0)
      n.survived <- sum(data()$Survived == 1)

      barplot(c(n.died, n.survived),
              col = c("red", "green"),
              main = "Survival in your group",
              xlab = "Survived",
              ylab = "Number of passengers",
              names.arg = c("No", "Yes"))
    }
  })

  output$textPrediction <- renderText({
    if (nrow(data()) == 0)
    {
      "No data available for prediction"
    }
    else
    {
      paste("Your probability of survival is",
            100*round(mean(data()$Survived), 2), " %!")
    }
    
  })
})