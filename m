Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38278 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdDHUTP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 16:19:15 -0400
Received: from dorothy.pg10b.knorrie.org (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 3EAB96000A
        for <linux-btrfs@vger.kernel.org>; Sat,  8 Apr 2017 22:19:12 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: About free space fragmentation, metadata write amplification and
 (no)ssd
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
Date: Sat, 8 Apr 2017 22:19:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So... today a real life story / btrfs use case example from the trenches
at work...

tl;dr 1) btrfs is awesome, but you have to carefully choose which parts
of it you want to use or avoid 2) improvements can be made, but at least
the problems relevant for this use case are managable and behaviour is
quite predictable.

This post is way too long, but I hope it's a fun read for a lazy sunday
afternoon. :) Otherwise, skip some sections, they have headers.

...

The example filesystem for this post is one of the backup server
filesystems we have, running btrfs for the data storage.

== About ==

In Q4 2014, we converted all our backup storage from ext4 and using
rsync with --link-dest to btrfs while still using rsync, but with btrfs
subvolumes and snapshots [1]. For every new backup, it creates a
writable snapshot of the previous backup and then uses rsync on the file
tree to get changes from the remote.

Currently there's ~35TiB of data present on the example filesystem, with
a total of just a bit more than 90000 subvolumes, in groups of 32
snapshots per remote host (daily for 14 days, weekly for 3 months,
montly for a year), so that's about 2800 'groups' of them. Inside are
millions and millions and millions of files.

And the best part is... it just works. Well, almost, given the title of
the post. But, the effort needed for creating all backups and doing
subvolume removal for expiries scales linearly with the amount of them.

== Hardware and filesystem setup ==

The actual disk storage is done using NetApp storage equipment, in this
case a FAS2552 with 1.2T SAS disks and some extra disk shelves. Storage
is exported over multipath iSCSI over ethernet, and then grouped
together again with multipathd and LVM, striping (like, RAID0) over
active/active controllers. We've been using this setup for years now in
different places, and it works really well. So, using this, we keep the
whole RAID / multiple disks / hardware disk failure part outside the
reach of btrfs. And yes, checksums are done twice, but who cares. ;]

Since the maximum iSCSI lun size is 16TiB, the maximum block device size
that we use by combining two is 32TiB. This filesystem is already
bigger, so at some point we added two new luns in a new LVM volume
group, and added the result to the btrfs filesystem (yay!):

Total devices 2 FS bytes used 35.10TiB
devid    1 size 29.99TiB used 29.10TiB path /dev/xvdb
devid    2 size 12.00TiB used 11.29TiB path /dev/xvdc

Data, single: total=39.50TiB, used=34.67TiB
System, DUP: total=40.00MiB, used=6.22MiB
Metadata, DUP: total=454.50GiB, used=437.36GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Yes, DUP metadata, more about that later...

I can also umount the filesystem for a short time, take a snapshot on
NetApp level from the luns, clone them and then have a writable clone of
a 40TiB btrfs filesystem, to be able to do crazy things and tests before
really doing changes, like kernel version or things like converting to
the free space tree etc.

>From end 2014 to september 2016, we used the 3.16 LTS kernel from Debian
Jessie. Since september 2016, it's 4.7.5, after torturing it for two
weeks on such a clone, replaying the daily workload on it.

== What's not so great... Allocated but unused space... ==

Since the beginning it showed that the filesystem had a tendency to
accumulate allocated but unused space that didn't get reused again by
writes.

In the last months of using kernel 3.16 the situation worsened, ending
up with about 30% allocated but unused space (11TiB...), while the
filesystem kept allocating new space all the time instead of reusing it:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-backups-16-Q23.png

Using balance with the 3.16 kernel and space cache v1 to fight this was
almost not possible because of the amount of scattered out metadata
writes + amplification (1:40 overall read/write ratio during balance)
and writing space cache information over and over again on every commit.

When making the switch to the 4.7 kernel I also switched to the free
space tree, eliminating the space cache flush problems and did a
mega-balance operation which brought it back down quite a bit.

Here's what it looked like for the last 6 months:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-backups-16-Q4-17-Q1.png

This is not too bad, but also not good enough. I want my picture to
become brighter white than this:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-03-14-backups-heatmap-chunks.png

The picture shows that the unused space is scattered all around the
whole filesystem.

So about a month ago, I continued searching kernel code for the cause of
this behaviour. This is a fun, but time consuming and often mind
boggling activity, because you run into 10 different interesting things
at the same time and want to start to find out about all of them at the
same time etc. :D

The two first things I found out about were:
  1) the 'free space cluster' code, which is responsible to find empty
space that new writes can go into, sometimes by combining several free
space fragments that are close to each other.
  2) the bool fragmented, which causes a block group to get blacklisted
for any more writes because finding free space for a write did not
succeed too easily.

I haven't been able to find a concise description of how all of it
actually is supposed to work, so have to end up reverse engineering it
from code, comments and git history.

And, in practice the feeling was that btrfs doesn't really try that
hard, and quickly gives up and just starts allocating new chunks for
everything. So, maybe it was just listing all my block groups as
fragmented and ignoring them?

== Balance based on free space fragmentation level ==

Now, free space being fragmented when you have a high churn rate
snapshot create and expire workload is not a surprise... Also, when data
is added there is no way to predict if, and when it ever will be
unreferenced from the snapshots again, which means I really don't care
where it ends up on disk.

But how fragmented is the free space, and how can we measure it?

