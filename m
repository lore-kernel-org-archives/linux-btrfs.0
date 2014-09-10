Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:52252
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbaIJRoX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 13:44:23 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 4B77A22142
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 18:44:22 +0100 (BST)
Message-ID: <54108DF5.8020606@barrowhillfarm.org.uk>
Date: Wed, 10 Sep 2014 18:44:21 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
References: <541043B8.7010601@barrowhillfarm.org.uk> <54104CD6.3030604@gmail.com>
In-Reply-To: <54104CD6.3030604@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/09/14 14:06, Austin S Hemmelgarn wrote:
> On 2014-09-10 08:27, Bob Williams wrote:
>> I have two 2TB disks formatted as a btrfs raid1 array, mirroring
>> both data and metadata. Last night I started
>> 
>> # btrfs filesystem balance <path>
>> 
> In general, unless things are really bad, you don't ever want to
> use balance on such a big filesystem without some filters to
> control what gets balanced (especially if the filesystem is more
> than about 50% full most of the time).
> 
Thank you. These disks are in an external, SATA II enclosure, and I
use them for backups. They contain about 6 subvolumes, each containing
 rsynced data and about 50 snapshots. btrfs fi sh says that I've used
890Gib out of 1.82Tib, so approaching 50%.

> My suggestion in this case would be to use: # btrfs balance start
> -dusage=25 -musage=25 <path> on a roughly weekly basis.  This will
> only balance chunks that are less than 25% full, and therefore run
> much faster.  If you are particular about high storage efficiency,
> then try 50 instead of 25.
>> and it is still running 18 hours later. This suggests that most
>> stuff only gets written to one physical device, which in turn
>> suggests that there is a risk of lost data if one physical device
>> fails. Or is there something clever about btrfs raid that I've
>> missed? I've used linux software raid (mdraid) before, and it
>> appeared to write to both devices simultaneously.
> The reason that a full balance takes so long on a big (and I'm
> assuming based on the 18 hours it's taken, very full) filesystem is
> that it reads all of the data, and writes it out to both disks, but
> it doesn't do very good load-balancing like mdraid or LVM do.  I've
> got a 4x 500Gib BTRFS RAID10 filesystem that I use for my home
> directory on my desktop system, and a full balance on that takes
> about 6 hours.

See above re how full the filesystem is. The process finished after
about 22 hours, with the message:

"Done, had to relocate 1230 out of 1230 chunks"
>> 
>> Is it safe to interrupt [^Z] the btrfs balancing process?
> ^Z sends a SIGSTOP, which is a really bad idea with something that
> is doing low-level stuff to a filesystem.  If you need to stop the
> balance process (and are using a recent enough kernel and
> btrfs-progs), the preferred way to do so is to use the following
> from another terminal: # btrfs balance stop <path> Depending on
> what the balance operation is working when you do this, it may take
> a few minutes before it actually stops (the longest that I've seen
> it take is ~200 seconds).
>> 
>> As a rough guide, how often should one perform
>> 
>> a) balance b) defragment c) scrub
>> 
>> on a btrfs raid setup?
> In general, you should be running scrub regularly, and balance and 
> defragment as needed.  On the BTRFS RAID filesystems that I have, I
> use the following policy: 1) Run a 25% balance (the command I
> mentioned above) on a weekly basis. 2) If the filesystem has less
> than 50% of either the data or metadata chunks full at the end of
> the month, run a full balance on it. 3) Run a scrub on a daily
> basis. 4) Defragment files only as needed (which isn't often for me
> because I use the autodefrag mount option). 5) Make sure than only
> one of balance, scrub or defrag is running at a given time.

Useful advice, thanks. I'm already doing a weekly scrub on my / and
/home partitions. I'll try adding the 25% balance routine as well.

Bob

- -- 
Bob Williams
System:  Linux 3.11.10-21-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.14.0
Uptime:  06:00am up 5 days 15:04, 4 users, load average: 1.94, 2.21, 2.36
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEUEARECAAYFAlQQjfMACgkQ0Sr7eZJrmU5V2wCggtKbz3Iwr0cSJrC4c7kNG1dT
fLcAl20Z+YA2mrJTYAWT2Rf9HhIICT8=
=CBHC
-----END PGP SIGNATURE-----
