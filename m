Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5003CD8CB;
	Mon, 20 Apr 2026 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691755; cv=none; b=o/Pa6sRW36ny59Hze/SdHgmOuov7rQBTxuvIe4XhTw5ol+CnW0667KRr2e/AVR/eaDqA28Nt2ujkuXAP9ZxUd4JXAZ93dbcncUGfMf4+KmwdoM44a58ssHip8a7im2g2Oc+F7xrUfwAHw9b8qnf6daZ6TJGV3WEIc1ow7LatXzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691755; c=relaxed/simple;
	bh=QzT6nGzD2mHrhZRygH74oxto7ZirKjowpXMtG/Nuqqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gXLiOdGzaiUlCMgLiyP4EyzTTJRdxg3UrTN6mRmqdw0GP4PehUx9EdLtVORRwROGa8W1q0/RHWsYc+9ZNJMwOWArBhesiygfyOe6980cbvlQS0Um+I1xU7NfumCNL2gttFTPrue5sxm4ToR5vM0OAmc0Yif0pnWxFw8E7qkMLx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0+GtTe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0+GtTe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BD8C2BCC4;
	Mon, 20 Apr 2026 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691755;
	bh=QzT6nGzD2mHrhZRygH74oxto7ZirKjowpXMtG/Nuqqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0+GtTe3Rwzl7CryvyMT0iqYNtWhboV635x7F+pgQegLCuAlGVxRBvPzkDpkpk26Z
	 5A3NdJUTAMLwrgBVxPBi74tJTnF0E+T0ekSkZkIhD50N85wd/0sfZAeLCeRMmMJyni
	 lkqrDHwWgg2Tmehyi/tKRbC/rWCQDNZpMAfhJZfWdP1u9B1mqTmOlhrn6aoR5rttTq
	 Jn7edyQCEA0OqcOo9o/smg3Wta/OIK9ngc9p7vBZK7XJBloXbSrdx6ycvaVv0mLxKD
	 QFLLjQ7JN7TN6aVRR2gTEpOAXrc4nzYUFYTMIzQeAWfpoDbd1BJr1cR9CX42Dlnwc1
	 Gba4LRBGXzabw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Aleksandar Gerasimovski <Aleksandar.Gerasimovski@belden.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] btrfs: be less aggressive with metadata overcommit when we can do full flushing
Date: Mon, 20 Apr 2026 09:19:28 -0400
Message-ID: <20260420132314.1023554-174-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 574d93fc62e2b03ab39c8f92fb44ded89ca6274d ]

Over the years we often get reports of some -ENOSPC failure while updating
metadata that leads to a transaction abort. I have seen this happen for
filesystems of all sizes and with workloads that are very user/customer
specific and unable to reproduce, but Aleksandar recently reported a
simple way to reproduce this with a 1G filesystem and using the bonnie++
benchmark tool. The following test script reproduces the failure:

    $ cat test.sh
    #!/bin/bash

    # Create and use a 1G null block device, memory backed, otherwise
    # the test takes a very long time.
    modprobe null_blk nr_devices="0"
    null_dev="/sys/kernel/config/nullb/nullb0"
    mkdir "$null_dev"
    size=$((1 * 1024)) # in MB
    echo 2 > "$null_dev/submit_queues"
    echo "$size" > "$null_dev/size"
    echo 1 > "$null_dev/memory_backed"
    echo 1 > "$null_dev/discard"
    echo 1 > "$null_dev/power"

    DEV=/dev/nullb0
    MNT=/mnt/nullb0

    mkfs.btrfs -f $DEV
    mount $DEV $MNT

    mkdir $MNT/test/
    bonnie++ -d $MNT/test/ -m BTRFS -u 0 -s 256M -r 128M -b

    umount $MNT

    echo 0 > "$null_dev/power"
    rmdir "$null_dev"

