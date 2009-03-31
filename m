From: Tom van Klinken / ISP Services BV <tom@isp-services.nl>
Subject: Re: Crash in 2.6.29-rc8
Date: Tue, 31 Mar 2009 13:26:52 +0200
Message-ID: <49D1FDFC.3090904@isp-services.nl>
References: <49C8F103.1090407@isp-services.nl> <1237916586.5633.14.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090504010302010706050201"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1237916586.5633.14.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090504010302010706050201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chris,

Chris Mason wrote:
> On Tue, 2009-03-24 at 15:41 +0100, Tom van Klinken / ISP Services BV
> wrote:
>> <CUT>
> 
> This is a metadata enospc oops.  You actually had about 400MB free but
> it was pinned down and waiting for a commit to free it all.
>
Today I had a similar issue. See attached kernel trace.

I'm quite sure the filesystem is not full (I have around 15GB of free 
space).

Is their anything I can test/do?

-- 
Met vriendelijke groet,
Tom van Klinken
ISP Services BV
http://www.isp-services.nl/contact

--------------090504010302010706050201
Content-Type: text/plain;
 name="btrfc-trace2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfc-trace2.txt"

Mar 31 00:20:07 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
Mar 31 00:20:07 db03b btrfs allocation failed flags 36, wanted 4096
Mar 31 00:20:07 db03b space_info has 204537856 free, is full
Mar 31 00:20:07 db03b space_info total=1073741824, pinned=271077376, delalloc=0, may_use=0, used=598126592
Mar 31 00:20:07 db03b block group 29360128 has 1073741824 bytes, 598126592 used 271077376 pinned 0 reserved
Mar 31 00:20:07 db03b 0 blocks of free space at or bigger than bytes is
Mar 31 00:20:07 db03b ------------[ cut here ]------------
Mar 31 00:20:07 db03b kernel BUG at fs/btrfs/extent-tree.c:2880!
Mar 31 00:20:07 db03b invalid opcode: 0000 [#1] SMP 
Mar 31 00:20:07 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/model
Mar 31 00:20:07 db03b CPU 5 
Mar 31 00:20:07 db03b Modules linked in:
Mar 31 00:20:07 db03b Pid: 16746, comm: mysqld Not tainted 2.6.29-22648-g1a81af4 #1 X7DVL-3
Mar 31 00:20:07 db03b RIP: 0010:[<ffffffff803bd1b4>]  [<ffffffff803bd1b4>] __btrfs_reserve_extent+0x26c/0x281
Mar 31 00:20:07 db03b RSP: 0018:ffff88015d0438e8  EFLAGS: 00010246
Mar 31 00:20:07 db03b RAX: ffff88032b1df4b8 RBX: ffff88032e642aac RCX: ffffffff806e810d
Mar 31 00:20:07 db03b RDX: ffff88032b1df498 RSI: 0000000000000246 RDI: 0000000000000246
Mar 31 00:20:07 db03b RBP: ffff88032b1df3e0 R08: 0000000000000000 R09: 0000000000000000
Mar 31 00:20:07 db03b R10: 0000000000000000 R11: 00000000ffffffff R12: ffff88032b1df440
Mar 31 00:20:07 db03b R13: 0000000000001000 R14: ffff88032b1df4b0 R15: ffff8802e5c22000
Mar 31 00:20:07 db03b FS:  0000000040998950(0063) GS:ffff88032e4f3740(0000) knlGS:0000000000000000
Mar 31 00:20:07 db03b CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar 31 00:20:07 db03b CR2: 00007f2c169b700f CR3: 00000001d2bef000 CR4: 00000000000006e0
Mar 31 00:20:07 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 31 00:20:07 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 31 00:20:07 db03b Process mysqld (pid: 16746, threadinfo ffff88015d042000, task ffff880230d3d9d0)
Mar 31 00:20:07 db03b Stack:
Mar 31 00:20:07 db03b 0000000000000000 ffff88015d0439e8 0000000000000000 0000000000000000
Mar 31 00:20:07 db03b 0000000000000024 0000000000000000 0000000000000000 0000000000001000
Mar 31 00:20:07 db03b ffff88015d0439e8 0000000000000002 ffff880289417420 ffff88032ccf8000
Mar 31 00:20:07 db03b Call Trace:
Mar 31 00:20:07 db03b [<ffffffff803bd215>] ? btrfs_alloc_extent+0x4c/0xc0
Mar 31 00:20:07 db03b [<ffffffff803bd2f2>] ? btrfs_alloc_free_block+0x69/0x98
Mar 31 00:20:07 db03b [<ffffffff803b3e88>] ? __btrfs_cow_block+0x1e2/0xaa7
Mar 31 00:20:07 db03b [<ffffffff803b4e7b>] ? btrfs_cow_block+0x270/0x27f
Mar 31 00:20:07 db03b [<ffffffff803b804a>] ? btrfs_search_slot+0x35f/0xa2f
Mar 31 00:20:07 db03b [<ffffffff803beaa8>] ? add_extent_ref+0x86/0x220
Mar 31 00:20:07 db03b [<ffffffff806e8000>] ? _write_trylock+0x2/0x1f
Mar 31 00:20:07 db03b [<ffffffff803bf6eb>] ? run_one_delayed_ref+0xe2/0x17c
Mar 31 00:20:07 db03b [<ffffffff803bb8d9>] ? select_delayed_ref+0x14/0x64
Mar 31 00:20:07 db03b [<ffffffff803c010d>] ? run_clustered_refs+0xce/0x14a
Mar 31 00:20:07 db03b [<ffffffff803c023c>] ? btrfs_run_delayed_refs+0xb3/0x1ac
Mar 31 00:20:07 db03b [<ffffffff803ccbf2>] ? __btrfs_end_transaction+0x5c/0x11a
Mar 31 00:20:07 db03b [<ffffffff802abdc1>] ? __mark_inode_dirty+0x29/0x180
Mar 31 00:20:07 db03b [<ffffffff802a46b2>] ? file_update_time+0xba/0xff
Mar 31 00:20:07 db03b [<ffffffff803d6c3d>] ? btrfs_file_write+0x1c1/0x688
Mar 31 00:20:07 db03b [<ffffffff8024894e>] ? autoremove_wake_function+0x0/0x2e
Mar 31 00:20:07 db03b [<ffffffff80293c51>] ? vfs_write+0xad/0x136
Mar 31 00:20:07 db03b [<ffffffff80294257>] ? sys_pwrite64+0x50/0x70
Mar 31 00:20:07 db03b [<ffffffff8020b3ea>] ? system_call_fastpath+0x16/0x1b
Mar 31 00:20:07 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 42 e1 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 31 00:20:07 db03b RIP  [<ffffffff803bd1b4>] __btrfs_reserve_extent+0x26c/0x281
Mar 31 00:20:07 db03b RSP <ffff88015d0438e8>
Mar 31 00:20:07 db03b ---[ end trace 6da0c5d3bc31360b ]---
Mar 31 00:20:12 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
Mar 31 00:20:12 db03b btrfs allocation failed flags 36, wanted 4096
Mar 31 00:20:12 db03b space_info has 204537856 free, is full
Mar 31 00:20:12 db03b space_info total=1073741824, pinned=271077376, delalloc=0, may_use=0, used=598126592
Mar 31 00:20:12 db03b block group 29360128 has 1073741824 bytes, 598126592 used 271077376 pinned 0 reserved
Mar 31 00:20:12 db03b 0 blocks of free space at or bigger than bytes is
Mar 31 00:20:12 db03b ------------[ cut here ]------------
Mar 31 00:20:12 db03b kernel BUG at fs/btrfs/extent-tree.c:2880!
Mar 31 00:20:12 db03b invalid opcode: 0000 [#2] SMP 
Mar 31 00:20:12 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/model
Mar 31 00:20:12 db03b CPU 6 
Mar 31 00:20:12 db03b Modules linked in:
Mar 31 00:20:12 db03b Pid: 7621, comm: btrfs-endio-wri Tainted: G      D    2.6.29-22648-g1a81af4 #1 X7DVL-3
Mar 31 00:20:12 db03b RIP: 0010:[<ffffffff803bd1b4>]  [<ffffffff803bd1b4>] __btrfs_reserve_extent+0x26c/0x281
Mar 31 00:20:12 db03b RSP: 0018:ffff8802e5d1b940  EFLAGS: 00010246
Mar 31 00:20:12 db03b RAX: ffff88032b1df4b8 RBX: ffff88032e642aac RCX: ffffffff806e810d
Mar 31 00:20:12 db03b RDX: ffff88032b1df498 RSI: 0000000000000246 RDI: 0000000000000246
Mar 31 00:20:12 db03b RBP: ffff88032b1df3e0 R08: 0000000000000000 R09: ffff8800280dc040
Mar 31 00:20:12 db03b R10: 0000000000000000 R11: 000001ff80a8b84e R12: ffff88032b1df440
Mar 31 00:20:12 db03b R13: 0000000000001000 R14: ffff88032b1df4b0 R15: ffff8802e5c22000
Mar 31 00:20:12 db03b FS:  0000000000000000(0000) GS:ffff88032e4f30c0(0000) knlGS:0000000000000000
Mar 31 00:20:12 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 31 00:20:12 db03b CR2: 00007f6e1f3a6000 CR3: 00000001d2bef000 CR4: 00000000000006e0
Mar 31 00:20:12 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 31 00:20:12 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 31 00:20:12 db03b Process btrfs-endio-wri (pid: 7621, threadinfo ffff8802e5d1a000, task ffff88031a596090)
Mar 31 00:20:12 db03b Stack:
Mar 31 00:20:12 db03b 0000000040000000 ffff8802e5d1ba40 0000000000000000 0000000000000000
Mar 31 00:20:12 db03b 0000000000000024 0000000040000000 0000000000000000 0000000000001000
Mar 31 00:20:12 db03b ffff8802e5d1ba40 0000000000000005 ffff880289417520 ffff88032b19d800
Mar 31 00:20:12 db03b Call Trace:
Mar 31 00:20:12 db03b [<ffffffff803bd215>] ? btrfs_alloc_extent+0x4c/0xc0
Mar 31 00:20:12 db03b [<ffffffff803bd2f2>] ? btrfs_alloc_free_block+0x69/0x98
Mar 31 00:20:12 db03b [<ffffffff803b3e88>] ? __btrfs_cow_block+0x1e2/0xaa7
Mar 31 00:20:12 db03b [<ffffffff803b4e7b>] ? btrfs_cow_block+0x270/0x27f
Mar 31 00:20:12 db03b [<ffffffff803b804a>] ? btrfs_search_slot+0x35f/0xa2f
Mar 31 00:20:12 db03b [<ffffffff803c64d2>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 31 00:20:12 db03b [<ffffffff803d7b6f>] ? btrfs_drop_extents+0xb4/0xb51
Mar 31 00:20:12 db03b [<ffffffff803af794>] ? leaf_space_used+0xde/0x111
Mar 31 00:20:12 db03b [<ffffffff803da558>] ? btrfs_key_generation+0xb8/0xc6
Mar 31 00:20:12 db03b [<ffffffff8022d897>] ? __wake_up+0x30/0x44
Mar 31 00:20:12 db03b [<ffffffff803ce9a4>] ? insert_reserved_file_extent+0x9d/0x24d
Mar 31 00:20:12 db03b [<ffffffff803e2e75>] ? set_extent_bit+0x24f/0x28f
Mar 31 00:20:12 db03b [<ffffffff803e344c>] ? lock_extent+0x38/0x84
Mar 31 00:20:12 db03b [<ffffffff803d2834>] ? btrfs_finish_ordered_io+0x179/0x230
Mar 31 00:20:12 db03b [<ffffffff8026b832>] ? test_clear_page_writeback+0xda/0xe6
Mar 31 00:20:12 db03b [<ffffffff803e4eed>] ? end_bio_extent_writepage+0x9b/0x186
Mar 31 00:20:12 db03b [<ffffffff803ec4f0>] ? worker_loop+0x62/0x1de
Mar 31 00:20:12 db03b [<ffffffff803ec48e>] ? worker_loop+0x0/0x1de
Mar 31 00:20:12 db03b [<ffffffff803ec48e>] ? worker_loop+0x0/0x1de
Mar 31 00:20:12 db03b [<ffffffff802487fd>] ? kthread+0x47/0x76
Mar 31 00:20:12 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 31 00:20:12 db03b [<ffffffff802487b6>] ? kthread+0x0/0x76
Mar 31 00:20:12 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 31 00:20:12 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 42 e1 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 31 00:20:12 db03b RIP  [<ffffffff803bd1b4>] __btrfs_reserve_extent+0x26c/0x281
Mar 31 00:20:12 db03b RSP <ffff8802e5d1b940>
Mar 31 00:20:12 db03b ---[ end trace 6da0c5d3bc31360c ]---
Mar 31 00:20:12 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
Mar 31 00:20:12 db03b btrfs allocation failed flags 36, wanted 4096
Mar 31 00:20:12 db03b space_info has 204537856 free, is full
Mar 31 00:20:12 db03b space_info total=1073741824, pinned=271077376, delalloc=0, may_use=0, used=598126592
Mar 31 00:20:12 db03b block group 29360128 has 1073741824 bytes, 598126592 used 271077376 pinned 0 reserved
Mar 31 00:20:12 db03b 0 blocks of free space at or bigger than bytes is
Mar 31 00:20:12 db03b ------------[ cut here ]------------
Mar 31 00:20:12 db03b kernel BUG at fs/btrfs/extent-tree.c:2880!
Mar 31 00:20:12 db03b invalid opcode: 0000 [#3] SMP 
Mar 31 00:20:12 db03b last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/model
Mar 31 00:20:12 db03b CPU 6 
Mar 31 00:20:12 db03b Modules linked in:
Mar 31 00:20:12 db03b Pid: 7623, comm: btrfs-endio-wri Tainted: G      D    2.6.29-22648-g1a81af4 #1 X7DVL-3
Mar 31 00:20:12 db03b RIP: 0010:[<ffffffff803bd1b4>]  [<ffffffff803bd1b4>] __btrfs_reserve_extent+0x26c/0x281
Mar 31 00:20:12 db03b RSP: 0018:ffff880317d15940  EFLAGS: 00010246
Mar 31 00:20:12 db03b RAX: ffff88032b1df4b8 RBX: ffff88032e642aac RCX: ffffffff806e810d
Mar 31 00:20:12 db03b RDX: ffff88032b1df498 RSI: 0000000000000246 RDI: 0000000000000246
Mar 31 00:20:12 db03b RBP: ffff88032b1df3e0 R08: 0000000000000000 R09: ffff8800280dc040
Mar 31 00:20:12 db03b R10: 0000000000000000 R11: 000001ff80a8c5da R12: ffff88032b1df440
Mar 31 00:20:12 db03b R13: 0000000000001000 R14: ffff88032b1df4b0 R15: ffff8802e5c22000
Mar 31 00:20:12 db03b FS:  0000000000000000(0000) GS:ffff88032e4f30c0(0000) knlGS:0000000000000000
Mar 31 00:20:12 db03b CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 31 00:20:12 db03b CR2: 00007f6e1f3a6000 CR3: 00000001d2bef000 CR4: 00000000000006e0
Mar 31 00:20:12 db03b DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar 31 00:20:12 db03b DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar 31 00:20:12 db03b Process btrfs-endio-wri (pid: 7623, threadinfo ffff880317d14000, task ffff88031a597690)
Mar 31 00:20:12 db03b Stack:
Mar 31 00:20:12 db03b 0000000000000000 ffff880317d15a40 0000000000000000 0000000000000000
Mar 31 00:20:12 db03b 0000000000000024 0000000000000000 0000000000000000 0000000000001000
Mar 31 00:20:12 db03b ffff880317d15a40 0000000000000005 ffff880289417560 ffff88032b19d800
Mar 31 00:20:12 db03b Call Trace:
Mar 31 00:20:12 db03b [<ffffffff803bd215>] ? btrfs_alloc_extent+0x4c/0xc0
Mar 31 00:20:12 db03b [<ffffffff803bd2f2>] ? btrfs_alloc_free_block+0x69/0x98
Mar 31 00:20:12 db03b [<ffffffff803b3e88>] ? __btrfs_cow_block+0x1e2/0xaa7
Mar 31 00:20:12 db03b [<ffffffff803b4e7b>] ? btrfs_cow_block+0x270/0x27f
Mar 31 00:20:12 db03b [<ffffffff803b804a>] ? btrfs_search_slot+0x35f/0xa2f
Mar 31 00:20:12 db03b [<ffffffff803c64d2>] ? btrfs_lookup_file_extent+0x35/0x3a
Mar 31 00:20:12 db03b [<ffffffff803d7b6f>] ? btrfs_drop_extents+0xb4/0xb51
Mar 31 00:20:12 db03b [<ffffffff803bec2d>] ? add_extent_ref+0x20b/0x220
Mar 31 00:20:12 db03b [<ffffffff803af582>] ? generic_bin_search+0x18f/0x1a3
Mar 31 00:20:12 db03b [<ffffffff803da558>] ? btrfs_key_generation+0xb8/0xc6
Mar 31 00:20:12 db03b [<ffffffff803ce9a4>] ? insert_reserved_file_extent+0x9d/0x24d
Mar 31 00:20:12 db03b [<ffffffff803e2e75>] ? set_extent_bit+0x24f/0x28f
Mar 31 00:20:12 db03b [<ffffffff803e344c>] ? lock_extent+0x38/0x84
Mar 31 00:20:12 db03b [<ffffffff803d2834>] ? btrfs_finish_ordered_io+0x179/0x230
Mar 31 00:20:12 db03b [<ffffffff8026b832>] ? test_clear_page_writeback+0xda/0xe6
Mar 31 00:20:12 db03b [<ffffffff803e4eed>] ? end_bio_extent_writepage+0x9b/0x186
Mar 31 00:20:12 db03b [<ffffffff803ec4f0>] ? worker_loop+0x62/0x1de
Mar 31 00:20:12 db03b [<ffffffff803ec48e>] ? worker_loop+0x0/0x1de
Mar 31 00:20:12 db03b [<ffffffff803ec48e>] ? worker_loop+0x0/0x1de
Mar 31 00:20:12 db03b [<ffffffff802487fd>] ? kthread+0x47/0x76
Mar 31 00:20:12 db03b [<ffffffff8020c5da>] ? child_rip+0xa/0x20
Mar 31 00:20:12 db03b [<ffffffff802487b6>] ? kthread+0x0/0x76
Mar 31 00:20:12 db03b [<ffffffff8020c5d0>] ? child_rip+0x0/0x20
Mar 31 00:20:12 db03b Code: 00 48 81 ed b8 00 00 00 48 8b 85 b8 00 00 00 48 8d 95 b8 00 00 00 0f 18 08 49 8d 44 24 58 48 39 c2 75 95 4c 89 f7 e8 42 e1 e8 ff <0f> 0b eb fe 48 83 c4 38 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 
Mar 31 00:20:12 db03b RIP  [<ffffffff803bd1b4>] __btrfs_reserve_extent+0x26c/0x281
Mar 31 00:20:12 db03b RSP <ffff880317d15940>
Mar 31 00:20:12 db03b ---[ end trace 6da0c5d3bc31360d ]---


--------------090504010302010706050201--


