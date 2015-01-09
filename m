Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55109 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbbAIWnX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 17:43:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9iH3-00040q-GW
	for linux-btrfs@vger.kernel.org; Fri, 09 Jan 2015 23:43:21 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 23:43:21 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 23:43:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Segfault in "btrfs balance start" due to kernel page allocation
 failure
Date: Fri, 9 Jan 2015 22:43:11 +0000 (UTC)
Message-ID: <pan$91b96$595041e4$b1777a9d$1c82bf25@cox.net>
References: <m8odfs$rv2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remy Blank posted on Fri, 09 Jan 2015 12:19:23 +0100 as excerpted:

> I have a btrfs filesystem that shows the following errors. This happens
> either when writing to the FS or when snapshotting, I'm not sure (this
> FS holds my backup, and I write to it with rsync and snapshot
> afterward).
> 
> Jan  8 13:54:33 twin kernel: BTRFS error (device dm-2):
> error inheriting props for ino 3828 (root 317): -28
> Jan  8 13:54:38 twin kernel: BTRFS error (device dm-2):
> error inheriting props for ino 17939 (root 317): -28

Just another user here, posting only to say I don't recall seeing a props 
inheritance error like that posted before.  Could be a new and 
interesting bug.

Also, when you post errors, please post kernel and btrfs-progs versions.  
I see from the trace that your kernel version is 3.17.7 so you're 
reasonably current there, but of course that doesn't give the userspace 
version.

And finally just a practical note.  Over time I've noticed that rsync 
seems to be involved in quite a few posted bugs, most of which have of 
course been fixed by now.  Rsync apparently stresses btrfs in ways few 
other tasks do, thus triggering more than its share of bugs that most 
other things don't tend to tickle.  I'm a gentooer myself, with (among 
other things) the main package tree rsynced to btrfs, and have seemed to 
escape these issues, but (1) all my btrfs are on SSD and thus likely 
escape some of the race conditions that trigger on spinning rust, and (2) 
I'm a strong believer in not putting all my data eggs in the same 
filesystem basket so I partition heavily, and all my partitions are 
relatively small (biggest btrfs 24 GiB, actually the gentoo tree, 
sources, and binpkgs partition).  Additionally, I prefer backups to 
identically sized partitions over snapshots (which are nice but if the 
filesystem has problems it takes all the snapshots with it), and thus 
don't tend to use the btrfs snapshots feature.  I suspect that has 
something to do with my relative scarcity of triggered btrfs issues, here.

So just be aware that rsync /does/ seem to stress btrfs more than most 
tasks, and try to plan/behave accordingly, perhaps avoiding rsync when 
possible, or keeping additional backups in case, and/or choosing 
something other than btrfs for at least one level of backups, etc.  (FWIW 
my non-btrfs level of backups here is reiserfs, the filesystem I used for 
years previously, which at least since the introduction of data=ordered 
back around kernel 2.6.16 or so, has done very well for me even thru 
hardware issues, etc.  Others on the list recommend xfs, but few seem 
particularly impressed with ext*, for whatever it's worth.  That last 
could simply be a biased sample, tho, as people involved in btrfs are I 
suspect less likely to be content with the traditional ext* status quo 
than the average Linuxer, but whatever the reason, cause or bias, ext* 
seems to get short shrift on this list.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

