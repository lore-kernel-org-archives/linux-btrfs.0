From: Proskurin Kirill <k.proskurin@corp.mail.ru>
Subject: Re: [btrfs-transacti] & btrfs-endio-wri] - WAS: Re: [btrfs-delalloc-]
Date: Thu, 30 Jun 2011 18:12:19 +0400
Message-ID: <4E0C8443.7070109@corp.mail.ru>
References: <4E084786.2070200@corp.mail.ru> <201106271521.54497.hka@qbs.com.pl> <4E0B46CA.2030205@corp.mail.ru> <4E0B4F67.30702@redhat.com>
Reply-To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060003070403010808000605"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0B4F67.30702@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060003070403010808000605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/29/2011 08:14 PM, Josef Bacik wrote:
>> Ok - I upgrade to 2.6.39-2 but it is seems to all things get worse.
>> Now I see [btrfs-transacti]&  btrfs-endio-wri] 80-100% all the time and
>> io performance looks like lower then before.
>>
>> Our scribe daemon in state D most of the time with half of a normal
>> load. Only kernel was changed.
>>
>> Any performance tune recommendation?
>>
>
> Can you get sysrq+w while this problem is happening so we can see whats
> going on?  Thanks,

I attached sysrq+w. Hope it helps.

-- 
Best regards,
Proskurin Kirill

--------------060003070403010808000605
Content-Type: text/x-log;
 name="dmesg.15.31.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.15.31.log"

SysRq : Show Blocked State
  task                        PC stack   pid father
btrfs-submit-0  D ffff88012f9d4690     0  1018      2 0x00000000
 ffff88012ff99980 0000000000000046 ffff880070f14d68 0000000100000000
 ffff88012f9d4100 0000000000015140 ffff88012ff99fd8 ffff88012ff98010
 ffff88012ff99fd8 0000000000015140 ffff880103076b30 ffff88012f9d4100
Call Trace:
 [<ffffffffa00e5d4c>] get_active_stripe+0x24c/0x4a0 [raid456]
 [<ffffffff814d4c2e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8105af90>] ? try_to_wake_up+0x420/0x420
 [<ffffffffa00e8f63>] make_request+0x1b3/0x470 [raid456]
 [<ffffffff81084c80>] ? wake_up_bit+0x40/0x40
 [<ffffffff813bfe63>] md_make_request+0xd3/0x210
 [<ffffffff810f4b41>] ? __perf_event_task_sched_out+0x31/0x50
 [<ffffffff8121852e>] generic_make_request+0x2be/0x610
 [<ffffffff8100a730>] ? __switch_to+0xd0/0x320
 [<ffffffff8104de98>] ? update_curr+0x108/0x1f0
 [<ffffffff814c99fc>] ? schedule+0x3ec/0x9c0
 [<ffffffff8105c4bb>] ? dequeue_task_fair+0xbb/0xc0
 [<ffffffff81218906>] submit_bio+0x86/0x110
 [<ffffffffa024616a>] run_scheduled_bios+0x27a/0x530 [btrfs]
 [<ffffffffa0246435>] pending_bios_fn+0x15/0x20 [btrfs]
 [<ffffffffa024d424>] worker_loop+0x154/0x460 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffff810845f6>] kthread+0x96/0xa0
 [<ffffffff814d5384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084560>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d5380>] ? gs_change+0x13/0x13
btrfs-transacti D ffff88012f9adab0     0  1027      2 0x00000000
 ffff88012f8a7c20 0000000000000046 ffff88012f8a7bd0 ffff880000000001
 ffff88012f9ad520 0000000000015140 ffff88012f8a7fd8 ffff88012f8a6010
 ffff88012f8a7fd8 0000000000015140 ffff880096805560 ffff88012f9ad520
Call Trace:
 [<ffffffff810fec70>] ? __lock_page+0x70/0x70
 [<ffffffff814ca05c>] io_schedule+0x8c/0xd0
 [<ffffffff810fec7e>] sleep_on_page+0xe/0x20
 [<ffffffff814caa4f>] __wait_on_bit+0x5f/0x90
 [<ffffffff810fee43>] wait_on_page_bit+0x73/0x80
 [<ffffffff81084cd0>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff810ffd6e>] ? find_get_page+0x1e/0xa0
 [<ffffffffa021f66c>] btrfs_wait_marked_extents+0x13c/0x160 [btrfs]
 [<ffffffffa021f84f>] btrfs_write_and_wait_marked_extents+0x3f/0x60 [btrfs]
 [<ffffffffa021f89b>] btrfs_write_and_wait_transaction+0x2b/0x50 [btrfs]
 [<ffffffffa022007d>] btrfs_commit_transaction+0x54d/0x790 [btrfs]
 [<ffffffff81084c80>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0219943>] transaction_kthread+0x273/0x290 [btrfs]
 [<ffffffffa02196d0>] ? btrfs_bio_wq_end_io+0x90/0x90 [btrfs]
 [<ffffffffa02196d0>] ? btrfs_bio_wq_end_io+0x90/0x90 [btrfs]
 [<ffffffff810845f6>] kthread+0x96/0xa0
 [<ffffffff814d5384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084560>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d5380>] ? gs_change+0x13/0x13
flush-btrfs-1   D ffff88013be41040     0  3449      2 0x00000080
 ffff88013b4e9990 0000000000000046 ffff88013b4e9940 ffff880100000001
 ffff88013be40ab0 0000000000015140 ffff88013b4e9fd8 ffff88013b4e8010
 ffff88013b4e9fd8 0000000000015140 ffff880077b13560 ffff88013be40ab0
