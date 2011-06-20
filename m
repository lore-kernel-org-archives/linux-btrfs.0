From: Henning Rohlfs <x+btrfs@xehonk.de>
Subject: Abysmal Performance
Date: Mon, 20 Jun 2011 23:51:24 +0200
Message-ID: <7da312412980843ba746e4e8809060f8@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_b12d200ba7c04e438dabfa5e5de902e5"
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=_b12d200ba7c04e438dabfa5e5de902e5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

 Hello,

 I've migrated my system to btrfs (raid1) a few months ago. Since then 
 the performance has been pretty bad, but recently it's gotten 
 unbearable: a simple sync called while the system is idle can take 20 up 
 to 60 seconds. Creating or deleting files often has several seconds 
 latency, too.

 One curious - but maybe unrelated - observation is that even though I'm 
 using a raid1 btrfs setup, the hdds are often being written to 
 sequentially. One hard-drive sees some write activity and after it 
 subsides, the other drive sees some activity. (See attached 
 sequential-writes.txt.)

 - 64bit gentoo with vanilla 2.6.39 kernel
 - lzo compression enabled
 - 2x WD1000FYPS (1TB WD hdds)
 - Athlon x2 2.2GHz with 8GB RAM
 - space_cache was enabled, but it seemed to make the problem worse. 
 It's no longer in the mount options.

 Any help is appreciated. Thanks,
 Henning




 server ~ # sync; time sync
 real	0m28.869s
 user	0m0.000s
 sys	0m5.750s



 server ~ # uname -a
 Linux server 2.6.39 #3 SMP Sat May 28 17:25:31 CEST 2011 x86_64 AMD 
 Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux



 server ~ # mount | grep btrfs
 /dev/sdb2 on / type btrfs (rw,noatime,compress=lzo,noacl)
 /dev/sda2 on /mnt/pool type btrfs (rw,noatime,subvolid=0,compress=lzo)
 /dev/sda2 on /usr/portage type btrfs 
 (rw,noatime,subvol=newportage,compress=lzo)
 /dev/sda2 on /home type btrfs (rw,noatime,subvol=home,compress=lzo)
 /dev/sda2 on /home/mythtv type btrfs 
 (rw,noatime,subvol=mythtv,compress=lzo)



 server ~ # btrfs fi show
 Label: none  uuid: 7676eb78-e411-4505-ac51-ccd12aa5a6b6
 	Total devices 2 FS bytes used 281.58GB
 	devid    1 size 931.28GB used 898.26GB path /dev/sda2
 	devid    3 size 931.27GB used 898.26GB path /dev/sdb2

 Btrfs v0.19-35-g1b444cd-dirty



 server ~ # btrfs fi df /
 Data, RAID1: total=875.00GB, used=279.30GB
 System, RAID1: total=8.00MB, used=140.00KB
 System: total=4.00MB, used=0.00
 Metadata, RAID1: total=23.25GB, used=2.28GB



 bonnie++

 Version  1.96       ------Sequential Output------ --Sequential Input- 
 --Random-
 Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
 --Seeks--
 Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  
 /sec %CP
 server          16G   147  90 76321  18 31787  16  1370  71 64812  14  
 27.0  66
 Latency             66485us    7581ms    4455ms   25011us     695ms     
 959ms
 Version  1.96       ------Sequential Create------ --------Random 
 Create--------
 server              -Create-- --Read--- -Delete-- -Create-- --Read--- 
 -Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  
 /sec %CP
                  16   238  51 +++++ +++   219  51   284  52 +++++ +++   
 390  57
 Latency              1914ms     524us    3461ms    1141ms      39us    
 1308ms
 1.96,1.96,server,1,1308618030,16G,,147,90,76321,18,31787,16,1370,71,64812,14,27.0,66,16,,,,,238,51,+++++,+++,219,51,284,52,+++++,+++,390,57,66485us,7581ms,4455ms,25011us,695ms,959ms,1914ms,524us,3461ms,1141ms,39us,1308ms

--=_b12d200ba7c04e438dabfa5e5de902e5
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=sequential-writes.txt
Content-Disposition: attachment;
 filename=sequential-writes.txt

