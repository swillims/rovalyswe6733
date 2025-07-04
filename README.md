# Rovaly-SWE6733
Project for SWE6733

## Group Name: White Clover
# Background:
Online dating is an enormous industry that grows each year. The findings of commissioned research concur with the periodic reports from top data aggregator firms of international repute. Reports reveal the revenue of top dating apps has almost doubled between 2017 and 2023. The number of online dating app users has also grown by nearly 80% in the past six years. As the audience for online dating has gotten bigger, the technology to meaningfully match different types of users has lagged behind. Oftentimes users, especially those looking for outdoor partners/adventurers to go explore a new place or activity, are matched using irrelevant metrics and statistics. Yes, users can use Bumble, OkCupid, or other apps, but they’re not adventure-specific, per se, to find like-minded partners for outdoor activities. As this has become commonplace, users find themselves matched with people who appear not to want the same thing, which may result in a lower-quality experience for all. That said, there is a shortage of creating a new outlet for finding adventure partners.
 
# Product Vision:
This team project aims to build an outdoor app (called Rovaly) for adventure seekers. Whether they're into hiking, kayaking, rock climbing, or just exploring new trails, the app matches them with like-minded adventurers who share their passion for the great outdoors. The app goes beyond basic metrics to ensure people find a partner who truly gets their love for adventure.
Our short term goal is that our team will deliver a working prototype of an outdoor adventure dating app that allows users to create profiles with activity preferences, browse and match with others based on shared interests and location, and validate the concept of niche, activity-based matchmaking through a basic interactive UI.
By the end of July, our long-term goal is to create a secure, adventure-focused dating app that intelligently matches users based on shared activity types, skill levels, and preferences—offering features like social media integration, profile customization, swipe-based matching, and in-app messaging. Future enhancements may include single sign-on (SSO), voice/video chat, and richer communication tools to foster real-world connections. 
Our primary stakeholders for this project is the adventure seekers (people seeking other adventurers), product owner (Vasanthal - the person who represents the user needs), the project team (the people working on developing the software in which they need clear requirements), and the instructor (Dr. Parizi - the one who evaluate the project execution and determines if the software meets the objective)

# Group Members:
- Christopher - Dev
- Kalil - Dev
- Michael - Scrum Master
- Sharon - UI Tester
- Spencer - Dev
- Vasanthal - Product Owner
- Yasmeen - Dev

# Tech Stack:
Flutter Web App Deployed with Firebase

# Online Project Management Tool
We are are using <a href="https://trello.com/b/vpFGW9uC/swe-6733">Trello</a>

# Definition of Readyness for Backlog Items
Each item has a ...
-  Title
-  First Sentence of a User Story
-  Desription
-  Story Point Estimation

# Backlog Item Ordering
Back log of items found at <a href="https://trello.com/b/vpFGW9uC/swe-6733">Trello</a>

## Must Haves
#### Account Creation
- User Story: As a potential user, I would like to start using the Rovaly App
- Description: Creates a database entity for the user. Password should be hashed but not a requirement.
- Story Point Estimation: 2
#### Login 
- User Story: As a registered user, I can access my account.
- Description: The project requires user verification. Each adventurer has it’s own entity tracked in a database.
- Story Point Estimation: 4 // 4 do to login token tracking
#### Upload/Edit User Info
- User Story: As an adventurer, I should be able to specify what kind of adventuring background I have.
- Description: The app needs a way for users to upload or change their adventuring information. That information needs to be tracked in a database. Some details that should be included “type of adventure, skill level, preferences, and attitude”
- Story Point Estimation:  3
#### Delete My Account
- User Story: As a user, I want to permanently delete my account so my data is not retained.
- Description: User has ability to delete their account. Deletion removes data from database. GDPR-compliance
- Story Point Estimation: 3
#### Swipes
- User Story: As a potential adventurer, I should be able to find other adventurers I haven’t met yet.
- Description: App has a matchmaking feature. Matches are tracked. If another person exists and doesn’t have a history of confirmation/deny, that person is new. New people appear as potential matches and matched(confirmed/deny) are tracked in some way.
- Story Point Estimation: 2
## Should Have
#### In-App Messaging
- User Story: As a user, I want to chat with my matches so I can coordinate adventures.
- Description: Users can chat with people they have matched with. Implement live messages via Firebase/Firestore or alternative. Text is acceptable. Video is bonus.
- Story Point Estimation: 3
#### Skill Based Matchmaking
- User Story: As an adventurer with preferences and skill levels, I would like my matches to reflect my skill level and preferred type of adventure who live in my area.
- Description: Add an algorithm to the swipes feature to match people based on their adventure types and skill level. Algorithm only includes people who are specified distance away
- Story Point Estimation: 5
#### Remove Matches
- User Story: As a person who does not want to interact with problem causing people, I should be able to remove people from my matches.
- Description: Users should be able to remove people from matches. Removed matches are changed from confirmed to denied.
- Story Point Estimation: 1
## Could Have
#### Upload Photo(s)
- User Story: As a user, I want to upload adventure photo(s) so I can showcase my experience(s).
- Description: Users can upload photos. “Users will be able to create& delete the profile and upload photos.” The location is unspecified. We can just have it posted on their profile.
- Story Point Estimation: 2
## Would Be Nice
#### Instagram Connection
- User Story: As a social media user, I should be able to connect my social media account(s) to the app.
- Description: The user should be able to connect their Instagram account and possibly other social media accounts to the app. “The app will allow users to connect their profiles to Instagram and other social media.” The high level feature just specifies connection - not functionality.
- Story Point Estimation: 1 // if we add functionality change to 5

# Backlog Item Ordering
We used the MoSCoW method to order backlog items and then they were further subsorted by:
- Technical dependencies
- Value to user
- Implementation complexity

# Forecast:
## Sprint 1 (June 29 - July 5)
Story Points: 6
We plan to get the Login and Account Creation done this week. These are the two most important things to set up for the Rovaly app, as they are the prerequisites for every other task that we have to do. After an account has been created, the user can use their information to log in if they log out. They should be able to access the settings, delete their account, upload/edit their information, use in-app messaging, skill-based matching, etc. Since we started this on Thursday, we have to forecast that we won't be able to complete that many stories, but by next week, we plan to get more done.


