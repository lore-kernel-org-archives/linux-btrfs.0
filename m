From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: minor ID for btrfs-control
Date: Sun, 03 Apr 2011 00:35:28 +0200
Message-ID: <4D97A4B0.6010207@libero.it>
References: <Bj4lB4gT1uB@helmut.hullen.de>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj4lB4gT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2011 06:45 PM, Helmut Hullen wrote:
> Hallo,
> 
> if I've understood some mails in this list correct, then btrfs needs a  
> character device "btrfs-control"  with the ID 10:55
> 
> When I look for this device in
> 
>         /sys/class/misc/btrfs-control/dev
> 
> I see 10:234
> 
> And when I run the command
> 
>   mkfs.btrfs -d raid0 -m raid1 /dev/sda1 /dev/sdc1
> 
> I get the error messages
> 
>   failed to open /dev/btrfs-control skipping device registration
> 
> ---
> 
>   ls -l /dev/bt*
> 
> shows
> 
>   crw-rw-rw- 1 root root 10,55 2. Apr 17:55 /dev/btrfs-control
> 
> ---
> 
> Kernel 2.6.38.1 (self made), no udev, no initrd, no tempfs. btrfs from  
> nov. 2010
> 
> What goes wrong?

As wrote by Tomasz the minor number of the btrfs-control is allocated
dynamically. A lot of drivers create a device which is registered
dynamically in the "misc" group. In linux this is a well established
behavior from a long time.

If you don't want to use udev you have two choices:
- use devtmpfs
- create manually a device. But nobody guarantee that the minor/major
will not  change.



> 
> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

