Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50157 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbcEMHON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 03:14:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b17IZ-0008Rx-9u
	for linux-btrfs@vger.kernel.org; Fri, 13 May 2016 09:14:11 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:14:11 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:14:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: About in-band dedupe for v4.7
Date: Fri, 13 May 2016 07:14:06 +0000 (UTC)
Message-ID: <pan$bfe1d$63474795$21d23024$288c85c6@cox.net>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
	<20160510221119.GD7633@wotan.suse.de>
	<23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
	<20160511025211.GF7633@wotan.suse.de> <20160511173659.GI29353@suse.cz>
	<20160512205426.GL7633@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Fasheh posted on Thu, 12 May 2016 13:54:26 -0700 as excerpted:

> For example, my 'large' duperemove test involves about 750 gigabytes of
> general purpose data - quite literally /home off my workstation.
> 
> After the run I'm usually seeing between 65-75 gigabytes saved for a
> total of only 10% duplicated data. I would expect this to be fairly
> 'average' - /home on my machine has the usual stuff - documents, source
> code, media, etc.
> 
> So if you were writing your whole fs out you could expect about the same
> from inline dedupe - 10%-ish. Let's be generous and go with that number
> though as a general 'this is how much dedupe we get'.
> 
> What the memory backend is doing then is providing a cache of
> sha256/block calculations. This cache is very expensive to fill, and
> every written block must go through it. On top of that, the cache does
> not persist between mounts, and has items regularly removed from it when
> we run low on memory. All of this will drive down the amount of
> duplicated data we can find.
> 
> So our best case savings is probably way below 10% - let's be _really_
> nice and say 5%.

My understanding is that this "general purpose data" use-case isn't being 
targeted by the in-memory dedup at all, because indeed it's a very poor 
fit for exactly the reason you explain.

Instead, think data centers where perhaps 50% of all files are duplicated 
thousands of times... and it's exactly those files that are most 
frequently used.  Totally different use-case, where that 5% on general 
purpose data could easily skyrocket to 50%+.

Refining that a bit, as I understand it, the idea with the in-memory-
inline dedup is pretty much opportunity-based dedup.  Where there's an 
easy opportunity seen, grab it, but don't go out of your way to do 
anything fancy.  Then somewhat later, a much more thorough offline dedup 
process will come along and dedup-pack everything else.

In that scenario a quick-opportunity 20% hit rate may be acceptable, 
while actual hit rates may approach 50% due to skew toward the common.  
Then the dedup-pack comes along and finishes things, possibly resulting 
in total savings of say 70% or so.  Even if the in-memory doesn't get 
that common-skew boost and ends up nearer 20%, that's still a significant 
savings for the initial inline result, with the dedup-packer coming along 
later to clean things up properly.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

