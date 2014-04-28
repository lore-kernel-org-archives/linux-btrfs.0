Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38823 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaD1D06 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 23:26:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WecDZ-0005aY-8W
	for linux-btrfs@vger.kernel.org; Mon, 28 Apr 2014 05:26:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 05:26:57 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 05:26:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "kernel BUG at
 =?us-ascii?Q?=2Fhome=2Fapw=2FCOD=2Flinux=2Ffs=2Fbtrfs=2Fextent=5Fio?=
 =?us-ascii?Q?=2Ec=3A2116!=22?= when deleting device or balancing
 filesystem.
Date: Mon, 28 Apr 2014 03:26:45 +0000 (UTC)
Message-ID: <pan$2abc$efe882ea$fdd493d$5779ebd8@cox.net>
References: <C25AA8A9-30B0-4D00-80B5-B681D93D67A3@pieroen.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jaap Pieroen posted on Sun, 27 Apr 2014 18:30:19 +0200 as excerpted:

> Hello,
> 
> When I try to delete a device from my btrfs filesystem I always get the
> following kernel bug error:

> kernel BUG at /home/apw/COD/linux/fs/btrfs/extent_io.c:2116!
> invalid opcode: 0000 [#3] SMP
> See attached log file for more details.

That's a reasonably common, generic error, simply indicating the kernel 
got an invalid/zero opcode instead of what it was supposed to get, but 
not really saying why, tho the log does give some more info.

In the log, it relocates various block groups, but then fails on one, due 
to invalid checksum (csum).  See below for the implications of that.

> I’m trying to delete the device /dev/sdb from my filesystem.
> 
> Steps I tried so far are:
> 1. mount with the clear_cache option
> 2. balance the filesystem (results in the same kernel error)
> 3. scrub the filesystem
> 4. btrfsck —repair

Never use btrfsck (or btrfs check) with the --repair option, unless 
you're about ready to give up on the filesystem and do a mkfs, in which 
case you aren't risking anything anyway, or unless a dev suggests you run 
it.

The reason being, btrfs check --repair knows how to fix some types of 
errors, but among the ones it doesn't know how to fix, it can sometimes 
make the problem worse.  At some point it should know most problems and 
at least not make them worse, but until then, it's not a good risk to 
take unless  you really know what you're doing or it's no risk as the 
next step is blowing away the filesystem anyway.

(btrfs check, without --repair, is fine to run, since it's read-only and 
thus won't make anything worse.  But by the same token, it won't fix 
anything either, it's simply informational.)

> During scrubbing and btrfsck some error where found and fixed. But I
> think these where error caused by system lockups during copying data to
> the new btrfs filesystem. These lockups where caused by an extraordinary
> amount of hard links, since I was using rsnapshot to create hourly
> snapshots on my old filesystem that I am migrating towards btrfs.
> Removing these hard links solved the lockup problems.
> 
> Something I also noted was that after the btrfsck run, the command
> ‘btrfs fi show’ reported
> “devid    4 size 0.0GiB used 98.00GiB path /dev/sdb” (mind the 0.0GB).
> 
> I’m ready to run any diagnostics necessary, but the filesystem is 4.7T
> so it won’t be able to provide an image.
> 
> System details:
> $ uname -a Linux nasbak 3.14.1-031401-generic

Good, latest stable kernel. =:^)

> $ btrfs --version
> Btrfs v3.12

You're behind on btrfs-tools.  =:^(  The latest version is v3.14.1.

> $ sudo btrfs fi show
> Label: btrfs_storage  uuid: 7ca5f38e-308f-43ab-b3ea-31b3bcd11a0d
> 	Total devices 6 FS bytes used 4.57TiB
> 	devid    1 size 1.82TiB used 1.32TiB path /dev/sde
> 	devid    2 size 1.82TiB used 1.32TiB path /dev/sdf
> 	devid    3 size 1.82TiB used 1.32TiB path /dev/sdg
> 	devid    4 size 931.51GiB used 88.00GiB path /dev/sdb
> 	devid    6 size 2.73TiB used 947.03GiB path /dev/sdh
> 	devid    7 size 2.73TiB used 947.03GiB path /dev/sdi
> 	
> Btrfs v3.12

For further reference, whenever you post btrfs fi show, please post btrfs 
fi df as well, as the two provide complementary information, and the 
picture without both of them is incomplete.

If you'd supplied the btrfs fi df output, we could see what raid level 
you're running for data/metadata/system, as well as which type of chunks 
were still left on /dev/sdb.

For raid1 and raid10 modes (and dup mode on a single device), there's two 
copies of each chunk, thus a second copy to try if the checksum fails.   
Single and raid0 modes only keep a single copy, so there's not much to do 
there but find the corresponding file and delete it, to correct the 
problem.  In normal operation, if such a checksum error is found and 
there is a second copy that passes checksum, the invalid copy is 
rewritten to match.  What scrub does is go thru the entire filesystem 
looking for such errors and rewriting the invalid copy if possible, so 
you don't have to wait until you happen on the problem by accident.

You mentioned that you did try scrub and that it fixed some errors, which 
would be csum errors.  But did it leave any unfixed because there wasn't 
a second, valid copy of the invalid data with which to rewrite it?  If it 
found and fixed all the errors, then you shouldn't be seeing further csum 
errors like those in the log file, unless more are being created, which 
would indicate an ongoing problem (perhaps a device going bad).

Of course the kernel bug is presumably locking up your system, not 
allowing a clean shutdown, in which case you may well have more csum 
errors due to that.  So after rebooting, be sure to run a scrub before 
you try to balance or device delete, and hopefully eliminate the problem.

But... since you didn't post the df output, we don't know what the 
remaining content on the device is, data/metadata/system, nor do we know 
what mode it is, and it could well be that scrub can't remove it due to 
invalid csums if there's no second, valid copy, as will definitely be the 
case if it's single or raid0 mode (with data chunks being single by 
default, tho metadata and system chunks default to raid1 on a multi-
device filesystem and dup on a single-device filesystem).

If there's no valid second copy to rewrite the bad one with, you may 
simply have to figure out what file and/or snapshot(s) it belongs to and 
delete them, fixing the bad csums that way.

Of course that's assuming it's the bad csums causing the problem, not 
something else.

Meanwhile, while I don't claim to be a dev nor to /really/ read code, I 
did see some recent patches go by with comments that described bugs that 
looked to me like they might match the problem you're reporting here, 
specifically, failure to properly device delete under some conditions.  
So I'd suggest updating to a current btrfs-progs v3.14.1 and see if that 
helps.  If not, try a current v3.15-rcX testing kernel, or if you don't 
want to try that, wait a couple stable kernel releases and see if there's 
any btrfs patches applied.

With a bit of luck, between tracking down and eliminating the bad csums, 
and the newer code that I think fixes at least some of the failure to 
device delete issues, the problem will be addressed. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

