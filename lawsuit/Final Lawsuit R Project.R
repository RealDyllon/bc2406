
# Title: Lawsuit 04 Group 02

setwd("/")

library(data.table)
lawsuit.dt <- fread('Lawsuit.csv')

# Headers for Lawsuit.csv 
# 1 Dept 1=Biochemistry/Molecular Biology, 2=Physiology, 3=Genetics, 4=Pediatrics, 5=Medicine, 6=Surgery
# 2 Gender 1=Male, 0=Female
# 3 Clin 1=Primarily clinical emphasis, 0=Primarily research emphasis
# 4 Cert 1=Board certified, 0=not certified
# 5 Prate Publication rate (# publications on cv)/(# years between CV date and MD date)
# 6 Exper # years since obtaining MD
# 7 Rank 1=Assistant, 2=Associate, 3=Full professor (a proxy for productivity)
# 8 Sal94 Salary in academic year 1994
# 9 Sal95 Salary after increment to 1994

# Identify variable type for each column 
class(lawsuit.dt$ID) # [1] "integer"
class(lawsuit.dt$Dept)# [1] "integer"
class(lawsuit.dt$Gender) # [1] "integer"
class(lawsuit.dt$Clin)# [1] "integer"
class(lawsuit.dt$Cert)# [1] "integer"
class(lawsuit.dt$Prate)# [1] "integer"
class(lawsuit.dt$Exper)# [1] "integer"
class(lawsuit.dt$Sal94)# [1] "integer"
class(lawsuit.dt$Sal95)# [1] "integer"
class(lawsuit.dt$Rank)# [1] "integer"

# Now given that Dept, Gender, Clin, Cert and Rank are not meaning as numerical, we will be converting them to categorical data. 
lawsuit.dt$Dept <- factor(lawsuit.dt$Dept)
lawsuit.dt$Gender <- factor(lawsuit.dt$Gender)
lawsuit.dt$Clin <- factor(lawsuit.dt$Clin)
lawsuit.dt$Cert <- factor(lawsuit.dt$Cert)
lawsuit.dt$Rank <- factor(lawsuit.dt$Rank)

class(lawsuit.dt$Dept)# [1] "factor"
class(lawsuit.dt$Gender) # [1] "factor"
class(lawsuit.dt$Clin) # [1] "factor"
class(lawsuit.dt$Cert) # [1] "factor"
class(lawsuit.dt$Rank )# [1] "factor"

# Line 45 - 121 ----------------------------------------------------------------
# Qn1. Are male professors paid more than female professors? 
salary_overview <- lawsuit.dt[, .(salary_before_adjustment = mean(Sal94),salary_after_adjustment = mean(Sal95)), 
                              by = .(Gender)] 
# Comparing both Gender and both year (94 and 95) mean professor salary

"salary_overview
Gender (1: Male, 0: Female)
Before Adjustment; (1) 177338.8, (0)  118871.3
After Adjustment; (1) 194914.1, (0) 130876.9 "

"
Analysis 
1. Gender Disparity in Salaries (Before Adjustment):
On average, the male professors (Gender 1) earned approximately $177,338.80 in the year 1994 (Sal94), which is notably higher than the average salary of female professors in the same year.
The female professors (Gender 0), on the other hand, had an average salary of approximately $118,871.30 in 1994. This suggests a gender pay gap before any adjustments.

2. Impact of Adjustment on Salaries:
After the adjustment in the year 1995 (Sal95), both male and female professors saw an increase in their average salaries.
Male professors, on average, received an increase in salary from approximately $177,338.80 (in 1994) to approximately $194,914.10 (in 1995).
Female professors, on average, received an increase in salary from approximately $118,871.30 (in 1994) to approximately $130,876.90 (in 1995).

