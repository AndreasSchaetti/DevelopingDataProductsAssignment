library(shiny)
shinyUI(
  fluidPage(
    titlePanel("Titanic Survival Predictor"),
    sidebarLayout(
      sidebarPanel(
        h3("Input your Data"),
        selectInput("selectAge", "Age", c("Choose Age" = "",
                                          "0-9" = 0,
                                          "10-19" = 1,
                                          "20-29" = 2,
                                          "30-39" = 3,
                                          "40-49" = 4,
                                          "50-59" = 5,
                                          "60 and older" = 6)),
        radioButtons("radioSex", "Sex", c("Female" = "female", "Male" = "male")),
        radioButtons("radioClass", "Class", c("First" = 1, "Business" = 2, "Economy" = 3)),
        submitButton("Update")
      ),
      mainPanel(
        h3("Prediction of Survival"),
        textOutput("textPrediction"),
        plotOutput("plotSurvival")
      )
    )
  )
)