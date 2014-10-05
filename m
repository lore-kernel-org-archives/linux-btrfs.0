Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33183 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJEU3p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 16:29:45 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:52397 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1XasQw-0005bV-Qg by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 05 Oct 2014 13:29:44 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1XasQz-00084g-R7
	for linux-btrfs@vger.kernel.org; Sun, 05 Oct 2014 13:29:37 -0700
Date: Sun, 5 Oct 2014 13:29:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20141005202937.GK10696@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 3.16.2 btrfs deadlock
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Deadlocks have been less frequent (good), but here is one.

An rsync from 5 days ago got stuck on btrfs it seems, and things just 
started piling up on top until the system deadlocked

I see btrfs-transaction saying wait on page, but if it's RAM, I had
plenty left:
             total       used       free     shared    buffers     cached
Mem:       7894580    6950108     944472          0         40    4816148
-/+ buffers/cache:    2133920    5760660
Swap:     15616764     767004   14849760


Here's the trace:
SysRq : Show Blocked State
  task                        PC stack   pid father
md8_raid5       D ffff88017028cb80     0   675      2 0x00000000
 ffff88020fd67aa8 0000000000000046 ffffffff812f1799 ffff88020fd67fd8
 ffff880037228410 00000000000140c0 ffff88021e3940c0 ffff880037228410
 ffff8801f5579bf0 0000000000000004 ffff880211ad07c8 ffff88020fd67ab8
Call Trace:
 [<ffffffff812f1799>] ? blk_flush_plug_list+0x1bc/0x1cb
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
 [<ffffffff812ef8f6>] get_request+0x4b8/0x56a
 [<ffffffff8130ba01>] ? cfq_merge+0x49/0x9e
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff812f1921>] blk_queue_bio+0x179/0x262
 [<ffffffff812eec2c>] generic_make_request+0x9c/0xdb
 [<ffffffffc042b31d>] handle_stripe+0x1e41/0x2166 [raid456]
 [<ffffffff81017316>] ? ___preempt_schedule+0x56/0xa8
 [<ffffffff8163d0d9>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
 [<ffffffffc042b925>] handle_active_stripes.isra.22+0x2e3/0x359 [raid456]
 [<ffffffff8151d35e>] ? md_wakeup_thread+0x55/0x58
 [<ffffffffc042bdd6>] raid5d+0x330/0x428 [raid456]
 [<ffffffff810795b1>] ? get_parent_ip+0xd/0x3c
 [<ffffffff815202f9>] md_thread+0x11c/0x13a
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff815201dd>] ? bb_store+0x55/0x55
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
btrfs-transacti D 0000000000000002     0   781      2 0x00000000
 ffff88020fd6b8c0 0000000000000046 ffff88020fd6b890 ffff88020fd6bfd8
 ffff88021150e3d0 00000000000140c0 ffff88021e3140c0 ffff88021150e3d0
 ffff88020fd6b960 ffffffff81106441 0000000000000002 ffff88020fd6b8d0