3. Gender Pay Gap Reduction (After Adjustment):
While there is still a salary disparity between male and female professors, the gap has reduced after the adjustment. In 1994, the gender pay gap was more significant than in 1995.

  3A. For Male Professors (Gender 1):
  Percentage Change in Salary for Male Professors:
  Old Value (Sal94 for Male Professors) = $177,338.80
  New Value (Sal95 for Male Professors) = $194,914.10
  Percentage Change = [($194,914.10 - $177,338.80) / $177,338.80] * 100 ≈ 9.90%

  3B. For Female Professors (Gender 0):
  Percentage Change in Salary for Female Professors:
  Old Value (Sal94 for Female Professors) = $118,871.30
  New Value (Sal95 for Female Professors) = $130,876.90
  Percentage Change = [($130,876.90 - $118,871.30) / $118,871.30] * 100 ≈ 10.11%

So, after adjusting for percentage change, we can see that both male and female professors experienced an approximate 9.90% to 10.11% increase in their salaries from 1994 (Sal94) to 1995 (Sal95).

This reduction in the gender pay gap after adjustment suggests that factors other than gender, such as performance, experience, or other adjustments, may have influenced the salary changes between 1994 and 1995.
In summary, the table suggests that there was a gender pay gap in the college's salaries in 1994, with male professors earning more on average than female professors. 
However, after the adjustment in 1995, both genders received salary increases, and the gender pay gap reduced, indicating that factors other than gender may have contributed to the salary differences between the two years. 
Further analysis is needed to understand the specific factors and adjustments that influenced these salary changes.
"

# 1. Visualisation for the Above
library(ggplot2)

# Create the ggplot object and customize the plot
x <- ggplot(data = salary_overview, aes(Gender, salary_before_adjustment, fill = Gender)) +
  geom_col(position = "dodge") +  # Use dodge position to separate bars by gender
  labs(title = "Average Salary Before Adjustment by Gender") +
  xlab("Gender") +
  ylab("Average Salary") +
  scale_fill_manual(values = c("blue", "red")) +  # Customize fill colors
  theme_minimal() +  # Use a minimal theme
  theme(plot.title = element_text(hjust = 0.5),  # Center the title
        legend.position = "none")  # Remove the legend

# Display the plot
print(x)

# Create the ggplot object and customize the plot
y <- ggplot(data = salary_overview, aes(Gender, salary_after_adjustment, fill = Gender)) +
  geom_col(position = "dodge") +  # Use dodge position to separate bars by gender
  labs(title = "Average Salary After Adjustment by Gender") +
  xlab("Gender") +
  ylab("Average Salary") +
  scale_fill_manual(values = c("blue", "red")) +  # Customize fill colors
  theme_minimal() +  # Use a minimal theme
  theme(plot.title = element_text(hjust = 0.5),  # Center the title
        legend.position = "none")  # Remove the legend

# Display the plot
print(y)

# Set scipen option
options(scipen = 999) # Less everything become e. 

# Create a boxplot for salary before and after adjustment by gender
boxplot_data <- melt(lawsuit.dt, id.vars = c("Gender"), measure.vars = c("Sal94", "Sal95"))

# Create the ggplot object and customize the plot
boxplot_plot <- ggplot(data = boxplot_data, aes(x = Gender, y = value, fill = as.factor(variable))) +
  geom_boxplot() +
  labs(title = "Salary Distribution Before and After Adjustment by Gender",
       x = "Gender",
       y = "Salary") +
  scale_fill_manual(values = c("Sal94" = "blue", "Sal95" = "red")) +  # Custom colors
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),  # Center the title
        legend.title = element_blank(),           # Remove legend title
        legend.position = "bottom")              # Move legend to the bottom

# Display the plot
print(boxplot_plot)
# ------------------------------------------------------------------------------

# Line (143 - 219) --------------------------------------------------------------
# Qn 2. How do salary in 94 and 95 vary base off experience? 
# Load the necessary library
library(ggplot2)
library(gridExtra)

# Scatterplot for Sal94
p1 <- ggplot(lawsuit.dt, aes(x = Exper, y = Sal94)) +
  geom_jitter(aes(color = Gender), alpha = 0.6, size = 3) +
  labs(title = "Scatterplot of Salaries in 1994 by Experience",
       x = "Years of Experience",
       y = "Salaries in 1994") +
  theme_minimal() +
  theme(legend.position = "top")

