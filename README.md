# Host-shiny-app-using-shiny-server
A stepby step guide on how to how to host shiny app using shiny-server and apache2
## Update the system 
```
sudo apt update && sudo apt upgrade 
```
## R Installation 
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt install r-base r-base-dev -y
sudo su - \ -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
```
## Shiny-Sever Installation 
```
sudo apt-get install -y gdebi-core
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb
sudo gdebi shiny-server-1.5.20.1002-amd64.deb
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
#Copy the app files 
cp app_dir /srv/shiny-server/app_name
```
## Modify Apache2 configuration file
- Add the following lines to 000-default.conf (/etc/apache2/sites-available/000-default.conf)
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
sudo /etc/init.d/apache2 restart
sudo systemctl enable apache2
sudo systemctl enable shiny-server 
sudo systemctl restart shiny-server 
## Install your R packages using the following commands 
```
sudo su - \ -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
```
