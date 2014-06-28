Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:34947 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaF1G23 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 02:28:29 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 3+ drives
Date: Sat, 28 Jun 2014 16:28:23 +1000
Message-ID: <1403953457.BS00mAsj6N@xev>
In-Reply-To: <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com> <10572318.CAuhDIAMDU@xev> <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 28 Jun 2014 04:26:43 Duncan wrote:
> Russell Coker posted on Sat, 28 Jun 2014 10:51:00 +1000 as excerpted:
> > On Fri, 27 Jun 2014 20:30:32 Zack Coffey wrote:
> >> Can I get more protection by using more than 2 drives?
> >> 
> >> I had an onboard RAID a few years back that would let me use RAID1
> >> across up to 4 drives.
> > 
> > Currently the only RAID level that fully works in BTRFS is RAID-1 with
> > data on 2 disks.
> 
> Not /quite/ correct.  Raid0 works, but of course that isn't exactly
> "RAID" as it's not "redundant".  And raid10 works.  But that's simply
> raid0 over raid1.  So depending on whether you consider raid0 actually

http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10

There are a number of ways of doing RAID-0 over RAID-1, but BTRFS doesn't do 
any of them.  When you have more than 2 disks and tell BTRFS to do RAID-1 you 
get a result that might be somewhat comparable to Linux software RAID-10, 
except for the issue of having disks of different sizes and adding more disks 
after creating the "RAID".

> "RAID" or not, which in turn depends on how strict you are with the
> "redundant" part, there is or is not more than btrfs raid1 working.

The way BTRFS, ZFS, and WAFL work is quite different to anything described in 
any of the original papers on RAID.  One could make a case that what these 
filesystems do shouldn't be called RAID, but then we would be searching for 
another term for it.

> > If you have 4 disks in the array then each block will
> > be on 2 of the disks.
> 
> Correct.
> 
> FWIW I'm told that the paper that laid out the original definition of
> RAID (which was linked on this list in a similar discussion some months
> ago) defined RAID-1 as paired redundancy, no matter the number of
> devices.  Various implementations (including Linux' own mdraid soft-raid,
> and I believe dmraid as well) feature multi-way-mirroring aka N-way-
> mirroring such that N devices equals N way mirroring, but that's an
> implementation extension and isn't actually necessary to claim RAID-1
> support.

The paper is a little ambiguous as to whether a 3 disk mirror can be RAID-1.

> So look for N-way-mirroring when you go RAID shopping, and no, btrfs does
> not have it at this time, altho it is roadmapped for implementation after
> completion of the raid5/6 code.
> 
> FWIW, N-way-mirroring is my #1 btrfs wish-list item too, not just for
> device redundancy, but to take full advantage of btrfs data integrity
> features, allowing to "scrub" a checksum-mismatch copy with the content
> of a checksum-validated copy if available.  That's currently possible,
> but due to the pair-mirroring-only restriction, there's only one
> additional copy, and if it happens to be bad as well, there's no
> possibility of a third copy to scrub from.  As it happens my personal
> sweet-spot between cost/performance and reliability would be 3-way
> mirroring, but once they code beyond N=2, N should go unlimited, so N=3,
> N=4, N=50 if you have a way to hook them all up... should all be possible.

What I want is the ZFS copies= feature.

> > If you want to have 4 disks in a fully redundant configuration (IE you
> > could lose 3 disks without losing any data) then the thing to do is to
> > have 2 RAID-1 arrays with Linux software RAID and then run BTRFS RAID-1
> > on top of that.
> 
> The caveat with that is that at least mdraid1/dmraid1 has no verified
> data integrity, and while mdraid5/6 does have 1/2-way-parity calculation,
> it's only used in recovery, NOT cross-verified in ordinary use.

Linux Software RAID-6 only uses the parity when you have a hard read error.  
If you have a disk return bad data and say it's good then you just lose.

That said the rate of disks returning such bad data is very low.  If you had a 
hypothetical array of 4 disks as I suggested then to lose data you need to 
have one pair of disks entirely fail and another disk return corrupt data or 
have 2 disks in separate RAID-1 pairs return corrupt data on matching sectors 
(according to BTRFS data copies) such that Linux software RAID copies the 
corrupt data to the good disk.

That sort of thing is much less likely than having a regular BTRFS RAID-1 
array of 2 disks failing.

Also if you were REALLY paranoid you could have 2 BTRFS RAID-1 filesystems 
that each contain a single large file.  Those 2 large files could be run via 
losetup and used for another BTRFS RAID-1 filesystem.  That gets you 
redundancy at both levels.  Of course if you had 2 disks in one pair fail then 
the loopback BTRFS filesystem would still be OK.

How does the BTRFS kernel code handle a loopback device read failure?

> In fact, with md/dmraid and its reasonable possibility of silent
> corruption since at that level any of the copies could be returned and
> there's no data integrity checking, if whatever md/dmraid level copy /is/
> returned ends up being bad, then btrfs will consider that side of the
> pair bad, without any way to check additional copies at the underlying md/
> dmraid level.  Effectively you only have two verified copies no matter
> how many ways the dm/mdraid level is mirrored, since there's no
> verification at the dm/mdraid level at all.

BTRFS doesn't consider a side of the pair to be bad, just the block that was 
read.  Usually disk corruption is in the order of dozens of blocks and the 
rest of the disk will be good.

> Tho if you ran a md/dmraid level scrub often enough, and then ran a btrfs
> scrub on top, one could be /reasonably/ assured of freedom from lower
> level corruption.

Not at all.  Linux software RAID scrub will copy data from one disk to the 
other.  It may copy from the good disk to the bad or from the bad disk to the 
good - and it won't know which it's doing.

Also last time I checked a scrub of Linux software RAID-1 still reported large 
multiples of 128 sectors mismatching in normal operation.  So you won't even 
know if a disk is returning bogus data unless the bad data is copied to the 
good disk and exposed to BTRFS.

> But with both levels of scrub together very possibly
> taking a couple days, and various ongoing write activity in the mean
> time, by the time one run was done it'd be time to start the next one, so
> you'd effectively be running scrub at one level or the other *ALL* the
> time!

No.  I have a RAID-1 array of 3TB disks that is 2/3 full which I scrub every 
Sunday night.  If I had an array of 4 disks then I could do scrubs on Saturday 
night as well.

> So... I'd suggest either forgetting about data integrity for the time
> being and just running md/dmraid without worrying about it, or just
> running btrfs with pairs, and backing up to another btrfs of pairs.
> Btrfs send/receive could even be used as the primary syncing method
> between the main and backup set, altho I'd suggest having a fallback such
> as rsync setup and tested to work as well, in case there's a bug in send/
> receive that stalls that method for awhile.

One advantage of BTRFS backup is that you know if the data is corrupt.  If you 
make several backups that end up with different blocks on disk then Linux 
knows which one has the correct file data.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

