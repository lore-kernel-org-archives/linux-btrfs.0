Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36290 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbcDEBpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 21:45:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anG3E-0001hK-3k
	for linux-btrfs@vger.kernel.org; Tue, 05 Apr 2016 03:45:04 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 03:45:04 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 03:45:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Tue, 5 Apr 2016 01:44:55 +0000 (UTC)
Message-ID: <pan$29fe9$b9ebd4f1$c02d7360$67ec3a8e@cox.net>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
	<pan$39ed6$7954b891$6122ae15$76baf1b0@cox.net>
	<20160404212628.14e83e37@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Mon, 04 Apr 2016 21:26:28 +0200 as excerpted:

> I'll go test the soon-to-die SSD as soon as it replaced. I think it's
> still far from failing with bitrot. It was overprovisioned by 30% most
> of the time, with the spare space trimmed.

Same here, FWIW.  In fact, I had expected to get ~128 GB SSDs and ended 
up getting 256 GB, such that I was only using about 130 GiB, so depending 
on relative to what the overprovisioning percentage is calculated 
against, I was and am near 50% or 100% overprovisioned.

So in my case I think the SSD was simply defective, such that the 
overprovisioning and trim simply didn't help.  Tho the other two 
identical brand and model devices I bought from the same store at the 
same time, so very likely the same manufacturing lot, were and are just 
fine (tho one is showing a trivial non-zero raw value for 5, reallocated 
sector count, and 182, erase fail count total, but both remain at 100% 
"cooked" value, but absolutely no issues on the other one, actually the 
one that wasn't replaced of the original pair, at all).

But based on that experience, while overprovisioning may help in terms of 
normal wearout, it doesn't necessarily help at all if the device is 
actually going bad.

> It certainly should have a
> lot of sectors for wear levelling. In addition, smartctl shows no sector
> errors at all - except for one: raw_read_error_rate. I'm not sure what
> all those sensors tell me, but that one I'm also seeing on hard disks
> which show absolutely no data damage.
> 
> In fact, I see those counters for my hard disks. But dd to /dev/null of
> the complete raw hard disk shows no sector errors. It seems good. But
> well, counting 1+1 together: I currently see data damage. But I guess
> that's unrelated.
> 
> Is there some documentation somewhere what each of those sensors
> technically mean and how to read the raw values and thresh values?

Nothing user/admin level that I'm aware of.  I'm sure there's some smart 
docs somewhere that describe them as part of the standard, but they could 
easily be effectively unavailable for those unwilling to pay a big-
corporate-sized consortium membership fee (as was the case with one of 
the CompactDisc specs, Orange Book IIRC, at one point).

I know there's some discussion by allusion in the smartctl manpage and 
docs, but many attributes appear to be manufacturer specific and/or to 
have been reverse-engineered by the smartctl devs, meaning even /they/ 
don't really have access to proper documentation for at least some 
attributes.

Which is sad, but in a majority proprietary or at best don't-care 
market...

> I'm also seeing multi_zone_error_rate on my spinning rust.

> According to smartctl health check and smartctl extended selftest,
> there's no problems at all - and the smart error log is empty. There has
> never been an ATA error in dmesg... No relocated sectors... From my
> naive view the drives still look good.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

