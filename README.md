FeedUpdater
===========

Project to fetch latest manga automatically

Features: 

1. Polling website http://eatmanga.com/latest/
2. User sets list of interested manga in config.rb.
3. If an entry matches in http://eatmanga.com/latest, then download chapter(s) and email a notification to the user.
4. If no entry matches, do nothing and do not send notification.
5. Does not re-download chapter if chapter exists in download directory. 

Usecase:

1. Set a cronjob to execute fetcher.rb on a hourly basis. (can be adjusted by user)
2. This will automatically find the latest manga and download to your local directory.
3. Thus, saving the time and effort to manually navigate to the website to check if a chapter has been released.

Roadmap:

Problem 1: Figure out an algorithm to pull from multiple sources.

Approach:

	1. On page 1, Figure out total number of pages in the chapter. (Unless possible, can loop until 404 then break)
	2. Page 1 of each chapter contains a link to the next page. (This is always true)
	3. Collect all the links in the page.
	4. Figure out a way to filter the link to the next page. (This is tricky, maybe can trigger if link contains Manga name?)
	5. Based off the pattern of the url, ie. (/page-2, /2, /page2), the next url must be crafted in the same manner.
	6. Now we have a list of the image urls, use the same logic to loop and GET request to save each.

Problem 2: Different sites have different names for chapter names

Approach: 

	1. The [-2] element contains the chapter number. (This is always true)
	2. Currently, I craft the folder name from the [-2] element. This means that duplicate chapters will be downloaded because different sites have different [-2] naming schemes.
	3. Craft a regex that matches on equal Manga name + the chapter number. (Must ignore cruft and only focus on Manga name and chapter number) (This will be difficult).
	4. If the chapter name regex matches, skip download on the subsequent entries. (To avoid downloading duplicate chapters)
