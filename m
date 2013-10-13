Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38738 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3JMPuG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Oct 2013 11:50:06 -0400
Date: Sun, 13 Oct 2013 16:50:00 +0100
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: John Drescher <drescherjm@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs hung tasks
Message-ID: <20131013155000.GC28147@carfax.org.uk>
References: <CAEhu1-4bzjDDWU-PXRvbCdijQL28+fDiCq7HprH6+Mwv8aL3jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="snImcH6YoPvXmXT+"
In-Reply-To: <CAEhu1-4bzjDDWU-PXRvbCdijQL28+fDiCq7HprH6+Mwv8aL3jA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--snImcH6YoPvXmXT+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[cc'd linux-btrfs]

On Sat, Oct 12, 2013 at 09:36:42AM -0400, John Drescher wrote:
> I am trying to debug this problem since it appears this is causing
> mythtv to truncate recordings on top of other very long delays.
> 
>  # uname -a
> Linux jmd0.comcast.net 3.11.4-gentoo-jmd0 #1 SMP PREEMPT Mon Oct 7
> 21:04:44 EDT 2013 x86_64 Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz
> GenuineIntel GNU/Linux
> 
> Here is 1 example of a hung task:
> 
> [ 3000.576427] INFO: task TFWWrite:11329 blocked for more than 120 seconds.
> [ 3000.576430] "echo 0 > /proc/sys/kernel/hung_task_
> timeout_secs" disables this message.
> [ 3000.576433] TFWWrite        D ffff8800a7ab5ac0     0 11329      1 0x00000000
> [ 3000.576437]  ffff8800a7ab5a18 0000000000000082 0000000000000002
> ffff8800a7ab5fd8
> [ 3000.576442]  ffff8800a7ab5fd8 0000000000004000 ffff8801a6cfade0
> ffff880099782de0
> [ 3000.576445]  0000000000000000 00000000000000d3 00000000000001a6
> 0000000000000001
> [ 3000.576449] Call Trace:
> [ 3000.576458]  [<ffffffff81074bfe>] ? load_balance+0xfe/0x800
> [ 3000.576462]  [<ffffffff8106e975>] ? sched_clock_local+0x25/0xa0
> [ 3000.576466]  [<ffffffff810d89e0>] ? __lock_page+0x70/0x70
> [ 3000.576471]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3000.576474]  [<ffffffff8156073a>] io_schedule+0x8a/0xd0
> [ 3000.576477]  [<ffffffff810d89e9>] sleep_on_page+0x9/0x10
> [ 3000.576480]  [<ffffffff8155e133>] __wait_on_bit_lock+0x53/0xb0
> [ 3000.576484]  [<ffffffff810d89d2>] __lock_page+0x62/0x70
> [ 3000.576488]  [<ffffffff810603c0>] ? wake_atomic_t_function+0x30/0x30
> [ 3000.576492]  [<ffffffff810d8b71>] find_lock_page+0x51/0x80
> [ 3000.576495]  [<ffffffff810d948a>] find_or_create_page+0x3a/0xc0
> [ 3000.576499]  [<ffffffff8128443c>] prepare_pages.isra.23+0x18c/0x340
> [ 3000.576504]  [<ffffffff81255990>] ? block_rsv_add_bytes+0x50/0x70
> [ 3000.576508]  [<ffffffff81284fca>] __btrfs_buffered_write+0x29a/0x4e0
> [ 3000.576511]  [<ffffffff81285425>] btrfs_file_aio_write+0x215/0x580
> [ 3000.576515]  [<ffffffff8111b30e>] ? kmem_cache_free+0xae/0x180
> [ 3000.576519]  [<ffffffff8113a4a1>] ? final_putname+0x21/0x50
> [ 3000.576523]  [<ffffffff8112eb1b>] do_sync_write+0x7b/0xb0
> [ 3000.576527]  [<ffffffff8112f8f0>] vfs_write+0xc0/0x1f0
> [ 3000.576530]  [<ffffffff8112fded>] SyS_write+0x4d/0xa0
> [ 3000.576533]  [<ffffffff81567b92>] system_call_fastpath+0x16/0x1b
> [ 3000.576556] INFO: task btrfs-transacti:6770 blocked for more than
> 120 seconds.
> [ 3000.576558] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3000.576559] btrfs-transacti D ffff8800a6d6f0c0     0  6770      2 0x00000000
> [ 3000.576562]  ffff8801500f5dd8 0000000000000046 ffff8801500f5d18
> ffff8801500f5fd8
> [ 3000.576566]  ffff8801500f5fd8 0000000000004000 ffff88017f08dbc0
> ffff88015eeb2de0
> [ 3000.576569]  ffff8801a86c0000 ffff8801a86b3990 0000000000000000
> 0000000000000000
> [ 3000.576573] Call Trace:
> [ 3000.576577]  [<ffffffff8124cd05>] ? btrfs_free_path+0x25/0x30
> [ 3000.576580]  [<ffffffff81561e26>] ? _raw_spin_lock+0x16/0x40
> [ 3000.576583]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3000.576587]  [<ffffffff8128b1ff>] ? btrfs_run_ordered_operations+0x20f/0x2c0
> [ 3000.576590]  [<ffffffff81561e68>] ? _raw_spin_lock_irqsave+0x18/0x50
> [ 3000.576593]  [<ffffffff81561c23>] ? _raw_spin_unlock_irqrestore+0x13/0x40
> [ 3000.576596]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3000.576600]  [<ffffffff81272d7d>] btrfs_commit_transaction+0x33d/0x960
> [ 3000.576603]  [<ffffffff81060350>] ? abort_exclusive_wait+0xb0/0xb0
> [ 3000.576607]  [<ffffffff8126ae3d>] transaction_kthread+0x19d/0x220
> [ 3000.576610]  [<ffffffff8126aca0>] ? btrfs_alloc_root+0x30/0x30
> [ 3000.576613]  [<ffffffff8105f7fb>] kthread+0xbb/0xc0
> [ 3000.576617]  [<ffffffff81560000>] ? __schedule+0x4c0/0xa10
> [ 3000.576620]  [<ffffffff8105f740>] ? kthread_freezable_should_stop+0x60/0x60
> [ 3000.576623]  [<ffffffff81567aec>] ret_from_fork+0x7c/0xb0
> [ 3000.576626]  [<ffffffff8105f740>] ? kthread_freezable_should_stop+0x60/0x60
> [ 3000.576652] INFO: task mythpreviewgen:12052 blocked for more than
> 120 seconds.
> [ 3000.576654] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3000.576655] mythpreviewgen  D ffff88015f6e8670     0 12052  12051 0x00000004
> [ 3000.576659]  ffff8801066adc08 0000000000000082 ffff8801066adb08
> ffff8801066adfd8
> [ 3000.576662]  ffff8801066adfd8 0000000000004000 ffff8801a6cf96f0
> ffff88018080ade0
> [ 3000.576665]  ffff8801a655d0c0 ffff8801a655d0c0 000000006d5f7675
> 0000000000000000
> [ 3000.576669] Call Trace:
> [ 3000.576676]  [<ffffffffa01f7d4a>] ? do_expire_wait+0x17a/0x190 [autofs4]
> [ 3000.576680]  [<ffffffff81561e26>] ? _raw_spin_lock+0x16/0x40
> [ 3000.576683]  [<ffffffff81561e26>] ? _raw_spin_lock+0x16/0x40
> [ 3000.576686]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3000.576689]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3000.576692]  [<ffffffff81560943>] schedule_preempt_disabled+0x13/0x20
> [ 3000.576695]  [<ffffffff8155f0ec>] __mutex_lock_slowpath+0x12c/0x210
> [ 3000.576699]  [<ffffffff8155e23d>] mutex_lock+0x1d/0x40
> [ 3000.576702]  [<ffffffff8113d6e8>] do_last+0x268/0xd20
> [ 3000.576705]  [<ffffffff8113a773>] ? inode_permission+0x13/0x50
> [ 3000.576708]  [<ffffffff8113accd>] ? link_path_walk+0x23d/0x8e0
> [ 3000.576711]  [<ffffffff8113e25d>] path_openat+0xbd/0x6b0
> [ 3000.576715]  [<ffffffff8113eb8e>] do_filp_open+0x3e/0xa0
> [ 3000.576718]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3000.576722]  [<ffffffff8114b31b>] ? __alloc_fd+0xcb/0x120
> [ 3000.576725]  [<ffffffff8112e6ac>] do_sys_open+0x13c/0x230
> [ 3000.576729]  [<ffffffff8112e7bd>] SyS_open+0x1d/0x20
> [ 3000.576731]  [<ffffffff81567b92>] system_call_fastpath+0x16/0x1b
> [ 3000.576734] INFO: task mythpreviewgen:12054 blocked for more than
> 120 seconds.
> [ 3000.576736] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3000.576737] mythpreviewgen  D ffff8801a86c06e0     0 12054  12053 0x00000004
> [ 3000.576740]  ffff880121141b28 0000000000000086 ffff880121141aa8
> ffff880121141fd8
> [ 3000.576744]  ffff880121141fd8 0000000000004000 ffff8801a6cfade0
> ffff88000a795bc0
> [ 3000.576747]  ffff880121141b58 ffffffff8125c7c7 ffff880121141a68
> ffffffff81561ca1
> [ 3000.576751] Call Trace:
> [ 3000.576755]  [<ffffffff8125c7c7>] ? reserve_metadata_bytes+0x177/0x880
> [ 3000.576758]  [<ffffffff81561ca1>] ? _raw_read_unlock+0x11/0x40
> [ 3000.576762]  [<ffffffff812a6f88>] ? btrfs_set_lock_blocking_rw+0xd8/0x110
> [ 3000.576766]  [<ffffffff81251d6f>] ? btrfs_search_slot+0x3ef/0x900
> [ 3000.576769]  [<ffffffff81561e68>] ? _raw_spin_lock_irqsave+0x18/0x50
> [ 3000.576772]  [<ffffffff81561c23>] ? _raw_spin_unlock_irqrestore+0x13/0x40
> [ 3000.576775]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3000.576779]  [<ffffffff81272017>] wait_current_trans.isra.34+0xb7/0x120
> [ 3000.576782]  [<ffffffff8127388c>] ? start_transaction+0x11c/0x4b0
> [ 3000.576785]  [<ffffffff81060350>] ? abort_exclusive_wait+0xb0/0xb0
> [ 3000.576789]  [<ffffffff81273a56>] start_transaction+0x2e6/0x4b0
> [ 3000.576792]  [<ffffffff81273f66>] btrfs_start_transaction+0x16/0x20
> [ 3000.576795]  [<ffffffff81280d82>] btrfs_create+0x42/0x210
> [ 3000.576799]  [<ffffffff81275f27>] ? btrfs_permission+0x37/0x70
> [ 3000.576802]  [<ffffffff8113a83e>] vfs_create+0x8e/0xf0
> [ 3000.576805]  [<ffffffff8113dd66>] do_last+0x8e6/0xd20
> [ 3000.576808]  [<ffffffff8113a773>] ? inode_permission+0x13/0x50
> [ 3000.576812]  [<ffffffff8113e25d>] path_openat+0xbd/0x6b0
> [ 3000.576815]  [<ffffffff8113eb8e>] do_filp_open+0x3e/0xa0
> [ 3000.576818]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3000.576821]  [<ffffffff8114b31b>] ? __alloc_fd+0xcb/0x120
> [ 3000.576825]  [<ffffffff8112e6ac>] do_sys_open+0x13c/0x230
> [ 3000.576828]  [<ffffffff8112e7bd>] SyS_open+0x1d/0x20
> [ 3000.576831]  [<ffffffff81567b92>] system_call_fastpath+0x16/0x1b
> [ 3120.576415] INFO: task TFWWrite:11329 blocked for more than 120 seconds.
> [ 3120.576419] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3120.576421] TFWWrite        D ffff8800a7ab5ac0     0 11329      1 0x00000000
> [ 3120.576426]  ffff8800a7ab5a18 0000000000000082 0000000000000002
> ffff8800a7ab5fd8
> [ 3120.576431]  ffff8800a7ab5fd8 0000000000004000 ffff8801a6cfade0
> ffff880099782de0
> [ 3120.576434]  0000000000000000 00000000000000d3 00000000000001a6
> 0000000000000001
> [ 3120.576438] Call Trace:
> [ 3120.576447]  [<ffffffff81074bfe>] ? load_balance+0xfe/0x800
> [ 3120.576451]  [<ffffffff8106e975>] ? sched_clock_local+0x25/0xa0
> [ 3120.576455]  [<ffffffff810d89e0>] ? __lock_page+0x70/0x70
> [ 3120.576460]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3120.576463]  [<ffffffff8156073a>] io_schedule+0x8a/0xd0
> [ 3120.576466]  [<ffffffff810d89e9>] sleep_on_page+0x9/0x10
> [ 3120.576469]  [<ffffffff8155e133>] __wait_on_bit_lock+0x53/0xb0
> [ 3120.576473]  [<ffffffff810d89d2>] __lock_page+0x62/0x70
> [ 3120.576477]  [<ffffffff810603c0>] ? wake_atomic_t_function+0x30/0x30
> [ 3120.576480]  [<ffffffff810d8b71>] find_lock_page+0x51/0x80
> [ 3120.576483]  [<ffffffff810d948a>] find_or_create_page+0x3a/0xc0
> [ 3120.576487]  [<ffffffff8128443c>] prepare_pages.isra.23+0x18c/0x340
> [ 3120.576491]  [<ffffffff81255990>] ? block_rsv_add_bytes+0x50/0x70
> [ 3120.576495]  [<ffffffff81284fca>] __btrfs_buffered_write+0x29a/0x4e0
> [ 3120.576499]  [<ffffffff81285425>] btrfs_file_aio_write+0x215/0x580
> [ 3120.576502]  [<ffffffff8111b30e>] ? kmem_cache_free+0xae/0x180
> [ 3120.576506]  [<ffffffff8113a4a1>] ? final_putname+0x21/0x50
> [ 3120.576510]  [<ffffffff8112eb1b>] do_sync_write+0x7b/0xb0
> [ 3120.576514]  [<ffffffff8112f8f0>] vfs_write+0xc0/0x1f0
> [ 3120.576517]  [<ffffffff8112fded>] SyS_write+0x4d/0xa0
> [ 3120.576521]  [<ffffffff81567b92>] system_call_fastpath+0x16/0x1b
> [ 3120.576543] INFO: task btrfs-transacti:6770 blocked for more than
> 120 seconds.
> [ 3120.576545] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3120.576546] btrfs-transacti D ffff8800a6d6f0c0     0  6770      2 0x00000000
> [ 3120.576549]  ffff8801500f5dd8 0000000000000046 ffff8801500f5d18
> ffff8801500f5fd8
> [ 3120.576553]  ffff8801500f5fd8 0000000000004000 ffff88017f08dbc0
> ffff88015eeb2de0
> [ 3120.576556]  ffff8801a86c0000 ffff8801a86b3990 0000000000000000
> 0000000000000000
> [ 3120.576560] Call Trace:
> [ 3120.576563]  [<ffffffff8124cd05>] ? btrfs_free_path+0x25/0x30
> [ 3120.576567]  [<ffffffff81561e26>] ? _raw_spin_lock+0x16/0x40
> [ 3120.576570]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3120.576573]  [<ffffffff8128b1ff>] ? btrfs_run_ordered_operations+0x20f/0x2c0
> [ 3120.576577]  [<ffffffff81561e68>] ? _raw_spin_lock_irqsave+0x18/0x50
> [ 3120.576580]  [<ffffffff81561c23>] ? _raw_spin_unlock_irqrestore+0x13/0x40
> [ 3120.576583]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3120.576587]  [<ffffffff81272d7d>] btrfs_commit_transaction+0x33d/0x960
> [ 3120.576590]  [<ffffffff81060350>] ? abort_exclusive_wait+0xb0/0xb0
> [ 3120.576594]  [<ffffffff8126ae3d>] transaction_kthread+0x19d/0x220
> [ 3120.576597]  [<ffffffff8126aca0>] ? btrfs_alloc_root+0x30/0x30
> [ 3120.576600]  [<ffffffff8105f7fb>] kthread+0xbb/0xc0
> [ 3120.576604]  [<ffffffff81560000>] ? __schedule+0x4c0/0xa10
> [ 3120.576607]  [<ffffffff8105f740>] ? kthread_freezable_should_stop+0x60/0x60
> [ 3120.576610]  [<ffffffff81567aec>] ret_from_fork+0x7c/0xb0
> [ 3120.576613]  [<ffffffff8105f740>] ? kthread_freezable_should_stop+0x60/0x60
> [ 3120.576634] INFO: task kworker/u8:0:9957 blocked for more than 120 seconds.
> [ 3120.576636] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3120.576637] kworker/u8:0    D ffff8801a4716d20     0  9957      2 0x00000000
> [ 3120.576644] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-7)
> [ 3120.576646]  ffff88010080b6f8 0000000000000046 0000000000000000
> ffff88010080bfd8
> [ 3120.576649]  ffff88010080bfd8 0000000000004000 ffff8801758e16f0
> ffff88014e4f2de0
> [ 3120.576653]  ffff88010080b668 ffffffff8111b477 ffffffff810dadf0
> 0001120000000010
> [ 3120.576656] Call Trace:
> [ 3120.576659]  [<ffffffff8111b477>] ? kmem_cache_alloc+0x57/0xf0
> [ 3120.576663]  [<ffffffff810dadf0>] ? mempool_alloc_slab+0x10/0x20
> [ 3120.576666]  [<ffffffff810dadf0>] ? mempool_alloc_slab+0x10/0x20
> [ 3120.576668]  [<ffffffff810db0f5>] ? mempool_alloc+0x55/0x150
> [ 3120.576672]  [<ffffffff81561e68>] ? _raw_spin_lock_irqsave+0x18/0x50
> [ 3120.576675]  [<ffffffff81561c23>] ? _raw_spin_unlock_irqrestore+0x13/0x40
> [ 3120.576678]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3120.576682]  [<ffffffff81272017>] wait_current_trans.isra.34+0xb7/0x120
> [ 3120.576685]  [<ffffffff81060350>] ? abort_exclusive_wait+0xb0/0xb0
> [ 3120.576688]  [<ffffffff812739f8>] start_transaction+0x288/0x4b0
> [ 3120.576692]  [<ffffffff81273ce2>] btrfs_join_transaction+0x12/0x20
> [ 3120.576695]  [<ffffffff8127aa00>] cow_file_range+0x40/0xe0
> [ 3120.576698]  [<ffffffff8127adfb>] run_delalloc_range+0x35b/0x390
> [ 3120.576702]  [<ffffffff812907f9>] __extent_writepage+0x2b9/0x730
> [ 3120.576706]  [<ffffffff8115c450>] ? end_buffer_async_read+0x1e0/0x1e0
> [ 3120.576709]  [<ffffffff81162400>] ? I_BDEV+0x10/0x10
> [ 3120.576713]  [<ffffffff813328c0>] ? merge+0x50/0xa0
> [ 3120.576718]  [<ffffffff81290f02>]
> extent_write_cache_pages.isra.40.constprop.57+0x292/0x3d0
> [ 3120.576722]  [<ffffffff812912c8>] extent_writepages+0x48/0x60
> [ 3120.576725]  [<ffffffff81276fd0>] ? btrfs_fiemap+0x60/0x60
> [ 3120.576728]  [<ffffffff81275ee3>] btrfs_writepages+0x23/0x30
> [ 3120.576732]  [<ffffffff810e2969>] do_writepages+0x19/0x40
> [ 3120.576736]  [<ffffffff8115489e>] __writeback_single_inode+0x3e/0x140
> [ 3120.576739]  [<ffffffff811559a6>] writeback_sb_inodes+0x276/0x3c0
> [ 3120.576742]  [<ffffffff81155b87>] __writeback_inodes_wb+0x97/0xd0
> [ 3120.576746]  [<ffffffff81155d8b>] wb_writeback+0x1cb/0x1e0
> [ 3120.576749]  [<ffffffff811560ae>] bdi_writeback_workfn+0x15e/0x310
> [ 3120.576754]  [<ffffffff810590d0>] process_one_work+0x140/0x390
> [ 3120.576757]  [<ffffffff81059759>] worker_thread+0x119/0x370
> [ 3120.576761]  [<ffffffff81059640>] ? rescuer_thread+0x2e0/0x2e0
> [ 3120.576764]  [<ffffffff8105f7fb>] kthread+0xbb/0xc0
> [ 3120.576767]  [<ffffffff81560000>] ? __schedule+0x4c0/0xa10
> [ 3120.576771]  [<ffffffff8105f740>] ? kthread_freezable_should_stop+0x60/0x60
> [ 3120.576774]  [<ffffffff81567aec>] ret_from_fork+0x7c/0xb0
> [ 3120.576777]  [<ffffffff8105f740>] ? kthread_freezable_should_stop+0x60/0x60
> [ 3120.576782] INFO: task mythpreviewgen:12052 blocked for more than
> 120 seconds.
> [ 3120.576784] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3120.576785] mythpreviewgen  D ffff88015f6e8670     0 12052  12051 0x00000004
> [ 3120.576789]  ffff8801066adc08 0000000000000082 ffff8801066adb08
> ffff8801066adfd8
> [ 3120.576792]  ffff8801066adfd8 0000000000004000 ffff8801a6cf96f0
> ffff88018080ade0
> [ 3120.576796]  ffff8801a655d0c0 ffff8801a655d0c0 000000006d5f7675
> 0000000000000000
> [ 3120.576799] Call Trace:
> [ 3120.576807]  [<ffffffffa01f7d4a>] ? do_expire_wait+0x17a/0x190 [autofs4]
> [ 3120.576810]  [<ffffffff81561e26>] ? _raw_spin_lock+0x16/0x40
> [ 3120.576813]  [<ffffffff81561e26>] ? _raw_spin_lock+0x16/0x40
> [ 3120.576816]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3120.576819]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3120.576823]  [<ffffffff81560943>] schedule_preempt_disabled+0x13/0x20
> [ 3120.576826]  [<ffffffff8155f0ec>] __mutex_lock_slowpath+0x12c/0x210
> [ 3120.576829]  [<ffffffff8155e23d>] mutex_lock+0x1d/0x40
> [ 3120.576832]  [<ffffffff8113d6e8>] do_last+0x268/0xd20
> [ 3120.576835]  [<ffffffff8113a773>] ? inode_permission+0x13/0x50
> [ 3120.576838]  [<ffffffff8113accd>] ? link_path_walk+0x23d/0x8e0
> [ 3120.576841]  [<ffffffff8113e25d>] path_openat+0xbd/0x6b0
> [ 3120.576845]  [<ffffffff8113eb8e>] do_filp_open+0x3e/0xa0
> [ 3120.576848]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3120.576852]  [<ffffffff8114b31b>] ? __alloc_fd+0xcb/0x120
> [ 3120.576855]  [<ffffffff8112e6ac>] do_sys_open+0x13c/0x230
> [ 3120.576859]  [<ffffffff8112e7bd>] SyS_open+0x1d/0x20
> [ 3120.576861]  [<ffffffff81567b92>] system_call_fastpath+0x16/0x1b
> [ 3120.576864] INFO: task mythpreviewgen:12054 blocked for more than
> 120 seconds.
> [ 3120.576866] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3120.576867] mythpreviewgen  D ffff8801a86c06e0     0 12054  12053 0x00000004
> [ 3120.576870]  ffff880121141b28 0000000000000086 ffff880121141aa8
> ffff880121141fd8
> [ 3120.576874]  ffff880121141fd8 0000000000004000 ffff8801a6cfade0
> ffff88000a795bc0
> [ 3120.576877]  ffff880121141b58 ffffffff8125c7c7 ffff880121141a68
> ffffffff81561ca1
> [ 3120.576881] Call Trace:
> [ 3120.576885]  [<ffffffff8125c7c7>] ? reserve_metadata_bytes+0x177/0x880
> [ 3120.576888]  [<ffffffff81561ca1>] ? _raw_read_unlock+0x11/0x40
> [ 3120.576892]  [<ffffffff812a6f88>] ? btrfs_set_lock_blocking_rw+0xd8/0x110
> [ 3120.576895]  [<ffffffff81251d6f>] ? btrfs_search_slot+0x3ef/0x900
> [ 3120.576899]  [<ffffffff81561e68>] ? _raw_spin_lock_irqsave+0x18/0x50
> [ 3120.576902]  [<ffffffff81561c23>] ? _raw_spin_unlock_irqrestore+0x13/0x40
> [ 3120.576905]  [<ffffffff81560664>] schedule+0x24/0x70
> [ 3120.576908]  [<ffffffff81272017>] wait_current_trans.isra.34+0xb7/0x120
> [ 3120.576911]  [<ffffffff8127388c>] ? start_transaction+0x11c/0x4b0
> [ 3120.576915]  [<ffffffff81060350>] ? abort_exclusive_wait+0xb0/0xb0
> [ 3120.576918]  [<ffffffff81273a56>] start_transaction+0x2e6/0x4b0
> [ 3120.576922]  [<ffffffff81273f66>] btrfs_start_transaction+0x16/0x20
> [ 3120.576925]  [<ffffffff81280d82>] btrfs_create+0x42/0x210
> [ 3120.576928]  [<ffffffff81275f27>] ? btrfs_permission+0x37/0x70
> [ 3120.576931]  [<ffffffff8113a83e>] vfs_create+0x8e/0xf0
> [ 3120.576934]  [<ffffffff8113dd66>] do_last+0x8e6/0xd20
> [ 3120.576937]  [<ffffffff8113a773>] ? inode_permission+0x13/0x50
> [ 3120.576941]  [<ffffffff8113e25d>] path_openat+0xbd/0x6b0
> [ 3120.576944]  [<ffffffff8113eb8e>] do_filp_open+0x3e/0xa0
> [ 3120.576947]  [<ffffffff81561be1>] ? _raw_spin_unlock+0x11/0x40
> [ 3120.576951]  [<ffffffff8114b31b>] ? __alloc_fd+0xcb/0x120
> [ 3120.576954]  [<ffffffff8112e6ac>] do_sys_open+0x13c/0x230
> [ 3120.576957]  [<ffffffff8112e7bd>] SyS_open+0x1d/0x20
> [ 3120.576960]  [<ffffffff81567b92>] system_call_fastpath+0x16/
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Jazz is the sort of music where no-one plays anything the ---    
                             same way once.                              

