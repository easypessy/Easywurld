        # We search deeper (40 results) to find the best personalities
        for r in ddgs.text(query, max_results=40):
            # Skip massive directories like Yelp or Facebook
            if not any(x in r['href'] for x in ['yelp.com', 'yellowpages.com', 'facebook.com']):
                
                snippet = r['body'].lower()
                contact_type = "LinkedIn/Profile"
                
                # Check if the snippet contains an email or WhatsApp number
                if "@" in snippet: contact_type = "Email Hinted"
                if "whatsapp" in snippet or "+" in snippet: contact_type = "WhatsApp/Phone Found"
                
                results.append({
                    'Person/Business': r['title'],
                    'Direct Link': r['href'],
                    'Contact Hint': r['body'][:180],
                    'Lead Quality': contact_type
                })
    
    if results:
        df = pd.DataFrame(results)
        # Unique filename so you don't lose yesterday's work
        filename = f"{industry.replace(' ', '_')}_{location.replace(' ', '_')}.csv"
        df.to_csv(filename, index=False)
        print(f"--- ✅ HUNT COMPLETE! ---")
        print(f"Found {len(df)} leads. Saved to: {filename}")
        print(f"To see them, type: cat {filename}")
    else:
        print("No specific leads found. Try a broader industry name.")

# RUNNING FOR LAW FIRMS
hunter_agent("Law Firm", "New York")
EOF

python hunter.py
pkg install tur-repo -y
pkg install python-pandas -y && pip install duckduckgo-search
pkg install tur-repo -y && pkg install python-pandas -y
pip install duckduckgo-search==6.2.13
~pip cache purge
pip install duckduckgo-search==3.8.5
pkg install python-lxml -y
cat <<EOF > hunter.py
import pandas as pd
from duckduckgo_search import DDGS

def find_outdated_leads(industry, location):
    print(f"\n--- 🕵️‍♂️ EASYWURLD: Hunting for OUTDATED sites in {location} ---")
    
    # We search for the industry + indicators of old/neglected sites
    # Keywords: "Copyright 2019..2022", "Under construction", "Not mobile friendly"
    query = f'{industry} {location} (Owner OR Partner) ("Copyright 2017" OR "Copyright 2018" OR "Copyright 2019" OR "Copyright 2020" OR "Copyright 2021" OR "Under Construction")'
    
    results = []
    with DDGS() as ddgs:
        # Looking at 40 results to find the "worst" websites
        search_results = ddgs.text(query, max_results=40)
        
        for r in search_results:
            snippet = r['body'].lower()
            url = r['href'].lower()
            
            # Filter out big tech/directories
            if not any(x in url for x in ['facebook.com', 'yelp.com', 'clutch.co', 'linkedin.com/company']):
                
                # Logic to determine WHY it is a "Bad/Outdated" site
                reason = "Unknown"
                if "copyright 20" in snippet: reason = "Old Copyright Year"
                if "construction" in snippet: reason = "Site Unfinished"
                if "not found" in snippet: reason = "Broken Links"
                
                results.append({
                    'Business/Owner': r['title'],
                    'Website': r['href'],
                    'Why it is Outdated': reason,
                    'Snippet': r['body'][:150]
                })

    if results:
        df = pd.DataFrame(results)
        filename = f"outdated_{industry.replace(' ', '_')}.csv"
        df.to_csv(filename, index=False)
        print(f"--- ✅ SUCCESS! ---")
        print(f"Found {len(df)} outdated or bad websites.")
        print(f"Check your file: {filename}")
    else:
        print("No outdated sites found with those specific markers. Try a broader city.")

# Set your target here
find_outdated_leads("Law Firm", "New York")
EOF

python hunter.py
pip install ddg3
cat <<EOF > hunter.py
import pandas as pd
from ddg3 import ddg