Call Trace:
 [<ffffffff81106441>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
 [<ffffffff8110644f>] sleep_on_page+0xe/0x12
 [<ffffffff8163acbd>] __wait_on_bit+0x48/0x7a
 [<ffffffff811063ef>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81087ba4>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff812504b5>] read_extent_buffer_pages+0x1bf/0x204
 [<ffffffff8122d7f9>] ? free_root_pointers+0x5b/0x5b
 [<ffffffff8122e4ec>] btree_read_extent_buffer_pages.constprop.44+0x66/0x100
 [<ffffffff8122f532>] read_tree_block+0x2f/0x47
 [<ffffffff81214f20>] read_node_slot+0x85/0xb2
 [<ffffffff812182e3>] push_leaf_right+0x76/0x16b
 [<ffffffff81218b24>] split_leaf+0xc5/0x567
 [<ffffffff81215755>] ? leaf_space_used+0xa9/0xd8
 [<ffffffff8163d188>] ? _raw_write_unlock+0x16/0x29
 [<ffffffff81262878>] ? btrfs_set_lock_blocking_rw+0x70/0xb5
 [<ffffffff8121961a>] btrfs_search_slot+0x654/0x6ef
 [<ffffffff8121a8f5>] btrfs_insert_empty_items+0x5d/0xa8
 [<ffffffff812253ff>] __btrfs_run_delayed_refs+0x706/0xc49
 [<ffffffff812274bd>] btrfs_run_delayed_refs+0x71/0x197
 [<ffffffff81234d62>] btrfs_commit_transaction+0x3d/0x87f
 [<ffffffff812317b1>] transaction_kthread+0xf8/0x1ab
 [<ffffffff812316b9>] ? btrfs_cleanup_transaction+0x436/0x436
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
btrfs-transacti D 0000000000000002     0  3349      2 0x00000000
 ffff8802085b3a60 0000000000000046 ffff8802085b3a30 ffff8802085b3fd8
 ffff8800c6836350 00000000000140c0 ffff88021e3140c0 ffff8800c6836350
 ffff8802085b3b00 ffffffff81106441 0000000000000002 ffff8802085b3a70
Call Trace:
 [<ffffffff81106441>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
 [<ffffffff8110644f>] sleep_on_page+0xe/0x12
 [<ffffffff8163acbd>] __wait_on_bit+0x48/0x7a
 [<ffffffff811063ef>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81087ba4>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff8110766f>] filemap_fdatawait_range+0x7e/0x126
 [<ffffffff81249f9c>] btrfs_wait_ordered_range+0x6a/0x11a
 [<ffffffff8126ad42>] __btrfs_write_out_cache+0x29b/0x387
 [<ffffffff8126b2eb>] btrfs_write_out_cache+0xab/0xe3
 [<ffffffff81227ba1>] btrfs_write_dirty_block_groups+0x543/0x561
 [<ffffffff81635381>] commit_cowonly_roots+0x14d/0x219
 [<ffffffff81235142>] btrfs_commit_transaction+0x41d/0x87f
 [<ffffffff812317b1>] transaction_kthread+0xf8/0x1ab
 [<ffffffff812316b9>] ? btrfs_cleanup_transaction+0x436/0x436
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
md8_resync      D 0000000000000002     0 20574      2 0x00000080
 ffff88006666fbd0 0000000000000046 ffff88021149f618 ffff88006666ffd8
 ffff880015f20510 00000000000140c0 ffff88021149f400 ffff88021149f424
 0000000000000000 ffff88021149f5f8 ffff88006666fc28 ffff88006666fbe0
Call Trace:
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffffc0428fcf>] get_active_stripe+0x225/0x575 [raid456]
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffffc042c876>] sync_request+0x25d/0x2d0 [raid456]
 [<ffffffff81521461>] md_do_sync+0x7fb/0xc2f
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff815202f9>] md_thread+0x11c/0x13a
 [<ffffffff815201dd>] ? bb_store+0x55/0x55
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
kworker/0:2     D ffff88010e4bf440     0 28539      2 0x00000080
Workqueue: events do_sync_work
 ffff880075083b60 0000000000000046 ffff880075083b30 ffff880075083fd8
 ffff880017c3a210 00000000000140c0 ffff88021e2140c0 ffff880017c3a210
 ffff880075083c00 ffffffff81106441 0000000000000002 ffff880075083b70
