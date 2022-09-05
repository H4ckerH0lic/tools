printf "${bblue} Running: Installing requirements ${reset}\n\n"

mkdir -p ~/.gf
mkdir -p $tools
mkdir -p ~/.config/notify/
mkdir -p ~/.config/amass/
mkdir -p ~/.config/nuclei/
touch $dir/.github_tokens

# Repos with special configs
eval git clone https://github.com/projectdiscovery/nuclei-templates ~/nuclei-templates $DEBUG_STD
eval git clone https://github.com/geeknik/the-nuclei-templates.git ~/nuclei-templates/extra_templates $DEBUG_STD
eval wget -q -O - https://raw.githubusercontent.com/NagliNagli/BountyTricks/main/ssrf.yaml > ~/nuclei-templates/ssrf_nagli.yaml $DEBUG_STD
eval wget -q -O - https://raw.githubusercontent.com/NagliNagli/BountyTricks/main/sap-redirect.yaml > ~/nuclei-templates/sap-redirect_nagli.yaml $DEBUG_STD
eval nuclei -update-templates $DEBUG_STD
cd ~/nuclei-templates/extra_templates && eval git pull $DEBUG_STD
cd "$dir" || { echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
eval git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git $dir/sqlmap $DEBUG_STD
eval git clone --depth 1 https://github.com/drwetter/testssl.sh.git $dir/testssl.sh $DEBUG_STD
eval $SUDO git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb $DEBUG_STD
eval $SUDO ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit $DEBUG_STD

gotools["gf"]="go install -v github.com/tomnomnom/gf@latest"
gotools["qsreplace"]="go install -v github.com/tomnomnom/qsreplace@latest"
gotools["Amass"]="go install -v github.com/OWASP/Amass/v3/...@master"
gotools["ffuf"]="go install -v github.com/ffuf/ffuf@latest"
gotools["github-subdomains"]="go install -v github.com/gwen001/github-subdomains@latest"
gotools["waybackurls"]="go install -v github.com/tomnomnom/waybackurls@latest"
gotools["nuclei"]="go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
gotools["anew"]="go install -v github.com/tomnomnom/anew@latest"
gotools["notify"]="go install -v github.com/projectdiscovery/notify/cmd/notify@latest"
gotools["unfurl"]="go install -v github.com/tomnomnom/unfurl@latest"
gotools["httpx"]="go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
gotools["github-endpoints"]="go install -v github.com/gwen001/github-endpoints@latest"
gotools["dnsx"]="go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
gotools["gau"]="go install -v github.com/lc/gau/v2/cmd/gau@latest"
gotools["subjs"]="go install -v github.com/lc/subjs@latest"
gotools["Gxss"]="go install -v github.com/KathanP19/Gxss@latest"
gotools["gospider"]="go install -v github.com/jaeles-project/gospider@latest"
gotools["crlfuzz"]="go install -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest"
gotools["dalfox"]="go install -v github.com/hahwul/dalfox/v2@latest"
gotools["puredns"]="go install -v github.com/d3mondev/puredns/v2@latest"
gotools["interactsh-client"]="go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
gotools["analyticsrelationships"]="go install -v github.com/Josue87/analyticsrelationships@latest"
gotools["gotator"]="go install -v github.com/Josue87/gotator@latest"
gotools["roboxtractor"]="go install -v github.com/Josue87/roboxtractor@latest"
gotools["mapcidr"]="go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
gotools["ipcdn"]="go install -v github.com/six2dez/ipcdn@latest"
gotools["dnstake"]="go install -v github.com/pwnesia/dnstake/cmd/dnstake@latest"
gotools["gowitness"]="go install -v github.com/sensepost/gowitness@latest"
gotools["tlsx"]="go install github.com/projectdiscovery/tlsx/cmd/tlsx@latest"
gotools["gitdorks_go"]="go install -v github.com/damit5/gitdorks_go@latest"
gotools["smap"]="go install -v github.com/s0md3v/smap/cmd/smap@latest"
gotools["dsieve"]="go install -v github.com/trickest/dsieve@master"

repos["dorks_hunter"]="six2dez/dorks_hunter"
repos["pwndb"]="davidtavarez/pwndb"
repos["dnsvalidator"]="vortexau/dnsvalidator"
repos["theHarvester"]="laramies/theHarvester"
repos["brutespray"]="x90skysn3k/brutespray"
repos["wafw00f"]="EnableSecurity/wafw00f"
repos["gf"]="tomnomnom/gf"
repos["Gf-Patterns"]="1ndianl33t/Gf-Patterns"
repos["ctfr"]="UnaPibaGeek/ctfr"
repos["xnLinkFinder"]="xnl-h4ck3r/xnLinkFinder"
repos["Corsy"]="s0md3v/Corsy"
repos["CMSeeK"]="Tuhinshubhra/CMSeeK"
repos["fav-up"]="pielco11/fav-up"
repos["Interlace"]="codingo/Interlace"
repos["massdns"]="blechschmidt/massdns"
repos["Oralyzer"]="r0075h3ll/Oralyzer"
repos["testssl"]="drwetter/testssl.sh"
repos["commix"]="commixproject/commix"
repos["JSA"]="w9w/JSA"
repos["cloud_enum"]="initstring/cloud_enum"
repos["ultimate-nmap-parser"]="shifty0g/ultimate-nmap-parser"
repos["pydictor"]="LandGrey/pydictor"
repos["gitdorks_go"]="damit5/gitdorks_go"

repos_step=0
for repo in "${!repos[@]}"; do
    repos_step=$((repos_step + 1))
    eval git clone https://github.com/${repos[$repo]} $dir/$repo $DEBUG_STD
    eval cd $dir/$repo $DEBUG_STD
    eval git pull $DEBUG_STD
    exit_status=$?
    if [ $exit_status -eq 0 ]
    then
        printf "${yellow} $repo installed (${repos_step}/${#repos[@]})${reset}\n"
    else
        printf "${red} Unable to install $repo, try manually (${repos_step}/${#repos[@]})${reset}\n"
        double_check=true
    fi
    if [ -s "requirements.txt" ]; then
        eval $SUDO pip3 install -r requirements.txt $DEBUG_STD
        #eval $SUDO python3 setup.py install --record files.txt $DEBUG_STD
        #[ -s "files.txt" ] && eval xargs rm -rf < files.txt $DEBUG_STD
        #eval $SUDO pip3 install . $DEBUG_STD
    fi
    if [ -s "setup.py" ]; then
        eval $SUDO pip3 install . $DEBUG_STD
    fi
    if [ "massdns" = "$repo" ]; then
            eval make $DEBUG_STD && strip -s bin/massdns && eval $SUDO cp bin/massdns /usr/local/bin/ $DEBUG_ERROR
    elif [ "gf" = "$repo" ]; then
            eval cp -r examples ~/.gf $DEBUG_ERROR
    elif [ "Gf-Patterns" = "$repo" ]; then
            eval mv *.json ~/.gf $DEBUG_ERROR
    fi
    cd "$dir" || { echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"; exit 1; }
done