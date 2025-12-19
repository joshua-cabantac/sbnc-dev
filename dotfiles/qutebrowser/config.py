config.load_autoconfig()

# Set default search engine
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "sp": "https://www.startpage.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
}