When running this bonnie++ fails in the phase where it deletes test
directories and files:

    $ ./test.sh
    (...)
    Using uid:0, gid:0.
    Writing a byte at a time...done
    Writing intelligently...done
    Rewriting...done
    Reading a byte at a time...done
    Reading intelligently...done
    start 'em...done...done...done...done...done...
    Create files in sequential order...done.
    Stat files in sequential order...done.
    Delete files in sequential order...done.
    Create files in random order...done.
    Stat files in random order...done.
    Delete files in random order...Can't sync directory, turning off dir-sync.
    Can't delete file 9Bq7sr0000000338
    Cleaning up test directory after error.
    Bonnie: drastic I/O error (rmdir): Read-only file system

And in the syslog/dmesg we can see the following transaction abort trace:

    [161915.501506] BTRFS warning (device nullb0): Skipping commit of aborted transaction.
    [161915.502983] ------------[ cut here ]------------
    [161915.503832] BTRFS: Transaction aborted (error -28)
    [161915.504748] WARNING: fs/btrfs/transaction.c:2045 at btrfs_commit_transaction+0xa21/0xd30 [btrfs], CPU#11: bonnie++/3377975
    [161915.506786] Modules linked in: btrfs dm_zero dm_snapshot (...)
    [161915.518759] CPU: 11 UID: 0 PID: 3377975 Comm: bonnie++ Tainted: G        W           6.19.0-rc7-btrfs-next-224+ #4 PREEMPT(full)
    [161915.520857] Tainted: [W]=WARN
    [161915.521405] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
    [161915.523414] RIP: 0010:btrfs_commit_transaction+0xa24/0xd30 [btrfs]
    [161915.524630] Code: 48 8b 7c 24 (...)
    [161915.526982] RSP: 0018:ffffd3fe8206fda8 EFLAGS: 00010292
    [161915.527707] RAX: 0000000000000002 RBX: ffff8f4886d3c000 RCX: 0000000000000000
    [161915.528723] RDX: 0000000002040001 RSI: 00000000ffffffe4 RDI: ffffffffc088f780
    [161915.529691] RBP: ffff8f4f5adae7e0 R08: 0000000000000000 R09: ffffd3fe8206fb90
    [161915.530842] R10: ffff8f4f9c1fffa8 R11: 0000000000000003 R12: 00000000ffffffe4
    [161915.532027] R13: ffff8f4ef2cf2400 R14: ffff8f4f5adae708 R15: ffff8f4f62d18000
    [161915.533229] FS:  00007ff93112a780(0000) GS:ffff8f4ff63ee000(0000) knlGS:0000000000000000
    [161915.534611] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [161915.535575] CR2: 00005571b3072000 CR3: 0000000176080005 CR4: 0000000000370ef0
    [161915.536758] Call Trace:
    [161915.537185]  <TASK>
    [161915.537575]  btrfs_sync_file+0x431/0x530 [btrfs]
    [161915.538473]  do_fsync+0x39/0x80
    [161915.539042]  __x64_sys_fsync+0xf/0x20
    [161915.539750]  do_syscall_64+0x50/0xf20
    [161915.540396]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
    [161915.541301] RIP: 0033:0x7ff930ca49ee
    [161915.541904] Code: 08 0f 85 f5 (...)
    [161915.544830] RSP: 002b:00007ffd94291f38 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
    [161915.546152] RAX: ffffffffffffffda RBX: 00007ff93112a780 RCX: 00007ff930ca49ee
    [161915.547263] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
    [161915.548383] RBP: 0000000000000dab R08: 0000000000000000 R09: 0000000000000000
    [161915.549853] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd94291fb0
    [161915.551196] R13: 00007ffd94292350 R14: 0000000000000001 R15: 00007ffd94292340
    [161915.552161]  </TASK>
    [161915.552457] ---[ end trace 0000000000000000 ]---
    [161915.553232] BTRFS info (device nullb0 state A): dumping space info:
    [161915.553236] BTRFS info (device nullb0 state A): space_info DATA (sub-group id 0) has 12582912 free, is not full
    [161915.553239] BTRFS info (device nullb0 state A): space_info total=12582912, used=0, pinned=0, reserved=0, may_use=0, readonly=0 zone_unusable=0
    [161915.553243] BTRFS info (device nullb0 state A): space_info METADATA (sub-group id 0) has -5767168 free, is full
    [161915.553245] BTRFS info (device nullb0 state A): space_info total=53673984, used=6635520, pinned=46956544, reserved=16384, may_use=5767168, readonly=65536 zone_unusable=0
    [161915.553251] BTRFS info (device nullb0 state A): space_info SYSTEM (sub-group id 0) has 8355840 free, is not full
    [161915.553254] BTRFS info (device nullb0 state A): space_info total=8388608, used=16384, pinned=16384, reserved=0, may_use=0, readonly=0 zone_unusable=0
    [161915.553257] BTRFS info (device nullb0 state A): global_block_rsv: size 5767168 reserved 5767168
    [161915.553261] BTRFS info (device nullb0 state A): trans_block_rsv: size 0 reserved 0
    [161915.553263] BTRFS info (device nullb0 state A): chunk_block_rsv: size 0 reserved 0
    [161915.553265] BTRFS info (device nullb0 state A): remap_block_rsv: size 0 reserved 0
    [161915.553268] BTRFS info (device nullb0 state A): delayed_block_rsv: size 0 reserved 0
    [161915.553270] BTRFS info (device nullb0 state A): delayed_refs_rsv: size 0 reserved 0
    [161915.553272] BTRFS: error (device nullb0 state A) in cleanup_transaction:2045: errno=-28 No space left
    [161915.554463] BTRFS info (device nullb0 state EA): forced readonly

