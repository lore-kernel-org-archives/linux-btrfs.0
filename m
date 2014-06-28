Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49792 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaF1LjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:39:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X0qy9-0006sc-8q
	for linux-btrfs@vger.kernel.org; Sat, 28 Jun 2014 13:38:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 13:38:57 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 13:38:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 3+ drives
Date: Sat, 28 Jun 2014 11:38:47 +0000 (UTC)
Message-ID: <pan$960c0$4afea28f$ba20e37d$eab767e1@cox.net>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
	<10572318.CAuhDIAMDU@xev> <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
	<1403953457.BS00mAsj6N@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sat, 28 Jun 2014 16:28:23 +1000 as excerpted:

> On Sat, 28 Jun 2014 04:26:43 Duncan wrote:
>> Russell Coker posted on Sat, 28 Jun 2014 10:51:00 +1000 as excerpted:
>> > On Fri, 27 Jun 2014 20:30:32 Zack Coffey wrote:
>> >> Can I get more protection by using more than 2 drives?
>> >> 
>> >> I had an onboard RAID a few years back that would let me use RAID1
>> >> across up to 4 drives.
>> > 
>> > Currently the only RAID level that fully works in BTRFS is RAID-1
>> > with data on 2 disks.
>> 
>> Not /quite/ correct.  Raid0 works, but of course that isn't exactly
>> "RAID" as it's not "redundant".  And raid10 works.  But that's simply
>> raid0 over raid1.  So depending on whether you consider raid0 actually
> 
> http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10
> 
> There are a number of ways of doing RAID-0 over RAID-1,

Yes...

> but BTRFS doesn't do any of them.

It does...

> When you have more than 2 disks and
> tell BTRFS to do RAID-1 you get a result that might be somewhat
> comparable to Linux software RAID-10, except for the issue of having
> disks of different sizes and adding more disks after creating the
> "RAID".

What about when you tell btrfs to do raid10?
 
Unless you're going to argue that btrfs raid10 mode isn't "real" raid10, 
or that like raid5/6 it's not complete, but you haven't mentioned it at 
all, so that doesn't seem to be what you're saying.

Which was my point when I mentioned raid10 in the first place, it's 
there, and unlike raid5/6, I've never seen any indication that it's not 
complete or supported.

>> "RAID" or not, which in turn depends on how strict you are with the
>> "redundant" part, there is or is not more than btrfs raid1 working.
> 
> The way BTRFS, ZFS, and WAFL work is quite different to anything
> described in any of the original papers on RAID.  One could make a case
> that what these filesystems do shouldn't be called RAID, but then we
> would be searching for another term for it.

The FAQ admits that some people call it a layering violation... =8^0  
Which in a way it is, as it combines a below-filesystem virtual device 
layer (where raid is normally found) with the filesystem layer.  But the 
argument is, it's a /useful/ layering violation.  Which it is, as that's 
what gives btrfs the ability to do what it does with some of its features.

But the flip side of that is that since it includes so much that is 
normally strictly isolated into other layers, it's intensely complex, far 
more so than most other filesystems, which is why it's taking so horribly 
long to introduce some of these features, and why some of the scaling 
bugs in particular have been so nasty -- it's just /dealing/ with that 
much more than the ordinary filesystem.

The nearest competitor that I'm aware of is zfs.  But (1) zfs made some 
compromises that btrfs is trying to avoid, and (2) AFAIK, zfs had a LOT 
more real resources sunk into it.  I'm sure there's people that know way 
more about its development than I do.

And of course zfs isn't GPLv2 compatible, the reason it'll never be 
mainline Linux unless the zfs owners wish it so, but it's very obvious 
they wish it NOT so, which is why it remains as it is.  That's not 
important to everyone, but it's a big reason I can't/won't seriously 
consider zfs here.

> What I want is the ZFS copies= feature.

As others have mentioned, the discussed idea is multi-axis 
configurability, N-mirror, S-stripe, P-parity (tho I don't believe that's 
the letters used).  It's possible strip-size could be added to that as 
well.  Hugo is the guy that has been working most directly on defining 
that.

*BUT*, at this point that's all pie-in-the-sky for btrfs, while I guess 
zfs copies= "just works".  If the licensing issues weren't there, I 
imagine I'd be using zfs today, and if btrfs took another decade or 
whatever to mature, no big deal.  But the licensing issues are there and 
zfs is thus not an option for me, so... as I said earlier, we work with 
what we have.

>> The caveat with that is that at least mdraid1/dmraid1 has no verified
>> data integrity, and while mdraid5/6 does have 1/2-way-parity
>> calculation, it's only used in recovery, NOT cross-verified in ordinary
>> use.
> 
> Linux Software RAID-6 only uses the parity when you have a hard read
> error. If you have a disk return bad data and say it's good then you
> just lose.

