Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55724 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbaACAJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 19:09:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VysKi-0002X7-Ly
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 01:09:48 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:09:48 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:09:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Migrate to bcache: A few questions
Date: Fri, 3 Jan 2014 00:09:26 +0000 (UTC)
Message-ID: <pan$6af1d$ed6b6a3b$ad28a0c4$aecbe1eb@cox.net>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
	<52C1990D.9060704@gmail.com> <52C476B8.2040601@gmail.com>
	<pan$ce6d2$f8c0c73e$1b8dc4d$cbbdd6eb@cox.net> <52C55D36.2070201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 02 Jan 2014 07:36:06 -0500 as
excerpted:

> I think the triple seek+write is probably the biggest offender in my
> case, although COW and autodefrag probably don't help either.  I'm kind
> of hesitant to put stuff that gets changed daily on a SSD, so I've ended
> up putting portage on ext4 with no journaling (which out-performs every
> other filesystem I have tested WRT write performance).

I went ahead with the gentoo tree and overlays on SSD, because... well, 
they need the fast access that SSD provides, and if I can't use the SSD 
for its good points, why did I buy it in the first place?

It's also worth noting that only a few files change on a day to day 
basis.  Most of the tree remains as it is.  Similarly with the git pack 
files behind the overlays (and live-git sources) -- once they reach a 
certain point they stop changing and all the changes go into a new file.

Further, most reports I've seen suggest that daily changes on some 
reasonably small part of an SSD aren't a huge problem... given wear-
leveling and an estimated normal lifetime of say three to five years 
before they're replaced with new hardware anyway, daily changes simply 
shouldn't be an issue.  It's worth keeping limited-write-cycles in mind 
and minimizing them where possible, but it's not quite the big thing a 
lot of people make it out to be.

Additionally, I'm near 100% overprovisioned, giving the SSDs lots of room 
to do that wear-leveling, so...

Meanwhile, are you using tail packing on that ext4?  The idea of wasting 
all that space due to all those small files has always been a downer for 
me and others, and is the reason many of us used reiserfs for many 
years.  I guess ext4 now does have tail packing or some similar solution, 
but I do wonder how much that tail packing affects performance.

Of course it'd also be possible to run reiserfs without tail packing, and 
even without journaling.  But somehow I always thought what was the point 
of running reiser, if those were disabled.

Anyway, I'd find it interesting to benchmark what the effect of 
tailpacking (or whatever ext4 calls it) on no-journal ext4 for the gentoo 
tree actually was.  If you happen to know, or happen to be inspired to 
run those benchmarks now, I'd be interested...

> As for the
> dep-calculations, I have 16G of ram, so I just use a script to read the
> entire tree into the page cache after each sync.

With 16 gig RAM, won't the sync have pulled everything into page-cache 
already?  That has always seemed to be the case here.  Running an emerge 
--deep --upgrade --newuse @world here after a sync shows very little disk 
activity and takes far less time than trying the same thing after an 
unmount/remount, thus cold-cache.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

