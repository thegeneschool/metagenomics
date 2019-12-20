#!/bin/bash
sudo wget -O- http://neuro.debian.net/lists/xenial.us-ca.full | \
  sudo tee /etc/apt/sources.list.d/neurodebian.sources.list && \
    sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 && \
    sudo apt-get update
apt-get upgrade -y
apt-get install -y docker.io singularity-container npm nodejs python3-pip python3-pycurl awscli
pip3 install jupyterhub
npm install -g configurable-http-proxy
pip3 install notebook jupyterlab

sudo mkfs -t xfs -L HOME /dev/nvme1n1
sudo sh -c 'echo "LABEL=HOME /home xfs defaults,noatime 0 0" >> /etc/fstab'
sudo sh -c 'echo "LABEL=TUTORIALDATA /data xfs defaults,noatime 0 0" >> /etc/fstab'
sudo mount /home
sudo mkdir /data
sudo mount /data

JH_HOME=/etc/jupyterhub

mkdir $JH_HOME
jupyterhub --generate-config -f $JH_HOME/jupyterhub_config.py

PUBLIC_HOSTNAME=$(curl http://169.254.169.254/2009-04-04/meta-data/public-hostname)

openssl req -x509 -newkey rsa:4096 -keyout $JH_HOME/key.pem -out $JH_HOME/cert.pem -days 365 -nodes \
  -subj "/C=AU/ST=NSW/L=Sydney/O=University of Technology Sydney/OU=i3 institute/CN=$PUBLIC_HOSTNAME"

sed -i "/#c\.JupyterHub\.bind_url *=/c\c.JupyterHub.bind_url = \"https://${PUBLIC_HOSTNAME}:8080\"" $JH_HOME/jupyterhub_config.py
sed -i '/#c\.Authenticator\.admin_users *=/c\c.Authenticator.admin_users = {"hub_admin"}' $JH_HOME/jupyterhub_config.py
sed -i '/#c\.Spawner\.default_url *=/c\c.Spawner.default_url = "/lab"' ${JH_HOME}/jupyterhub_config.py
sed -i "/#c\.JupyterHub\.ssl_key *=/c\c.JupyterHub.ssl_key = \"${JH_HOME}/key.pem\"" $JH_HOME/jupyterhub_config.py
sed -i "/#c\.JupyterHub\.ssl_cert *=/c\c.JupyterHub.ssl_cert = \"${JH_HOME}/cert.pem\"" $JH_HOME/jupyterhub_config.py

sudo systemctl start docker
sudo systemctl enable docker

useradd -m -s /bin/bash -G sudo -p '$6$q3E/uVm2.jYs0Y.D$djPDt6ez75e/Sc8tyh/QfiZh4mn8T7iU8CIRV6rQMX1kSmQYJIhf1zT30QP0qTwoPCJfR9oeySBPdx321Ad0P.' hub_admin
useradd -m -s /bin/bash -p '$6$rounds=656000$5KEg/g/643fwQYzx$M1xEprkiABTJAWM2uPr5qzjck5/2Mxszrnr0.2su8OxtBISH5RRKTZZGLIWDOQ3SFJILzPTqKkS7XxhvT6RGs.' celymar
useradd -m -s /bin/bash -p '$6$rounds=656000$NoubmSzTXQ8B10oS$c9seRQXKIf8NAm.u/k8JleG6iSCo.vEhO8guct7PmSoSCTdE0IcPBZTgIA6bapdP9ioDm8AJwnzY0//aLDHaC1' xin
useradd -m -s /bin/bash -p '$6$rounds=656000$0zNhMKoWBylJ1XgY$5oCeB2vJkIyWxwKyZ5wbstOcXcC8fk3dV69wjQAYkmMdS.6Cm7cmK2ruU.HIfJCBQhh6050aT/SW/UMHG5R8q1' sidra
useradd -m -s /bin/bash -p '$6$rounds=656000$44dz7DL05i0QZt8O$il1KiMA6Ulwn5Mvwzvzdq0S6r.TL7TYckSJhSCbD6XFwTW4Iwcm3.Zgp3s9Sl.YkY4mtUI.K/KBovziubBftq/' gemma
useradd -m -s /bin/bash -p '$6$rounds=656000$GGs2Jk3riBk42hmR$mMXAg7TJHvTW.kN.gELObs34RnA7EUWdIBYE9SpWBOy4qHvOp3eEbk5A0NX1IZcmKWzq85w8Eo9SuHI6.Z.oq0' emily
useradd -m -s /bin/bash -p '$6$rounds=656000$rZWxfCuV8khKc4DJ$voVaX5M6g1JSQEbV2YoFfvLzxBUh346JTnYOPlM9HS6oA5JDMXCZDZPeh4uhneG4/zT.2ophqzyW4cav3Ewex0' nicholas
useradd -m -s /bin/bash -p '$6$rounds=656000$0HypUXSIRHLxlQJf$x4.QsYFJFDYXkYc607VCh5HjeRhVHSec7VvG9lbDs1UqfgbtGmzR36a60UHqnOKuoQagtG.AJ0fG0pyGMITXA.' jwalit
useradd -m -s /bin/bash -p '$6$rounds=656000$2vkO7Zpn5CUxHHQW$r03UnNmFxPNWrqy1.ghyjoaSb1I8BjhTrc6fUTr0vMR6g3aHKfQUKqJAvhyRGwZAZRZSr1JHjXpKV9etU6sJR1' vahid
useradd -m -s /bin/bash -p '$6$rounds=656000$4VjFCxEhKOSOXEVf$i4kPCkObRKGc9PQhDFIdIz2RxH00tk4GBk4UT3PbwDQWRpyKdith8lDakGO3FW3tWSOT0Ve6kzQtAF6q.saKh1' olivia
useradd -m -s /bin/bash -p '$6$rounds=656000$LpEHfshIzzWwruWX$kXsyLcU5HljHxr2.jaGwcytwDKM2KU6je8PS9HZ2l0hQ75YvAKimdWtOWec9BTj9dtjPgDEQno92.N5tvXONn0' wajira
useradd -m -s /bin/bash -p '$6$rounds=656000$o94j4toHv9uOVeOb$rDa.caDc8nwS8qzlnF5uYcNXcPnOU9ZqsZgZTpp1bzbtVckDLrm/Z9MIM8jtuAOs6sqcxjk5o8St5npvOQgOP0' simranjit
useradd -m -s /bin/bash -p '$6$rounds=656000$yE38heXu8LSEiMox$WUHMeAboKz2sWFQyIKZNGQqK4PI.SIcsouzDLLRIwEe1MS61WIJviHv.o8Ym6yg2kRwt7PJa1jlMrM8skvT050' jenendra
useradd -m -s /bin/bash -p '$6$rounds=656000$MXwrRVuShuQR4Unk$SOGq814Xpi77IgnN1Vs08/L2s83uNcMhpB0YoacJbDFBusArOoshRVmCG.8hy/yLjmEcEP/CRat3v/fvF/Jpd1' bruna
useradd -m -s /bin/bash -p '$6$rounds=656000$xGqT.PWfQnx4m5R/$aAUy4uWgkOxwL.FTqwHVVIlTlNpzs4ClOBwoQLKWKxLvPQBx5lp5pHfeoJKbazlPpdaU6fxRYJ5R.bvW03gvM0' pankaj
useradd -m -s /bin/bash -p '$6$rounds=656000$tOf1E2j34xB8G1rz$5z5YlRpNtFLLt1rQN62B5JBpkmd4EfsDsKMwuop7pVCKxkWup6oaQKisys8Ba/jgwLODFBMD8ukdgcJp7jrXV/' catarina
useradd -m -s /bin/bash -p '$6$rounds=656000$Cw7RkG6OqH5bB1NM$pqzKkor7gPu.bTp.UxzO92qHum57O9W9DgX5zxVFwDByolND6ft.k9/xCgb1RpznywFNf7HKsqQHoWOT1XlF9.' lea
useradd -m -s /bin/bash -p '$6$rounds=656000$PnWGvNQ2cpQC7EPj$R12EvL2zDNNGsC.ETjSvexQZTJkgnUhUitWJx6/vnm1XLlZeyjE6W64xs9IXkDFVgMSq7WK04Y9lPPAsePMHt/' ramesha
useradd -m -s /bin/bash -p '$6$rounds=656000$IpXilUyCUmpo97nq$pu3dVXtcYTKPwtQ/bDHwpEuaU1rjurzi2bTcixR1/3P3yLT5IwOXDRNU1r6zo6DFaJKnChok1wg2NxE1IR0LB/' laura
useradd -m -s /bin/bash -p '$6$rounds=656000$jnx3tO6hwdjiYhpn$ElM1U65aVH1RI3m9QyfxwyPVDvLo./6SFW9dxVzOcXTGkHP7FyCDsPCwkWvxwkyLeKA/8PhlP0Xj9naxgJ18J/' sitaram
useradd -m -s /bin/bash -p '$6$rounds=656000$ad70tfUenFaCfZ74$ROa6UqgGTmo0ejgwzjDEPJw6cgsI9izOraj8LxmmMausqUoe./b9TnJjIEkluLOBpP6L327.XtIpai8p6UZl10' chenchen
useradd -m -s /bin/bash -p '$6$rounds=656000$EH9HCRDV9eTUJC5d$/mEFBI068mdcUjhrUocmyVyLKZGpYM4DN7twN3u7jJgUqip2SY5QqklcmaMb1009QuUJOb2eiOTdQF5hB5BVY1' sharon
useradd -m -s /bin/bash -p '$6$rounds=656000$IeEAMNtBdpFE3B1s$fdJ/WCa6yBWxaKCuKvDQqz1OeDyyDFXSJc8vN0lYoSKOZdJPki3sYssT4GR8wbom8DNit8/r.yy3BE1c2xiJ10' mahfuza
useradd -m -s /bin/bash -p '$6$rounds=656000$tSHYuGT8aGQshFto$7e.a/loyZo7xAqFoVZh.o6Cl0o9wwZGGLPbYk39svlXNYRFwy2ZVIbi7AKYmo.TQTvnQuMZrCMHOf1lmcYUx5.' lucky
useradd -m -s /bin/bash -p '$6$rounds=656000$MpsO5aKPqnbI2gky$mDRp4KMQUasDxv8ZaGM.5tJWgp9htKiLqbkoG6HS8hisPA/zYkjdR31zkwBfh0baLYkzya1sUsofPC7Dr0jpj1' john
useradd -m -s /bin/bash -p '$6$rounds=656000$BYos1rkuI1zXt84k$5R4AVX26eAHIp8o0ltOEbRgtMHky0B8X2dKPm1UMSqyh9e5O9uYPwb6NZquNM8RYYZy5EBKPf5Q28oND9ZABM0' michelle
