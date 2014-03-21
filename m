Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33911 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaCUGGd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 02:06:33 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WQsbA-00062J-VI
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 23:06:33 -0700
Date: Thu, 20 Mar 2014 23:06:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs deadlock (3.14 kernel)
Message-ID: <20140321060632.GD28005@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After 1.5 days of running, the machine I was doing btrfs receive on got
stuck with this (note, the traces are not all the same).

The machine is not dead, but any IO that goes through btrfs seems dead.

If you want Sysrq-W, let me know.

Is thre anything I can try to unwedge or prevent this problem next time I try?

Thanks,
Marc

[107280.560066] INFO: task btrfs-transacti:6728 blocked for more than 120 seconds.
[107280.560078]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[107280.560082] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[107280.560087] btrfs-transacti D ffff88007bb2e880     0  6728      2 0x00000080
[107280.560097]  ffff8800702d38d0 0000000000000046 ffff8800702d3fd8 ffff88007bb2e350
[107280.560109]  00000000000141c0 ffff88007bb2e350 ffff88007fc141c0 ffff88007bb2e350
[107280.560123]  ffff8800702d3970 ffffffff810fe5f2 0000000000000002 ffff8800702d38e0
[107280.560134] Call Trace:
[107280.560145]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[107280.560151]  [<ffffffff8160c331>] schedule+0x73/0x75
[107280.560157]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[107280.560162]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[107280.560167]  [<ffffffff8160c768>] __wait_on_bit+0x48/0x7a
[107280.560187]  [<ffffffff810fe5a0>] wait_on_page_bit+0x7a/0x7c
[107280.560195]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[107280.560201]  [<ffffffff81245ea2>] read_extent_buffer_pages+0x1bf/0x204
[107280.560207]  [<ffffffff81223942>] ? free_root_pointers+0x5b/0x5b
[107280.560214]  [<ffffffff81224644>] btree_read_extent_buffer_pages.constprop.45+0x66/0x100
[107280.560219]  [<ffffffff81225599>] read_tree_block+0x2f/0x47
[107280.560225]  [<ffffffff8120a930>] read_node_slot+0x85/0xb2
[107280.560236]  [<ffffffff8120ed52>] push_leaf_right+0x76/0x16b
[107280.560240]  [<ffffffff8120f593>] split_leaf+0xc5/0x567
[107280.560243]  [<ffffffff8120c189>] ? leaf_space_used+0xa9/0xd8
[107280.560248]  [<ffffffff812578cf>] ? btrfs_set_lock_blocking_rw+0x95/0xdf
[107280.560251]  [<ffffffff81210055>] btrfs_search_slot+0x620/0x6bb
[107280.560257]  [<ffffffff81211330>] btrfs_insert_empty_items+0x5d/0xa8
[107280.560261]  [<ffffffff8121ba41>] __btrfs_run_delayed_refs+0x6f1/0xbdf
[107280.560266]  [<ffffffff81016495>] ? native_sched_clock+0x34/0x36
[107280.560270]  [<ffffffff81015efa>] ? paravirt_sched_clock+0x9/0xd
[107280.560274]  [<ffffffff8121dac8>] btrfs_run_delayed_refs+0x81/0x18f
[107280.560278]  [<ffffffff8122ae40>] btrfs_commit_transaction+0x79/0x849
[107280.560282]  [<ffffffff812277ca>] transaction_kthread+0xf8/0x1ab
[107280.560286]  [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
[107280.560294]  [<ffffffff8106bc56>] kthread+0xae/0xb6
[107280.560298]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[107280.560302]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[107280.560306]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[107280.560310] INFO: task btrfs:20144 blocked for more than 120 seconds.
[107280.560313]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[107280.560315] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[107280.560317] btrfs           D ffff88000043c540     0 20144  20139 0x00000080
[107280.560323]  ffff8800009ebb10 0000000000000082 ffff8800009ebfd8 ffff88000043c010
[107280.560331]  00000000000141c0 ffff88000043c010 ffff88007fc141c0 ffff88000043c010
[107280.560338]  ffff8800009ebbb0 0000000000000002 ffffffff810fe5f2 ffff8800009ebb20
[107280.560345] Call Trace:
[107280.560349]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[107280.560353]  [<ffffffff8160c331>] schedule+0x73/0x75
[107280.560356]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[107280.560360]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[107280.560363]  [<ffffffff8160c866>] __wait_on_bit_lock+0x46/0x8a
[107280.560367]  [<ffffffff810fe6bb>] __lock_page+0x69/0x6b
[107280.560371]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[107280.560375]  [<ffffffff81240beb>] lock_page+0x1e/0x21
[107280.560378]  [<ffffffff812446bc>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[107280.560382]  [<ffffffff8110067f>] ? find_get_pages+0xef/0x104
[107280.560386]  [<ffffffff81244b1a>] extent_writepages+0x4b/0x5c
[107280.560390]  [<ffffffff8122eed5>] ? btrfs_submit_direct+0x3f4/0x3f4
[107280.560393]  [<ffffffff8122d5c7>] btrfs_writepages+0x28/0x2a
[107280.560398]  [<ffffffff81108e3b>] do_writepages+0x1e/0x2c
[107280.560402]  [<ffffffff810ffc03>] __filemap_fdatawrite_range+0x55/0x57
[107280.560405]  [<ffffffff810ffc36>] filemap_fdatawrite_range+0x13/0x15
[107280.560409]  [<ffffffff8123fab1>] btrfs_wait_ordered_range+0x88/0x11d
[107280.560413]  [<ffffffff8123324b>] btrfs_truncate+0x45/0x231
[107280.560416]  [<ffffffff81233cef>] btrfs_setattr+0x1a4/0x27c
[107280.560421]  [<ffffffff8116b33f>] notify_change+0x1e4/0x2c8
[107280.560427]  [<ffffffff81154045>] do_truncate+0x69/0x90
[107280.560431]  [<ffffffff81154156>] vfs_truncate+0xea/0x118
[107280.560435]  [<ffffffff811541ce>] do_sys_truncate+0x4a/0x86
[107280.560438]  [<ffffffff8115430e>] SyS_truncate+0xe/0x10
[107280.560442]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[107280.560449] INFO: task kworker/u8:0:22761 blocked for more than 120 seconds.
[107280.560452]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[107280.560454] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[107280.560456] kworker/u8:0    D ffff8800096ca940     0 22761      2 0x00000080
[107280.560465] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[107280.560470]  ffff880023565a00 0000000000000046 ffff880023565fd8 ffff8800096ca410
[107280.560477]  00000000000141c0 ffff8800096ca410 ffff88007fc941c0 ffff8800096ca410
[107280.560484]  ffff880023565aa0 0000000000000002 ffffffff810fe5f2 ffff880023565a10
[107280.560495] Call Trace:
[107280.560499]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[107280.560503]  [<ffffffff8160c331>] schedule+0x73/0x75
[107280.560506]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[107280.560509]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[107280.560513]  [<ffffffff8160c866>] __wait_on_bit_lock+0x46/0x8a
[107280.560517]  [<ffffffff810fe6bb>] __lock_page+0x69/0x6b
[107280.560521]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[107280.560524]  [<ffffffff81240beb>] lock_page+0x1e/0x21
[107280.560528]  [<ffffffff812446bc>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[107280.560532]  [<ffffffff81244b1a>] extent_writepages+0x4b/0x5c
[107280.560535]  [<ffffffff8122eed5>] ? btrfs_submit_direct+0x3f4/0x3f4
[107280.560539]  [<ffffffff81108e2c>] ? do_writepages+0xf/0x2c
[107280.560542]  [<ffffffff8122d5c7>] btrfs_writepages+0x28/0x2a
[107280.560546]  [<ffffffff81108e3b>] do_writepages+0x1e/0x2c
[107280.560550]  [<ffffffff8117683d>] __writeback_single_inode+0x7d/0x238
[107280.560553]  [<ffffffff811771c4>] writeback_sb_inodes+0x1eb/0x339
[107280.560557]  [<ffffffff81177386>] __writeback_inodes_wb+0x74/0xb7
[107280.560561]  [<ffffffff81177501>] wb_writeback+0x138/0x293
[107280.560565]  [<ffffffff81177a78>] bdi_writeback_workfn+0xc6/0x329
[107280.560569]  [<ffffffff8100e047>] ? load_TLS+0xb/0xf
[107280.560573]  [<ffffffff8106651d>] process_one_work+0x195/0x2d2
[107280.560577]  [<ffffffff81066a39>] worker_thread+0x136/0x205
[107280.560580]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[107280.560584]  [<ffffffff8106bc56>] kthread+0xae/0xb6
[107280.560588]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[107280.560592]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[107280.560595]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[113640.560075] INFO: task btrfs-transacti:6728 blocked for more than 120 seconds.
[113640.560091]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[113640.560095] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[113640.560099] btrfs-transacti D ffff88007bb2e880     0  6728      2 0x00000080
[113640.560108]  ffff8800702d3840 0000000000000046 ffff8800702d3fd8 ffff88007bb2e350
[113640.560120]  00000000000141c0 ffff88007bb2e350 ffff88007fc941c0 ffff88007bb2e350
[113640.560131]  ffff8800702d38e0 ffffffff810fe5f2 0000000000000002 ffff8800702d3850
[113640.560146] Call Trace:
[113640.560157]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[113640.560164]  [<ffffffff8160c331>] schedule+0x73/0x75
[113640.560169]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[113640.560174]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[113640.560185]  [<ffffffff8160c768>] __wait_on_bit+0x48/0x7a
[113640.560205]  [<ffffffff810fe5a0>] wait_on_page_bit+0x7a/0x7c
[113640.560212]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[113640.560219]  [<ffffffff81245ea2>] read_extent_buffer_pages+0x1bf/0x204
[113640.560225]  [<ffffffff81223942>] ? free_root_pointers+0x5b/0x5b
[113640.560231]  [<ffffffff81224644>] btree_read_extent_buffer_pages.constprop.45+0x66/0x100
[113640.560236]  [<ffffffff81225599>] read_tree_block+0x2f/0x47
[113640.560247]  [<ffffffff8120a930>] read_node_slot+0x85/0xb2
[113640.560252]  [<ffffffff8120ed52>] push_leaf_right+0x76/0x16b
[113640.560256]  [<ffffffff8120f593>] split_leaf+0xc5/0x567
[113640.560260]  [<ffffffff8120c189>] ? leaf_space_used+0xa9/0xd8
[113640.560264]  [<ffffffff812578cf>] ? btrfs_set_lock_blocking_rw+0x95/0xdf
[113640.560268]  [<ffffffff81210055>] btrfs_search_slot+0x620/0x6bb
[113640.560272]  [<ffffffff81211330>] btrfs_insert_empty_items+0x5d/0xa8
[113640.560276]  [<ffffffff812170c6>] alloc_reserved_file_extent+0x95/0x233
[113640.560281]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[113640.560285]  [<ffffffff8121bd60>] __btrfs_run_delayed_refs+0xa10/0xbdf
[113640.560290]  [<ffffffff8121dac8>] btrfs_run_delayed_refs+0x81/0x18f
[113640.560294]  [<ffffffff8122ae40>] btrfs_commit_transaction+0x79/0x849
[113640.560298]  [<ffffffff812277ca>] transaction_kthread+0xf8/0x1ab
[113640.560302]  [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
[113640.560306]  [<ffffffff8106bc56>] kthread+0xae/0xb6
[113640.560310]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[113640.560315]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[113640.560320]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[113760.560065] INFO: task btrfs:20144 blocked for more than 120 seconds.
[113760.560079]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[113760.560083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[113760.560087] btrfs           D ffff88000043c540     0 20144  20139 0x00000080
[113760.560097]  ffff8800009ebb10 0000000000000082 ffff8800009ebfd8 ffff88000043c010
[113760.560114]  00000000000141c0 ffff88000043c010 ffff88007fc141c0 ffff88000043c010
[113760.560125]  ffff8800009ebbb0 ffffffff810fe5f2 0000000000000002 ffff8800009ebb20
[113760.560140] Call Trace:
[113760.560150]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[113760.560157]  [<ffffffff8160c331>] schedule+0x73/0x75
[113760.560164]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[113760.560170]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[113760.560175]  [<ffffffff8160c768>] __wait_on_bit+0x48/0x7a
[113760.560180]  [<ffffffff810fe5a0>] wait_on_page_bit+0x7a/0x7c
[113760.560187]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[113760.560193]  [<ffffffff81240a0d>] wait_on_page_writeback+0x16/0x18
[113760.560199]  [<ffffffff81244709>] extent_write_cache_pages.isra.16.constprop.32+0x15b/0x2c6
[113760.560205]  [<ffffffff8110067f>] ? find_get_pages+0xef/0x104
[113760.560213]  [<ffffffff81244b1a>] extent_writepages+0x4b/0x5c
[113760.560219]  [<ffffffff8122eed5>] ? btrfs_submit_direct+0x3f4/0x3f4
[113760.560224]  [<ffffffff8122d5c7>] btrfs_writepages+0x28/0x2a
[113760.560235]  [<ffffffff81108e3b>] do_writepages+0x1e/0x2c
[113760.560238]  [<ffffffff810ffc03>] __filemap_fdatawrite_range+0x55/0x57
[113760.560242]  [<ffffffff810ffc36>] filemap_fdatawrite_range+0x13/0x15
[113760.560246]  [<ffffffff8123fab1>] btrfs_wait_ordered_range+0x88/0x11d
[113760.560249]  [<ffffffff8123324b>] btrfs_truncate+0x45/0x231
[113760.560254]  [<ffffffff81233cef>] btrfs_setattr+0x1a4/0x27c
[113760.560259]  [<ffffffff8116b33f>] notify_change+0x1e4/0x2c8
[113760.560263]  [<ffffffff81154045>] do_truncate+0x69/0x90
[113760.560267]  [<ffffffff81154156>] vfs_truncate+0xea/0x118
[113760.560270]  [<ffffffff811541ce>] do_sys_truncate+0x4a/0x86
[113760.560274]  [<ffffffff8115430e>] SyS_truncate+0xe/0x10
[113760.560279]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[134520.560062] INFO: task btrfs:20144 blocked for more than 120 seconds.
[134520.560073]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[134520.560077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[134520.560081] btrfs           D ffff88000043c540     0 20144  20139 0x00000080
[134520.560091]  ffff8800009ebd48 0000000000000082 ffff8800009ebfd8 ffff88000043c010
[134520.560107]  00000000000141c0 ffff88000043c010 ffff88001f3d92a0 ffff8800546391e8
[134520.560117]  0000000000000000 ffff880054639000 ffff88000c197420 ffff8800009ebd58
[134520.560128] Call Trace:
[134520.560138]  [<ffffffff8160c331>] schedule+0x73/0x75
[134520.560146]  [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
[134520.560153]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[134520.560158]  [<ffffffff8122ba9e>] start_transaction+0x48e/0x4f2
[134520.560164]  [<ffffffff8122bb1d>] btrfs_start_transaction+0x1b/0x1d
[134520.560170]  [<ffffffff81233c8a>] btrfs_setattr+0x13f/0x27c
[134520.560176]  [<ffffffff8116b33f>] notify_change+0x1e4/0x2c8
[134520.560182]  [<ffffffff81154045>] do_truncate+0x69/0x90
[134520.560188]  [<ffffffff81154156>] vfs_truncate+0xea/0x118
[134520.560193]  [<ffffffff811541ce>] do_sys_truncate+0x4a/0x86
[134520.560199]  [<ffffffff8115430e>] SyS_truncate+0xe/0x10
[134520.560205]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[134640.560074] INFO: task btrfs:20144 blocked for more than 120 seconds.
[134640.560085]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[134640.560089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[134640.560100] btrfs           D ffff88000043c540     0 20144  20139 0x00000080
[134640.560109]  ffff8800009ebd48 0000000000000082 ffff8800009ebfd8 ffff88000043c010
[134640.560121]  00000000000141c0 ffff88000043c010 ffff88001f3d92a0 ffff8800546391e8
[134640.560131]  0000000000000000 ffff880054639000 ffff88000c197420 ffff8800009ebd58
[134640.560142] Call Trace:
[134640.560151]  [<ffffffff8160c331>] schedule+0x73/0x75
[134640.560159]  [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
[134640.560166]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[134640.560171]  [<ffffffff8122ba9e>] start_transaction+0x48e/0x4f2
[134640.560177]  [<ffffffff8122bb1d>] btrfs_start_transaction+0x1b/0x1d
[134640.560183]  [<ffffffff81233c8a>] btrfs_setattr+0x13f/0x27c
[134640.560191]  [<ffffffff8116b33f>] notify_change+0x1e4/0x2c8
[134640.560198]  [<ffffffff81154045>] do_truncate+0x69/0x90
[134640.560203]  [<ffffffff81154156>] vfs_truncate+0xea/0x118
[134640.560208]  [<ffffffff811541ce>] do_sys_truncate+0x4a/0x86
[134640.560214]  [<ffffffff8115430e>] SyS_truncate+0xe/0x10
[134640.560220]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[134760.560062] INFO: task btrfs:20144 blocked for more than 120 seconds.
[134760.560073]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[134760.560077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[134760.560081] btrfs           D ffff88000043c540     0 20144  20139 0x00000080
[134760.560091]  ffff8800009ebd48 0000000000000082 ffff8800009ebfd8 ffff88000043c010
[134760.560102]  00000000000141c0 ffff88000043c010 ffff88001f3d92a0 ffff8800546391e8
[134760.560113]  0000000000000000 ffff880054639000 ffff88000c197420 ffff8800009ebd58
[134760.560124] Call Trace:
[134760.560133]  [<ffffffff8160c331>] schedule+0x73/0x75
[134760.560141]  [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
[134760.560148]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[134760.560154]  [<ffffffff8122ba9e>] start_transaction+0x48e/0x4f2
[134760.560163]  [<ffffffff8122bb1d>] btrfs_start_transaction+0x1b/0x1d
[134760.560168]  [<ffffffff81233c8a>] btrfs_setattr+0x13f/0x27c
[134760.560174]  [<ffffffff8116b33f>] notify_change+0x1e4/0x2c8
[134760.560181]  [<ffffffff81154045>] do_truncate+0x69/0x90
[134760.560186]  [<ffffffff81154156>] vfs_truncate+0xea/0x118
[134760.560191]  [<ffffffff811541ce>] do_sys_truncate+0x4a/0x86
[134760.560197]  [<ffffffff8115430e>] SyS_truncate+0xe/0x10
[134760.560203]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
