# Basic Data Type --------
c("John", "Mary")
c(2, 3.1412)
c(TRUE, TRUE, F, T) # Can interchange between T and TRUE, F and FALSE
# using c() to collect your value
typeof(c("John", "Mary"))
typeof(list("John", 178, TRUE))

# Binding ----
personName = c("John", "Mary")
personName <- c("John", "Mary")

c("John", "Mary") -> personName

interestingNumber = c(2, 3.1412)
interestingNumber <- c(2, 3.1412)
covidPositive = c(TRUE, TRUE, F)


# name call to access value
personName
interestingNumber
covidPositive

personName

# Retrieve ONE element value ----
#  by position / index
personName[[1]]
personName[[2]]

list("John", 178, TRUE)
listExample = list("John", 178, TRUE)

listExample
listExample[[3]]

# Name your element values -----
## name: John, age: 38, height: 178, isMarried: False
recordExample1 = list("John", 38, 178, FALSE)
recordExample2 = list(
 "name"="John",
 "age"=38,
 "height"=178,
 "is married"=F
)
recordExample2 = list(
  name="John",
  age=38,
  height=178,
  "is married"=F
)
recordExample1[[1]]
recordExample2[[1]]
recordExample2$name
recordExample2[["name"]]
recordExample2$`is married`

# Retrieve multiple element values ----
##  by Position/Index ----
listExample
listExample[c(1,2)]

atomicExample <- c(1, 4, 78, 455, -23)
atomicExample
atomicExample[c(1,3,4)]
atomicExample[c(1,2,3,4)]
atomicExample[c(1:4)]
atomicExample[c(2:5)]
## by element names ----
recordExample2
recordExample2[c("name","height","is married")]

# nested list ----
person1 = list(
  "name"="John",
  "age"=38,
  "height"=178,
  "is married"=F
)
person2 = list(
  "name"="Mary",
  "age"=32,
  "height"=168,
  "is married"=T
)
collective_data = list(
  person1, # name call on person1
  person2 # name call on person2
)
collective_data = list(
  list(
    "name"="John",
    "age"=38,
    "height"=178,
    "is married"=F
  ),
  list(
    "name"="Mary",
    "age"=32,
    "height"=168,
    "is married"=T
  )
)
# Sequential Retrieval ------
## Retrieve the 2nd person's data and tell me his/her name
collective_data[[2]][["name"]]
collective_data[[2]]$name
## Retrieve the 2nd person's data and tell me his/her name and marriage status
collective_data[[2]][c("name", "is married")]

