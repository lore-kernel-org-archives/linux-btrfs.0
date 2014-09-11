Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36028 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752416AbaIKEaI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 00:30:08 -0400
Date: Thu, 11 Sep 2014 00:30:07 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Bob Williams <linux@barrowhillfarm.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Message-ID: <20140911043007.GB10787@hungrycats.org>
References: <541043B8.7010601@barrowhillfarm.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <541043B8.7010601@barrowhillfarm.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 10, 2014 at 01:27:36PM +0100, Bob Williams wrote:
> I have two 2TB disks formatted as a btrfs raid1 array, mirroring both
> data and metadata. Last night I started
> 
> # btrfs filesystem balance <path>
> 
> and it is still running 18 hours later. This suggests that most stuff
> only gets written to one physical device, which in turn suggests that
> there is a risk of lost data if one physical device fails. Or is there
> something clever about btrfs raid that I've missed? I've used linux
> software raid (mdraid) before, and it appeared to write to both
> devices simultaneously.
> 
> Is it safe to interrupt [^Z] the btrfs balancing process?

The ioctl isn't interruptible, so ^Z won't do much.  You'll need a
separate window to run 'btrfs balance pause' or 'btrfs balance cancel'.
It seems to wait until it's reached the end of a block group before it
actually stops, so it may take a few minutes or a few hours depending
on how much other load you have on the filesystem.

> As a rough guide, how often should one perform
> 
> a) balance

I have a cron job that runs 'btrfs balance resume' or 'btrfs balance
start' (depending on whether a balance is already in progress) nightly
at 1AM.  Another cron job comes along at 6AM to run 'btrfs balance pause'
on my headless servers.  On my desktops and laptops I have a daemon that
detects keyboard/mouse input and does 'btrfs balance pause' when some
is detected (the balance remains paused until the next day at 1AM,
as it is really heavy and takes a long time to come to a stop).

Using that schedule, a full balance can take weeks to run to completion on
a busy server.  Enough progress is made each day to have some benefit.

I keep my disks 90-99% full.  Free space fragmentation can be a huge
performance problem, since it causes severe file fragmentation when
large files are created or modified.  Balancing rearranges the allocated
space so that there are big enough contiguous free spaces so that new
data isn't scattered sparsely across the entire surface of the disk.

> b) defragment

I run this once daily on a continuously active 4GB PostgreSQL DB.
I generally don't bother with defragment otherwise.

I have millions of tiny files that are already unfragmented, and a few
huge files that can't be defragmented without moving around hundreds
of GB of data to make a free contiguous extent.  For me defragment is
usually either pointless or too expensive to be worthwhile, with a
few specific exceptions like highly active large database files.

Defragmentation also does not seem to play well with snapshots and
deduplication.

> c) scrub

Every 14 days.  The ZFS guideline is one scrub every 4 weeks for
enterprise drives, and every week for consumer drives.  I split the
difference.  scrub is relatively fast so it's not too painful to run
it often.  On the opposite weeks I run SMART self-tests on the drives too.

On desktops and laptops I have a daemon that listens for keyboard/mouse
input and pause/resumes scrubs, so I don't have to wait around while
scrub competes for my disk bandwidth.  The servers just get a little
slower for a couple of hours a month.

> on a btrfs raid setup?

I use roughly the same policies on all my btrfs filesystems from SSDs
and single spinning disks to six-disk RAID1 arrays.  I don't rebalance
SD cards--they are too fragile for the write load, and chances are good
that they'll wear out before balancing becomes necessary anyway.  On
busy server machines I'll rearrange the balancing hours to avoid high
load times.

> Bob
> - -- 
> Bob Williams
> System:  Linux 3.11.10-21-desktop
> Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.14.0
> Uptime:  06:00am up 5 days 15:04, 4 users, load average: 1.94, 2.21, 2.36
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> 
> iEYEARECAAYFAlQQQ6wACgkQ0Sr7eZJrmU5WlwCfd+OcuqFoz/vYSZEHg+5zNwlo
> oTQAn2ZKhx4gCdQIy0gl9EBb8XXVJu1G
> =2GSh
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
