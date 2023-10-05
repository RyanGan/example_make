# ---------------------------------------------------------------
# Title: Analysis of lung data
# Author: Ryan Gan
# Date Created: 2023-10-04
# -------------------------------------------------------------

# loads configs and libraries in source
source('./R/00-config.R')

# load data
lung <- read.csv('./data/lung.csv')

# kaplan-meier of ecog status on lung
fit <- survfit(Surv(time, status) ~ ph.ecog, data=lung)

# save results to text file in result
log_file <- file('./results/02-lung_median_times.txt', open = 'wt')

# Redirect output to the log file
sink(log_file)


cat("Summary Statistics for Kaplan-Meier Survival Analysis:\n")
cat("---------------------------------------------------\n")
summary_output <- capture.output(fit)
cat(summary_output, sep = "\n")
cat("\n")



# Close the connection to the log file
sink()
close(log_file)



# Make plot and save to results
# Create a vector of colors for each ph.ecog status
colors <- c("blue", "red", "green", "purple")


# Create a PNG file for the plot
png('./results/02-survival_plot.png', width = 800, height = 600)  # Specify width and height as needed

# Create the Kaplan-Meier survival curve plot
plot(
    fit, 
    col = colors, 
    xlab = "Time", 
    ylab = "Survival Probability", 
    main = "Kaplan-Meier Survival Curve by ph.ecog"
    )
    
legend("topright", legend = levels(lung$ph.ecog), col = colors, lty = 1)

# Save the plot as a PNG file
dev.off()
