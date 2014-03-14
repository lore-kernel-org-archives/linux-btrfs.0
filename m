Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49918 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbaCNOgx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 10:36:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOTEA-00061B-IG
	for linux-btrfs@vger.kernel.org; Fri, 14 Mar 2014 15:36:50 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 15:36:50 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 15:36:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incremental backup for a raid1
Date: Fri, 14 Mar 2014 14:36:22 +0000 (UTC)
Message-ID: <pan$3d121$b887db46$4fafc3f2$f4e0c6a9@cox.net>
References: <1564384.fRV1HUkfCq@fuchsia>
	<pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>
	<1549230.7yEi5AM4H9@fuchsia>
	<pan$4e795$762009e5$6f734697$16ccd0b0@cox.net>
	<5323082B.50600@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Mitchell posted on Fri, 14 Mar 2014 06:46:19 -0700 as excerpted:

> Actually, an interesting concept would be to have the initial two drive
> RAID 1 mirrored by 2 additional drives in 4-way configuration on a
> second machine at a remote location on a private high speed network with
> both machines up 24/7.  In that case, if such a configuration would
> work, either machine could be obliterated and the data would survive
> fully intact in full duplex mode.  It would just need to be remounted
> from the backup system and away it goes.  Just thinking of interesting
> possibilities with n-way mirroring.  Oh how I would love to have n-way
> mirroring to play with!

In terms of raid1, mdraid already supports such a concept with its "write 
mostly" component device designation.  A component device designated 
"write mostly" is never read from unless it becomes the only device 
available, so it's perfect for such an "over-the-net real-time-online-
backup" solution.

The other half of the solution are the various block-device-over-network 
drivers such as BLK_DEV_NBD (see Documentation/blockdev/nbd.txt) for the 
client side, the server-side of which is in userspace.  That lets you 
have what appears to be a block-device routed over the inet to that 
remote location.

Of course mdraid is lacking btrfs' data integrity features, etc, with its 
raid1 implementation entirely lacking any data integrity or real-time 
cross-checking at all, but unlike btrfs' N-way-mirroring it gets points 
for actually being available right now, so as they say, YMMV.

Of course the other notable issue with your idea is that while it DOES 
address the real-time remote redundancy issue, that doesn't (by itself) 
deal with fat-fingering or similar issues where real-time actually means 
the same problem's duplicated to the backup as well.

But btrfs snapshots address the fat-fingering issue and can be done on 
the partially-remote filesystem solution as well, and local or remote-
local solutions (like periodic btrfs send to a separate local filesystem 
at both ends) can deal with the filesystem damage possibilities.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

