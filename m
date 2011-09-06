From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Any chance to recovery btrfs raid-0 after accidental format of
 one volume?
Date: Tue, 06 Sep 2011 08:24:32 +0200
Message-ID: <4E65BCA0.40109@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Bad case of user error here but I managed to reformat one half of a
> btrfs volume that was set up with metadata raid-1 and data raid-0.

It won't help you - but did you format it with mkfs.btrfs, while it was mounted?

mkfs.btrfs behaves very dangerously here.


For example, we have a block device in use:

# cat /proc/swaps 
Filename				Type		Size	Used	Priority
/dev/md0                                partition	10233276	0	-1


mkfs for other filesystems will refuse to touch it, because it's in use:

# mkfs.ext4 /dev/md0
mke2fs 1.41.14 (22-Dec-2010)
/dev/md0 is mounted; will not make a filesystem here!

# mkfs.xfs /dev/md0
mkfs.xfs: cannot open /dev/md0: Device or resource busy




mkfs.btrfs doesn't see a problem in creating a filesystem on a mounted block device:

# mkfs.btrfs /dev/md0

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/md0
	nodesize 4096 leafsize 4096 sectorsize 4096 size 9.76GB
Btrfs Btrfs v0.19



-- 
Tomasz Chmielewski
http://wpkg.org

