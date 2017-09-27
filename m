Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:46733 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdI0VlQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 17:41:16 -0400
Received: by mail-pg0-f53.google.com with SMTP id v3so379336pgv.3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:41:16 -0700 (PDT)
Received: from sharpeth.aviatis.com (c-50-161-66-197.hsd1.ca.comcast.net. [50.161.66.197])
        by smtp.gmail.com with ESMTPSA id p124sm8123371pfg.179.2017.09.27.14.41.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 27 Sep 2017 14:41:14 -0700 (PDT)
From: Johannes Ernst <johannes.ernst@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: btrfs check error and kernel stack traces
Message-Id: <9FAA90A4-D652-4895-90BE-10A10CBFBD05@gmail.com>
Date: Wed, 27 Sep 2017 14:41:12 -0700
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bunch of processes hung, so I rebooted. Upon reboot:

> btrfs check /dev/sdb
Checking filesystem on /dev/sdb
UUID: d53460f0-40b8-4e5c-8172-cb4b7cd26a28
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
checking quota groups
ERROR: out of memory
ERROR: Loading qgroups from disk: -2
ERROR: failed to check quota groups
found 237836521472 bytes used, error(s) found
total csum bytes: 230618852
total tree bytes: 1614397440
total fs tree bytes: 1274036224
total extent tree bytes: 60456960
btree space waste bytes: 246521070
file data blocks allocated: 290520551424
 referenced 235795329024
extent buffer leak: start 37634048 len 16384
extent buffer leak: start 590715289600 len 16384

(—mode lowmem produces the exact same result, including out of memory. There are no quotas on that filesystem)

> btrfs fi show /build
Label: none  uuid: d53460f0-40b8-4e5c-8172-cb4b7cd26a28
	Total devices 2 FS bytes used 221.50GiB
	devid    1 size 298.09GiB used 265.03GiB path /dev/sdb
	devid    2 size 298.09GiB used 266.00GiB path /dev/sdc

> btrfs fi df /build
Data, RAID1: total=262.00GiB, used=220.00GiB
System, DUP: total=8.00MiB, used=64.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=3.50GiB, used=1.50GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=324.14MiB, used=0.00B

There are also a number of entries in the systemd journal that seem related. This is the first one I can find:

Sep 27 19:15:59 ubos-pc kernel: INFO: task btrfs-cleaner:364 blocked for more than 120 seconds.
Sep 27 19:15:59 ubos-pc kernel:       Tainted: G           O    4.12.13-1-ARCH #1
Sep 27 19:15:59 ubos-pc kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 27 19:15:59 ubos-pc kernel: btrfs-cleaner   D    0   364      2 0x00000000
Sep 27 19:15:59 ubos-pc kernel: Call Trace:
Sep 27 19:15:59 ubos-pc kernel:  __schedule+0x236/0x870
Sep 27 19:15:59 ubos-pc kernel:  schedule+0x3d/0x90
Sep 27 19:15:59 ubos-pc kernel:  btrfs_tree_read_lock+0xbc/0x110 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? wake_bit_function+0x60/0x60
Sep 27 19:15:59 ubos-pc kernel:  __add_missing_keys+0xbf/0x130 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? free_extent_buffer+0x4b/0xa0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  find_parent_nodes+0x358/0x920 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? find_parent_nodes+0x36f/0x920 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  __btrfs_find_all_roots+0xa4/0x110 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_find_all_roots+0x55/0x70 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_qgroup_trace_extent+0x126/0x150 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_qgroup_trace_leaf_items+0x116/0x150 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_qgroup_trace_subtree+0x203/0x390 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  do_walk_down+0x463/0x590 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  walk_down_tree+0xca/0x100 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_drop_snapshot+0x389/0x8c0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? btrfs_delete_unused_bgs+0x25f/0x3b0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_clean_one_deleted_snapshot+0xb5/0x100 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  cleaner_kthread+0x14a/0x180 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  kthread+0x125/0x140
Sep 27 19:15:59 ubos-pc kernel:  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? kthread_create_on_node+0x70/0x70
Sep 27 19:15:59 ubos-pc kernel:  ? SyS_exit_group+0x14/0x20
Sep 27 19:15:59 ubos-pc kernel:  ret_from_fork+0x25/0x30