c2VydmVyIH4gIyBpb3N0YXQgLW0gNQoKYXZnLWNwdTogICV1c2VyICAgJW5pY2UgJXN5c3RlbSAl
aW93YWl0ICAlc3RlYWwgICAlaWRsZQogICAgICAgICAgIDMuMDAgICAgMC4wMCAgIDQ1LjIwICAg
IDUuMjAgICAgMC4wMCAgIDQ2LjYwCgpEZXZpY2U6ICAgICAgICAgICAgdHBzICAgIE1CX3JlYWQv
cyAgICBNQl93cnRuL3MgICAgTUJfcmVhZCAgICBNQl93cnRuCnNkYSAgICAgICAgICAgICAgIDAu
MDAgICAgICAgICAwLjAwICAgICAgICAgMC4wMCAgICAgICAgICAwICAgICAgICAgIDAKc2RiICAg
ICAgICAgICAgICAxNS4yMCAgICAgICAgIDAuMDYgICAgICAgICAwLjAwICAgICAgICAgIDAgICAg
ICAgICAgMAptZDAgICAgICAgICAgICAgICAwLjAwICAgICAgICAgMC4wMCAgICAgICAgIDAuMDAg
ICAgICAgICAgMCAgICAgICAgICAwCgphdmctY3B1OiAgJXVzZXIgICAlbmljZSAlc3lzdGVtICVp
b3dhaXQgICVzdGVhbCAgICVpZGxlCiAgICAgICAgICAgNC4zMCAgICAwLjAwICAgMzcuNDYgICA0
Mi4zNiAgICAwLjAwICAgMTUuODgKCkRldmljZTogICAgICAgICAgICB0cHMgICAgTUJfcmVhZC9z
ICAgIE1CX3dydG4vcyAgICBNQl9yZWFkICAgIE1CX3dydG4Kc2RhICAgICAgICAgICAgICA0NS4w
MCAgICAgICAgIDAuMDAgICAgICAgICAwLjM4ICAgICAgICAgIDAgICAgICAgICAgMQpzZGIgICAg
ICAgICAgICAgNDY3LjYwICAgICAgICAgMC4wMiAgICAgICAgIDIuMDYgICAgICAgICAgMCAgICAg
ICAgIDEwCm1kMCAgICAgICAgICAgICAgIDAuMDAgICAgICAgICAwLjAwICAgICAgICAgMC4wMCAg
ICAgICAgICAwICAgICAgICAgIDAKCmF2Zy1jcHU6ICAldXNlciAgICVuaWNlICVzeXN0ZW0gJWlv
d2FpdCAgJXN0ZWFsICAgJWlkbGUKICAgICAgICAgICA0LjMxICAgIDAuMDAgICAxOS4zNCAgIDU4
LjgyICAgIDAuMDAgICAxNy41NAoKRGV2aWNlOiAgICAgICAgICAgIHRwcyAgICBNQl9yZWFkL3Mg
ICAgTUJfd3J0bi9zICAgIE1CX3JlYWQgICAgTUJfd3J0bgpzZGEgICAgICAgICAgICAgICA4Ljgw
ICAgICAgICAgMC4wMCAgICAgICAgIDAuMDQgICAgICAgICAgMCAgICAgICAgICAwCnNkYiAgICAg
ICAgICAgICA2NDkuODAgICAgICAgICAwLjAyICAgICAgICAgMi42NyAgICAgICAgICAwICAgICAg
ICAgMTMKbWQwICAgICAgICAgICAgICAgMC4wMCAgICAgICAgIDAuMDAgICAgICAgICAwLjAwICAg
ICAgICAgIDAgICAgICAgICAgMAoKYXZnLWNwdTogICV1c2VyICAgJW5pY2UgJXN5c3RlbSAlaW93
YWl0ICAlc3RlYWwgICAlaWRsZQogICAgICAgICAgIDMuMjAgICAgMC4wMCAgIDYzLjI0ICAgMzEu
OTcgICAgMC4wMCAgICAxLjYwCgpEZXZpY2U6ICAgICAgICAgICAgdHBzICAgIE1CX3JlYWQvcyAg
ICBNQl93cnRuL3MgICAgTUJfcmVhZCAgICBNQl93cnRuCnNkYSAgICAgICAgICAgICA1ODUuODAg
ICAgICAgICAwLjAwICAgICAgICAgMi4zNiAgICAgICAgICAwICAgICAgICAgMTEKc2RiICAgICAg
ICAgICAgICAyMC44MCAgICAgICAgIDAuMDggICAgICAgICAwLjE2ICAgICAgICAgIDAgICAgICAg
ICAgMAptZDAgICAgICAgICAgICAgICAwLjAwICAgICAgICAgMC4wMCAgICAgICAgIDAuMDAgICAg
ICAgICAgMCAgICAgICAgICAwCgphdmctY3B1OiAgJXVzZXIgICAlbmljZSAlc3lzdGVtICVpb3dh
aXQgICVzdGVhbCAgICVpZGxlCiAgICAgICAgICAgMy4zMCAgICAwLjAwICAgNDIuNjAgICAzOS4z
MCAgICAwLjAwICAgMTQuODAKCkRldmljZTogICAgICAgICAgICB0cHMgICAgTUJfcmVhZC9zICAg
IE1CX3dydG4vcyAgICBNQl9yZWFkICAgIE1CX3dydG4Kc2RhICAgICAgICAgICAgIDUxNC4yMCAg
ICAgICAgIDAuMDAgICAgICAgICAyLjI5ICAgICAgICAgIDAgICAgICAgICAxMQpzZGIgICAgICAg
ICAgICAgIDU5LjIwICAgICAgICAgMC4xMCAgICAgICAgIDAuMTcgICAgICAgICAgMCAgICAgICAg
ICAwCm1kMCAgICAgICAgICAgICAgIDAuMDAgICAgICAgICAwLjAwICAgICAgICAgMC4wMCAgICAg
ICAgICAwICAgICAgICAgIDAKCgo=
--=_b12d200ba7c04e438dabfa5e5de902e5--