Call Trace:
 [<ffffffff810fec70>] ? __lock_page+0x70/0x70
 [<ffffffff814ca05c>] io_schedule+0x8c/0xd0
 [<ffffffff810fec7e>] sleep_on_page+0xe/0x20
 [<ffffffff814ca8fa>] __wait_on_bit_lock+0x5a/0xc0
 [<ffffffff810fec67>] __lock_page+0x67/0x70
 [<ffffffff81084cd0>] ? autoremove_wake_function+0x50/0x50
 [<ffffffffa0244d0f>] extent_write_cache_pages.clone.0+0x1ff/0x330 [btrfs]
 [<ffffffffa0244f56>] extent_writepages+0x46/0x60 [btrfs]
 [<ffffffffa022bfa0>] ? btrfs_submit_direct+0x1d0/0x1d0 [btrfs]
 [<ffffffff81084b44>] ? bit_waitqueue+0x14/0xd0
 [<ffffffffa0223967>] btrfs_writepages+0x27/0x30 [btrfs]
 [<ffffffff81109a31>] do_writepages+0x21/0x40
 [<ffffffff81180604>] writeback_single_inode+0xf4/0x230
 [<ffffffff811809cd>] writeback_sb_inodes+0xed/0x1c0
 [<ffffffff81180b39>] writeback_inodes_wb+0x99/0x160
 [<ffffffff81180edb>] wb_writeback+0x2db/0x450
 [<ffffffff8118127c>] wb_do_writeback+0x22c/0x280
 [<ffffffff8118137a>] bdi_writeback_thread+0xaa/0x260
 [<ffffffff811812d0>] ? wb_do_writeback+0x280/0x280
 [<ffffffff811812d0>] ? wb_do_writeback+0x280/0x280
 [<ffffffff810845f6>] kthread+0x96/0xa0
 [<ffffffff814d5384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084560>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d5380>] ? gs_change+0x13/0x13
btrfs-endio-wri D ffff8800b9c75a30     0  5898      2 0x00000080
 ffff8800b99778a0 0000000000000046 ffff8800355b1a90 0000000000000001
 ffff8800b9c754a0 0000000000015140 ffff8800b9977fd8 ffff8800b9976010
 ffff8800b9977fd8 0000000000015140 ffff880096805560 ffff8800b9c754a0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa020605d>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
 [<ffffffffa02112c1>] ? update_block_group+0xe1/0x2b0 [btrfs]
 [<ffffffffa0211723>] alloc_reserved_tree_block+0x73/0x1e0 [btrfs]
 [<ffffffffa02120b7>] run_delayed_tree_ref+0xf7/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa0224e44>] btrfs_finish_ordered_io+0x2a4/0x370 [btrfs]
 [<ffffffffa0224f5e>] btrfs_writepage_end_io_hook+0x4e/0xa0 [btrfs]
 [<ffffffffa025e716>] end_compressed_bio_write+0x86/0xf0 [btrfs]
 [<ffffffff8118b36d>] bio_endio+0x1d/0x40
 [<ffffffffa0219f64>] end_workqueue_fn+0xf4/0x130 [btrfs]
 [<ffffffffa024d424>] worker_loop+0x154/0x460 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffff810845f6>] kthread+0x96/0xa0
 [<ffffffff814d5384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084560>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d5380>] ? gs_change+0x13/0x13
scribed         D ffff8800b998da70     0 10715   5824 0x00000080
 ffff8801088c1218 0000000000000082 0000000000000297 ffff88007fc18058
 ffff8800b998d4e0 0000000000015140 ffff8801088c1fd8 ffff8801088c0010
 ffff8801088c1fd8 0000000000015140 ffffffff81a0b020 ffff8800b998d4e0
Call Trace:
 [<ffffffff810fec70>] ? __lock_page+0x70/0x70
 [<ffffffff814ca05c>] io_schedule+0x8c/0xd0
 [<ffffffff810fec7e>] sleep_on_page+0xe/0x20
 [<ffffffff814caa4f>] __wait_on_bit+0x5f/0x90
 [<ffffffff810fee43>] wait_on_page_bit+0x73/0x80
 [<ffffffff81084cd0>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff812422c1>] ? list_del+0x11/0x40
 [<ffffffff8110fa75>] shrink_page_list+0x385/0x5b0
 [<ffffffff811103d7>] shrink_inactive_list+0x1e7/0x480
 [<ffffffff8110e6ac>] ? free_page_list+0xdc/0xf0
 [<ffffffff81108a0a>] ? determine_dirtyable_memory+0x1a/0x30
 [<ffffffff81110bcb>] shrink_zone+0x20b/0x2c0
 [<ffffffff8111165c>] __zone_reclaim+0x10c/0x2c0
 [<ffffffff81105938>] ? rmqueue_bulk.clone.0+0xa8/0xf0
 [<ffffffff811056c7>] ? prep_new_page+0x127/0x1c0
 [<ffffffff81111927>] zone_reclaim+0x117/0x140
 [<ffffffff81105dbb>] get_page_from_freelist+0x43b/0x570
 [<ffffffff81107bbf>] __alloc_pages_nodemask+0xff/0x1f0
 [<ffffffff8114087a>] alloc_pages_vma+0x9a/0x150
 [<ffffffff81150363>] do_huge_pmd_anonymous_page+0x143/0x210
 [<ffffffff81124e68>] handle_mm_fault+0x158/0x360
 [<ffffffff811279c6>] ? find_vma+0x46/0x80
 [<ffffffff814cf963>] do_page_fault+0x143/0x4b0
 [<ffffffffa0371eeb>] ? bond_start_xmit+0xab/0x280 [bonding]
 [<ffffffff81406759>] ? dev_hard_start_xmit+0x259/0x530
 [<ffffffff814cc655>] page_fault+0x25/0x30
 [<ffffffff8123bb9d>] ? copy_user_generic_string+0x2d/0x40
 [<ffffffff813fcf6d>] ? memcpy_toiovec+0x6d/0x90
 [<ffffffff813fdd20>] skb_copy_datagram_iovec+0x60/0x290
 [<ffffffff813fde8f>] skb_copy_datagram_iovec+0x1cf/0x290
 [<ffffffff8144b9d2>] tcp_recvmsg+0xb62/0xd20
 [<ffffffff81106f96>] ? free_pcppages_bulk+0x3a6/0x460
 [<ffffffff8146ddaf>] inet_recvmsg+0x4f/0x80
 [<ffffffff811082a9>] ? __pagevec_free+0x59/0xc0
 [<ffffffff813f213d>] sock_recvmsg+0xfd/0x130
 [<ffffffff81129bd0>] ? unmap_region+0x160/0x180
 [<ffffffff813f22be>] sys_recvfrom+0xee/0x170
 [<ffffffff8112c752>] ? do_mremap+0x192/0x310
 [<ffffffff8115cc2b>] ? __fput+0x16b/0x240
 [<ffffffff810c0c9f>] ? audit_syscall_entry+0x1bf/0x1f0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff8800371225d0     0 10724   5824 0x00000080
 ffff8800740736a8 0000000000000082 ffff880074073638 ffffffff00000001
 ffff880037122040 0000000000015140 ffff880074073fd8 ffff880074072010
 ffff880074073fd8 0000000000015140 ffff880103076100 ffff880037122040
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff81088ac1>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff814c99fc>] ? schedule+0x3ec/0x9c0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff880037081af0     0 10725   5824 0x00000080
 ffff880071547638 0000000000000082 0000000000000001 ffff88010a574bc0
 ffff880037081560 0000000000015140 ffff880071547fd8 ffff880071546010
 ffff880071547fd8 0000000000015140 ffff880077b13560 ffff880037081560
