# NASAPod
A mobile app which display NASA’s Astronomy picture of the day from the NASA APOD API. It display picture according to selected date and stores all the data using Core Data.

Basic feature -
- Allow users to search for the picture for a date of their choice
- Allow users to create/manage a list of &quot;favorite&quot; listings
- Display date, explanation, Title and the image / video of the day
- App caches information and display last updated information in case of
network unavailability.
- Dark mode support
- App handles different screen sizes, orientations

NASA’s open APIs ( https://api.nasa.gov/ ) and in particular, the APOD (
Astronomy picture of the day ) resource.

## Screenshots

<h3 align="center">
<img width="200" src="screen3.png" alt="Screenshot of APOD for iOS" />
</h3>

<h3 align="center">
<img width="200" src="screen1.png" alt="Screenshot of APOD for iOS" />
</h3>

<h3 align="center">
<img width="200" src="screen2.png" alt="Screenshot of APOD for iOS" />
</h3>

## Third-party libraries
[SDWebImage](https://github.com/rs/SDWebImage) is used for downloading the picture of the day.
It is installed using Swift Package Manager

## Steps
1. Open .xcodeproj file in latest Xcode 
2. Select File -> Packages -> Update to latest package version 
3. Select simulator 
4. Run 
