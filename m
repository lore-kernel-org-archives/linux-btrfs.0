Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45963 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbbBEDnh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 22:43:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJDLr-0003nh-Cl
	for linux-btrfs@vger.kernel.org; Thu, 05 Feb 2015 04:43:35 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 04:43:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 04:43:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What does scrub tell me?
Date: Thu, 5 Feb 2015 03:43:29 +0000 (UTC)
Message-ID: <pan$e108e$e9933d01$2069a082$32e36a2e@cox.net>
References: <CAPs0Big=8SsBRFjrDPcradYW100GUnWEzC=ycvvDQScTSYKt5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sandy McArthur Jr posted on Wed, 04 Feb 2015 12:31:07 -0500 as excerpted:

> Does a btrfs scrub verify the integrity of the whole filesystem or just
> the data in that filesystem?

Btrfs scrub verifies both data and metadata /checksum/ integrity.  From 
the below it looks like that's very likely what you're most worried about 
anyway and you likely already get what I explain in the next paragraph, 
but for the benefit of others that read this... =:^)  

A lot of people misunderstand what scrub does and try to use it as if it 
were btrfs check, verifying metadata structure and function integrity as 
well, and then wonder why their filesystem passes scrub and yet won't 
balance or has other filesystem errors.  Thus the emphasis on 
/checksum/.  (Meta)data can be valid as saved and still be corrupt, 
because it was corrupted before the save due to a bug.  The checksum, and 
thus scrub, verifies that you're getting exactly what was saved, but it, 
by itself, doesn't say anything about whether what was saved was actually 
valid in the first place, and a lot of folks miss the significance of 
that difference until it is explained to them.

> I recently removed some unreliable drives from my multi-volume RAID1
> btrfs filesystem and ran a scrub that completed with two corrected
> errors (see below).  I've struggled with this filesystem due to poor
> choices in hardware on my part and had to recover it several times. As
> of now I've eliminated all older drives or drives labeled as "desktop"
> drives. (Knowing what I know now, I'm impressed with how well btrfs has
> preserved my data despite myself.)
> 
> I'm at a point where I can grow my existing btrfs filesystem as RAID1 or
> I can afford to migrate data to a new btrfs single filesystem and then
> add drives back in to get back to RAID1 mirroring again. Is there value
> to starting a fresh btrfs filesystem given my history?
> 
> 
> # btrfs scrub status /mcmedia/ ; echo ; btrfs --version 
> scrub status for 94b3345e-2589-423c-a228-d569bf94ab58
> scrub resumed at Mon Feb  2 22:03:14 2015 and finished after 204126
> seconds
> total bytes scrubbed: 23.38TiB with 2 errors
> error details: csum=2
> corrected errors: 2, uncorrectable errors: 0, unverified errors: 0
> 
> Btrfs v3.18.2

If you like you can run a btrfs check (--readonly, without --repair or 
similar write option) and/or btrfs balance, and if they complete without 
error, it's reasonably safe to assume your filesystem is "clean".

That said, personally, I prefer to start "clean" every few kernel (and 
thus btrfs-tools userspace as well) cycles in any case, for a couple 
reasons.

Here, I do it as part of my regular backup cycle, where my first-level 
backup is a set of btrfs of the same size, and I do a fresh mkfs.btrfs to 
purge the old backup, mount the new filesystem, copy everything over from 
the working filesystem, reboot to the backup (for root) or unmount the 
working btrfs and mount the backup to test the backup, then when I'm 
satisfied with the now tested backup, reverse the cycle, doing a 
mkfs.btrfs of my normal working filesystem and copying everything back 
from the backup.  (FWIW, my second level backup is non-btrfs, reiserfs in 
my case since I've used it for years and it has proved itself very 
resilient since data=ordered by default, thru the various hardware issues 
I've had.  I do test pre-release kernels and that way, if there's a 
serious btrfs bug that eats both my working copy and the backup when I 
try to boot to it for recovery, I still have the reiserfs backup, which 
will hopefully be unaffected.)

The reasons:

1) Btrfs is still under rapid, not entirely stable yet, development.  By 
starting clean I eliminate the filesystem back-history and with it the 
possibility of some previously unknown side effect of some long fixed bug 
coming back to haunt me.  This probably isn't as likely to eliminate 
issues now as it was back before say 3.11 (when they started dropping the 
most dire warnings, IIRC), but I'm used to doing it now, and call it 
sysadmin superstition if you like, but I still rest better when I can 
say, OK, I know for sure that filesystem couldn't have been affected by 
anything previous to 3.x kernel and userspace, as that's when I created 
it.

2) As long as you don't have to worry about compatibility with old 
kernels, a fresh mkfs.btrfs allows you to take advantage of (relatively) 
newer filesystem options like skinny-metadata, no-holes, and 16 KiB 
nodesizes.  These make the filesystem more efficient.  While some such 
features can be enabled at runtime, not all of them can, and the old data/
metadata will still be written with the old options until a balance or 
whatever to rewrite them.

Of course if you need to maintain compatibility with old enough kernels 
you'll want to turn off these features anyway, and this reason disappears.

Meanwhile, if the filesystem is still reasonably new, time-wise, even if 
it has been thru some tough hardware issues, and you originally created 
it with the options you wanted already, this reason goes away in that 
case as well, as the available options have remained steady for awhile 
now, tho the defaults have recently changed for a couple of them.

Bottomline:

While you're likely fine in terms of filesystem stability, particularly 
if you run a btrfs check and a balance and they both work fine, I'd still 
personally recommend a fresh mkfs for the reasons above, given the 
current opportunity and the fact that running the check and balance are 
likely to take a good chunk of the time that starting with a fresh 
mkfs.btrfs, copying things over, and balancing back to the expanded 
raid1, would take, and you won't know if the existing setup is reliable 
until you do that check and balance anyway, so you may well end up with a 
clean filesystem in any case.

IOW, if it were my system, I'd go the clean mkfs.btrfs route. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

