library(shiny)
shinyUI(
  fluidPage(
    titlePanel("See whether you would have survived the sinking of the RMS Titanic!"),
    sidebarLayout(
      sidebarPanel(
        h3("Input your data"),
        p("Note that there might not have been any passengers aboard the Titanic meeting your data. In this case, no prediction is possible."),
        selectInput("selectAge", "Age", c("Choose Age" = "",
                                          "0-19" = 0,
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
        h3("Prediction of your survival based on passengers matching your data"),
        textOutput("textPrediction"),
        plotOutput("plotSurvival")
      )
    )
  )
)