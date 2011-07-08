From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: btrfs hang in flush-btrfs-5
Date: Fri, 08 Jul 2011 11:58:53 +0100
Message-ID: <iv6ntd$3o5$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi - I'm trying btrfs with kernel 2.6.38.8-32.fc15.x86_64 (a Fedora kernel). 
I'm just doing a tar-to-tar copy onto the file system with compress-
force=zlib. Here are some traces of the stuck processes.

flush-btrfs-5 seems to be stuck:

Jul  8 11:49:40 xback2 kernel: [74920.681032] flush-btrfs-5   D 
ffff88003c7bae60     0 11712      2 0x00000080
Jul  8 11:49:40 xback2 kernel: [74920.681032]  ffff88001842f750 
0000000000000046 000000000000ce5a ffff88003c7bae60
Jul  8 11:49:40 xback2 kernel: [74920.681032]  ffff88001842ffd8 
ffff88001842ffd8 0000000000013840 0000000000013840
Jul  8 11:49:40 xback2 kernel: [74920.681032]  ffff88005b819730 
ffff88003c7bae60 ffff88005fd140c8 ffff88005feb2188
Jul  8 11:49:40 xback2 kernel: [74920.681032] Call Trace:
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d80c7>] ? 
sync_page+0x0/0x4f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8147439c>] 
io_schedule+0x47/0x62
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d8112>] 
sync_page+0x4b/0x4f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8147482f>] 
__wait_on_bit_lock+0x46/0x8f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d8075>] 
__lock_page+0x66/0x68
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8106f2ab>] ? 
wake_bit_function+0x0/0x31
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa0430cf9>] 
lock_page+0x3a/0x3e [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa04310a6>] 
lock_delalloc_pages+0xad/0x1af [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa0432f7c>] 
find_lock_delalloc_range.constprop.9+0xc8/0x1ba [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa0433866>] 
__extent_writepage+0x15c/0x582 [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8122d488>] ? 
radix_tree_gang_lookup_tag_slot+0x81/0xa2
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81474867>] ? 
__wait_on_bit_lock+0x7e/0x8f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa0433dd0>] 
extent_write_cache_pages.constprop.6+0x144/0x28f [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81475f0e>] ? 
common_interrupt+0xe/0x13
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa043417b>] 
extent_writepages+0x3f/0x50 [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113e27a>] ? 
list_move+0x29/0x30
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa041af1d>] ? 
btrfs_get_extent+0x0/0x74f [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa041ade3>] 
btrfs_writepages+0x28/0x2a [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810e05d5>] 
do_writepages+0x21/0x2a
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113e386>] 
writeback_single_inode+0x96/0x194
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113e6db>] 
writeback_sb_inodes+0xa1/0x12b
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113f4f0>] 
writeback_inodes_wb+0x163/0x175
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113f741>] 
wb_writeback+0x23f/0x35a
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81080b7b>] ? 
arch_local_irq_save+0x15/0x1b
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113f8e2>] 
wb_do_writeback+0x86/0x19d
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81060bb4>] ? 
process_timeout+0x0/0x10
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113fa81>] 
bdi_writeback_thread+0x88/0x1e5
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8113f9f9>] ? 
bdi_writeback_thread+0x0/0x1e5
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8106ebaf>] 
kthread+0x84/0x8c
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8100a9e4>] 
kernel_thread_helper+0x4/0x10
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8106eb2b>] ? 
kthread+0x0/0x8c
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8100a9e0>] ? 
kernel_thread_helper+0x0/0x10

Here is the state of the tar which is stuck in D:

Jul  8 11:49:40 xback2 kernel: [74920.681032] tar             D 
ffff88005fc0f440     0 13171  11702 0x00000084
Jul  8 11:49:40 xback2 kernel: [74920.681032]  ffff88003aa5b468 
0000000000000086 0000000000000001 ffff880059bdc590
Jul  8 11:49:40 xback2 kernel: [74920.681032]  ffff88003aa5bfd8 
ffff88003aa5bfd8 0000000000013840 0000000000013840
Jul  8 11:49:40 xback2 kernel: [74920.681032]  ffff88005ba1c590 
ffff880059bdc590 ffff88005fc140c8 000000015feb58a8
Jul  8 11:49:40 xback2 kernel: [74920.681032] Call Trace:
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d80c7>] ? 
sync_page+0x0/0x4f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8147439c>] 
io_schedule+0x47/0x62
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d8112>] 
sync_page+0x4b/0x4f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8147482f>] 
__wait_on_bit_lock+0x46/0x8f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d8075>] 
__lock_page+0x66/0x68
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8106f2ab>] ? 
wake_bit_function+0x0/0x31
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8111493a>] 
lock_page+0x3a/0x3e
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8111535f>] 
move_to_new_page+0x123/0x1a1
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81115732>] 
migrate_pages+0x246/0x38c
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8110b787>] ? 
compaction_alloc+0x0/0x2a3
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810ecabe>] ? 
zone_page_state_add+0x2f/0x34
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8110bf73>] 
compact_zone+0x3e7/0x5ca
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8110c2e5>] 
compact_zone_order+0x94/0x9f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8110c381>] 
try_to_compact_pages+0x91/0xe3
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8146e867>] 
__alloc_pages_direct_compact+0xa7/0x16d
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810deea3>] 
__alloc_pages_nodemask+0x46a/0x77f
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81108755>] 
alloc_pages_current+0xbe/0xd8
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8111c7aa>] ? 
__mem_cgroup_try_charge+0x111/0x480
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8110f902>] 
alloc_slab_page+0x1c/0x4d
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81110f4c>] 
new_slab+0x50/0x199
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8146f999>] 
__slab_alloc+0x24a/0x328
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8122cc1d>] ? 
radix_tree_preload+0x31/0x81
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8122cc1d>] ? 
radix_tree_preload+0x31/0x81
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8111173e>] 
kmem_cache_alloc+0x77/0x105
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8122cc1d>] 
radix_tree_preload+0x31/0x81
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d89cd>] 
add_to_page_cache_locked+0x56/0x118
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d8ab9>] 
add_to_page_cache_lru+0x2a/0x58
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff810d8d61>] 
find_or_create_page+0x5a/0x8a
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa0423620>] 
prepare_pages+0xd3/0x2e7 [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa040aad7>] ? 
btrfs_delalloc_reserve_metadata+0xf9/0x128 [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffffa0423ca6>] 
btrfs_file_aio_write+0x472/0x7f1 [btrfs]
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff811346ef>] ? 
touch_atime+0x116/0x131
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8112104b>] 
do_sync_write+0xbf/0xff
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff8114db7b>] ? 
fsnotify+0x1eb/0x217
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff811e8102>] ? 
security_file_permission+0x2e/0x33
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81121436>] ? 
rw_verify_area+0xb0/0xcd
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff811216c1>] 
vfs_write+0xac/0xf3
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff811218b0>] 
sys_write+0x4a/0x6e
Jul  8 11:49:40 xback2 kernel: [74920.681032]  [<ffffffff81009bc2>] 
system_call_fastpath+0x16/0x1b


The system has 1.5GB RAM, is x86-64 and the processor is an Athlon X2 4600+. 
The btrfs volume is currently on an linux software raid md device.

I'm also concerned about the space usage. Does "btrfs filesystem df" show 
the uncompressed or compressed space?

The space used reported there is similar to the uncompressed space used for 
a ZFS copy of the data (which achives a compression ratio of x1.59).

Jeremy




