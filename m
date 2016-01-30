Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59059 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbcA3F67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 00:58:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aPOYh-0000lc-PJ
	for linux-btrfs@vger.kernel.org; Sat, 30 Jan 2016 06:58:55 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 06:58:55 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 06:58:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: csum failed : d-raid0, m-raid1
Date: Sat, 30 Jan 2016 05:58:45 +0000 (UTC)
Message-ID: <pan$75b98$f785acae$3724509e$fea963e1@cox.net>
References: <CAAcrkYJmDHNijZx45cdfZNTgVCgvih_06WROGJg+pjYsQT-=tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Smith posted on Fri, 29 Jan 2016 19:04:42 +0100 as excerpted:

> Hi
> 
> i built btrfs volume using 2x3tb brand new /tested for badblocks drives.
> I copied into volume around 5Tb of data.
> 
> I tried to read one file which is around 4GB and i got input / output
> error.
> 
> Dmesg contains:
> 
> [154159.040059] BTRFS warning (device sdd): csum failed ino 9995246 off
> 4506214400 csum 383964635 expected csum 6478505
> 
> 
> Any idea what is it? Whats the reason that this happened? Can I recover?

Btrfs crc32c-checksums all blocks on write, both data (except for data 
written while mounted nodatasum and nocow attribute files) and metadata 
(always), and verifies the checksum on read.

The read-time csum verification failed on the block at that address of 
the file, and as your data is raid0, there's no second copy to fall back 
on as there would be for raid1 data and no parity data available to try 
to rebuild from as there'd be for raid56 data, so the file can only be 
read upto that point, and if you skip that block, and there are no 
further checksum failures, beyond that point, to the end of the file.

Of course the sysadmin's first rule of backups, in simplest form, is that 
if you don't have at least one backup, you are by your failure to backup 
defining the value of the data as less than the value of the time/hassle/
resources you'd otherwise spend making that backup, so you either have a 
backup to fallback to, or you're data is self-defined by that lack of a 
backup as of only trivial value not worth the trouble.

And of course, btrfs, while stabilizING, isn't yet considered fully 
stable and mature, so that sysadmin's rule of backups applies to an even 
stronger degree than it does to fully stable and mature filesystems.

As a result, for recovery, you can either fall back to the backup, 
rewriting the file from backup to the btrfs in question, or by action you 
defined the data as too trivial to be worth backing up, so you can simply 
delete the file in question and not worry about it.

The question then becomes one of finding out what file is involved, in 
ordered to either delete it or recover it from backup.  Keep in mind that 
unlike most filesystems, inode numbers on btrfs are subvolume-specific, 
so it's possible to have multiple inodes with the same inode number on 
the filesystem, if you have multiple subvolumes.  Thus, it's not as 
simple as looking up what file that inode corresponds to, unless of 
course you have only the primary/root subvolume, no others.

There are two ways to find what file corresponds to that inode on that 
subvolume.  One involves use of the btrfs debugging tools and is targeted 
at devs.  While I know this is possible and I've seen the method posted, 
I'm not a dev, only a btrfs user and list regular, and I've not kept 
track of the specifics, so I won't attempt to describe them further here.

The other one is btrfs scrub, which will systematically verify all 
checksums on the filesystem, repairing errors where it's possible 
(metadata in your case as it's raid1, assuming of course that the second 
copy of the block isn't also bad), reporting those which it can't (the 
raid0 data).  Where it can't fix the problem dmesg should contain the 
file with the problem (unless it's metadata and thus not a file, of 
course).

Of course on 5 TB of data, scrub's going to take awhile... likely over a 
day and possibly two (5 TiB of data at 30 MiB/sec is about 48 hours, 30 
MiB/sec might be a bit pessimistically slow but isn't out of real-world 
range on spinning rust).  Even on relatively fast (for spinning rust) 
drives, 100 MiB/sec, you're looking at 14 hours...

Tho because scrub checksum-verifies all blocks, it'll cover any problems 
in other files and in metadata too, not just the one file.

FWIW, maintenance time is one of several reasons I use multiple smaller 
btrfs on partitioned up devices, here, instead of a single huge multi-TB 
btrfs.  My btrfs are also all raid1 both data and metadata, save for 
/boot (and its backup on the other device) which are both mixed-mode dup, 
two copies on the same device, so there's always that second copy to pull 
from to repair the failed one, if something fails checksum verification.  
They also happen to be on SSD, with the largest btrfs on a pair of 24 GiB 
partitions.  As such, scrubs, balances, checks, etc, all take under 10 
minutes per filesystem, with scrubs often complete in under a minute, 
instead of the day or longer it's likely to take you for 5 TiB on 
spinning rust.  Of course I have more btrfs and it'd take me somewhat 
longer than that minute to do just one, say a half hour, to scrub them 
all, but some of them aren't even routinely mounted, and my 8 GiB (per 
device, two devices) btrfs raid1 / is mounted read-only by default, so it 
too is unlikely to be damaged.  As such, generally only 2-3 btrfs need 
scrubbed at once and often it's only 1-2, and on fast SSD, I'm done in 
under 5 minutes.  /Much/ more feasible maintenance time than several 
/days/! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

