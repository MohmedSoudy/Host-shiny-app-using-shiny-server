# Host-shiny-app-using-shiny-server
A step by step guide on how to how to host shiny app using shiny-server and apache2
## Update the system 
```
sudo apt update && sudo apt upgrade 
```
## R Installation 
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt install r-base r-base-dev -y
sudo Rscript -e "install.packages('shiny', repos='https://cran.rstudio.com/')"
```
## Shiny-Sever Installation 
```
sudo apt-get install -y gdebi-core
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb
sudo gdebi shiny-server-1.5.20.1002-amd64.deb
```
## Copy the app files 
```
cp app_dir /srv/shiny-server/app_name
```
## Apache2 Installation 
```
sudo apt-get install -y apache2
sudo apt-get install -y libxml2-dev
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_wstunnel
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so
```
## Modify Apache2 configuration file
- Add the following lines to 000-default.conf (/etc/apache2/sites-available/000-default.conf)
- An example file is attached to the repository 
```
<VirtualHost *:80>

  <Proxy *>
    Allow from localhost
  </Proxy>
 ProxyPass / http://localhost:3838/
 ProxyPassReverse / http://localhost:3838/
 ProxyRequests Off
```
## Enable Apache2 and Shiny-Server 
```
sudo /etc/init.d/apache2 restart
sudo systemctl enable apache2
sudo systemctl enable shiny-server 
sudo systemctl restart shiny-server
```
## Install your R packages using the following commands 
- CRAN
  ```
  sudo Rscript -e "install.packages('shiny', repos='https://cran.rstudio.com/')"
  ```
- Bioconductor
  ```
  sudo Rscript -e \"BiocManager::install('msa')"
  ```
## Define packages repository 
Use the check_packages.R to know which of your packages are CRAN and which are Bioconductor 
- Usage
  - Input: Path to CSV File containing package names on the first column, and output directory to write the output files
  - Output: Two files containing CRAN and Bioconductor packages  
  ```
  Rscript --no-save --no-restore --vanilla check_packages.R Path_to_csv OutPath
  ```
