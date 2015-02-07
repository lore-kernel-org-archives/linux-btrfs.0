Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbbBGGjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Feb 2015 01:39:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJz2u-0000iR-CM
	for linux-btrfs@vger.kernel.org; Sat, 07 Feb 2015 07:39:12 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Feb 2015 07:39:12 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Feb 2015 07:39:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1, SSD+non-SSD
Date: Sat, 7 Feb 2015 06:39:07 +0000 (UTC)
Message-ID: <pan$dd18d$5ac5cdf3$89ab930f$74b0f909@cox.net>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brian B posted on Fri, 06 Feb 2015 15:01:30 -0500 as excerpted:

> The only reason I'm doing the [btrfs] RAID1 is for the self-healing. I
> realize writing large amounts of data will be slower than the SSD
> alone, but is it possible to set it up to only read from the magnetic
> drive if there's an error reading from the SSD?

Chris Murphy is correct.  Btrfs raid1 doesn't have the write-mostly 
option that mdraid has.

I'll simply expand on what he mentioned with two points, #1 being the 
more important for your case.

1) The btrfs raid1 read-mode device choice algorithm is known to be sub-
optimal, and the plan is to change and optimize it in the longer term.  
Basically, it's an easy first implementation that's simple enough to be 
reasonably bug-free and to stay out of the developer's way while they 
work on on other things, while still allowing easy testing of both 
devices.

Specifically, it's a very simple even/odd parity assignment based on the 
PID making the request.  Thus, a single PID read task will consistently 
read from the same device (unless the block checksum on that device is 
bad, then it tries the other device), no matter how much there is to read 
and how backed up that device might be, or how idle the other one might 
be. Even a second read task from another PID, or a 10th, or the 100th, if 
they're all even or all odd parity PIDs, will all be assigned to read 
from the same device, even if the other one is entirely idle.

Which ends up being worst-case for a multi-threaded heavy-read focused 
task where all read threads happen to be even or odd, say if read and 
compute threads are paired and always spawned in the same order, with 
nothing else going on to throw the parity ordering off.  But that's how 
it's currently implemented.  =:^(

And it /does/ make for easily repeatable test results, while being simple 
enough to stay out of the way while development interest focuses 
elsewhere, after all pretty important factors early in a project of this 
scope. =:^)


Obviously, that's going to be bad news for you, too, unless your use-case 
is specific enough that you can tune the read PIDs to favor the parity 
that hits the SSD. =:^(


The claim is made that btrfs is stabilizing, and in fact, as a regular 
here for some time, I can vouch for that.  But I think it's reasonable to 
argue that until this sort of read-scheduling algorithm is replaced with 
something a bit more optimized, and of course that replacement well 
tested, it's definitely premature to call btrfs fully stable.  This sort 
of painfully bad in some cases mis-optimization just doesn't fit with 
stable, and regardless of how long it takes, until development quiets 
down far enough that the devs can feel comfortable focusing on something 
like this, it's extremely hard to argue that development has quieted down 
enough to fairly call it stable in the first place.

Well, my opinion anyway.

So the short of it is, at least until btrfs optimizes this a bit better, 
for SSD paired with spinning-rust raid1 optimization, as Chris Murphy 
suggested, use some sort of caching mechanism, bcache or dmcache.

Tho you'll want to compare notes with someone who has already tried it, 
as there were some issues with at least btrfs and bcache earlier.  I 
believe they're fixed now, but as explained above, btrfs itself isn't 
really entirely stable yet, so I'd definitely recommend keeping backups, 
and comparing notes with others who have tried it.  (I know there's some 
on the list, tho they may not see this.  But hopefully they'll respond to 
a new thread with bcache or dmcache in the title, if you decide to go 
that way.)


2) While this doesn't make a significant difference in the two-device 
btrfs raid1 case, it does with three or more devices in the btrfs raid1, 
and with other raid forms the difference is even stronger.  I noticed you 
wrote RAID1 in ALL CAPS form.  Btrfs' raid implementations aren't quite 
like traditional RAID, and I recall a dev (Chris Mason, actually, IIRC) 
pointing out that the choice to use small-letters raidX nomenclature was 
deliberate, in ordered to remind people that there is a difference.

Specifically for btrfs raid1, as contrasted to, for instance, md/RAID-1, 
at present btrfs raid1 is always pair-mirrored, regardless of the number 
of devices (above two, of course).  While a three-device md/RAID-1 will 
have three mirrors and a four-device md/RAID-1 will have four, simply 
adding redundant mirrors while maintaining capacity (in the simple all-
the-same-size case, anyway), a three-device btrfs raid1 will have 1.5x 
the capacity of a two-device btrfs raid1, and a four-device btrfs raid1 
will have twice the two-device capacity, while maintaining a constant 
pair-mirroring regardless of the number of devices in the btrfs raid1.

For btrfs raid10, the pair-mirroring is there, but for odd numbers of 
devices there's also a difference of uneven striping, because of the odd 
one out in the mirroring and the difference in chunk size between data 
and metadata chunks.

And of course there's the difference that data and metadata are treated 
separately in btrfs, and don't have to have the same raid levels, nor are 
they the same by default.  A filesystem agnostic raid such as mdraid or 
dmraid will by definition treat data and metadata alike as it won't be 
able to tell the difference -- if it did it wouldn't be filesystem 
agnostic.


Now that btrfs raid56 mode is basically complete with kernel 3.19, the 
next thing on the raid side of the roadmap is N-way-mirroring.  I'm 
really looking forward to that as I really like btrfs' self-repair 
capacities as well, but for me the ideal balance is three-way-mirroring, 
just in case two copies fail checksum.  Tho the fact of the matter is, 
btrfs only now is getting to the point where a third mirror has some 
reasonable chance of being useful, as until now btrfs itself was unstable 
enough that the chances of it having a bug were far higher than of both 
devices going bad for a checksummed block at the same time.  But btrfs 
really is much more stable than it was, and it's stable enough now that 
the possibility of a third mirror really should start making statistical 
sense pretty soon, if it doesn't already.

But given the time raid56 took, I'm not holding my breath.  I guess 
they'll be focused on the remaining raid56 bugs thru 3.20, and figure 
it'll be at least three kernel cycles later, so second half of the year 
at best, before we see N-way-mirroring in mainstream.  This time next 
year would actually seem more reasonable, and 2H-2016 or into 2017 
wouldn't surprise me in the least, again, given the time raid56 mode 
took.  Hopefully it'll be there before 2018...


Tho as I said, for the two-device case, if both data and metadata are 
raid1 mode, those differences can for the most part be ignored.  Thus, 
this point is mostly for others reading, and for you in the future should 
you end up working with a btrfs raid1 with more than two devices.  I 
mostly mentioned it due to seeing that all-caps RAID1.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

