Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51849 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766Ab3BBQEC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Feb 2013 11:04:02 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id h5Tzbjf8fQfLQ0bI (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2013 09:04:01 -0700 (MST)
Date: Sat, 2 Feb 2013 11:02:12 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: experimental raid5/6 code in git
Message-ID: <20130202160212.GB4694@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've uploaded an experimental release of the raid5/6 support to git, in
branches named raid56-experimental.  This is based on David Woodhouse's
initial implementation (thanks Dave!).

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git raid56-experimental
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git raid56-experimental

These are working well for me, but I'm sure I've missed at least one or
two problems.  Most importantly, the kernel side of things can have
inconsistent parity if you crash or lower power.  I'm adding new code to
fix that right now, it's the big missing piece.

But, I wanted to give everyone the chance to test what I have while I'm
finishing off the last few details.  Also missing:

* Support for scrub repairing bad blocks.  This is not difficult, we
just need to make a way for scrub to lock stripes and rewrite the
whole stripe with proper parity.

* Support for discard.  The discard code needs to discard entire
stripes.

* Progs support for parity rebuild.  Missing drives upset the progs
today, but the kernel does rebuild parity properly.

* Planned support for N-way mirroring (triple mirror raid1) isn't
included yet.

With all those warnings out of the way, how does it work?  The
original plan was to base read/modify/write cycles at high levels in the
filesystem, so that we always gave full stripe writes down to raid56
layers.  But this had a few problems, especially when you start thinking
about converting from one stripe size to another.  It doesn't fit with
the delayed allocation model where we pick physical extents for a given
operation as late as we possibly can.

Instead I'm doing read/modify/write when we map bios down to the
individual drives.  This allows blocks from multiple files to share a
stripe, and it allows us to have metadata blocks smaller than a full
stripe.  That's important if you don't want to spin every disk for each
metadata read.

This does sound quite a lot like MD raid, and that's because it is.  By
doing the raid inside of Btrfs, we're able to use different raid levels
for metadata vs data, and we're able to force parity rebuilds when crcs
don't match.  Also management operations such as restriping and
adding/removing drives are able to hook into the filesystem
transactions.  Longer term we'll be able to skip reads on blocks that
aren't allocated and do other connections between raid56 and the FS
metadata.

I've spent a long time running different performance numbers, but there
are many benchmarks left to run.  The matrix of different configurations
is fairly large, with btrfs-raid56 vs MD-raid56 vs Btrfs-on-MD-raid56,
and then comparing all the basic workloads.  Before I dive into numbers,
I want to describe a few moving pieces.

Stripe cache -- This avoids read/modify/write cycles with an LRU of
recently written stripes.  Picture a database that does adjacent
synchronous 4K writes (say a log record and a commit block).  We want to
make sure we don't repeat read/modify/writes for the commit block after
writing the log block.

In btrfs the stripe cache changes because we're doing COW.  Hopefully we
are able to collect writes from multiple processes into a full stripe
and do fewer read/modify/write cycles.  But, we still need the cache.
The cache in btrfs defaults to 1024 stripes and can't (yet) be tuned.
In MD it can be tuned up to 32768 stripes.

In the btrfs code, the stripe cache is the director in a state machine
that pulls stripes from initial submission to completion.  It
coordinates merging stripes, parity rebuild and handing off the stripe
lock to the next bio.

Plugging -- The on stack plugging code has a slick way for anyone in the
IO stack to participate in plugging.  Btrfs is using this to collect
partial stripe writes in hopes of merging them into full stripes.  When
the kernel code unplugs, we sort, merge and fire off the IOs.  MD has a
plugging callback as well.

Parity calculations --  For full stripes, Btrfs does P/Q calculations
at IO submission time without handing off to helper threads.  The code
uses the synchronous xor/memcpy/raid6 lib apis.  For sub-stripe writes,
Btrfs kicks the work off to its own helper threads and uses the same
synchronous apis.  I'm definitely open to trying out the ioat code, but
so far I don't see the P/Q math as a real bottleneck.

Everyone who made it this far gets to see benchmarks!  I've run these on
two different systems.

1) A large HP DL380 with two sockets and 4TB of flash.  The
flash is spread over 4 drives and in a raid0 run it can do 5GB/s
streaming writes.  This machine has the IOAT async raid engine.

