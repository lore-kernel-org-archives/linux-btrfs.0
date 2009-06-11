From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs SSD autodetection and mount options
Date: Thu, 11 Jun 2009 16:54:20 -0400
Message-ID: <20090611205420.GB3834@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

A quick update on the btrfs SSD modes.  The pull request I just to Linus
includes autodetection of ssd devices based on the queue rotating flag.
You can see this for your devices in /sys/block/xxx/queue/rotating

If all the devices in your FS have a 0 in the rotating flag, btrfs
automatically enables ssd mode.  You can turn this off with
mount -o nossd.

The default ssd flag tries to find rough groupings of blocks to allocate
on, and will try to pack blocks into the free space available.  So,
if you have something like this (pretending a bitmap of free blocks)

free | free | used | free | used | free | free | used

Btrfs SSD mode will collect a large region of mostly free blocks and
allocate from that.  This works well on newer and high end ssds that
prefer us to reuse blocks instead of spreading IO across the hole
device.

But, low end devices may have to do a read/modify/write cycle when we
actually do IO in this case.  I've added a new mount option for those
devices:

mount -o ssd_spread.  This is not autodetected, you still need to pass
it on the mount command line or in /etc/fstab.  In ssd_spread mode,
btrfs will try much harder to find a contiguous chunk of free blocks and
hand those out.

-chris

