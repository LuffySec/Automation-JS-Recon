#!/bin/bash

# Check if domain is provided
if [ -z "$1" ]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

DOMAIN=$1

# Step 1: Find subdomains using subfinder
echo "[*] Finding subdomains for $DOMAIN..."
subfinder -d "$DOMAIN" -o subdomain.txt

# Step 2: Check for alive subdomains using lucek
echo "[*] Checking for alive subdomains..."
cat subdomain.txt | lucek -ms 200 -ou alive_subs.txt

# Step 3: Use waybackurls to gather URLs
echo "[*] Fetching URLs from Wayback Machine..."
cat alive_subs.txt | waybackurls | tee -a wayback.txt

# Step 4: Filter JavaScript files
echo "[*] Filtering JavaScript files..."
cat wayback.txt | grep -iE '.js' | grep -iEv '(.jsp|.json)' >> js.txt

# Step 5: Analyze JavaScript files using nuclei
echo "[*] Analyzing JavaScript files for potential secrets..."
nuclei -l js.txt -t /home/kali/.local/nuclei-templates/http/exposures -o potential_secrets.txt

echo "[*] Script completed. Results saved in potential_secrets.txt."
