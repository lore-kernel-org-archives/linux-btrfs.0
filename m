Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbaEFUwM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 16:52:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhmLS-0003ls-35
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 22:52:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 22:52:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 22:52:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Thoughts on RAID nomenclature
Date: Tue, 6 May 2014 20:51:57 +0000 (UTC)
Message-ID: <pan$c6c07$3362ec6f$a8e07dc1$37606705@cox.net>
References: <20140505211738.GS24298@carfax.org.uk>
	<536806E5.9010409@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Mon, 05 May 2014 23:47:17 +0200 as excerpted:

>> At the moment, we have two chunk allocation strategies: "dup" and
>> "spread" (for want of a better word; not to be confused with the
>> ssd_spread mount option, which is a whole different kettle of borscht).
>> The dup allocation strategy is currently only available for 2c
>> replication, and only on single-device filesystems. When a filesystem
>> with dup allocation has a second device added to it, it's automatically
>> upgraded to spread.
> 
> I thought this step was manual - but okay! :)

AFAIK, the /allocator/ automatically updates to "spread" when a second 
device is added.  That is, assuming previous dup metadata on a single 
device, adding a device will cause new allocations to be in raid1/spread 
mode, instead of dup.

What's manual, however, is that /existing/ chunk allocations don't get 
automatically updated.  For that, a balance must be done.  But existing 
allocations are by definition already allocated, so the chunk allocator 
doesn't do anything with them.  (A rebalance allocates new chunks, 
rewriting the contents of the old chunks into the new ones before 
unmapping the now unused old chunks, so again, existing chunks stay where 
they are until unmapped, it's the NEW chunks that get mapped by the 
updated allocation policy.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

