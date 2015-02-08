Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41192 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbbBHDSr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Feb 2015 22:18:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKIOR-0008LP-HV
	for linux-btrfs@vger.kernel.org; Sun, 08 Feb 2015 04:18:43 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 04:18:43 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 04:18:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1, SSD+non-SSD (RAID 5/6 question)
Date: Sun, 8 Feb 2015 03:18:34 +0000 (UTC)
Message-ID: <pan$d9f76$d230fd06$3be20fdc$edd0ab4a@cox.net>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
	<pan$dd18d$5ac5cdf3$89ab930f$74b0f909@cox.net>
	<501bdb14-88dc-424e-bd2a-5a6b026e6673@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ed Tomlinson posted on Sat, 07 Feb 2015 07:42:50 -0500 as excerpted:

> On Saturday, February 7, 2015 1:39:07 AM EST, Duncan wrote:
> 
>> The btrfs raid1 read-mode device choice algorithm
> 
> Very interesting suff on the raid1 read select alg.  What changes with
> raid5/6?  Is that alg 'smarter'?

I don't know as much about the raid56 (5/6) mode.  What I /do/ know about 
it is that until the still-in-testing 3.19 kernel and similarly "now" 
userspace, raid56 mode mkfs worked, and normal runtime worked, but scrub 
and the various repair modes were code-incomplete.  That made it 
effectively an inefficient raid0 in practice -- the parity strips were 
calculated and written, but the tools weren't there to properly recover 
from them should it be necessary, so from an admin perspective it was 
like a raid0, if a device drops out, say bye-bye to the entire 
filesystem.  In practice there were certain limited recovery steps that 
could be taken in some circumstances, but as they couldn't be counted on, 
from an admin perspective, the best policy really was to consider it a 
slow raid0, as that's the risk you were taking, running it.

The difference was that if you set it up for raid5/6, once the tools were 
complete and ready, you'd effectively get a "free" redundancy upgrade, 
since it was actually running that way all along, it just couldn't be 
recovered as such because the recovery tools weren't done yet.

With kernel 3.19, in theory all the btrfs raid56 mode kernel pieces are 
there now, altho in practice there's still bugs being worked out, so I'd 
not (bleeding-edge) trust it until 3.20 at least, and I'd hesitate to 
consider it as (relatively) stable as single/dup/raid0/1/10 modes for 
another couple kernels after that, simply because they've been usable for 
long enough to have had quite a few more bugs found and worked out at 
this point.

I'm not exactly sure what the status is on the userspace side, but I 
/think/ it's there in the current v3.18.x userspace release, and should 
be usable by the time the kernelspace is usable, kernel 3.20 with 
userspace 3.19.

But with ~9 week release cycles and with 3.19 very close to out now, if 
we take that 3.20 bleeding-edge usable in say 10 weeks from now, and call 
raid56 mode reasonably stable two kernel cycles or 18 weeks later, that 
puts it 28 weeks out, say 6.5 months, for reasonably stable.  Which would 
be late August.  Of course if you're willing to take a bit more risk, 
it's more like six or seven weeks, say 3.20-rc4 or so, about the end of 
March.  I'd really not recommend raid56 mode until then, unless you *ARE* 
treating it exactly as you would a raid0, and are willing to call the 
entire filesystem a complete loss if a device drops or there's any other 
serious problem with it.


As for algorithm, AFAIK, operationally btrfs raid56 mode stripes data 
similar to raid0, except that one or two devices of each stripe are of 
course reserved for parity.  So a three-way raid5 or a four-way raid6 
will have a two-way-data-stripe, while a four-way raid5 or a five-way 
raid6 will have a three-way-data-stripe.

Since data chunks are nominally 1 GiB and the allocator will allocate a 
chunk on each device, then full available width sub-chunk stripe with 
raid0/5/6, in theory at least, performance should be very similar to a 
conventional raid0/5/6, at least for single thread.

Which means writes are going to be the big bottleneck, just as they are 
with conventional raid5/6, since they end up being read-modify-write for 
any of the strips of the stripe not yet read into cache yet.

FWIW I actually ran md/RAID-6 here for awhile (general desktop/
workstation use-case, tho on gentoo, so call it developer's workstation 
due to the building from source), and was rather disappointed.  I found a 
well-optimized raid1 implementation (as md/RAID-1 is) to be much more 
efficient, even with four-way-mirroring!

Tho due to btrfs raid1 mode not yet being optimized, btrfs raid56 mode 
even with a reasonable write load, might well actually be competitive or 
even faster, at this point.  I haven't even looked to see if there's any 
benchmarks on that, yet.  (Despite raid56 mode repair tools not being 
complete, runtime worked, so it could have been benchmarked against raid1 
mode already.  I just haven't checked to see if there's actually a report 
of such on the wiki or wherever.)


But back to the SSD+spinning-rust combo, I don't expect btrfs raid56 mode 
to do particularly well on that, either, tho at least you wouldn't have 
the potential worst-case of all reads getting assigned to the spinning 
rust, as could well happen with btrfs' unoptimized raid1 mode, at this 
point.  Intuitively, I'd predict that read thruput would be similar to 
that of reading just the spinning-rust share off the spinning-rust 
device.  IOW, when reading from both, the SSD would be done so fast it 
wouldn't even show up in the results, while the speed of the spinning 
rust would be what you'd be getting for data read off of it, so where 
half the data is on spinning rust and half on ssd, you'd effectively get 
twice the speed you'd get if it were all on spinning rust, because half 
would show up at spinning rust speed, while the other half would already 
be there by the time the spinning rust side finished.  But that's simply 
intuition, and simple intuition could be quite wrong.  You could of 
course test it.

The ideal, if you don't want to deal with a cache layer, as I didn't, 
would be to simply declare the money to put it all on SSD worth it, and 
just do that.  Two SSDs in btrfs raid1 mode.  That's actually what I'm 
running here, tho I don't like all my data eggs in the same filesystem 
basket, so I actually have both SSDs partitioned up similarly, and am 
running multiple smaller independent btrfs, all (but for /boot) being 
btrfs raid1, with each of the two devices for each btrfs raid1 being a 
partition on one of the SSDs.

That actually works quite well and I've been very happy with it. =:^)  
Particularly when doing a full balance/scrub/check on a filesystem takes 
under 10 minutes, with some of them a minute or less, both because of the 
speed of the SSDs, and because the filesystems are all under 50 GiB 
each.  It's **MUCH** easier to work with such filesystems when a scrub or 
balance doesn't take the **DAYS** people often report for their multi-
terabyte spinning-rust based filesystems!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

