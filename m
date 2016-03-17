Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41891 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbcCQIvn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 04:51:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agTef-0005DU-MI
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 09:51:41 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 09:51:41 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 09:51:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Stupid (?) Idea about extent lifetimes.
Date: Thu, 17 Mar 2016 08:51:28 +0000 (UTC)
Message-ID: <pan$21eeb$326c05ba$63975d28$148fb00e@cox.net>
References: <56E8FDE5.90401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Tue, 15 Mar 2016 23:32:05 -0700 as excerpted:

> It occurs to me that it would be desirable to mark extents as "least
> favoured nations" and so all new writes would like to not be written
> there and any data written there would have a desire to be somewhere
> else.

I believe the word you wanted here instead of extents is "chunks".

Extents are parts of files, and btrfs is a COW (copy on write) 
filesystem, so writes modifying existing files already move out of the 
existing file extents.

But chunks, in btrfs context at least, are relatively large, nominally 1 
GiB for data, 256 MiB for metadata (tho sizes can be larger on really 
large filesystems or smaller on real small ones), "chunks", that the 
filesystem allocates first as empty, and lets files (or metadata nodes) 
fill.  It's these chunks that balance rewrites, and thus these chunks 
that would logically get your numeric "gravity" ratings.

With that change, it's an interesting concept.  I'm not a dev and can't 
really guess if it's entirely practical to implement or not, but as a 
btrfs user and admin, I can certainly see practical uses, should it /be/ 
implemented.

Very creative concept and definitely worth discussion.  Thanks for 
throwing it out here /for/ discussion.  =:^)

Tho one caution.  There's a lot more worthwhile ideas about what /could/ 
be done with btrfs than developers and developer time to implement them 
all, at least in anything like a reasonable time frame of say five years 
or less.  So even if it's a pretty good idea, unless it happens to be 
practically usable to help implement some other project the devs are 
working on, simply because there's so many other pretty good ideas, it 
might take quite some time (over five years) to actually be implemented.  
So don't get your hopes up for anything too immediate, or even 
intermediate term (2-5 years out), unless you get extremely lucky and the 
devs see it as a way to implement something they already are working on 
or that's already a high priority "next" item on their roadmap.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

