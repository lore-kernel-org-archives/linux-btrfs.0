Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44028 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaJRPwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 11:52:35 -0400
Received: by mail-pd0-f170.google.com with SMTP id p10so2432626pdj.15
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Oct 2014 08:52:35 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Poll: time to switch skinny-metadata on by default?
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <54427383.6050104@fb.com>
Date: Sat, 18 Oct 2014 23:52:20 +0800
Cc: Petr Janecek <janecek@ucw.cz>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Message-Id: <EB5E882A-A370-40CC-BECE-5451088980EC@gmail.com>
References: <20141017123036.GA8052@atrey.karlin.mff.cuni.cz> <54415F1C.1060902@fb.com> <20141018112121.GB17403@atrey.karlin.mff.cuni.cz> <54427383.6050104@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

With Skinny metadta and i running your btrfs-next repo for-suse branch
(which has extent ref patch), i hit following problem:

[  250.679705] BTRFS info (device sdb): relocating block group 35597058048 flags 36                                                                                                                        
[  250.728815] BTRFS info (device sdb): relocating block group 35462840320 flags 36
[  253.562133] Dropping a ref for a root that doesn't have a ref on the block
[  253.562475] Dumping block entry [34793177088 8192], num_refs 3, metadata 0
[  253.562795]   Ref root 0, parent 35532013568, owner 23988, offset 0, num_refs 18446744073709551615
[  253.563126]   Ref root 0, parent 35560964096, owner 23988, offset 0, num_refs 1
[  253.563505]   Ref root 0, parent 35654615040, owner 23988, offset 0, num_refs 1
[  253.563837]   Ref root 0, parent 35678650368, owner 23988, offset 0, num_refs 1
[  253.564162]   Root entry 5, num_refs 1
[  253.564520]   Root entry 18446744073709551608, num_refs 18446744073709551615
[  253.564860]   Ref action 4, root 5, ref_root 5, parent 0, owner 23988, offset 0, num_refs 1
[  253.565205]    [<ffffffffa049d2f1>] process_leaf.isra.6+0x281/0x3e0 [btrfs]
[  253.565225]    [<ffffffffa049de83>] build_ref_tree_for_root+0x433/0x460 [btrfs]
[  253.565234]    [<ffffffffa049e1af>] btrfs_build_ref_tree+0x18f/0x1c0 [btrfs]
[  253.565241]    [<ffffffffa0419ce8>] open_ctree+0x18b8/0x21a0 [btrfs]
[  253.565247]    [<ffffffffa03ecb0e>] btrfs_mount+0x62e/0x8b0 [btrfs]
[  253.565251]    [<ffffffff812324e9>] mount_fs+0x39/0x1b0
[  253.565255]    [<ffffffff8125285b>] vfs_kern_mount+0x6b/0x150
[  253.565257]    [<ffffffff8125565b>] do_mount+0x27b/0xc30
[  253.565259]    [<ffffffff81256356>] SyS_mount+0x96/0xf0
[  253.565260]    [<ffffffff81795429>] system_call_fastpath+0x16/0x1b
[  253.565263]    [<ffffffffffffffff>] 0xffffffffffffffff
[  253.565272]   Ref action 1, root 18446744073709551608, ref_root 0, parent 35654615040, owner 23988, offset 0, num_refs 1
[  253.565681]    [<ffffffffa049d564>] btrfs_ref_tree_mod+0x114/0x570 [btrfs]
[  253.565692]    [<ffffffffa03f946b>] btrfs_inc_extent_ref+0x6b/0x120 [btrfs]
[  253.565697]    [<ffffffffa03fb77c>] __btrfs_mod_ref+0x16c/0x2b0 [btrfs]
[  253.565702]    [<ffffffffa0401504>] btrfs_inc_ref+0x14/0x20 [btrfs]
[  253.565707]    [<ffffffffa03f05ff>] update_ref_for_cow+0x15f/0x380 [btrfs]
[  253.565711]    [<ffffffffa03f0a3d>] __btrfs_cow_block+0x21d/0x540 [btrfs]
[  253.565716]    [<ffffffffa03f0f0c>] btrfs_cow_block+0x12c/0x290 [btrfs]
[  253.565721]    [<ffffffffa046f59c>] do_relocation+0x49c/0x570 [btrfs]
[  253.565728]    [<ffffffffa04723ce>] relocate_tree_blocks+0x60e/0x660 [btrfs]
[  253.565735]    [<ffffffffa0473ce7>] relocate_block_group+0x407/0x690 [btrfs]
[  253.565741]    [<ffffffffa0474148>] btrfs_relocate_block_group+0x1d8/0x2f0 [btrfs]
[  253.565746]    [<ffffffffa04455a7>] btrfs_relocate_chunk.isra.30+0x77/0x800 [btrfs]
[  253.565753]    [<ffffffffa0448a8b>] __btrfs_balance+0x4eb/0x8d0 [btrfs]
[  253.565760]    [<ffffffffa044928a>] btrfs_balance+0x41a/0x720 [btrfs]
[  253.565766]    [<ffffffffa045112a>] btrfs_ioctl_balance+0x16a/0x530 [btrfs]
[  253.565772]    [<ffffffffa0456df8>] btrfs_ioctl+0x588/0x2cb0 [btrfs]
[  253.565779]   Ref action 1, root 18446744073709551608, ref_root 0, parent 35560964096, owner 23988, offset 0, num_refs 1
[  253.566143]    [<ffffffffa049d564>] btrfs_ref_tree_mod+0x114/0x570 [btrfs]
[  253.566152]    [<ffffffffa03f946b>] btrfs_inc_extent_ref+0x6b/0x120 [btrfs]
[  253.566180]    [<ffffffffa03fb77c>] __btrfs_mod_ref+0x16c/0x2b0 [btrfs]
[  253.566186]    [<ffffffffa0401504>] btrfs_inc_ref+0x14/0x20 [btrfs]
[  253.566191]    [<ffffffffa03f071b>] update_ref_for_cow+0x27b/0x380 [btrfs]
[  253.566195]    [<ffffffffa03f0a3d>] __btrfs_cow_block+0x21d/0x540 [btrfs]
[  253.566199]    [<ffffffffa03f0f0c>] btrfs_cow_block+0x12c/0x290 [btrfs]
[  253.566203]    [<ffffffffa046f59c>] do_relocation+0x49c/0x570 [btrfs]
[  253.566210]    [<ffffffffa04723ce>] relocate_tree_blocks+0x60e/0x660 [btrfs]
[  253.566216]    [<ffffffffa0473ce7>] relocate_block_group+0x407/0x690 [btrfs]
[  253.566222]    [<ffffffffa0474148>] btrfs_relocate_block_group+0x1d8/0x2f0 [btrfs]
[  253.566227]    [<ffffffffa04455a7>] btrfs_relocate_chunk.isra.30+0x77/0x800 [btrfs]
[  253.566233]    [<ffffffffa0448a8b>] __btrfs_balance+0x4eb/0x8d0 [btrfs]
[  253.566240]    [<ffffffffa044928a>] btrfs_balance+0x41a/0x720 [btrfs]
[  253.566245]    [<ffffffffa045112a>] btrfs_ioctl_balance+0x16a/0x530 [btrfs]
[  253.566252]    [<ffffffffa0456df8>] btrfs_ioctl+0x588/0x2cb0 [btrfs]
[  253.566258]   Ref action 2, root 18446744073709551608, ref_root 5, parent 0, owner 23988, offset 0, num_refs 18446744073709551615
[  253.566641]    [<ffffffffa049d710>] btrfs_ref_tree_mod+0x2c0/0x570 [btrfs]
[  253.566651]    [<ffffffffa040404a>] btrfs_free_extent+0x7a/0x180 [btrfs]
[  253.566657]    [<ffffffffa03fb77c>] __btrfs_mod_ref+0x16c/0x2b0 [btrfs]
[  253.566662]    [<ffffffffa0401521>] btrfs_dec_ref+0x11/0x20 [btrfs]
[  253.566668]    [<ffffffffa03f07a8>] update_ref_for_cow+0x308/0x380 [btrfs]

