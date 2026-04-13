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
COMPANY="Suave_Properties"
# 1. Create the folder
mkdir -p "$COMPANY"
cd "$COMPANY"
# 2. THE MASTER HOME PAGE (index.html)
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$COMPANY | Home</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@300;400&display=swap');
        body { margin: 0; background: #050505; color: #fff; font-family: 'Inter', sans-serif; }
        nav { position: fixed; width: 100%; top: 0; padding: 30px; display: flex; justify-content: space-between; box-sizing: border-box; z-index: 1000; background: rgba(0,0,0,0.8); }
        nav a { color: #fff; text-decoration: none; margin-left: 20px; font-size: 11px; text-transform: uppercase; letter-spacing: 2px; }
        .hero { height: 100vh; background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8)), url('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1600&q=80'); background-size: cover; background-attachment: fixed; display: flex; align-items: center; padding: 0 10%; }
        h1 { font-family: 'Playfair Display', serif; font-size: 5rem; margin: 0; color: #c5a059; }
        .btn { display: inline-block; padding: 20px 40px; border: 1px solid #c5a059; color: #c5a059; text-decoration: none; text-transform: uppercase; font-size: 11px; letter-spacing: 3px; margin-top: 30px; }
    </style>
</head>
<body>
    <nav>
        <div style="font-family:'Playfair Display'; color:#c5a059;">EASYWURLD</div>
        <div>
            <a href="index.html">Home</a>
            <a href="about.html">About</a>
            <a href="services.html">Services</a>
        </div>
    </nav>
    <div class="hero">
        <div>
            <p style="letter-spacing:10px; color:#888;">ESTATE ARCHITECTURE</p>
            <h1>$COMPANY</h1>
            <a href="services.html" class="btn">Explore Portfolio</a>
        </div>
    </div>
</body>
</html>
EOF

# 3. THE ABOUT PAGE (about.html)
cat <<EOF > about.html
<!DOCTYPE html>
<html><head><style>body{background:#050505; color:#fff; font-family:sans-serif; padding:100px 10%;} h1{color:#c5a059; font-family:serif; font-size:3rem;}</style></head>
<body>
    <h1>Our Vision</h1>
    <p style="line-height:2; color:#888; max-width:600px;">$COMPANY is a leading boutique agency dedicated to high-end lifestyle curation. We don't just sell property; we architect legacies.</p>
    <a href="index.html" style="color:#c5a059;">Back to Home</a>
</body></html>
EOF

# 4. THE SERVICES PAGE (services.html)
cat <<EOF > services.html
<!DOCTYPE html>
<html><head><style>body{background:#050505; color:#fff; font-family:sans-serif; padding:100px 10%;} h1{color:#c5a059; font-family:serif; font-size:3rem;}</style></head>
<body>
    <h1>Services</h1>
    <ul style="color:#888; line-height:3;">
        <li>Luxury Property Brokerage</li>
        <li>Asset Management & Maintenance</li>
        <li>Investment Portfolio Strategy</li>
    </ul>
    <a href="index.html" style="color:#c5a059;">Back to Home</a>
</body></html>
EOF

# 5. GO BACK AND PUSH
cd ..
git add .
git commit -m "Complete 4-Page Enterprise Site for $COMPANY"
git push origin main
COMPANY="Aluko_Oyebode"
INDUSTRY="Specialist Legal Infrastructure"
mkdir -p "$COMPANY"
cd "$COMPANY"
# 1. HOME: The "Power & Authority" Layout
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$COMPANY | 2026 Corporate Portal</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@200;400&display=swap');
        body { margin:0; background:#020b1a; color:#fff; font-family:'Inter',sans-serif; }
        nav { position:fixed; width:100%; top:0; padding:30px; display:flex; justify-content:space-between; box-sizing:border-box; z-index:1000; background:rgba(2,11,26,0.9); }
        .logo { font-family:'Playfair Display'; font-size:1.3rem; color:#a5b4fc; letter-spacing:3px; }
        .hero { height:100vh; display:flex; align-items:center; padding:0 10%; border-left: 1px solid #1e293b; }
        h1 { font-family:'Playfair Display'; font-size:5rem; margin:0; line-height:1; }
        .btn { display:inline-block; padding:20px 50px; border:1px solid #a5b4fc; color:#a5b4fc; text-decoration:none; text-transform:uppercase; font-size:11px; letter-spacing:4px; margin-top:40px; transition:0.3s; }
        .btn:hover { background:#a5b4fc; color:#020b1a; }
        .wa-float { position:fixed; bottom:40px; right:40px; background:#25d366; padding:20px; border-radius:50px; text-decoration:none; font-weight:bold; color:#fff; z-index:1000; }
    </style>
</head>
<body>
    <nav><div class="logo">EASYWURLD / CORP</div><a href="about.html" style="color:#fff; text-decoration:none; font-size:10px; letter-spacing:2px;">THE FIRM</a></nav>
    <div class="hero">
        <div>
            <p style="letter-spacing:10px; color:#475569; text-transform:uppercase;">$INDUSTRY</p>
            <h1>$COMPANY</h1>
            <a href="https://wa.me/2349050690837" class="btn">View Digital Architecture</a>
        </div>
    </div>
    <a href="https://wa.me/2349050690837" class="wa-float">Connect with Architect</a>
</body>
</html>
EOF

# 2. ABOUT: The "Expertise" Page
cat <<EOF > about.html
<!DOCTYPE html>
<html><head><style>body{background:#020b1a; color:#fff; font-family:sans-serif; padding:150px 10%;} h1{font-family:serif; color:#a5b4fc; font-size:3rem;}</style></head>
<body>
    <h1>Excellence & Trust</h1>
    <p style="max-width:650px; line-height:2.2; color:#94a3b8; font-size:1.1rem;">At $COMPANY, we recognize that digital stability is the foundation of 2026 operations. Our partnership with Easywurld ensures our digital footprint matches our physical reputation for uncompromising excellence.</p>
    <br><a href="index.html" style="color:#a5b4fc; text-decoration:none;">RETURN TO PORTAL</a>
</body></html>
EOF

cd ..
git add . && git commit -m "Deployment: High-Trust Corporate Style for $COMPANY" && git push origin main
