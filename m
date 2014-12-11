Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42347 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaLKHd5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 02:33:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyyG4-0006NN-H1
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 08:33:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 08:33:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 08:33:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Date: Thu, 11 Dec 2014 07:33:45 +0000 (UTC)
Message-ID: <pan$7afe7$a4162ba6$5e4598b4$bfddf82@cox.net>
References: <5488C6CF.1080608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 10 Dec 2014 14:18:55 -0800 as excerpted:

> So I started looking at the mkfs.btrfs manual page with an eye towards
> documenting some of the tidbits like metadata automatically switching
> from dup to raid1 when more than one device is used.
> 
> In experimenting I ended up with some questions...
> 
> (1) why is the dup profile for data restricted to only one device and
> only if it's mixed mode?

> (2) why is metadata dup profile restricted to only one device on
> creation when it will run that way just fine after a device add?

1 and 2 together since they both deal with dup mode...

Dup mode was apparently originally considered purely an extra safeguard 
for metadata in the single-device case, where it was made the default 
(except for SSDs, which default to single mode metadata on a single-
device filesystem, because the FTL voids any guarantees on location 
anyway, and because firmware such as sandforce compresses and dedups 
anyway, in which case the hardware/firmware is subverting btrfs' efforts 
to do dup anyway).

In the single-device case, two copies of data was considered simply not 
worth the cost, due both to doubling the size (especially on SSD where 
size is money!) and to the speed penalties on spinning rust due to seeks 
between one 1-GiB data-chunk and its dup.

With multi-device, raid1 metadata, forcing one copy to each of two 
different devices, was considered enough superior to make that the 
default, since that provided device-loss resiliency for the all-important 
metadata, thus enabling recovery of at least /some/ files even with a 
device missing (single-mode data where the file's extents all happened to 
be on available devices, plus of course raid1, etc, data).  Further, dup-
mode metadata was considered a mistake it was better not to even have 
available as an option, since loss of a single device would likely kill 
the filesystem, which made dup mode little better than single mode, 
without the doubled-size-cost.  Further, on spinning rust there'd again 
be the seek penalty, to little benefit since dup mode provides no 
guarantees in case of device loss.

So multi-device defaults to raid1 metadata for safety, but single mode 
metadata remains an option (along with raid0) if you really /don't/ care 
about losing everything due to loss of a single device.  Single-device 
simply makes dup-mode available (and the default) for metadata, as a poor-
man's substitute for the safety of raid1, but single-device-metadata is 
the only case where that poor-man's-raid1-substitute is worth the 
(considered extreme) cost, with usage of that option not even available 
on multi-device as it'd be a near-certain mistake, certainly at the mkfs 
level.  And dup mode isn't ordinarily available for data even on single-
device, because it's considered not worth the cost.

As for dup-mode working after device-add, that's simply a necessary bit 
in ordered for device add to work from a default-dup-mode single-device 
at all.  And it's only the existing metadata chunks on the original 
device that will be dup-mode.  Once a second device is added, additional 
metadata chunks will be written in raid1 mode, forcing the two chunk 
copies to different devices since there's multiple devices available to 
allow that.  The clear intent and recommendation is to do a rebalance 
ASAP after a device add, to spread usage to the new device as 
appropriate.  And of course that rebalance will use the new raid1 
metadata defaults, unless told otherwise of course, and I don't believe 
dup mode is available to tell it otherwise there, either.


What all that original reasoning fails to account for, however, is the 
btrfs data/metadata checksumming and integrity features and the very high 
(which the original btrfs mode designers obviously considered extreme) 
value some users (including me) place on them.  While a multi-device dup-
mode-metadata choice at mkfs is arguably still a mistake, the cost of 
raid1 metadata without the benefit, near the risk of single metadata but 
at double the size, dup-mode data combined with btrfs checksumming and 
data integrity features on a single device has strong data integrity 
benefits that some would definitely consider worth it, even at the 
additional cost in speed on spinning rust due to seeking, and in size on 
expensive SSDs.

