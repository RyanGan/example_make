# ---------------------------------------------------------------
# Title: Details
# Author: Ryan Gan
# Date Created: 2023-10-04
# -------------------------------------------------------------

# Sources 00-config.R
source('./R/00-config.R')


# using survival lung data, writes lung data
write.csv(lung, file = './data/lung.csv')
