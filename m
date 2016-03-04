Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53361 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbcCDMRa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 07:17:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abofe-0003Ly-Ia
	for linux-btrfs@vger.kernel.org; Fri, 04 Mar 2016 13:17:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 13:17:26 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 13:17:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Stray 4k extents with slow buffered writes
Date: Fri, 4 Mar 2016 12:17:19 +0000 (UTC)
Message-ID: <pan$c10c8$9f263f0c$e897a9bf$b8ca489d@cox.net>
References: <56D82DED.5030107@googlemail.com>
	<20160303183322.GA16959@localhost.localdomain>
	<56D89655.70504@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Thu, 03 Mar 2016 20:53:57 +0100 as excerpted:

> It changes things because you likely have a higher value set for
> vm/dirty_expire_centisecs or dirty_bytes explicitly configured; I have
> it set to 1000 (10s) to prevent large writebacks from choking
> everything.
> The default is probably still 30s aka 3000.

[This is a comment on write-cache management strategy in the above 
context, not on the buffered write 4k extents issue.]

Interesting strategy.

I left the expire (aka foreground priority) timeout at its default 30 
seconds, here, and actually upped the writeback (background priority) 
timeout to 10 seconds, from its default 5.

I don't like large writebacks choking things either, but I chose to use 
the size knobs (after all, the descriptor at issue here is "large", not 
"old") to deal with that, not the time knobs.  As a result, I set the 
background ratio to 1% (it defaults to 5%), and foreground ratio to 3% 
(it defaults to 10%).

With 16 gig of RAM, that's ~160 MiB background, about five seconds worth 
at the 30 MiB/sec random write that's a reasonable if perhaps a bit 
pessimistic estimate for spinning rust, ~ half a GiB foreground (15 
seconds worth).  Tho obviously as I'm at 1%, I'd have to switch to the 
bytes instead of ratio knobs if I were to up my memory or want to go 
lower or wanted more precise knobs.

It just seems to me more logical to fiddle the size knob if I'm worried 
about the /size/ of the writeback, and with size now dealt with and off 
the table, I decided doubling the low priority background writeback 
timeout to 10 seconds was equally logical, giving writes additional time 
to accumulate, for better write combining and elevator ordering, before 
actually starting low priority writeback, since if sizes started 
ballooning the lower size thresholds would trigger writeback anyway.  And 
with size already dealt with, the higher priority foreground expiry 
default of 30 seconds was fine, so I didn't change that at all.


And, it seems to me, that might be part of your problem, since you're 
forcing high priority writeback at only 10 seconds, even if it's under 
the 4K block size, thus forcing COW rewrites when more data is appended 
to those blocks, with COW predictably playing havoc with your extents, 
now that you're forcing sub-4K writes to storage at high priority so fast 
they have little chance to be consolidated into whole 4K block writes.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

