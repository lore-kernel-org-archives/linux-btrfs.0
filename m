Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbaDWCzx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 22:55:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcnLk-0001Lt-Lw
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 04:55:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 04:55:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 04:55:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug: "corrupt leaf. slot offset bad": root subvolume
 unmountable, "btrfs check" crashes
Date: Wed, 23 Apr 2014 02:55:36 +0000 (UTC)
Message-ID: <pan$df664$93c6c4b1$b586c2f$c5ce83c7@cox.net>
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com>
	<5356B1ED.8060608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Reis posted on Tue, 22 Apr 2014 20:16:13 +0200 as excerpted:

> Same failure with btrfs-progs from integration-20140421 (apart from the
> line number 1156).
> 
> Can I get a bit of input on this? Is it safe to just ignore the error
> for now (as I'm doing atm), ie. remount as rw to skip the orphan
> cleanup?

I explained orphans in my other reply.  Since they're simply not yet 
completed file deletions, it should be /relatively/ safe to continue 
ignoring and doing the manual remount rw, since that continues to work.

"Relatively" as in that's what I'd do in the shorter term here were I 
seeing the problem, tho I'd ensure my backups were current and tested, as 
should be the case on btrfs anyway since it's not entirely stable yet, 
and just because I don't like nagging half-dealt-with-problems left 
laying around and the error would eat at me until I'd cleared it, at some 
point likely rather sooner than later, I'd very likely mkfs and restore 
from those backups.  But I'd certainly be willing to continue running 
from the partition short term, for a week or so until I had a chance to 
do the mkfs.btrfs and restore from backup, as long as that remained the 
only issue I was seeing.

> Might it even be safe to call btrfs check --repair on the partition? I'm
> not keen on that failing mid-process at the same assertion and thus
> breaking it over a bunch of minor files, just like it happened with my
> previous btrfs partitions.

That I can't say.  Based on reports and the common knowledge of the list, 
I've become rather leery of btrfs check --repair myself, and tend to rely 
on scrub and balance to fix issues if they can, and beyond that, 
mkfs.btrfs and restore from backup.  In fact, while btrfs check without 
the --repair is safe as it's read-only, I don't run it regularly either, 
because I know should it report problems I'd then be worried about things 
I might have no reasonable way to fix, that obviously aren't causing me 
problems anyway.  Basically, if mounting and regular use of the 
filesystem isn't giving me anything unusual in dmesg, I consider it good, 
and I for the most part I tend to route around btrfs check entirely, as 
if it weren't even there, tho I've run it in default read-only mode a few 
times, to compare my output with a post from the list or something, 
always with a clean bill of health from btrfs check when I have run it.

That said, if you have backups tested and ready anyway, and would 
otherwise be doing a mkfs.btrfs in short order in ordered to get rid of 
those bad orphan warnings anyway, I don't see the harm in running it, 
since at that point it's zero risk anyway.  If you lose the filesystem as 
a result, big deal, as you were going to mkfs.btrfs and restore from 
backup anyway, and if it fixes the problem, well, you saved yourself the 
hassle.

Plus, either way you can report back the results and then we'll know 
whether it's safe to recommend btrfs check for the next report, or not. 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

