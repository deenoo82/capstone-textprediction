library(shiny)

# Define UI for application that takes in input
shinyUI(
  pageWithSidebar(
    # application title
    headerPanel("Text Prediction based on ngram model"),
    
    sidebarPanel(
      textInput('userInput','Please provide text input for next word prediction'),
      submitButton('Submit')
  ),
  mainPanel(
    p('This app uses n-gram model to try and predict the next word based on user input'),
    p('Please input text into the text input and hit submit button'),
    p('Initial query will take longer due to loading dataset into memory, subsequent query will be much faster'),
    h3('Results of Suggestion'),
    h4('You have entered'),
    verbatimTextOutput("inputValue"),
    h4('The next word is '),
    textOutput("nextword")
    )
))