The problem is that we allow for a very aggressive metadata overcommit,
about 1/8th of the currently available space, even when the task
attempting the reservation allows for full flushing. Over time this allows
more and more tasks to overcommit without getting a transaction commit to
release pinned extents, joining the same transaction and eventually lead
to the transaction abort when attempting some tree update, as the extent
allocator is not able to find any available metadata extent and it's not
able to allocate a new metadata block group either (not enough unallocated
space for that).

Fix this by allowing the overcommit to be up to 1/64th of the available
(unallocated) space instead and for that limit to apply to both types of
full flushing, BTRFS_RESERVE_FLUSH_ALL and BTRFS_RESERVE_FLUSH_ALL_STEAL.
This way we get more frequent transaction commits to release pinned
extents in case our caller is in a context where full flushing is allowed.

Note that the space infos dump in the dmesg/syslog right after the
transaction abort give the wrong idea that we have plenty of unallocated
space when the abort happened. During the bonnie++ workload we had a
metadata chunk allocation attempt and it failed with -ENOSPC because at
that time we had a bunch of data block groups allocated, which then became
empty and got deleted by the cleaner kthread after the metadata chunk
allocation failed with -ENOSPC and before the transaction abort happened
and dumped the space infos.

The custom tracing (some trace_printk() calls spread in strategic places)
used to check that:

  mount-1793735 [011] ...1. 28877.261096: btrfs_add_bg_to_space_info: added bg offset 13631488 length 8388608 flags 1 to space_info->flags 1 total_bytes 8388608 bytes_used 0 bytes_may_use 0
  mount-1793735 [011] ...1. 28877.261098: btrfs_add_bg_to_space_info: added bg offset 22020096 length 8388608 flags 34 to space_info->flags 2 total_bytes 8388608 bytes_used 16384 bytes_may_use 0
  mount-1793735 [011] ...1. 28877.261100: btrfs_add_bg_to_space_info: added bg offset 30408704 length 53673984 flags 36 to space_info->flags 4 total_bytes 53673984 bytes_used 131072 bytes_may_use 0

These are from loading the block groups created by mkfs during mount.

Then when bonnie++ starts doing its thing:

  kworker/u48:5-1792004 [011] ..... 28886.122050: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  kworker/u48:5-1792004 [011] ..... 28886.122053: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 927596544
  kworker/u48:5-1792004 [011] ..... 28886.122055: btrfs_make_block_group: make bg offset 84082688 size 117440512 type 1
  kworker/u48:5-1792004 [011] ...1. 28886.122064: btrfs_add_bg_to_space_info: added bg offset 84082688 length 117440512 flags 1 to space_info->flags 1 total_bytes 125829120 bytes_used 0 bytes_may_use 5251072

