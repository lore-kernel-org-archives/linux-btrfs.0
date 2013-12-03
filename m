Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34899 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3LCNW4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Dec 2013 08:22:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VnpwB-0003h0-0S
	for linux-btrfs@vger.kernel.org; Tue, 03 Dec 2013 14:22:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 14:22:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 14:22:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Date: Tue, 3 Dec 2013 13:22:29 +0000 (UTC)
Message-ID: <pan$a94a7$40cf79d0$e6eb9695$6d10ceb2@cox.net>
References: <1531404.tFNCiHaLVH@linux-suse.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Szőts Ákos posted on Tue, 03 Dec 2013 12:28:26 +0100 as excerpted:

> Dear list members,
> 
> I'm not sure if this a bug or an intended behaviour, since I've yet to
> find a reliable source with Google search.
> 
> My problem is the following: with the 3.12 kernel on every single boot
> (even when the computer was shut down clear) the process
> [btrfs-ino-cache] is preventing the successful startup of X because it's
> running for 6 minutes.
> 
> I can see this in "iotop" and while that program runs the whole system
> is being blocked. After 6 minutes I restart X and everyting goes normal
> from that point on.
> 
> My question is: is that necessary to regenerate the inode cache on every
> boot or is this a bug? Of course if I remove the "inode_cache" option
> from fstab, this phenomenon disappears.
> 
> Versions:
> - OS: openSUSE 13.1 - Kernel: 3.12.0-6.ge7c00d8-desktop #1 SMP PREEMPT
> Tue Nov 12 13:09:24 UTC 2013 (e7c00d8)
> - Mount options: compress=lzo,space_cache,inode_cache,noatime

>From what I've seen (as a btrfs using admin and list regular, /not/ a 
dev, btrfs or otherwise), the inode_cache mount option isn't intended or 
recommended for general purpose use.  Its intended purpose is, I believe, 
for cases such as mail servers, for example, where a sluggish startup 
isn't a big issue, but where quickly and efficiently creating/deleting 
lots of little files is part of the job description.

The general recommendation thus appears to be to omit the inode_cache 
mount option unless your use-case requires it, and the X-based user 
desktop use-case almost certainly doesn't.


Meanwhile, briefly on the other options:  While continuous use of the 
space_cache option won't hurt anything, it really only needs turned on 
once, after which it's on permanently unless you specifically disable it 
again.  Noatime's a good choice on most filesystems, but especially btrfs 
if you're using snapshotting (as I believe OpenSuSE makes heavy use of), 
so good choice there.  And I'm using compress=lzo here too. =:^)

You may wish to consider adding autodefrag also, altho if you've not been 
running with it from the beginning, performance may be bad for awhile 
until it has caught back up with existing fragmentation, but then it 
should be better.  One way around that is to defrag (or rebalance, which 
rewrites everything and thus defrags in the process) everything, which 
could take awhile on a multi-terabyte spinning-rust drive, then mount 
with autodefrag from then on, to avoid heavy fragmentation happening 
again.  That used to require a rather convoluted command, but a new 
enough btrfs-progs and kernel should let you use the btrfs filesystem 
defrag -r (recursive) option. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

