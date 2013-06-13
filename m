Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52780 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab3FMHmZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 03:42:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Un2Ap-0000Jc-5S
	for linux-btrfs@vger.kernel.org; Thu, 13 Jun 2013 09:42:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 09:42:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 09:42:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: can't mount a newly created fs after reboot
Date: Thu, 13 Jun 2013 07:42:05 +0000 (UTC)
Message-ID: <pan$cd3a5$681cfc5c$4ba83ac1$212a4c18@cox.net>
References: <20130612205303.308095ca@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 12 Jun 2013 20:53:03 +0900 as excerpted:

> I've created two btrfs fileystems using these commands:
> 
> mkfs.btrfs -d raid1 -m raid1 -L btrfs1 /dev/sda5 /dev/sdb5
> mkfs.btrfs -d raid1 -m raid1 -L btrfs2 /dev/sdc1 /dev/sdd1

So dual-device btrfs raid1 both data/metadata.

> 
> Then, added these to /etc/fstab:
> 
> LABEL=btrfs1 /mnt/btrfs1 btrfs noatime,compress-force=zlib 0 0
> LABEL=btrfs2 /mnt/btrfs2 btrfs noatime,compress-force=zlib 0 0
> 
> I mounted these filesystems with:
> 
> mount -a
> 
> 
> And enabled quotas:
> 
> btrfs quota enable /mnt/btrfs1 btrfs quota enable /mnt/btrfs2
> 
> 
> I'm using Linux 3.9.5.
> 
> 
> After that I've rebooted and I'm no longer able to mount these two
> fileystems

[snip dmesg segments]

> Is it expected behaviour that the fs is mountable only once?

First an answer then a recommendation/pointer to more:

Before mounting multi-device btrfs filesystems you need to run...

btrfs device scan

... so the system can find all the necessary devices to activate as part 
of the multi-device filesystem.

This is sort of a hack around the fact that the normal kernel assumption 
for a filesystem is that it consists of only a single device, which btrfs 
violates in the multi-device filesystem cases.  (In the case of RAID, 
etc, the "single device" may be a single /virtual/ device consisting of 
several physical devices, where the virtual device must be assembled/
activated before the filesystem can be mounted or there's similar issues.)

Some distros already run btrfs device scan automatically as part of their 
pre-mount bootscripts and/or initramfs and/or udev actions, and that 
seems to be the case here (where it's either the btrfs support module in 
the dracut-generated initramfs or udev, as I'm reasonably familiar with 
the bootscripts and can't see it in them), but not all distros will be 
handling that yet.

And the process of creating the filesystems in the first place also gives 
the system the requisite data it needs, explaining why it worked for you 
initially, but not after a reboot without btrfs device scan.

If running the scan before mount is inconvenient, it's also possible to 
enumerate the devices directly in the mount options themselves using the 
device= option as many times as necessary, thus making the above fstab 
entries look like this (lines wrapped for posting):

LABEL=btrfs1 /mnt/btrfs1 btrfs
 noatime,compress-force=zlib,device=/dev/sda5,device=/dev/sdb5 0 0

LABEL=btrfs2 /mnt/btrfs2 btrfs
 noatime,compress-force=zlib,device=/dev/sdc1,device=/dev/sdd1 0 0


An additional caveat that's worth mentioning even tho it doesn't apply to 
the two-device-filesystem case -- btrfs so-called raid1 mode is *NOT* 
raid1 in the traditional sense.  It's simply two-way-mirrored data.  
Thus, if you add a third device to your btrfs "raid1" and rebalance, you 
will *NOT* get three-way-redundant data/metadata and the ability to lose 
two of the three devices without data loss, you'll get more space but 
still only single-device-loss tolerance, since data/metadata will still 
only be two-way-mirrored, not three-way across all devices.  (N-way-
mirroring is planned, but it was to be added after raid5/6, which was 
delayed and has just been added, so in a few more kernel cycles...)

And one more, the obligatory "btrfs is a development filesystem and still 
experimental" caveat.  Thus, either don't use it for data you'd miss at 
all, or make even more sure than you would on a stable filesystem that 
you have backups to a degree appropriate to the inconvenience the loss of 
the data would mean to you.  Backup your backups, preferably with at 
least one copy on non-btrfs, just in case.


Meanwhile, the fact that you didn't know the above is a hint that you may 
not know about the btrfs wiki either.  That's worrying as it covers all 
sorts of btrfs information basics /like/ btrfs device scan, that you're 
likely to find useful working with btrfs, particularly multi-device 
btrfs.  If you do already know about the wiki, perhaps you need to go 
back and re-read, as this really is quite basic information that's 
covered on the wiki, and if you missed this, you likely missed a lot of 
other info that'll prove helpful over time as well.  (Look at the 
information in sections 4.1 and 4.3, Guides and usage information, Using 
the built-in tools, especially.)

https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

