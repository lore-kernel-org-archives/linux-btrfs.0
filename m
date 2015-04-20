Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46584 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbbDTFXz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 01:23:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yk4BT-0008N6-Q6
	for linux-btrfs@vger.kernel.org; Mon, 20 Apr 2015 07:23:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 07:23:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 07:23:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to clone a btrfs filesystem
Date: Mon, 20 Apr 2015 05:23:46 +0000 (UTC)
Message-ID: <pan$774e3$bc27dda5$8703f13a$d11ec028@cox.net>
References: <1429312124.8371.62.camel@scientia.net>
	<201504180424.40385.russell@coker.com.au>
	<1429334269.8371.75.camel@scientia.net>
	<201504190102.42660.russell@coker.com.au>
	<1429473624.24823.38.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sun, 19 Apr 2015 22:00:24 +0200 as
excerpted:

> Most of the time, only one of the two disks shows activity, while the
> other is reading respectively writing.
> The CPU isn't really under full load either (not even a single core),...
> it's rather in the 5-10% utilisation.
> The resulting transferspeed is about 21,5 MB/s (not MiB).
> Seems to be pretty low...

In general, btrfs hasn't really been optimized yet.  One of the more 
obvious cases of this is the btrfs raid1 mode read case, where the read-
scheduling algorithm is simple even/odd based on the PID, which means a 
single read thread will bottleneck on a single device, even if the other 
one is totally idle.

That's the biggest "forget optimization, 50% utilization is the best-case 
as we're not yet optimizing" example out there, AFAIK.

Which, given the common developer wisdom about premature optimization, 
can be explained.  But accepting that explanation, one is still stymied 
by the fact that all the previous warnings about btrfs being in heavy 
development, keep good backups and be prepared to use them, etc, are 
being stripped, because btrfs is supposedly ready for normal use now.  
But if it's ready for normal use, why isn't it optimized for normal use, 
then?  And if it's not ready for normal use, why are the warnings 
actually telling people that being prematurely stripped?

IMO, therefore, a major btrfs development milestone will be when they 
decide development has stabilized enough that it's time to actually 
optimize these things for production use, and that doing so is no longer 
"premature optimization", because the filesystem is mature and its 
methods stable enough that optimization is no longer premature.  Once 
/that/ happens, arguably then, and /only/ then, can /real/ discussion 
start on whether/when btrfs is /truly/ mature and stable.

Until that optimization, then, the clear answer is that btrfs is not yet 
stable, because developers are demonstrating by their failure to 
optimize, that they don't consider the filesystem mature and stable 
enough for it yet, such that any major effort at optimization (as opposed 
to simply taking the opportunity when it presents itself as the most 
sensible option) is premature.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

