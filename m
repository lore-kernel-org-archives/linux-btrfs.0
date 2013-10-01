Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54304 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab3JAMzM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 08:55:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQzTq-0004JT-Ru
	for linux-btrfs@vger.kernel.org; Tue, 01 Oct 2013 14:55:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 14:55:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 14:55:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Progress of device deletion?
Date: Tue, 1 Oct 2013 12:54:50 +0000 (UTC)
Message-ID: <pan$d8eab$6713390e$a59891e9$38a1914f@cox.net>
References: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com>
	<2E504581-FA34-425A-B14B-EF3F16FC655C@colorremedies.com>
	<F4008F3B-594D-4003-BC06-82B9E18AA023@colorremedies.com>
	<pan$d4ca0$5ff8830c$a79d58d4$78936022@cox.net>
	<2754C186-FACD-4621-9876-2328C90978CC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 30 Sep 2013 23:26:16 -0600 as excerpted:

> The other thing, clearly the OP is surprised it's taking anywhere near
> this long. Had he known in advance, he probably would have made a
> different choice.

I had a longer version that I wrote first, but decided was /too/ long to 
post as it was.  In it I compared the time of seconds to a couple minutes 
to do a full btrfs balance here, to the time of days I'm seeing reported 
on-list.  That's down to two reasons, AFAIK, the fact that I'm running 
SSDs, and the fact that I partition things up so that even for my backups 
on spinning rust, I'm looking at perhaps a couple hours, not days, for a 
full balance or pre-btrfs, an mdraid (1) return from degraded.

The point there was that when a balance or raid rebuild takes seconds, 
minutes or hours, it's feasible and likely to do it as a test or as part 
of routine maintenance, before things get as bad as terabytes of over-
allocation.  As I result, I actually know what my normal balance times 
look like since I do them reasonably often, something that someone on a 
system where it's going to take days isn't likely to have the option or 
luxury of doing.

So there's a benefit in if possible partitioning, even if SSDs aren't a 
current option, or otherwise managing the data scale so maintenance time 
scales are at very worst on the scale of hours, not days, and preferably 
at the low end of that range (based on my mdraid days, a practical limit 
for me is a couple hours, before it's simply too long to do routinely 
enough to be familiar with the scale times, etc).

Of course that can't be done for all use cases, but if it's at all 
possible, simply managing the scale helps a *LOT*.  As I said, the 
practical wall before things go off the not routinely manageable end for 
me is about two hours.  A pre-deployment test can give one an idea of 
time scale, and from there... at least I'd have some idea whether it'd 
take a day or longer, and if it did there was definitely something wrong.

Of course if this /is/ part of that pre-deployment testing or even btrfs 
development testing, as is appropriate at this stage of btrfs 
development, then points to him for doing that testing and finding 
there's either something badly wrong or he's simply off the practical end 
of the size scale before actual deployment. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