Call Trace:
 [<ffffffff81106441>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
 [<ffffffff8110644f>] sleep_on_page+0xe/0x12
 [<ffffffff8163acbd>] __wait_on_bit+0x48/0x7a
 [<ffffffff811063ef>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81087ba4>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81111cf3>] ? pagevec_lookup_tag+0x21/0x29
 [<ffffffff8110766f>] filemap_fdatawait_range+0x7e/0x126
 [<ffffffff81107738>] filemap_fdatawait+0x21/0x23
 [<ffffffff81181b06>] sync_inodes_sb+0x14e/0x1a0
 [<ffffffff81185854>] ? vfs_fsync+0x1e/0x1e
 [<ffffffff81185868>] sync_inodes_one_sb+0x14/0x16
 [<ffffffff8116337e>] iterate_supers+0x6e/0xc2
 [<ffffffff811858bf>] do_sync_work+0x25/0x8b
 [<ffffffff81068bf7>] process_one_work+0x195/0x2d2
 [<ffffffff81068fd8>] worker_thread+0x275/0x352
 [<ffffffff81068d63>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
kworker/u8:10   D 0000000000000000     0 20493      2 0x00000080
Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
 ffff88007d427cd8 0000000000000046 ffff8800c96aa270 ffff88007d427fd8
 ffff88003c7e62d0 00000000000140c0 ffff880110e8e1e0 ffff8802115c11f0
 ffff8802115c1000 ffff88010b2a0e80 00000000fffffff0 ffff88007d427ce8
Call Trace:
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff81234554>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff812357c8>] start_transaction+0x224/0x50f
 [<ffffffff81235b04>] btrfs_join_transaction+0x17/0x19
 [<ffffffff812275fb>] delayed_ref_async_start+0x18/0x7b
 [<ffffffff8125ac72>] normal_work_helper+0xf1/0x233
 [<ffffffff8125af61>] btrfs_extent_refs_helper+0x12/0x14
 [<ffffffff81068bf7>] process_one_work+0x195/0x2d2
 [<ffffffff81068fd8>] worker_thread+0x275/0x352
 [<ffffffff81068d63>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
kworker/0:4     D ffff88017028cb80     0 22618      2 0x00000080
Workqueue: kcryptd kcryptd_crypt [dm_crypt]
 ffff88006c577b88 0000000000000046 ffff88021149f618 ffff88006c577fd8
 ffff8800017d41d0 00000000000140c0 ffff88021149f400 ffff88021149f418
 0000000000000000 ffff88021149f5c8 ffff88006c577be0 ffff88006c577b98
Call Trace:
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffffc0428fcf>] get_active_stripe+0x225/0x575 [raid456]
 [<ffffffff8107965a>] ? preempt_count_add+0x7a/0x8d
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffffc042d079>] make_request+0x790/0xa04 [raid456]
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff81521ac5>] md_make_request+0x105/0x213
 [<ffffffff812eec2c>] generic_make_request+0x9c/0xdb
 [<ffffffffc0437d1f>] kcryptd_crypt_write_io_submit+0x9d/0xa2 [dm_crypt]
 [<ffffffffc0438418>] kcryptd_crypt+0x261/0x411 [dm_crypt]
 [<ffffffff81068bf7>] process_one_work+0x195/0x2d2
 [<ffffffff81068fd8>] worker_thread+0x275/0x352
 [<ffffffff81068d63>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
rsync           D ffff880129726080     0 28673   9798 0x20020080
 ffff8800484d7c30 0000000000000082 ffff88013f4976d8 ffff8800484d7fd8
 ffff88007cfe61d0 00000000000140c0 ffff880150dce660 ffff880150dce664
 ffff88007cfe61d0 ffff880150dce668 00000000ffffffff ffff8800484d7c40
Call Trace:
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163ab47>] schedule_preempt_disabled+0x18/0x24
 [<ffffffff8163bc6a>] __mutex_lock_slowpath+0x160/0x1d7
 [<ffffffff811690f4>] ? lookup_fast+0x15f/0x228
 [<ffffffff8163bcf8>] mutex_lock+0x17/0x27
 [<ffffffff8116956c>] walk_component+0x69/0x180
 [<ffffffff811696b1>] lookup_last+0x2e/0x30
 [<ffffffff8116a357>] path_lookupat+0x90/0x2d7
 [<ffffffff81148eb1>] ? kmemleak_alloc_recursive.constprop.44+0x16/0x18
 [<ffffffff8114aa0b>] ? kmem_cache_alloc+0xff/0x17e
 [<ffffffff8116a5c7>] filename_lookup+0x29/0x7f
 [<ffffffff8116d2ed>] user_path_at_empty+0x59/0x8c
 [<ffffffff8163d0a7>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff81125b6e>] ? list_lru_add+0xc4/0xdb
 [<ffffffff81178f06>] ? mntput_no_expire+0x33/0x12b
 [<ffffffff8116d331>] user_path_at+0x11/0x13
 [<ffffffff811648a4>] vfs_fstatat+0x49/0x96
 [<ffffffff810c2efb>] ? from_kgid_munged+0x12/0x1e
 [<ffffffff8116498c>] vfs_lstat+0x1e/0x20
 [<ffffffff8104b32d>] sys32_lstat64+0x1a/0x33
 [<ffffffff811682a0>] ? path_put+0x1e/0x21
 [<ffffffff810a4aae>] ? current_kernel_time+0xe/0x32
 [<ffffffff810cb5d4>] ? __audit_syscall_entry+0xa6/0xc8
 [<ffffffff816401cc>] sysenter_dispatch+0x7/0x21