Call Trace:
 [<ffffffff810fec70>] ? __lock_page+0x70/0x70
 [<ffffffff814ca05c>] io_schedule+0x8c/0xd0
 [<ffffffff810fec7e>] sleep_on_page+0xe/0x20
 [<ffffffff814caa4f>] __wait_on_bit+0x5f/0x90
 [<ffffffff810fee43>] wait_on_page_bit+0x73/0x80
 [<ffffffff81084cd0>] ? autoremove_wake_function+0x50/0x50
 [<ffffffffa023ea72>] ? submit_one_bio+0x82/0xa0 [btrfs]
 [<ffffffffa02459ca>] read_extent_buffer_pages+0x3ba/0x460 [btrfs]
 [<ffffffffa02188b0>] ? btrfs_find_tree_block+0x30/0x30 [btrfs]
 [<ffffffffa021badd>] btree_read_extent_buffer_pages+0x9d/0xe0 [btrfs]
 [<ffffffffa021bb9c>] read_tree_block+0x3c/0x60 [btrfs]
 [<ffffffffa01fd6d1>] read_block_for_search+0xf1/0x1f0 [btrfs]
 [<ffffffffa0204dc5>] btrfs_search_slot+0x435/0x690 [btrfs]
 [<ffffffffa020605d>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
 [<ffffffffa02112c1>] ? update_block_group+0xe1/0x2b0 [btrfs]
 [<ffffffffa0211723>] alloc_reserved_tree_block+0x73/0x1e0 [btrfs]
 [<ffffffffa02120b7>] run_delayed_tree_ref+0xf7/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff8115ac4a>] do_sync_write+0xda/0x120
 [<ffffffff8109782f>] ? futex_wake+0x11f/0x130
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b1e8>] vfs_write+0xc8/0x190
 [<ffffffff8115b3b1>] sys_write+0x51/0x90
 [<ffffffff814cc9ae>] ? do_device_not_available+0xe/0x10
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff88006fc2da70     0 10729   5824 0x00000080
 ffff880069f8f6a8 0000000000000082 0000000000000000 ffff88006ff35000
 ffff88006fc2d4e0 0000000000015140 ffff880069f8ffd8 ffff880069f8e010
 ffff880069f8ffd8 0000000000015140 ffff88007c336ab0 ffff88006fc2d4e0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff8800b998d040     0 10731   5824 0x00000080
 ffff880100a1f758 0000000000000082 ffff880100a1f6d8 0000000000000001
 ffff8800b998cab0 0000000000015140 ffff880100a1ffd8 ffff880100a1e010
 ffff880100a1ffd8 0000000000015140 ffff8800b1cbf4e0 ffff8800b998cab0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa020605d>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
 [<ffffffffa02112c1>] ? update_block_group+0xe1/0x2b0 [btrfs]
 [<ffffffffa0211723>] alloc_reserved_tree_block+0x73/0x1e0 [btrfs]
 [<ffffffffa02120b7>] run_delayed_tree_ref+0xf7/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff8109751f>] ? get_futex_key+0x1f/0x210
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff88007c337040     0 10733   5824 0x00000080
 ffff880078b5f6a8 0000000000000082 ffff88010bcccaf8 ffff880000000001
 ffff88007c336ab0 0000000000015140 ffff880078b5ffd8 ffff880078b5e010
 ffff880078b5ffd8 0000000000015140 ffff880078a15560 ffff88007c336ab0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa01fe7c7>] ? __btrfs_cow_block+0x3d7/0x5e0 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff81154d4c>] ? __mem_cgroup_commit_charge+0x6c/0xc0
 [<ffffffff8110b3dd>] ? lru_cache_add_lru+0x2d/0x50
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff8800b1cbfa70     0 10734   5824 0x00000080
 ffff88010b8776a8 0000000000000082 ffff880035438ef8 ffff880100000001
 ffff8800b1cbf4e0 0000000000015140 ffff88010b877fd8 ffff88010b876010
 ffff88010b877fd8 0000000000015140 ffff88007bf1e100 ffff8800b1cbf4e0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff814c99fc>] ? schedule+0x3ec/0x9c0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff880037584650     0 10735   5824 0x00000080
 ffff8800789796a8 0000000000000082 ffff8800378641f0 ffff880000000001
 ffff8800375840c0 0000000000015140 ffff880078979fd8 ffff880078978010
 ffff880078979fd8 0000000000015140 ffff8800b9906b30 ffff8800375840c0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa01fe7c7>] ? __btrfs_cow_block+0x3d7/0x5e0 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff812373ad>] ? __rb_erase_color+0x12d/0x1d0
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff880096804690     0 10736   5824 0x00000080
 ffff880104fed6a8 0000000000000082 0000000000000000 ffff88006ff35000
 ffff880096804100 0000000000015140 ffff880104fedfd8 ffff880104fec010
 ffff880104fedfd8 0000000000015140 ffff8801088eb4e0 ffff880096804100
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa025f8e6>] ? tree_insert+0x86/0xa0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa024108e>] ? set_extent_buffer_dirty+0x4e/0xa0 [btrfs]
 [<ffffffffa01fe7c7>] ? __btrfs_cow_block+0x3d7/0x5e0 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff812373ad>] ? __rb_erase_color+0x12d/0x1d0
 [<ffffffff81088ac1>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff8800968050c0     0 10738   5824 0x00000080
 ffff88010449d6a8 0000000000000082 ffff88010449d638 0000000000000001
 ffff880096804b30 0000000000015140 ffff88010449dfd8 ffff88010449c010
 ffff88010449dfd8 0000000000015140 ffff8800b998cab0 ffff880096804b30
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa0202250>] ? setup_items_for_insert+0x3e0/0x4b0 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa023fc90>] ? map_extent_buffer+0xb0/0xc0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff880078a150c0     0 10739   5824 0x00000080
 ffff8800739236a8 0000000000000082 0000000000000000 0000000200000001
 ffff880078a14b30 0000000000015140 ffff880073923fd8 ffff880073922010
 ffff880073923fd8 0000000000015140 ffff880074001520 ffff880078a14b30
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffff812371bd>] ? rb_insert_color+0x9d/0x160
 [<ffffffffa025f8e6>] ? tree_insert+0x86/0xa0 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa025f8e6>] ? tree_insert+0x86/0xa0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa024108e>] ? set_extent_buffer_dirty+0x4e/0xa0 [btrfs]
 [<ffffffffa01fe7c7>] ? __btrfs_cow_block+0x3d7/0x5e0 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff81088ac1>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814cc9ae>] ? do_device_not_available+0xe/0x10
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff880078a15af0     0 10740   5824 0x00000080
 ffff880076193758 0000000000000082 00000000000003e1 0000000000000001
 ffff880078a15560 0000000000015140 ffff880076193fd8 ffff880076192010
 ffff880076193fd8 0000000000015140 ffff880096804100 ffff880078a15560
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa020605d>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
 [<ffffffffa02112c1>] ? update_block_group+0xe1/0x2b0 [btrfs]
 [<ffffffffa0211723>] alloc_reserved_tree_block+0x73/0x1e0 [btrfs]
 [<ffffffffa02120b7>] run_delayed_tree_ref+0xf7/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff81088ac1>] ? lock_hrtimer_base+0x31/0x60
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff814c99fc>] ? schedule+0x3ec/0x9c0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff8801088eba70     0 10743   5824 0x00000080
 ffff88012fa1f6a8 0000000000000082 0000000000015140 000000000001bf90
 ffff8801088eb4e0 0000000000015140 ffff88012fa1ffd8 ffff88012fa1e010
 ffff88012fa1ffd8 0000000000015140 ffff880077b13560 ffff8801088eb4e0
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffff81154d4c>] ? __mem_cgroup_commit_charge+0x6c/0xc0
 [<ffffffff8110b3dd>] ? lru_cache_add_lru+0x2d/0x50
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff810985a1>] ? futex_wait+0x1/0x2b0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
scribed         D ffff880077b13af0     0 10768   5824 0x00000080
 ffff880035f276a8 0000000000000082 ffff880035f27638 ffffffffa023e8f7
 ffff880077b13560 0000000000015140 ffff880035f27fd8 ffff880035f26010
 ffff880035f27fd8 0000000000015140 ffff88006fea2100 ffff880077b13560
