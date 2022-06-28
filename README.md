# SpaceX Mission Launch and Rocket Info

This is a simple application displaying the list of SpaceX's mission launches plus some rocket information in each of the launches.


## Architecture / Design Pattern

We went with a modified MVVM (Model View View-Model) architecture to structure our project and give each of the component its own separate concerns. Model's only concern is how it represent the data coming from the server. View's only job is to display the information when needed and ViewModel's job is to mould this information and pass it onto the view by triggering an update (property observers).

We have a ViewModel manager class that takes control of the accesses and flow of data from the backend call, down to triggering the view to display.


## API

We are using the V4 version of this SpaceX [API](https://github.com/r-spacex/SpaceX-API). 

Although the data is not that big, at first I planned to have a pagination querying only 10 data per call then subsequently calling the api again to fetch another 10. But, apparently, this feature has been removed in V4. We need to have our authentication key setup and use when querying if we wanted to have this feature. 

Nevertheless, the fetching and loading of the launch list is relatively quick because of the amount of data being fetch.

## Screenshot


## License
Project is under the MIT License. Please see the [LICENSE](https://github.com/arvinq/TLCspaceX/blob/main/LICENSE) file for more information.

## Attribution
[Space icons](https://www.flaticon.com/free-icons/space) that I used for the app's icon is created by amonrat rungreangfangsai from Flaticon.