First allocation of a data block group of 112M.

  kworker/u48:5-1792004 [011] ..... 28886.192408: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  kworker/u48:5-1792004 [011] ..... 28886.192413: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 810156032
  kworker/u48:5-1792004 [011] ..... 28886.192415: btrfs_make_block_group: make bg offset 201523200 size 117440512 type 1
  kworker/u48:5-1792004 [011] ...1. 28886.192425: btrfs_add_bg_to_space_info: added bg offset 201523200 length 117440512 flags 1 to space_info->flags 1 total_bytes 243269632 bytes_used 0 bytes_may_use 122691584

Another 112M data block group allocated.

  kworker/u48:5-1792004 [011] ..... 28886.260935: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  kworker/u48:5-1792004 [011] ..... 28886.260941: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 692715520
  kworker/u48:5-1792004 [011] ..... 28886.260943: btrfs_make_block_group: make bg offset 318963712 size 117440512 type 1
  kworker/u48:5-1792004 [011] ...1. 28886.260954: btrfs_add_bg_to_space_info: added bg offset 318963712 length 117440512 flags 1 to space_info->flags 1 total_bytes 360710144 bytes_used 0 bytes_may_use 240132096

Yet another one.

  bonnie++-1793755 [010] ..... 28886.280407: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  bonnie++-1793755 [010] ..... 28886.280412: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 575275008
  bonnie++-1793755 [010] ..... 28886.280414: btrfs_make_block_group: make bg offset 436404224 size 117440512 type 1
  bonnie++-1793755 [010] ...1. 28886.280419: btrfs_add_bg_to_space_info: added bg offset 436404224 length 117440512 flags 1 to space_info->flags 1 total_bytes 478150656 bytes_used 0 bytes_may_use 268435456

One more.

  kworker/u48:5-1792004 [011] ..... 28886.566233: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  kworker/u48:5-1792004 [011] ..... 28886.566238: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 457834496
  kworker/u48:5-1792004 [011] ..... 28886.566241: btrfs_make_block_group: make bg offset 553844736 size 117440512 type 1
  kworker/u48:5-1792004 [011] ...1. 28886.566250: btrfs_add_bg_to_space_info: added bg offset 553844736 length 117440512 flags 1 to space_info->flags 1 total_bytes 595591168 bytes_used 268435456 bytes_may_use 209723392

Another one.

  bonnie++-1793755 [009] ..... 28886.613446: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  bonnie++-1793755 [009] ..... 28886.613451: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 340393984
  bonnie++-1793755 [009] ..... 28886.613453: btrfs_make_block_group: make bg offset 671285248 size 117440512 type 1
  bonnie++-1793755 [009] ...1. 28886.613458: btrfs_add_bg_to_space_info: added bg offset 671285248 length 117440512 flags 1 to space_info->flags 1 total_bytes 713031680 bytes_used 268435456 bytes_may_use 2 68435456

Another one.

  bonnie++-1793755 [009] ..... 28886.674953: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  bonnie++-1793755 [009] ..... 28886.674957: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 222953472
  bonnie++-1793755 [009] ..... 28886.674959: btrfs_make_block_group: make bg offset 788725760 size 117440512 type 1
  bonnie++-1793755 [009] ...1. 28886.674963: btrfs_add_bg_to_space_info: added bg offset 788725760 length 117440512 flags 1 to space_info->flags 1 total_bytes 830472192 bytes_used 268435456 bytes_may_use 1 34217728

Another one.

  bonnie++-1793755 [009] ..... 28886.674981: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  bonnie++-1793755 [009] ..... 28886.674982: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 105512960
  bonnie++-1793755 [009] ..... 28886.674983: btrfs_make_block_group: make bg offset 906166272 size 105512960 type 1
  bonnie++-1793755 [009] ...1. 28886.674984: btrfs_add_bg_to_space_info: added bg offset 906166272 length 105512960 flags 1 to space_info->flags 1 total_bytes 935985152 bytes_used 268435456 bytes_may_use 67108864

Another one, but a bit smaller (~100.6M) since we now have less space.

  bonnie++-1793758 [009] ..... 28891.962096: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 65536 dev_extent_want 1073741824
  bonnie++-1793758 [009] ..... 28891.962103: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 65536 dev_extent_want 1073741824 max_avail 12582912
  bonnie++-1793758 [009] ..... 28891.962105: btrfs_make_block_group: make bg offset 1011679232 size 12582912 type 1
  bonnie++-1793758 [009] ...1. 28891.962114: btrfs_add_bg_to_space_info: added bg offset 1011679232 length 12582912 flags 1 to space_info->flags 1 total_bytes 948568064 bytes_used 268435456 bytes_may_use 8192