# Scatterplot for Sal95
p2 <- ggplot(lawsuit.dt, aes(x = Exper, y = Sal95)) +
  geom_jitter(aes(color = Gender), alpha = 0.6, size = 3) +
  labs(title = "Scatterplot of Salaries in 1995 by Experience",
       x = "Years of Experience",
       y = "Salaries in 1995") +
  theme_minimal() +
  theme(legend.position = "top")

# Arrange the plots side by side
grid.arrange(p1, p2, ncol = 2)

# Base of the scatterplots, given that male professors have more years of years experience, which may results in them earning higher salaries!

cor(lawsuit.dt$Exper,lawsuit.dt$Sal94) # [1] 0.3198043
cor(lawsuit.dt$Exper,lawsuit.dt$Sal95) # [1] 0.3189344
"These correlation coefficients indicate a positive but relatively weak linear relationship between years of experience and salaries in both 1994 and 1995. 
The correlations are positive, meaning that as years of experience increase, salaries tend to increase slightly. However, the correlations are relatively close to zero, which suggests that the linear relationship is not very strong. 
In other words, years of experience alone may not be a strong predictor of salary changes in this dataset."

library(ggplot2)

# Create the scatter plot with regression line
scatter_plot <- ggplot(data = lawsuit.dt, aes(x = Exper, y = Sal94)) +
  geom_point(color = "blue", alpha = 0.5) +  # Customize point aesthetics
  geom_smooth(method = "lm", se = TRUE, color = "red") +  # Add regression line
  labs(
    title = "Relationship between Years of Experience and Salary (1994)",
    x = "Years of Experience",
    y = "Salary before Adjustment",
    caption = "Correlation coefficient (R) = 0.32, p < 0.05"
  ) +
  theme_minimal()  # Use a minimal theme for cleaner appearance

# Print the plot
print(scatter_plot)

" There is a statistically significant moderate positive linear relationship 
(R = 0.32, p < 0.05) between years of experience and salaries in 1994 among 
all the professors in your dataset.This indicates that as years of experience 
increase, salaries tend to increase, and this relationship is unlikely to be 
due to random chance.
"

