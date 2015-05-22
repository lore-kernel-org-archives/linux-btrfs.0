Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51744 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbbEVEnZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 00:43:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yvenq-0001RQ-V2
	for linux-btrfs@vger.kernel.org; Fri, 22 May 2015 06:43:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 06:43:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 06:43:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS RAID5 filesystem corruption during balance
Date: Fri, 22 May 2015 04:43:16 +0000 (UTC)
Message-ID: <pan$1c831$68d3ab4d$212d5e11$aaf7c2b4@cox.net>
References: <loom.20150521T231006-840@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Voet posted on Thu, 21 May 2015 21:43:36 +0000 as excerpted:

> I recently upgraded a quite old home NAS system (Celeron M based) to
> Ubuntu 14.04 with an upgraded linux kernel (3.19.8) and BTRFS tools
> v3.17.
>  This system has 5 brand new 6TB drives (HGST) with all drives directly
> handled by BTRFS, both data and metadata in RAID5.

FWIW, btrfs raid5 (and raid6, together called raid56 mode) is still 
extremely new, only normal runtime implemented as originally introduced, 
with complete repair from a device failure only completely implemented in 
kernel 3.19, and while in theory complete, that implementation is still 
very immature and poorly tested, and *WILL* have bugs, one of which you 
may very well have found.

For in-production use, therefore, btrfs raid56 mode, while now at least 
in theory complete, is really too immature at this point to recommend.  
I'd recommend either btrfs raid1 or raid10 modes as more stable within 
btrfs at this point, tho by the end of this year or early next, I predict 
raid56 mode to have stabilized to about that of the rest of btrfs, which 
is to say, not entirely stable, but heading that way.

IOW, for btrfs in general, the sysadmin's backup rule that if you don't 
have backups by definition you don't care about the data regardless of 
claims to the contrary, and untested would-be backups aren't backups 
until you complete them by testing that they can be read and restored 
from, continues to apply even more than to more stable filesystems, and 
keeping up with current is still very important as by doing so you're 
avoiding known and already fixed bugs.  Given those constraints, btrfs 
is /in/ /general/ usable.  But not yet raid56 mode, which I'd definitely 
consider to still be breakable at any time.

So certainly for the multi-TB of data you're dealing with, which you say 
yourself takes some time (and is thus not something you can afford to 
backup and restore trivially), I'd say stay off btrf raid56 until around 
the end of the year or early next, at which point it should have 
stabilized.  Until then, consider either btrfs raid1 mode (which I use), 
or for that amount of data, more likely btrfs raid10 mode.

Or if you must keep raid5 due to device and data size limitations, 
consider sticking with mdraid5 or similar, for now, potentially with 
btrfs on top, or perhaps with the more stable xfs or ext3/4 (or my 
favorite reiserfs, which I have found /extremely/ reliable here, even 
with less than absolutely reliable hardware, the old tales about it being 
unreliable were from pre-data=ordered times, but that's early kernel 2.4 
era and thus rather ancient history, now, but as they say, YMMV...).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

