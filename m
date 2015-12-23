Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47399 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbbLWENR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 23:13:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBanb-0007eK-0s
	for linux-btrfs@vger.kernel.org; Wed, 23 Dec 2015 05:13:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 05:13:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 05:13:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Loss of connection to Half of the drives
Date: Wed, 23 Dec 2015 04:13:06 +0000 (UTC)
Message-ID: <pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
	<CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
	<CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Tue, 22 Dec 2015 17:56:29 -0600 as excerpted:


>> Also understand with Brfs RAID 10 you can't lose more than 1 drive
>> reliably. It's not like a strict raid1+0 where you can lose all of the
>> "copy 1" *OR* "copy 2" mirrors.
> 
> Pardon my pea brain but this sounds like a pretty bad design flaw?

It's not a design flaw, it's EUNIMPLEMENTED.  Btrfs raid1, unlike say 
mdraid1 (and now various hardware raid vendors), implements exactly two 
copy raid1 -- each chunk is mirrored to exactly two devices.  And btrfs 
raid10, because it builds on btrfs raid1, is likewise exactly two copies.

With raid1 on two devices, where those two copies go is defined, one to 
each device.  With raid1 on more than two devices, the current chunk-
allocator will allocate one copy each to the two devices with the most 
free space left, so that if the devices are all the same size, they'll 
all be used to about the same level and will run out of space at about 
the same time.  (If they're not the same size, with one much larger than 
the others, it'll get one copy all the time, with the other copy going to 
the second largest or to each in turn once remaining empty sizes even 
out.)

Similarly with raid10, except each strip is two-way mirrored and a stripe 
created of the mirrors.

And because the raid is managed and allocated per-chunk, drop more than a 
single device, and it's very likely you _will_ be dropping both copies of 
_some_ chunks on raid1, and some strips of chunks on raid10, making them 
entirely unavailable.

In that case you _might_ be able to mount degraded,ro, but you won't be 
able to mount writable.

The other btrfs-only alternative at this point would be btrfs raid6, 
which should let you drop TWO devices before data is simply missing and 
unrecreatable from parity.  But btrfs raid6 is far newer and less mature 
than either raid1 or raid10, and running the truly latest versions is 
very strongly recommended upto v4.4 or so, which is actually soon to be 
released now, as older versions WILL quite likely have issues.  As it 
happens, kernel v4.4 is an LTS series, so the timing for btrfs raid5 and 
raid6 there is quite nice, as 4.4 should see them finally reasonably 
stable, and being LTS, should continue to be supported for quite some 
time.

(The current btrfs list recommendation in general is to stay within two 
LTS versions in ordered to avoid getting /too/ far behind, as while 
stabilizing, btrfs isn't entirely stable and mature yet, and further back 
then that simply gets unrealistic to support very well.  That's 3.18 and 
4.1 currently, with 3.18 being soon to drop as 4.4 is soon to release as 
the next LTS.  But as btrfs stabilizes further, it's somewhat likely that 
4.1 or at least 4.4, will continue to be reasonably supported beyond the 
second LTS back phase, perhaps to the third, and sometime after that, 
support will probably last more or less as long as the LTS stable branch 
continues getting updates.)

But even btrfs raid6 only lets you drop two devices before general data 
loss occurs.

The other alternative, as regularly used and recommended by one regular 
poster here, would be btrfs raid1 on top of mdraid0 or possibly mdraid10 
or whatever.  The same general principle would apply to btrfs raid5 and 
raid6 as they mature, on top of mdraidN, with the important point being 
that the btrfs level has redundancy, raid1/10/5/6, since it has real-time 
data and metadata checksumming and integrity management features that are 
lacking in mdraid.  By putting the btrfs raid with either redundancy or 
parity on top, you get the benefit of actual error recovery that would be 
lacking if it was btrfs raid0 on top.

That would let you manage loss of one entire set of the underlying mdraid 
devices, one copy of the overlying btrfs raid1/10 or one strip/parity of 
btrfs raid5, which could then be rebuilt from the other two, while 
maintaining btrfs data and metadata integrity as one copy (or stripe-
minus-one-plus-one-parity) would always exist.  With btrfs raid6, it 
would of course let you lose two of the underlying sets of devices 
composing the btrfs raid6.

In the precise scenario the OP posted, that would work well, since in the 
huge numbers of devices going offline case, it'd always be complete sets 
of devices, corresponding to one of the underlying mdraidNs, because the 
scenario is that set getting unplugged or whatever.

Of course in the more general random N devices going offline case, with 
the N devices coming from any of the underlying mdraidNs, it could still 
result in not all data being available to the btrfs raid level, but 
except for mdraid0, the chances of it happening are still relatively low, 
and with mdraid0, they're still within reason, if not /as/ low.  But that 
general scenario isn't what was posted; the posted scenario was entire 
specific sets going offline, and that such a setup could handle quite 
well indeed.


Meanwhile, I /did/ say EUNIMPLEMENTED.  N-way-mirroring has long been on 
the roadmap for implementation shortly after raid56 mode, which was 
finally nominally complete in 3.19, and is reasonably stabilized in 4.4, 
so based on the roadmap, N-way-mirroring should be one of the next major 
features to appear.  That would let you do 3-way-mirroring, 4-way-
mirroring, etc, which would then give you loss of N-1 devices before risk 
of data loss.  That has certainly been my most hotly anticipated feature 
since 3.5 or so, when I first looked at btrfs raid1 and found it only had 
2-way-mirroring, but saw N-way-mirroring roadmapped for after raid56, 
which at the time was /supposed/ to be introduced in 3.6, two and a half 
years before it was actually fully implemented in 3.19.

Of course N-way-mirroring in the raid1 context.  In the raid10 context, 
it would then obviously translate into being able to specify at least one 
of the stripe width or number of mirrors, with the other one either 
determined based on the first and the number of devices present, or also 
specifiable at the same time.

And of course N-way-mirroring in the raid10 context would be the most 
direct solution to the current discussion... were it available currently 
or were this current discussion in the future when it was available.  But 
lacking it as a current solution, the closest direct solutions allowing 
loss-of-one device on a many-device btrfs are btrfs raid1/5/10, with 
btrfs raid6 allowing a two-device drop.  But the nearest comparable 
solution isn't quite as direct, a btrfs raid1/5/10 (or btrfs raid6 for 
double set loss), on top of mdraidN.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

