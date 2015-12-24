Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45617 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbbLXCEw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 21:04:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBvGs-00050c-C1
	for linux-btrfs@vger.kernel.org; Thu, 24 Dec 2015 03:04:50 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 03:04:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 03:04:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs und lvm-cache?
Date: Thu, 24 Dec 2015 02:04:43 +0000 (UTC)
Message-ID: <pan$22dc8$3670cf4f$29866f7c$946ede75@cox.net>
References: <n5du09$9rn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Neuer User posted on Wed, 23 Dec 2015 11:45:28 +0100 as excerpted:

> - both hdd and ssd in one LVM VG
> - one LV on each hdd, containing a btrfs filesystem
> - both btrfs LV configured as RAID1
> - the single SDD used as a LVM cache device for both HDD LVs to speed up
> random access, where possible

I'll let others debate the lvm-cache details, which I don't know much
about, but I do have a couple points to add, one of which is detail,
one rather higher level.  The higher level one first:

1) While I've seen both bcache and lvm-cache discussed as potential
options here, there is at least one user using bcache on top of btrfs
that posts to bcache-related threads here with some regularity.
While there were some serious bugs to work thru early on, his
recent posts suggest current bcache works very well with current
btrfs, and given that he has posted to several threads with some
time separation between them, he does appear to be a regular here,
and I expect he'd be posting pretty fast if things started going
buggy for him once again.

There hasn't been a corresponding regular poster here using lvm-cache,
so while it may work well, we don't know that.  At minimum, postings
thus suggest that bcache on btrfs is a better tested solution at
this point, and thus, would be recommended, while lvm-cache on btrfs,
while an equally valid technical choice in theory, doesn't have much
if any real-world data going for it at this point, and is thus
in practice an unknown.

2) Not being the person using bcache and not being familiar with it
or lvm-cache personally, I don't know how either one handle btrfs
multi-device.  However, it occurs to me that if it's necessary,
in addition to the multiple ssds suggested by the others to cover
such multi-device caching, you should also be able to partition
up the ssd, and use each partition as an individual device cache.
That's almost certainly what I'd do here if I needed to (except
that above a certain size, ssd prices per GiB start to go up
dramatically, so if I wanted total ssd cache sizes above that I'd
of course pay less for multiple smaller ssds again) instead of
fiddling with multiple physical ssds, but again, not knowing
how the caching works, I'm not sure if multiple cache devices
would be needed to cache a multi-device btrfs at the back end,
or not, so I don't know whether I'd need to bother with such
partitioning or not.

The key here is that on ssds, seek time is zero anyway, so
partitioning up the ssd and using both partitions as cache
doesn't have the latency issues that attempting to do something
like that (or for example btrfs raid1 on two partitions on the
same physical device) would have on spinning rust.


I thought I'd throw those points out, in case you had failed to
notice bcache as an option and would prefer it as better tested,
once you knew about it, and in case the partitioned ssd idea
does help with the multi-device btrfs caching thing.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