--snImcH6YoPvXmXT+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUlrBKFheFHXiqx3kAQJW1g/+InGStOXexOAUqzaysZ7PnFzH5ruqe7zV
Vw7zwi7g7FTwK4+ClU+yIl0/nwEop6xGyBX4Tqyly6uNTMFLcHB6P8n+4TAKHCy6
3427qwETK/F2duha8R7SeYeBexXKDMGcJUBQuDDvhP96oPMg7vOyoDu9Ed5nUHZy
on1neLklBl+DvAK21WaMIev8F4qGMpRgDEr8kBaGP/19ldqmuwO+1H+BuhID2/0G
cV/8181zqV67E+HGUC4rbzVZRkhsdR1r1EZPu7VX/SGrK7+5x1VitOMkXu0gZfNu
x8dnAnodzy8r2RT+vvLiSja7NH+f02VnRg0S70Wcw47QvACulZXHxT0i31Jjq9Vt
KFjTIlUZh/qx9rmW+NOj6mPW/nIEcwFs2oFgvqRqShxj1H3YwVHXvRsuNol1PaN2
oZoVvucPBoEdwgWkhoFAEFkORA5q5zJ3u7xhcfQLkKQhVo0HPak3vA0ZgUYD5sK2
pB1KvOo0X8F8M/nNe+LFR/7cM+l5nG/pZns+BXH10s3G1VS74CUIZ5lmu4uGLwtR
GBDLDjoEDXqx0Dv3fHn7smbf4j+Mc+U5QdMExIVSHaS17wgLqEET7M+DtJ+4RFca
oyny5gutTmlB7r2PXBZv85PCBnobYPJOZGUoVVbETsKXWYj+mbsApZd9X4XRIJVy
S+zLr2xLC/s=
=snSH
-----END PGP SIGNATURE-----

--snImcH6YoPvXmXT+--