Call Trace:
 [<ffffffffa023e8f7>] ? free_extent_state+0x37/0x60 [btrfs]
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa02261ea>] btrfs_dirty_inode+0x8a/0x130 [btrfs]
 [<ffffffff811819df>] __mark_inode_dirty+0x3f/0x1f0
 [<ffffffff8117313c>] file_update_time+0xec/0x170
 [<ffffffffa022ec10>] btrfs_file_aio_write+0x1d0/0x310 [btrfs]
 [<ffffffffa022ea40>] ? __btrfs_direct_write+0x160/0x160 [btrfs]
 [<ffffffff8115ab33>] do_sync_readv_writev+0xd3/0x110
 [<ffffffff81089912>] ? hrtimer_cancel+0x22/0x30
 [<ffffffff811e7ec3>] ? security_file_permission+0x23/0x90
 [<ffffffff8115b9a4>] do_readv_writev+0xd4/0x1e0
 [<ffffffff81099568>] ? do_futex+0x98/0x1b0
 [<ffffffff8115baf6>] vfs_writev+0x46/0x60
 [<ffffffff8115bc31>] sys_writev+0x51/0xc0
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
btrfs-endio-wri D ffff88012fe9b000     0 10809      2 0x00000080
 ffff880102d8d7f0 0000000000000046 ffff880126f95e70 ffff88013c335a60
 ffff88012fe9aa70 0000000000015140 ffff880102d8dfd8 ffff880102d8c010
 ffff880102d8dfd8 0000000000015140 ffff880037122040 ffff88012fe9aa70
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa01ff333>] ? leaf_space_used+0xf3/0x130 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa0224e44>] btrfs_finish_ordered_io+0x2a4/0x370 [btrfs]
 [<ffffffffa0224f5e>] btrfs_writepage_end_io_hook+0x4e/0xa0 [btrfs]
 [<ffffffffa025e716>] end_compressed_bio_write+0x86/0xf0 [btrfs]
 [<ffffffff8118b36d>] bio_endio+0x1d/0x40
 [<ffffffffa0219f64>] end_workqueue_fn+0xf4/0x130 [btrfs]
 [<ffffffffa024d424>] worker_loop+0x154/0x460 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffff810845f6>] kthread+0x96/0xa0
 [<ffffffff814d5384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084560>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d5380>] ? gs_change+0x13/0x13