Below is my Test scrips:

#!/bin/bash
DEVICE=/dev/sdb
TEST_MNT=/mnt
SLEEP=3

function run_snapshots()
{
	i=1
	while [ 1 ]
	do
		btrfs sub snapshot $TEST_MNT $TEST_MNT/snap_$i
		a=$(($i%10))
		if [ $a -eq 0 ]; then
			btrfs sub delete *
		fi
		((i++))
		sleep $SLEEP
	done
}

function run_compiling()
{
	while [ 1 ]
	do
		make -j4 -C $TEST_MNT/linux-btrfs
		make -C $TEST_MNT/linux-btrfs clean
	done
}

function run_balance()
{
	while [ 1 ]
	do
		btrfs balance start $TEST_MNT
		sleep $SLEEP
	done
}

run_snapshots &
run_compiling &
run_balance &

——cut—

Mount options:
/dev/sdb /mnt btrfs rw,relatime,space_cache 0 0

Here my /dev/sdb is 10G, and before comping kernel,run ‘make allmodconfig’
Above tests maybe detect more problem， after running a while, system seems
blocked, echo w > /proc/sysrq-trigger

[ 1970.909512] SysRq : Show Blocked State                                                                                                                                                             
   2 [ 1970.910490]   task                        PC stack   pid father
   3 [ 1970.910564] kworker/u128:9  D ffff880208a89a30     0  3514      2 0x00000080
   4 [ 1970.910587] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
   5 [ 1970.910590]  ffff8800b3dab8e8 0000000000000046 ffff8800b3dabfd8 00000000001d59c0
   6 [ 1970.910594]  00000000001d59c0 ffff880208a89a30 ffff8801f71c3460 ffff8802303d6360
   7 [ 1970.910597]  ffff88023ff509a8 ffff8800b3dab978 0000000000000002 ffffffff8178eda0
   8 [ 1970.910600] Call Trace:
   9 [ 1970.910606]  [<ffffffff8178eda0>] ? bit_wait+0x50/0x50
  10 [ 1970.910609]  [<ffffffff8178e56d>] io_schedule+0x9d/0x130
  11 [ 1970.910612]  [<ffffffff8178edcc>] bit_wait_io+0x2c/0x50
  12 [ 1970.910614]  [<ffffffff8178eb3b>] __wait_on_bit_lock+0x4b/0xb0
  13 [ 1970.910619]  [<ffffffff811aa2ef>] __lock_page+0xbf/0xe0
  14 [ 1970.910623]  [<ffffffff810caa90>] ? autoremove_wake_function+0x40/0x40
  15 [ 1970.910642]  [<ffffffffa043d9d0>] extent_write_cache_pages.isra.30.constprop.52+0x410/0x440 [btrfs]
  16 [ 1970.910645]  [<ffffffff810d6a46>] ? __lock_acquire+0x396/0xbe0
  17 [ 1970.910648]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
  18 [ 1970.910661]  [<ffffffffa043f92c>] extent_writepages+0x5c/0x90 [btrfs]
  19 [ 1970.910672]  [<ffffffffa04216a0>] ? btrfs_submit_direct+0x6b0/0x6b0 [btrfs]
  20 [ 1970.910674]  [<ffffffff810b7174>] ? local_clock+0x24/0x30
  21 [ 1970.910685]  [<ffffffffa041f008>] btrfs_writepages+0x28/0x30 [btrfs]
  22 [ 1970.910688]  [<ffffffff811b8a21>] do_writepages+0x21/0x50
  23 [ 1970.910692]  [<ffffffff8125f920>] __writeback_single_inode+0x40/0x540
  24 [ 1970.910694]  [<ffffffff81260425>] writeback_sb_inodes+0x275/0x520
  25 [ 1970.910697]  [<ffffffff8126076f>] __writeback_inodes_wb+0x9f/0xd0
  26 [ 1970.910700]  [<ffffffff81260a53>] wb_writeback+0x2b3/0x550
  27 [ 1970.910702]  [<ffffffff811b7e90>] ? bdi_dirty_limit+0x40/0xe0
  28 [ 1970.910705]  [<ffffffff812610d8>] bdi_writeback_workfn+0x1f8/0x650
  29 [ 1970.910711]  [<ffffffff8109c684>] process_one_work+0x1c4/0x640
  30 [ 1970.910713]  [<ffffffff8109c624>] ? process_one_work+0x164/0x640
  31 [ 1970.910716]  [<ffffffff8109cc1b>] worker_thread+0x11b/0x490
  32 [ 1970.910718]  [<ffffffff8109cb00>] ? process_one_work+0x640/0x640
  33 [ 1970.910721]  [<ffffffff810a2f1f>] kthread+0xff/0x120
  34 [ 1970.910724]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
  35 [ 1970.910727]  [<ffffffff810a2e20>] ? kthread_create_on_node+0x250/0x250
  36 [ 1970.910730]  [<ffffffff8179537c>] ret_from_fork+0x7c/0xb0
  37 [ 1970.910732]  [<ffffffff810a2e20>] ? kthread_create_on_node+0x250/0x250
  38 [ 1970.910737] kworker/u128:20 D ffff8801f71c3460     0  8244      2 0x00000080
  39 [ 1970.910752] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper [btrfs]
  40 [ 1970.910754]  ffff88020aa2b640 0000000000000046 ffff88020aa2bfd8 00000000001d59c0
  41 [ 1970.910757]  00000000001d59c0 ffff8801f71c3460 ffff880225e93460 7fffffffffffffff
  42 [ 1970.910760]  ffff880035763520 ffff880035763518 ffff880225e93460 ffff880201c44000
  43 [ 1970.910763] Call Trace:
  44 [ 1970.910766]  [<ffffffff8178e209>] schedule+0x29/0x70
  45 [ 1970.910769]  [<ffffffff81793621>] schedule_timeout+0x281/0x460
  46 [ 1970.910772]  [<ffffffff810d47d5>] ? mark_held_locks+0x75/0xa0
  47 [ 1970.910775]  [<ffffffff817946ac>] ? _raw_spin_unlock_irq+0x2c/0x40
  48 [ 1970.910777]  [<ffffffff8178f89c>] wait_for_completion+0xfc/0x140
  49 [ 1970.910780]  [<ffffffff810b31c0>] ? wake_up_state+0x20/0x20
  50 [ 1970.910790]  [<ffffffffa0400ff7>] btrfs_async_run_delayed_refs+0x127/0x150 [btrfs]
  51 [ 1970.910802]  [<ffffffffa041d0c8>] __btrfs_end_transaction+0x208/0x390 [btrfs]
  52 [ 1970.910811]  [<ffffffffa041d260>] btrfs_end_transaction+0x10/0x20 [btrfs]
  53 [ 1970.910821]  [<ffffffffa042365b>] cow_file_range_inline+0x49b/0x5e0 [btrfs]
  54 [ 1970.910824]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
  55 [ 1970.910833]  [<ffffffffa0423aa3>] cow_file_range+0x303/0x450 [btrfs]
  56 [ 1970.910836]  [<ffffffff817945b7>] ? _raw_spin_unlock+0x27/0x40
  57 [ 1970.910845]  [<ffffffffa0424a88>] run_delalloc_range+0x338/0x370 [btrfs]
  58 [ 1970.910857]  [<ffffffffa043c5e9>] ? find_lock_delalloc_range+0x1e9/0x210 [btrfs]
  59 [ 1970.910859]  [<ffffffff810d6a46>] ? __lock_acquire+0x396/0xbe0
  60 [ 1970.910870]  [<ffffffffa043c72c>] writepage_delalloc.isra.34+0x11c/0x180 [btrfs]
  61 [ 1970.910880]  [<ffffffffa043d2fa>] __extent_writepage+0xca/0x390 [btrfs]
  62 [ 1970.910883]  [<ffffffff811b6f49>] ? clear_page_dirty_for_io+0xc9/0x110
