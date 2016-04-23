Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35479 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbcDWFiU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Apr 2016 01:38:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1atqGm-0001ll-Hd
	for linux-btrfs@vger.kernel.org; Sat, 23 Apr 2016 07:38:16 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Apr 2016 07:38:16 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Apr 2016 07:38:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Add device while rebalancing
Date: Sat, 23 Apr 2016 05:38:10 +0000 (UTC)
Message-ID: <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juan Alberto Cirez posted on Fri, 22 Apr 2016 14:36:44 -0600 as excerpted:

> Good morning,
> I am new to this list and to btrfs in general. I have a quick question:
> Can I add a new device to the pool while the btrfs filesystem balance
> command is running on the drive pool?

Adding a device while balancing shouldn't be a problem.  However, 
depending on your redundancy mode, you may wish to cancel the balance and 
start a new one after the device add, so the balance will take account of 
it as well and balance it into the mix.

Note that while device add doesn't do more than that on its own, device 
delete/remove effectively initiates its own balance, moving the chunks on 
the device being removed to the other devices.  So you wouldn't want to 
be running a balance and then do a device remove at the same time.

Similarly with btrfs replace, altho in that case, it's more directly 
moving data from the device being replaced (if it's still there, or using 
redundancy or parity to recover it if not) to the replacement device, a 
more limited and often faster operation.  But you probably still don't 
want to do a balance at the same time as it places unnecessary stress on 
both the filesystem and the hardware, and even if the filesystem and 
devices handle the stress fine, the result is going to be that both 
operations take longer as they're both intensive operations that will 
interfere with each other to some extent.

Similarly with btrfs scrub.  The operations are logically different 
enough that they shouldn't really interfere with each other logically, 
but they're both hardware intensive operations that will put unnecessary 
stress on the system if you're doing more than one at a time, and will 
result in both going slower than they normally would.

And again with snapshotting operations.  Making a snapshot is normally 
nearly instantaneous, but there's a scaling issue if you have too many 
per filesystem (try to keep it under 2000 snapshots per filesystem total, 
if possible, and definitely keep it under 10K or some operations will 
slow down substantially), and deleting snapshots is more work, so while 
you should ordinarily automatically thin down snapshots if you're 
automatically making them quite frequently (say daily or more 
frequently), you may want to put the snapshot deletion, at least, on hold 
while you scrub or balance or device delete or replace.

Meanwhile, you mentioned being new to btrfs.  If you haven't discovered 
the wiki yet, please spend some time reading the user documentation 
there, as it's likely to clear up a lot of questions you may have, and 
you'll better understand how to effectively work with the filesystem when 
you're done.  It's well worth the time invested! =:^)

https://btrfs.wiki.kernel.org


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

