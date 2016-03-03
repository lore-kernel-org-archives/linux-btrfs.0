Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53346 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbcCCE5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Mar 2016 23:57:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abLKN-0002bi-BD
	for linux-btrfs@vger.kernel.org; Thu, 03 Mar 2016 05:57:31 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 05:57:31 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 05:57:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Thu, 3 Mar 2016 04:57:23 +0000 (UTC)
Message-ID: <pan$1a785$dbfe4789$bdc8f4d5$778788dd@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dāvis Mosāns posted on Thu, 03 Mar 2016 02:28:36 +0200 as excerpted:

> 2016-02-27 23:14 GMT+02:00 Marc Haber <mh+linux-btrfs@zugschlus.de>:
>> Hi,
>>
>> I have again the issue of no space left on device while rebalancing
>> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
>>
>>
> I've same issue, 4.4.3 kernel on Arch Linux
> 
> $ sudo btrfs fi show /mnt/fs/
> Label: 'fs'  uuid: a3c66d25-2c25-40e5-a827-5f7e5208e235
>         Total devices 1 FS bytes used 396.94GiB
>         devid    1 size 435.76GiB used 435.76GiB path /dev/sdi2
> 

> $ sudo btrfs fi usage /mnt/fs/
> Overall:
>     Device size:                 435.76GiB
>     Device allocated:            435.76GiB
>     Device unallocated:            1.00MiB

[Snipped the longer story, but the summary is that at first a full 
balance would fail, but after jumping thru some balance filtering hoops, 
you cleared enough space to unallocated that you could then do a full 
balance and it was working, tho it was still running.]


You're issue isn't the same, because all your space was allocated, 
leaving only 1 MiB unallocated, which isn't normally enough to allocate a 
new chunk to rewrite the data or metadata from the old chunks into.

That's a known issue, with known workarounds as dealt with in the FAQ. 

Ideally, you catch it while you have at least a gig or two of unallocated 
space (apparently in some instances with huge filesystems, you may need 
up to 10 GiB free, as data chunk allocations can be larger than the 
nominal 1 GiB on really large filesystems, but yours obviously isn't 
/that/ large) thereby giving you enough room to allocate at least one new 
chunk in ordered to rewrite data from old chunks while consolidating.

You only had 1 MiB of unallocated space in that first report, so you're a 
bit lucky that you didn't have to temporarily add a second device of at 
least several gigs in size, at least long enough to rewrite a few chunks 
and clear some additional space.  (FWIW, a few GiB USB thumb drive can be 
used, or even a loopback file on tmpfs, if you have enough memory for it 
and your system and power is stable enough that you're willing to take 
the gamble of not having an unscheduled reboot in the middle and thus 
losing your loopback, before you're able to btrfs device delete it again 
after you've completed at least enough of the balance to have enough room 
to do so.)  That's what some folks end up having to do if all space is 
allocated and they don't even have enough left to allocate even one more 
new chunk in ordered to do the balance and consolidate the partially-free 
chunks, thereby freeing the space they were using.

The issue of this thread is quite different, as they've triggered a bug 
that the devs have been trying to track down for quite awhile, where even 
with /lots/ of unallocated free space, btrfs will due to the bug refuse 
to allocate more, resulting in ENOSPC errors even when there's tens or 
hundreds of GiB of unallocated space, where you had only that 1 MiB.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

