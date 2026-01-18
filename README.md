**Overview**

This project is a simple iOS app that fetches data from a StackOverflow API to display a list of users. It has the ability to follow/unfollow users, but this is only locally simulated and persisted.

This app is written in UIKit using Swift in an MVVM-C architecure with some added unit tests. Asynchronous calls such as networking are using async/await where appropriate. Unit tests have also been included to validate business logic.


**How To Run**

1. Clone this project
2. Open PixelTechTest.xcodeproj with Xcode
3. Select your chosen development team (if required)
4. Select the PixelTechTest scheme
5. Select a run destination (simulator or physical device)
6. Run by clicking the play icon or using CMD + R


**Technical Decisions**

1. Data Persistence

A requirement for this project was that the follow state of a user is to be persisted across app sessions. I decided that using UserDefaults was adequate for this use case as it only involved keeping a simple list of followed user ID's. Introducing a more complex solution such as CoreData would have been unnecessary overhead for the scope of this project. 

2. Architecture

MVVM was the chosen architecture as it provides excellent seperation of concerns and testibility. 

Whilst this app was only a small 1 view project, I decided to still implement a coordinator pattern. As programatic UIKit does require a few lines of setup compared to Storyboards, it was only slightly more time to create a coordinator which allows the app to be easily expanded on if this is required. 

I decided to treat the profile image URL of the User model as optional- this should not cause a decoding error in case this field is missing from a user who has not set a profile image. 

