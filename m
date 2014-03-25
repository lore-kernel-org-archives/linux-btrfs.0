Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52270 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaCYQxS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 12:53:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSUbE-0004Ft-1W
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 17:53:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 17:53:16 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 17:53:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "Asymmetric" RAID0
Date: Tue, 25 Mar 2014 16:52:47 +0000 (UTC)
Message-ID: <pan$c6bbb$e31857d7$d3530345$ba2c0e6e@cox.net>
References: <CADef55oE1UQbmEnvXcXuYxEwdR=ktYsC2C+QzTjQWu7h5vA7NQ@mail.gmail.com>
	<53312549.6040207@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Tue, 25 Mar 2014 08:42:17 +0200 as excerpted:

> The "raid0" will always distribute data to each disk relatively equally.
> There are exceptions of course. The way to have it better utilise the
> diskspace is to use either "single" (which won't get the same
> performance as raid0) or to add a third disk.
> 
> In any raided configuration, the largest disk won't be fully utilised
> unless the other disks add up to be equal to or more than that largest
> disk.
> 
> Play around with Hugo's disk usage calculator to get a better idea of
> what the different configurations will do:
> http://carfax.org.uk/btrfs-usage/

Agreed.  Adding...

The wiki's multi-device page says this:

"""""
When you have drives with differing sizes and want to use the full 
capacity of each drive, you have to use the single profile for the data 
blocks, rather than raid0. 
"""""
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

Further explanation for this reply:

Each raidN mode has a minimum number of devices it can use.  For raid0 
(and raid1), that's two devices, otherwise it's no longer raidN, but 
single (or dup) mode.

That's why btrfs won't be able to use ~500 gig of the larger device, 
since when it fills up the smaller, there's no way to continue raid0 
striping.

If you added a third device the same size as the larger device (931 gig), 
btrfs would stripe across three devices until it filled the smaller, then 
across the two remaining devices.

If, however, the third device was only ~ 500 gig, you'd have roughly the 
same problem, as it would stripe three ways until the smallest was full, 
then two ways until the second-smallest was full, again leaving the 
remember unusable.

Tho I don't see where the 20 gig number comes from, as the smaller device 
still had 230-ish gigs unallocated, so you (OP not Brendan) should be 
safe for 200 gig or so more allocation, which combined with the 200 that 
would also be allocated on the larger drive, would be about 400 gig or so 
of additional data, depending on how that unallocated space gets 
allocated and whether you rebalance as the allocated space on the smaller 
drive drops toward zero, to return any available allocated but not fully 
used chunks to unallocated.

As Brendan says, however, switching to single mode instead of raid0 
should let you use all the space, tho with less performance, because that 
doesn't require the striping.

In theory at least, you /could/ even switch to single mode as you 
approached full on the raid0, doing a rebalance-convert, but then 
canceling it right away, before it has actually converted much to 
single.  That /should/ leave most of the existing chunks (minus the few 
converted before the balance-convert was canceled as raid0, while telling 
the filesystem that new allocations should be single, not raid0.  But I'm 
not sure if that would actually work in practice, as I'm not sure how 
btrfs would do further data block allocations in that case.  Also, you'd 
have to be careful while doing further balances so as not to disturb the 
raid0/single ratio and push over the edge on the smaller device.  So 
unless you decide to be the guinea pig, I'd suggest leaving that as "in 
theory", but if you want to try it, I'm sure I'm not the only one who'd 
be interested in your report of how it goes. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

