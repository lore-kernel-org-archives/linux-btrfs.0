Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tsort.uuid.uk ([81.2.80.87]:40110 "EHLO tsort.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757056AbcJ3Rtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 13:49:35 -0400
Received: from redrum.uuid.uk ([2001:8b0:ffea:0:2e0:81ff:fe4d:2bec]:53924 ident=simon)
        by tsort.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@fire.lp0.eu>)
        id 1c0uEe-00014A-Uw
        for linux-btrfs@vger.kernel.org; Sun, 30 Oct 2016 17:49:33 +0000
Subject: Re: Deletion of snapshots with few changes (and quota enabled)
 consumes 2GB+ of memory
To: linux-btrfs@vger.kernel.org
References: <000b8b2c-f90a-a887-0a62-2dce80a78cae@simon.arlott.org.uk>
From: Simon Arlott <simon@fire.lp0.eu>
Message-ID: <b26a8e63-3f34-27c3-e347-697489bff5fd@simon.arlott.org.uk>
Date: Sun, 30 Oct 2016 17:49:31 +0000
MIME-Version: 1.0
In-Reply-To: <000b8b2c-f90a-a887-0a62-2dce80a78cae@simon.arlott.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/10/16 21:44, Simon Arlott wrote:
> I've got 32 snapshots in a 21GB subvolume with 3189 directories and
> 2077439 files. The 24 hour diff between snapshots is only about 5MB.
> The hourly diff between snapshots is about 160-320KB.
> 
> When I start deleting some of the hourly snapshots, the memory usage
> goes up to at least 2GB (and then the VM runs out of memory). If I add
> additional memory it can survive but with high disk I/O and a lot of
> blocked processes.

I've tracked this down to btrfs_qgroup_prepare_account_extents, which is
running out of memory working with 239596..464222+ qgroup extent record
nodes in delayed_refs->dirty_extent_root.

When deleting snapshots for smaller subvolumes it only has to handle
4780 nodes.

Using 4.9.0-rc3 (2a26d99b251b8625d27aed14e97fc10707a3a81f) to run UML
with 256MB of memory it runs out after about 80K nodes:

[  126.010000] btrfs_qgroup_prepare_account_extents nodes=87869/239596
[  126.010000] btrfs-transacti invoked oom-killer: gfp_mask=0x2400840(GFP_NOFS|__GFP_NOFAIL), nodemask=0, order=0, oom_score_adj=0
[  126.010000] btrfs-transacti cpuset=/ mems_allowed=0
[  126.010000] CPU: 0 PID: 123 Comm: btrfs-transacti Tainted: G        W       4.9.0-rc3+ #63
[  126.010000] Stack:
[  126.010000]  7022b540 60071a02 7022b550 7022b760
[  126.010000]  600a55d7 603faaa0 7022b550 602b766f
[  126.010000]  7022b5e0 600e9b87 00000000 00000000
[  126.010000] Call Trace:
[  126.010000]  [<600a55d7>] ? [  126.010000] printk+0x0/0x94
 [<6001c20b>] [  126.010000] show_stack+0xdb/0x1a0
 [<60071a02>] ? [  126.010000] dump_stack_print_info+0xd2/0xf0
 [<600a55d7>] ? [  126.020000] printk+0x0/0x94
 [<602b766f>] [  126.020000] dump_stack+0x2a/0x3b
 [<600e9b87>] [  126.020000] dump_header.isra.5+0xa5/0x233
 [<6002c13d>] ? [  126.020000] set_signals+0x2d/0x50
 [<600aea8a>] ? [  126.020000] get_page_from_freelist+0x84a/0x9d0
 [<600ab384>] [  126.020000] out_of_memory.part.7+0xe4/0x3d0
 [<6002c100>] ? [  126.020000] get_signals+0x0/0x10
 [<600ae150>] ? [  126.020000] __zone_watermark_ok+0x0/0xf0
 [<600aba1e>] [  126.020000] out_of_memory+0x6e/0x100
 [<600ae240>] ? [  126.020000] get_page_from_freelist+0x0/0x9d0
 [<600ae150>] ? [  126.020000] __zone_watermark_ok+0x0/0xf0
 [<600ae240>] ? [  126.020000] get_page_from_freelist+0x0/0x9d0
 [<600b00cf>] [  126.020000] __alloc_pages_nodemask+0xe9f/0xfa0
 [<600af180>] ? [  126.020000] gfp_pfmemalloc_allowed+0x0/0xb0
 [<600a7560>] ? [  126.020000] find_get_entry+0x0/0xf0
 [<600a7808>] [  126.020000] pagecache_get_page+0xd8/0x2f0
 [<601c4874>] [  126.020000] alloc_extent_buffer+0x134/0x4a0
 [<601b9180>] ? [  126.020000] btrfs_get_token_64+0x0/0x130
 [<6018f796>] [  126.020000] read_tree_block+0x26/0x70
 [<601c4be0>] ? [  126.020000] free_extent_buffer+0x0/0xb0
 [<601c4be0>] ? [  126.020000] free_extent_buffer+0x0/0xb0
 [<601681fb>] [  126.020000] read_block_for_search.isra.16+0x17b/0x3b0
 [<6016adef>] [  126.020000] btrfs_search_slot+0x62f/0xde0
 [<6016bb56>] [  126.020000] btrfs_search_old_slot+0x5b6/0xcc0
 [<600e4e8b>] ? [  126.020000] kmem_cache_alloc+0xbb/0x150
 [<60218e04>] ? [  126.020000] ulist_alloc+0x24/0x70
 [<6021510d>] [  126.020000] __resolve_indirect_refs+0x1ad/0x980
 [<600e4e8b>] ? [  126.020000] kmem_cache_alloc+0xbb/0x150
 [<60215920>] ? [  126.020000] __add_prelim_ref.part.1+0x40/0x120
 [<601c4c2b>] ? [  126.020000] free_extent_buffer+0x4b/0xb0
 [<60214970>] ? [  126.020000] __merge_refs+0x0/0x150
 [<6018f770>] ? [  126.020000] read_tree_block+0x0/0x70
 [<602166a5>] [  126.020000] find_parent_nodes+0xca5/0x19d0
 [<60216673>] ? [  126.020000] find_parent_nodes+0xc73/0x19d0
 [<601c5360>] ? [  126.020000] read_extent_buffer+0x0/0x140
 [<6002c100>] ? [  126.020000] get_signals+0x0/0x10
 [<600e5b08>] ? [  126.020000] kfree+0x118/0x1e0
 [<60217500>] ? [  126.020000] __btrfs_find_all_roots+0x130/0x140
 [<60218e04>] ? [  126.020000] ulist_alloc+0x24/0x70
 [<60215a00>] ? [  126.020000] find_parent_nodes+0x0/0x19d0
 [<60219190>] ? [  126.020000] ulist_next+0x0/0x50
 [<6021748f>] [  126.020000] __btrfs_find_all_roots+0xbf/0x140
 [<60164b29>] ? [  126.020000] btrfs_free_path+0x39/0x50
 [<60217530>] ? [  126.020000] btrfs_find_all_roots+0x0/0x90
 [<600a55d7>] ? [  126.020000] printk+0x0/0x94
 [<6021759c>] [  126.020000] btrfs_find_all_roots+0x6c/0x90
 [<6021bc6a>] [  126.020000] btrfs_qgroup_prepare_account_extents+0xba/0x160
 [<60179340>] ? [  126.020000] btrfs_trans_release_metadata+0x0/0x90
 [<6017f740>] ? [  126.020000] btrfs_run_delayed_refs+0x0/0x390
 [<60199936>] [  126.020000] btrfs_commit_transaction.part.13+0x3f6/0xd50
 [<60068790>] ? [  126.020000] prepare_to_wait_event+0x0/0x110
 [<60068300>] ? [  126.020000] autoremove_wake_function+0x0/0x40
 [<60313650>] ? [  126.020000] mutex_lock+0x0/0x30
 [<6019a2d7>] [  126.020000] btrfs_commit_transaction+0x47/0xa0
 [<60058f10>] ? [  126.020000] kthread_should_stop+0x0/0x30
 [<60193807>] [  126.020000] transaction_kthread+0x1f7/0x210
 [<60193610>] ? [  126.020000] transaction_kthread+0x0/0x210
 [<600683b0>] ? [  126.020000] __init_waitqueue_head+0x0/0x10
 [<60193610>] ? [  126.020000] transaction_kthread+0x0/0x210
 [<600683b0>] ? [  126.020000] __init_waitqueue_head+0x0/0x10
 [<600589a2>] [  126.020000] kthread+0x112/0x140
 [<6002c0ef>] ? [  126.020000] unblock_signals+0x1f/0x30
 [<6005e3a7>] ? [  126.020000] finish_task_switch+0x57/0x160
 [<60060875>] ? [  126.020000] schedule_tail+0x15/0xc0
 [<6001aaa1>] [  126.020000] new_thread_handler+0x81/0xb0
[  126.020000] 
[  126.020000] Mem-Info:
[  126.020000] active_anon:124 inactive_anon:0 isolated_anon:0
[  126.020000]  active_file:1162 inactive_file:1124 isolated_file:32
[  126.020000]  unevictable:0 dirty:1028 writeback:0 unstable:0
[  126.020000]  slab_reclaimable:360 slab_unreclaimable:50575
[  126.020000]  mapped:1 shmem:0 pagetables:14 bounce:0
[  126.020000]  free:764 free_pcp:18 free_cma:0
[  126.020000] Node 0 active_anon:496kB inactive_anon:0kB active_file:4648kB inactive_file:4496kB unevictable:0kB isolated(anon):0kB isolated(file):128kB mapped:4kB dirty:4112kB writeback:0kB shmem:0kB writeback_tmp:0kB unstable:0kB pages_scanned:37019 all_unreclaimable? yes
[  126.020000] Normal free:3056kB min:2008kB low:2508kB high:3008kB active_anon:496kB inactive_anon:0kB active_file:4648kB inactive_file:4496kB unevictable:0kB writepending:4112kB present:279180kB managed:252356kB mlocked:0kB slab_reclaimable:1440kB slab_unreclaimable:202300kB kernel_stack:488kB pagetables:56kB bounce:0kB free_pcp:72kB local_pcp:72kB free_cma:0kB
[  126.020000] lowmem_reserve[]: 0 0
[  126.020000] Normal: 32*4kB (H) 34*8kB (H) 18*16kB (H) 14*32kB (H) 10*64kB (H) 6*128kB (H) 2*256kB (H) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3056kB
2320 total pagecache pages
[  126.020000] 69795 pages RAM
[  126.020000] 0 pages HighMem/MovableOnly
[  126.020000] 6706 pages reserved
[  126.020000] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[  126.020000] Kernel panic - not syncing: Out of memory and no killable processes...

-- 
Simon Arlott