btrfs-endio-wri D ffff880096805af0     0 10810      2 0x00000080
 ffff880101b81600 0000000000000046 0000000000000001 ffff880000000001
 ffff880096805560 0000000000015140 ffff880101b81fd8 ffff880101b80010
 ffff880101b81fd8 0000000000015140 ffff8800b1cbe080 ffff880096805560
Call Trace:
 [<ffffffff810fec70>] ? __lock_page+0x70/0x70
 [<ffffffff814ca05c>] io_schedule+0x8c/0xd0
 [<ffffffff810fec7e>] sleep_on_page+0xe/0x20
 [<ffffffff814caa4f>] __wait_on_bit+0x5f/0x90
 [<ffffffff810fee43>] wait_on_page_bit+0x73/0x80
 [<ffffffff81084cd0>] ? autoremove_wake_function+0x50/0x50
 [<ffffffffa023ea72>] ? submit_one_bio+0x82/0xa0 [btrfs]
 [<ffffffffa02459ca>] read_extent_buffer_pages+0x3ba/0x460 [btrfs]
 [<ffffffffa02188b0>] ? btrfs_find_tree_block+0x30/0x30 [btrfs]
 [<ffffffffa021badd>] btree_read_extent_buffer_pages+0x9d/0xe0 [btrfs]
 [<ffffffffa021bb9c>] read_tree_block+0x3c/0x60 [btrfs]
 [<ffffffffa01fd6d1>] read_block_for_search+0xf1/0x1f0 [btrfs]
 [<ffffffffa0204dc5>] btrfs_search_slot+0x435/0x690 [btrfs]
 [<ffffffffa021675e>] btrfs_del_csums+0x23e/0x300 [btrfs]
 [<ffffffffa0211d3e>] __btrfs_free_extent+0x4ae/0x730 [btrfs]
 [<ffffffffa0212289>] run_delayed_data_ref+0x159/0x160 [btrfs]
 [<ffffffffa01fecf4>] ? unlock_up+0xe4/0x180 [btrfs]
 [<ffffffffa0212340>] run_one_delayed_ref+0xb0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa0224e44>] btrfs_finish_ordered_io+0x2a4/0x370 [btrfs]
 [<ffffffffa0224f5e>] btrfs_writepage_end_io_hook+0x4e/0xa0 [btrfs]
 [<ffffffffa025e716>] end_compressed_bio_write+0x86/0xf0 [btrfs]
 [<ffffffff8118b36d>] bio_endio+0x1d/0x40
 [<ffffffffa0219f64>] end_workqueue_fn+0xf4/0x130 [btrfs]
 [<ffffffffa024d424>] worker_loop+0x154/0x460 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffffa024d2d0>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
 [<ffffffff810845f6>] kthread+0x96/0xa0
 [<ffffffff814d5384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084560>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d5380>] ? gs_change+0x13/0x13
rm              D ffff8800b1cbe610     0 21684   3357 0x00000080
 ffff88010ebeb8c8 0000000000000086 ffff88012e57a850 ffff880100000001
 ffff8800b1cbe080 0000000000015140 ffff88010ebebfd8 ffff88010ebea010
 ffff88010ebebfd8 0000000000015140 ffff880096804b30 ffff8800b1cbe080
Call Trace:
 [<ffffffffa0252421>] btrfs_tree_lock+0x111/0x120 [btrfs]
 [<ffffffffa02522f0>] ? btrfs_try_tree_lock+0x40/0x40 [btrfs]
 [<ffffffffa01fcfa8>] btrfs_lock_root_node+0x38/0x50 [btrfs]
 [<ffffffffa0204d49>] btrfs_search_slot+0x3b9/0x690 [btrfs]
 [<ffffffffa023f572>] ? insert_state+0x102/0x180 [btrfs]
 [<ffffffffa020f84c>] lookup_inline_extent_backref+0xbc/0x3f0 [btrfs]
 [<ffffffffa0211966>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa020e577>] ? btrfs_free_tree_block+0x107/0x380 [btrfs]
 [<ffffffffa021211d>] run_delayed_tree_ref+0x15d/0x170 [btrfs]
 [<ffffffffa0212330>] run_one_delayed_ref+0xa0/0xd0 [btrfs]
 [<ffffffffa0212419>] run_clustered_refs+0xb9/0x220 [btrfs]
 [<ffffffffa0212648>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa021f931>] __btrfs_end_transaction+0x71/0x210 [btrfs]
 [<ffffffffa021fb25>] btrfs_end_transaction+0x15/0x20 [btrfs]
 [<ffffffffa0228997>] btrfs_evict_inode+0x1b7/0x250 [btrfs]
 [<ffffffff81173da8>] evict+0x78/0x170
 [<ffffffff81174228>] iput_final+0xc8/0x180
 [<ffffffff81174318>] iput+0x38/0x50
 [<ffffffff8116a28a>] do_unlinkat+0x11a/0x1c0
 [<ffffffff8115f736>] ? sys_newfstatat+0x36/0x50
 [<ffffffff810c0c9f>] ? audit_syscall_entry+0x1bf/0x1f0
 [<ffffffff8100bf75>] ? math_state_restore+0x45/0x60
 [<ffffffff8116a492>] sys_unlinkat+0x22/0x40
 [<ffffffff814d4242>] system_call_fastpath+0x16/0x1b
Sched Debug Version: v0.10, 2.6.39.2 #1
ktime                                   : 12216636.444644
sched_clk                               : 12217333.758264
cpu_clk                                 : 12217333.758399
jiffies                                 : 4306883928
sched_clock_stable                      : 1

sysctl_sched
  .sysctl_sched_latency                    : 24.000000
  .sysctl_sched_min_granularity            : 3.000000
  .sysctl_sched_wakeup_granularity         : 4.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 7279
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2133.174 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 26905374
  .nr_load_updates               : 4685274
  .nr_uninterruptible            : 1
  .next_balance                  : 4306.884003
  .curr->pid                     : 27639
  .clock                         : 12217333.316083
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 896
  .cpu_load[2]                   : 880
  .cpu_load[3]                   : 926
  .cpu_load[4]                   : 972
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 27706762
  .sched_goidle                  : 11752137
  .avg_idle                      : 1000000
  .ttwu_count                    : 14444352
  .ttwu_local                    : 13866405
  .bkl_count                     : 0