Which is basically restating what I was saying.

> That said the rate of disks returning such bad data is very low.  If you
> had a hypothetical array of 4 disks as I suggested then to lose data you
> need to have one pair of disks entirely fail and another disk return
> corrupt data or have 2 disks in separate RAID-1 pairs return corrupt
> data on matching sectors (according to BTRFS data copies) such that
> Linux software RAID copies the corrupt data to the good disk.

Well, it's a bit more complex than that, and the details can definitely 
come back to bite you in certain corner cases, but I agree with the 
general idea.
 
> That sort of thing is much less likely than having a regular BTRFS
> RAID-1 array of 2 disks failing.

The problem is that there's little or no control of it at the mdraid 
level.  In md/raid1 mode, a "scrub" simply copies the data, good or bad, 
from the first device to the others.  There's no data integrity checking 
and not even a majority vote, it simply dumbly copies what's on one 
device to the others, as long as what's on the first device is readable 
at all.  In theory raid6 with its two-way-parity could be better, since 
it /does/ have the two-way-parity data it /could/ check, but the 
frustrating part of it is that it /doesn't/!  It only reads the data 
strip not the entire stripe, and doesn't do any cross-checking unless it 
has to make up for a dropped device.

And with the size of disks we have today, the statistics on multiple 
whole device reliability are NOT good to us!  There's a VERY REAL chance, 
even likelihood, that at least one block on the device is going to be 
bad, and not be caught by its own error detection!

