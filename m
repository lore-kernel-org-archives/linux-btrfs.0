Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:36791 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaF1NkG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 09:40:06 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 3+ drives
Date: Sat, 28 Jun 2014 23:40 +1000
Message-ID: <1428358.y4e5pb3mAe@xev>
In-Reply-To: <pan$960c0$4afea28f$ba20e37d$eab767e1@cox.net>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com> <1403953457.BS00mAsj6N@xev> <pan$960c0$4afea28f$ba20e37d$eab767e1@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 28 Jun 2014 11:38:47 Duncan wrote:
> And with the size of disks we have today, the statistics on multiple
> whole device reliability are NOT good to us!  There's a VERY REAL chance,
> even likelihood, that at least one block on the device is going to be
> bad, and not be caught by its own error detection!

http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html

The above paper suggests that it's about 10% of SATA disks getting such errors 
per year and that typically a disk that has such a problem has it for ~50 
sectors.  The probability of having 2 disks randomly get such errors (if they 
are truly random and independent) would be something like 1% per year.  The 
probability that the ~50 sectors on each of 2*3TB disks happening to match up 
is much lower.

> > Also if you were REALLY paranoid you could have 2 BTRFS RAID-1
> > filesystems that each contain a single large file.  Those 2 large files
> > could be run via losetup and used for another BTRFS RAID-1 filesystem.
> > That gets you redundancy at both levels.  Of course if you had 2 disks
> > in one pair fail then the loopback BTRFS filesystem would still be OK.
> 
> But the COW and fragmentation issues on the bottom level... OUCH!  And
> you can't simply set NOCOW, because that turns off the checksumming as
> well, leaving you right back where you were without the integrity
> checking!

It really depends on how much performance you need.  I've got some virtual 
servers running BTRFS within BTRFS and with modern hardware and a light load 
it works OK.

> *BUT* at a cost of essentially *CONSTANT* scrubbing.  Constant because at
> the multi-TBs we're talking, just completing a single scrub cycle could
> well take more than a standard 8-hour work-day, so by the time you
> finish, it's already about time to start the next scrub cycle.

Scrubbing my BTRFS RAID-1 filesystem with 2.4TB of data stored on a pair of 
3TB disks takes 5 hours.

> That sort of constant scrubbing is going to take its toll both on device
> life and on I/O thruput for whatever data you're actually storing on the
> device, since a good share of the time it's going to be scrubbing as
> well, slowing down the speed of the real I/O.

Some years ago I asked an executive from a company that manufactured hard 
drives about this.  The engineering manager who was directed to answer my 
question told me that the drives were designed to perform any sequence of 
legal operations continually for the warranty period.  So if a disk had a 3 
year warranty then it should be able to survive a scrubbing loop for 3 years.

But scrubbing a system that runs 24*7 is a problem.  Hopefully we will get a 
speed limit feature for BTRFS scrubbing as there is for Linux software RAID 
rebuild/scrub.

> > No.  I have a RAID-1 array of 3TB disks that is 2/3 full which I scrub
> > every Sunday night.  If I had an array of 4 disks then I could do scrubs
> > on Saturday night as well.
> 
> But are you scrubbing at both the btrfs and the md/dmraid level?  That'll
> effectively double the scrub-time.

It's a BTRFS RAID-1, there is no mdadm on that system.

> And while that might not take a full 24 hours, it's likely to take a
> significant enough portion of 24 hours, that if you're doing a full mdraid
> and btrfs level both scrub every two days, some significant fraction (say
> a third to a half) of the time will be spent scrubbing, during which
> normal I/O speeds will be significantly reduced, while also reducing
> device lifetime due to the relatively high duty cycle seek activity.

When the expected error rate for SATA disks is ~10% of disks having errors per 
year a scrub every second day seems rather paranoid.

But if you are that paranoid then the wisc.edu paper suggests that you should 
be buying "enterprise" disks that have a much lower error rate.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

