Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60616 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3K2BKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 20:10:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VmCbJ-0004gL-5g
	for linux-btrfs@vger.kernel.org; Fri, 29 Nov 2013 02:10:33 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2013 02:10:33 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2013 02:10:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 2 errors when scrubbing - but I don't know what they mean
Date: Fri, 29 Nov 2013 01:10:12 +0000 (UTC)
Message-ID: <pan$e58f7$107ceb0e$e753a400$c76bf1d5@cox.net>
References: <5297A950.3020100@informatik.uni-bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sebastian Ochmann posted on Thu, 28 Nov 2013 21:36:32 +0100 as excerpted:

> when I scrubbed one of my btrfs volumes today, the result of the scrub
> was:
> 
> total bytes scrubbed: 1.27TB with 2 errors error details: super=2
> corrected errors: 0, uncorrectable errors: 0, unverified errors: 0
> 
> and dmesg said:
> 
> btrfs: bdev /dev/mapper/tray errs: wr 0, rd 0, flush 0, corrupt 0, gen 1
> btrfs: bdev /dev/mapper/tray errs: wr 0, rd 0, flush 0, corrupt 0, gen 2
> 
> Can someone please enlighten me what these errors mean (especially the
> "super" and "gen" values)? As an additional info: The drive is sometimes
> used in a machine with kernel 3.11.6 and sometimes with 3.12.0, could
> this swapping explain the problem somehow?

[Just an admin using/testing btrfs here; not a dev.]

Super=superblock.  I really can't say what errors registered as superblock 
errors might mean as I've never seen them here and haven't chanced across 
an explanation on-list or on the wiki, but were I seeing that here, my 
approach would be to try the scrub again and hope the errors were fixed 
(tho I should mention that I'm on SSD with multiple independent rather 
small btrfs partitions, so scrubs take a couple minutes for my larger 
partitions, not the hours you're likely to see with multi-TB spinning 
rust, so rerunning a scrub is trivial, /here/!).  If that didn't catch 
them, then I'd try btrfsck (without --repair) and see if it had any 
further information to offer.  (Repair is a a further step that I'd only 
take if necessary -- making sure I had a good backup first!)  There's 
also btrfs-show-super, which should be safe as it's read-only, simply 
displaying a lot of information, much of which probably won't make much 
sense except to a btrfs dev/expert (it's beyond me).


As for the dmesg output you quoted, if you compare your syslog times for 
the same messages, I suspect you'll find they were printed at filesystem 
mount time, NOT during the scrub, and are thus not directly related.

What the dmesg output IS directly related to is the output of btrfs 
device stat.  The first thing to note about it is that errors reported 
are cumulative, only being reset if its -z option is used.  Thus, stats 
let you track whether the number of errors are rising, but unless you 
reset stats (using btrfs dev stat -z) after your last scrub, they'll 
still reflect historical errors that have already been corrected -- 
errors reported at mount time and by device stat reflect historical 
status and do NOT necessarily reflect *CURRENT* errors.

As with the superblock errors, I've not actually seen generation errors 
here, so I don't know whether they're the superblock errors scrub is 
reporting or are different.  Similarly, I don't know what fixes them.

What I /have/ seen here are read_ and write_io_errs (as reported by stat, 
simply wr/rd as reported by the kernel at mount time), due to bad 
shutdowns (well, suspend-to-ram that didn't resume properly).  I know 
scrub can and does recover those, provided it has a second copy to 
recover from, as it does here since (with the exception of /boot) all my 
btrfs filesystems are btrfs raid1 mode, both data and metadata, across 
two SSDs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

