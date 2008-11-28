From: Yan Zheng <ukernel@gmail.com>
Subject: Re: Seed device questions
Date: Fri, 28 Nov 2008 21:19:01 +0800
Message-ID: <492FEFC5.2050009@gmail.com>
References: <492FC847.1090605@southpole.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jonas Bonn <jonas@southpole.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <492FC847.1090605@southpole.se>
List-ID: <linux-btrfs.vger.kernel.org>

Jonas Bonn wrote:
> Hi,
> I am trying the 'seed device' functionality, trying to get a read-only
> block-device to act as a seed for multiple other filesystems.
> 
> The following sequence works for setting up the first filesystem.
> 
> #-------------
> 
> #First initialize 'seed device'
> mkfs.btrfs /dev/vdb
> mount /dev/vdb /mnt
> btrfs -S subvol /mnt
> echo hello > /mnt/subvol/xxx
> umount /mnt
> 
> #Make block device a "seed device" (read-only)
> btrfstune -S 1 /dev/vdb
> 
> #Mount the seed device... it will be mounted read-only.
> mount /dev/vdb /mnt
> 
> #Add the writeable block device
> btrfs-vol -a /dev/vdc /mnt
> 
> #Now remount the filesystem read-write.
> mount -oremount,rw /mnt
> 
> #Now all changes to /mnt should go to /dev/vdc.
> 
> #--------------
> 
> After this, however, it's not possible to mount /dev/vdb again in order
> to set up a second filesystem as seed.  I want to do:
> 
> mount /dev/vdb /othermnt
> btrfs-vol -a /dev/vdd /othermnt
> mount -oremount,rw /othermnt
> 
> So my questions (comments):
> 
> i)  Is the seed-device _really_ read-only... no metadata updates or
> anything? (i.e. I can have my seed device on read-only media)
yes

> ii)  Should it be possible to have a device as a 'seed' for multiple
> other filesystems.
it's possible, but only one filesystem can be mounted at a time.
I will add 'mounting multiple filesystems at the same time' support
later.

> iii)  When the seeded filesystem is created, the size of the filesystem
> is the aggregate of all devices, whereas it should be the aggregate size
> of only the 'writable' devices.
>
Since btrfs mirrors metadata and creates chunk dynamically, how to
compute the size of filesystem isn't clear. I'm afraid I can't answer
this question.

Regards
Yan Zheng