[ 1970.910893]  [<ffffffffa043d93a>] extent_write_cache_pages.isra.30.constprop.52+0x37a/0x440 [btrfs]
  64 [ 1970.910895]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
  65 [ 1970.910898]  [<ffffffff81024f39>] ? sched_clock+0x9/0x10
  66 [ 1970.910900]  [<ffffffff810b7175>] ? local_clock+0x25/0x30
  67 [ 1970.910909]  [<ffffffffa043f92c>] extent_writepages+0x5c/0x90 [btrfs]
  68 [ 1970.910918]  [<ffffffffa04216a0>] ? btrfs_submit_direct+0x6b0/0x6b0 [btrfs]
  69 [ 1970.910928]  [<ffffffffa041f008>] btrfs_writepages+0x28/0x30 [btrfs]
  70 [ 1970.910930]  [<ffffffff811b8a21>] do_writepages+0x21/0x50
  71 [ 1970.910933]  [<ffffffff811ac7dd>] __filemap_fdatawrite_range+0x5d/0x80
  72 [ 1970.910936]  [<ffffffff811ac8ac>] filemap_flush+0x1c/0x20
  73 [ 1970.910945]  [<ffffffffa042271a>] btrfs_run_delalloc_work+0x5a/0xa0 [btrfs]
  74 [ 1970.910956]  [<ffffffffa044ec1f>] normal_work_helper+0x13f/0x5c0 [btrfs]
  75 [ 1970.910966]  [<ffffffffa044f0f2>] btrfs_flush_delalloc_helper+0x12/0x20 [btrfs]
  76 [ 1970.910969]  [<ffffffff8109c684>] process_one_work+0x1c4/0x640
  77 [ 1970.910971]  [<ffffffff8109c624>] ? process_one_work+0x164/0x640
  78 [ 1970.910976]  [<ffffffff8109cc1b>] worker_thread+0x11b/0x490
  79 [ 1970.910978]  [<ffffffff8109cb00>] ? process_one_work+0x640/0x640
  80 [ 1970.910981]  [<ffffffff810a2f1f>] kthread+0xff/0x120
  81 [ 1970.910983]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
  82 [ 1970.910986]  [<ffffffff810a2e20>] ? kthread_create_on_node+0x250/0x250
  83 [ 1970.910988]  [<ffffffff8179537c>] ret_from_fork+0x7c/0xb0
  84 [ 1970.910991]  [<ffffffff810a2e20>] ? kthread_create_on_node+0x250/0x250
  85 [ 1970.910997] btrfs           D ffff88022beab460     0 62979   2587 0x00000080
  86 [ 1970.911000]  ffff880054083870 0000000000000046 ffff880054083fd8 00000000001d59c0
  87 [ 1970.911004]  00000000001d59c0 ffff88022beab460 ffff88017f740000 7fffffffffffffff
  88 [ 1970.911007]  ffff8800546a9520 ffff8800546a9518 ffff88017f740000 ffff880201c44000
  89 [ 1970.911010] Call Trace:
  90 [ 1970.911012]  [<ffffffff8178e209>] schedule+0x29/0x70
  91 [ 1970.911015]  [<ffffffff81793621>] schedule_timeout+0x281/0x460
  92 [ 1970.911018]  [<ffffffff810d47d5>] ? mark_held_locks+0x75/0xa0
  93 [ 1970.911021]  [<ffffffff817946ac>] ? _raw_spin_unlock_irq+0x2c/0x40
  94 [ 1970.911023]  [<ffffffff8178f89c>] wait_for_completion+0xfc/0x140
  95 [ 1970.911026]  [<ffffffff810b31c0>] ? wake_up_state+0x20/0x20
  96 [ 1970.911035]  [<ffffffffa0400ff7>] btrfs_async_run_delayed_refs+0x127/0x150 [btrfs]
  97 [ 1970.911047]  [<ffffffffa041d0c8>] __btrfs_end_transaction+0x208/0x390 [btrfs]
  98 [ 1970.911059]  [<ffffffffa041e0c3>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
  99 [ 1970.911073]  [<ffffffffa0473cfe>] relocate_block_group+0x41e/0x690 [btrfs]
 100 [ 1970.911086]  [<ffffffffa0474148>] btrfs_relocate_block_group+0x1d8/0x2f0 [btrfs]
 101 [ 1970.911100]  [<ffffffffa04455a7>] btrfs_relocate_chunk.isra.30+0x77/0x800 [btrfs]
 102 [ 1970.911102]  [<ffffffff81024f39>] ? sched_clock+0x9/0x10
 103 [ 1970.911105]  [<ffffffff810b7175>] ? local_clock+0x25/0x30
 104 [ 1970.911118]  [<ffffffffa0435568>] ? btrfs_get_token_64+0x68/0x100 [btrfs]
 105 [ 1970.911132]  [<ffffffffa0448a8b>] __btrfs_balance+0x4eb/0x8d0 [btrfs]
 106 [ 1970.911146]  [<ffffffffa044928a>] btrfs_balance+0x41a/0x720 [btrfs]
 107 [ 1970.911159]  [<ffffffffa045112a>] ? btrfs_ioctl_balance+0x16a/0x530 [btrfs]
 108 [ 1970.911172]  [<ffffffffa045112a>] btrfs_ioctl_balance+0x16a/0x530 [btrfs]
 109 [ 1970.911186]  [<ffffffffa0456df8>] btrfs_ioctl+0x588/0x2cb0 [btrfs]
 110 [ 1970.911189]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
 111 [ 1970.911191]  [<ffffffff81024f39>] ? sched_clock+0x9/0x10
 112 [ 1970.911194]  [<ffffffff810b7175>] ? local_clock+0x25/0x30
 113 [ 1970.911197]  [<ffffffff810cfe7f>] ? up_read+0x1f/0x40
 114 [ 1970.911200]  [<ffffffff81067a84>] ? __do_page_fault+0x254/0x5b0
 115 [ 1970.911202]  [<ffffffff810d6a46>] ? __lock_acquire+0x396/0xbe0
 116 [ 1970.911206]  [<ffffffff81243830>] do_vfs_ioctl+0x300/0x520
 117 [ 1970.911209]  [<ffffffff8124fc6d>] ? __fget_light+0x13d/0x160
 118 [ 1970.911212]  [<ffffffff81243ad1>] SyS_ioctl+0x81/0xa0
 119 [ 1970.911217]  [<ffffffff8114a49c>] ? __audit_syscall_entry+0x9c/0xf0
 120 [ 1970.911220]  [<ffffffff81795429>] system_call_fastpath+0x16/0x1b
[ 1970.911217]  [<ffffffff8114a49c>] ? __audit_syscall_entry+0x9c/0xf0                                                                                                                                 
 120 [ 1970.911220]  [<ffffffff81795429>] system_call_fastpath+0x16/0x1b
 121 [ 1970.911228] as              D ffff880225e93460     0  6423   6421 0x00000080
 122 [ 1970.911231]  ffff880049657ad0 0000000000000046 ffff880049657fd8 00000000001d59c0
 123 [ 1970.911235]  00000000001d59c0 ffff880225e93460 ffff880225631a30 7fffffffffffffff
 124 [ 1970.911238]  ffff880035762b20 ffff880035762b18 ffff880225631a30 ffff880201c44000
 125 [ 1970.911241] Call Trace:
 126 [ 1970.911244]  [<ffffffff8178e209>] schedule+0x29/0x70
 127 [ 1970.911247]  [<ffffffff81793621>] schedule_timeout+0x281/0x460
 128 [ 1970.911250]  [<ffffffff810d47d5>] ? mark_held_locks+0x75/0xa0
 129 [ 1970.911252]  [<ffffffff817946ac>] ? _raw_spin_unlock_irq+0x2c/0x40
 130 [ 1970.911255]  [<ffffffff8178f89c>] wait_for_completion+0xfc/0x140
 131 [ 1970.911258]  [<ffffffff810b31c0>] ? wake_up_state+0x20/0x20
 132 [ 1970.911268]  [<ffffffffa0400ff7>] btrfs_async_run_delayed_refs+0x127/0x150 [btrfs]
 133 [ 1970.911280]  [<ffffffffa041d0c8>] __btrfs_end_transaction+0x208/0x390 [btrfs]
 134 [ 1970.911292]  [<ffffffffa041d260>] btrfs_end_transaction+0x10/0x20 [btrfs]
 135 [ 1970.911304]  [<ffffffffa0423088>] btrfs_dirty_inode+0x78/0xe0 [btrfs]
 136 [ 1970.911307]  [<ffffffff8124cf55>] ? touch_atime+0xf5/0x160
 137 [ 1970.911319]  [<ffffffffa0423154>] btrfs_update_time+0x64/0xd0 [btrfs]
 138 [ 1970.911321]  [<ffffffff8124cdb5>] update_time+0x25/0xd0
 139 [ 1970.911323]  [<ffffffff8124cf79>] touch_atime+0x119/0x160
 140 [ 1970.911327]  [<ffffffff811acf34>] generic_file_read_iter+0x5f4/0x660
 141 [ 1970.911330]  [<ffffffff810d47d5>] ? mark_held_locks+0x75/0xa0
 142 [ 1970.911332]  [<ffffffff81790ed6>] ? mutex_lock_nested+0x2d6/0x520
 143 [ 1970.911335]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
 144 [ 1970.911338]  [<ffffffff8122d82b>] new_sync_read+0x8b/0xd0
 145 [ 1970.911340]  [<ffffffff8122dfdb>] vfs_read+0x9b/0x180
 146 [ 1970.911343]  [<ffffffff8122ecf8>] SyS_read+0x58/0xd0
 147 [ 1970.911345]  [<ffffffff81795429>] system_call_fastpath+0x16/0x1b
 148 [ 1970.911347] as              D ffff88022bf01a30     0  6433   6431 0x00000080
 149 [ 1970.911351]  ffff88016f3ffad0 0000000000000046 ffff88016f3fffd8 00000000001d59c0
 150 [ 1970.911354]  00000000001d59c0 ffff88022bf01a30 ffff8800ba1a3460 7fffffffffffffff
 151 [ 1970.911419]  ffff88017faa6820 ffff88017faa6818 ffff8800ba1a3460 ffff880201c44000
 152 [ 1970.911423] Call Trace:
 153 [ 1970.911426]  [<ffffffff8178e209>] schedule+0x29/0x70
 154 [ 1970.911429]  [<ffffffff81793621>] schedule_timeout+0x281/0x460
 155 [ 1970.911432]  [<ffffffff810d47d5>] ? mark_held_locks+0x75/0xa0
 156 [ 1970.911435]  [<ffffffff817946ac>] ? _raw_spin_unlock_irq+0x2c/0x40
 157 [ 1970.911438]  [<ffffffff8178f89c>] wait_for_completion+0xfc/0x140
 158 [ 1970.911440]  [<ffffffff810b31c0>] ? wake_up_state+0x20/0x20
 159 [ 1970.911452]  [<ffffffffa0400ff7>] btrfs_async_run_delayed_refs+0x127/0x150 [btrfs]
 160 [ 1970.911464]  [<ffffffffa041d0c8>] __btrfs_end_transaction+0x208/0x390 [btrfs]
 161 [ 1970.911476]  [<ffffffffa041d260>] btrfs_end_transaction+0x10/0x20 [btrfs]
 162 [ 1970.911488]  [<ffffffffa0423088>] btrfs_dirty_inode+0x78/0xe0 [btrfs]
 163 [ 1970.911490]  [<ffffffff8124cf55>] ? touch_atime+0xf5/0x160
 164 [ 1970.911502]  [<ffffffffa0423154>] btrfs_update_time+0x64/0xd0 [btrfs]
 165 [ 1970.911505]  [<ffffffff8124cdb5>] update_time+0x25/0xd0
 166 [ 1970.911507]  [<ffffffff8124cf79>] touch_atime+0x119/0x160
 167 [ 1970.911510]  [<ffffffff811acf34>] generic_file_read_iter+0x5f4/0x660
 168 [ 1970.911513]  [<ffffffff810d47d5>] ? mark_held_locks+0x75/0xa0
 169 [ 1970.911516]  [<ffffffff81790ed6>] ? mutex_lock_nested+0x2d6/0x520
 170 [ 1970.911518]  [<ffffffff81024ec5>] ? native_sched_clock+0x35/0xa0
 171 [ 1970.911521]  [<ffffffff8122d82b>] new_sync_read+0x8b/0xd0
 172 [ 1970.911523]  [<ffffffff8122dfdb>] vfs_read+0x9b/0x180
 173 [ 1970.911526]  [<ffffffff8122ecf8>] SyS_read+0x58/0xd0
 174 [ 1970.911528]  [<ffffffff81795429>] system_call_fastpath+0x16/0x1b
 175 [ 1970.911530] ld              D ffff880225e93460     0  6435   6370 0x00000080
 176 [ 1970.911534]  ffff880049623ad0 0000000000000046 ffff880049623fd8 00000000001d59c0
 177 [ 1970.911537]  00000000001d59c0 ffff880225e93460 ffff8800364b4e90 7fffffffffffffff
 178 [ 1970.911541]  ffff880035762820 ffff880035762818 ffff8800364b4e90 ffff880201c44000
 179 [ 1970.911544] Call Trace:
 180 [ 1970.911547]  [<ffffffff8178e209>] schedule+0x29/0x7

It is easy to reproduce this problem using my scripts…


> On 10/18/2014 07:21 AM, Petr Janecek wrote:
>> Hello,
>> 
>>>>   so far I haven't succeeded running btrfs balance on a large
>>>> skinny-metadata fs -- segfault, kernel bug, reproducible.  No such
>>>> problems on ^skinny-metadata fs (same disks, same data).  Tried both
>>>> several times on 3.17.  More info in comments 10,14 in
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=64961
>>> 
>>> I can't reproduce this, how big is your home directory, and are you
>>> still seeing corruptions after just rsyncing to a clean fs?  Thanks,
>> 
>>   as I wrote in comment 10, it has improved since year ago when I
>> reported it: I see no corruption at all, neither after rsync, nor after
>> balance crash: btrfs check doesn't find anything wrong, files look ok.
>> The only problem is that after adding a disk the balance segfaults on a
>> kernel bug and the fs gets stuck.  When I run balance again after
>> reboot, it makes only a very small progress and crashes again the same
>> way.
>> 
>>   There are some 2.5TB of data in 7.5M files on that fs.  And couple
>> dozen ro snapshots -- I'm testing 3.17 + revert of 9c3b306e1c9e right
>> now, but it takes more than day to copy the data and recreate all the
>> snapshots.  But a test with ^skinny-metadata showed no problems, so I
>> don't thing I got bitten by that bug.
>> 
>>   I have btrfs-image of one of previous runs after crashed balance.
>> It's 15GB. I can place it somewhere with fast link, are you interested?
>> 
>> 
> 
> Yup, send me the link and I'll pull it down.  Thanks,
> 
> Josef
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

