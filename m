Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47147 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbcF0VMy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 17:12:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bHdpo-0005jg-Ag
	for linux-btrfs@vger.kernel.org; Mon, 27 Jun 2016 23:12:49 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 23:12:48 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 23:12:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Strange behavior when replacing device on BTRFS RAID 5 array.
Date: Mon, 27 Jun 2016 21:12:38 +0000 (UTC)
Message-ID: <pan$1b1eb$ec458251$ad5da650$8b2cea6b@cox.net>
References: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nick Austin posted on Sun, 26 Jun 2016 20:57:32 -0700 as excerpted:

> I have a 4 device BTRFS RAID 5 filesystem.
> 
> One of the device members of this file system (sdr) had badblocks, so I
> decided to replace it.

While the others answered the direct question, there's something 
potentially more urgent...

Btrfs raid56 mode has some fundamentally serious bugs as currently 
implemented, that we are just now finding out how serious they 
potentially are.  For the details you can read the other active threads 
from the last week or so, but the important thing is that...

For the time being, raid56 mode is not to be trusted repairable and as a 
result is now highly negative-recommended.  Unless you are using pure 
testing data that you don't care about whether it lives or dies (either 
because it literally /is/ that trivial, or because you have tested 
backups, /making/ it that trivial), I'd urgently recommend either getting 
your data off it ASAP, or rebalancing to redundant-raid, raid1 or raid10, 
instead of parity-raid (5/6), before something worse happens and you no 
longer can.

Raid1 mode is a reasonable alternative, as long as your data fits in the 
available space.  Keeping in mind that btrfs raid1 is always two copies, 
with more than two devices upping the capacity, not the redundancy, 3 
5.46 TB devices = 8.19 TB usable space.  Given your 8+ TiB of data usage, 
plus metadata and system, that's unlikely to fit unless you delete some 
stuff (older snapshots probably, if you have them).  So you'll need to 
keep it to four devices of that size.

Btrfs raid10 is also considered as stable as btrfs in general, and would 
be doable with 4+ devices, but for various reasons I'll skip for brevity 
here (ask if you want them detailed), I'd recommend staying with btrfs 
raid1.

Or switch to md- or dm-raid1.  Or one other interesting alternative, a 
pair of md- or dm-raid0s, on top of which you run btrfs raid1.  That 
gives you the data integrity of btrfs raid1, with somewhat better speed 
than the reasonably stable but as yet unoptimized btrfs raid10.

And of course there's one other alternative, zfs, if you are good with 
its hardware requirements and licensing situation.

But I'd recommend btrfs raid1 as the simple choice.  It's what I'm using 
here (tho on a pair of ssds, so far smaller but faster media, so 
different use-case).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

