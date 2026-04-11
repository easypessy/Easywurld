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
~leads=("Paga_Corp" "Eden_Life" "Konga_Online" "Enyo_Retail" "HealthTracka" "Austin_Movers" "London_Glow" "Calgary_Dental" "Melbourne_Realty" "Dubai_Yacht")
for company in "${leads[@]}"; do   clean_name=$(echo $company | sed 's/_/ /g')
  cat <<EOF > "${company}.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${clean_name} | Concept</title>
    <style>
        body { background:#000; color:#fff; font-family:sans-serif; text-align:center; padding:50px; }
        .btn { display:block; padding:20px; background:#00ff88; color:#000; text-decoration:none; border-radius:10px; margin:20px auto; max-width:300px; font-weight:bold; }
    </style>
</head>
<body>
    <h1>${clean_name}</h1>
    <p>Exclusive 2026 Digital Design by Easywurld</p>
    <a href="https://wa.me/2349050690837" class="btn">WhatsApp Me</a>
</body>
</html>
EOF
 done
git add . && git commit -m "Sunday Prep Batch" && git push
leads=("Paga_Corp" "Eden_Life" "Konga_Online" "Enyo_Retail" "HealthTracka" "Austin_Movers" "London_Glow" "Calgary_Dental" "Melbourne_Realty" "Dubai_Yacht")
for company in "${leads[@]}"; do   clean_name=$(echo $company | sed 's/_/ /g')
  cat <<EOF > "${company}.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${clean_name} | Concept</title>
    <style>
        body { background:#000; color:#fff; font-family:sans-serif; text-align:center; padding:50px; }
        .btn { display:block; padding:20px; background:#00ff88; color:#000; text-decoration:none; border-radius:10px; margin:20px auto; max-width:300px; font-weight:bold; }
    </style>
</head>
<body>
    <h1>${clean_name}</h1>
    <p>Exclusive 2026 Digital Design by Easywurld</p>
    <a href="https://wa.me/2349050690837" class="btn">WhatsApp Me</a>
</body>
</html>
EOF
 done
git add . && git commit -m "Sunday Prep Batch" && git push
# Go to the root directory
cd ~
# If the folder exists, enter it
cd Easywurld 2>/dev/null || cd easywurld_demos 2>/dev/null
# Force everything to the main area
git add .
git commit -m "Final link sync"
git push origin main
cat <<EOF > Toronto_Dental_Hub.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toronto Dental Hub | Premium Oral Care</title>
    <style>
        :root { --teal: #00d2d3; --dark: #10ac84; }
        body { font-family: 'Helvetica', sans-serif; margin: 0; color: #333; line-height: 1.6; }
        .hero { background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1200&q=80'); height: 100vh; background-size: cover; display: flex; align-items: center; justify-content: center; color: #fff; text-align: center; }
        .section { padding: 80px 20px; text-align: center; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; max-width: 1200px; margin: auto; }
        .card { padding: 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); background: #fff; }
        .cta-btn { background: var(--teal); color: #fff; padding: 20px 40px; border-radius: 50px; text-decoration: none; font-weight: bold; font-size: 1.2rem; }
        footer { background: #222; color: #fff; padding: 50px; text-align: center; }
    </style>
</head>
<body>
    <header class="hero">
        <div>
            <h1 style="font-size: 4rem;">Smile With Confidence</h1>
            <p style="font-size: 1.5rem;">Toronto's Most Advanced Digital Dental Clinic</p>
            <br><br>
            <a href="https://wa.me/2349050690837" class="cta-btn">Book Consultation</a>
        </div>
    </header>

    <section class="section">
        <h2>Our Specialized Services</h2>
        <div class="grid">
            <div class="card"><h3>Digital Implants</h3><p>State-of-the-art 3D imaging for perfect precision.</p></div>
            <div class="card"><h3>Laser Whitening</h3><p>Get a celebrity smile in under 45 minutes.</p></div>
            <div class="card"><h3>Pediatric Care</h3><p>Making the dentist a fun place for the kids.</p></div>
        </div>
    </section>

    <section class="section" style="background: #f9f9f9;">
        <h2>Why Toronto Dental Hub?</h2>
        <p style="max-width: 700px; margin: auto;">We combine the latest AI dental technology with a gentle, patient-first approach. 20+ years of experience in the Ontario region.</p>
    </section>

    <footer>
        <p>&copy; 2026 Toronto Dental Hub // Digital Strategy by Easywurld</p>
        <a href="tel:+2349050690837" style="color: #00d2d3;">Emergency Call: +234 905 069 0837</a>
    </footer>
</body>
</html>
EOF

git add . && git commit -m "Deployed full landing page demo" && git push
cd ~
cd Easywurld 2>/dev/null || cd easywurld_demos 2>/dev/null
leads=("Air_Peace" "Mikano_Int" "Innoson_Motors" "Dana_Air" "Leadway_Assurance" "Texas_Logistics" "London_Health" "Vancouver_Realty" "Sydney_Solar" "Dubai_Gold")
for company in "${leads[@]}"; do   clean_name=$(echo $company | sed 's/_/ /g')
  cat <<EOF > "${company}.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${clean_name} | Official Digital Portal</title>
    <style>
        :root { --main: #00d2d3; --dark: #111; --gray: #f4f4f4; }
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; margin: 0; color: #333; line-height: 1.6; scroll-behavior: smooth; }
        nav { background: #fff; padding: 20px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .hero { background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80'); height: 80vh; background-size: cover; display: flex; align-items: center; justify-content: center; color: #fff; text-align: center; }
        .section { padding: 80px 20px; text-align: center; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; max-width: 1100px; margin: auto; }
        .card { padding: 40px; border-radius: 10px; background: #fff; border: 1px solid #eee; transition: 0.3s; }
        .card:hover { transform: translateY(-10px); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
        .btn { background: #000; color: #fff; padding: 18px 35px; border-radius: 5px; text-decoration: none; font-weight: bold; display: inline-block; margin-top: 20px; }
        .accent-btn { background: var(--main); color: #fff; }
        footer { background: var(--dark); color: #fff; padding: 60px 20px; text-align: center; }
        .footer-links { margin: 20px 0; display: flex; justify-content: center; gap: 20px; list-style: none; padding: 0; }
        .footer-links a { color: #fff; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
    <nav>
        <div style="font-weight: bold; font-size: 1.2rem;">${clean_name}</div>
        <a href="https://wa.me/2349050690837" style="text-decoration:none; color:#000; font-weight:bold;">Contact Agent</a>
    </nav>

    <div class="hero">
        <div>
            <h1 style="font-size: 3.5rem; margin:0;">${clean_name}</h1>
            <p style="font-size: 1.2rem; margin:20px 0;">Performance, Precision, and Digital Excellence.</p>
            <a href="#services" class="btn accent-btn">Explore Services</a>
        </div>
    </div>

    <section id="services" class="section">
        <h2>Our Core Capabilities</h2>
        <div class="grid">
            <div class="card">
                <h3>Global Operations</h3>
                <p>Scaling solutions across borders with unmatched efficiency and reliability.</p>
            </div>
            <div class="card">
                <h3>Innovation First</h3>
                <p>Leveraging 2026 technology to streamline infrastructure and logistics.</p>
            </div>
            <div class="card">
                <h3>Dedicated Support</h3>
                <p>Round-the-clock priority assistance for all enterprise-level clients.</p>
            </div>
        </div>
    </section>

    <section class="section" style="background: var(--gray);">
        <div style="max-width: 800px; margin: auto;">
            <h2>Strategy for Growth</h2>
            <p>This full-length portal is a custom architectural demo designed by <b>Easywurld</b> to show how ${clean_name} can dominate the digital landscape this year.</p>
            <a href="tel:+2349050690837" class="btn">Talk to the Architect</a>
        </div>
    </section>

    <footer>
        <p>&copy; 2026 ${clean_name}. All rights reserved.</p>
        <ul class="footer-links">
            <li><a href="https://wa.me/2349050690837">WhatsApp</a></li>
            <li><a href="tel:+2349050690837">Direct Line</a></li>
        </ul>
        <p style="font-size: 12px; color: #666; margin-top: 20px;">Designed & Managed by Easywurld Digital Agency</p>
    </footer>
</body>
</html>
EOF
 done
git add . && git commit -m "Batch Deployment: 10 Full Landing Pages" && git push
leads=("Air_Peace" "Mikano_Int" "Innoson_Motors" "Dana_Air" "Leadway_Assurance" "Texas_Logistics" "London_Health" "Vancouver_Realty" "Sydney_Solar" "Dubai_Gold")
for company in "${leads[@]}"; do   clean_name=$(echo $company | sed 's/_/ /g')
  cat <<EOF > "${company}.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${clean_name} | Enterprise Portal</title>
    <style>
        :root { --main: #00d2d3; --dark: #111; }
        body { font-family: 'Helvetica', sans-serif; margin: 0; color: #333; line-height: 1.6; }
        .hero { background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80'); height: 70vh; background-size: cover; display: flex; align-items: center; justify-content: center; color: #fff; text-align: center; }
        .section { padding: 60px 20px; text-align: center; max-width: 1000px; margin: auto; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-top: 40px; }
        .card { padding: 30px; border: 1px solid #eee; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .cta-btn { background: #000; color: #fff; padding: 15px 35px; border-radius: 5px; text-decoration: none; font-weight: bold; display: inline-block; margin: 10px; }
        footer { background: #111; color: #fff; padding: 40px; text-align: center; margin-top: 50px; }
    </style>
</head>
<body>
    <div class="hero">
        <div>
            <h1 style="font-size: 3rem;">${clean_name}</h1>
            <p style="font-size: 1.2rem;">2026 Digital Performance Architecture</p>
            <a href="https://wa.me/2349050690837" class="cta-btn" style="background:#00ff88; color:#000;">WhatsApp Me</a>
        </div>
    </div>
    <div class="section">
        <h2>Corporate Solutions</h2>
        <div class="grid">
            <div class="card"><h3>Efficiency</h3><p>Streamlined digital workflows for modern enterprises.</p></div>
            <div class="card"><h3>Security</h3><p>Enterprise-grade protection for all data and transactions.</p></div>
            <div class="card"><h3>Scale</h3><p>Built to handle global traffic without slowing down.</p></div>
        </div>
    </div>
    <div class="section" style="background:#f4f4f4; border-radius: 20px;">
        <h3>Why this design?</h3>
        <p>Easywurld built this specifically for ${clean_name} to demonstrate a 1-second load time and high-conversion mobile interface.</p>
        <a href="tel:+2349050690837" class="cta-btn">Call Specialist</a>
    </div>
    <footer>
        <p>&copy; 2026 ${clean_name} // Digital Transformation by Easywurld</p>
    </footer>
</body>
</html>
EOF
 done
git add . && git commit -m "Updated all leads to Full Landing Pages" && git push
# Enter the repo
cd ~
cd Easywurld 2>/dev/null || cd easywurld_demos 2>/dev/null
# Move all HTML files to the very front so they are easy to find
mv *.html .. 2>/dev/null
cd ..
# Force sync
git add .
git commit -m "Moving files to root for easier access"
git push origin main
