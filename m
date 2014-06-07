Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:52815 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaFGC3M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 22:29:12 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 6D09220339
	for <linux-btrfs@vger.kernel.org>; Sat,  7 Jun 2014 12:29:06 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: Re: Very slow filesystem
Date: Sat, 07 Jun 2014 12:29:05 +1000
Message-ID: <1748350.S3klgLzlBt@xev>
In-Reply-To: <CAKcLGm8fFX-Hqz0iEgk2qtsUXrSNW=XsKMHiVWZvV4AoJCBGVQ@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com> <pan$95296$7c52a8f8$5f80de1d$977b2dd9@cox.net> <CAKcLGm8fFX-Hqz0iEgk2qtsUXrSNW=XsKMHiVWZvV4AoJCBGVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 6 Jun 2014 14:06:53 Mitch Harder wrote:
> Every time you update your database, btrfs is going to update
> whichever 128 KiB blocks need to be modified.
> 
> Even for a tiny modification, the new compressed block may be slightly
> more or slightly less than 128 KiB.
> 
> If you have a 1-2 GB database that is being updated with any
> frequency, you can see how you will quickly end up with lots of
> metadata fragmentation as well as inefficient data block utilization.
> I think this will be the case even if you switch to NOCOW due to the
> compression.
> 
> On a very fundamental level, file system compression and large
> databases are two use cases that are difficult to reconcile.

The ZFS approach of using a ZIL (write-back cache that caches before 
allocation) and L2ARC (read-cache on SSD) mitigates these problems.  Samsung 
1TB SSDs are $565 at my local computer store, if your database has a working 
set of less than 2TB then SSDs with L2ARC should solve those performance 
problems at low cost.  The vast majority of sysadmins have never seen a 
database that's 2TB in size, let alone one with a 2TB working set.

That said I've seen Oracle docs recommending against ZFS for large databases, 
but the Oracle definition of "large database" is probably a lot larger than 
anything that is likely to be stored on BTRFS in the near future.

Another thing to note is that there are a variety of ways of storing 
compressed data in databases.  Presumably anyone who is storing so much data 
that the working set exceeds the ability to attach lots of SSDs is going to be 
using some form of compressed tables which will reduce the ability of 
filesystem compression to do any good.

On Fri, 6 Jun 2014 19:59:55 Duncan wrote:
> Similarly for checksumming.  When there are enough updates, in addition 
> to taking more time to calculate and write, checksumming simply invites 
> race conditions between the last then-valid checksum and the next update 
> invalidating it.  In addition, in many, perhaps most cases, the sorts of 
> apps that do constant internal updates, have already evolved their own 
> data integrity verification methods in ordered to cope with issues on the 
> after all way more common unverified filesystems, creating even more 
> possible race conditions and timing issues and making all that extra work 
> that btrfs normally does for verification unnecessary.  Trying to do all 
> that in-place due to NOCOW is a recipe for failure or insanity if not both

http://www.strchr.com/crc32_popcnt

The above URL has some interesting information about CRC32 speed.  In summary 
if you have a Core i5 system then you are looking at less than a clock cycle 
per byte on average.  So if your storage is capable of handling more than 
4GB/s of data transfer then CRC32 might be a bottleneck.  But doing 4GB/s for 
a database is a very different problem.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

