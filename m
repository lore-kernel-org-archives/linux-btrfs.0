Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54192 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbbLHNiy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 08:38:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6ITl-0000gQ-90
	for linux-btrfs@vger.kernel.org; Tue, 08 Dec 2015 14:38:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 14:38:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 14:38:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub on btrfs single device only to detect errors, not correct
 them?
Date: Tue, 8 Dec 2015 13:38:46 +0000 (UTC)
Message-ID: <pan$55430$b692802c$678dae98$d07f0732@cox.net>
References: <CA+pSGYcxAHUppSgODwk16i+5rLdojzjYxp8=SWWkLXmXOAo9kg@mail.gmail.com>
	<CAJCQCtQX5Ov6YKZ=SdxaGSPaGa0sEFF6gz89WsDm9qegmykGkA@mail.gmail.com>
	<pan$519f9$af10e2cb$f1ea2d14$435d0b5a@cox.net>
	<CA+pSGYcFAxsk=8EWPz4wM0Gjk4Nyra0HEcTjbJtRQU8-zfSVjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jon Panozzo posted on Mon, 07 Dec 2015 08:43:14 -0600 as excerpted:

[On single-device dup data]

> Thanks for the additional feedback.  Two follow-up questions to this is:
> 
> Can the --mixed option only be applied when first creating the fs, or
> can you simply add this to the balance command to take an existing
> filesystem and add this to it?

Mixed-bg mode has to be done at btrfs creation.

It changes the way btrfs handles chunks, and doing that _live_, with a 
non-zero time during which both modes are active, would be... complex and 
an invitation to all sorts of race bugs, to put it mildly.

> So it sounds like there are really three ways to enable scrub to repair
> errors on a btrfs single device (please confirm):

Yes.

> 1) mkfs.btrfs with the --mixed option

This would be my current preferred to filesystem sizes of a quarter to 
perhaps a half terabyte on spinning rust, and some people are known to 
use mixed for exactly this reason, tho it's not particularly well tested 
at the terabyte scale filesystem level, where as a result you might 
uncover some unusual bugs.

> 2) create two partitions on a single phys device,
> then present them as logical devices (maybe a loopback or something)
> and create a btrfs raid1 for both data/metadata

No special loopback, etc, required.  Btrfs deploys just fine on pretty 
much any block device as presented by the kernel, including both 
partitions and LVM volumes, the two ways single physical devices are 
likely to be presented as multiple logical devices.

In fact I use btrfs on partitions here, tho in my case it's two devices 
partitioned up identically, with raid1 across the parallel partitions on 
each device, instead of using multiple partitions on the same physical 
device, which is what we're talking about here.

This option will be rather inefficient on spinning rust as the write head 
will have to write one copy to the one partition, then reposition itself 
to write the second copy to the other partition, and that repositioning 
is non-zero time on spinning rust, but there's no such repositioning 
latency on SSDs, where it might actually be faster than mixed-mode, tho 
I'm unaware of any benchmarking to find out.

Despite the inefficiency, both partitions and btrfs raid1 are separately 
well tested and their combined use on a single device should introduce no 
race conditions that wouldn't have been found by previous separate usage, 
so this would be my current preferred at filesystem sizes over a half 
terabyte on spinning rust, or on SSDs with their zero seek times.

But writing /will/ be slow on spinning rust, particularly with partition 
sizes of a half-TiB or larger each, as that write-mode seek-time will be 
/nasty/.

That said, again, there are people known to be using this mode, and it's 
a viable choice in deployments such as laptops where physical multi-
device isn't an option, but the additional reliability of pair-copy data 
is highly desirable.

> 3) wait for the patch in process to allow for btrfs single devices to
> support dup mode for data

This should be the preferred mode in the future, tho as with any new 
btrfs feature, it'll probably take a couple kernel versions after initial 
introduction for the most critical bugs in the new feature to be found 
and duly exterminated, so I'd consider anyone using it the first kernel 
cycle or two after introduction to be volunteering as guinea pigs.  That 
said, the individual components of this feature have been in btrfs for 
some time and are well tested by now, so I'd expect the introduction of 
this feature to be rather smoother than many.  For the much more 
disruptive raid56 mode, I suggested a guinea-pig time of a year, five 
kernel cycles, for instance, and that turned out to be about right.

(Interestingly enough, that put raid56 mode feature stability at the soon 
to be released kernel 4.4, which is scheduled to be a long-term-support 
release, so the raid56 mode stability timing worked out rather well, tho 
I had no idea 4.4 would be an LTS when I originally predicted the year's 
settle-time.)

> Is that about right?

=:^)


One further caveat regarding SSDs.

On SSDs, many commonly deployed FTLs do dedup.  Sandforce firmware, where 
dedup is sold as a feature, is known for this.  If the firmware is doing 
dedup, then duplicated data /or/ metadata at the filesystem level is 
simply being deduped at the physical device firmware level, so you end up 
with only one physical copy in any case, and filesystem efforts to 
provide redundancy only end up costing CPU cycles at both the filesystem 
and device-firmware levels, all for naught.  This is a big reason why 
mkfs.btrfs on a single device defaults to single metadata if it detects 
an SSD, despite the normally preferred dup metadata default.

So if you're deploying on SSDs using sandforce firmware or otherwise 
known to do dedup at the FTL, don't bother with any of the above as the 
firmware will be simply defeating your efforts at deliberate redundancy.

(FWIW, I happened to get lucky with my own SSDs as I knew way less about 
them at the time I purchased mine, and happened to get SSDs designed for 
server deployment that sell the /lack/ of dedup and compression as a 
feature, because it makes latency and capacity much more stable and 
predictable.  So I can use dup mode in whatever form without fear of the 
FTL second-guessing me, tho I actually use btrfs raid1 on two actual 
physical device SSDs, on most of the partitions.  But /boot is an 
exception where I do actually use dup mode as opposed to raid1, on both 
the working /boot on one device, and the backup /boot on the other 
device.  This is because while with grub2 I could actually use grub 
rescue mode to load /boot from either device, rescue mode isn't the 
easiest thing to use, and it's still easier to simply let grub point at 
just one /boot, and use the BIOS to choose which device and thus grub and 
associated /boot I'm going to actually boot from, the same way I did back 
in the grub1 era, before grub had a rescue mode.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

