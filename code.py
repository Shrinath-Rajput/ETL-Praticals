import requests
from bs4 import BeautifulSoup

# Mobile YouTube channel URL (HTML-based)
url = "https://m.youtube.com/@GoogleDevelopers/videos"

# Fetch HTML
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")

# -----------------------------------------
# STEP 1: Extract the main video container
# -----------------------------------------

# On the mobile site, videos are inside <div id="items"> or <div class="media-items">
video_container = soup.find("div", {"id": "items"})   # main block

# If not found, try alternative structure
if video_container is None:
    video_container = soup.find("div", {"class": "media-items"})

# Save the full HTML of the video section
video_html = str(video_container)

print("EXTRACTED VIDEO HTML BLOCK:\n")
print(video_html)

# -----------------------------------------
# STEP 2: Parse the extracted HTML block
# -----------------------------------------

sub_soup = BeautifulSoup(video_html, "html.parser")   # parse only the video section
video_links = []

for tag in sub_soup.find_all("a", href=True):
    if "/watch" in tag["href"]:
        full_link = "https://youtube.com" + tag["href"]
        video_links.append(full_link)

# -----------------------------------------
# Final Output
# -----------------------------------------
print("\nVIDEO LINKS FOUND:")
for link in video_links:
    print(link)