ggscatter(lawsuit.dt[Gender == 1], x = "Exper", y = "Sal94", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Years of Experience", ylab = "Salary before Adjustment")

ggscatter(lawsuit.dt[Gender == 0], x = "Exper", y = "Sal94", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Years of Experience", ylab = "Salary before Adjustment")

"
Analysis 
In summary, both genders (Gender 1 and Gender 0) exhibit weak positive relationships between years of experience and salary before adjustment. 
However, the strength of the relationship and its statistical significance vary between the two genders. 
For Gender 1, the relationship is statistically significant but still weak, while for Gender 0, 
the relationship is not statistically significant within the given dataset.
"
# ------------------------------------------------------------------------------

# (Line 221 - 281 ) ------------------------------------------------------------
# Qn 3. How certification affect salary? 
library(ggplot2)

# Create the plot
p <- ggplot(lawsuit.dt, aes(x = factor(Cert), y = Sal94, fill = factor(Cert))) +
  geom_boxplot() +
  labs(
    title = "Relationship between Certification and Salary",
    caption = "0: Not Certified, 1: Board Certified",
    x = "Certification Status",
    y = "Salary before Adjustment"
  ) +
  scale_fill_manual(
    values = c("#FF6F61", "#6FB8FF"),  # Define custom fill colors
    labels = c("Not Certified", "Board Certified")
  ) +
  theme_minimal() +  # Use a minimal theme
  theme(legend.position = "bottom")  # Position the legend at the bottom

# Display the plot
print(p)

" Analysis
For Gender 1, having board certification (Cert = 1) is associated with 
substantially higher average salaries both before and after adjustment compared 
to not being certified (Cert = 0). 
This could indicate that board certification has a significant impact on salary for this gender group.

For Gender 0, similar to Gender 1, having board certification (Cert = 1) is 
associated with higher average salaries both before and after adjustment 
compared to not being certified (Cert = 0). 
However, the difference in average salaries is not as pronounced as in Gender 1."

library(ggplot2)

# Create a summary data frame with percentages
cert_gender_summary <- lawsuit.dt[, .(Count = .N), by = .(Cert, Gender)]
cert_gender_summary <- cert_gender_summary[, Percentage := Count / sum(Count) * 100, by = Cert]

# Define custom colors
custom_colors <- c("#FF6F61", "#6FB8FF")

# Create the plot
ggplot(cert_gender_summary, aes(x = factor(Cert, labels = c("Not certified", "Board certified")), y = Percentage, fill = Gender)) +
  geom_bar(stat = "identity", position = "fill") +
  geom_text(aes(label = sprintf("%.1f%%", Percentage)), position = position_fill(vjust = 0.5), size = 3) +
  scale_fill_manual(values = custom_colors, labels = c("0: Female", "1: Male")) +
  labs(
    title = "Distribution of Certification Status by Gender",
    x = "Certification Status",
    y = "Percentage",
    fill = "Gender"
  )

"
Analysis 
Given male professors have higher board certification than female and femal professor
having more not cerified may thus, explain the disparity between the pay gap. 
"
# ------------------------------------------------------------------------------

# (Line 283 - 324 )-------------------------------------------------------------
# Qn 4. Does being a research or clinical emphasis affects the pay? 
library(ggplot2)

# Create a more informative title
title <- "Salary Distribution by Clinical Emphasis and Gender"

custom_colors <- c("#FF6F61", "#6FB8FF")

# Create a boxplot with improved aesthetics
ggplot(lawsuit.dt, aes(x = factor(Clin), y = Sal94, fill = Gender)) +
  geom_boxplot() +
  labs(
    x = "Clinical Emphasis",
    y = "Salary",
    title = title,
    fill = "Gender"
  ) +
  scale_x_discrete(labels = c("No", "Yes")) +  # Improve x-axis labels
  theme_minimal() +  # Apply a minimalistic theme
  theme(legend.title = element_blank())  # Remove legend title

library(ggplot2)

# Create a bar plot to compare gender counts by clinical emphasis
ggplot(lawsuit.dt, aes(x = factor(Clin), fill = factor(Gender))) +
  geom_bar(position = "fill") +
  labs(
    x = "Clinical Emphasis",
    y = "Proportion",
    title = "Gender Distribution by Clinical Emphasis"
  ) +
  scale_x_discrete(labels = c("No", "Yes")) +  # Improve x-axis labels
  scale_fill_discrete(labels = c("Female", "Male")) +  # Improve legend labels
  theme_minimal()  # Apply a minimalistic theme

"
Analysis
Given that more male professors are in clinical emphasis than female, thus
resulting in higher pay. 
"

# ------------------------------------------------------------------------------

# Create the scatter plot with regression line
scatter_plot <- ggplot(data = lawsuit.dt, aes(x = Prate, y = Sal94, fill = Gender)) + # aes(x = Exper, fill = Gender)
  geom_point(color = "blue", alpha = 0.5) +  # Customize point aesthetics
  geom_smooth(method = "lm", se = TRUE, color = "red") +  # Add regression line
  labs(
    title = "Salary Distribution by Publication",
    x = "Pub rate",
    y = "Salary before Adjustment",
    # caption = "Correlation coefficient (R) = 0.32, p < 0.05"
  ) +
  theme_minimal()  # Use a minimal theme for cleaner appearance

# Print the plot
print(scatter_plot)


# ------------------------------------------------------------------------------




# ------------------------------------------------------------------------------

# (Line 326 - 406 )-------------------------------------------------------------
# Question 5. How does experience (the # of year after attending MD) affect each gender pay? 
ggplot(data = lawsuit.dt, aes(x = Exper, fill = Gender)) +
  geom_bar() +
  labs(
    title = "Distribution of Years of Medical Experience by Gender",
    x = "Years since Obtaining MD",
    y = "Count"
  )

# Cannot use cor given both var are categorical. 

ggplot(data = lawsuit.dt, aes(x = Gender, y = Exper, fill = Gender)) +
  geom_boxplot() +
  labs(
    title = "Distribution of Years of Medical Experience by Gender",
    x = "Gender",
    y = "Years since Obtaining MD"
  )

# Male have more professors who have more years of experience 


# Calculate the correlation between Exper and Sal94
correlation <- cor(lawsuit.dt$Exper, lawsuit.dt$Sal94)
print(correlation)

" The correlation coefficient between Exper and Sal94 is approximately 0.3198, which suggests a positive but moderately weak linear relationship between years of experience (Exper) and salary before adjustment (Sal94).
"

library(ggplot2)

ggplot(data = lawsuit.dt, aes(x = Exper, y = Sal94, color = Gender)) +
  geom_point() +
  labs(
    title = "Relationship between Experience, Gender, and Salary (Sal94)",
    x = "Years of Experience",
    y = "Salary before Adjustment",
    color = "Gender"
  )

library(dplyr)  # Add this line to import the dplyr library

# Calculate the percentage of each gender group within each department
department_gender_counts <- lawsuit.dt %>%
  group_by(Dept, Gender) %>%
  summarise(Count = n()) %>%
  mutate(Percentage = (Count / sum(Count)) * 100)

# Create the ggplot object
exp <- ggplot(data = department_gender_counts, aes(x = as.factor(Dept), y = Percentage, fill = Gender)) +
  
  # Define the bar chart layer
  geom_bar(stat = "identity") +
  
  # Add labels and facets
  labs(
    title = "Gender Distribution across Departments",
    x = "Department",
    y = "Percentage",
    fill = "Gender"
  ) +
  
  # Customize the color palette
  scale_fill_manual(values = custom_colors) +
  
  # Add percentage labels above the bars
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), vjust = -0.5) +
  
  # Rotate x-axis labels for better readability
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  
  # Adjust the plot size for better aesthetics
  theme(legend.position = "top", plot.margin = unit(c(1, 1, 1, 1), "cm")) +
  
  # Add facet grid
  facet_grid(. ~ Gender)

