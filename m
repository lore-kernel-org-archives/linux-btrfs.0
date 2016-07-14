Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbcGNMBs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 08:01:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bNfKr-0002l1-A3
	for linux-btrfs@vger.kernel.org; Thu, 14 Jul 2016 14:01:45 +0200
Received: from ip-64-134-228-164.public.wayport.net ([64.134.228.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2016 14:01:45 +0200
Received: from 1i5t5.duncan by ip-64-134-228-164.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2016 14:01:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs replace performance with missing drive
Date: Thu, 14 Jul 2016 12:01:36 +0000 (UTC)
Message-ID: <pan$97fa$5418116$c2d5a5b1$dde13409@cox.net>
References: <1468495129.19617.127.camel@seblu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sébastien Luttringer posted on Thu, 14 Jul 2016 13:18:49 +0200 as
excerpted:

> I have a performance issue with «btrfs replace» with raid5 and a 
_missing_
> device. My btrfs rely on 6x4TB HDD and the operating system is an 
Archlinux.
> 
> In a nutshell, I will need 23 to 46 days to replace on missing disk.


If you're still posting about this, it means you haven't been keeping up 
with list discussion over the last couple weeks and thus have missed the 
following.  I'll leave it to you to find the threads and get the details 
if you want, but here's the basics:

1) Btrfs raid56 mode has never really gotten to the stability level of 
the rest of btrfs, and recently a couple of fundamental defects in the 
current implementation have come to light, that unfortunately might well 
require a full rewrite to correct.

As such, btrfs raid56 mode, while never recommended except for those 
willing to be on the bleeding edge, is now negatively recommended, with 
the recommendation for those already using it being to switch to 
something more stable at their soonest convenience and to *ensure* that 
they either have backups or simply don't care about losing the data in 
the mean time.

2) Replace's often impractically slow performance in raid56 mode with a 
missing device was one of the known bugs keeping raid56 mode from being 
considered stable even before the above mentioned fundamental defects had 
come to light.  As such, for raid56 mode with a missing device, btrfs 
device add of the replacement, followed by btrfs device delete of the 
missing/failed drive (which forces a rebalance as part of the device 
delete), seems to be much faster, and is recommended, for raid56 mode 
with a missing device only, instead of btrfs replace.

So there's a workaround for your immediately reported problem, but that 
doesn't change the fact that there are fundamental issues with the 
current implementation, and that as such, getting off of raid56 mode as 
soon as convenient, and ensuring good backups of anything you don't want 
to lose in the mean time, is now recommended.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

