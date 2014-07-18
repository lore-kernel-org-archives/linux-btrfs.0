Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59011 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761234AbaGRKp6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 06:45:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X85fl-0007CP-7M
	for linux-btrfs@vger.kernel.org; Fri, 18 Jul 2014 12:45:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:45:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 12:45:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Questions on incremental backups
Date: Fri, 18 Jul 2014 10:45:37 +0000 (UTC)
Message-ID: <pan$b430d$ca43159e$977364a9$ed50906b@cox.net>
References: <1405627978.2630.39.camel@s-Air>
	<e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Fri, 18 Jul 2014 14:35:20 +1000 as excerpted:

> Daily snapshots work welk with kernel 3.14 and above (I had problems
> with 3.13 and previous). I have snapshots every 15 mins on some subvols.
> 
> Very large numbers of snapshots can cause performance problems. I
> suggest keeping below 1000 snapshots at this time.

The other caveat with btrfs snapshots is how they deal with NOCOW files, 
the usual workaround recommended for large (Gig-ish-plus) internal-
rewrite-pattern files such as databases and VM images.

I'll avoid a detailed discussion here since I don't know whether it 
applies to the OP's use-case and the problem and workarounds are well 
discussed in other threads, but this is a heads-up for the OP to do a bit 
of research on the topic if he /does/ deal with gig-plus sized VM images 
or databases.  Very briefly, putting such files on their own subvolume 
and using more traditional backup techniques instead of snapshotting is 
recommended.  Another alternative is partitioning and choosing a 
filesystem other than btrfs for those files, while still considering 
btrfs for other files.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

