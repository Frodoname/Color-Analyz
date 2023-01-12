# Color-Analyz
A simple application that analyzes colors from camera



https://user-images.githubusercontent.com/104575755/212058532-6aec1986-dc8d-440c-8d6c-c7c11a58ecc4.mp4


### How does it work? 
The goal was to create an application wich have to analyze the colors phone's camera and show the top-5 frequent colors.
Because the lowest fps of the camera is 30, app can't analyze 30 photos each second (analysis algorithm is nˆ2 complexity), that's why analyzes the next shot only when the previous is completed (the application does not take the pictures missed during this time, but takes the last relevant one).
A Possible solution may be to make camera resolution lower.

The most frequent colors are showing in collection view, so when the app have just launced, it will show nothing. Also, if there are less than 5 colors, it will show less tham 5 colors. Colors are sorted from most common to least common.

***
Application is developed with:

* MVP Architecture
* UIKit
* Just native technologies, no external libraries
* 13+ IOS 
* Portret orientation
