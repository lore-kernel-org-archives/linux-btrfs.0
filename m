Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaEOJb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 05:31:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wks13-0002BW-E5
	for linux-btrfs@vger.kernel.org; Thu, 15 May 2014 11:31:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 11:31:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 11:31:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: staggered stripes
Date: Thu, 15 May 2014 09:31:42 +0000 (UTC)
Message-ID: <pan$a10c6$96b782de$86a74a2f$b7f37af@cox.net>
References: <2751140.Zb1qMBeNgk@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Thu, 15 May 2014 19:00:10 +1000 as excerpted:

> http://www.cs.wisc.edu/adsl/Publications/corruption-fast08.html
> 
> Page 13 of the above paper says:
> 
> # Figure 12 [...] We see in the figure that many disks develop
> # corruption for a specific set of block numbers.  [T]herefore,
> # RAID system designers may be well-advised to use staggered
> # stripes such that the blocks that form a stripe (providing
> # the required redundancy) are placed at different block numbers
> # on different disks.
> 
> Does the BTRFS RAID functionality do such staggered stripes?  If not
> could it be added?

AFAIK nothing like that yet, but it's reasonably likely to be implemented 
later.  N-way-mirroring is roadmapped for next up after raid56 
completion, however. 

You do mention the partition alternative, but not as I'd do it for such a 
case.  Instead of doing a different sized buffer partition (or using the 
mkfs.btrfs option to start at some offset into the device) on each 
device, I'd simply do multiple partitions and reorder them on each 
device.  Tho N-way-mirroring would sure help here too, since if a given 
area around the same address is assumed to be weak on each device, I'd 
sure like greater than the current 2-way-mirroring, even if if I had a 
different filesystem/partition at that spot on each one, since with only 
two-way-mirroring if one copy is assumed to be weak, guess what, you're 
down to only one reasonably reliable copy now, and that's not a good spot 
to be in if that one copy happens to be hit by a cosmic ray or otherwise 
fail checksum, without another reliable copy to fix it since that other 
copy is in the weak area already.

Another alternative would be using something like mdraid's raid10 "far" 
layout, with btrfs on top of that...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

