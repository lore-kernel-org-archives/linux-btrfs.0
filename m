Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47830 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037845AbdDUK0W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 06:26:22 -0400
Received: from [IPv6:2001:828:13c8:10b::c] (blackbox.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 9B0E46003D
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 12:26:18 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Experiences with metadata balance/convert
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
Date: Fri, 21 Apr 2017 12:26:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a followup to my previous post "About free space fragmentation,
metadata write amplification and (no)ssd", exploring how good or bad
btrfs can handle filesystem that are larger than your average desktop
computer.

One of the things I'm looking at to do is to convert the metadata of a
large filesystem from DUP to single, because:
  1. in this particular situation the disk storage is considered
reliable enough to handle bitrot and failed disks itself.
  2. it would simply reduce metadata writes (the favourite thing this
filesystem wants to do all the time) with 50% already

So, I used the clone functionality of the underlying iSCSI target to get
a writable throw-away version of the filesystem to experiment with (great!).

== The starting point ==

Data, single: total=39.46TiB, used=35.63TiB
System, DUP: total=40.00MiB, used=6.23MiB
Metadata, DUP: total=454.50GiB, used=441.46GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

~90000 subvolumes, which are related to each other in groups of about 32
of them, no shared data extents between those groups.

That's around 900x a 512MiB metadata DUP block group, all >90% used.

I wrote a simple script to count the metadata types, here's the result,
sorted by tree and level (0 = leaf, > 0 are nodes)

-# ./show_metadata_tree_sizes.py /srv/backup/
ROOT_TREE          68.11MiB 0(  4346) 1(    12) 2(     1)
EXTENT_TREE        14.63GiB 0(955530) 1(  3572) 2(    16) 3(     1)
CHUNK_TREE          6.17MiB 0(   394) 1(     1)
DEV_TREE            3.50MiB 0(   223) 1(     1)
FS_TREE           382.63GiB 0(24806886) 1(250284) 2( 18258) 3(   331)
CSUM_TREE          41.98GiB 0(2741020) 1(  9930) 2(    45) 3(     1)
QUOTA_TREE            0.00B
UUID_TREE           3.28MiB 0(   209) 1(     1)
FREE_SPACE_TREE    79.31MiB 0(  5063) 1(    12) 2(     1)
DATA_RELOC_TREE    16.00KiB 0(     1)

FS_TREE counts tree 5 and all other subvolumes together.

Kernel: Linux 4.9.18 (Debian)
Progs: 4.9.1 (Debian)

== Test 1: Just trying it ==

So, let's just do a
  btrfs balance start -f -mconvert=single /srv/backup

The result:
 * One by one the metadata block groups are emptied, from highest vaddr
to lowest vaddr.
 * For each 512MiB that is removed, a new 1024MiB block group is
forcibly added.
 * For each 512MiB, it takes on average 3 hours to empty it, during
which the filesystem is writing metadata at 100MiB/s to disk. That
means, to move 512MiB to another place, it needs to write a bit more
than *1TiB* to disk (3*3600*100MiB). And, it seems to be touching almost
all of the 900 metadata block groups on every committed transaction.
 * Instead of moving the metadata to the single type block group, it
seems to prefer to keep messing around in the DUP block groups all the
time as long as there's any free space to be found in them.

I let it run for a day, and then stopped it. So, when naively
extrapolating this, when running at full speed, doing nothing else, this
would take 112.5 days, while writing a Petabyte of metadata to disk.

Hmm...

== Test 2: Does reducing metadata size help? ==

Another thing I tried is to see what the effect of removing a lot of
subvolumes is. I simply ran the backup-expiries for everything that
would expire in the next two weeks (which is at least all daily backup
snapshots, which are kept for 14 days by default).

After that:

Data, single: total=38.62TiB, used=30.15TiB
System, DUP: total=40.00MiB, used=6.16MiB
Metadata, DUP: total=454.00GiB, used=391.78GiB
GlobalReserve, single: total=512.00MiB, used=265.62MiB

About 54000 subvolumes left now.

Hmmzzz... FS trees reduced from ~380 to ~340 GiB... not spectacular.

ROOT_TREE          48.05MiB 0(  3064) 1(    10) 2(     1)
EXTENT_TREE        14.41GiB 0(940473) 1(  3559) 2(    16) 3(     1)
CHUNK_TREE          6.16MiB 0(   393) 1(     1)
DEV_TREE            3.50MiB 0(   223) 1(     1)
FS_TREE           339.80GiB 0(22072422) 1(183505) 2( 12821) 3(   272)
CSUM_TREE          37.33GiB 0(2437006) 1(  9519) 2(    44) 3(     1)
QUOTA_TREE            0.00B
UUID_TREE           3.25MiB 0(   207) 1(     1)
FREE_SPACE_TREE   119.44MiB 0(  7619) 1(    24) 2(     1)
DATA_RELOC_TREE    16.00KiB 0(     1)

Now trying it again:
  btrfs balance start -f -mconvert=single /srv/backup

The result:
 * For each 512MiB, it takes on average 1 hour, writing 100MiB/s to disk
 * Almost all metadata is rewritten into existing DUP chunks (!!), since
there's more room in there now because of reducing total metadata amount.
 * For the little bit of data written to the new single chunks (which
have twice the amount of space in total in them, because every 512MiB is
traded for a new 1024MiB...) it shows a somewhat interesting pattern:

vaddr            length   flags          used           used_pct
[.. many more above here ..]
v 87196153413632 l 512MiB f METADATA|DUP used 379338752 pct 71
v 87784027062272 l 512MiB f METADATA|DUP used 351125504 pct 65
v 87784563933184 l 512MiB f METADATA|DUP used 365297664 pct 68
v 87901064921088 l 512MiB f METADATA|DUP used 403718144 pct 75
v 87901601792000 l 512MiB f METADATA|DUP used 373047296 pct 69
v 87969784397824 l 512MiB f METADATA|DUP used 376979456 pct 70
v 87971395010560 l 512MiB f METADATA|DUP used 398917632 pct 74
v 87971931881472 l 512MiB f METADATA|DUP used 391757824 pct 73
v 88126013833216 l 512MiB f METADATA|DUP used 426967040 pct 80
v 88172721602560 l 512MiB f METADATA|DUP used 418840576 pct 78
v 88186143375360 l 512MiB f METADATA|DUP used 422821888 pct 79
v 88187753988096 l 512MiB f METADATA|DUP used 395575296 pct 74
v 88190438342656 l 512MiB f METADATA|DUP used 388841472 pct 72
v 88545310015488 l 512MiB f METADATA|DUP used 347045888 pct 65
v 88545846886400 l 512MiB f METADATA|DUP used 318111744 pct 59
v 88546383757312 l 512MiB f METADATA|DUP used 101662720 pct 19
v 89532615622656 l 1GiB f METADATA used 150994944 pct 14
v 89533689364480 l 1GiB f METADATA used 150716416 pct 14
v 89534763106304 l 1GiB f METADATA used 144375808 pct 13
v 89535836848128 l 1GiB f METADATA used 140738560 pct 13
v 89536910589952 l 1GiB f METADATA used 144637952 pct 13
v 89537984331776 l 1GiB f METADATA used 153124864 pct 14
v 89539058073600 l 1GiB f METADATA used 127434752 pct 12
v 89540131815424 l 1GiB f METADATA used 113655808 pct 11
v 89541205557248 l 1GiB f METADATA used 99450880 pct 9
v 89542279299072 l 1GiB f METADATA used 90652672 pct 8
v 89543353040896 l 1GiB f METADATA used 78725120 pct 7
v 89544426782720 l 1GiB f METADATA used 74186752 pct 7
v 89545500524544 l 1GiB f METADATA used 65175552 pct 6
v 89546574266368 l 1GiB f METADATA used 47136768 pct 4
v 89547648008192 l 1GiB f METADATA used 30965760 pct 3
v 89548721750016 l 1GiB f METADATA used 15187968 pct 1

So, it's 3 times faster per blockgroup, but it will only do more work
over and over again, leading to a 900 + 899 + 898 + 897 + ... etc
pattern of the amount of work it seems.

Still doesn't sound encouraging.

== Intermezzo: endless btrfs_merge_delayed_refs ==

Test 3: What happens when starting at the lower vaddr?

This test is mainly to just try things and find out what happens.

I tried to feed the metadata blockgroup with the lowest vaddr to balance:
  btrfs balance start -f -mconvert=single,soft,vrange=29360128..29360129
/srv/backup

When doing so, the filesystem immediately ends up using 100% kernel cpu,
does not read or write from disk anymore.

After letting it running for two hours, there's no change. These two
processes are just doing 100% cpu, showing the following stack traces
(which do not change over time) in /proc/<pid>/stack:

kworker/u20:3

[<ffffffffc00caa74>] btrfs_insert_empty_items+0x94/0xc0 [btrfs]
[<ffffffff815fc689>] error_exit+0x9/0x20
[<ffffffffc01426fe>] btrfs_merge_delayed_refs+0xee/0x570 [btrfs]
[<ffffffffc00d5ded>] __btrfs_run_delayed_refs+0xad/0x13a0 [btrfs]
[<ffffffff810abdb1>] update_curr+0xe1/0x160
[<ffffffff811e02dc>] kmem_cache_alloc+0xbc/0x520
[<ffffffff810aabc4>] account_entity_dequeue+0xa4/0xc0
[<ffffffffc00da07d>] btrfs_run_delayed_refs+0x9d/0x2b0 [btrfs]
[<ffffffffc00da319>] delayed_ref_async_start+0x89/0xa0 [btrfs]
[<ffffffffc0124fff>] btrfs_scrubparity_helper+0xcf/0x2d0 [btrfs]
[<ffffffff81090384>] process_one_work+0x184/0x410
[<ffffffff8109065d>] worker_thread+0x4d/0x480
[<ffffffff81090610>] process_one_work+0x410/0x410
[<ffffffff81090610>] process_one_work+0x410/0x410
[<ffffffff8107bb0a>] do_group_exit+0x3a/0xa0
[<ffffffff810965ce>] kthread+0xce/0xf0
[<ffffffff81024701>] __switch_to+0x2c1/0x6c0
[<ffffffff81096500>] kthread_park+0x60/0x60
[<ffffffff815fb2f5>] ret_from_fork+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

btrfs-transacti

[<ffffffff815fc689>] error_exit+0x9/0x20
[<ffffffffc01426fe>] btrfs_merge_delayed_refs+0xee/0x570 [btrfs]
[<ffffffffc01426a5>] btrfs_merge_delayed_refs+0x95/0x570 [btrfs]
[<ffffffffc00d5ded>] __btrfs_run_delayed_refs+0xad/0x13a0 [btrfs]
[<ffffffff8109d94d>] finish_task_switch+0x7d/0x1f0
[<ffffffffc00da07d>] btrfs_run_delayed_refs+0x9d/0x2b0 [btrfs]
[<ffffffff8107bb0a>] do_group_exit+0x3a/0xa0
[<ffffffffc00f0b10>] btrfs_commit_transaction+0x40/0xa10 [btrfs]
[<ffffffffc00f1576>] start_transaction+0x96/0x480 [btrfs]
[<ffffffffc00eb9ac>] transaction_kthread+0x1dc/0x200 [btrfs]
[<ffffffffc00eb7d0>] btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[<ffffffff810965ce>] kthread+0xce/0xf0
[<ffffffff81024701>] __switch_to+0x2c1/0x6c0
[<ffffffff81096500>] kthread_park+0x60/0x60
[<ffffffff815fb2f5>] ret_from_fork+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

== Considering the options ==

Well, this all doesn't look good, that's for sure.

Especially the tendency to empty DUP block groups into other DUP block
groups, which need to be removed later again, instead of single ones
when converting it a bit sad.

== Thinking out of the box ==

Technically, converting from DUP to single could also mean:
* Flipping one bit in the block group type flags to 0 for each block
group item
* Flipping one bit in the chunk type flags and removing 1 stripe struct
for each metadata chunk item
* Removing the
* Anything else?

How feasible would it be to write btrfs-progs style conversion to do this?

-- 
Hans van Kranenburg
