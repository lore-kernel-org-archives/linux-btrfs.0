From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: btrfs hang in flush-btrfs-5
Date: Mon, 11 Jul 2011 12:40:34 +0100
Message-ID: <ivenfi$iph$1@dough.gmane.org>
References: <iv6ntd$3o5$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jeremy Sanders wrote:

> Hi - I'm trying btrfs with kernel 2.6.38.8-32.fc15.x86_64 (a Fedora
> kernel). I'm just doing a tar-to-tar copy onto the file system with
> compress- force=zlib. Here are some traces of the stuck processes.

I've managed to reproduce the hang using the latest btrfs from the 
repository. I had to remove some of the tracing lines to get it to compile 
under 2.6.38.8 and an ioctl which wasn't defined. Here is is where it is 
stuck:

[ 8390.923737] flush-btrfs-4   D ffff88005aeef480     0  2965      2 
0x00000080
[ 8390.923907]  ffff8800026cb720 0000000000000046 ffff8800026cb690 
ffffffff00000001
[ 8390.924037]  0000000000013840 0000000000013840 0000000000013840 
ffff88005931ae60
[ 8390.924037]  0000000000013840 ffff8800026cbfd8 0000000000013840 
0000000000013840
[ 8390.924037] Call Trace:
[ 8390.924037]  [<ffffffff810e03e7>] ? sync_page+0x0/0x4d
[ 8390.924037]  [<ffffffff8148ad2f>] io_schedule+0x47/0x62
[ 8390.924037]  [<ffffffff810e0430>] sync_page+0x49/0x4d
[ 8390.924037]  [<ffffffff8148b1cc>] __wait_on_bit_lock+0x46/0x8f
[ 8390.924037]  [<ffffffff810e038c>] __lock_page+0x66/0x6d
[ 8390.924037]  [<ffffffff8107374c>] ? wake_bit_function+0x0/0x31
[ 8390.924037]  [<ffffffff8104767a>] ? should_resched+0xe/0x2e
[ 8390.924037]  [<ffffffffa0541727>] lock_page+0x3d/0x41 [btrfs]
[ 8390.924037]  [<ffffffffa0541d22>] lock_delalloc_pages+0xb7/0x1a2 [btrfs]
[ 8390.924037]  [<ffffffffa05439b9>] 
find_lock_delalloc_range.clone.18+0xd9/0x1cb [btrfs]
[ 8390.924037]  [<ffffffff8123fe95>] ? __lookup_tag+0xb9/0x123
[ 8390.924037]  [<ffffffffa05442ce>] __extent_writepage+0x156/0x561 [btrfs]
[ 8390.924037]  [<ffffffff8123ff80>] ? 
radix_tree_gang_lookup_tag_slot+0x81/0xa2
[ 8390.924037]  [<ffffffff810e00d5>] ? find_get_pages_tag+0x6f/0xd5
[ 8390.924037]  [<ffffffffa054480d>] 
extent_write_cache_pages.clone.9.clone.16+0x134/0x2a1 [btrfs]
[ 8390.924037]  [<ffffffffa0544bea>] extent_writepages+0x47/0x5c [btrfs]
[ 8390.924037]  [<ffffffffa052b78c>] ? btrfs_get_extent+0x0/0x77f [btrfs]
[ 8390.924037]  [<ffffffff81073620>] ? bit_waitqueue+0x17/0xa9
[ 8390.924037]  [<ffffffffa052a980>] btrfs_writepages+0x27/0x29 [btrfs]
[ 8390.924037]  [<ffffffff810e8a0e>] do_writepages+0x21/0x2a
[ 8390.924037]  [<ffffffff81149aa0>] writeback_single_inode+0x9c/0x19b
[ 8390.924037]  [<ffffffff81149d9b>] writeback_sb_inodes+0xa1/0x12b
[ 8390.924037]  [<ffffffff8114a7bc>] writeback_inodes_wb+0x163/0x175
[ 8390.924037]  [<ffffffff8114aa1d>] wb_writeback+0x24f/0x368
[ 8390.924037]  [<ffffffff8114acb9>] wb_do_writeback+0x183/0x19e
[ 8390.924037]  [<ffffffff8148b0f6>] ? schedule_timeout+0xb3/0xe3
[ 8390.924037]  [<ffffffff8114ad5c>] bdi_writeback_thread+0x88/0x205
[ 8390.924037]  [<ffffffff8114acd4>] ? bdi_writeback_thread+0x0/0x205
[ 8390.924037]  [<ffffffff8107326e>] kthread+0x82/0x8a
[ 8390.924037]  [<ffffffff8100ba64>] kernel_thread_helper+0x4/0x10
[ 8390.924037]  [<ffffffff810731ec>] ? kthread+0x0/0x8a
[ 8390.924037]  [<ffffffff8100ba60>] ? kernel_thread_helper+0x0/0x10

