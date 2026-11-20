#!/usr/bin/env Rscript

# Demo R Script - Showing R capabilities

cat("=== R Demo Script ===\n\n")

# 1. Basic arithmetic and variables
cat("1. Basic Arithmetic:\n")
x <- 10
y <- 20
sum_result <- x + y
cat(sprintf("  %d + %d = %d\n\n", x, y, sum_result))

# 2. Vectors and operations
cat("2. Working with Vectors:\n")
numbers <- c(1, 5, 10, 15, 20, 25)
cat(sprintf("  Numbers: %s\n", paste(numbers, collapse=", ")))
cat(sprintf("  Mean: %.2f\n", mean(numbers)))
cat(sprintf("  Median: %.2f\n", median(numbers)))
cat(sprintf("  Std Dev: %.2f\n\n", sd(numbers)))

# 3. Data frame
cat("3. Creating a Data Frame:\n")
df <- data.frame(
  name = c("Alice", "Bob", "Charlie", "Diana"),
  age = c(25, 30, 28, 32),
  score = c(85, 92, 78, 95)
)
print(df)
cat("\n")

# 4. Simple statistics
cat("4. Statistics Summary:\n")
cat(sprintf("  Average age: %.1f\n", mean(df$age)))
cat(sprintf("  Average score: %.1f\n", mean(df$score)))
cat(sprintf("  Highest score: %d\n", max(df$score)))
cat(sprintf("  Lowest score: %d\n\n", min(df$score)))

# 5. Sequence and operations
cat("5. Generating Sequences:\n")
sequence <- seq(1, 20, by=2)
cat(sprintf("  Odd numbers 1-20: %s\n", paste(sequence, collapse=", ")))
cat(sprintf("  Sum: %d\n", sum(sequence)))
cat(sprintf("  Product: %d\n\n", prod(sequence)))

# 6. String manipulation
cat("6. String Operations:\n")
greeting <- "Welcome to R!"
cat(sprintf("  Message: %s\n", greeting))
cat(sprintf("  Length: %d characters\n", nchar(greeting)))
cat(sprintf("  Uppercase: %s\n\n", toupper(greeting)))

cat("=== Demo Complete! R is working perfectly. ===\n")