cfs_rq[0]:/autogroup-25
  .exec_clock                    : 1754651.110984
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1636072.639823
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -4071171.099304
  .nr_spread_over                : 329
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 1700.248736
  .load_period                   : 5.110558
  .load_contrib                  : 332
  .load_tg                       : 9135
  .se->exec_start                : 12217253.606401
  .se->vruntime                  : 5707220.431260
  .se->sum_exec_runtime          : 1754651.593737
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 26.525825
  .se->statistics.slice_max      : 52.712563
  .se->statistics.wait_max       : 124.693729
  .se->statistics.wait_sum       : 166971.507741
  .se->statistics.wait_count     : 10835394
  .se->load.weight               : 2

cfs_rq[0]:/autogroup-230
  .exec_clock                    : 62436.263988
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 71157.593880
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5636086.145247
  .nr_spread_over                : 1533
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 9728.499720
  .load_period                   : 9.500488
  .load_contrib                  : 1023
  .load_tg                       : 1023
  .se->exec_start                : 12217333.316083
  .se->vruntime                  : 5707243.739127
  .se->sum_exec_runtime          : 62436.253723
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 18.585894
  .se->statistics.slice_max      : 15.700933
  .se->statistics.wait_max       : 27.049583
  .se->statistics.wait_sum       : 1003.645717
  .se->statistics.wait_count     : 23082
  .se->load.weight               : 1024

cfs_rq[0]:/
  .exec_clock                    : 3048654.851778
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 5707243.739127
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 358
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R        cc1plus 27639     71157.593880       414   120     71157.593880      1762.498830        29.784276 /autogroup-230

cpu#1, 2133.174 MHz
  .nr_running                    : 2
  .load                          : 1099
  .nr_switches                   : 5202989
  .nr_load_updates               : 3412499
  .nr_uninterruptible            : 6
  .next_balance                  : 4306.883930
  .curr->pid                     : 10780
  .clock                         : 12217332.313831
  .cpu_load[0]                   : 75
  .cpu_load[1]                   : 134
  .cpu_load[2]                   : 360
  .cpu_load[3]                   : 615
  .cpu_load[4]                   : 787
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 5663379
  .sched_goidle                  : 1693306
  .avg_idle                      : 575273
  .ttwu_count                    : 3129335
  .ttwu_local                    : 1363004
  .bkl_count                     : 0

cfs_rq[1]:/autogroup-76
  .exec_clock                    : 499407.750509
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 502439.086079
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5204804.653048
  .nr_spread_over                : 241
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 5119.999488
  .load_period                   : 5.494750
  .load_contrib                  : 931
  .load_tg                       : 1648
  .se->exec_start                : 12217318.830093
  .se->vruntime                  : 4065470.984154
  .se->sum_exec_runtime          : 499407.707174
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 22.392523
  .se->statistics.slice_max      : 36.697023
  .se->statistics.wait_max       : 56.248241
  .se->statistics.wait_sum       : 18173.424809
  .se->statistics.wait_count     : 206104
  .se->load.weight               : 2

cfs_rq[1]:/autogroup-25
  .exec_clock                    : 498335.813672
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 319178.217391
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5388065.521736
  .nr_spread_over                : 225
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 4991.828921
  .load_period                   : 7.411406
  .load_contrib                  : 673
  .load_tg                       : 9135
  .se->exec_start                : 12217332.313831
  .se->vruntime                  : 4065652.931256
  .se->sum_exec_runtime          : 498336.350679
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 25.412956
  .se->statistics.slice_max      : 77.233543
  .se->statistics.wait_max       : 158.722105
  .se->statistics.wait_sum       : 68913.287745
  .se->statistics.wait_count     : 1532691
  .se->load.weight               : 75

cfs_rq[1]:/
  .exec_clock                    : 2693797.505618
  .MIN_vruntime                  : 4065640.931256
  .min_vruntime                  : 4065652.931256
  .max_vruntime                  : 4065640.931256
  .spread                        : 0.000000
  .spread0                       : -1641590.807871
  .nr_spread_over                : 422
  .nr_running                    : 2
  .load                          : 1099
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
 btrfs-endio-wri  5898   4065640.931256    163995   120   4065640.931256   2120589.603022   4812011.877524 /
R        scribed 10780    319178.217391     40625   120    319178.217391     30710.062386   2740882.340892 /autogroup-25

cpu#2, 2133.174 MHz
  .nr_running                    : 3
  .load                          : 297
  .nr_switches                   : 4315099
  .nr_load_updates               : 3330178
  .nr_uninterruptible            : 4
  .next_balance                  : 4306.883960
  .curr->pid                     : 10799
  .clock                         : 12217333.315513
  .cpu_load[0]                   : 106
  .cpu_load[1]                   : 97
  .cpu_load[2]                   : 97
  .cpu_load[3]                   : 127
  .cpu_load[4]                   : 199
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 4758647
  .sched_goidle                  : 1364869
  .avg_idle                      : 801941
  .ttwu_count                    : 2694705
  .ttwu_local                    : 1257375
  .bkl_count                     : 0

cfs_rq[2]:/autogroup-25
  .exec_clock                    : 494954.846307
  .MIN_vruntime                  : 332267.401963
  .min_vruntime                  : 332267.402128
  .max_vruntime                  : 332267.402128
  .spread                        : 0.000165
  .spread0                       : -5374976.336999
  .nr_spread_over                : 285
  .nr_running                    : 3
  .load                          : 3072
  .load_avg                      : 10356.877319
  .load_period                   : 5.595277
  .load_contrib                  : 1851
  .load_tg                       : 9135
  .se->exec_start                : 12217333.315513
  .se->vruntime                  : 4181344.918399
  .se->sum_exec_runtime          : 494955.354343
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 70.792267
  .se->statistics.slice_max      : 43.647628
  .se->statistics.wait_max       : 202.697576
  .se->statistics.wait_sum       : 66469.684263
  .se->statistics.wait_count     : 1310449
  .se->load.weight               : 297