There's some serious study and work going into this, and it's why people 
working on modern filesystems are pretty much all adding data integrity 
features, etc.  Btrfs and zfs aren't alone in that.  And it's really 
because there's no choice.  As TB scale to PB, the chances are that 
there /will/ be one or possibly more device-undetected errors somewhere 
on that device.  One in a billion or whatever (IDR the real number and 
I'm too lazy to do the math ATM) chance, but once you have numbers 
nearing a billion...
 
> Also if you were REALLY paranoid you could have 2 BTRFS RAID-1
> filesystems that each contain a single large file.  Those 2 large files
> could be run via losetup and used for another BTRFS RAID-1 filesystem. 
> That gets you redundancy at both levels.  Of course if you had 2 disks
> in one pair fail then the loopback BTRFS filesystem would still be OK.

But the COW and fragmentation issues on the bottom level... OUCH!  And 
you can't simply set NOCOW, because that turns off the checksumming as 
well, leaving you right back where you were without the integrity 
checking!

IOW, it might work for filesystems to a quarter TiB or so, but don't 
except it to scale to TiB plus without getting MASSIVELY slow.  I used to 
mention that theoretical option too, but once I saw the problems btrfs 
has with fragmentation on internal-write files, which is what loop-file 
would be... lets just say when I thought about mentioning it I shuddered 
and decided to forget I even considered it.

Tho for the sub-100-GiB filesystems I'm dealing with here, on fast SSD 
with near 100% over-provisioning (hey, the size I wanted wasn't available 
at a good price so I took what I could get, and the overprovisioning 
certainly doesn't hurt!), it might actually be somewhat practical...

> How does the BTRFS kernel code handle a loopback device read failure?
> 
>> In fact, with md/dmraid and its reasonable possibility of silent
>> corruption since at that level any of the copies could be returned and
>> there's no data integrity checking, if whatever md/dmraid level copy
>> /is/ returned ends up being bad, then btrfs will consider that side of
>> the pair bad, without any way to check additional copies at the
>> underlying md/dmraid level.  Effectively you only have two verified
>> copies no matter how many ways the dm/mdraid level is mirrored, since
>> there's no verification at the dm/mdraid level at all.
> 
> BTRFS doesn't consider a side of the pair to be bad, just the block that
> was read.  Usually disk corruption is in the order of dozens of blocks
> and the rest of the disk will be good.

I didn't word that well, primarily because I didn't even think of the 
whole-device-bad case.

What I meant was that in the context of a btrfs scrub, btrfs will only be 
aware of the two "sides" for every block, no matter how many devices the 
underlying mdraid on that "side" is actually composed of.  At the btrfs 
level, then, it'll only have one chance to present good data, and the 
mdraid level will effectively pick a candidate randomly.  If the picked 
candidate happens to return a block that fails the btrfs checksum, it'll 
reject that block from that side, regardless of how many good copies 
there might also be.  If it /does/ reject that block, you better *HOPE* 
that the copy it picks from the mdraid on the /other/ side happens to be 
valid, because if it's not...

If it's not, then btrfs will show both sides as failing the checksum, 
which means as far as btrfs is concerned that block (not the whole btrfs 
device "side", just that block, but that's bad enough) is dead, there's 
no good copies for it to use, regardless of the number of good copies on 
the other devices composing the underlying mdraids on each side.

It's simply a matter of chance, over which the admin has very little 
control.  That's the frustrating part, and the point I was trying to get 
across.

But I agree (now that you made me aware of that read of what I wrote in 
the first place) that the way I wrote it did sound like I was saying that 
btrfs would drop that whole underlying mdraid, composing that "side".  
But while that's what I appeared to write, that's not what I had in 
mind...

>> Tho if you ran a md/dmraid level scrub often enough, and then ran a
>> btrfs scrub on top, one could be /reasonably/ assured of freedom from
>> lower level corruption.
> 
> Not at all.  Linux software RAID scrub will copy data from one disk to
> the other.  It may copy from the good disk to the bad or from the bad
> disk to the good - and it won't know which it's doing.

Which was my point.

But, assuming that you do an mdraid scrub and it finds and copies a bad 
version.  At that point, if you've been both-layer scrubbing regularly, 
the chances of the /other/ side being bad are relatively low, so if as 
soon as you finish the mdraid scrub, you do a btrfs scrub, it should 
catch that bad copy and rewrite it from other, good copy at the btrfs 
level.  The rewrite will then be propagated down to all the devices on 
the underlying mdraid on the bad side of the btrfs, and with a bit of 
luck, that will rewrite all the bad copies, or at least the bad copy on 
the first mdraid device so that the next mdraid scrub will propagate it 
to the bad device.

If you constantly scrub the underlying mdraids and it sometimes 
propagates a bad block at that level, followed by a scrub at the btrfs 
level to (hopefully) force rewrites of any bad copies that the mdraid 
scrub propagated, then back to the mdraid level, then back to the btrfs 
level, basically constantly scrubbing at one level or the other, then in 
theory anyway, the chances of bitrot appearing on both sides of the btrfs 
at the same time are rather lowered...

*BUT* at a cost of essentially *CONSTANT* scrubbing.  Constant because at 
the multi-TBs we're talking, just completing a single scrub cycle could 
well take more than a standard 8-hour work-day, so by the time you 
finish, it's already about time to start the next scrub cycle.

That sort of constant scrubbing is going to take its toll both on device 
life and on I/O thruput for whatever data you're actually storing on the 
device, since a good share of the time it's going to be scrubbing as 
well, slowing down the speed of the real I/O.

And I just don't see that as realistic.  At least not for spinning rust, 
which is where people talking about multi-TB capacities are likely to be 
at this point.  For SSD it could be feasible as the scrubs should go fast 
enough that most of the time will be /between/ scrubs instead of /doing/ 
scrubs, and even during the scrubs, normal I/O shouldn't be /too/ held up 
on SSD, altho higher capacity I/O certainly would be, but of course SSD 
limits you to the lower capacities and higher costs of SSD.

> Also last time I checked a scrub of Linux software RAID-1 still reported
> large multiples of 128 sectors mismatching in normal operation.

Ouch!  That I hadn't even considered.

> So you won't even know if a disk is returning bogus data unless the bad
> data is copied to the good disk and exposed to BTRFS.
> 
>> But with both levels of scrub together very possibly taking a couple
>> days, and various ongoing write activity in the mean time, by the time
>> one run was done it'd be time to start the next one, so you'd
>> effectively be running scrub at one level or the other *ALL* the time!
> 
> No.  I have a RAID-1 array of 3TB disks that is 2/3 full which I scrub
> every Sunday night.  If I had an array of 4 disks then I could do scrubs
> on Saturday night as well.

But are you scrubbing at both the btrfs and the md/dmraid level?  That'll 
effectively double the scrub-time.

And the idea was to scrub say every other day if not daily, so the chance 
of developing further bitrot and thus of getting it on both sides of the 
btrfs at the same time, is reduced as much as possible because the bitrot 
is caught and btrfs-scrub-corrected as soon as possible.

And while that might not take a full 24 hours, it's likely to take a 
significant enough portion of 24 hours, that if you're doing a full mdraid 
and btrfs level both scrub every two days, some significant fraction (say 
a third to a half) of the time will be spent scrubbing, during which 
normal I/O speeds will be significantly reduced, while also reducing 
device lifetime due to the relatively high duty cycle seek activity.

>> So... I'd suggest either forgetting about data integrity for the time
>> being and just running md/dmraid without worrying about it, or just
>> running btrfs with pairs, and backing up to another btrfs of pairs.
>> Btrfs send/receive could even be used as the primary syncing method
>> between the main and backup set, altho I'd suggest having a fallback
>> such as rsync setup and tested to work as well, in case there's a bug
>> in send/ receive that stalls that method for awhile.
> 
> One advantage of BTRFS backup is that you know if the data is corrupt. 
> If you make several backups that end up with different blocks on disk
> then Linux knows which one has the correct file data.

Absolutely agreed. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

