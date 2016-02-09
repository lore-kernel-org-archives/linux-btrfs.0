Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37720 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbcBIBmu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 20:42:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aSxKK-0005A5-Nm
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 02:42:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 02:42:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 02:42:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "layout" of a six drive raid10
Date: Tue, 9 Feb 2016 01:42:40 +0000 (UTC)
Message-ID: <pan$b862$fa78f2fd$bea6373b$99d690b8@cox.net>
References: <1E2010FD-CBFD-44BD-B5DB-9ECD5C009391@bueechi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

boli posted on Mon, 08 Feb 2016 23:19:52 +0100 as excerpted:

> Hi
> 
> I'm trying to figure out what a six drive btrfs raid10 would look like.

> It could mean that stripes are split over two raid1 sets of three
> devices each. The sentence "Every stripe is split across to exactly 2
> RAID-1 sets" would lead me to believe this.
> 
> However, earlier it says for raid0 that "stripe[s are] split across as
> many devices as possible". Which for six drives would be: stripes are
> split over three raid1 sets of two devices each.
> 
> Can anyone enlighten me as to which is correct?

Hugo's correct, and this is pretty much restating what he did.  Sometimes 
I find that reading things again in different words helps me better 
understand the concept, and this post is made with that in mind.

At present, btrfs has only two-way mirroring, not N-way.  So any raid 
level that includes mirroring will have exactly two copies, no matter the 
number of devices.  (FWIW, N-way-mirroring is on the roadmap, but who 
knows when it'll come, and like raid56 mode, it will likely take some 
time to stabilize even once it does.)

What that means for a six device raid1 or raid10 is, still exactly two 
copies of everything, with raid1 simply being three independent chunks, 
two copies each, and raid10 being two copies of a three-device stripe.

> Reason I'm asking is that I'm deciding on a suitable raid level for a
> new DIY NAS box. I'd rather not use btrfs raid6 (for now).

Agreed and I think wise choice. =:^)  I'd still be a bit cautious of 
btrfs raid56, as I don't think it's quite to the level of stability that 
other btrfs raid types are, just yet.  I expect to be much more 
comfortable recommending it in another couple kernel cycles.

> The first
> alternative I thought of was raid10. Later I learned how btrfs raid1
> works and figured it might be better suited for my use case: Striping
> the data over multiple raid1 sets doesn't really help, as transfer
> from/to my box will be limited by gigabit ethernet anyway, and a single
> drive can saturate that.
> 
> Thoughts on this would also be appreciated.

Agreed, again. =:^)

Tho I'd consider benchmarking or testing, as I'm not sure btrfs raid1 on 
spinning rust will in practice fully saturate the gigabit Ethernet, 
particularly as it gets fragmented (which COW filesystems such as btrfs 
tend to do much more so than non-COW, unless you're using something like 
the autodefrag mount option from the get-go, as I do here, tho in that 
case, striping won't necessarily help a lot either).

If you're concerned about getting the last bit of performance possible, 
I'd say raid10, tho over the gigabit ethernet, the difference isn't 
likely to be much.

OTOH, if you're more concerned about ease of maintenance, replacing 
devices, etc, I believe raid1 is a bit less complex both in code terms 
(where less code complexity means less chance of bugs) and in 
administration, at least conceptually, tho in practice the administration 
is going to be very close to the same as well.

So I'd tend to lean toward raid1 for a use-case thruput limited to gitabit 
Ethernet speeds, even on spinning rust, as I think there may be a bit of 
a difference in speed vs raid10, but I doubt it'll be much due to the 
gigabit thruput limit, and I'd consider the lower complexity of raid1 to 
offset that.

> As a bonus I was wondering how btrfs raid1 are layed out in general, in
> particular with even and odd numbers of drives. A pair is trivial. For
> three drives I think a "ring setup" with each drive sharing half of its
> data with another drive. But how is it with four drives – are they
> organized as two pairs, or four-way, or …

For raid1, allocation is done in pairs, with each allocation taking the 
device with the most space left, except that both copies can't be on a 
single device, even if for instance you have a 3 TB device and the rest 
are 1 TB or smaller.  That case would result in one copy of each pair on 
the 3 TB device, one copy on whatever device has the most space left of 
the others.

Which on a filesystem with all equal sized devices, tends to result in 
round-robin allocation, tho of course in the odd number of devices case, 
there will always be at least one device that has either more or less 
allocation by a one-chunk margin.  (Tho it can be noted that metadata 
chunks are smaller than data chunks, and while Hugo noted the nominal 1 
GiB data chunk size and 256 MiB metadata chunk size, at the 100 GiB plus 
per device scale, chunks can be larger, upto 10 GiB data chunk, and of 
course smaller on very small devices, so the 1GiB-data/256MiB-metadata 
values are indeed only nominal, but they still give you some idea of the 
relative size.)

So a btrfs raid1 on four equally sized devices will indeed result in two 
pairs, but simply because of the most-space-available allocation rule, 
not because it's forced to pairs of pairs.  And with unequally sized 
devices, the device with the most space will always get one of the two 
copies, until its space equalizes to that of at least one other device.

Btrfs raid10 works similarly with the copy allocation, but stripe 
allocation works exactly opposite, prioritizing stripe width.  So with an 
even number of equally sized devices, each stripe will be half the number 
of devices wide, with the second copy being the other half.  If there's 
an odd number of devices, one will be left out on each allocation, but 
the one that's left out will change with each allocation, as the one left 
out in the previous allocation will now have more space available than 
the others so it'll be allocated first for one of the copies, leaving a 
different one to be left out on this allocation round.  And with 
unequally sized devices, allocation will always be to an even number and 
always to at least four at once, of course favoring the device with the 
most space available, but stripes will always be half the available 
width, with a second copy of the stripe to the other half, so will use up 
space on all devices at once if it's an even number of devices with space 
left, all but one if it's an odd number with space left, since both 
copies can't be on the same device, which means that odd device can't be 
used for that allocation round, tho it will be for the next, and a 
different device left out instead.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