# Display or save the plot
print(exp)
# --------------------------------------------------------------------------------

# (Line 408 - 489 )-------------------------------------------------------------

# Does Department play a part in Salary? 

# Load necessary libraries
library(dplyr)

# Create an empty list to store correlation results
correlations <- list()

# Iterate over unique departments
unique_depts <- unique(lawsuit.dt$Dept)

for (dept in unique_depts) {
  # Subset the data for the current department
  dept_data <- subset(lawsuit.dt, Dept == dept)
  
  # Calculate the correlation between Sal94 and other variables for the current department
  correlation <- cor(dept_data$Sal94, dept_data$Exper)  # Change Exper to the desired variable
  
  # Store the correlation result in the list
  correlations[[dept]] <- correlation
}

# Print the correlations for each department
for (i in 1:length(correlations)) {
  cat("Department:", unique_depts[i], "Correlation:", correlations[[i]], "\n")
}

"
Analysis 
Department: 1 Correlation: 0.6820622 
Department: 2 Correlation: 0.8150702 
Department: 3 Correlation: 0.6523381 
Department: 4 Correlation: 0.6498367 
Department: 5 Correlation: 0.7260775 
Department: 6 Correlation: 0.7580306 

Strong Positive Correlations: Departments 2 (Physiology), 5 (Medicine), and 6 (Surgery) show strong positive correlations between years of experience (Exper) and salary (Sal94). This suggests that in these departments, as individuals gain more years of experience, their salaries tend to increase significantly.

Moderate Positive Correlations: Departments 1 (Biochemistry/Molecular Biology), 3 (Genetics), and 4 (Pediatrics) also exhibit positive correlations between experience and salary. While the correlations are not as strong as in the above departments, they still indicate that experience has a moderate positive effect on salary.

