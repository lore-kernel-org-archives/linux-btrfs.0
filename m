Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42169 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbbFKEOc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 00:14:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z2tss-0000Xk-Rg
	for linux-btrfs@vger.kernel.org; Thu, 11 Jun 2015 06:14:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 06:14:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 06:14:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Does raid56 work on latest kernel?
Date: Thu, 11 Jun 2015 04:14:25 +0000 (UTC)
Message-ID: <pan$4058c$7888c445$459683cf$d6eac669@cox.net>
References: <CAEko1BmP0Rrf5ng5Gqo56SzRhGdJzBE7w=-x--T2EBv81iaT6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Guilherme Gonçalves posted on Wed, 10 Jun 2015 21:05:38 -0300 as
excerpted:

> Hello!,  use arch linux with the latest kernel, i am trying to do raid 5
> on 3 devices, but i get this on btfs fi usage:
> 
> "WARNING: RAID56 detected, not implemented"
> 
> what is not implemented?

That warning is purely regarding the btrfs fi usage subcommand.  Usage is 
a relatively new subcommand, and the patches adding it didn't implement 
the calculations code necessary to produce correct numbers for some of 
the non-mainstream (at the time) modes, including mixed-blockgroup mode 
(for small btrfs, the default on btrfs' under 1 GiB and recommended by 
some but not all regulars, on btrfs upto 16 or 32 GiB, but it remains a 
bit of a corner-case), and raid56 mode, as support for it wasn't complete 
anyway.

So specific btrfs fi usage subcommand support for those modes isn't there 
now and can be expected later, but because the usage subcommand is purely 
informational anyway, and basically prints the same information available 
from the fi show and fi df commands separately, only a bit prettier, this 
missing support doesn't affect actual btrfs operation in any way.

That said...

> btrfs-progs v4.0.1
> 
> does it work on my kernel (4.0.5-1-ARCH), i know it was incomplete
> before, but now on 4.0 does it work despite it being new? what is "not
> implemented" on the message mean?

Technically, all the raid56 support should be there now -- it's code-
complete.  Practically, however, I've been recommending people continue 
to stay off of it for anything but pure data-loss-ok testing, for at 
*LEAST* another couple kernels, to shake out some of the inevitable bugs 
and let the code settle at least a /bit/.

And point-of-fact, we /did/ have some bad raid56 mode reports shortly 
after 4.0, from people who had /not/ let it shake out a bit and were 
trying to use it in normal-case situations.  Whether they're actually 
fixed now (with the latest stable or with late 4.1-rcs for 4.1 release) 
I'm not sure, tho the number of bad reports has died down quite a bit, 
but I don't know whether that is people actually following the 
recommendation, or because it's fixed now.  Either way, however, I'd not 
be using it myself, and couldn't recommend it for others except as I said 
purely for data-loss-doesn't-matter testing, until at LEAST 4.2, as 
there's still likely to be a few more critical bugs to shake out.

And even at 4.2, I'd still recommend raid56 mode only for those willing 
to be bleeding edge testers, if that's what it takes to be leading edge 
testers, because point-of-fact, that code still won't be as stable as the 
raid0/1/10 modes, which are basically as stable as btrfs itself is by 
this point.  It's going to take some time, as well as the reports of 
those leading/bleeding edge testers, to shake out further bugs and 
stabilize that still very new code.

For more btrfs-mainstream users[1], I'd recommend waiting about a year, 
five kernel cycles, for btrfs raid56 mode to stabilize.  By that point, 
with testing/reporting from the leading/bleeding edge and corresponding 
fixes from the devs, raid56 mode should be approaching the stability of 
btrfs in general, and I'd suggest following the list's raid56 mode 
discussion for kernel 4.4 and early 4.5, and as long as things look 
reasonably calm, *THEN* I'd say it's reasonable for a mainline btrfs user 
to consider raid56 mode.

But even then, be sure to have tested backups or by definition of your 
action, you really do NOT care about losing that data, no matter any 
claims to the contrary.  Because while btrfs in general is certainly 
stabilizing, and in a year will certainly be more stable and mature then 
than it is now, as a practical matter, it simply won't have the time 
tested stability and maturity of filesystems such as ext3/4, xfs, and 
even reiserfs[2], for some years yet.

In the mean time, I'd recommend the much more mature btrfs raid10 mode.  
You might need a few more devices to get equivalent capacity, but at 
least you're getting a mode that's known to be basically as mature and 
stable as btrfs itself is, at this point, not the still new btrfs raid56 
mode code that's still not been even minimally time-tested and is 
statistically still very likely to have some pretty critical bugs 
crawling around.

Tho of course it's your system, your data, and your call.  But I know 
what my call would be for /my/ systems. =:^)  And I know a number of 
posters who wish they had been (quite!) a bit more cautious with raid56 
mode for 4.0, at least. =:^(

---
[1] Btrfs-mainstream users.  This takes into account that btrfs itself is 
still not entirely stable, tho it's definitely making progress, so the 
sysadmin's backup rule that if you don't have a backup, by definition, 
you don't care about losing that data, and an untested would-be backup 
isn't a backup yet, because it's not a backup until you have tested that 
you can actually recover from it, applies double, compared to more tested 
stable filesystems -- have that backup or you by your actions really do 
NOT care!

[2] Reiserfs:  My own time-tested stability favorite, at least post-
data=ordered-by-default, thru various hardware problems that would bring 
ordinary filesystems to their knees.  I'm convinced it's at least partly 
because most non-fs-expert kernel devs fear reiserfs enough to leave it 
alone, so only the real reiserfs experts dare work with it, while every 
kernel dev and their brother thinks they know enough about the ext* 
family of filesystems to tinker with them.  Consider the period when ext3 
got switched back to data=writeback mode by default, the very same mode 
that caused reiserfs to have the bad name it did, back in the early 
days.  The folks that did that left reiserfs alone, so reiserfs users 
were actually safer by default during that period than ext3 users!


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

