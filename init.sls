install_prerequisites:
  cmd.run:
    - name: yum -y install gcc libpcap-devel pcre-devel libyaml-devel file-devel zlib-devel jansson-devel nss-devel libcap-ng-devel libnet-devel tar make libnetfilter_queue-devel lua-devel

/usr/src/suricata-3.1.tar.gz:
  file.managed:
    - source: salt://files/suricata_sources/suricata-3.1.tar.gz
    - unless:
      - ls /usr/src/suricata-3.1.tar.gz

extract_suricata:
  cmd.run:
    - name: tar xfvz /usr/src/suricata-3.1.tar.gz --directory=/usr/src
    - unless:
      - ls /usr/src/suricata-3.1

install_suricata:
  cmd.run:
    - name: |
        cd /usr/src/suricata-3.1
        ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-nfqueue --enable-lua
        make install-full && ldconfig
    - cwd: /usr/src/suricata-3.1
    - timeout: 1000
    - shell: /bin/bash
    - unless: 
      - ls /bin/suricata

/etc/init.d/suricata:
  file.managed:
    - source: salt://files/suricata
    - unless:
      - ls /etc/init.d/suricata

modify-suri-init:
  cmd.run:
    - name: chmod +x /etc/init.d/suricata

/etc/suricata/suricata.yaml
  file.managed:
    - source: salt://files/suricata.yaml