def find_outdated_leads(industry, location):
    print(f"\n--- 🕵️‍♂️ EASYWURLD: Hunting for OUTDATED sites in {location} ---")
    
    # Looking for industry + indicators of old/neglected sites
    query = f'{industry} {location} (Owner OR Partner) ("Copyright 2018" OR "Copyright 2019" OR "Copyright 2020" OR "Copyright 2021")'
    
    # ddg3 is much simpler and faster for Termux
    raw_results = ddg(query, max_results=25)
    
    results = []
    for r in raw_results:
        snippet = r['body'].lower()
        url = r['href'].lower()
        
        # Filter out the big directories that don't need web design
        if not any(x in url for x in ['facebook.com', 'yelp.com', 'clutch.co', 'linkedin.com/company']):
            
            # Logic to flag WHY the site is bad
            reason = "Old Copyright Year"
            if "construction" in snippet: reason = "Site Unfinished"
            if "201" in snippet or "2020" in snippet: reason = "Outdated Copyright"
            
            results.append({
                'Business/Owner': r['title'],
                'Website': r['href'],
                'Reason': reason,
                'Snippet': r['body'][:150]
            })

    if results:
        df = pd.DataFrame(results)
        filename = f"outdated_{industry.replace(' ', '_')}.csv"
        df.to_csv(filename, index=False)
        print(f"--- ✅ SUCCESS! ---")
        print(f"Found {len(df)} leads with outdated websites.")
        print(f"To see them: cat {filename}")
    else:
        print("No results. Try changing the city name.")

find_outdated_leads("Law Firm", "New York")
EOF

python hunter.py
cat <<EOF > hunter.py
import pandas as pd
from ddg3 import DDG3

def find_outdated_leads(industry, location):
    print(f"\n--- 🕵️‍♂️ EASYWURLD: Hunting for OUTDATED sites in {location} ---")
    
    # Query for industry + old copyright markers
    query = f'{industry} {location} (Owner OR Partner) ("Copyright 2018" OR "Copyright 2019" OR "Copyright 2020" OR "Copyright 2021")'
    
    # Initialize the new version of the tool
    ddg = DDG3()
    raw_results = ddg.text(query, max_results=25)
    
    results = []
    for r in raw_results:
        snippet = r.get('body', '').lower()
        url = r.get('href', '').lower()
        
        # Filter out directories
        if not any(x in url for x in ['facebook.com', 'yelp.com', 'clutch.co', 'linkedin.com/company']):
            
            # Flagging the 'Bad' website reason
            reason = "Old Copyright Year"
            if "construction" in snippet: reason = "Site Unfinished"
            
            results.append({
                'Business/Owner': r.get('title'),
                'Website': r.get('href'),
                'Reason': reason,
                'Snippet': snippet[:150]
            })

    if results:
        df = pd.DataFrame(results)
        filename = f"outdated_{industry.replace(' ', '_')}.csv"
        df.to_csv(filename, index=False)
        print(f"--- ✅ SUCCESS! ---")
        print(f"Found {len(df)} leads with outdated websites.")
        print(f"To see them, type: cat {filename}")
    else:
        print("No results found. Try a different city or a broader industry name.")

find_outdated_leads("Law Firm", "New York")
EOF

pip install -U duckpy
cat <<EOF > hunter.py
import pandas as pd
from duckpy import Client

def find_outdated_leads(industry, location):
    print(f"\n--- 🕵️‍♂️ EASYWURLD: Hunting for OUTDATED sites in {location} ---")
    
    # Target query: Industry + City + Old Copyright footprints
    query = f'{industry} {location} (Owner OR Partner) ("Copyright 2018" OR "Copyright 2019" OR "Copyright 2020" OR "Copyright 2021")'
    
    client = Client()
    raw_results = client.search(query)
    
    results = []
    for r in raw_results:
        snippet = r.description.lower()
        url = r.url.lower()
        
        # Filter out directories and social media
        if not any(x in url for x in ['facebook.com', 'yelp.com', 'clutch.co', 'linkedin.com']):
            
            # Logic to flag why the site is a good target
            reason = "Old Copyright Year"
            if "construction" in snippet: reason = "Site Unfinished"
            
            results.append({
                'Business/Owner': r.title,
                'Website': r.url,
                'Reason': reason,
                'Snippet': snippet[:150]
            })

    if results:
        df = pd.DataFrame(results)
        filename = f"outdated_{industry.replace(' ', '_')}.csv"
        df.to_csv(filename, index=False)
        print(f"--- ✅ SUCCESS! ---")
        print(f"Found {len(df)} outdated leads.")
        print(f"To see them, type: cat {filename}")
    else:
        print("No outdated sites found. Try a different city like 'Chicago' or 'Houston'.")

# Running the hunt
find_outdated_leads("Law Firm", "New York")
EOF

python hunter.py
cat <<EOF > hunter.py
import urllib.request
import urllib.parse
import re
import csv

