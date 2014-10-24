FeedUpdater
===========

Project to fetch the latest manga automatically

Features: 

1. Polls http://eatmanga.com/latest/  
2. User sets list of interested manga in config.yml
3. If an entry matches in http://eatmanga.com/latest, then download chapter(s) and email a notification to the user.
4. If no entry matches, do nothing and do not send notification.
5. Does not re-download chapter if chapter exists in download directory. 

Usecase:

1. Set a cronjob to execute fetcher.rb on a hourly basis. (can be adjusted by user)
2. This will automatically find the latest manga and download to your local directory.
3. Thus, saving the time and effort to manually navigate to the website to check if a chapter has been released.

Feature to come: 

Mass fetch every chapter of specified manga.

Supported sites:
1. www.mangahere.com
2. www.kissmanga.com

