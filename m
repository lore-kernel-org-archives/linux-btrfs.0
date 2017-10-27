Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:39278 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752131AbdJ0VUR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 17:20:17 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 5EC2258696CD
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 23:20:16 +0200 (CEST)
Subject: Data and metadata extent allocators [2/2]: metadata!
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
Message-ID: <b94ce11f-18d3-3d99-ebfa-7dddd9f13d66@mendix.com>
Date: Fri, 27 Oct 2017 23:20:16 +0200
MIME-Version: 1.0
In-Reply-To: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, it's time to start looking at the other half of the story... The
behavior of the metadata extent allocator.

    Interesting questions here are:

Q: If I point btrfs balance at 1GiB of data, why does it need to write
40GiB to disk while only relocating this 1GiB amount? What's the other
39GiB of "ghost" data?

Q: If I'm running nightly backups, fetching changes from external
filesystems (rsync, not send/receive), why do I see an average amount of
writes of ~60MiB/s to disk while the incoming data stream is capped on
~16MiB/s?

Q: If I'm doing expiries (mass removal of subvolumes), why does my
filesystem write ~80MiB/s to disk for hours and hours and hours?

    tl;dr version:

* Excessive rumination in large extent tree
* I want an invalid combination of data / metadata extent allocators to
minimize extent tree writes
* I get the invalid combination thanks to a bug
* Profit
* I want to be able to do the same in a newer kernel

    Long version:

    July 2017 was the last time when I have been doing tests on a cloned
(on a lower layer, yay NetApp) btrfs filesystem with about 40TiB of
files and 90k subvolumes (with related data in groups of between 20 and
30 subvolumes each).

What I did was running a linux kernel with some modifications (yes, I
found out about the tracepoints a bit later) to count the amount of
metadata block cow operations that are done, per tree. By reading the
counters and graphing that data, it became very clear what happened when
writing that 39GiB of ghost data that I just talked about...

It's metadata, and it's the extent tree. Thousands of cow operations on
the extent tree per second, filling all write IO bandwidth (just 1Gb/s
iSCSI in this case, writing 80-100MiB/s) while the other trees are
relatively dead silent in comparison.

Q: Why does my extent tree cause so many writes to disk?
A: Because the extent tree is tracking the space used to store itself.

(Disclaimer: identifying these symptoms is not some kind of new amazing
discovery, it should be a well known thing for btrfs developers, but I'm
writing for the users like me who are looking at their running
filesystems, wondering what the hell the thing is are doing all the
time. Also, it's good to see at what size and complexity the practical
scalability limitations of this filesystem are seriously starting to get
in the way.)

Let's see what would happen (also a bit simplified, it's about the
general idea) in a worst case scenario, where every update of a metadata
item would cause cow of a metadata block:

  1. Write to a filesystem tree happens
  2. Filesystem metadata block gets cowed
  3. Write to the extent tree happens to add new fs tree block
  4. Extent tree block gets cowed for the write
  5. Write to the extent tree happens to track the new blocks location
  6. Extent tree block gets cowed for the write
  7. Write to the extent tree happens to track the new blocks location
  8. Extent tree block gets cowed for the write
  9. Write to the extent tree happens to track the new blocks location
  10. Extent tree block gets cowed for the write
  11. Write to the extent tree happens to track the new blocks location
  12. Extent tree block gets cowed for the write
  13. Write to the extent tree happens to track the new blocks location
  14. Extent tree block gets cowed for the write
  15. Write to the extent tree happens to track the new blocks location
  16. Extent tree block gets cowed for the write
  17. Write to the extent tree happens to track the new blocks location
  18. Extent tree block gets cowed for the write
  19. Write to the extent tree happens to track the new blocks location
  20. Extent tree block gets cowed for the write
  21. Write to the extent tree happens to track the new blocks location
  [...]

Yep, it's like a dog running in circles chasing its own tail.

(Side note: The "Snowball effect of wandering trees" still has to be
added on top of this, since cowing a metadata block also needs cow
operations of every block in the path up towards the top of the tree.
But, I'm ignoring that part now, since it's not causing the biggest
problems in my case.)

When would this ever stop? Well...
1. A metadata block gets cowed only once during a transaction. The
reason of the cow is to get a new block on disk later on a different
location while the previous one is also still on disk. All changes that
happen inside the memory during the transaction never reach the disk
individually, so there's no need to keep more copies in memory other
than the final one which will go to disk at the end of the transaction.
2. A single metadata block holds a whole bunch of metadata items, part
of a larger range. So, together with 1, if the changes happen near to
each other, they are all going into the same metadata block, and there
are less blocks to cow.

So, in reality, the recursive cowing in the extent tree (I'd like to
call it "rumination"...) will stop after a few extra chews.

As for point 2... If we try to keep all new writes of extent tree
metadata as close together as possible, we minimize the explosion of
rumination that's happening.

    Extent allocators...

As mentioned in the commit to change the data extent allocator behaviour
for 'ssd' mode [0]: "Recommendations for future development are to
reconsider the current oversimplified nossd / ssd distinction [...] and
provide experienced users with a more flexible way to choose allocator
behaviour for data and metadata"

Currently, the nossd / ssd / ssd_spread mount options are the only knobs
we can turn to change extent allocator choice in btrfs as a side effect.
When doing so, the behavior for data as well as metadata gets changed.

Here's the situation since 4.14:

        nossd         ssd           ssd_spread
------------------------------------------------
data    tetris        tetris        contiguous
meta    cluster(64k)  cluster(2M)   contiguous

Before 4.14, data+ssd is also cluster(2M)

