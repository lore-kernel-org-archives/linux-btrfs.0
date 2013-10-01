Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36420 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3JAEoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 00:44:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQroZ-0004Uo-Uj
	for linux-btrfs@vger.kernel.org; Tue, 01 Oct 2013 06:44:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 06:44:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 06:44:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Progress of device deletion?
Date: Tue, 1 Oct 2013 04:43:45 +0000 (UTC)
Message-ID: <pan$d4ca0$5ff8830c$a79d58d4$78936022@cox.net>
References: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com>
	<2E504581-FA34-425A-B14B-EF3F16FC655C@colorremedies.com>
	<F4008F3B-594D-4003-BC06-82B9E18AA023@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 30 Sep 2013 19:05:36 -0600 as excerpted:

> It probably seems weird to add drives to remove drives, but sometimes
> (always?) Btrfs really gets a bit piggish about allocating a lot more
> chunks than there is data. Or maybe it's not deallocating space as
> aggressively as it could. So it can get to a point where even though
> there isn't that much data in the volume (in your case 1.5x the drive
> size, and you have 4 drives) yet all of it's effectively allocated. So
> to back out of that takes free space. Then once the chunks are better
> allocated, you'd have been able to remove the drives.

As I understand things and from what I've actually observed here, btrfs 
only allocates chunks on-demand, but doesn't normally DEallocate them at 
all, except during balance, etc, when it rewrites all the (meta)data that 
matches the filters, compacting all those "data holes" that were opened 
up thru deletion in the process, by filling chunks as it rewrites the 
(meta)data.

So effectively, allocated chunks should always be the high-water-mark 
(rounded up to the nearest chunk size) of usage since the last balance 
effectively compacted chunk usage, because chunk allocation is automatic 
but chunk deallocation requires a balance.

This is actually a fairly reasonable approach in the normal case, since 
it's reasonable to assume that even if the size of the data has reduced 
substantially, if it once reached a particular size, it's likely to reach 
it again, and particularly the deallocation process has a serious time 
cost to rewrite the remaining active data to other chunks, so best to 
just let it be unless an admin decides it's worth eating that cost to get 
the lower chunk allocation and invokes a balance to effect that.


So as you were saying, the most efficient way to delete a device could be 
to add one first if chunk allocation is almost maxed out and well above 
actual (meta)data size, then do a balance to rewrite all those nearly 
empty chunks to nearly full ones and shrink the number of allocated 
chunks to something reasonable as a result, and only THEN, when there's 
some reasonable amount of unallocated space available, attempt the device 
delete.


Meanwhile, I really do have to question the use case where the risks of a 
single dead device killing a raid0 (or for that matter, running still 
experimental btrfs) are fine, but spending days doing data maintenance on 
data not valuable enough to put on anything but experimental btrfs raid0, 
is warranted over simply blowing the data away and starting with brand 
new mkfs-ed filesystems.  That a strong hint to me that either the raid0 
use case is wrong, or the days of data move and reshape instead of 
blowing it away and recreating brand new filesystems, is wrong, and that 
one or the other should be reevaluated.  However, I'm sure there must be  
use cases for which it's appropriate, and I simply don't have a 
sufficiently creative imagination, so I'll admit I could be wildly wrong 
on that.   If a sysadmin is sure he's on solid ground with his use case, 
for him, he very well could be.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

