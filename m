From: Avi Kivity <avi@redhat.com>
Subject: oops in btrfs_reserve_extent (v0.16)
Date: Sun, 28 Sep 2008 23:42:00 +0300
Message-ID: <48DFEC18.6070303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Perhaps a bit optimistically I started moving my home directory to 
btrfs, using v0.16.  Midway through the rsync I noticed the 10GB lvm 
volume would be too small for a filesystem with no -ENOSPC support, so I 
extended the volume and resized the filesystem while rsync was running.  
The punishment for this arrived almost immediately:

new size for /dev/mapper/vg0-home.btrfs is 21474836480
Unable to find block group for 8619294720
------------[ cut here ]------------
WARNING: at /home/avi/btrfs/btrfs-0.16/extent-tree.c:300 
find_search_start+0x1d9/0x27e [btrfs]() (Not tainted)
Modules linked in: btrfs ...
Pid: 31165, comm: pdflush Not tainted 2.6.26.3-29.fc9.x86_64 #1

Call Trace:
 [<ffffffff81036db7>] warn_on_slowpath+0x60/0xa3
 [<ffffffff8129a3ed>] ? printk+0x67/0x6a
 [<ffffffffa0511d52>] ? :btrfs:get_state_private+0x6b/0x79
 [<ffffffffa04f41e8>] ? :btrfs:btrfs_lookup_block_group+0x3b/0x73
 [<ffffffffa0511b6b>] ? :btrfs:find_first_extent_bit_state+0x23/0x5e
 [<ffffffffa04f4cf4>] :btrfs:find_search_start+0x1d9/0x27e
 [<ffffffffa0511d52>] ? :btrfs:get_state_private+0x6b/0x79
 [<ffffffffa04f5eb9>] :btrfs:find_free_extent+0x334/0x5ff
 [<ffffffffa04f632d>] :btrfs:__btrfs_reserve_extent+0x1a9/0x23a
 [<ffffffffa04f641c>] :btrfs:btrfs_reserve_extent+0x5e/0x79
 [<ffffffffa05014a7>] :btrfs:cow_file_range+0x11d/0x23e
 [<ffffffffa0501894>] :btrfs:run_delalloc_range+0x2cc/0x2e2
 [<ffffffffa0512a82>] ? :btrfs:find_lock_delalloc_range+0x205/0x218
 [<ffffffff8104ee17>] ? getnstimeofday+0x3a/0x96
 [<ffffffffa05151b4>] :btrfs:__extent_writepage+0x169/0x5b6
 [<ffffffff8107ca9c>] ? find_get_pages_tag+0x3d/0x95
 [<ffffffff81083cba>] write_cache_pages+0x1c5/0x314
 [<ffffffffa051504b>] ? :btrfs:__extent_writepage+0x0/0x5b6
 [<ffffffffa051285d>] :btrfs:extent_writepages+0x32/0x52
 [<ffffffffa050264a>] ? :btrfs:btrfs_get_extent+0x0/0x74f
 [<ffffffffa0502628>] :btrfs:btrfs_writepages+0x23/0x25
 [<ffffffff81083e56>] do_writepages+0x28/0x38
 [<ffffffff810c9841>] __writeback_single_inode+0x16d/0x2cc
 [<ffffffffa00b6b71>] ? :dm_mod:dm_any_congested+0x43/0x52
 [<ffffffff810c9dab>] sync_sb_inodes+0x20b/0x2d0
 [<ffffffff810ca0f9>] writeback_inodes+0xa8/0x100
 [<ffffffff81083fac>] wb_kupdate+0xa3/0x119
 [<ffffffff81084a81>] pdflush+0x148/0x1f7
 [<ffffffff81083f09>] ? wb_kupdate+0x0/0x119
 [<ffffffff81084939>] ? pdflush+0x0/0x1f7
 [<ffffffff81049baf>] kthread+0x49/0x76
 [<ffffffff8100d148>] child_rip+0xa/0x12
 [<ffffffff81049b66>] ? kthread+0x0/0x76
 [<ffffffff8100d13e>] ? child_rip+0x0/0x12

and

