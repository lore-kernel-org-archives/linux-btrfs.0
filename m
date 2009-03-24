From: Tom van Klinken / ISP Services BV <tom@isp-services.nl>
Subject: Crash in 2.6.29-rc8
Date: Tue, 24 Mar 2009 15:41:07 +0100
Message-ID: <49C8F103.1090407@isp-services.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060101020507040706070607"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060101020507040706070607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I started using btrfs yesterday and used the version that comes with 
2.6.29-rc8.

The main reason I wanted to try btrfs is that because I am running on 
SSD's and the normal wear leveling algorithm of this SSD (MTRON 7535) 
failed terribly with xfs. (SSD's wore out in 2 months)

I have a 64GB ssd mounted with '-o noatime' and '-o ssd'.

The load is MySQL with 300-400 inserts/sec 24/7 on a large database with 
a lot of indexes.

Attached is the trace I got this morning. The system ran fine for about 
16 hours :)

-- 
Met vriendelijke groet,
Tom van Klinken
ISP Services BV
http://www.isp-services.nl/contact

--------------060101020507040706070607
Content-Type: text/plain;
 name="btrfs-trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs-trace.txt"

Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440762368, delalloc=0, may_use=0, used=632913920
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632913920 used 440762368 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440762368, delalloc=0, may_use=0, used=632913920
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632913920 used 440762368 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440766464, delalloc=0, may_use=0, used=632909824
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632909824 used 440766464 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440770560, delalloc=0, may_use=0, used=632905728
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632905728 used 440770560 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440770560, delalloc=0, may_use=0, used=632905728
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632905728 used 440770560 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0

Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440770560, delalloc=0, may_use=0, used=632905728
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632905728 used 440770560 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440770560, delalloc=0, may_use=0, used=632905728
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632905728 used 440770560 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
Mar 24 08:17:50 db03b btrfs allocation failed flags 36, wanted 4096
Mar 24 08:17:50 db03b space_info has 65536 free, is full
Mar 24 08:17:50 db03b space_info total=1073741824, pinned=440770560, delalloc=0, may_use=0, used=632905728
Mar 24 08:17:50 db03b block group 29360128 has 1073741824 bytes, 632905728 used 440770560 pinned 0 reserved
Mar 24 08:17:50 db03b 0 blocks of free space at or bigger than bytes is
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#1] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 6 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23292, comm: btrfs-endio-wri Not tainted 2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff880220df3580  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: ffffffff806e91b5
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e4f30c0(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f129d0d0c10 CR3: 000000032b80d000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23292, threadinfo ffff880220df2000, task ffff88032c5cae50)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff880220df3680 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880100000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff880220df3680 ffff8800a1c8b000 0000000000000002 ffff8802a8c9cbc0
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803e4821>] ? clear_extent_bit+0x1d6/0x217
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803c1426>] ? __btrfs_inc_extent_ref+0x73/0x1eb
Mar 24 08:17:50 db03b [<ffffffff8041f0fe>] ? sort+0xfa/0x18c
Mar 24 08:17:50 db03b [<ffffffff803c4729>] ? btrfs_inc_ref+0x536/0x632
Mar 24 08:17:50 db03b [<ffffffff803c13b3>] ? __btrfs_inc_extent_ref+0x0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803b29c5>] ? __btrfs_cow_block+0x62a/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c18>] ? lookup_extent_mapping+0x9d/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff880220df3580>
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe69 ]---
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#2] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 2 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23293, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff880248f63580  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f62ea
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e48db40(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f129cc4000f CR3: 0000000186803000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23293, threadinfo ffff880248f62000, task ffff88032c5cb950)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff880248f63680 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880000000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff880248f63680 ffff8800a1c8b000 0000000000000002 ffff88004a6fb958
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803e39fe>] ? merge_state+0x73/0xc2
Mar 24 08:17:50 db03b [<ffffffff806e90ca>] ? _spin_lock+0x5/0x7
Mar 24 08:17:50 db03b [<ffffffff803c1426>] ? __btrfs_inc_extent_ref+0x73/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803da987>] ? btrfs_file_extent_disk_bytenr+0xb8/0xc6
Mar 24 08:17:50 db03b [<ffffffff8041f0fe>] ? sort+0xfa/0x18c
Mar 24 08:17:50 db03b [<ffffffff803c4729>] ? btrfs_inc_ref+0x536/0x632
Mar 24 08:17:50 db03b [<ffffffff803c13b3>] ? __btrfs_inc_extent_ref+0x0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803b29c5>] ? __btrfs_cow_block+0x62a/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c18>] ? lookup_extent_mapping+0x9d/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff880248f63580>
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe6a ]---
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#3] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 0 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23294, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff88027d3e1580  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f6472
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffffffff80a70000(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f1298068810 CR3: 000000032b80d000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23294, threadinfo ffff88027d3e0000, task ffff88032a170310)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff88027d3e1680 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880300000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff88027d3e1680 ffff8800a1c8b000 0000000000000002 ffff88004a6fbd48
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803c1426>] ? __btrfs_inc_extent_ref+0x73/0x1eb
Mar 24 08:17:50 db03b [<ffffffff8041f0fe>] ? sort+0xfa/0x18c
Mar 24 08:17:50 db03b [<ffffffff803c4729>] ? btrfs_inc_ref+0x536/0x632
Mar 24 08:17:50 db03b [<ffffffff803c13b3>] ? __btrfs_inc_extent_ref+0x0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803b29c5>] ? __btrfs_cow_block+0x62a/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c4b>] ? lookup_extent_mapping+0xd0/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff88027d3e1580>
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe6b ]---
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#4] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 5 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23295, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff88026fdff8e0  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f65fa
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e4f3740(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f12870a2410 CR3: 000000032b80d000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23295, threadinfo ffff88026fdfe000, task ffff88032a170e10)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff88026fdff9e0 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880200000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff88026fdff9e0 ffff88030ddee000 0000000000000005 ffff88004a6fbd10
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c18>] ? lookup_extent_mapping+0x9d/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff88026fdff8e0>
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe6c ]---
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#5] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 1 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23290, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff8802b0bf5300  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f6782
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e463240(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f12a90ae810 CR3: 000000031886f000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23290, threadinfo ffff8802b0bf4000, task ffff88032b928610)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff8802b0bf5400 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b 0000000000000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff8802b0bf5400 ffff8800a1c8b000 0000000000000002 ffff8802a8c9cbf8
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b4310>] ? push_leaf_right+0x13a/0x97d
Mar 24 08:17:50 db03b [<ffffffff803e39fe>] ? merge_state+0x73/0xc2
Mar 24 08:17:50 db03b [<ffffffff803b5171>] ? split_leaf+0x45/0xb5e
Mar 24 08:17:50 db03b [<ffffffff803af9dc>] ? leaf_space_used+0xde/0x111
Mar 24 08:17:50 db03b [<ffffffff803b842b>] ? btrfs_search_slot+0xa84/0xb00
Mar 24 08:17:50 db03b [<ffffffff803af7ca>] ? generic_bin_search+0x18f/0x1a3
Mar 24 08:17:50 db03b [<ffffffff803b8ac6>] ? btrfs_insert_empty_items+0x7d/0x500
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803be11c>] ? insert_extent_backref+0x45/0x194
Mar 24 08:17:50 db03b [<ffffffff803c1553>] ? __btrfs_inc_extent_ref+0x1a0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff8041f0fe>] ? sort+0xfa/0x18c
Mar 24 08:17:50 db03b [<ffffffff803c4729>] ? btrfs_inc_ref+0x536/0x632
Mar 24 08:17:50 db03b [<ffffffff803c13b3>] ? __btrfs_inc_extent_ref+0x0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803b29c5>] ? __btrfs_cow_block+0x62a/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c18>] ? lookup_extent_mapping+0x9d/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff8802b0bf5300>
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe6d ]---
Mar 24 08:17:50 db03b invalid opcode: 0000 [#6] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 7 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23288, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff88032a915580  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f690a
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e5e89c0(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f129bf38010 CR3: 000000032b80d000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23288, threadinfo ffff88032a914000, task ffff88032e7ec3d0)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff88032a915680 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880300000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff88032a915680 ffff8800a1c8b000 0000000000000002 ffff88004a6fba00
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803c1426>] ? __btrfs_inc_extent_ref+0x73/0x1eb
Mar 24 08:17:50 db03b [<ffffffff8041f0fe>] ? sort+0xfa/0x18c
Mar 24 08:17:50 db03b [<ffffffff803c4729>] ? btrfs_inc_ref+0x536/0x632
Mar 24 08:17:50 db03b [<ffffffff803c13b3>] ? __btrfs_inc_extent_ref+0x0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803b29c5>] ? __btrfs_cow_block+0x62a/0xb11
Mar 24 08:17:50 db03b [<ffffffff803e3c78>] ? test_range_bit+0xc7/0xda
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c4b>] ? lookup_extent_mapping+0xd0/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff88032a915580>
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#7] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 4 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23291, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff88026ccfb580  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f6a92
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e4f3d40(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007fd3a7727000 CR3: 00000001c726f000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23291, threadinfo ffff88026ccfa000, task ffff88032b929110)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff88026ccfb680 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880200000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff88026ccfb680 ffff8800a1c8b000 0000000000000002 ffff88004a6fb920
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803ef6c9>] ? btrfs_set_lock_blocking+0x14/0x16
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803c1426>] ? __btrfs_inc_extent_ref+0x73/0x1eb
Mar 24 08:17:50 db03b [<ffffffff8041f0fe>] ? sort+0xfa/0x18c
Mar 24 08:17:50 db03b [<ffffffff803c4729>] ? btrfs_inc_ref+0x536/0x632
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe6e ]---
Mar 24 08:17:50 db03b [<ffffffff803c13b3>] ? __btrfs_inc_extent_ref+0x0/0x1eb
Mar 24 08:17:50 db03b [<ffffffff803b29c5>] ? __btrfs_cow_block+0x62a/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c18>] ? lookup_extent_mapping+0x9d/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff88026ccfb580>
Mar 24 08:17:50 db03b ------------[ cut here ]------------
Mar 24 08:17:50 db03b kernel BUG at fs/btrfs/extent-tree.c:3412!
Mar 24 08:17:50 db03b invalid opcode: 0000 [#8] SMP 
Mar 24 08:17:50 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:06:00.0/host6/port-6:1/end_device-6:1/target6:0:1/6:0:1:0/vendor
Mar 24 08:17:50 db03b CPU 3 
Mar 24 08:17:50 db03b Modules linked in:
Mar 24 08:17:50 db03b Pid: 23289, comm: btrfs-endio-wri Tainted: G      D    2.6.29-rc8 #1 X7DVL-3
Mar 24 08:17:50 db03b RIP: 0010:[<ffffffff803bcf7f>]  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP: 0018:ffff8802a52298e0  EFLAGS: 00010246
Mar 24 08:17:50 db03b RAX: ffff88032b94f1f8 RBX: ffff88032d3c3aec RCX: 00000000000f6c1a
Mar 24 08:17:50 db03b RDX: ffff88032b94f1d8 RSI: 0000000000000246 RDI: 0000000000000246
Mar 24 08:17:50 db03b RBP: ffff88032b94f120 R08: 0000000000000000 R09: 0000000000000000
Mar 24 08:17:50 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b94f180
Mar 24 08:17:50 db03b R13: 0000000000001000 R14: ffff88032b94f1f0 R15: ffff8802da8ec000
Mar 24 08:17:50 db03b FS:  0000000000000000(0000) GS:ffff88032e48d4c0(0000) knlGS:0000000000000000
Mar 24 08:17:50 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 24 08:17:50 db03b CR2: 00007f12a8605010 CR3: 000000031687c000 CR4: 00000000000006e0
Mar 24 08:17:50 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 24 08:17:50 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 24 08:17:50 db03b Process btrfs-endio-wri (pid: 23289, threadinfo ffff8802a5228000, task ffff88032e7ed450)
Mar 24 08:17:50 db03b Stack:
Mar 24 08:17:50 db03b 0000000000000000 ffff8802a52299e0 0000000000000000 0000000000000000
Mar 24 08:17:50 db03b ffff880200000024 0000000000000000 0000000000000000 0000000000001000
Mar 24 08:17:50 db03b ffff8802a52299e0 ffff88030ddee000 0000000000000005 ffff88004a6fbae0
Mar 24 08:17:50 db03b Call Trace:
Mar 24 08:17:50 db03b [<ffffffff803bf934>] ? btrfs_alloc_extent+0x4c/0xab
Mar 24 08:17:50 db03b [<ffffffff803bf9fc>] ? btrfs_alloc_free_block+0x69/0x98
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe6f ]---
Mar 24 08:17:50 db03b [<ffffffff803b25e3>] ? __btrfs_cow_block+0x248/0xb11
Mar 24 08:17:50 db03b [<ffffffff803b3657>] ? btrfs_cow_block+0x297/0x2a6
Mar 24 08:17:50 db03b [<ffffffff803b7dbc>] ? btrfs_search_slot+0x415/0xb00
Mar 24 08:17:50 db03b [<ffffffff803d9c4b>] ? lookup_extent_mapping+0xd0/0x175
Mar 24 08:17:50 db03b [<ffffffff803c7a3e>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 24 08:17:50 db03b [<ffffffff803d8c47>] ? btrfs_drop_extents+0xb4/0xb09
Mar 24 08:17:50 db03b [<ffffffff803ef64c>] ? btrfs_tree_unlock+0x1b/0x45
Mar 24 08:17:50 db03b [<ffffffff803b09de>] ? unlock_up+0x12b/0x14f
Mar 24 08:17:50 db03b [<ffffffff8022d8c7>] ? __wake_up+0x30/0x44
Mar 24 08:17:50 db03b [<ffffffff803cfb92>] ? insert_reserved_file_extent+0x96/0x230
Mar 24 08:17:50 db03b [<ffffffff803e3f09>] ? set_extent_bit+0x24f/0x28f
Mar 24 08:17:50 db03b [<ffffffff803e44e0>] ? lock_extent+0x38/0x84
Mar 24 08:17:50 db03b [<ffffffff803d394f>] ? btrfs_finish_ordered_io+0xfe/0x19b
Mar 24 08:17:50 db03b [<ffffffff803e5f0f>] ? end_bio_extent_writepage+0x9b/0x186
Mar 24 08:17:50 db03b [<ffffffff803ed674>] ? worker_loop+0x62/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff803ed612>] ? worker_loop+0x0/0x1de
Mar 24 08:17:50 db03b [<ffffffff80248891>] ? kthread+0x47/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 24 08:17:50 db03b [<ffffffff8024884a>] ? kthread+0x0/0x76
Mar 24 08:17:50 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 24 08:17:50 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 0b e4 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 24 08:17:50 db03b RIP  [<ffffffff803bcf7f>] __btrfs_reserve_extent+0x26c/0x281
Mar 24 08:17:50 db03b RSP <ffff8802a52298e0>
Mar 24 08:17:50 db03b ---[ end trace 06bcf77144a7fe70 ]---

--------------060101020507040706070607--


