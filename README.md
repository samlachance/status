# Status

## About
Status is a program that allows you to monitor 911 calls from your terminal as they are dispatched in Hamilton County, T.N.

## How does it work?
Status uses [Hamilton County 911's public website](http://www.hc911.org/responses.php) to provide data about current 911 calls in your terminal. To put it simply, Status grabs each call that is listed on the site and then watches for changes. 

## Problems 
Because HC911's website refreshes every minute and the poll time on Status is one minute, it is possible to have up to a 59 second delay from realtime. This is generally not an issue because HC911 isn't particularly concerned with keeping things updated in realtime. There will be times that they add past calls to their log and backtime them appropriately. I suggest you don't change the refresh interval of the program. Polling the server once every, say, 10 seconds could result in an IP blacklist. 

No point in aiming for 100% accuracy when the source doesn't really care ;).

##Credits
While this project was my idea, it would be criminal if I didn't mention my Ruby mentor, [Don Humphreys](https://github.com/dhumphreys), for his significant help during refactoring.