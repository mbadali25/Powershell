##################################################################################################
### PowerShell Basics
###  02 - Conditional Statements
### 
### Author: Matthew Badali
### Date Written: 05/16/2021
### 
##################################################################################################

##################################################################################################
### Conditional Statemetns 
###
### The if statement contains the first test to evaluate, followed by the first statement list 
### enclosed inside the curly brackets {}.The PowerShell if statement is the only statement required
### to be present.
#$##
### The elseif statement is where you add conditions. You can add multiple ElseIf statements when you
### multiple conditions. PowerShell will evaluate each of these conditions sequentially.
###
### The else statement does not accept any condition. The statement list in this statement contains 
### the code to run if all the prior conditions tested are false.
### 
###  Conditional Statement are very important for determing logic and telling powershell what to 
###  do in certain situations
###
##################################################################################################

##Example
##
##########

### Settting Variable to a Number
$number = 10

### Setting Variable to a string (text)
$text = "Hellow World"

##################################################################################################
### Below are the primary variable types that are used in conditional statements
### - Boolean (True or False)
### - Integers (Numbers) 
### - string (text) 
###
### Each of these variables behave differently
### 
### Lets see some examples
### 
##################################################################################################

# Integers we can do Greater than -gt 

# If the number is greater than 10 do an actions
if ($number -gt 10) {
    '$number is greater than 10'
}

# Integers we can do Greater than or equal to -ge
# If the number is greater than or equal to 10 do an actions
if ($number -ge 10) {
    '$number is greater than or equal to 10'
}

# Integers we can do Less Than or equal to -lt
# If the number is greater than or equal to 10 do an actions
if ($number -lt 10) {
    '$number is less than 10'
}

# Integers we can do Less Than or equal to -le
# If the number is greater than or equal to 10 do an actions
if ($number -le 10) {
    '$number is less than or equal to 10'
}

# Both Integers and Text we can do equal to -eq
# If the number is greater than or equal to 10 do an actions
if ($number -eq 10) {
    '$number is equal to 10'
}

# String -eq
if ($text -eq "Hellow World") {
    '$text is equal to Hellow World'
}

# Moving on to strings there are a few functions that we can use.
# If $text -like  allows us to use use * as a wild cards
# Note: the wild cards can be used before or after or on both sides of the text.

if ($text -like "*ello*") {
    '$text is like ello'
}

# Strings can be counted with the length function
#Example
#If $text has less than 8 characters in it
if ($text.length -lt 8) {
    '$text has less than eight characters.'
}

## If , Else , and ElseIF Statemetns
## 
## The logic for a if and else statements are 
## if this criteria A is met perform actino a 
## else perform action b

## Example:
if ($numeber -gt 10) {
    "$numeber is greater than 10"
}
else {
    "$numeber is NOT greater than 10"
}

#### IF and Else if
## The logic for a if and else statements are 
## if this crtieria A is met perform actino a 
## elseif the criteria B perform action b/

## Example:
if ($numeber -gt 10) {
    "$numeber is greater than 10"
}
elseif ($number -lt 10) {
    "$numeber is less than 10"
}


###Interactive If, elseif and else statemetn
write-host "Interactive If, elseif and else statement`n`n"

While ($fruit -ne "X") {
    $fruit = Read-Host "Name that fruit"

    if ($fruit -eq 'Apple') {
        'I have an Apple'
    }
    elseif ($fruit -eq 'Banana') {
        'I have a Banana'
    }
    elseif ($fruit -eq 'Orange') {
        'I have an Orange'
    }
    else {
        'Sorry, that fruit is not in the list'
    }
}