cfs_rq[2]:/
  .exec_clock                    : 2782930.847972
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4181344.918399
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1525898.820728
  .nr_spread_over                : 366
  .nr_running                    : 1
  .load                          : 297
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
         scribed 10735    332267.402128     42181   120    332267.402128     60756.381280   2711089.437213 /autogroup-25
         scribed 10741    332267.401963     43881   120    332267.401963     41509.615065   2736135.528323 /autogroup-25
R        scribed 10799    332268.179232     49286   120    332268.179232     44583.256256   2708643.765415 /autogroup-25

cpu#3, 2133.174 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 3566636
  .nr_load_updates               : 3231982
  .nr_uninterruptible            : 0
  .next_balance                  : 4306.883937
  .curr->pid                     : 10807
  .clock                         : 12217333.315095
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 893
  .cpu_load[2]                   : 887
  .cpu_load[3]                   : 1054
  .cpu_load[4]                   : 1165
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3997671
  .sched_goidle                  : 1036744
  .avg_idle                      : 875228
  .ttwu_count                    : 2317023
  .ttwu_local                    : 1188657
  .bkl_count                     : 0

cfs_rq[3]:/autogroup-104
  .exec_clock                    : 1042.146427
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1041.097851
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5706202.641276
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 840.969664
  .load_period                   : 9.536831
  .load_contrib                  : 88
  .load_tg                       : 88
  .se->exec_start                : 12217264.731984
  .se->vruntime                  : 4237812.475572
  .se->sum_exec_runtime          : 1042.138865
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 19.669824
  .se->statistics.slice_max      : 14.713005
  .se->statistics.wait_max       : 20.977554
  .se->statistics.wait_sum       : 122.877838
  .se->statistics.wait_count     : 7746
  .se->load.weight               : 2

cfs_rq[3]:/autogroup-76
  .exec_clock                    : 761855.251614
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 761898.181721
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -4945345.557406
  .nr_spread_over                : 26
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 6869.735669
  .load_period                   : 9.569814
  .load_contrib                  : 717
  .load_tg                       : 1648
  .se->exec_start                : 12217284.575036
  .se->vruntime                  : 4237901.051612
  .se->sum_exec_runtime          : 761855.212972
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 20.660558
  .se->statistics.slice_max      : 71.050682
  .se->statistics.wait_max       : 42.770238
  .se->statistics.wait_sum       : 19920.522671
  .se->statistics.wait_count     : 161732
  .se->load.weight               : 2

cfs_rq[3]:/autogroup-25
  .exec_clock                    : 439304.464950
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 304723.334359
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5402520.404768
  .nr_spread_over                : 218
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 7172.446743
  .load_period                   : 7.484584
  .load_contrib                  : 878
  .load_tg                       : 9135
  .se->exec_start                : 12217284.666890
  .se->vruntime                  : 4237913.051612
  .se->sum_exec_runtime          : 439304.858078
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 24.953756
  .se->statistics.slice_max      : 82.117601
  .se->statistics.wait_max       : 170.531510
  .se->statistics.wait_sum       : 61267.000589
  .se->statistics.wait_count     : 1153357
  .se->load.weight               : 2

cfs_rq[3]:/
  .exec_clock                    : 2780537.614307
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4237927.149103
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1469316.590024
  .nr_spread_over                : 318
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
Rbtrfs-delalloc- 10807   4237927.149103     25157   120   4237927.149103    209280.273512   2568413.477590 /

cpu#4, 2133.174 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 8214676
  .nr_load_updates               : 2688095
  .nr_uninterruptible            : 1
  .next_balance                  : 4306.884026
  .curr->pid                     : 5895
  .clock                         : 12217333.315419
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 896
  .cpu_load[2]                   : 880
  .cpu_load[3]                   : 926
  .cpu_load[4]                   : 968
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 8812362
  .sched_goidle                  : 2533391
  .avg_idle                      : 1000000
  .ttwu_count                    : 5059169
  .ttwu_local                    : 4525693
  .bkl_count                     : 0

cfs_rq[4]:/autogroup-25
  .exec_clock                    : 361336.890454
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 274004.052341
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5433240.687149
  .nr_spread_over                : 387
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 14337.219072
  .load_period                   : 9.256943
  .load_contrib                  : 1481
  .load_tg                       : 9135
  .se->exec_start                : 12217307.628907
  .se->vruntime                  : 2880243.295216
  .se->sum_exec_runtime          : 361337.275425
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 23.588326
  .se->statistics.slice_max      : 47.112710
  .se->statistics.wait_max       : 204.274242
  .se->statistics.wait_sum       : 116184.116044
  .se->statistics.wait_count     : 1056567
  .se->load.weight               : 2

cfs_rq[4]:/
  .exec_clock                    : 1830928.098544
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 2880287.827681
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -2826956.911809
  .nr_spread_over                : 400
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
Rbtrfs-delalloc-  5895   2880287.827681    134043   120   2880287.827681    592844.026075   6457506.091557 /

cpu#5, 2133.174 MHz
  .nr_running                    : 2
  .load                          : 1103
  .nr_switches                   : 3471510
  .nr_load_updates               : 3409152
  .nr_uninterruptible            : 2
  .next_balance                  : 4306.884177
  .curr->pid                     : 6269
  .clock                         : 12217329.760121
  .cpu_load[0]                   : 79
  .cpu_load[1]                   : 195
  .cpu_load[2]                   : 434
  .cpu_load[3]                   : 690
  .cpu_load[4]                   : 981
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3934378
  .sched_goidle                  : 985135
  .avg_idle                      : 1000000
  .ttwu_count                    : 2222722
  .ttwu_local                    : 1184589
  .bkl_count                     : 0

