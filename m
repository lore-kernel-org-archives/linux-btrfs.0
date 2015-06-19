Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60937 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbbFSHxq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 03:53:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5r7P-00053B-Kb
	for linux-btrfs@vger.kernel.org; Fri, 19 Jun 2015 09:53:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 09:53:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 09:53:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Corrupted btrfs partition (converted from ext4) after balance
Date: Fri, 19 Jun 2015 07:53:33 +0000 (UTC)
Message-ID: <pan$f0b29$47b8cb68$f88267b2$c1dce0e4@cox.net>
References: <55835A55.7000308@stroebel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vianney Stroebel posted on Fri, 19 Jun 2015 01:55:01 +0200 as excerpted:

> I could copy the data on another freshly formatted disk and reformat
> this one but I am wondering if btrfs is stable enough to be used on my
> professional laptop (where I cannot afford such downtime)or if I should
> go back to ext4.

As a btrfs-using admin and list regular, not a dev, I'll reply to just 
the above more general question, letting others deal with the specific 
technical issue...

Good question, on which there's apparently a bit of controversy.

My own opinion, TL;DR summary?  If you're asking the question and are 
unlikely to be going ahead anyway, regardless of the answer you get, then 
btrfs is unlikely to be what you'd call "stable enough", at this point.

The longer version...

The devs have applied patches that have removed most of the warnings, and 
some distros are now using btrfs by default, generally for the system 
partitions in ordered to take advantage of btrfs snapshotting to enable 
rollback, so it's obviously "stable enough" for them.

But actual non-dev btrfs user and list regular opinion on this list seems 
to be somewhere between "Are you kidding?  After I just got thru dealing 
with bug XXXX, no way, Jose!", and "It's definitely stabilizing and 
maturing, and is noticeably better than six months ago, which was 
noticeably better than six months before that, but it's equally 
definitely not something I'd characterize as fully stable and mature just 
yet."

An arguably more practical way of stating the latter position, which 
happens to be my own, is by reference to the sysadmin's rule of backups.  
This rule says that if a particular set of files isn't backed up, then by 
definition, you don't care about losing it, despite any claims, possibly 
after said loss, to the contrary.  Additionally, a would-be backup that 
hasn't passed restorability tests isn't yet complete, and therefore 
cannot be called a backup for purposes of the above rule.  If it isn't 
backed up, you don't care about losing it.  Full stop.  But, because 
btrfs isn't yet fully stable and mature, that rule applies double.

I'd argue that for anyone that accepts that principle, including the 
doubling, and is still willing to use btrfs, it's "stable enough".  
Otherwise, better look somewhere else, as what you're looking for isn't 
found here.

That's the sysadmin-speak test, and result.  But there's another way of 
putting it that's more developer-speak.

As any good developer will tell you, premature optimization is bad, very 
bad, in no small part because optimization is a LOT of work, and 
premature optimization either severely limits post-optimization 
flexibility in ordered to retain that work, or must be repeated over and 
over again as the problem and solution space becomes more defined by 
early trial and mid-stage implementations and better solutions become 
known.

For reasonably good developers, then (and if you don't consider them good 
developers, why are you trusting their filesystem work?), developer's own 
REAL opinion of the stability and maturity of a project is how much it 
has been optimized, vs. where optimization remains on the TODO list.  
Once developers are focusing on optimization, arguably they too believe 
the general solution to be relatively stable and mature.  By contrast, if 
major parts of the code remain unoptimized, particularly where the 
current code works well enough but is known to be LESS than optimum, 
developers self-evidently consider it still maturing and subject to 
change that could possibly undo any current efforts at optimization.

Arguably, that's about as technically reasonable and unbiased as a 
measure gets, so for those concerned about stability the optimization 
level is a valid question, quite apart from the direct efficiency answer 
one might expect as motivation for the question.

OK, so where's btrfs on this scale?

In answer let's consider just one well known case, the raid1 read-
scheduler device-choice algorithm.  The ideal case is that given two 
devices in raid1 so each has a copy of the data and an otherwise idle 
system so there's nothing else trying to do reads or writes as well, 
because the actual read off spinning rust is the bottleneck, for any read 
of significant size, the scheduler should make use of both devices by 
reading half the data from one device, and half from the other.

OK, so what does btrfs actually do?  It assigns read device based on the 
PID, even/odd.  While this does provide a very easy way to test things by 
arranging the number of processes and their PIDs to either balance reads 
or to force reads to only one device or the other, and should balance 
things reasonably well with a large enough set of random processes trying 
to read at the same time, for a single process doing read access on an 
otherwise I/O idle system, it's worst-case, since 100% of all reads will 
be to one device, bottlenecking on it while the other device remains 100% 
idle!

Obviously, they did a quick implementation that is easy to implement and 
troubleshoot, and dead easy to test, but doesn't prioritize actual 
efficiency or optimization at all.

And they haven't optimized it from that, despite it being a well known 
case that has much better optimized and well tested solutions in the form 
of mdraid's raid1 scheduler, in the same Linux kernel.

It can well be argued from just that, that the developers themselves 
consider btrfs still subject to enough change that even well known low-
hanging-fruit optimization would be premature, and that btrfs code is 
anything /but/ "stable and mature".  Were it otherwise, at least the 
really obvious low-hanging-fruit optimizations with known better 
scheduler optimization code already very well tested in other areas, 
would be implemented here, as well.  Since they haven't been... well, the 
code and its optimization state speaks for itself.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

