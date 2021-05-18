##################################################################################################
### PowerShell Basics
### Item: How to use variables guide 1
### 
### Author: Matthew Badali
### Date Written: 05/16/2021
### 
##################################################################################################

##################################################################################################
### Define variables
###
### Varialbes are defined by doing 
### the folowing:
### $variablename=somevalue
###
### For integers (numbers)
### Below set the variable to equal 1
### $variablename=1
###
### For strings (text)
### Below set the variable to equal 
### "Hello World"
### $variablename="Hello Word"
###
### Note: String must be enclosed in either single quotes '  or double qoutes ".
### 
### Later sections will go over what the differences are
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
### Writing output of variables
###
### This can be done multiple ways either call the variable name
### $variablename
###
### Shell Output: variable value
###
### or using the write-host command
###
### write-host $variable name
###
### Adding text with write-host
### write-host 'This is the output for the $numbervariable=' $numbervariable
###
### In write-host single quotes or double quotes will change the output
###
### write-host "This is the output for the $numbervariable=" $numbervariable
###
### Single quotes will treat everything as text.
### Double Quotes will output the variable
### Best Practices with double quotes is to escape the quotes so the variable output is unaffected
###
### Exmaple:
### write-host "This is the output for the $('numbervariable') $($numbervariable))"
###
### Note: The $() allows the expression to be evauluated outside of double quotes
##################################################################################################

##Example just using variable name

#Showing the value of the $number variable
$number

#Showing the value of the $text variable
$text

##Example just using the write-host command

#Showing the value of the $number variable
$number

#Showing the value of the $text variable
$text

### Example using write host

#Using write-host with single quotes
write-host 'This is the output for the with double quotes $number=' $number
write-host 'This is the output for the with double quotes $text=' $text

#Using write-host with double quotes
write-host "This is the output for the with double quotes $number=" $number
write-host 'This is the output for the with double quotes $text=' $text

#Using write-host with double quotes with best practices
write-host "This is the output for the with double quotes $('$number')= $($number)"
write-host "This is the output for the with double quotes $('$text')= $($text)"
