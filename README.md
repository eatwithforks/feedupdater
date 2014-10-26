FeedUpdater
===========

<b> Description </b>

Project to download the latest manga or an entire series.

<b> Features </b>

get_latest.rb

1. Polls http://eatmanga.com/latest/  
2. User sets list of interested manga in config.yml
3. If an entry matches in http://eatmanga.com/latest, then download chapter(s) and email a notification to the user.
4. If no entry matches, do nothing and do not send notification.
5. Do not re-download chapter if chapter exists in download directory. 

get_series.rb

1. Source is from http://eatmanga.com
2. To download a series, `ruby get_series.rb 'manga_name'` 
3. Do not re-download chapter if chapter exists in download directory.
4. Supports partial searching, for example:
```
ruby get_series.rb shigatsu

Output:
More than 1 result found, please enter a number:
1: Shigatsu No Hina
2: Shigatsu wa Kimi no Uso
2
"23 chapters found, downloading..."
"Shigatsu-wa-Kimi-no-Uso-001 is downloaded."
etc
```
<b> Usecase <b>

1. Set a cronjob to execute get_latest.rb on a hourly basis. (can be adjusted by user)
2. This will automatically find the latest manga and download to your local directory.
3. Thus, saving the time and effort to manually navigate to the website to check if a chapter has been released.

<b> Dependencies </b>

* ruby 1.9.3 or newer
* mechanize
* gmail (Not required if you don't want email notifications)

<b> Windows Instructions </b>

1. Install Ruby here: http://rubyinstaller.org/
2. Install Development Kit here: http://rubyinstaller.org/downloads/
3. Run `Bundle Install` in /feedupdater directory.
4. Edit config.yml save_dir to your desired save directory. 
5. Both scripts can be executed by `Ruby script_name.rb`

<b> Windows run get_latest.rb as hidden background task <b>

1. Create a powershell script
2. In the script, write `Invoke-Expression "ruby $env:C:\Users\JLee\Documents\feedupdater\get_latest.rb" `
3. Edit the Directory to your own
4. Save the script, I named it get_latest.ps1
5. Launch Windows Powershell
6. Enter `Set-ExecutionPolicy Unrestricted` 
7. Launch Task Scheduler
8. Create new task, follow the steps (fairly straightforward)
9. When you get to `Edit Action` 
10. In `Program/script`, put `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
11. In `Add arguments`, put `-NoProfile -Noninteractive -NoLogo -WindowStyle Hidden C:\Users\JLee\Documents\feedupdater\get_latest.ps1`
12. Edit the directory to your own
13. I set the task to run on a hourly basis. 

<b> Support </b>

The bug tracker is available here:

* https://github.com/eatwithforks/feedupdater/issues
