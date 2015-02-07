Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56133 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbbBGS5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Feb 2015 13:57:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKAZE-0002rt-2i
	for linux-btrfs@vger.kernel.org; Sat, 07 Feb 2015 19:57:20 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Feb 2015 19:57:20 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Feb 2015 19:57:20 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: RAID1, SSD+non-SSD
Date: Sat, 07 Feb 2015 19:06:14 +0100
Message-ID: <mp0iqb-1f5.ln1@hurikhan77.spdns.de>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com> <CAJCQCtQn=HQU15D5qfS4ASR7HZM974f1p8xKQQCQRmR-NPXQ+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> On Fri, Feb 6, 2015 at 1:01 PM, Brian B <canis8585@gmail.com> wrote:
>> My laptop has two disks, a SSD and a traditional magnetic disk. I plan
>> to make a partition on the mag disk equal in size the SSD and set up
>> BTRFS RAID1. This I know how to do.
> 
> There isn't a write mostly option in btrfs like there is with md raid,
> so I don't know how Btrfs will tolerate one device being exceptionally
> slower than the other. It may be most of the time it won't matter, but
> I can imagine with a ton of IOPS backing up on the hard drive, having
> completed on the SSD, could maybe be a problem. I'd test it unless
> someone else who has pipes up.
> 
>>
>> The only reason I'm doing the RAID1 is for the self-healing. I realize
>> writing large amounts of data will be slower than the SSD alone, but
>> is it possible to set it up to only read from the magnetic drive if
>> there's an error reading from the SSD?
> 
> No.
>>
>> In other words, is there a way to tell it to only read from the faster
>> disk?  Is that even necessary?  Is there a better way to accomplish
>> this?
> 
> No. No. And maybe. In order.
> 
> If there is an error detected by either drive, or by Btrfs, Btrfs will
> get the correct data from the other drive and fix the problem on the
> original drive. You don't need to configure anything. The only concern
> is the asymmetric performance.
> 
> I think the use case is better achieved with two HDD's + two SSD
> partitions, configured either with bcache or dmcache. The result is
> two logical devices using HDDs as backing device and SSD partitions as
> cache, and then format them as Btrfs raid1. The question there of
> course, is maturity of bcache vs dmcache and their interactions with
> Btrfs. But at least that's supposed to work.

Bcache on multi-device btrfs works fine for me. No problems yet, even in 
case of hard-reset. I'm using normal desktop workload, some Steam games, 
some VMs, and some MySQL/PHP/Rails programming. A single bcache partition 
can support many backing device, so no need to use multiple partitions in 
that case. In this scenario, bcache{0,1,2} is my btrfs rootfs:

$ lsblk /dev/sdb
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb           8:16   0 119,2G  0 disk
├─sdb1        8:17   0   512M  0 part
├─sdb2        8:18   0    20G  0 part
├─sdb3        8:19   0  79,5G  0 part
│ ├─bcache0 252:0    0 925,5G  0 disk
│ ├─bcache1 252:1    0 925,5G  0 disk
│ └─bcache2 252:2    0 925,5G  0 disk /home
└─sdb4        8:20   0  19,2G  0 part

sdb3 is the cache device, sdb4 is trimmed and left untouched for SSD 
overprovisioning, sdb2 is a dedicated resume swap (traditional swapping goes 
to all there HDDs), sdb1 is my ESP to boot kernel and initramfs from.

Bcache takes some time to warm up but is really fast afterwards: Boot times 
(using systemd and readahead) went down from >60s (on spinning rust) to ~30s 
on first boot (system was migrated to bcache with dev del/add, not 
reinstalled), then ~15s, 10s, and now it fluctuates between 3 and 8s (mostly 
around 5s) for reaching graphical.target (depending on whether I installed 
updates). KDE takes some time to load but I suppose most of it is due to its 
artificial 4 second delay during initialization of kded and friends - I 
guess this will be fixed in KDE5. This boot target is not stripped down, it 
includes network, mysql, postfix and some other stuff that one either 
usually not needs or could be optimized away. The numbers are taken from 
"systemd-analyze critical-chain".

Bcache hit rate is usually between 60 and 80% using write-back. So after all 
I can generally recommend bcache. I don't know dmcache, tho. But I really 
suggest against using a mixed setup of SSD and HDD partitions in btrfs RAID 
mode, especially since btrfs does not handle different sized partitions that 
well. With bcache you can have your cake and eat it too (read: big storage 
pool + fast access times).

BTW: Is there work in progress to let btrfs choose which device to read from 
or write to other than using round-robin or pid mapping? Maybe it would be 
interesting to watch the current read and write latencies of all drives and 
choose the one with the lowest latency. Tho, I think it won't make much 
sense when passing accesses through btrfs.

-- 
Replies to list only preferred.

