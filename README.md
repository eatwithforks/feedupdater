FeedUpdater
===========

<b> Description </b>

Project to download the latest manga or download an entire series.

<b> Features </b>

get_latest.rb

1. Polls http://eatmanga.com/latest/  
2. User sets list of interested manga in config.yml
3. If an entry matches in http://eatmanga.com/latest, then download chapter(s) and email a notification to the user.
4. If no entry matches, do nothing and do not send notification.
5. Do not re-download chapter if chapter exists in download directory. 

get_series.rb

1. Source is from http://eatmanga.com
2. Pass in the series link in the cli
3. Do not re-download chapter if chapter exists in download directory.

For example, 
```
ruby get_series.rb "http://eatmanga.com/Manga-Scan/Naruto/"
```

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

<b> Windows Instructions </b>

1. Install Ruby here: http://rubyinstaller.org/
2. Install Development Kit here: http://rubyinstaller.org/downloads/
3. Run 'Bundle Install' in /feedupdater directory.
4. Edit config.yml save_dir to your desired save directory. 
5. Both scripts can be executed by 'Ruby <script_name.rb>'

<b> Windows run get_latest.rb as hidden background task <b>

1. Create a powershell script
2. In the script, write `Invoke-Expression "ruby $env:C:\Users\JLee\Documents\feedupdater\get_latest.rb" `
3. Edit the Directory to your own
4. Save the script, I named it get_latest.ps1
5. Launch Task Scheduler
6. Create new task, follow the steps
7. Under 'Edit Action'
8. In the Program/script field, put this `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
9. In the Add arguments field, put this `-NoProfile -Noninteractive -NoLogo -WindowStyle Hidden C:\Users\JLee\Documents\feedupdater\get_latest.ps1`
10. Edit the directory to your own
11. I set the task to run on a hourly basis. 
