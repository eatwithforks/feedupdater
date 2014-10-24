FeedUpdater
===========

<b> Description </b>

Project to download the latest manga and also download an entire series.

<b> Features </b>

get_latest.rb

1. Polls http://eatmanga.com/latest/  
2. User sets list of interested manga in config.yml
3. If an entry matches in http://eatmanga.com/latest, then download chapter(s) and email a notification to the user.
4. If no entry matches, do nothing and do not send notification.
5. Do not re-download chapter if chapter exists in download directory. 

get_all.rb

1. Source is from http://eatmanga.com
2. Pass in the series link in the cli
2. For example, ruby get_all.rb "http://eatmanga.com/Manga-Scan/Naruto/"
3. Do not re-download chapter if chapter exists in download directory.

<b> Usecase <b>

1. Set a cronjob to execute fetcher.rb on a hourly basis. (can be adjusted by user)
2. This will automatically find the latest manga and download to your local directory.
3. Thus, saving the time and effort to manually navigate to the website to check if a chapter has been released.

<b> Dependencies </b>

* ruby 1.9.3 or newer
* mechanize
* gmail

<b> Support </b>
The bug tracker is available here:

* https://github.com/eatwithforks/feedupdater/issues