kworker/3:2     D 0000000000000000     0 29416      2 0x00000080
Workqueue: kcryptd kcryptd_crypt [dm_crypt]
 ffff88000549bbe0 0000000000000046 ffff880211117298 ffff88000549bfd8
 ffff88002c84a150 00000000000140c0 ffff880211117000 ffff880211117298
 ffff880211117290 0000000000000001 ffff8800c878d700 ffff88000549bbf0
Call Trace:
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8151d5b1>] md_write_start+0x11e/0x137
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff81510c5a>] make_request+0x3f/0xa96
 [<ffffffff812e3827>] ? crypto_aes_set_key+0x2c/0x2c
 [<ffffffff812e3827>] ? crypto_aes_set_key+0x2c/0x2c
 [<ffffffff81521ac5>] md_make_request+0x105/0x213
 [<ffffffff812eec2c>] generic_make_request+0x9c/0xdb
 [<ffffffffc0437d1f>] kcryptd_crypt_write_io_submit+0x9d/0xa2 [dm_crypt]
 [<ffffffffc0438418>] kcryptd_crypt+0x261/0x411 [dm_crypt]
 [<ffffffff81068bf7>] process_one_work+0x195/0x2d2
 [<ffffffff81068fd8>] worker_thread+0x275/0x352
 [<ffffffff81068d63>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106e3a9>] kthread+0xae/0xb6
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
rsync           D ffff88018351f040     0 30350  28673 0x20020080
 ffff88002e6fbbb0 0000000000000086 ffff8800c96aa270 ffff88002e6fbfd8
 ffff8800824be510 00000000000140c0 ffff880110e8e1e0 ffff8800c96a19f0
 ffff8800c96a1800 ffff880209e9f980 0000000000000000 ffff88002e6fbbc0
Call Trace:
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff81234554>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff81087b70>] ? finish_wait+0x65/0x65
 [<ffffffff81235a43>] start_transaction+0x49f/0x50f
 [<ffffffff81235ace>] btrfs_start_transaction+0x1b/0x1d
 [<ffffffff8123fdae>] btrfs_create+0x3c/0x1ce
 [<ffffffff812a401b>] ? security_inode_permission+0x1c/0x23
 [<ffffffff81169b0b>] ? __inode_permission+0x79/0xa4
 [<ffffffff8116adc9>] vfs_create+0x66/0x8c
 [<ffffffff8116bb2b>] do_last+0x5af/0xa23
 [<ffffffff8116c1d6>] path_openat+0x237/0x4de
 [<ffffffff8116d5d5>] do_filp_open+0x3a/0x7f
 [<ffffffff810795b1>] ? get_parent_ip+0xd/0x3c
 [<ffffffff8163d0a7>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff811775f8>] ? __alloc_fd+0xea/0xf9
 [<ffffffff8115fb65>] do_sys_open+0x70/0xff
 [<ffffffff8119d7bc>] compat_SyS_open+0x1b/0x1d
 [<ffffffff816401cc>] sysenter_dispatch+0x7/0x21
exim            D 0000000000000001     0  9533   4717 0x20020080
 ffff8800016bfc30 0000000000000082 ffff8800016bfc00 ffff8800016bffd8
 ffff8800b9fac410 00000000000140c0 ffff88021e2940c0 ffff8800b9fac410
 ffff8800016bfcd0 ffffffff81106441 0000000000000002 ffff8800016bfc40
