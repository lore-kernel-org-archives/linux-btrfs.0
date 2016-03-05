Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58042 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbcCEFe6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Mar 2016 00:34:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ac4rg-000572-Gd
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 06:34:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 06:34:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 06:34:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC while creating snapshot
Date: Sat, 5 Mar 2016 05:34:39 +0000 (UTC)
Message-ID: <pan$691ee$6e394beb$af481c7f$72f2b3f6@cox.net>
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
	<CAJCQCtRP6yNOk-oDy9dOiuTL1e19SB9H9cjueEZVsCwJS4vC6w@mail.gmail.com>
	<CAJ88j0axsFA3HFc6Cr5o-dtYxLau_iDS2Mx2uVzKvF5HCe9F5Q@mail.gmail.com>
	<CAJCQCtS6cMjc0MQZresKJpkDnhLF7st2wyvwCKmsPSaT3mYmbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 04 Mar 2016 19:46:34 -0700 as excerpted:

> On Fri, Mar 4, 2016 at 4:16 PM, Martin Mlynář <nexus@smoula.net> wrote:

[Mount options line split/wrapped for followup]

>>>> rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,
>>>> enospc_debug,commit=900,subvolid=5,subvol=/
>>>
>>> Most likely unrelated but commit time of 15 minutes? Umm, OK why?
>>
>> I'm trying to reduce writes to my ssd.
> 
> This will not reduce writes. It will only delay them. And it increases
> the chance of data loss by a lot.

AFAIK, to the extent that temporary files are created and then deleted 
again, within that 900 seconds aka 15 minutes, it will indeed reduce 
writes.

This can be the case for the build-tmp location for people running build-
from-sources distros such as gentoo, for instance, as many packages will 
be built and tmp-installed to that build-tmp, before being quick-merged 
to the live system and the work deleted from build-tmp in well under 15 
minutes, at least on today's reasonably powerful quad-core-plus systems. 
Tho on gentoo, the recommendation for those with the memory available is 
to point that build-tmp at a tmpfs instead of a permanent-storage backed 
filesystem of any sort.

And in general, for those without the memory to support build-tmp in 
tmpfs, a 15-minute commit time isn't going to help either, because if 
they have enough memory to avoid flushing to free up memory for that full 
15 minutes, they obviously have enough memory to store all those files 
that would be in tmpfs if they'd have simply pointed build-tmp at that, 
instead.

Another use-case is laptops and other mobile systems with enough memory 
to cache the normal working set, is to power down the storage devices for 
as long as possible between powerups.  However, the heavy power usage 
there is normally on spinning up the disk and/or keeping it spinning, and 
SSDs obviously aren't subject to that.  While some small amount of power 
may still be saved by powering down the SSD, I expect it to be pretty 
small, and the writes are going to take the same amount of power no 
matter when they're done.

In either case, 15 minute commit times are rather extreme, because as has 
been pointed out, that's potentially 15 minutes of lost work should the 
system crash before those writes are completed, and losing 15 minutes 
worth of work is well beyond the acceptable risk level for most people.  
5 minutes, much more common, 10 minutes, not so common but you'll fine 
people doing it.  15 minutes, pretty rare, I expect.

The point being, yes, there are use-cases where 15 minute commit times 
makes sense.  But the given reason, a bare wish to reduce writes to the 
ssd, without support such as one of the above use-cases or something 
similar, really doesn't make sense, at least on its face.  I'll agree 
with other posters on that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

