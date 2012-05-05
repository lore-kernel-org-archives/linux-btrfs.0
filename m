From: Alexey Shvetsov <alexxy@gentoo.org>
Subject: [linux-3.4] WARNING: at fs/btrfs/extent-tree.c:6219
 =?UTF-8?Q?btrfs=5Falloc=5Ffree=5Fblock+=30x=33=35=34/=30x=33=36=30=28=29?=
Date: Sat, 05 May 2012 21:37:01 +0300
Message-ID: <98ab61fb6c0f3db4f060f9cd970ba382@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

Under high i/o load i always get many this warnings

WARNING: at fs/btrfs/extent-tree.c:6219 
btrfs_alloc_free_block+0x354/0x360()
btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6219 
btrfs_alloc_free_block+0x354/0x360()
Hardware name: EP45-DS4
Modules linked in:
Hardware name: EP45-DS4
  tun ath5k ath
Modules linked in: i2c_i801 tun
Pid: 31233, comm: btrfs-endio-wri Tainted: G        W    
3.4.0-rc5-gentoo #2
  ath5k ath i2c_i801
Pid: 30807, comm: btrfs-endio-wri Tainted: G        W    
3.4.0-rc5-gentoo #2
Call Trace:
Call Trace:
  [<ffffffff8104779a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff8104779a>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff810477e5>] warn_slowpath_null+0x15/0x20
  [<ffffffff810477e5>] warn_slowpath_null+0x15/0x20
  [<ffffffff813254a4>] btrfs_alloc_free_block+0x354/0x360
  [<ffffffff813254a4>] btrfs_alloc_free_block+0x354/0x360
  [<ffffffff81359c94>] ? read_extent_buffer+0xb4/0x110
  [<ffffffff81070121>] ? get_parent_ip+0x11/0x50
  [<ffffffff81359c94>] ? read_extent_buffer+0xb4/0x110
  [<ffffffff810dd67a>] ? activate_page+0x8a/0xd0
  [<ffffffff813139f0>] __btrfs_cow_block+0x130/0x4d0
  [<ffffffff81a72495>] ? _raw_spin_unlock+0x15/0x40
  [<ffffffff81313e87>] btrfs_cow_block+0xf7/0x1b0
  [<ffffffff813139f0>] __btrfs_cow_block+0x130/0x4d0
  [<ffffffff81317bf9>] btrfs_search_slot+0x199/0x920
  [<ffffffff8132996f>] btrfs_lookup_csum+0x6f/0x170
  [<ffffffff81313e87>] btrfs_cow_block+0xf7/0x1b0
  [<ffffffff81317bf9>] btrfs_search_slot+0x199/0x920
  [<ffffffff811105c7>] ? kmem_cache_alloc+0x97/0xb0
  [<ffffffff8132996f>] btrfs_lookup_csum+0x6f/0x170
  [<ffffffff811105c7>] ? kmem_cache_alloc+0x97/0xb0
  [<ffffffff8132aa6c>] btrfs_csum_file_blocks+0xac/0x6a0
  [<ffffffff8132aa6c>] btrfs_csum_file_blocks+0xac/0x6a0
  [<ffffffff813381dd>] add_pending_csums.isra.44+0x3d/0x60
  [<ffffffff8133ac3a>] btrfs_finish_ordered_io+0x26a/0x3b0
  [<ffffffff8133ad95>] btrfs_writepage_end_io_hook+0x15/0x20
  [<ffffffff813381dd>] add_pending_csums.isra.44+0x3d/0x60
  [<ffffffff8133ac3a>] btrfs_finish_ordered_io+0x26a/0x3b0
  [<ffffffff81356948>] end_extent_writepage+0x58/0x100
  [<ffffffff811512fa>] ? bio_free+0x5a/0x60
  [<ffffffff8133ad95>] btrfs_writepage_end_io_hook+0x15/0x20
  [<ffffffff81356a54>] end_bio_extent_writepage+0x64/0x90
  [<ffffffff81150158>] bio_endio+0x18/0x30
  [<ffffffff8132d45c>] end_workqueue_fn+0x3c/0x50
  [<ffffffff81356948>] end_extent_writepage+0x58/0x100
  [<ffffffff811512fa>] ? bio_free+0x5a/0x60
  [<ffffffff81363908>] worker_loop+0x148/0x560
  [<ffffffff81356a54>] end_bio_extent_writepage+0x64/0x90
  [<ffffffff81150158>] bio_endio+0x18/0x30
  [<ffffffff81a714e8>] ? preempt_schedule+0x48/0x60
  [<ffffffff813637c0>] ? btrfs_queue_worker+0x300/0x300
  [<ffffffff8132d45c>] end_workqueue_fn+0x3c/0x50
  [<ffffffff81363908>] worker_loop+0x148/0x560
  [<ffffffff810637fe>] kthread+0x8e/0xa0
  [<ffffffff813637c0>] ? btrfs_queue_worker+0x300/0x300
  [<ffffffff810637fe>] kthread+0x8e/0xa0
  [<ffffffff81a747a4>] kernel_thread_helper+0x4/0x10
  [<ffffffff81a747a4>] kernel_thread_helper+0x4/0x10
  [<ffffffff81063770>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff81063770>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff81a747a0>] ? gs_change+0x13/0x13
---[ end trace 0cba9c497fa7913f ]---
  [<ffffffff81a747a0>] ? gs_change+0x13/0x13
---[ end trace 0cba9c497fa79140 ]---


-- 
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear Physics Institute, NRC Kurchatov Institute, 
Gatchina, Russia
Department of Molecular and Radiation Biophysics
Gentoo Team Ru
Gentoo Linux Dev
mailto:alexxyum@gmail.com
mailto:alexxy@gentoo.org
mailto:alexxy@omrb.pnpi.spb.ru
