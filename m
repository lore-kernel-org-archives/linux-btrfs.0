Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59066 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab3KOJZo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 04:25:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhFen-0001yn-DW
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 10:25:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 10:25:41 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 10:25:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "No space left on device"
Date: Fri, 15 Nov 2013 09:25:20 +0000 (UTC)
Message-ID: <pan$909c$9bfd218e$358995ba$af8547c5@cox.net>
References: <ecb3dcc9-c636-4fa7-b41f-e9021411a09a@email.android.com>
	<20131114210056.GN4315@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 14 Nov 2013 21:00:56 +0000 as excerpted:

>> Is there a formula to calculate how much space btrfs _might_ need?
> 
> Not really. I'd expect to need something in the range 250-1500 GiB of
> headroom, depending on the size of the filesystem (and on the size of
> the metadata).

As a somewhat more concrete answer...

While recently doing a bit of research on something else, I came across 
comments that on a large enough filesystem, data chunks default to 1 GiB, 
while metadata chunks default to 256 MiB.

And we know that data mode defaults to SINGLE, while metadata mode 
defaults to DUP.

So on a default single-device btrfs of several gigs plus, assuming the 
files being manipulated are under 1 GiB size, keeping an unallocated 
space reserve of 1.5 GiB should be reasonable.  That's enough unallocated 
space to allocate one more 1 GiB data chunk, plus one more 256 MiB 
metadata chunk, doubled to a half GiB due to DUP mode.  Obviously in the 
single-mode-metadata case, the metadata requirement would be only a 
single copy, so 256 MiB for it, 1.25 GiB total unallocated, minimum.

btrfs filesystem show is the command used to see what your allocated 
space for a filesystem looks like, per device.  However, it doesn't note 
UNALLOCATED space, only size and used (aka allocated), so an admin must 
do the math to figure unallocated.

If the files being manipulated are over a gig in size, round up to the 
nearest whole GiB for the data and add another half GiB to cover the 
quarter-gig DUP metadata case.

If the filesystem is under a gig in size, btrfs defaults to mixed
data+metadata, with chunks of 256 MiB if there's space but apparently 
rather more flexibility in ordered to better utilize all available 
space.  At such "small" sizes[1], full allocation with no more to 
allocate being common, but one does hope people using such sized 
filesystems have a good idea what will be going on them, and they won't /
need/ to allocate further chunks after the initial filesystem 
population.  And quite in contrast to the multi-TB filesystems, 
rebalancing such a filesystem in ordered to recover lost space should be 
relatively fast even on spinning rust.

For filesystems of 1 GiB up to say 10 GiB, it's a more open question, 
altho at that size, there's still a rather good chance that the sysadmin 
has a reasonably good idea what's going on the filesystem and has planned 
accordingly, with some "reasonable" level of over-allocation for future-
proofing and plan fuzziness, and rebalances should still occur in 
reasonable time as well, so it shouldn't be a /huge/ problem unless the 
admin simply isn't tracking the situation.

The multi-device situation is another dimension vector.  Apparently, 
except for single mode, btrfs at this point only ever allocates in pairs 
(plus raid5/6 checksum chunks if applicable, and pairs of pairs in raid10 
mode), regardless of the number of devices available, which does simplify 
calculations to some degree.

Btrfs' multi-device default (for >1 GiB per device sizes, anyway) is 
single data, raid1 metadata.  So to reserve space for one chunk of either 
type, we'd need at least 1 GiB unallocated on ONE device to allow at 
least one single-mode data chunk allocation, PLUS at least 256 MiB 
unallocated on each of TWO devices to cover at least one raid1-mode 
metadata chunk allocation.  Thus, with two devices, we'd require at least 
1.25 GiB free/unallocated on one device (1 GiB data chunk plus one copy 
of the 256 MiB metadata chunk), 256 MiB on the other (the second copy of 
the metadata).  For a three+ device filesystem, that would work, OR 256 
MiB on each of two (for the raid1 metadata), 1 GiB on a third (for the 
data).