Overall Trend: Across all departments, there is a positive correlation between experience and salary, which is expected. Employees with more experience generally earn higher salaries.

Variability: The strength of the correlation varies by department, suggesting that the relationship between experience and salary may be influenced by other department-specific factors.
"

# Load necessary libraries
library(ggplot2)

# Create a boxplot to visualize the distribution of Sal94 by department and gender
ggplot(lawsuit.dt, aes(x = Dept, y = Sal94, fill = Gender)) +
  geom_boxplot() +
  labs(
    title = "Distribution of Salary Before Adjustment by Department and Gender",
    x = "Department",
    y = "Salary Before Adjustment"
  ) +
  scale_fill_discrete(labels = c("Female", "Male")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

library(ggplot2)

# Calculate the percentage of each gender group within each department
department_gender_counts <- lawsuit.dt %>%
  group_by(Dept, Gender) %>%
  summarize(Count = n()) %>%
  mutate(Percentage = (Count / sum(Count)) * 100)

# Create a stacked bar chart with percentage labels
ggplot(department_gender_counts, aes(x = Dept, y = Percentage, fill = as.factor(Gender))) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(Percentage), "%")), position = position_stack(vjust = 0.5)) +  # Add percentage labels
  labs(
    title = "Percentage of Gender by Department",
    x = "Department",
    y = "Percentage",
    fill = "Gender"
  ) +
  scale_fill_discrete(labels = c("Female", "Male")) +
  theme_minimal()
#--------------------------------------------------------------------------------

## Extra : Zoom in on medicine department 
# Filter the data for the "Medicine" department and years of experience less than or equal to 10
exp.dt <- lawsuit.dt[Dept == 5 & Exper <= 10]

# Create a bar plot to show the distribution of gender within the Medicine department
bar_plot <- ggplot(data = exp.dt, aes(x = Exper, fill = as.factor(Gender))) +
  geom_bar(position = "dodge") +
  scale_fill_discrete(labels = c("Female", "Male")) +
  labs(
    title = "Distribution of Gender within Medicine Department (Years of Experience <= 10)",
    x = "Years of Experience",
    y = "Count"
  )

# Display the bar plot
print(bar_plot)

# Create a scatter plot to visualize salary distribution by gender
scatter_plot <- ggplot(data = exp.dt, aes(x = Sal94, y = as.factor(Gender))) +
  geom_point() +
  labs(
    title = "Salary Distribution by Gender in Medicine Department (Years of Experience <= 10)",
    x = "Salary (Sal94)",
    y = "Gender"
  )

# Display the scatter plot
print(scatter_plot)

# Calculate the mean salaries for each gender in Sal94
mean_salaries <- exp.dt[, .(Mean_Salary_94 = mean(Sal94)), by = Gender]

# Create a column chart to show the mean salaries by gender
mean_salary_chart <- ggplot(data = mean_salaries, aes(x = Gender, y = Mean_Salary_94)) +
  geom_col() +
  labs(
    title = "Mean Salary (Sal94) by Gender in Medicine Department (Years of Experience <= 10)",
    x = "Gender",
    y = "Mean Salary"
  )

# Display the mean salary chart
print(mean_salary_chart)
# ------------------------------------------------------------------------------

# -----

# Create a list of departments you want to plot
departments_to_plot <- c(1, 2, 3, 4, 5, 6)

# Create a list to store the plots
per_dept_plots <- list()

# Create a scatterplot for each department and store it in the list
for (dept in departments_to_plot) {
  plot <- ggplot(subset(lawsuit.dt, Dept == dept), aes(x = Exper, y = Sal94)) +
    geom_jitter(aes(color = Gender), alpha = 0.6, size = 3) +
    labs(title = paste("Scatterplot of Salaries in 1994 by Experience for Dept", dept),
         x = "Years of Experience",
         y = "Salaries in 1994") +
    theme_minimal() +
    theme(legend.position = "top")
  
  per_dept_plots[[as.character(dept)]] <- plot
}

