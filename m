Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60396 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdE1A77 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 20:59:59 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 8B140600B1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 02:59:57 +0200 (CEST)
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d5ebd421-52a1-5b91-72a3-f97a2fb9628f@mendix.com>
Date: Sun, 28 May 2017 02:59:57 +0200
MIME-Version: 1.0
In-Reply-To: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A small update...

Original (long) message:
https://www.spinics.net/lists/linux-btrfs/msg64446.html

On 04/08/2017 10:19 PM, Hans van Kranenburg wrote:
> [...]
> 
> == But! The Meta Mummy returns! ==
> 
> After changing to nossd, another thing happened. The expiry process,
> which normally takes about 1.5 hour to remove ~2500 subvolumes (keeping
> it queued up to a 100 orphans all the time), suddenly took the entire
> rest of the day, not being done before the nightly backups had to start
> again at 10PM...
> 
> And the only thing it seemed to do is writing, writing, writing 100MB/s
> all day long.

This behaviour was observed with a 4.7.5 linux kernel.

When running 4.9.25 now with -o nossd, this weird behaviour is gone. I
have no idea what change between 4.7 and 4.9 is responsible for this,
but it's good.

> == So, what do we want? ssd? nossd? ==
> 
> Well, both don't do it for me. I want my expensive NetApp disk space to
> be filled up, without requiring me to clean up after it all the time
> using painful balance actions and I want to quickly get rid of old
> snapshots.
> 
> So currently, there's two mount -o remount statements before and after
> doing the expiries...

With 4.9+ now, it stays on nossd for sure, everywhere. :)

I keep doing daily btrfs-heatmap pictures, here's a nice timelapse of
Feb 22 until May 26th. One picture per day.

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-05-28-btrfs-nossd-whoa.mp4

These images use --sort virtual, so the block groups jump around a bit
because of the free-space-fragmentation-level-score-based btrfs balance
that I did for a few weeks. Total fs size is close to 40TiB.

At 17 seconds into the movie, I switched over to -o nossd. The effect is
very clearly visible. Suddenly the filesystem starts filling up all
empty space, starting at the beginning of the virtual address space. In
the last few months the amount of allocated but unused space went down
from about 6 TiB to a bit more than 2 TiB now, and it's still decreasing
every day. \o/

This actually means that forcing -o nossd solved the main headache and
cause of babysitting requirements when using btrfs that I have been
experiencing from the very beginning of trying it...

By the way, being able to use only nossd only is also a big improvement
for the (a few dozen) smaller filesystems that we use with replication
for DR purposes (yay, btrbk). We don't have to look around and respond
to alerts all the time any more to see which filesystem is choking
itself to death today and then rescue it with btrfs balance, and the
snapshot and send/receive schedule and expiry doesn't cause abnormal
write IO any more. \o/

> [...]
> 
> == Work to do ==
> 
> The next big change on this system will be to move from the 4.7 kernel
> to the 4.9 LTS kernel and Debian Stretch.

After starting to upgrade other btrfs filesystems to use kernel 4.9 in
the last few weeks (including the smaller backup servers), I did the
biggest one today. It's running 4.9.25 now, or Debian 4.9.25-1~bpo8+1 to
be exact. Currently it's working its way through the nightlies, looking
good.

> Note that our metadata is still DUP, and it doesn't have skinny extent
> tree metadata yet. It was originally created with btrfs-progs 3.17, and
> when we realized we should have single it was too late. I want to change
> that and see if I can convert on a NetApp clone. This should reduce
> extent tree metadata size by maybe more than 60% and whoknowswhat will
> happen to the abhorrent write traffic.

Yeah, blabla... Converting metadata from DUP to single is a big no go
with btrfs balance, that's what I clearly got figured out now.

> Before switching over to the clone as live backup server, all missing
> snapshots can be rsynced over from the live backup server.

Using snapshot/clone functionality of our NetApp storage, I did the move
from 4.7 to 4.9 in the last two days.

Since mounting with 4.9 requires a rebuild of the free space tree (and
since I didn't feel like hacking the feature bit in instead), this
wasn't going to be a quick maintenance action.

Two days ago I cloned the luns that make up the (now) 40TiB filesystem
and did the skinny-metadata and free space tree changes, and also
cleaned out the free space cache v1 (byebye..)

-# time btrfsck --clear-space-cache v2 /dev/xvdb
Clear free space cache v2
free space cache v2 cleared

real    10m47.854s
user    0m17.200s
sys     0m11.040s

-# time btrfsck --clear-space-cache v1 /dev/xvdb
Clearing free space cache
Free space cache cleared

real    195m8.970s
user    161m32.380s
sys     24m23.476s

^^notice the cpu usage...

-# time btrfstune -x /dev/xvdb

real    17m4.647s
user    0m16.856s
sys     0m3.944s

-# time mount -o noatime,nossd,space_cache=v2 /dev/xvdb /srv/backup

real    289m55.671s
user    0m0.000s
sys     1m11.156s

Yeah, random read IO sucks... :|

In the two days after, I ran the same expiries as the production backup
server was doing, and synced new backup data to the clone. Tonight, just
before the nightly run, I swapped the production luns and the clones so
the real backup server could quickly continue using the prepared filesystem.

-- 
Hans van Kranenburg