For raid1 data the 1 GiB data chunks must have two copies, each on its 
own device, and the above multi-device default scenario would modify 
accordingly: 2-device-case: 1.25 GiB minimum unallocated on each device 
(one copy each for a data and a metadata chunk).  3-device-case:  That OR 
1.25/1.0/.25 GiB.  4-device-plus-case: Either of those or 1.0/1.0/.25/.25 
GiB.

For single metadata plus default single data, we're back to the 1.25 GiB 
total case, in two separate chunks of 1 GiB and 256 MiB, either on 
separate devices or the same device.

I haven't personally played with the raid0 case as it doesn't fit my use-
case, but the wiki documentation suggests that it still allocates chunks 
only in pairs, striping the data/metadata across the pair.  So we're 
looking at a minimum 1 GiB on each of two separate devices for a raid0 
data chunk allocation (which would then allow two gigs of data), a 
minimum of 256 MiB on each of two separate devices for a raid0 metadata 
chunk allocation (which would hold a half-gig of metadata).  Permutations 
are, as they say "left as an exercise for the reader." =:^)

Apparently raid10 mode is pairs of pairs, so allocates in sets of four.  
Metadata: 256 MiB on each of four separate devices, 512 MiB metadata 
capacity.  Data: 1 GiB on each of four separate devices, holds 2 GiB 
worth of data.  Again, permutations "left as an exercise for the reader."

Finally, there's the mixed data/metadata chunk mode that's the default on 
<1 GiB filesystems.  Default chunk sizes there are 256 MiB, with the same 
pair-allocation rules for multi-device filesystems as above.  But as 
discussed under the single device case, these filesystems are often 
capacity-planned and fully allocated from the beginning, with no further 
chunk allocation necessary once the filesystem is populated.

That leaves raid5/6.  With the caveat that these raid modes aren't yet 
ready for normal use (even more so than the still experimental btrfs as a 
whole, where good backups are STRONGLY RECOMMENDED, with raid5/6 mode, 
REALLY expect your data to be eaten for breakfast, so do NOT use it in 
present form for anything but temporary testing!)...

raid5 should work like raid0 above, but requiring one more device chunk 
reserved for the raid5 checksumming, thus reserving in threes with no 
additional capacity over raid0.  raid6 is the same but with yet another 
reserved, thus reserving in fours.  Again, permutations "left as an 
exercise for the reader."

Presumably raid50/60 will be possible with little change in the code once 
raid5/6 stabilize, since it's a logical combination with raid0, with the 
required parallel chunk reservation 6 and 8 devices wide respectively, 
but AFAIK, that's not even supported at all yet, and even if it is, it's 
hardly worth trying since the raid5/6 component remains so highly 
unstable at this point.

And of course there's N-way mirroring on the roadmap as well, but 
implementation remains some way out, beyond raid5/6 normalization.  When 
it comes, its parallel chunk reservation characteristics can be predicted 
based on the raid1 discussion above, extended from it by multiplying by 
the N in the N-way mirroring, instead of by a hard-coded two, as done in 
the current raid1 case.  (This is actually a case I'm strongly interested 
in, 3-way-mirroring, perhaps even in the raid10 variant thus requiring 
six devices minimum, but given btrfs history to date and current progress 
on raid5/6, I don't expect to see it in anything like normalized form 
until well into next year, perhaps a year from now, at the earliest.)

---
[1] Re < 1 GiB being "small", I still can't help but think of my first 
computer when I mention that, a 486-class machine with a 130 MB (128 MiB 
or some such, half the size of my /boot and 1/128th the size of my main 
memory, today!) hard drive, and that was early 90s, so while I've a bit 
of computer experience I'm still a relative newcomer compared to many in 
the *ix community.  It was several disk upgrade generations later when I 
got my first gig-sized drive, and it sure didn't seem "small" at the 
time!  My how times do change!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

