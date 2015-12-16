Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39445 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879AbbLPJzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 04:55:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a98nj-0007Io-DD
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 10:55:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 10:55:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 10:55:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: dear developers, can we have notdatacow + checksumming, plz?
Date: Wed, 16 Dec 2015 09:55:08 +0000 (UTC)
Message-ID: <pan$5e79$48bd5e4f$cab49683$cb54fe41@cox.net>
References: <1450069158.2388.72.camel@scientia.net>
	<566ECF41.10709@gmail.com> <1450149311.701.126.camel@scientia.net>
	<56703928.7070003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 15 Dec 2015 11:00:40 -0500 as
excerpted:

> AFAIUI, checksums are stored per-instance for every block.  This is
> important in a multi-device filesystem in case you lose a device, so
> that you still have a checksum for the block.  There should be no
> difference between extent layout and compression between devices
> however.

I don't believe that's quite correct.

What is correct, to the best of my knowledge, is that checksums are 
metadata, and thus have whatever duplication/parity level metadata is 
assigned.

For single devices, that is of course by default dup, 2X the metadata and 
thus 2X the checksums, both on the single data (as effectively the only 
choice on a single device, at least thru 4.3, tho there's a patch adding 
dup data as an option that I think should be in 4.4) when covering data, 
dup metadata when covering it.

For multiple devices, it's default raid1 metadata, default single data, 
so the picture doesn't differ much by default from the single-device 
default picture.  It's also possible to do single metadata, raidN data, 
which really doesn't make sense except for raid0 data, and thus I believe 
there's a warning about that sort of layout in newer mkfs.btrfs, or when 
lowering the metadata redundancy using balance filters.

But of course it's possible to do raid1 data and metadata, which would be 
two copies of each, regardless of the number of devices (except that it's 
2+, of course).  But the copies aren't 1:1 assigned.  That is, if they're 
equal generation, btrfs can read either checksum and apply it to either 
data/metadata block.  (Of course if they're not equal generation, btrfs 
will choose the higher one, thus covering the case of writing at the time 
of a crash, since either they will both be the same generation if the 
root block wasn't updated to the new one on either one yet, or one will 
be a higher/newer generation than the other, if it had already finished 
writing one but not the other at the time of the crash.)

This is why it's an extremely good idea if you have a pair of devices in 
raid1, and you mount one of them degraded/writable with the other 
unavailable for some reason, that you don't also mount the other one 
writable and then try to recombined them.  Chances are the generations 
wouldn't match and it'd pick the one with the higher generation, but if 
they did for some reason match, and both checksums were valid on their 
data, but the data differed... either one could be chosen, and a scrub 
might choose either one to fix the other, as well, which could in theory 
result in a file with intermixed blocks from the two different versions!

Just ensure that if one is mounted writable, it's the only one mounted 
writable if there's a chance of recombining, and you'll be fine, as it'll 
be the only one with advancing generations.  And if by some accident both 
are mounted writable separately, the best bet is to be sure and wipe the 
one, then add it as a new device, if you're going to reintroduce it to 
the same filesystem.

Of course this gets a bit more complicated with 3+ device raid1, since 
currently, there's still only two copies of each block and two copies of 
the checksum, meaning there's at least one device without a copy of each 
block, and if the filesystem is mounted degraded writable repeatedly with 
a random device missing...

Similarly, the permutations can be calculated for the other raid types, 
and for mixed raid types like raid6 data (specified) and raid1 metadata 
(unspecified so the default used), but I won't attempt that here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