2) A smaller single socket box with 4 spindles and 2 fusionio drives.
No raid offload here.  This box can do 2.5GB/s streaming writes.

These are all on 3.7.0 with MD created with -c 64 and --assume-clean.
I upped the MD stripe cache to 32768, but didn't include Shaohua's
patches to parallelize the MD parity calculations.  I'll do those runs
after I have the next round of btrfs changes done.

Lets start with an easy benchmark:

machine #2 flash broken up into 8 logical volumes and then raid5
created on top (64K stripe size).  Single dd doing streaming full stripe
writes:

dd if=/dev/zero of=/mnt/oo bs=1344K oflag=direct count=4096

Btrfs -- 604MB/s
MD    -- 162MB/s

My guess is the performance difference here is coming from latencies
related to handing off parity to helpers.  Btrfs is doing everything
inline and MD is handing off.

fs/direct-io.c is sending down partial stripes (one IO per 64 pages),
but our plugging callbacks let us collect them.  Neither MD or Btrfs are
doing any reads here.

Now for something a little bigger:

machine #1 with all 4 drives configured in raid6.  This one is using fio
to do a streaming aio/dio write of large full stripes.  The numbers
below are from blktrace.  Since we're doing raid6 over 4 drives, half
our IO was for parity.  The actual tput seen by fio is 1/2 of this.

The MD runs are going directly to MD, no filesystem involved.

MD -- 800MB/s very little system time
http://masoncoding.com/mason/benchmark/btrfs-raid6/md-raid6-full-stripe-tput.png
http://masoncoding.com/mason/benchmark/btrfs-raid6/md-raid6-full-stripe-sys.png

Btrfs -- 3.8GB/s one CPU mostly pegged
http://masoncoding.com/mason/benchmark/btrfs-raid6/btrfs-full-stripe-tput.png
http://masoncoding.com/mason/benchmark/btrfs-raid6/btrfs-full-stripe-sys.png

That one CPU is handling interrupts for the flash.

I spent some time trying to figure out why MD was doing reads in this
run, but I wasn't able to nail it down.

Long story short, I spent a long time tuning for streaming writes on
flash.  MD isn't CPU bound in these runs, and latencytop shows it is
waiting for room in its stripe cache.

Ok, but what about read/modify/write?
Machine #2 with fio doing 32K writes onto raid5

Btrfs -- 380MB/s seen by fio
MD    -- 174MB/s seen by fio

http://masoncoding.com/mason/benchmark/btrfs-raid6/btrfs-32K-write-raid5-full.png
http://masoncoding.com/mason/benchmark/btrfs-raid6/md-raid5-32K.png

For the Btrfs run, I filled the disk with 8 files and then deleted one
of them.  The end result made it impossible for btrfs to ever allocate a
full stripe, even when it was doing COW.  So every 32K write triggered a
read/modify/write cycle.  MD was doing rmw on every IO as well.

It's interesting that MD is doing a 1:1 read/write while btrfs is doing
more reads than writes.  Some of that is metadata required for the IO.

How does Btrfs do at 32K sub stripe writes when the FS is empty?

http://masoncoding.com/mason/benchmark/btrfs-raid6/btrfs-32K-write-raid5-empty.png

COW lets us collect 32K writes from multiple procs into a full stripe,
so we can avoid the rmw cycle some of the time.  It's faster, but only
lasts while the space is free.

Metadata intensive workloads hit the read/modify/write code much harder,
and are even more latency sensitive than O_DIRECT.  To test this, I used
fs_mark, both on spindles and on flash.

The interesting thing is that on flash, MD was within 15% of the Btrfs
number.  The fs_mark run was actually CPU bound creating new files in
Btrfs, so once we used flash the storage wasn't the bottleneck any more.

Spindles looked a little different.  For these runs I tested btrfs on
top of MD vs btrfs raid5.

http://masoncoding.com/mason/benchmark/btrfs-raid5/btrfs-fsmark-md-raid5-spindle.png
http://masoncoding.com/mason/benchmark/btrfs-raid5/btrfs-fsmark-raid5-spindle.png

Creating 12 million files on Btrfs raid5 took 226 seconds, vs 485
seconds on MD.  In general MD is doing more reads for the same
workload.  I don't have a great explanation for this yet but the
Btrfs stripe cache may have a bigger window for merging concurrent IOs
into the same stripe.

Ok, that's enough for now, happy testing everyone.

-chris
