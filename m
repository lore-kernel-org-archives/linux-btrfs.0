Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33745 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaCYPnI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 11:43:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSTVG-0003CO-8J
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 16:43:02 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 16:43:02 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 16:43:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Suggestion: Anti-fragmentation safety catch (RFC)
Date: Tue, 25 Mar 2014 15:42:36 +0000 (UTC)
Message-ID: <pan$ee4df$a16c7a6$74fe8395$12ca6150@cox.net>
References: <lgq247$lgk$1@ger.gmane.org>
	<pan$191e5$f5ca4422$3e26f4d9$15d09a73@cox.net>
	<lgqk8i$j4p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Tue, 25 Mar 2014 00:57:05 +0000 as excerpted:

> https://btrfs.wiki.kernel.org/index.php/Mount_options

> #### autodefrag (since [kernel] 3.0)
> 
> Will detect random writes into existing files and kick off background
> defragging. It is well suited to bdb or sqlite databases, but not
> virtualization images or big databases (yet). Once the developers make
> sure it doesn't defrag files over and over again, they'll move this
> toward the default.
> ####
> 
> Looks like I might be a good test case :-)
> 
> 
> What's the problem for big images or big databases? What is considered
> "big"?

"Big" is obviously relative and may depend to some extent on the physical 
device backing the filesystem, particularly SSD vs. spinning rust, as 
well as just how actively rewritten the file in question actually is.

Based on my own experience and what I've seen posted from others, 
autodefrag seems to work reasonably well into the lower hundreds of MiB, 
while once we're talking "gigs", something like the NOCOW file attribute 
tends to be a better solution.

Sizes of say half a gig to a gig are a gray area.  Autodefrag will 
probably work well enough on them for fast media (SSD) or if the file re-
writing requests aren't coming in /too/ fast, but on slower spinning rust 
or where internal file data rewrites are coming fast, rewriting the 
entire multi-hundred-megabyte file to defrag it every time an update of a 
few bytes comes in will likely bottleneck the system, with an effect much 
like the one you posted to start this thread: a load average increasing 
into the hundreds due to IO-bottleneck with CPUs @ 100% wait, due to the 
write-magnification effect as a full several hundred megabyte file gets 
repeatedly rewritten for each update of a few bytes!

Actually, if your use-case ends up being in or near that gray area, I'm 
sure some specific tests and hard numbers would be appreciated!  Maybe 
autodefrag is fine to 1.5 GiB or so, or perhaps the trouble starts at say 
300 MiB for you as your system is slow enough and the incoming data 
stream high enough you're bottlenecking at 300 MiB.  Or perhaps the half-
gig to 1-gig range is right on.  Regardless, if you can get hard data on 
it, please do share. =:^)

Meanwhile, the NOCOW extended file-attribute (chattr +C) mentioned a 
couple paragraphs up is recommended once the problem scales beyond what 
autodefrag can handle. There are, however, a number of btrfs specific 
peculiarities to the NOCOW situation that it can take some familiarity 
with the topic to cleanly navigate.  That's out of scope for this post 
and besides, there's quite a few other threads where it has been 
discussed, so I'll punt on that discussion, for now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

