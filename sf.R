library(tidyverse)
library(stringr)

#14.2.1 String basics
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'


double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"", "\\")

writeLines(x)

x <- "\u00b5"

c("one", "two", "three")

#14.2.1 String length
str_length(c("a", "R for data science", NA))

#14.2.2 Combining strings

str_c("x", "y")
str_c("x", "y", "z")

str_c("x", "y", sep = ", ")

x <- c("abc", NA)
str_c("|-", x, "-|")

str_c("|-", str_replace_na(x), "-|")

str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- TRUE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

str_c(c("x", "y", "z"), collapse = ", ")

#14.2.3 Subsetting strings

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

str_sub(x, -3, -1)

str_sub("a", 1, 5)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))

x

#14.2.4 Locales

str_to_upper(c("i", "ı"))

str_to_upper(c("i", "ı"), locale = "tr") #turkey

#The locale is specified as a ISO 639 language code

x <- c("apple", "eggplant", "banana")

str_sort(x, locale = "en")  # English

str_sort(x, locale = "haw") # Hawaiian

#14.3.1 Basic matches

x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

# To create the regular expression, we need \\
dot <- "\\."

# But the expression itself only contains one:
writeLines(dot)
#> \.

# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)
#> a\b

str_view(x, "\\\\")

#14.3.2 Anchors

x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")

str_view(x, "^apple$")

str_view(c("abc", "a.c", "a*c", "a c","cab","bac"), "^a|^c|c$")

str_view(c("grey", "gray"), "gr(e|a)y")

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, 'C[LX]+')

str_view(x, 'C{2,3}?')

str_view(fruit, "(.)\1\1", match = TRUE)

str_view(fruit, "(..)\\1", match = TRUE)#"(.)(.)\\1\\2"

str_view(fruit, "(.)(.)\\2\\1", match = TRUE)#回文

str_view(fruit, "(.).\\1.\\1", match = TRUE)

str_view(fruit, "(.)(.)(.).*\\3\\2\\1", match = TRUE)

str_view(c("1231","1111","2121","1112","2343","2233","4442","1212",
           "aaaa","abab","abcabc","1111aaaa","121212"), "(..)\\1", match = TRUE)
#

  str_view(c("A128596789"), "^[A-Z]{1}[1-2]{1}[0-9]{8}$", match = TRUE)  
  
  str_view(c("123456789"), "", match = TRUE)  
  