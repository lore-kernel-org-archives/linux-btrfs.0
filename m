Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58956 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbaDIL4h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 07:56:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WXr7J-0008Ed-20
	for linux-btrfs@vger.kernel.org; Wed, 09 Apr 2014 13:56:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 13:56:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 13:56:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using noCow with snapshots ?
Date: Wed, 9 Apr 2014 11:56:20 +0000 (UTC)
Message-ID: <pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net>
References: <1541415.olHfkWYf4R@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Wed, 09 Apr 2014 13:15:24 +0200 as excerpted:

> In the quest for BTRFS and performance, and having received the advice
> to "chattr +C" my akonadi DB directory to make it noCow, I would like to
> be sure about what will happen when I take a snapshot of the concerned
> BTRFS subvolume.
> 
> 1/ Being noCow, will the database be modified in the snapshot as well,
> efectively defeating the snapshot ?
> 
> 2/ Being snapshotted, will the database be COWed even though it's
> supposed to be noCow ?
> 
> 3/ Are both options mutually incompatible in some more osbcure ways ?
> 
> I'd like to know where I'm going with this ;-)


Good questions. =:^)

#2. That's from one of the devs when the question came up perhaps a 
couple months ago.

On a NOCOW file the first write to a fileblock (4096 bytes) after a 
snapshot must still be COW, because the snapshot locks the old version in 
place, and now the fileblock has changed, so it MUST be written elsewhere 
despite the NOCOW in ordered to keep the snapshot as it was.  However, 
the file does retain the NOCOW attribute and additional writes to the 
same fileblock will be in-place... until the next snapshot of course.

This is why on filesystems with scripted snapshots as close as a minute a 
part (I even saw one guy say he was doing them every 30 seconds!!), 
setting NOCOW has very little value -- they aren't NOCOW on the first 
write after a snapshot, and with snapshots happening every minute...,  
Hourly snapshots are still likely to be a problem on a regularly changing 
file, tho with daily snapshots you'd probably save some fragmentation 
over the fairly short term anyway, but it'd still be a problem longer 
term.

Which is why I suggest putting such files on a separate subvolume and not 
snapshotting that subvolume, since snapshots stop at the subvolume 
boundary.  That gives NOCOW a chance to actually *BE* NOCOW.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

