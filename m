Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40204 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaEBBsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 21:48:12 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help with space
Date: Fri, 2 May 2014 11:48:07 +1000
Cc: linux-btrfs@vger.kernel.org
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <2809235.lZD2oazSeA@xev> <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net>
In-Reply-To: <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201405021148.07577.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 1 May 2014, Duncan <1i5t5.duncan@cox.net> wrote:
> That's why I'm running raid1 for both data and metadata here.  I love
> btrfs' data/metadata checksumming and integrity mechanisms, and having
> that second copy to scrub from in the event of an error on one of them is
> just as important to me as the device-redundancy-and-failure-recovery bit.
> 
> I could get the latter on md/raid and did run it for some years, but the
> fact that there's no way to have it do routine read-time parity cross-
> check and scrub (or N-way checking and vote, rewriting to a bad copy on
> failure, in the case of raid1), even tho it has all the cross-checksums
> already there and available to do it, but only actually makes /use/ of
> that for recovery if a device fails...

Am I missing something or is it impossible to do a disk replace on BTRFS right 
now?

I can delete a device, I can add a device, but I'd like to replace a device.

If a disk has some bad sectors and I delete it from a RAID-1 (or RAID-5) array 
then I'll be one bad sector away from real data loss.  However if I could do a 
replace operation then the old disk would still be available if other disks 
don't work.

Currently it seems that the best thing to do if a disk in a RAID-1 array gets 
bad sectors is to shut the system down, run a program to read all the readable 
data and copy it to a fresh disk, then boot up again and run a scrub to fill 
the holes.  With modern disks that means 6+ hours of down-time for the copy.

> My biggest frustration with btrfs ATM is the lack of "true" raid1, aka
> N-way-mirroring.  Btrfs presently only does pair-mirroring, no matter the
> number of devices in the "raid1".  Checksummed-3-way-redundancy really is
> the sweet spot I'd like to hit, and yes it's on the road map, but this
> thing seems to be taking about as long as Christmas does to a five or six
> year old... which is a pretty apt metaphor of my anticipation and the
> eagerness with which I'll be unwrapping and playing with that present
> once it comes! =:^)

http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf‎

Whether a true RAID-1 means just 2 copies or N copies is a matter of opinion.  
Papers such as the above seem to clearly imply that RAID-1 is strictly 2 
copies of data.

I don't have a strong opinion on how many copies of data can be involved in a 
RAID-1, but I think that there's no good case to claim that only 2 copies 
means that something isn't "true RAID-1".

> > My experience is that in the vast majority of disk failures that don't
> > involve dropping a disk the majority of disk data will still be
> > readable.  For example one time I had a workstation running RAID-1 get
> > too hot in summer and both disks developed significant numbers of
> > errors, enough that it couldn't maintain a Linux Software RAID-1 (disks
> > got kicked out all the time).  I wrote a program to read all the data
> > from disk 0 and read from disk 1 any blocks that couldn't be read from
> > disk 0, the result was that after running e2fsck on the result I didn't
> > lose any data.
> 
> That's rather similar to an experience of mine.  I'm in Phoenix, AZ, and
> outdoor in-the-shade temps can reach near 50C.  Air-conditioning failure
> with a system left running while I was elsewhere.  I came home the the
> "hot car effect", far hotter inside than out, so likely 55-60C ambient
> air temp, very likely 70+ device temps.  The system was still on but
> "frozen" (broiled?) due to disk head crash and possibly CPU thermal
> shutdown.
> 
> Surprisingly, after shutting everything down, getting a new AC, and
> letting the system cool for a few hours, it pretty much all came back to
> life, including the CPU(s) (that was pre-multi-core, but I don't remember
> whether it was my dual socket original Opteron, or pre-dual-socket for me
> as well) which I had feared would be dead.

CPUs have had thermal shutdown for a long time.  When a CPU lacks such 
controls (as some buggy Opteron chips did a few years ago) it makes the IT 
news.

> Anyway, yes, my experience tracks yours.  Both in that case and when I
> simply run the disks to wear-out (which I sometimes do as a secondary/
> backup/low-priority-cache-data device once it starts clicking or
> developing bad sectors or whatever), the devices themselves continue to
> work in general, long after I've begun to see intermittent issues with
> them.

Disks can continue to work for a long time after they flag errors.  The backup 
disk I'm referring to is one that I got from a client a year ago after the NAS 
it was running in flagged an error.

> > So if you have BTRFS configured to "dup" metadata on a RAID-5 array
> > (either hardware RAID or Linux Software RAID) then the probability of
> > losing metadata would be a lot lower than for a filesystem which doesn't
> > do checksums and doesn't duplicate metadata.  To lose metadata you would
> > need to have two errors that line up with both copies of the same
> > metadata block.
> 
> Like I said, btrfs raid1 both data/metadata here, for exactly that
> reason.  But I'd sure like to make it triplet-mirror instead of being
> limited to pair-mirror, again for exactly that reason.  Currently, I

I'd like to be able to run a combination of "dup" and RAID-1 for metadata.  
ZFS has a "copies" option, it would be good if we could do that.

RAID-1 plus backups is more than adequate for file data for me.  But errors on 
2 disks knocking out some metadata would be a major PITA.

It's nice the way a BTRFS scrub tells you the file names that are affected.  
So if I have errors on a pair of disks in a RAID-1 array that don't affect 
metadata then I don't need to do a full restore and try and find and merge 
changes that happened after the last backup, I just need to copy the raw 
devices to new disks, scrub the filesystem, and then restore from backup any 
files that are flagged as bad.

> figure the chance of both copies independently going bad is lower than
> the risk of a bug in still-under-development btrfs making BOTH copies
> equally bad (even if they pass checksum), and I'm choosing to run btrfs
> knowing that tho I keep non-btrfs backups just in case.  But as btrfs
> matures and stabilizes, the chance of a btrfs bug making both copies bad
> goes down, while the chance of the two copies independently going bad at
> the same place remains the same, and as the two chances reverse in
> likelihood, I'd sure like to have that triplet-mirroring available.

I use BTRFS for all my backups too.  I think that the chance of data patterns 
triggering filesystem bugs that break backups as well as primary storage is 
vanishingly small.  The chance of such bugs being latent for long enough that 
I can't easily recreate the data isn't worth worrying about.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
