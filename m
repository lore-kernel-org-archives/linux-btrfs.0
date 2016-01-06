Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53673 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbcAFIGY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 03:06:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aGj6r-00006M-9A
	for linux-btrfs@vger.kernel.org; Wed, 06 Jan 2016 09:06:21 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 09:06:21 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 09:06:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confining scrub to a subvolume
Date: Wed, 6 Jan 2016 08:06:14 +0000 (UTC)
Message-ID: <pan$750ca$58478144$e752037f$54c8f93f@cox.net>
References: <56831EA2.3090807@totakura.in>
	<20151230173949.GH4227@twin.jikos.cz>
	<pan$88aff$ee7e2e75$cb54e003$bedb8f3a@cox.net>
	<568A5126.20801@totakura.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sree Harsha Totakura posted on Mon, 04 Jan 2016 12:01:58 +0100 as
excerpted:

> On 12/30/2015 07:26 PM, Duncan wrote:
>> David Sterba posted on Wed, 30 Dec 2015 18:39:49 +0100 as excerpted:
>> 
>>> On Wed, Dec 30, 2015 at 01:00:34AM +0100, Sree Harsha Totakura wrote:
>>>> Is it possible to confine scrubbing to a subvolume instead of the
>>>> whole file system?
>>>
>>> No. Srub reads the blocks from devices (without knowing which files
>>> own them) and compares them to the stored checksums.
>> 
>> Of course if like me you prefer not to have all your data eggs in one
>> filesystem basket and have used partitions (or LVM) and multiple
>> independent btrfs, in which case you scrub the filesystem you want, and
>> don't worry about the others. =:^)
> 
> I considered it, but after reading somewhere (couldn't find the source)
> that having a single btrfs could be beneficial, I decided not to.
> Clearly, it doesn't seem to be true in this case.

It depends very much on your viewpoint and use-case.

Arguably, btrfs should /eventually/ provide a more flexible alternative 
to lvm as a volume manager, letting you do subvolumes, restrict them if 
desired to some maximum size via quotas (which remain buggy and 
unreliable on btrfs ATM so don't try to use them for that yet), and let 
you "magically" add and remove devices from a single btrfs storage pool, 
changing quota settings as desired, without the hassle of managing 
individual partitions and multiple filesystems.

But IMO at least, and I'd guess in the opinion of most on the list, btrfs 
at its present "still stabilizing, not yet fully stable and mature" 
status, remains at least partially unsuited to that.  Besides general 
stability, some options, including quotas, simply don't work reliably 
yet, and other tools and features have yet to be developed.

But even in the future, when btrfs is stable and many are using these 
sorts of logical volume management and integrated filesystem features to 
do everything on a single filesystem, I'm still very likely to consider 
that a higher risk than I'm willing to take, because it'll still be 
ultimately putting all those data eggs in the filesystem basket, which if 
the bottom falls out...

In addition, I actually tried, for instance, big partitioned mdraids, 
with several filesystems each on their own partition of that mdraid, and 
I eventually came to the conclusion that at some point, they simply get 
too big, and maintenance simply takes too long, to be practical for me.  
When adding a multi-TB device to a big mdraid takes days...  I'd much 
rather have multiple much smaller mdraids, or now, btrfs raids, and 
perhaps still take days overall to do the same thing if I'm doing it to 
all of them, but in increments of a few hours each on multiple much 
smaller capacity ones, rather than a single-shot instance that takes days.

Meanwhile, my current btrfs layout is multiple mostly raid1 btrfs, on a 
pair of partitioned SSDs, which each partition under 50 GiB, under 100 
GiB for the raid1 filesystem, 50 on each device.  On that, scrubs 
normally take, literally, under a minute, full balances well under ten, 
per filesystem.  Sure, to do every single filesystem might still take say 
a half hour, but most of the time, not all filesystems are even mounted, 
and most of the time, I only need to scrub or balance perhaps three of 
them, so while if they were all in one I might do it in say 20 minutes, 
and if I had to do all of them it might take me 30 because I have to 
repeatedly type in the command for each one, because I have to do only 
three of them, it's done in five minutes or less.

That's in addition to the fact that if a filesystem dies, I've only a 
fraction of the data to btrfs restore or to copy over from backup, 
because most of it was on other filesystems, many of which weren't even 
mounted or in some cases (my /) were mounted read-only, so they're just 
fine and I don't have to btrfs restore or copy back over from backup, for 
them.

These are lessons I've learned in a quarter century of working with 
computers, about a decade on MS, a decade and a half later this year, on 
Linux.  They may not always apply to everyone, but I've definitely 
learned how to spare myself unnecessary pain, as I've learned how they 
apply to me. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

