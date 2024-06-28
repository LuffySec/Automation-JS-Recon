#!/bin/bash

# Prompt the user to enter the domain
echo "Please enter the domain (e.g., example.com):"
read DOMAIN

# Check if the user provided input
if [ -z "$DOMAIN" ]; then
  echo "No domain entered. Exiting..."
  exit 1
fi

# Step 1: Find subdomains using subfinder
echo "[*] Finding subdomains for $DOMAIN..."
subfinder -d "$DOMAIN" -o subdomain.txt

# Step 2: Check for alive subdomains using lucek
echo "[*] Checking for alive subdomains..."
cat subdomain.txt | lucek -ms 200 -ou alive_subs.txt

# Step 3: Find login endpoints using dorkScraper
echo "[*] Finding login endpoints for $DOMAIN..."
python3 dorkScraper.py -d "intitle:login+site:*.$DOMAIN" 200 -o login_endpoints.txt

# Step 4: Use waybackurls to gather URLs
echo "[*] Fetching URLs from Wayback Machine..."
cat alive_subs.txt | waybackurls | tee -a wayback.txt

# Step 5: Filter JavaScript files
echo "[*] Filtering JavaScript files..."
cat wayback.txt | grep -iE '.js' | grep -iEv '(.jsp|.json)' >> js.txt

# Step 6: Analyze JavaScript files using nuclei
echo "[*] Analyzing JavaScript files for potential secrets..."
nuclei -l js.txt -t /home/kali/.local/nuclei-templates/http/exposures -o potential_secrets.txt

echo "[*] Script completed. Results saved in potential_secrets.txt."