Another one, this one even smaller (12M).

  kworker/u48:5-1792004 [011] ..... 28892.112802: btrfs_chunk_alloc: enter first metadata chunk alloc attempt
  kworker/u48:5-1792004 [011] ..... 28892.112805: btrfs_create_chunk: gather_device_info 1 ctl->dev_extent_min = 131072 dev_extent_want 536870912
  kworker/u48:5-1792004 [011] ..... 28892.112806: btrfs_create_chunk: gather_device_info 2 ctl->dev_extent_min = 131072 dev_extent_want 536870912 max_avail 0

536870912 is 512M, the standard 256M metadata chunk size times 2 because
of the DUP profile for metadata.
'max_avail' is what find_free_dev_extent() returns to us in
gather_device_info().

As a result, gather_device_info() sets ctl->ndevs to 0, making
decide_stripe_size() fail with -ENOSPC, and therefore metadata chunk
allocation fails while we are attempting to run delayed items during
the transaction commit.

  kworker/u48:5-1792004 [011] ..... 28892.112807: btrfs_create_chunk: decide_stripe_size fail -ENOSPC

In the syslog/dmesg pasted above, which happened after the transaction was
aborted, the space info dumps did not account for all these data block
groups that were allocated during bonnie++'s workload. And that is because
after the metadata chunk allocation failed with -ENOSPC and before the
transaction abort happened, most of the data block groups had become empty
and got deleted by by the cleaner kthread - when the abort happened, we
had bonnie++ in the middle of deleting the files it created.

But dumping the space infos right after the metadata chunk allocation fails
by adding a call to btrfs_dump_space_info_for_trans_abort() in
decide_stripe_size() when it returns -ENOSPC, we get:

  [29972.409295] BTRFS info (device nullb0): dumping space info:
  [29972.409300] BTRFS info (device nullb0): space_info DATA (sub-group id 0) has 673341440 free, is not full
  [29972.409303] BTRFS info (device nullb0): space_info total=948568064, used=0, pinned=275226624, reserved=0, may_use=0, readonly=0 zone_unusable=0
  [29972.409305] BTRFS info (device nullb0): space_info METADATA (sub-group id 0) has 3915776 free, is not full
  [29972.409306] BTRFS info (device nullb0): space_info total=53673984, used=163840, pinned=42827776, reserved=147456, may_use=6553600, readonly=65536 zone_unusable=0
  [29972.409308] BTRFS info (device nullb0): space_info SYSTEM (sub-group id 0) has 7979008 free, is not full
  [29972.409310] BTRFS info (device nullb0): space_info total=8388608, used=16384, pinned=0, reserved=0, may_use=393216, readonly=0 zone_unusable=0
  [29972.409311] BTRFS info (device nullb0): global_block_rsv: size 5767168 reserved 5767168
  [29972.409313] BTRFS info (device nullb0): trans_block_rsv: size 0 reserved 0
  [29972.409314] BTRFS info (device nullb0): chunk_block_rsv: size 393216 reserved 393216
  [29972.409315] BTRFS info (device nullb0): remap_block_rsv: size 0 reserved 0
  [29972.409316] BTRFS info (device nullb0): delayed_block_rsv: size 0 reserved 0

So here we see there's ~904.6M of data space, ~51.2M of metadata space and
8M of system space, making a total of 963.8M.

Reported-by: Aleksandar Gerasimovski <Aleksandar.Gerasimovski@belden.com>
Link: https://lore.kernel.org/linux-btrfs/SA1PR18MB56922F690C5EC2D85371408B998FA@SA1PR18MB5692.namprd18.prod.outlook.com/
Link: https://lore.kernel.org/linux-btrfs/CAL3q7H61vZ3_+eqJ1A9po2WcgNJJjUu9MJQoYB2oDSAAecHaug@mail.gmail.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have enough information for a thorough analysis. Let me compile my
findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem prefix:** `btrfs`
- **Action verb:** "be less aggressive" (behavioral adjustment)
- **Summary:** Reduce metadata overcommit aggressiveness when full
  flushing is possible, to avoid -ENOSPC transaction aborts.
