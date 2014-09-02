Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56819 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaIBGDF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 02:03:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XOhBH-0001vh-NY
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 08:03:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 08:03:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 08:03:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel Bug while copying my data off btrfs
Date: Tue, 2 Sep 2014 06:02:50 +0000 (UTC)
Message-ID: <pan$4a69e$fb511089$4fe3f7c1$e2b7f2dc@cox.net>
References: <54050BD4.2060804@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nathan Shearer posted on Mon, 01 Sep 2014 18:14:12 -0600 as excerpted:

> I had a multi-drive raid6 setup and failed and removed 2 drives. I tried
> to start a scrub and rebalance to recalculate the parity and something
> happened where I could not write to the filesystem. Any programs that
> tried to interact with the filesystem would stall forever and bring the
> server load up to ~40000.
> 
> Anyways, now I am mounting the entire filesystem in degraded and
> read-only mode and trying to get my data out, but I keep hitting the
> same kernel bug:

Btrfs raid6 mode, or hardware or mdraid raid6 mode?

Btrfs raid6:

As a bit of research would have told you as the warnings are pretty clear 
for those who do that research, btrfs raid5/6 modes are known not to be 
code-complete at this time and are considered suitable for testing only.  
They work in normal operation, but scrub is broken for that mode, and the 
code for proper recovery/rebalance from failed drives simply isn't yet 
fully complete either.

IOW, btrfs raid5 and raid6 modes currently function in practice like slow 
raid0 with two less devices -- if you lose a device you basically 
consider the whole thing toast.  The only benefit to raid5/raid6 mode at 
this time is that assuming it survives without a device loss until the 
raid5/6 mode code is complete, you'll get a "free" upgrade to raid5/6 at 
that point, since it has actually been doing the writes for it all along, 
it just doesn't have the recovery code done yet.

So if you were running btrfs raid6, you should have considered it raid0 
in terms of recoverability and thus not be storing anything of value on 
it, without backup to something else (a rule which BTW applies to btrfs 
in general at this point, since it's not really a mature filesystem yet, 
altho the basic no-frills stuff is getting closer to stable now, but 
there's still high code churn and lots of bug fixes, and the rule 
DEFINITELY applies to raid5/6 mode since that's KNOWN to be incomplete at 
this point).

Tho at least scrub has some raid5/6 patches floating around, which I 
/think/ might have made it into the I /think/ still soon to be released 
btrfs-progs-3.16 (I've not done a git-pull in a few days so I'm not 
sure).  It's /possible/ you'll have some luck with the very freshest 
code, kernel 3.17-rc3 or integration branch and btrfs-progs-3.16 or 
integration-branch.  Tho AFAIK the code isn't yet complete even there, 
but it's bound to be closer than anything earlier, and thus might give 
you a bit more luck.

Additionally, see the btrfs wiki page on btrfs raid5/6 (assuming you 
hadn't already, but if so, I'd guess you wouldn't have been using btrfs 
raid5/6 in the first place), and in particular, take the external link 
from there to Marc MERLIN's btrfs raid5/6 page, as he's the regular here 
that has done by far the most testing and has the most experience with 
raid5/6.  If it's possible to get your data, his page is most likely to 
help you get there.

https://btrfs.wiki.kernel.org/index.php/RAID56


Hardware/mdraid RAID6:

If you were running hardware or mdraid raid6, with a single-device btrfs 
on top, then by default that btrfs would have been dup-mode metadata, 
single-mode data.  With luck, metadata can be scrubbed from the DUP copy 
and you won't have any non-recoverable errors there, giving you a 
reasonable chance at recovery of at least the undamaged files, but any 
errors in the data won't have a second copy, so damaged files are likely 
unrecoverable.


Either way I hope your backups are good, because that's very likely what 
you'll be using for at least some of those files! =:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

