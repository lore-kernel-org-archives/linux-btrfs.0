From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.31-rc6, BTRFS] potential memory leaks...
Date: Fri, 14 Aug 2009 16:03:04 +0100
Message-ID: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932465AbZHNPDI@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
[1] are false-positives, due to the overwriting of the static pointers
[2]. Does this ring true with anyone else?

--- [1]

unreferenced object 0xffff88001eda7000 (size 168):
  comm "rm", pid 14794, jiffies 4301710929
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810d9f73>] kmem_cache_alloc+0x153/0x1a0
    [<ffffffff811df959>] alloc_extent_state+0x19/0x70
    [<ffffffff811e1eb3>] clear_extent_bit+0x233/0x2e0
    [<ffffffff811e20ee>] try_release_extent_state+0x7e/0xa0
    [<ffffffff811bf7f3>] btree_releasepage+0x63/0xa0
    [<ffffffff810ad0be>] try_to_release_page+0x2e/0x60
    [<ffffffff810b872c>] invalidate_mapping_pages+0x1ac/0x1c0
    [<ffffffff811b746a>] __btrfs_free_extent+0x56a/0x8e0
    [<ffffffff811b7c9d>] run_one_delayed_ref+0x4bd/0x4f0
    [<ffffffff811b9a8f>] run_clustered_refs+0xcf/0x360
    [<ffffffff811b9de6>] btrfs_run_delayed_refs+0xc6/0x1f0
    [<ffffffff811c4129>] __btrfs_end_transaction+0x59/0x130
    [<ffffffff811c421b>] btrfs_end_transaction+0xb/0x10
    [<ffffffff811cc6d2>] btrfs_delete_inode+0x112/0x130

unreferenced object 0xffff88006c5912a0 (size 168):
  comm "make", pid 3983, jiffies 4296054079
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810d9f73>] kmem_cache_alloc+0x153/0x1a0
    [<ffffffff811df959>] alloc_extent_state+0x19/0x70
    [<ffffffff811e0cae>] set_extent_bit+0x1ee/0x390
    [<ffffffff811e1a73>] lock_extent+0x73/0xa0
    [<ffffffff811e27a7>] __extent_read_full_page+0x97/0x610
    [<ffffffff811e3119>] read_extent_buffer_pages+0x3f9/0x540
    [<ffffffff811bf75f>] readahead_tree_block+0x4f/0x60
    [<ffffffff811a7e03>] read_block_for_search+0x2f3/0x3b0
    [<ffffffff811b003b>] btrfs_next_leaf+0x28b/0x3f0
    [<ffffffff811c5cea>] btrfs_real_readdir+0x1ca/0x4e0
    [<ffffffff810f0580>] vfs_readdir+0xb0/0xd0
    [<ffffffff810f06f7>] sys_getdents+0x87/0xe0
    [<ffffffff8100bdeb>] system_call_fastpath+0x16/0x1b

unreferenced object 0xffff88003bf5d800 (size 256):
  comm "btrfs-transacti", pid 2060, jiffies 4301667515
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810d9f73>] kmem_cache_alloc+0x153/0x1a0
    [<ffffffff811dfa29>] alloc_extent_buffer+0x79/0x3e0
    [<ffffffff811bf688>] btrfs_find_create_tree_block+0x28/0x30
    [<ffffffff811b46a1>] btrfs_init_new_buffer+0x31/0x140
    [<ffffffff811b4854>] btrfs_alloc_free_block+0xa4/0x230
    [<ffffffff811ac2d7>] __btrfs_cow_block+0x137/0x670
    [<ffffffff811acf0f>] btrfs_cow_block+0xef/0x1f0
    [<ffffffff811af6ba>] btrfs_search_slot+0x19a/0x890
    [<ffffffff811bd1ee>] btrfs_del_csums+0xee/0x2e0
    [<ffffffff811b75b9>] __btrfs_free_extent+0x6b9/0x8e0
    [<ffffffff811b7be2>] run_one_delayed_ref+0x402/0x4f0
    [<ffffffff811b9a8f>] run_clustered_refs+0xcf/0x360
    [<ffffffff811b9de6>] btrfs_run_delayed_refs+0xc6/0x1f0
    [<ffffffff811c4a8a>] btrfs_commit_transaction+0x7a/0x750

unreferenced object 0xffff8800668e8600 (size 256):
  comm "btrfs-endio-wri", pid 2053, jiffies 4301877227
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810d9f73>] kmem_cache_alloc+0x153/0x1a0
    [<ffffffff811dfa29>] alloc_extent_buffer+0x79/0x3e0
    [<ffffffff811bf688>] btrfs_find_create_tree_block+0x28/0x30
    [<ffffffff811b46a1>] btrfs_init_new_buffer+0x31/0x140
    [<ffffffff811b4854>] btrfs_alloc_free_block+0xa4/0x230
    [<ffffffff811ac2d7>] __btrfs_cow_block+0x137/0x670
    [<ffffffff811acf0f>] btrfs_cow_block+0xef/0x1f0
    [<ffffffff811af6ba>] btrfs_search_slot+0x19a/0x890
    [<ffffffff811b0819>] btrfs_insert_empty_items+0x69/0xd0
    [<ffffffff811b7998>] run_one_delayed_ref+0x1b8/0x4f0
    [<ffffffff811b9a8f>] run_clustered_refs+0xcf/0x360
    [<ffffffff811b9de6>] btrfs_run_delayed_refs+0xc6/0x1f0
    [<ffffffff811c4129>] __btrfs_end_transaction+0x59/0x130
    [<ffffffff811c421b>] btrfs_end_transaction+0xb/0x10

--- [2] fs/btrfs/extent_io.c:46

static struct kmem_cache *extent_state_cache;
static struct kmem_cache *extent_buffer_cache
-- 
Daniel J Blueman