Call Trace:
 [<ffffffff81106441>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8163a889>] schedule+0x6e/0x70
 [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
 [<ffffffff8110644f>] sleep_on_page+0xe/0x12
 [<ffffffff8163acbd>] __wait_on_bit+0x48/0x7a
 [<ffffffff811063ef>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81087ba4>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff8124ae77>] wait_on_page_writeback+0x16/0x18
 [<ffffffff8124ed06>] extent_write_cache_pages.isra.16.constprop.31+0x15b/0x2c3
 [<ffffffff8163b2e4>] ? mutex_unlock+0x16/0x18
 [<ffffffff81243e32>] ? btrfs_file_write_iter+0x34e/0x41c
 [<ffffffff8124f2a2>] extent_writepages+0x4b/0x5c
 [<ffffffff81238e7c>] ? btrfs_submit_direct+0x3f9/0x3f9
 [<ffffffff81237568>] btrfs_writepages+0x28/0x2a
 [<ffffffff81110efe>] do_writepages+0x1e/0x2c
 [<ffffffff81107b4f>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff81107b82>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff81242a99>] btrfs_sync_file+0xaa/0x2cc
 [<ffffffff811627cb>] ? __sb_end_write+0x2d/0x5b
 [<ffffffff8118582c>] vfs_fsync_range+0x1b/0x25
 [<ffffffff81185852>] vfs_fsync+0x1c/0x1e
 [<ffffffff81185a5e>] do_fsync+0x2c/0x4c
 [<ffffffff81185c7e>] SyS_fdatasync+0x13/0x17
 [<ffffffff816401cc>] sysenter_dispatch+0x7/0x21


Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3
CPU: 3 PID: 9583 Comm: sadc Not tainted 3.16.2-amd64-i915-preempt-20140714 #1
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
 0000000000000000 ffff88021e386c20 ffffffff816369d6 ffffffff81aa16ef
 ffff88021e386c98 ffffffff81632988 0000000000000010 ffff88021e386ca8
 ffff88021e386c48 0000000000000000 0000000000000003 ffff88021e386ef8
Call Trace:
 <NMI>  [<ffffffff816369d6>] dump_stack+0x4e/0x7a
 [<ffffffff81632988>] panic+0xcb/0x1fe
 [<ffffffff810d0c32>] watchdog_overflow_callback+0xbb/0x110
 [<ffffffff810ff920>] __perf_event_overflow+0x155/0x1e3
 [<ffffffff81021695>] ? x86_perf_event_set_period+0x103/0x113
 [<ffffffff810ffe31>] perf_event_overflow+0x14/0x16
 [<ffffffff810277ec>] intel_pmu_handle_irq+0x2d7/0x364
 [<ffffffff810205ce>] perf_event_nmi_handler+0x25/0x3e
 [<ffffffff810122a5>] nmi_handle+0x60/0x11c
 [<ffffffff81038b62>] ? cpumask_clear_cpu.constprop.3+0x11/0x11
 [<ffffffff81012573>] default_do_nmi+0x74/0x157
 [<ffffffff810126b8>] do_nmi+0x62/0xa2
 [<ffffffff8163fde1>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff8108c679>] ? do_raw_spin_lock+0x19/0x27
 [<ffffffff8108c679>] ? do_raw_spin_lock+0x19/0x27
 [<ffffffff8108c679>] ? do_raw_spin_lock+0x19/0x27
 <<EOE>>  [<ffffffff8163d54a>] _raw_spin_lock_irq+0x24/0x27
 [<ffffffff813de347>] uart_proc_show+0x134/0x331
 [<ffffffff8117bcca>] seq_read+0x150/0x302
 [<ffffffff812a3a92>] ? fsnotify_perm+0x60/0x6b
 [<ffffffff811ae760>] proc_reg_read+0x5a/0x7c
 [<ffffffff8116069b>] vfs_read+0x88/0xfa
 [<ffffffff81160e9a>] SyS_read+0x46/0x79
 [<ffffffff816401cc>] sysenter_dispatch+0x7/0x21

      131.048038         0.016424         0.007621 /
    kworker/2:1H   347 4825481473.873853  32768954   100 4825481473.873853   1024031.415751 2431265490.458642 /

          bioset   656      7340.438018         2   100      7340.438018         0.079953         0.032596 /
          bioset   674      7428.235256         2   100      7428.235256         0.011555         0.006256 /
    btrfs-worker   761      8129.795955         2   100      8129.795955         0.096081         0.046142 /
 btrfs-worker-hi   763 3243544430.862921         4   100 3243544430.862921         0.119452 1603390139.421423 /
 btrfs-flush_del   765 4740941088.983912         4   100 4740941088.983912         0.105922 2389612400.423491 /
     btrfs-fixup   768      8175.005182         2   100      8175.005182         0.009229         0.006478 /
     btrfs-endio   769 4805566466.196436        64   100 4805566466.196436         9.582823 2423209769.669892 /
 btrfs-endio-met   771      8202.024157         2   100      8202.024157         0.007683         0.003995 /
 btrfs-endio-rai   772      8211.030439         2   100      8211.030439         0.007657         0.003322 /
       btrfs-rmw   773      8220.036746         2   100      8220.036746         0.007690         0.003264 /
 btrfs-freespace   775 4731100793.494699       131   100 4731100793.494699         3.131112 2383851399.473326 /
 btrfs-delayed-m   776  65137379.868524         3   100  65137379.868524         0.113543  26290219.856218 /
 btrfs-readahead   777      8


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
