Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32864 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbcFIPlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 11:41:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bB25B-0000I2-VB
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 17:41:22 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 17:41:21 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 17:41:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Thu, 9 Jun 2016 15:41:15 +0000 (UTC)
Message-ID: <pan$2dac6$9a9c194e$57b6cef4$3686a053@cox.net>
References: <572D0C8B.8010404@mendix.com>
	<89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
	<5758A5F6.4060400@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Thu, 09 Jun 2016 01:10:46 +0200 as
excerpted:

> The next question is what files these extents belong to. To find out, I
> need to open up the extent items I get back and follow a backreference
> to an inode object. Might do that tomorrow, fun.
> 
> To be honest, I suspect /var/log and/or the file storage of mailman to
> be the cause of the fragmentation, since there's logging from postfix,
> mailman and nginx going on all day long in a slow but steady tempo.
> While using btrfs for a number of use cases at work now, we normally
> don't use it for the root filesystem. And the cases where it's used as
> root filesystem don't do much logging or mail.

FWIW, that's one reason I have a dedicated partition (and filesystem) for 
logs, here.  (The other reason is that should something go runaway log-
spewing, I get a warning much sooner when my log filesystem fills up, not 
much later, with much worse implications, when the main filesystem fills 
up!)

> And no, autodefrag is not in the mount options currently. Would that be
> helpful in this case?

It should be helpful, yes.  Be aware that autodefrag works best with 
smaller (sub-half-gig) files, however, and that it used to cause 
performance issues with larger database and VM files, in particular.  
There used to be a warning on the wiki about that, that was recently 
removed, so apparently it's not the issue that it was, but you might wish 
to monitor any databases or VMs with gig-plus files to see if it's going 
to be a performance issue, once you turn on autodefrag.

The other issue with autodefrag is that if it hasn't been on and things 
are heavily fragmented, it can at first drive down performance as it 
rewrites all these heavily fragmented files, until it catches up and is 
mostly dealing only with the normal refragmentation load.  Of course the 
best way around that is to run autodefrag from the first time you mount 
the filesystem and start writing to it, so it never gets overly 
fragmented in the first place.  For a currently in-use and highly 
fragmented filesystem, you have two choices, either backup and do a fresh 
mkfs.btrfs so you can start with a clean filesystem and autodefrag from 
the beginning, or doing manual defrag.

However, be aware that if you have snapshots locking down the old extents 
in their fragmented form, a manual defrag will copy the data to new 
extents without releasing the old ones as they're locked in place by the 
snapshots, thus using additional space.  Worse, if the filesystem is 
already heavily fragmented and snapshots are locking most of those 
fragments in place, defrag likely won't help a lot, because the free 
space as well will be heavily fragmented.   So starting off with a clean 
and new filesystem and using autodefrag from the beginning really is your 
best bet.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

