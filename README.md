### Setup the project
1. Locate the current directory in terminal
2. Execute `pod install`
3. Execute `npm install -g mountebank`
4. Execute `mb --configfile imposters.ejs`
5. Open `WeChatMoments.xcworkspace` in the current directory
6. Run the project and make sure the app can start correctly

### App Introduction

The code is an iPhone app which looks like Wechat Moments page. 

We have some requirements during building this app, and you should also try to follow these requirements:

#### Product Requirements

- The assignment is to build an iPhone app which looks like Wechat Moments page.
- Wechat Moments is the ideal goal of the view layouts
- The view consists of profile image, avatar and tweets list
- For each tweet, there will be a sender, optional content, optional images and comments
- A tweet contains from 0 to 9 images, make sure the layout is aligning with Wechat Moments
- Load all tweets in memory at the first time and only show first 5 of them at the beginning and after refresh.
- Show 5 more while user pulling up the view at the bottom of the table view.
- Pulling down table view to refresh, only first 5 items are shown after refreshing
- Supports layout on all kinds of iOS device screen and orientation.
- This is a static page, no more actions(tapping, pulling, multi-touching) are required. Any extra interaction is welcome and will be seriously considered in a positive way. For any other unclear layout concerns, please reference current Wechat implementation.

#### Tech requirements:

- The data JSON will be hosted at localhost:2727
- An example of the response in `WeChatMomentsTests/Resources/Tweet.json` 
- Layout using storyboards or programmatically
- AutoLayout & Size Classes is appreciated.
- Unit tests are appreciated.
- Functional programming is appreciated
- Utilise Git for source control, for git log is the direct evidence of the development process
- Utilise GCD for multi-thread operation
- Only binary, framework or Cocopods dependency is allowed. do not copy other developer's source code(`*.h`, `*.m`, `*.swift`) into your project
- Keep your code clean as much as possible Production and Technical requirements are weighing equally in the final result.
