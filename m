From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: linux 2.6.34 raid1 btrfs weird mounting issue
Date: Fri, 28 May 2010 21:06:18 +0200
Message-ID: <201005282106.19055.kreijack@libero.it>
References: <alpine.DEB.1.10.1005271527320.19767@mtl.rackplans.net> <m3hblti0my.fsf@pullcord.laptop.org> <alpine.DEB.1.10.1005281439280.26232@mtl.rackplans.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: gmack@innerfire.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1005281439280.26232@mtl.rackplans.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gerhard

On Friday, May 28, 2010, gmack@innerfire.net wrote:
> I had my raid set to mount by uuid but that randomly doesn't work so I 
> changed to mounting by the first partition in the raid.. that worked but 
> on the next reboot it failed.  Changing the mount to the second partition 
> worked until the next reboot when I needed it to change it back to the 
> first.  Each change seems to last for one reboot.


Do you perform a "scan" before mounting the first time (after a reboot) a 
multivolume btrfs filesystem ?
On the basis of your report it seems no.  

Btrfs requires to know where the components of a multi-volume filesystem are. 
To do that, you have to "scan" the devices, explicitly

	# btrfs scan /dev/sdX1 /dev/sdx2 ...

or implicitly

        # btrfs scan

In the last case the btrfs command scans every block device (even the cdrom 
and/or floppy).

For other information you may want to read this thread which suggests how udev 
can perform the scan.

http://kerneltrap.org/mailarchive/linux-btrfs/2010/4/16/6884594

Regards



> 
> 
> # mount /dev/sdb1  /home
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> # mount /dev/sdb1  /home
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> mount /dev/sdc1  /home
> (worked)
> # btrfs-show
> failed to read /dev/sr0
> Label: none  uuid: a2aa44b8-3168-480a-a155-d510e05853e7
>         Total devices 1 FS bytes used 5.46GB
>         devid    1 size 29.33GB used 13.29GB path /dev/sda2
> 
> Label: fhome  uuid: 128ddab5-224d-4f45-abc0-6a07d0f63d47
>         Total devices 2 FS bytes used 8.24GB
>         devid    1 size 931.51GB used 21.03GB path /dev/sdb1
>         devid    2 size 931.51GB used 21.01GB path /dev/sdc1
> 
> 
> 	Gerhard
> 
> 
> --
> Gerhard Mack
> 
> gmack@innerfire.net
> 
> <>< As a computer I find your faith in technology amusing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
