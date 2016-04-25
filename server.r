library(shiny)
library(quanteda)

# loading the prediction matric
load('predictMatrix.rda')

predictNextword <- function(input) {
  tokens <- tokenize(input, what="word", removeNumber=TRUE,
                  removePunct=TRUE, removeSeparators=TRUE, 
                  removeTwitter=FALSE, ngrams=3L)
  tokens <- tolower(tokens)
  size <- length(tokens)
  lasttoken <- tokens[[1]][size]
  last2word <- paste(unlist(strsplit(lasttoken,'_'))[2:3],collapse = "_")
  lastword <- unlist(strsplit(lasttoken,'_'))[2]
  tbl <- data.frame(tokens)
  colnames(tbl) <- c("token")
  # merging two results
  tbl <- merge(tbl, predictMatrix, by.x = "token", by.y = "word")
  sumprod <- prod(tbl$prob)
  # get the potential results from prediction matrix
  prediction <- predictMatrix[which(predictMatrix$key == last2word),]
  # use 2-gram when no result if found
  if (nrow(prediction) == 0) {
    prediction <- predictMatrix[which(predictMatrix$key == lastword),]
  }
  # check for the new prediction table
  if (nrow(prediction) == 0) {
    rand.int <- sample(1:nrow(predictMatrix), 1)
    return(predictMatrix[rand.int,3])
  }
  prediction$nextwordProb <- prediction$prob * sumprod
  prediction <- prediction[order(-prediction[,5]),]
  return (prediction[1,c("nextword")])
}

shinyServer(
  function(input, output) {
     output$inputValue <- renderPrint(input$userInput)
     # tokenize the user input
     output$nextword <- renderPrint(predictNextword(input$userInput))
  }
)