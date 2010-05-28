From: gmack@innerfire.net
Subject: linux 2.6.34 raid1 btrfs weird mounting issue
Date: Fri, 28 May 2010 14:45:27 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.1005281439280.26232@mtl.rackplans.net>
References: <alpine.DEB.1.10.1005271527320.19767@mtl.rackplans.net> <m3hblti0my.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3hblti0my.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had my raid set to mount by uuid but that randomly doesn't work so I 
changed to mounting by the first partition in the raid.. that worked but 
on the next reboot it failed.  Changing the mount to the second partition 
worked until the next reboot when I needed it to change it back to the 
first.  Each change seems to last for one reboot.


# mount /dev/sdb1  /home
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# mount /dev/sdb1  /home
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

mount /dev/sdc1  /home
(worked)
# btrfs-show
failed to read /dev/sr0
Label: none  uuid: a2aa44b8-3168-480a-a155-d510e05853e7
        Total devices 1 FS bytes used 5.46GB
        devid    1 size 29.33GB used 13.29GB path /dev/sda2

Label: fhome  uuid: 128ddab5-224d-4f45-abc0-6a07d0f63d47
        Total devices 2 FS bytes used 8.24GB
        devid    1 size 931.51GB used 21.03GB path /dev/sdb1
        devid    2 size 931.51GB used 21.01GB path /dev/sdc1


	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
