Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58666 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaF2Ca6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 22:30:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X14tM-0006G4-Ua
	for linux-btrfs@vger.kernel.org; Sun, 29 Jun 2014 04:30:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 04:30:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 04:30:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 3+ drives
Date: Sun, 29 Jun 2014 02:30:43 +0000 (UTC)
Message-ID: <pan$851b1$4b6a3090$beaa984b$707a921a@cox.net>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
	<10572318.CAuhDIAMDU@xev> <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
	<20140628161347.2097d308@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sat, 28 Jun 2014 16:13:47 +0600 as excerpted:

> Also depending on what you consider "fully works", RAID1 may not qualify
> too,
> as neither the read-balancing, nor write-submission algorithms are ready
> for production use, performance-wise.
> 
> (RAID1 writes to two disks sequentially, not at the same time; and reads
> are satisfied from in effect a random device, not from the least-busy
> device).

Good point.  The current algorithms were designed as "good enough" stand-
ins for testing.  They were /not/ designed as highly efficient
parallel-I/O on parallel devices and cores implementations, as that was 
to come later.

Of course part of /that/ problem is that often enough, the I/O channel 
is /not/ the bottleneck, the bottleneck is still the horrible scaling 
issues due to calculating the interplay between all those snapshots and 
quotas and massive internal-rewrite-pattern-VM-images, thus the reason we 
have snapshot-aware-defrag disabled ATM, so arguably focusing on the most 
efficient I/O queues algorithm at this point would be premature 
optimization, which would mean it's a /good/ thing they haven't focused 
on updating them yet.  Once these horrible scaling issues are addressed 
and snapshot-aware-defrag and the like can be enabled again without 
triggering week-going-and-it's-still-not-half-done issues, /then/ perhaps 
it's time to look at the parallel I/O queuing and balancing algorithms.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