[ 8390.933163] tar             D ffff880019053478     0  4195   2953 
0x00000084
[ 8390.933163]  ffff8800190533d8 0000000000000086 ffffffff813b9878 
0000000000000010
[ 8390.933163]  0000000000013840 0000000000013840 0000000000013840 
ffff880045beae60
[ 8390.933163]  0000000000013840 ffff880019053fd8 0000000000013840 
0000000000013840
[ 8390.933163] Call Trace:
[ 8390.933163]  [<ffffffff813b9878>] ? read_pmtmr+0x10/0x17
[ 8390.933163]  [<ffffffff810e03e7>] ? sync_page+0x0/0x4d
[ 8390.933163]  [<ffffffff8148ad2f>] io_schedule+0x47/0x62
[ 8390.933163]  [<ffffffff810e0430>] sync_page+0x49/0x4d
[ 8390.933163]  [<ffffffff8148b1cc>] __wait_on_bit_lock+0x46/0x8f
[ 8390.933163]  [<ffffffff810e038c>] __lock_page+0x66/0x6d
[ 8390.933163]  [<ffffffff8107374c>] ? wake_bit_function+0x0/0x31
[ 8390.933163]  [<ffffffff8111ec72>] lock_page+0x3d/0x41
[ 8390.933163]  [<ffffffff8111f61d>] move_to_new_page+0x11e/0x195
[ 8390.933163]  [<ffffffff8111f9fc>] migrate_pages+0x24e/0x38d
[ 8390.933163]  [<ffffffff8111501d>] ? compaction_alloc+0x0/0x29a
[ 8390.933163]  [<ffffffff810f523b>] ? zone_page_state_add+0x2f/0x34
[ 8390.933163]  [<ffffffff81115735>] compact_zone+0x3f0/0x5e1
[ 8390.933163]  [<ffffffff81115ad9>] compact_zone_order+0xb0/0xbf
[ 8390.933163]  [<ffffffff810e6bc6>] ? get_page_from_freelist+0x627/0x670
[ 8390.933163]  [<ffffffff81115b79>] try_to_compact_pages+0x91/0xe7
[ 8390.933163]  [<ffffffff810e6cb8>] __alloc_pages_direct_compact+0xa9/0x16f
[ 8390.933163]  [<ffffffff810e71e7>] __alloc_pages_nodemask+0x469/0x762
[ 8390.933163]  [<ffffffff81123b15>] ? signal_pending+0x17/0x21
[ 8390.933163]  [<ffffffff81111c69>] alloc_pages_current+0xb1/0xca
[ 8390.933163]  [<ffffffff81119f3f>] alloc_slab_page+0x1c/0x4a
[ 8390.933163]  [<ffffffff8111a9f7>] new_slab+0x52/0x1a7
[ 8390.933163]  [<ffffffff8111b2dd>] __slab_alloc+0x224/0x302
[ 8390.933163]  [<ffffffff8124078b>] ? radix_tree_preload+0x34/0x85
[ 8390.933163]  [<ffffffff8124078b>] ? radix_tree_preload+0x34/0x85
[ 8390.933163]  [<ffffffff8111b953>] kmem_cache_alloc+0x5b/0xe1
[ 8390.933163]  [<ffffffff8124078b>] radix_tree_preload+0x34/0x85
[ 8390.933163]  [<ffffffff810e0740>] add_to_page_cache_locked+0x58/0x124
[ 8390.933163]  [<ffffffff810e0836>] add_to_page_cache_lru+0x2a/0x58
[ 8390.933163]  [<ffffffff810e0b58>] find_or_create_page+0x5a/0x8a
[ 8390.933163]  [<ffffffffa0533e2c>] prepare_pages.clone.9+0xf1/0x30a 
[btrfs]
[ 8390.933163]  [<ffffffffa05143c0>] ? block_rsv_add_bytes+0x24/0x4e [btrfs]
[ 8390.933163]  [<ffffffffa0534358>] 
__btrfs_buffered_write.clone.11+0x126/0x2a1 [btrfs]
[ 8390.933163]  [<ffffffff8114a01c>] ? __mark_inode_dirty+0x30/0x169
[ 8390.933163]  [<ffffffff8113f534>] ? file_update_time+0xf7/0x111
[ 8390.933163]  [<ffffffffa05348ad>] btrfs_file_aio_write+0x3da/0x492 
[btrfs]
[ 8390.933163]  [<ffffffff81133939>] ? pipe_read+0x3bd/0x3d2
[ 8390.933163]  [<ffffffff810d98a7>] ? __perf_event_task_sched_out+0x27/0x2c
[ 8390.933163]  [<ffffffff8112b7e2>] do_sync_write+0xcb/0x108
[ 8390.933163]  [<ffffffff811f72da>] ? security_file_permission+0x2e/0x33
[ 8390.933163]  [<ffffffff8112be61>] vfs_write+0xac/0xff
[ 8390.933163]  [<ffffffff8112c068>] sys_write+0x4a/0x6e
[ 8390.933163]  [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b

Jeremy