* tetris means: just fill all space up with writes that fit, from the
beginning of the filesystem to the end.
* cluster(X) means: use the cluster system (of which the code still
mostly looks like black magic to me) and when doing writes, first
collect at least X amount of space together in free space extents that
are near each other, thus "clustering" writes together.
* contiguous means: when doing X writes, just put them into X free
space, and don't fragment the write over multiple locations.

    When switching from the ssd (which was automatically chosen for me
because btrfs thinks an iSCSI lun is an ssd) to nossd because of the
effect on data placement, the immediate new problem which surfaced was
that subvolume removals would take forever, while the filesystem was
just writing, writing and writing metadata to disk full speed all the
time. Expiries would not be finished before the next nightly backups, so
that situation was not acceptable.

When changing back to -o ssd, the situation would immediately improve
again. See [1] for an example... The simple reason for this was not that
there was more actual work to be done, it was that metadata writes would
end up in more different locations because of the smaller cluster size
parameter, and thus caused much longer ongoing rumination.

The pragmatic solution so far for this was to remount -o nossd, then do
the nightly backups, then remount -o ssd, then do the expiries etc... Yay...

    Flash forward to the beginning of October 2017 when I was
thinking... "what would happen when I was able to run data with the
tetris allocator and metadata with the contiguous allocator? That would
probably be better for my metadata..."

Thanks to a bug, solved in [2], it's actually possible to run exactly
this combination, just by mounting with -o ssd_spread,nossd. The nossd
option resets the ssd flag again, that was just before set by
ssd_spread, but it doesn't unset ssd_spread. Combine this result with
the exact checks that are done for flags in the code paths and voila.
So, in my 4.9 kernel I can still do this.

When, after testing the change was applied on the production system, the
immediate effect on the behavior was amazing. *poof* Bye bye metadata
writes.

During nightly backups, we now write around 25MiB/s for 16MiB/s incoming
data and all metadata administration that needs to happen. (small
changes are happening all over the place). With DUP metadata this means
overhead of about (25-16)/2 = 4.5MiB/s

For expiries... Removing an avg of 3000 subvolumes would take between 4
and 8 hours, writing 80-100MiB/s to disk all the time (~3500 iops). Now
with the contiguous allocator, it's 1 hour with ~30MiB/s writes (~750
iops), and the progress is suddenly limited by random write behaviour
while walking the trees to do the subvolume removals...

Roughly speaking this means writing 16 times less metadata to disk to do
the same thing. (!!)

Using btrfs balance for a filled 1GiB chunk with, say, 2000 data extents
changed from 10 minutes of looking at 80MiB/s metadata writes to doing
the same in just under a minute.

The obvious downside of using the 'contiguous' allocator is that the
exact same effect as we just prevented for data will again happen
here... When metadata gets cowed, the old 16kiB blocks are turned into
free space after the transaction finished. The effect is that the usage
of all exiting metadata chunks slowly decreases, while the free space is
not reused because it's happening all over the place. [3] is an example
of a metadata block 83% filled up two weeks after the switch. Allocated
space for metadata was exploding with about 5 to 10GiB extra per day.

So, the tradeoff for getting 16x less metadata writes in this case is
sacrificing more raw disk space to metadata. Right now, after a while,
the excessive new allocations have stopped since the gaps which have
dropped in existing chunks are becoming interestingly sized enough to be
chosen for new bulk writes.

It's like a child which never cleans up the toys he plays with, but just
throws them onto a big pile in the hallway instead of choosing an empty
spot in the closet to put every item back. At some point, enough
different toys are used to end up with a mostly empty closet, after
which we can simply take the whole pile of toys from the hallway and put
it inside again. :D

    So, to be continued... I'll try to produce a proposal with some
patches to introduce a different way to (individually) choose data and
metadata extent allocator, decoupling it from the current ssd related
options, since the whole concept of ssd doesn't have anything to do with
everything written above. Different combinations of allocators can be
better in different situations. Bundling writes together and doing 16x
less of them instead of doing random writes all over the place is e.g.
also something that a user of a large btrfs filesystem made from slower
rotating drives might prefer?

P.S. metadata on the big production filesystem is still DUP, since I
can't change that easily [4]. This also causes all metadata writes to
end up in the iSCSI write pipeline twice... Getting this fixed would
reduce the writes by another 50%.

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=583b723151794e2ff1691f1510b4e43710293875
[1]
https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-06-04-expire_ssd_nossd.png
[2] https://www.spinics.net/lists/linux-btrfs/msg64203.html
[3]
https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-10-27-metadata-ssd_spread.png
[4] https://www.spinics.net/lists/linux-btrfs/msg64771.html

---- >8 ----

Fun thing is, I'm not seeing any problem with cpu usage. It's perfectly
possible to have tens of thousands of subvolumes in a btrfs filesystem
without cpu usage problems. The real cpu trouble starts when there's
data with too many reflinks. For example, when doing deduplication, you
win some space, but if you're too greedy and dedupe the wrong things,
you have to pay the price of added metadata complexity and cpu usage.

With only groups of 20-30 subvolumes that reference each others data
(the 14 daily, 10 extra weekly and 9 extra monthly snapshots) there are
no cpu usage problems.

Actually... when having 40TiB of gazillions of files of all sizes, it's
much better to have a large amount of subvolumes instead of a small
amount, since it keeps the sizes of the subvolume fs trees down. Also,
sacrificing some space to actively prevent more file fragmentation and
reflinks by e.g. using rsync --whole-file helps.

-- 
Hans van Kranenburg
