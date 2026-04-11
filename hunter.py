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
