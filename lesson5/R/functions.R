#Script with the function Lesson5

#Function to remove the clouds

cloud_rm <- function(x, y){
  x[y != 0] <- NA
  return(x)
}


#NDVI function

ndvical <- function(x,y) {
  ndvi <- (y-x)/(y+x)
  return(ndvi)
}