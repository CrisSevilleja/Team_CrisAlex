# Cristina Gonz?lez Sevilleja & Wan Quanxing
# 11/01/2017



#Function to know leap year

leapyear <- function(x){
  # Function to calculate leapyear
  # x (numeric) is the year you want to calculate
  if(!is.numeric(x)) { # x is not numeric
    stop("x must be of class numeric")} #stop and show a warning message
  else
    if (x <= 1581){ # x is out of the range of Gregorian calendar
      stop("Sorry, it's out of range. It should be in the gregorian calendar.")
    }else
      if (x %% 4 != 0) # x is not possible to divided by 4
        {return(FALSE)}
      else
        return(TRUE)
  }
