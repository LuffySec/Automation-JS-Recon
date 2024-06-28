# Automation-JS-Recon
This tools used for Automating finding of subdomain, and checking for alive subdomain, and gathering js files from all the subdomain and then automating finding of sensitive information on all the js files

# What this tools using
Use subfinder to find subdomains and save them to subdomain.txt.

Use lucek to check for alive subdomains and save them to alive_subs.txt.

Use waybackurls to fetch URLs and save them to wayback.txt.

Filter out JavaScript files from the fetched URLs and save them to js.txt.

Use nuclei to analyze the JavaScript files and save potential secrets to potential_secrets.txt.

# Requirements
subfinder : https://github.com/projectdiscovery/subfinder

LUcek : https://github.com/rootbakar/LUcek

waybackurls : https://github.com/tomnomnom/waybackurls

nuclei : https://github.com/projectdiscovery/nuclei