# Arrange the plots in a grid
grid.arrange(grobs = per_dept_plots, ncol = 3)  # Change ncol as needed

# --------
# make plotting easier with named gender
lawsuit.dt$Gender <- factor(lawsuit.dt$Gender, labels = c("Female", "Male"))
lawsuit.dt$SalDiff <- lawsuit.dt$Sal95 - lawsuit.dt$Sal94

filtered_data <- lawsuit.dt # [lawsuit.dt$Exper < 10, ]
# filtered_data <- filtered_data[filtered_data$Prate >= 0 & filtered_data$Prate < 6, ]
# filtered_data <- filtered_data[filtered_data$Dept == 1, ]

# Assuming university_data is your dataset

ggplot(filtered_data, aes(x = Dept, y = SalDiff, fill = Gender)) +
  geom_boxplot() +
  labs(title = "Salary increase from 1994 to 1995 by Department and Gender (0 <= Prate < 6)")

# ------------------------------------------------------------------------------



# Create a new variable 'PrateRange' representing the desired ranges
lawsuit.dt$Gender <- factor(lawsuit.dt$Gender, labels = c("Female", "Male"))
lawsuit.dt$SalDiff <- lawsuit.dt$Sal95 - lawsuit.dt$Sal94
filtered_data <- lawsuit.dt
filtered_data <- filtered_data[filtered_data$Exper < 10, ]
filtered_data$PrateRange <- cut(filtered_data$Prate, breaks = 0:9,
                                labels = c("0-1", "1-2", "2-3", "3-4", "4-5", "5-6", "6-7", "7-8", "8-9"),
                                drop = FALSE)

# Assuming university_data is your dataset
ggplot(filtered_data, aes(x = Cert, y = Sal95, fill = Gender)) +
  geom_boxplot() +
  labs(title = "Salary increase from 1994 to 1995 by Prate Range and Gender",
       x = "Prate Range") +
  scale_x_discrete(labels = c("0-1", "1-2", "2-3", "3-4", "4-5", "5-6", "6-7", "7-8", "8-9"))


# ------------------------------------------------------------------------------
# show the difference in years of experience (Exper)




# ggplot(lawsuit.dt, aes(x = Gender, y = Sal94, fill = Gender)) +
#   geom_violin() +
#   labs(
#     title = "Salary Differences by Gender",
#     x = "Gender",
#     y = "Salary"
#   ) +
#   theme_minimal()


#
# library(dplyr)
#
# lawsuit.dt %>%
#   group_by(Dept, Gender) %>%
#   summarize(
#     Mean_Salary = mean(Sal94),
#     SD_Salary = sd(Sal94)
#   ) %>%
#   ggplot(aes(x = Dept, y = Sal94, fill = Gender)) +
#   geom_bar(stat = "identity", position = "dodge") +
#   geom_errorbar(aes(ymin = Mean_Salary - SD_Salary, ymax = Mean_Salary + SD_Salary),
#                 position = position_dodge(width = 0.9), width = 0.25) +
#   labs(title = "Average Salary by Department and Gender")
#
#
#
#
# ggplot(lawsuit.dt, aes(x = Dept, y = Sal94, color = Gender)) +
#   geom_point() +
#   labs(title = "Salary by Department and Gender")



# models linreg

# Fit a multiple linear regression model
model <- lm(Sal95 ~ Rank + Prate + as.factor(Gender), data = lawsuit.dt)

# Check the summary of the regression model
summary(model)



# Fit a multiple linear regression model with Dept and Clin
model <- lm(Sal95 ~ Rank + Prate + as.factor(Gender) + Dept + Clin, data = lawsuit.dt)

# Check the summary of the regression model
summary(model)






# Fit an ANOVA model
model <- lm(Sal95 ~ Rank * as.factor(Gender), data = lawsuit.dt)

# Check the ANOVA table
anova(model)


# Compute Cohen's d for gender effect
library(effsize)
cohen.d(Sal95 ~ as.factor(Gender), data = lawsuit.dt)