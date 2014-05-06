Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46947 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaEFTpL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:45:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whl3z-00059h-7j
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 21:30:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:30:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:30:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
Date: Tue, 6 May 2014 17:16:08 +0000 (UTC)
Message-ID: <pan$a6ac4$b6e79aa$56ddd950$5b7b75c2@cox.net>
References: <20140503232702.GC9061@merlins.org>
	<5365E4CF.3050405@swiftspirit.co.za> <20140504072420.GJ9061@merlins.org>
	<5366DF48.40209@gmail.com> <20140505050617.GG10159@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 04 May 2014 22:06:17 -0700 as excerpted:

> That's true, but in this case I barely see the point of -m single vs -m
> raid0. It sounds like they both stripe data anyway, maybe not at the
> same level, but if both are striped, than they're almost the same in my
> book :)

Single only stripes in such extremely large (1 GiB data, quarter-GiB 
metadata, per strip) chunks that it doesn't matter for speed, and then 
only as a result of its chunk allocation policy.  If one can define such 
large strips as striping, which it is in a way, but not really in the 
practical sense.

The effect of a lost device, then, is more or less random, tho for single 
metadata the effect is likely to be quite large up to total loss, due to 
the damage to the tree.  It's not out of thin air that the multi-device 
metadata default is raid1 (which unlike the single-device case, should be 
the same on SSD or spinning rust, since by definition the copies will be 
on different devices and thus cannot be affected by SSDs' FTL-level de-
dup).

So the below assumes copies=2 raid1 metadata and is thus only considering 
single vs. raid0 data.

For single data, only files that happened to be partially allocated on 
the lost device will be damaged.  For file sizes above the 1 GiB data 
chunk size, the chance of damage is therefore rather high, as by 
definition the file will require multiple chunks and the chances of one 
of them being on the lost device go up accordingly.  But for file sizes 
significantly under 1 GiB, where data fragmentation is relatively low at 
least (think a recent rebalance or (auto)defrag), relatively small files 
are very likely to be located on a single chunk and thus either all there 
or all missing, depending on whether that chunk was on the missing device 
or not.

That contrasts with raid0, where the striping is at sizes well under a 
chunk (memory page size or 4 MiB on x86/amd64 data I believe, tho the 
fact that files under the 16 MiB node size may actually be entirely 
folded into metadata and not have a data extent allocation at all skews 
things for up to the 16 MiB metadata node size), so the definition of 
"small file likely to be recovered" is **MUCH** smaller on raid0, than on 
single.

Effectively, raid0 data you're only (relatively) likely to recover files 
smaller than 16 MiB, while single data, it's files smaller than 1 GiB.

Big difference!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

