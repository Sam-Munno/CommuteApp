# Sam Munno Spot Hero Submission
Acceptance Criteria:
Please create a simple iOS project that....

* Somehow uses Dijkstra's algorithm
* Involves some use of a web service
* Supports iOS 12 and later
* Uses Swift 5 or later
* Runnable on Xcode 11.x (please no betas)

SEE GraphImage.png for visual of graph 

Solution:
I wrote an app that calls a weather service API to figure out what form of transportation(Biking, Train, or Driving) I should take to work. I used Dijkstra’s algorithm by mapping out different routes to my office(Image of graph attached in files). Depending on the current weather in Chicago(lat and long of my apartment) I dynamically weighed the biking option. The logic I put in is if it’s raining or under 4.0 Celsius I put a weight Multiplier on the biking option. Uncomment out line #97 in ViewController to park with SpotHero.
To use the app, run it and click the button on the ViewController. If the service call fails or the Dijkstra’s algorithm fails to find a route I have an image to display “no route found”