cfs_rq[5]:/autogroup-24
  .exec_clock                    : 162.445116
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 197.311167
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5707047.428323
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 7625.888256
  .load_period                   : 8.824504
  .load_contrib                  : 864
  .load_tg                       : 864
  .se->exec_start                : 12217326.749178
  .se->vruntime                  : 4167283.771931
  .se->sum_exec_runtime          : 162.439451
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 13.232947
  .se->statistics.slice_max      : 3.267770
  .se->statistics.wait_max       : 11.340110
  .se->statistics.wait_sum       : 47.266926
  .se->statistics.wait_count     : 4098
  .se->load.weight               : 2

cfs_rq[5]:/autogroup-25
  .exec_clock                    : 384589.418050
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 298479.678048
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5408765.061442
  .nr_spread_over                : 192
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 9699.411602
  .load_period                   : 7.713238
  .load_contrib                  : 1322
  .load_tg                       : 9135
  .se->exec_start                : 12217329.760121
  .se->vruntime                  : 4167322.516139
  .se->sum_exec_runtime          : 384589.784577
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 24.994387
  .se->statistics.slice_max      : 75.880836
  .se->statistics.wait_max       : 157.590113
  .se->statistics.wait_sum       : 60991.924850
  .se->statistics.wait_count     : 840378
  .se->load.weight               : 79

cfs_rq[5]:/
  .exec_clock                    : 2793179.007168
  .MIN_vruntime                  : 4167310.516139
  .min_vruntime                  : 4167322.516139
  .max_vruntime                  : 4167310.516139
  .spread                        : 0.000000
  .spread0                       : -1539922.223351
  .nr_spread_over                : 421
  .nr_running                    : 2
  .load                          : 1103
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
       md0_raid5   863   4167310.516139   3424152   120   4167310.516139    270912.576424  11795648.898170 /
R           bash  6269    298468.185914      2733   120    298468.185914      1806.785809   6745808.153495 /autogroup-25

cpu#6, 2133.174 MHz
  .nr_running                    : 3
  .load                          : 292
  .nr_switches                   : 3195696
  .nr_load_updates               : 3506863
  .nr_uninterruptible            : 2
  .next_balance                  : 4306.883946
  .curr->pid                     : 10729
  .clock                         : 12217334.315835
  .cpu_load[0]                   : 78
  .cpu_load[1]                   : 59
  .cpu_load[2]                   : 102
  .cpu_load[3]                   : 294
  .cpu_load[4]                   : 549
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3652930
  .sched_goidle                  : 901061
  .avg_idle                      : 1000000
  .ttwu_count                    : 2071659
  .ttwu_local                    : 1094733
  .bkl_count                     : 0

cfs_rq[6]:/autogroup-25
  .exec_clock                    : 342051.319508
  .MIN_vruntime                  : 266565.286666
  .min_vruntime                  : 266577.286666
  .max_vruntime                  : 266577.286666
  .spread                        : 12.000000
  .spread0                       : -5440667.452824
  .nr_spread_over                : 275
  .nr_running                    : 3
  .load                          : 3072
  .load_avg                      : 8737.728247
  .load_period                   : 6.047456
  .load_contrib                  : 1443
  .load_tg                       : 9135
  .se->exec_start                : 12217334.315835
  .se->vruntime                  : 4167807.265322
  .se->sum_exec_runtime          : 342051.655163
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 34.918282
  .se->statistics.slice_max      : 60.531193
  .se->statistics.wait_max       : 146.144632
  .se->statistics.wait_sum       : 61710.696905
  .se->statistics.wait_count     : 790208
  .se->load.weight               : 292

cfs_rq[6]:/
  .exec_clock                    : 2975483.631357
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 4167807.265322
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1539437.474168
  .nr_spread_over                : 398
  .nr_running                    : 1
  .load                          : 292
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R        scribed 10729    266566.020605     42683   120    266566.020605     46269.627553   2726078.411762 /autogroup-25
         scribed 10733    266565.286666     39983   120    266565.286666     57123.431312   2718298.543814 /autogroup-25
         scribed 10786    266577.286666     46171   120    266577.286666     44596.572841   2709349.616752 /autogroup-25

cpu#7, 2133.174 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 2777608
  .nr_load_updates               : 2949637
  .nr_uninterruptible            : 1
  .next_balance                  : 4306.884007
  .curr->pid                     : 10808
  .clock                         : 12217334.315362
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 760
  .cpu_load[2]                   : 793
  .cpu_load[3]                   : 877
  .cpu_load[4]                   : 962
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 3157776
  .sched_goidle                  : 673326
  .avg_idle                      : 892935
  .ttwu_count                    : 1906563
  .ttwu_local                    : 1141082
  .bkl_count                     : 0

cfs_rq[7]:/autogroup-25
  .exec_clock                    : 354455.915522
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 278965.198926
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -5428279.540564
  .nr_spread_over                : 223
  .nr_running                    : 0
  .load                          : 0
  .load_avg                      : 6746.540864
  .load_period                   : 5.839319
  .load_contrib                  : 1155
  .load_tg                       : 9135
  .se->exec_start                : 12217286.319101
  .se->vruntime                  : 3793542.310877
  .se->sum_exec_runtime          : 354456.279955
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 25.527186
  .se->statistics.slice_max      : 62.782995
  .se->statistics.wait_max       : 198.264244
  .se->statistics.wait_sum       : 58180.444857
  .se->statistics.wait_count     : 798245
  .se->load.weight               : 2

cfs_rq[7]:/
  .exec_clock                    : 2560150.798518
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 3793563.780772
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1913680.958718
  .nr_spread_over                : 353
  .nr_running                    : 1
  .load                          : 1024
  .load_avg                      : 0.000000
  .load_period                   : 0.000000
  .load_contrib                  : 0
  .load_tg                       : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
Rbtrfs-delalloc- 10808   3793563.780772     28933   120   3793563.780772    212006.056854   2565681.821674 /


--------------060003070403010808000605--
