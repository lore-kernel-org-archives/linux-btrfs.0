From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs Partition Reaches 'Disk Full' Early
Date: Thu, 4 Feb 2010 11:21:28 -0500
Message-ID: <20100204162128.GB10300@dhcp231-156.rdu.redhat.com>
References: <26a1f7961002031843t665677aeh53e5b7cc6aaab6a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <26a1f7961002031843t665677aeh53e5b7cc6aaab6a6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 03, 2010 at 08:43:58PM -0600, Mitch Harder wrote:
> I've been trying to get a handle on where my Btrfs partition would run
> out of room, and I'm reaching the 'no space left' point earlier than I
> was expecting.
> 
> I'm running the btrfs-unstable.git version as of commit 035fe03a Thu,
> 28 Jan 2010 21:20:39 (Btrfs: check total number of devices when
> removing missing) back-ported to a 2.6.32 kernel.
> 
> Also, I've manually added Josef Bacik's 'btrfsctl -i' patches to get
> more information about the state when full.
> 
> I'm using a single 13.4GB partition as a root partition for a Sabayon
> Linux system.  With the btrfs file system ~59% full, I booted to
> another partition, and filled the remainder of the space using 'dd'
> (dd if=/dev/urandom of=/<path-to-btrfs-mounted-partition>/randomdata
> bs=1024k) to see where I'd get a full-disk error.
> 
> A btrfs 'no space left' error is received with the 'df' command
> showing only 81% full.
> 
> 'df -T' reports:
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sda5    btrfs    14008648  11314552   2694096  81% /mnt/sabayon-btrfs
> 
> The dmesg disk full error reported:
> [ 1606.386085] no space left, need 1048576, 89128960 delalloc bytes,
>  10639556608 bytes_used, 3981312 bytes_reserved, 0 bytes_pinned,
>  0 bytes_readonly, 0 may use 10733551616 total
> 
> Josef Bacik's 'btrfsctl -i' command reported:
> # btrfsctl -i /mnt/sabayon-btrfs/
> Metadata, DUP: total=1.67GB, used=813.89MB
> System, DUP: total=8.00MB, used=4.00KB
> Data: total=10.00GB, used=10.00GB
> Metadata: total=8.00MB, used=0.00
> System: total=4.00MB, used=0.00
> operation complete
> Btrfs Btrfs v0.19
> 
> Using 'btrfsctl -i', I'm still having trouble closing the loop on disk
> utilization.  10.00 GB Data + 1.67 GB Metadata = 11.67GB.  Since this
> is a 13.4GB partition, I'm still missing ~1.7GB, based on the
> 'btrfsctl -i' reporting.
> 
> Is 1.67 GB reserved for Metadata about what might be expected for a
> messy root partition with ~10GB of files?

Sorry I guess I should have fixed df -i to print the actual disk space used.
Anything with 'DUP' as the identifier means you need to take the totals it gives
you and multiply by 2, because all that data is duplicated.  So in your case you
have

> Metadata, DUP: total=1.67GB, used=813.89MB
> System, DUP: total=8.00MB, used=4.00KB

So really you have 3.34 gb total disk space reserved for metadata, and you are
using 1.58 gb of that total space.  Same goes for System, you really have 16 mb
reserved and are using 8 kb.

Now if you don't want to use the metadata duplication feature of btrfs, then you
can do 

mkfs.btrfs -m single /dev/whatever

and you won't end up with duplicate metadata.  Thanks,

Josef