Sep 27 19:15:59 ubos-pc kernel: INFO: task btrfs-transacti:365 blocked for more than 120 seconds.
Sep 27 19:15:59 ubos-pc kernel:       Tainted: G           O    4.12.13-1-ARCH #1
Sep 27 19:15:59 ubos-pc kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 27 19:15:59 ubos-pc kernel: btrfs-transacti D    0   365      2 0x00000000
Sep 27 19:15:59 ubos-pc kernel: Call Trace:
Sep 27 19:15:59 ubos-pc kernel:  __schedule+0x236/0x870
Sep 27 19:15:59 ubos-pc kernel:  schedule+0x3d/0x90
Sep 27 19:15:59 ubos-pc kernel:  btrfs_commit_transaction+0x818/0x900 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? wake_bit_function+0x60/0x60
Sep 27 19:15:59 ubos-pc kernel:  transaction_kthread+0x193/0x1c0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  kthread+0x125/0x140
Sep 27 19:15:59 ubos-pc kernel:  ? btrfs_cleanup_transaction+0x500/0x500 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? kthread_create_on_node+0x70/0x70
Sep 27 19:15:59 ubos-pc kernel:  ? SyS_exit_group+0x14/0x20
Sep 27 19:15:59 ubos-pc kernel:  ret_from_fork+0x25/0x30

Sep 27 19:15:59 ubos-pc kernel: INFO: task systemd-journal:30360 blocked for more than 120 seconds.
Sep 27 19:15:59 ubos-pc kernel:       Tainted: G           O    4.12.13-1-ARCH #1
Sep 27 19:15:59 ubos-pc kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 27 19:15:59 ubos-pc kernel: systemd-journal D    0 30360  30344 0x00000104
Sep 27 19:15:59 ubos-pc kernel: Call Trace:
Sep 27 19:15:59 ubos-pc kernel:  __schedule+0x236/0x870
Sep 27 19:15:59 ubos-pc kernel:  schedule+0x3d/0x90
Sep 27 19:15:59 ubos-pc kernel:  btrfs_tree_read_lock+0xbc/0x110 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? wake_bit_function+0x60/0x60
Sep 27 19:15:59 ubos-pc kernel:  __add_missing_keys+0xbf/0x130 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? free_extent_buffer+0x4b/0xa0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  find_parent_nodes+0x358/0x920 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  __btrfs_find_all_roots+0xa4/0x110 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_find_all_roots+0x55/0x70 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_qgroup_trace_extent_post+0x34/0x60 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_add_delayed_tree_ref+0x1ab/0x1d0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_inc_extent_ref+0x4c/0x60 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  __btrfs_mod_ref+0x13c/0x230 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? btrfs_lookup_extent_info+0x3ed/0x470 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  ? lookup_tree_block_ref.isra.41+0xe0/0xe0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_inc_ref+0x14/0x20 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  update_ref_for_cow+0xd8/0x330 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  __btrfs_cow_block+0x1f1/0x590 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_cow_block+0xcd/0x1c0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_search_slot+0x30d/0x9c0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_insert_empty_items+0x71/0xc0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_new_inode+0x235/0x5f0 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  btrfs_mkdir+0x110/0x210 [btrfs]
Sep 27 19:15:59 ubos-pc kernel:  vfs_mkdir+0xb6/0x120
Sep 27 19:15:59 ubos-pc kernel:  SyS_mkdir+0xe7/0x110
Sep 27 19:15:59 ubos-pc kernel:  do_syscall_64+0x54/0xc0
Sep 27 19:15:59 ubos-pc kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Sep 27 19:15:59 ubos-pc kernel: RIP: 0033:0x7fb3405e8417
Sep 27 19:15:59 ubos-pc kernel: RSP: 002b:00007ffc1f1c2788 EFLAGS: 00000293 ORIG_RAX: 0000000000000053
Sep 27 19:15:59 ubos-pc kernel: RAX: ffffffffffffffda RBX: 00007ffc1f1c2ae0 RCX: 00007fb3405e8417
Sep 27 19:15:59 ubos-pc kernel: RDX: 000055894ba797fd RSI: 00000000000001ed RDI: 000055894c7df240
Sep 27 19:15:59 ubos-pc kernel: RBP: 00007ffc1f1c27d0 R08: 0000000000000000 R09: 0000000000000000
Sep 27 19:15:59 ubos-pc kernel: R10: 0000000000000002 R11: 0000000000000293 R12: 00007ffc1f1c28c8
Sep 27 19:15:59 ubos-pc kernel: R13: 0000000000000001 R14: 00055a30919adda9 R15: 000055894ba836c8


How should I proceed?

Thanks,


Johannes


