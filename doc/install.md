```shell
echo 'deb http://download.opensuse.org/repositories/home:/ra3xdh/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/home:ra3xdh.list
curl -fsSL https://download.opensuse.org/repositories/home:ra3xdh/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_ra3xdh.gpg > /dev/null
sudo apt update
sudo apt install -yu qucs-s ngspice gnuplot
```
