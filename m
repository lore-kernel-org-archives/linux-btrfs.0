Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40980 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaAVPjv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 10:39:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W5zu9-0004A4-Uh
	for linux-btrfs@vger.kernel.org; Wed, 22 Jan 2014 16:39:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 16:39:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 16:39:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrubbing with BTRFS Raid 5
Date: Wed, 22 Jan 2014 15:39:27 +0000 (UTC)
Message-ID: <pan$90f3c$88756f33$d6abe04$395cafd4@cox.net>
References: <DC8CDADE-5C7A-4DA3-8081-EB631136621B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Fleming posted on Tue, 21 Jan 2014 10:03:26 -0800 as excerpted:

> I want to keep playing around with BTRFSS RAID 5 and testing with it...
> assuming I have a drive with bad blocks, or let's say some inconsistent
> parity am I right in assuming that a) a btrfs scrub operation will not
> fix the stripes with bad parity

What I know is that it is said btrfs scrub doesn't work with btrfs raid5/6 
yet.  I don't know how it actually fails (tho I'd hope it simply returns 
an error to the effect that it doesn't work with raid5/6 yet) as I've not 
actually tried that mode, here.

> and b) a balance operation will not be
> successful? Or would a balance operation work to re-write parity?

Balance actually rewrites everything (well, everything matching its 
filters if a filtered balance is used, everything, if not), so it should 
rewrite parity correctly.

AFAIK, all the writing works and routine read works.  It's the error 
recovery that's still only partially implemented.  Since reading just 
reads data, not parity unless there's a dropped device or the like to 
recover from, as long as all devices are active and there's a good copy 
of the data (based on btrfs checksumming) to read, the rebalance should 
just use and rewrite that, ignoring the bad parity.



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

