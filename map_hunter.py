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
