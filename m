Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40916 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbaBPSTF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 13:19:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WF6Ix-0006fQ-Bv
	for linux-btrfs@vger.kernel.org; Sun, 16 Feb 2014 19:19:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 19:19:03 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 19:19:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC with 270GiB free
Date: Sun, 16 Feb 2014 18:18:38 +0000 (UTC)
Message-ID: <pan$3dcd9$71bbddfa$a9318b9a$e36a9655@cox.net>
References: <20140216135808.GA1491@frosties>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goswin von Brederlow posted on Sun, 16 Feb 2014 14:58:08 +0100 as
excerpted:

> As you can see there are still 270GiB free and plenty of block groups
> free on the device too.
> 
> So why isn't btrfs allocating a new block group to store more data?

I saw this on a much (much) smaller filesystem a few weeks ago, when I 
redid my /boot.  In my case it was under a gig total, so mixed-mode, but 
copying files over in a particular order errored some of them out with 
ENOSPC.  But the way I was copying (using mc) left the ones that hadn't 
copied selected, and I tried a copy of them again, and/or used mc's 
directory-diff to find the missing files and copy them over again.  After 
about three times, they all copied.

So some combination of size and metadata wasn't triggering a new block 
allocation, but coming in a different order, it triggered fine.  Again, 
this was mixed-mode, so data/metadata blocks mixed, and it didn't matter 
which ran out first since they were combined.

I wonder if you're running into something similar.  Can you try doing the 
copy in a different order, or is it one big file?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

