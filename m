Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45129 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402AbaDITYR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 15:24:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXy6a-0003kt-AX
	for linux-btrfs@vger.kernel.org; Wed, 09 Apr 2014 21:24:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 21:24:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 21:24:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes
 in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
Date: Wed, 9 Apr 2014 19:24:04 +0000 (UTC)
Message-ID: <pan$67ab$c32b2852$4d6f351b$ebc1ebdd@cox.net>
References: <20140408153609.GE23524@merlins.org>
	<20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com>
	<20140409043125.GI10789@merlins.org> <20140409053139.GJ10789@merlins.org>
	<20140409154259.GM10789@merlins.org> <53456B45.8050906@fb.com>
	<20140409165134.GO10789@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 09 Apr 2014 09:51:34 -0700 as excerpted:

> But since we're talking about this, is btrfsck ever supposed to return
> clean on a clean filesystem?

FWIW, it seems to return clean here, on everything I've tried it on.

But I run relatively small partitions (the biggest is I believe 40 gig, 
my media partitions are still reiserfs on spinning rust, while all my 
btrfs partitions are on SSD and most are raid1 both data/metadata, with 
the exceptions (my normal /boot and the backup /boot on the other ssd in 
the pair that's btrfs raid1 for most partitions) being tiny mixed-data/
metadata dup), and keep them pretty clean, running balance and scrub when 
needed.

I had seen some scrub recoveries back when I was doing suspend-to-ram and 
the system wasn't reliably resuming, I've quit doing that and recently 
did a new mkfs.btrfs and restored from backup on the affected filesystems 
in ordered to take advantage of newer features like 16k metadata nodes, 
so in fact have never personally seen an unclean output of any type from 
btrfs check.

Tho I don't run btrfs check regularly as in normal mode it's read-only 
anyway, and I know it can make some problems worse instead of fixing them 
in repair mode, so my normal idea is why run it and see stuff that might 
make me worried if I can't really do much about it, and I prefer balance 
and scrub instead if there's problems.  But I have run it a few times as 
I was curious just what it /would/ output, and everything came up clean 
on the filesystems I ran it on.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

