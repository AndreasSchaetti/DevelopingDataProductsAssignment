library(shiny)
library(titanic)
library(dplyr)

titanic_train <- subset(titanic_train, select = c(Survived, Pclass, Sex, Age))
titanic_train$Sex <- as.factor(titanic_train$Sex)
titanic_train$Pclass <- as.factor(titanic_train$Pclass)

# input missing age values

is.na.age <- is.na(titanic_train$Age)
is.female <- titanic_train$Sex == "female"

sampled.age.female <- sample(titanic_train$Age[!is.na.age & is.female],
                             length(titanic_train$Age[is.na.age & is.female]),
                             replace=TRUE)
sampled.age.male <- sample(titanic_train$Age[!is.na.age & !is.female],
                          length(titanic_train$Age[is.na.age & !is.female]),
                          replace=TRUE)

titanic_train$Age[is.na.age & is.female] <- sampled.age.female
titanic_train$Age[is.na.age & !is.female] <- sampled.age.male

shinyServer(function(input, output)
{
  data <- reactive({
    ageGroup <- as.numeric(input$selectAge)
    sex <- input$radioSex
    pclass <- input$radioClass

    titanic_train %>%
    filter(Age >= ageGroup*10,
           ifelse(ageGroup == 6, TRUE, Age < (ageGroup+1)*10),
           Sex == sex,
           Pclass == pclass)
  })

  output$plotSurvival <- renderPlot({
    if (nrow(data()) > 0)
    {
      barplot(table(data()$Survived),
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