- Record: [btrfs] [behavioral fix] [reduce overcommit to prevent
  transaction abort -ENOSPC]

### Step 1.2: Tags
- **Reported-by:** Aleksandar Gerasimovski (user report with a
  reproducible test case)
- **Link 1:** lore bug report thread
- **Link 2:** lore follow-up discussion
- **Reviewed-by:** Qu Wenruo (core btrfs developer)
- **Signed-off-by:** Filipe Manana (author, prominent btrfs developer),
  David Sterba (btrfs maintainer)
- No Fixes: tag (expected for candidates under review)
- No Cc: stable (expected)
- Record: User-reported with reproduction steps, reviewed by a key btrfs
  developer, signed-off by the btrfs maintainer.

### Step 1.3: Commit Body Analysis
The commit describes a transaction abort with -ENOSPC (error -28) during
bonnie++ workload on a 1G filesystem. The abort forces the filesystem
read-only. The detailed trace shows `btrfs_commit_transaction` aborting
at line 2045 with the call path `btrfs_sync_file -> do_fsync ->
__x64_sys_fsync`. The author explains that the overly generous 1/8
overcommit allows too many tasks to overcommit without triggering
transaction commits that would release pinned extents, eventually
leading to metadata exhaustion and transaction abort. Includes custom
tracing evidence of block group allocation behavior leading up to the
failure.

- Record: Real bug manifesting as filesystem going read-only
  (transaction abort with -ENOSPC) during normal workload on small
  filesystem. Root cause: too-aggressive metadata overcommit allows too
  many tasks to bypass flushing, resulting in no free metadata extents
  and no unallocated space for new metadata chunks.

### Step 1.4: Hidden Bug Fix Detection
This is not a hidden fix - it is clearly described as fixing a
transaction abort bug. The words "Fix this by" are explicitly used.
Record: This IS a direct bug fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** `fs/btrfs/space-info.c` (1 file)
- **Lines changed:** 3 lines modified (1 comment change, 2 logic
  changes)
