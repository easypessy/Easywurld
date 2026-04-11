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
