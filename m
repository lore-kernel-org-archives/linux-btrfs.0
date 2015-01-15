Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58141 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbbAOWwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 17:52:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YBtHX-0003xm-0j
	for linux-btrfs@vger.kernel.org; Thu, 15 Jan 2015 23:52:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 23:52:50 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 23:52:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BtrFs on drives with error recovery control / TLER?
Date: Thu, 15 Jan 2015 22:52:45 +0000 (UTC)
Message-ID: <pan$4400a$2a1b3182$7ae7e911$d2acb24@cox.net>
References: <54B81AE2.7050902@pocock.pro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Pocock posted on Thu, 15 Jan 2015 20:54:10 +0100 as excerpted:

> Can anybody comment on how BtrFs (particularly RAID1 mirroring)
> interacts with drives that offer error recovery control (or TLER in WDC
> terms)?
> 
> I generally prefer to buy this type of drive for any serious data
> storage purposes
> 
> I notice ZFS gets a mention in the Wikipedia article about the topic:
> http://en.wikipedia.org/wiki/Error_recovery_control
> 
> Should BtrFs be mentioned there too?

I make no claims to being an expert in this area and others with more 
expertise will likely be along shortly.  However...

In general you have a valid worry, and the recommendation is as with 
other raid technology, if possible, set your device to a recovery time 
under 30 seconds, as that's the default Linux SCSI level link reset time, 
and it will short-circuit the process and doesn't get the bad sector 
marked as such and remapped to a reserve sector, on the device.

On consumer level devices where setting the device recovery time isn't 
possible, the hard-wired recovery time can be near two minutes, so the 
recommendation is to set the Linux SCSI level link reset time to 120 
seconds or so, thus allowing the hardware device to timeout first so it 
can again recognize the bad sector and do its remapping thing.

In general, this recommendation should apply to all Linux-kernel-based 
soft-raid technologies (including btrfs, mdraid, dmraid...) where the 
raid redundancy can fill in the missing data so letting it fail and 
potentially trigger a remap is the best strategy.

OTOH, the shorter time wouldn't be recommended (tho a longer SCSI reset 
time well could be) for a single-device btrfs or a multi-device btrfs in 
raid0 or single mode, because in those cases, the assumption is that 
there's no other copies of the data, so letting the device take up to two 
minutes to try to retrieve that data in the hope that the extra tries 
will finally be successful, can very possibly save that data... of course 
at the cost of a system that goes unresponsive for upto two minutes at a 
time, which clearly isn't going to work if it's happening frequently.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