def universal_hunter(industry, location):
    print(f"\n--- 🕵️‍♂️ EASYWURLD: Hunting for OUTDATED {industry} sites in {location} ---")
    
    # Searching for industry + old copyright markers
    query = f'{industry} {location} "Copyright 2018" OR "Copyright 2019" OR "Copyright 2020"'
    encoded_query = urllib.parse.quote(query)
    url = f"https://html.duckduckgo.com/html/?q={encoded_query}"
    
    headers = {'User-Agent': 'Mozilla/5.0'}
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            html = response.read().decode('utf-8')
            
            # Extracting Titles, Links, and Snippets using Patterns (Regex)
            links = re.findall(r'href="(http[s]?://.*?)"', html)
            titles = re.findall(r'result__a">(.*?)</a>', html)
            
            leads = []
            # Filtering out ads and major directories
            for title, link in zip(titles, links):
                if not any(x in link for x in ['duckduckgo', 'google', 'facebook', 'yelp', 'amazon']):
                    leads.append({'Business': title, 'Website': link, 'Status': 'Check for Old Copyright'})
            
            if leads:
                with open('outdated_leads.csv', 'w', newline='', encoding='utf-8') as f:
                    writer = csv.DictWriter(f, fieldnames=['Business', 'Website', 'Status'])
                    writer.writeheader()
                    writer.writerows(leads)
                print(f"--- ✅ SUCCESS! Found {len(leads)} potential outdated leads. ---")
                print("Type: cat outdated_leads.csv")
            else:
                print("No leads found. Try a different city.")
                
    except Exception as e:
        print(f"Error: {e}")

universal_hunter("Law Firm", "New York")
EOF

python hunter.py
cat <<EOF > map_hunter.py
import urllib.request
import urllib.parse
import re
import csv

def hunt_maps(industry, location):
    print(f"\n--- 🗺️ EASYWURLD: Scraping Google Presence for {industry} in {location} ---")
    
    # We search specifically for the "Place" results on Google
    query = f'"{industry}" in "{location}"'
    encoded_query = urllib.parse.quote(query)
    
    # We use the mobile-optimized search to avoid laptop-only blocks
    url = f"https://www.google.com/search?q={encoded_query}&tbm=lcl"
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 10; SM-G960F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Mobile Safari/537.36'
    }
    
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            html = response.read().decode('latin-1')
            
            # Find business names and their website links
            # These regex patterns look for the structure of Google's 'Map Pack'
            names = re.findall(r'data-attrid="title".*?>(.*?)<', html)
            links = re.findall(r'href="(http[s]?://.*?)"', html)
            
            leads = []
            print(f"Analyzing {len(names)} businesses found on the map...")
            
            for name in names:
                # We check if a website link was found near this business name in the code
                # If not, it likely has NO website listed.
                has_site = False
                site_url = "NONE"
                
                for link in links:
                    if name.lower()[:5] in link.lower() or "google" not in link:
                        has_site = True
                        site_url = link
                        break
                
                # We filter for the "Easywurld Gold": No site or just Social Media
                if not has_site or "facebook.com" in site_url or "instagram.com" in site_url:
                    leads.append({
                        'Business': name.replace('&amp;', '&'),
                        'Website': site_url,
                        'Status': 'NEEDS WEBSITE' if site_url == "NONE" else 'ONLY SOCIAL MEDIA'
                    })

            if leads:
                with open('map_leads.csv', 'w', newline='', encoding='utf-8') as f:
                    writer = csv.DictWriter(f, fieldnames=['Business', 'Website', 'Status'])
                    writer.writeheader()
                    writer.writerows(leads)
                print(f"--- ✅ SUCCESS! ---")
                print(f"Found {len(leads)} businesses with no real website.")
                print("Type: cat map_leads.csv")
            else:
                print("No clear 'No-Website' leads found. Try a different industry!")

    except Exception as e:
        print(f"Error: {e}")

# Target: Law Firms in Lagos (High potential for NO website)
hunt_maps("Law Firm", "Lagos")
EOF

python map_hunter.py
cat <<EOF > lead_hunter.py
import urllib.request
import urllib.parse
import re
import csv