- **Functions modified:** `calc_available_free_space()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
Before:
- When `flush == BTRFS_RESERVE_FLUSH_ALL`, overcommit limit was `avail
  >> 3` (1/8 of available)
- `BTRFS_RESERVE_FLUSH_ALL_STEAL` fell through to `else` branch: `avail
  >> 1` (1/2 of available)

After:
- When `flush == BTRFS_RESERVE_FLUSH_ALL || flush ==
  BTRFS_RESERVE_FLUSH_ALL_STEAL`, overcommit limit is `avail >> 6` (1/64
  of available)
- This is more conservative, forcing earlier transaction commits

### Step 2.3: Bug Mechanism
This is a **logic/correctness fix**. The overcommit threshold was too
generous, allowing too many tasks to avoid triggering the space flushing
machinery, which would commit transactions and unpin extents. This
eventually exhausted metadata space with no recovery path.

Two bugs fixed:
1. `BTRFS_RESERVE_FLUSH_ALL_STEAL` was falling into the "else" (1/2
   overcommit) branch — far too generous for a flush type that CAN do
   full flushing.
2. Even `BTRFS_RESERVE_FLUSH_ALL` at 1/8 was too aggressive for small
   filesystems.

### Step 2.4: Fix Quality
- Minimal and obviously correct — reducing overcommit thresholds is safe
- Well-understood mechanism with detailed analysis in commit message
- Regression risk: slightly more frequent transaction commits under
  memory pressure (performance trade-off, not a correctness regression)
- The author is Filipe Manana, one of the most prolific btrfs developers

Record: Very high quality, obviously correct, minimal scope.

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The buggy code (`avail >>= 3` / `avail >>= 1`) was introduced in commit
`41783ef24d56ce` ("btrfs: move and export can_overcommit") by Josef
Bacik, merged in v5.4. The code has been in every kernel since v5.4.

### Step 3.2: No Fixes: tag — skipped as expected.

### Step 3.3: File History
`fs/btrfs/space-info.c` has ~90 changes since v6.6 but the specific
`calc_available_free_space()` function's overcommit logic has only been
touched by:
- `cb6cbab79055c` (v6.7, adjusted overcommit for "very close to full"
  condition)
- `64d2c847ba380` (v6.10, zoned fix)
- Various argument refactoring (fs_info removal)

The current patch touches only the two lines at the `>>= 3` / `>>= 1`
branch which have been stable since v5.4.

### Step 3.4: Author
Filipe Manana is one of the most active btrfs contributors with hundreds
of commits. He regularly fixes space reservation bugs and is deeply
familiar with the overcommit subsystem.

### Step 3.5: Dependencies
The patch is standalone. The only dependency is the existence of
`BTRFS_RESERVE_FLUSH_ALL_STEAL`, which was added in commit
`7f9fe61440769` and confirmed present in all stable trees back to v5.10.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

Lore.kernel.org has bot protection enabled, preventing direct access.
However:
- The commit has two Link: tags referencing mailing list discussions
- The commit was reviewed by Qu Wenruo and signed-off by David Sterba
- The commit message includes the original user report from Aleksandar
  Gerasimovski

Record: Could not access lore directly. The commit has proper review
chain and user report.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Function Modified
`calc_available_free_space()` — computes how much overcommit is allowed
for metadata.

### Step 5.2: Callers
1. `check_can_overcommit()` → called by `can_overcommit()` and
   `btrfs_can_overcommit()`
2. `btrfs_calc_reclaim_metadata_size()` — reclaim size calculation
3. `need_preemptive_reclaim()` — decides if preemptive reclaim is needed

These are called during **every metadata reservation** in the kernel.
This is a hot path for all btrfs operations.

### Step 5.3-5.4: Call Chain
`reserve_bytes()` → `can_overcommit()` → `check_can_overcommit()` →
`calc_available_free_space()`

This is reachable from any filesystem operation that reserves metadata
(file creation, deletion, modification, etc.).

### Step 5.5: Similar Patterns
The earlier commit `cb6cbab79055c` addressed a related but different
aspect of overcommit (when very close to full). This patch addresses the
general case.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
Verified the EXACT same code pattern exists in ALL active stable trees:
- v5.10: same code at line 327
- v5.15: same code at line 324
- v6.1: same code at line 372
- v6.6: same code at line 373
- v6.12: same code at line 421

`BTRFS_RESERVE_FLUSH_ALL_STEAL` confirmed present in v5.10+.

### Step 6.2: Backport Complications
The surrounding context has minor differences (e.g., the zoned mode
alignment was added in v6.10, function signature changed in v6.13+) but
the actual 3-line change applies to code that is IDENTICAL across all
stable trees. Minor context adjustment may be needed for the surrounding
lines (no zoned block in older trees), but the core logic change is
trivially backportable.

### Step 6.3: No related fix already in stable.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and Criticality
- **Subsystem:** `fs/btrfs` — filesystem
- **Criticality:** IMPORTANT — btrfs is a widely-used filesystem,
  especially in enterprise (SLES, openSUSE) and desktop Linux. Metadata
  ENOSPC bugs cause data loss risk (filesystem goes read-only).

### Step 7.2: Activity
btrfs/space-info.c is very actively maintained with frequent
improvements and fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All btrfs users, especially those with smaller filesystems (1G-8G) under
heavy workloads. This is common in containers, VMs, embedded systems,
and IoT devices.

### Step 8.2: Trigger Conditions
- Normal file operations (create/delete files) on a filesystem that has
  most of its space allocated to data
- Reproducible with bonnie++ on a 1G filesystem
- No special privileges needed — any user writing files can trigger this

### Step 8.3: Failure Mode
**CRITICAL** — Transaction abort with -ENOSPC forces the filesystem into
read-only mode. This means:
- Active writes fail
- The filesystem must be unmounted/remounted to recover
- Potential data loss if writes were in progress
- User sees "Read-only file system" errors

### Step 8.4: Risk-Benefit Ratio
- **Benefit:** HIGH — prevents filesystem going read-only on small
  filesystems under normal workloads
- **Risk:** VERY LOW — 3-line change reducing an overcommit threshold;
  the only behavioral change is slightly more frequent transaction
  commits, which is a minor performance trade-off with no correctness
  risk
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real, reproducible bug (filesystem goes read-only)
- Failure mode is CRITICAL (transaction abort, forced read-only)
- Extremely small patch (3 lines in 1 file)
- Reviewed by core btrfs developer (Qu Wenruo), signed off by maintainer
  (David Sterba)
- Author is one of the most prolific btrfs developers (Filipe Manana)
- User-reported with clear reproduction case
- Buggy code exists in ALL stable trees (v5.10+)
- Fix applies cleanly with trivial context adjustment
- No new features or APIs
- The FLUSH_ALL_STEAL case falling through to 1/2 overcommit was clearly
  a bug

**AGAINST backporting:**
- This is a behavioral/heuristic change rather than a strictly "wrong
  code" fix
- Could theoretically affect performance on large filesystems (more
  frequent commits)
- Changes a tuning constant (1/8 → 1/64) which is somewhat subjective
- No Fixes: tag (but this is expected)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — reproduced, analyzed with
   tracing, reviewed
2. Fixes a real bug? **YES** — transaction abort forcing read-only
   filesystem
3. Important issue? **YES** — filesystem goes read-only = CRITICAL
4. Small and contained? **YES** — 3 lines in 1 file
5. No new features? **YES** — changes an existing threshold
6. Can apply to stable? **YES** — verified same code in all stable trees

### Step 9.3: Exception Category
Not applicable — this is a standard bug fix.

### Step 9.4: Decision
The fix is small, surgical, obviously correct, and addresses a CRITICAL
failure mode (filesystem forced read-only). The risk is minimal
(slightly more conservative overcommit policy). The benefit-to-risk
ratio is extremely favorable.

---

## Verification

- [Phase 1] Parsed tags: Reported-by from Aleksandar Gerasimovski,
  Reviewed-by Qu Wenruo, two lore Links
- [Phase 2] Diff analysis: 3-line change in
  `calc_available_free_space()` — shifts avail from >>3 to >>6 for full-
  flush cases, and adds FLUSH_ALL_STEAL to the condition
- [Phase 3] git blame: buggy code introduced in commit 41783ef24d56ce
  (v5.4), present in all stable trees
- [Phase 3] Verified FLUSH_ALL_STEAL exists in v5.10+ (commit
  7f9fe61440769)
- [Phase 3] Author Filipe Manana has hundreds of btrfs commits —
  confirmed core developer
- [Phase 4] lore.kernel.org blocked by bot protection — could not access
  mailing list directly
- [Phase 5] Traced callers: `calc_available_free_space()` called through
  `can_overcommit()` from `reserve_bytes()` — on every metadata
  reservation path
- [Phase 6] Verified exact same code pattern in v5.10, v5.15, v6.1,
  v6.6, v6.12 trees
- [Phase 6] cb6cbab79055c (related but different overcommit fix) already
  in v6.7+
- [Phase 8] Failure mode: transaction abort → read-only filesystem =
  CRITICAL severity
- [Phase 8] Trigger: normal file operations on small filesystem, easily
  reproducible
- UNVERIFIED: Could not access mailing list discussion to check for NAKs
  or concerns about performance regression on large filesystems

**YES**

 fs/btrfs/space-info.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 87cbc051cb12f..b2b775ab878c6 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -489,10 +489,10 @@ static u64 calc_available_free_space(const struct btrfs_space_info *space_info,
 	/*
 	 * If we aren't flushing all things, let us overcommit up to
 	 * 1/2th of the space. If we can flush, don't let us overcommit
-	 * too much, let it overcommit up to 1/8 of the space.
+	 * too much, let it overcommit up to 1/64th of the space.
 	 */
-	if (flush == BTRFS_RESERVE_FLUSH_ALL)
-		avail >>= 3;
+	if (flush == BTRFS_RESERVE_FLUSH_ALL || flush == BTRFS_RESERVE_FLUSH_ALL_STEAL)
+		avail >>= 6;
 	else
 		avail >>= 1;
 
-- 
2.53.0

