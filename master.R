SMRs <- read_excel("SMR Template 20180314_SemiCompleted_1750hrs.xlsx",skip = 1)
SMRs$row_num <- 1:dim(SMRs)[1]
View(SMRs)

SMRs$`Identification of Suspicious Indicator(s)`

library(tidyverse)
library(tidytext)
library(magrittr)
data("stop_words")

row_num_SI <- SMRs[,c("row_num", "Identification of Suspicious Indicator(s)")]


tokens <- unnest_tokens(tbl = row_num_SI, output = word, 
              input = "Identification of Suspicious Indicator(s)")

tokens %<>% anti_join(y = stop_words, by = 'word') %>%
  group_by(row_num, word) %>%
  summarise(count = n()) %>% ungroup()

tokens

SMR_dtm <- tokens %>% cast_dtm(row_num, word, count)
dim(SMR_dtm)

as.matrix(SMR_dtm) %>% apply(MARGIN = 2, FUN = max)

train_i <- 1:900
x_train <- as.matrix(SMR_dtm[train_i,])
x_test <- as.matrix(SMR_dtm[-train_i, ])

library(keras)
model <- keras_model_sequential()
model %>%
  layer_dense(units = 10, activation = "tanh", input_shape = ncol(x_train), bias_initializer = "ones") %>%
  layer_dense(units = 5, activation = "tanh") %>%
  layer_dense(units = 10, activation = "tanh") %>%
  layer_dense(units = ncol(x_train))

summary(model)

model %>% compile(
  loss = "mean_squared_error", 
  optimizer = "adam"
)


checkpoint <- callback_model_checkpoint(
  filepath = "model.hdf5", 
  save_best_only = TRUE, 
  period = 1,
  verbose = 1
)

early_stopping <- callback_early_stopping(patience = 5)

model %>% fit(
  x = x_train, 
  y = x_train, 
  epochs = 300, 
  batch_size = 32,
  validation_data = list(x_test, x_test), 
  callbacks = list(checkpoint, early_stopping)
)