allocation failed flags 1
------------[ cut here ]------------
kernel BUG at /home/avi/btrfs/btrfs-0.16/extent-tree.c:2111!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: btrfs ...
Pid: 31165, comm: pdflush Tainted: G        W 2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffffa04f6383>]  [<ffffffffa04f6383>] 
:btrfs:__btrfs_reserve_extent+0x1ff/0x23a
RSP: 0018:ffff81005f095860  EFLAGS: 00010286
RAX: 000000000000001d RBX: 0000000000000001 RCX: ffff81005e487e60
RDX: 0000000100000000 RSI: ffff81005f0956d0 RDI: 0000000000000246
RBP: ffff81005f0958d0 R08: ffffffff813d2db0 R09: ffff810001019798
R10: 00004bd3179bd155 R11: 0000000000000000 R12: ffff8100256ea000
R13: ffff81003722f000 R14: 0000000000001000 R15: ffff81003e1926c8
FS:  0000000000000000(0000) GS:ffffffff81417000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000031c032e830 CR3: 000000007a40a000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pdflush (pid: 31165, threadinfo ffff81005f094000, task 
ffff810018b2da80)
Stack:  0000000000000000 ffff81005f095990 0000000000000000 0000000000000000
 0000000000000001 0000000000000246 0000000000000000 0000000000000000
 0000000000001000 0000000000000000 ffff81003722f000 0000000000000000
Call Trace:
 [<ffffffffa04f641c>] :btrfs:btrfs_reserve_extent+0x5e/0x79
 [<ffffffffa05014a7>] :btrfs:cow_file_range+0x11d/0x23e
 [<ffffffffa0501894>] :btrfs:run_delalloc_range+0x2cc/0x2e2
 [<ffffffffa0512a82>] ? :btrfs:find_lock_delalloc_range+0x205/0x218
 [<ffffffff8104ee17>] ? getnstimeofday+0x3a/0x96
 [<ffffffffa05151b4>] :btrfs:__extent_writepage+0x169/0x5b6
 [<ffffffff8107ca9c>] ? find_get_pages_tag+0x3d/0x95
 [<ffffffff81083cba>] write_cache_pages+0x1c5/0x314
 [<ffffffffa051504b>] ? :btrfs:__extent_writepage+0x0/0x5b6
 [<ffffffffa051285d>] :btrfs:extent_writepages+0x32/0x52
 [<ffffffffa050264a>] ? :btrfs:btrfs_get_extent+0x0/0x74f
 [<ffffffffa0502628>] :btrfs:btrfs_writepages+0x23/0x25
 [<ffffffff81083e56>] do_writepages+0x28/0x38
 [<ffffffff810c9841>] __writeback_single_inode+0x16d/0x2cc
 [<ffffffffa00b6b71>] ? :dm_mod:dm_any_congested+0x43/0x52
 [<ffffffff810c9dab>] sync_sb_inodes+0x20b/0x2d0
 [<ffffffff810ca0f9>] writeback_inodes+0xa8/0x100
 [<ffffffff81083fac>] wb_kupdate+0xa3/0x119
 [<ffffffff81084a81>] pdflush+0x148/0x1f7
 [<ffffffff81083f09>] ? wb_kupdate+0x0/0x119
 [<ffffffff81084939>] ? pdflush+0x0/0x1f7
 [<ffffffff81049baf>] kthread+0x49/0x76
 [<ffffffff8100d148>] child_rip+0xa/0x12
 [<ffffffff81049b66>] ? kthread+0x0/0x76
 [<ffffffff8100d13e>] ? child_rip+0x0/0x12

Code: 85 08 01 00 00 4c 89 f2 48 8b 70 20 e8 0d f5 ff ff e9 91 fe ff ff 
85 c0 74 15 48 89 de 48 c7 c7 f1 bc 51 a0 31 c0 e8 03 40 da e0 <0f> 0b 
eb fe 48 8b 45 18 49 8b bd 08 01 00 00 b9 50 00 00 00 48
RIP  [<ffffffffa04f6383>] :btrfs:__btrfs_reserve_extent+0x1ff/0x23a

The 'Unable to find block group' perhaps indicate the firesystem was 
resized beyond the blockdev's limits?  Or is online resizing broken?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

