Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36808 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbbKUHwg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Nov 2015 02:52:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a02yG-0005P7-QB
	for linux-btrfs@vger.kernel.org; Sat, 21 Nov 2015 08:52:32 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2015 08:52:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2015 08:52:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Enhancement] ... and please rename "raid1" to something better
Date: Sat, 21 Nov 2015 07:52:24 +0000 (UTC)
Message-ID: <pan$ba95d$ea17d75d$74c0a6c9$f6e5f034@cox.net>
References: <pan$130bd$2fb4e52a$aef597d4$e021ef73@cox.net>
	<1448047774.6878.9.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Fri, 20 Nov 2015 20:29:34 +0100 as
excerpted:

> On Fri, 2015-11-20 at 11:05 +0000, Duncan wrote:
>> It's missing raid1. =:^(
> speaking of which...
> 
> Wouldn't the developers consider to rename raid1 to something more
> correct? E.g. replicas2 or dup or whatever.
> 
> RAID1 has ever had the meaning of mirrored devices and the closest to
> this in btrfs would be N replicas with N devices, and not two as it is
> now.
> Also I wouldn't know of any other system that doesn't use "RAID1" in the
> traditional meaning (MD, basically every HW RAID I came across).
> 
> And I'm not against the mode of having 2 duplicates itself... just
> against the naming, which I think easily confuses users and they may
> awake with a bad surprise.

The meaning of "raid1" when there's more than two devices has actually 
been debated in several threads here over the years.  Turns out that the 
original papers that defined the raid levels only discussed the pair-
mirror case, and what happens when there's more than two devices was left 
open to interpretation.  Someone actually posted a link to copies of 
those original papers on the net, in at least one of those threads, so 
you're free to go back and find it and look it up for yourself, if 
desired, but it does indeed appear to be the case, from the reading I did.

And apparently, the original RAID1 setups really did do only pair-
mirroring.  I believe (someone else made the claim and I've no evidence 
either way, so...) that Linux md/raid1 was one of the first to actually 
define raid1 as N-devices equals N-way-mirroring.  And once mdraid could 
do it, it was pretty hard for the hardware raid vendors to counter the 
"Hey, mdraid can do it for free, why would I pay you good money for less 
features?" argument, so they mostly ended up providing the same N-way-
mirroring raid1-type functionality as well, and it became quite common, 
despite the original RAID1 definition not actually defining RAID1 beyond 
the two-way-mirroring level.

So btrfs raid1 is indeed proper raid1 in that regard, tho you will notice 
that in btrfs terms it's almost always _lowercase_ "raid1", while the 
proper definition was an acronym, Redundant Array of Independent Devices, 
and thus in absolutely proper usage, would be all uppercase RAID1, or I 
believe even more properly, RAID-1.  But btrfs' raid1 functionality 
apparently isn't _exactly_ mirrored, the chunks are duplicated but may 
appear in different order, etc, and for that and other reasons, it's 
"raid1-like", but not precisely RAID-1, thus the generally consistent 
btrfs raid1 lowercasing.

But regardless, it /is/ still somewhat confusing, altho any admin worth 
the name will do pre-deployment research and testing, and the fact that 
btrfs raid1 mode is (currently) precisely two-way-mirrored, no matter how 
many devices beyond two there might be, is well enough documented that it 
will come up in that research, if the research is worth it's name, anyway.

Meanwhile, N-way-mirroring has long been roadmapped for coding up after 
raid56 mode, which took years longer than initially planned but is now 
complete and stabilizing, so N-way-mirroring should hopefully be along in 
a few more kernel cycles.  At that point, some rejiggering of the current 
definitions will obviously need to be done in ordered to make way for the 
new N-way-mirroring as well as the current pair-mirrored-only raid1, so 
we'll see then if the raid1 term is expanded to cover N-way-mirroring as 
well, or if a different term is used.

So while the present pair-mirroring-only raid1 state is indeed confusing, 
there is both historical precedent for it in the "RAID-1" term itself, 
and the current situation is temporary, with the N-way-mirroring form of 
"raid1" long being on the roadmap for after raid56 mode.  In fact, in 
general, it's only because raid56 mode a couple years longer than 
intended, that we're even still talking about this at all, as if raid56 
mode had dropped as originally planned, we'd have N-way-mirroring, 
whatever it ends up being called once the code actually drops, by now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

