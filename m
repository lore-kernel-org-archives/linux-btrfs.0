From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs error: 'disk full' although 8 of 21 GB free
Date: Wed, 7 Apr 2010 11:48:23 -0400
Message-ID: <20100407154823.GA2315@localhost.localdomain>
References: <201004071659.03927.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Marek Otahal <markotahal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201004071659.03927.markotahal@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 07, 2010 at 04:59:02PM +0200, Marek Otahal wrote:
> Hi, 
> I'm running archlinux, kernel 2.6.33.2, btrfs-progs 0.19. 
> I was copying a folder (cca 2GB) to a btrfs partition(8GB free) and got a 
> 'disk full' error message. Had to kill the process and remove the files 
> otherwise apps report full disk. 
> I can always reproduce this by creating some big files on the partition. 
> Since then, btrfsck reports errors, is there a way to fix them? 
> Thank you, Mark
> 
> // here follows contents of files attached for your comfort
> 
> Here are some clues: 
> 
> *output of df -h: 
> 
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda5              20G   13G  6.0G  68% /
> udev                   10M  248K  9.8M   3% /dev
> none                  1.0G     0  1.0G   0% /dev/shm
> /dev/mapper/homeDevice
>                        21G   13G  8.0G  62% /home
> tmpfs                 3.0G   29M  3.0G   1% /tmp
> /dev/sda8             3.4G  2.3G  976M  71% /var
> /dev/sda2             145M   20M  118M  15% /boot
> /dev/mapper/storeDevice
>                        40G   38G  2.0G  96% /mnt/store
> /dev/sda10             18G  9.1G  7.4G  56% /mnt/recovery
> /dev/sda12            9.8G  9.6G  206M  98% /media/disk
> /dev/sda1              30G   22G  7.5G  75% /mnt/winxp
> 
> * I've heard df has issues with btrfs, but du -sh /mountpoint reports approx 
> same size used
> 
> *btrfsck /dev/mapper/homeDevice - is there a way to fix these errors?? I'm 
> worried to take snapshots or defragment not to make it worse. 
> 

Some work has been done in this area recently.  Can you run with the latest
btrfs-unstable tree?  Df will tell you something that is more along the lines
with what you are expecting, and you can use the new btrfs-progs-unstable tree
and run a 

btrfs filesystem df /mount/point

and it will spit out specific space info that will be helpfull.  Thanks,

Josef
