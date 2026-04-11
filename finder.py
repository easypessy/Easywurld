import pandas as pd
from duckduckgo_search import DDGS

def find_clients(industry, location):
    print(f"--- Searching for {industry} in {location} ---")
    # This query looks for businesses likely needing a site update or help
    query = f"{industry} in {location} contact"
    results = []
    
    with DDGS() as ddgs:
        # We search the web for the top 25 results
        for r in ddgs.text(query, max_results=25):
            # Filtering out massive directories to find direct business links
            if not any(x in r['href'] for x in ['facebook.com', 'yelp.com', 'yellowpages.com']):
                results.append({
                    'Business Name': r['title'],
                    'Link': r['href'],
                    'Snippet': r['body']
                })
    
    if results:
        df = pd.DataFrame(results)
        # Saves the file to your phone's 'Documents' folder
        output_path = '/data/data/com.termux/files/home/storage/downloads/real_leads.csv'
        df.to_csv(output_path, index=False)
        print(f"SUCCESS! Found {len(df)} leads.")
        print(f"File saved to your phone's 'Downloads' folder as: real_leads.csv")
    else:
        print("No results found. Try a different industry or location.")

# Change these to find different clients!
find_clients("Dental Clinic", "Lagos Nigeria")