def hunt_lagos_leads():
    print(f"\n--- 🕵️‍♂️ EASYWURLD: Scanning Lagos for 'Invisible' Law Firms ---")
    
    # We use 'site:google.com' to find the actual Google Business profiles 
    # for firms in Lagos that don't have their own website link indexed.
    query = 'law firm Lagos "no website" OR "directions" -inurl:http'
    encoded_query = urllib.parse.quote(query)
    url = f"https://www.google.com/search?q={encoded_query}&num=20"
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1'
    }
    
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            html = response.read().decode('latin-1')
            
            # This regex captures the name of the business from the search results
            names = re.findall(r'aria-level="3".*?>(.*?)<', html)
            
            leads = []
            for name in names:
                clean_name = name.replace('&amp;', '&').replace('<span>', '').replace('</span>', '')
                if "Law" in clean_name or "Chambers" in clean_name or "Legal" in clean_name:
                    leads.append({
                        'Business Name': clean_name,
                        'Issue': 'No Website Found in Search',
                        'Action': 'Pitch Mobile Landing Page'
                    })

            if leads:
                # Save to a new file
                with open('lagos_law_leads.csv', 'w', newline='', encoding='utf-8') as f:
                    writer = csv.DictWriter(f, fieldnames=['Business Name', 'Issue', 'Action'])
                    writer.writeheader()
                    writer.writerows(leads)
                print(f"--- ✅ SUCCESS! Found {len(leads)} leads in Lagos. ---")
                print("Type: cat lagos_law_leads.csv")
            else:
                print("Google is being stubborn. Let's try one more trick...")
                print("Manual Search Suggestion: Open Google and type 'Law firms in Victoria Island without website'")

    except Exception as e:
        print(f"Error: {e}")

hunt_lagos_leads()
EOF

python lead_hunter.py
mkdir -p easywurld_demos
cd easywurld_demos
# List of the 10 Lagos Leads
leads=("Bam_Gad_Solicitors" "Ediagbonya_Partners" "Philips_Njeteneh_Co" "Bayo_Akinlade_Co" "Abiloye_and_Co" "Alexander_Okpako_Co" "Cheakley_Chambers" "Jacobs_Bigaels" "Simons_Signature_Realty" "Wale_Liady_Co")
for company in "${leads[@]}"; do   clean_name=$(echo $company | sed 's/_/ /g')
  cat <<EOF > "${company}.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${clean_name} | Official Site</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: #f4f4f4; color: #333; text-align: center; }
        header { background: #1a1a1a; color: white; padding: 60px 20px; }
        .badge { background: #d4af37; color: black; padding: 5px 10px; font-weight: bold; border-radius: 5px; }
        .content { padding: 40px 20px; }
        .cta { background: #1a1a1a; color: white; padding: 15px 30px; text-decoration: none; border-radius: 50px; display: inline-block; margin-top: 20px; }
        footer { font-size: 12px; margin-top: 50px; color: #777; padding-bottom: 20px; }
    </style>
</head>
<body>
    <header>
        <div class="badge">EASYWURLD DEMO</div>
        <h1>${clean_name}</h1>
        <p>Premium Professional Services in Lagos</p>
    </header>
    <div class="content">
        <h2>Expertise. Integrity. Results.</h2>
        <p>We are currently upgrading our digital experience to better serve our clients in 2026.</p>
        <a href="https://wa.me/2348000000000" class="cta">Book a Consultation</a>
    </div>
    <footer>
        &copy; 2026 ${clean_name}. Digital Architecture by Easywurld.
    </footer>
</body>
</html>
EOF
 done
echo "✅ 10 Demos Created in 'easywurld_demos' folder!"
git init
git add .
git commit -m "Initial Easywurld Demos"
git remote add origin https://github.com/USERNAME/REPO.git
git push -u origin main
pkg install git -y
pkg install termux-services git -y
# 1. Enter your project folder
cd ~/easywurld_demos
# 2. Move everything out of any sub-folders to the main area
mv * .[^.]* .. 2>/dev/null
cd ..
rmdir easywurld_demos 2>/dev/null
# 3. Create a "Home Page" so the main link works too
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head><title>Easywurld Portfolio</title></head>
<body style="background:#000;color:#fff;text-align:center;padding-top:100px;font-family:sans-serif;">
<h1>EASYWURLD DIGITAL FACTORY</h1>
<p>2026 Enterprise Demos Live.</p>
</body>
</html>
EOF

# 4. Push the fix live
git add .
git commit -m "Fixed file paths for GitHub Pages"
git push
# 1. Go to your folder
cd ~/easywurld_demos
# 2. Force an index file into the main area
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head><title>Easywurld</title></head>
<body style="background:#000;color:#fff;text-align:center;padding:100px;">
<h1>EASYWURLD LIVE</h1>
<p>Demos are active.</p>
</body>
</html>
EOF

# 3. Push everything again
git add .
git commit -m "Emergency link fix"
git push
