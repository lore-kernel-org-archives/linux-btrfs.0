Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58785 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaEVUwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 16:52:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WnZyn-0002oQ-Qh
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 22:52:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 22:52:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 22:52:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.15.0-rc5: btrfs and sync deadlock:
 call_rwsem_down_read_failed / balance seems to create locks that block
 everything else
Date: Thu, 22 May 2014 20:52:34 +0000 (UTC)
Message-ID: <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net>
References: <20140522090921.GA12037@merlins.org>
	<20140522131528.GB22952@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Thu, 22 May 2014 06:15:29 -0700 as excerpted:

> Balance cancel hangs too and so does sync [...]

For balance, if it comes to having to stop it on new mount after a 
shutdown, there is of course the skip_balance mount option.

> I was able to stop my btrfs send/receive, in turn this unlocked sync
> which succeeded too (2mn later).
> btrfs balance cancel did not return, but maybe that's normal.
> I see:
> legolas:~# btrfs balance status /mnt/btrfs_pool2/
> Balance on '/mnt/btrfs_pool2/' is running, cancel requested
> 383 out of about 388 chunks balanced (457 considered),   1% left
> 
> It's been running for at least 15mn in 'cancel mode'. Is that normal?

I'd guess so.  It's probably in the middle of operations for a single 
chunk, and only checks for cancel between chunks.  Given the possible 
complexity of those operations with snapshotting and quotas factored in 
as well as COW fragmentation, 15 minutes on a single chunk isn't 
/entirely/ out there.

That being symptomatic of the whole performance problem they're battling 
ATM.  They've turned off snapshot-aware-defrag for the time being, and 
there's the quota handling rework in the pipeline, but...

> The system doesn't seem hung, but it seems that running anything else
> while balance is running creates an avalanche of locks that kills
> everything.
> 
> Is that a known performance problem?

Yes, in that at least there's currently a definite known problem with 
balance and snapshotting and snapshot deletion and send all going on at 
the same time, as is certainly a possibility if some of those are on a 
cron job that the admin running the other(s) didn't think about when they 
initiated their own commands.

I've seen patches for at least one related race-related problem (where 
snapshot deletion could collide with balance or send) go by, and don't 
believe it's in Linus-mainline yet, tho I haven't closely tracked status 
beyond that.

Basically, at this point running only one such "major" btrfs operation at 
a time should drastically reduce the possibility of problems, because 
there /are/ known races.  Even after the known races are fixed, it's 
probably a good idea anyway where possible, since just one such operation 
is complex enough and running more than one at a time is only going to 
slow them all down as well as requiring more CPU/IO/memory bandwidth, but 
there /is/ recognition of the very real likelihood that people /will/ end 
up doing it, especially since one or more of the operations may be cron 
jobs that the admin isn't thinking about, so they're /trying/ to make it 
work.  But "just don't do that" does remain the best policy, where it's 
possible.  And of course right now there are known collision issues, so 
definitely avoid it ATM.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