Three weeks ago I made up a free space 'scoring' algorithm, revised it a
few times and now I'm using it to feed block groups with bad free space
fragmentation to balance to clean up the filesystem a bit. But, this is
a fun story for a separate post. In short, take the log2() of the size
of a free space extent, and then punish it the hardest if it ends up in
the middle of log2(sectorsize) and log2(block_group.length) and less if
it's smaller or bigger.

It's still 'mopping with the tap open', like we say in the Netherlands.
But it's already much better than usage-based balance. If a block group
is used for 50% and it has 512 alternating 1MiB filled and free
segments, I want to get rid of it, but if it's 512MiB data and then
512MiB empty space, it has to stay.

== But... -o remount,nossd ==

About two weeks ago, I ran into this code, from extent-tree.c:

bool ssd = btrfs_test_opt(fs_info, SSD);
*empty_cluster = 0;
[...]
if (ssd)
    *empty_cluster = SZ_2M;
if (space_info->flags & BTRFS_BLOCK_GROUP_METADATA) {
    ret = &fs_info->meta_alloc_cluster;
    if (!ssd)
        *empty_cluster = SZ_64K;
} else if ((space_info->flags & BTRFS_BLOCK_GROUP_DATA) && ssd) {
    ret = &fs_info->data_alloc_cluster;
}
[...]

Wait, what? If I mount -o ssd, every small write will turn into at least
finding 2MiB for a write? What is this magic number?

Since the rotational flag in /sys is set to 0 for this filesystem, which
does not at all mean it's an ssd by the way, it mounts with the ssd
option by default. Since the lower layer of storage is iSCSI on NetApp,
it does not make any sense at all for btrfs to make assumptions about
where goes what or how optimal it is, as everything will be reorganized
anyway.

These two if statements is pretty much about it, what the ssd option
does. There's one other if, in tree-log.c, but t.. that's it folks.
The amount of lines of administration code for handling the mount
options itself is outnumbering the amount of lines where the option is
used by far. :D

Like the careful reader can see, the minimum amount of space used for
metadata writes also gets changed...

After playing around with -o nossd in a few other places, I finally did
it on this filesystem, first by a complete umount and mount, and then,
something magical happened:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-btrfs-nossd-whoa.gif
(timelapse of daily btrfs-heatmap --sort virtual)

After two weeks of creating new backups and feeding fragmented block
groups to balance, 25% of the filesystem consists of chunks that are
100% filled up. (:

== But! The Meta Mummy returns! ==

After changing to nossd, another thing happened. The expiry process,
which normally takes about 1.5 hour to remove ~2500 subvolumes (keeping
it queued up to a 100 orphans all the time), suddenly took the entire
rest of the day, not being done before the nightly backups had to start
again at 10PM...

And the only thing it seemed to do is writing, writing, writing 100MB/s
all day long. To see what it was doing I put some code together into
show_orphan_cleaner_progress.py:

https://github.com/knorrie/python-btrfs/commit/dd34044adf24f7febf6f6992f11966c9094c058b

The output showed it was just doing the normal expiry, but really really
slow. When changing back to -o ssd, it's back at normal speed.

Since the only thing that seems to change is a minimum of 64KiB instead
of 2MiB for metadata writes, I suspect the result of doing smaller
writes is an avalanche of write amplification, especially in the extent
tree. Since more small spots are filled, it causes more extent tree
pages to be cowed, which causes metadata writes, which need free space,
which cause changes in the extent tree, which causes more pages to be
cowed, which needs free space, which cause changes in the extent tree,
which...

Warning: do NOT click if you have epilepsy!
http://31.media.tumblr.com/3c316665d64ecd625eb3b6bc160f08fd/tumblr_mo73kigx0t1s92vobo1_250.gif
  Wheeeeeeeeeeee!

<to be continued>

== So, what do we want? ssd? nossd? ==

Well, both don't do it for me. I want my expensive NetApp disk space to
be filled up, without requiring me to clean up after it all the time
using painful balance actions and I want to quickly get rid of old
snapshots.

So currently, there's two mount -o remount statements before and after
doing the expiries...

== Ok, one more picture ==

Here's a picture of disk read/write throughput of yesterday:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-backups-diskstats_throughput-day.png

* The balance part is me feeding fragmented block groups to balance. And
yes, rewriting 1GiB of data requires writing about 40GiB of metadata. ! :(
* Backup 1 and 2 are the backups, rsync limited at 16MB/s incoming
remote network traffic, which ends up as 50MB/s writes including
metadata changes. :(
* Expire, which today took 2.5 hours, removing 4240 subvolumes (+14 days
and a lot +3 months)

While snapshot removal totally explodes with nossd, there seems to be
little impact on backups and balance... :?

== Work to do ==

The next big change on this system will be to move from the 4.7 kernel
to the 4.9 LTS kernel and Debian Stretch.

Note that our metadata is still DUP, and it doesn't have skinny extent
tree metadata yet. It was originally created with btrfs-progs 3.17, and
when we realized we should have single it was too late. I want to change
that and see if I can convert on a NetApp clone. This should reduce
extent tree metadata size by maybe more than 60% and whoknowswhat will
happen to the abhorrent write traffic.

This conversion can run on the clone, after removing as many subvolumes
as possible with the least amount of data going away.

Before switching over to the clone as live backup server, all missing
snapshots can be rsynced over from the live backup server.

== So ==

Thanks for reading. Now, feel free to ask me anything... :D ...or on IRC
of course.

Moo,

[1] http://tech.mendix.com/linux/2015/02/12/btrfs-dirvish/
-- 
Hans van Kranenburg,
Production Engineer at Mendix