Meanwhile, mixed-bg-mode was an after-thought, added much later (after my 
own btrfs journey began) in ordered to make working with small 
filesystems reasonable.  Before mixed-bg-mode, people attempting to use 
btrfs on sub-GiB devices often found they couldn't use all available 
space (often 25-50% wasted!) as the separate data/metadata chunk 
allocation was simply too large grained to properly deal with the small 
sizes involved.

And small filesystems really _was_ mixed-mode's _entire_ purpose.  That 
it could additionally be used to allow dup-data, using the ability to 
specify mixed-bg-mode even on > 1 GiB filesystems where it wasn't the 
default to get dup-data, was *ENTIRELY* an accident, not even considered 
until a user figured it out, as confirmed by I believe it was Chris Mason 
when directly asked at some point.

But now that mixed-mode is there and can be used to enable dup-mode data 
too, for people that want it, and now that we know for sure such people 
exist because we see mixed-bg mode being offered as a way to get exactly 
that, dup-mode-data, there's little reason to remove the accidental 
feature. =:^)

Meanwhile, now that demand is known to exist for dup-mode-data, I think 
it probable that at some point code for that without having to force 
mixed-bg-mode to get it will be made available and tested, much as other 
features have been.  But there's way more features left to implement than 
time to implement them, at least with the current btrfs developer pool.  
And given that mixed-bg-mode is available to deliver dup-mode-data for 
those /really/ intent on having it, the priority of coding and testing 
stand-alone-dup-mode-data is going to be relatively low, so I'd suggest 
not expecting it any time soon -- maybe five years out, I don't see it 
much sooner unless a dev (or dev sponsor) really gets that itch and 
decides to priority scratch it.


> (3) why can I make a raid5 out of two devices?

> (4) Same question for raid6 but with three drives instead of the
> mandated four.
> 
> (5) If I can make a RAID5 or RAID6 device with one missing element, why
> can't I make a RAID1 out of one drive, e.g. with one missing element?

AFAIK, the ability to mkfs raid56 modes with a missing device is a bug.  
I'm not sure if it was known or not, tho I know there has been some 
change in minimum number of devices over time and it might have gotten 
caught in that, but I'd /guess/ that since raid56 isn't yet fully 
supported, if the bug /was/ known, it had relatively low priority on the 
fix-list compared to various other bugs with currently supported features.

If it is a bug as I believe it to be, that nullifies most of the 
secondary questions you had...
 
> (6) If I make a RAID1 out of three devices are there three copies of
> every extent or are there always two copies that are semi-randomly
> spread across three devices? (ibid for more than three).

Currently btrfs raid1 is defined very specifically as exactly two copies/
mirrors, regardless of whether there are two or two hundred devices in 
the filesystem.  More devices gives you more room; number of copies 
remains two.  This is covered in the wiki.

The feature known as N-way-mirroring is however on the roadmap -- for 
just after raid56, since the planned implementation depends on some of 
the same code.

This is actually a bit of a personal sore spot for me, since it has long 
been my most-wished-for feature.  When I first investigated btrfs now 
years ago, I was running quad-way-mdraid-1, and was very disappointed to 
see that btrfs only offered paired-raid1, since I wanted (and still want) 
very much to be able to fall back more than once to additional copies, 
should the checksum fail on the first N-1 copies.

And back then (kernel 3.5 era IIRC) it was already roadmapped immediately 
after raid56 modes, which was to be introduced in another kernel cycle or 
two, so I figured perhaps 3-4 cycles, maybe a year (~5 cycles) for N-way-
mirroring.  But it seems as far out now as then, if not further since we 
know how long raid56 is taking to complete, and two kernel cycles after 
that for N-way-mirroring seems wildly optimistic, now.  Maybe a year 
after... if it's not too complicated.

But it's definitely on the roadmap, next thing to implement in fact, but 
it's still right after raid56, and raid56 has of course been coming right 
up since kernel 3.6 or whatever, at least.

But I'm not a dev so I can't help in that regard, tho I do use btrfs in 
pair-way raid1 mode now, and try to help on the list where my knowledge 
as list regular and sysadmin using btrfs allow it.  Someday that feature 
will be available to play with... but that doesn't mean I can't enjoy 
btrfs for what it has right now, nor does it mean I can't help others 
with btrfs while I wait...



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

