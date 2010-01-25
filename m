From: "Mr. Tux" <tuxoholic@hotmail.de>
Subject: Re: Howto mount intact left-over device of a degraded btrfs-raid?
Date: Mon, 25 Jan 2010 22:46:47 +0100
Message-ID: <BLU0-SMTP645D546639865D7DF323B2D85F0@phx.gbl>
References: <BLU0-SMTP89D73FD06036781FE98000D8640@phx.gbl> <20100125184326.GA2204@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100125184326.GA2204@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 25 January 2010 19.43:27 Josef Bacik wrote:
>
> How did you setup this array to begin with?  I'm trying to reproduce this
> bug but I haven't been able to.  Thanks,
>

Hi Josef,

Thanks for your help!

Linux Kernel 2.6.32.2 from kernel.org (was marked as stable at that time,  I 
compiled it using make-kpkg with btrfs support inside the kernel -> not 
modular)

OS: Debian Lenny 5.03

I created the btrfs raid on a two sata-II drives like this:

mkfs.btrfs -d raid1 -m raid 1 /dev/sda4 /dev/sdb4

Then I mounted the btrfs with:

mount /dev/sda4 /mnt/

cat /proc/mounts and dmesg showed the raid was mounted successfully

Then I started to copy large amount of data into the raid1 from a file server. 
With the copying process ongoing I detached the data cable from one device to 
simulate hardware failure. Copying process went on as planed to the drive 
still attached.

Then I unmounted the btrfs raid like this:

umount /mnt/

and I shut down the system.

Now the goal was to boot and mount only the intact btrfs partition again as a 
degraded raid.

I followed the multiple-device-wiki of btrfs [1]

I didn't try to remove the faulty device - I shut down the system already and 
booted again without the faulty drive. So I tried this:

mount -o degraded /dev/sda /mnt/

This caused a memory segfault - the system still ran, but I couldn't use the 
array any more.

So I used the next command

btrfs-vol -r missing /mnt

Complained it couldn't mount with only one member present.

My assumption: Bad luck with the kernel - or did this memory segfault happen 
on earlier kernel versions as well?

[1] 
http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_Failed_Devices

