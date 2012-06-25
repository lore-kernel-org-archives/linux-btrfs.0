Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60720 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab2FYNIm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 09:08:42 -0400
Message-ID: <4FE862D7.3060005@fusionio.com>
Date: Mon, 25 Jun 2012 09:08:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: Stefan Priebe <s.priebe@profihost.ag>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE58366.8000302@profihost.ag>
In-Reply-To: <4FE58366.8000302@profihost.ag>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/2012 04:50 AM, Stefan Priebe wrote:
> Hello list,
>
> i've seen this deadlock today and can reproduce it while using ceph.
>
> Is this a known bug?
>
> [  599.514534] INFO: task kworker/6:0:29 blocked for more than 120 seconds.
> [  599.530394] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  599.546832] kworker/6:0     D ffffffff8180ebc0     0    29      2
> 0x00000000
> [  599.563725]  ffff880e78f4dc90 0000000000000046 ffff880e78f4a180
> 0000000000012280
> [  599.580812]  ffff880e78f4dfd8 ffff880e78f4c010 0000000000012280
> 0000000000012280
> [  599.580813]  ffff880e78f4dfd8 0000000000012280 ffff880e78e8c340
> ffff880e78f4a180
> [  599.580814] Call Trace:
> [  599.580820]  [<ffffffff81620334>] schedule+0x24/0x70
> [  599.580832]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  599.580836]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580844]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  599.580846]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  599.580847]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580853]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  599.580859]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  599.580861]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  599.580862]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  599.580863]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  599.580865]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  599.580866]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  599.580868]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  599.580869]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
> [  599.580872] INFO: task kworker/2:1:1184 blocked for more than 120
> seconds.
> [  599.580872] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  599.580873] kworker/2:1     D ffffffff8180ebc0     0  1184      2
> 0x00000000
> [  599.580874]  ffff880e448cfc90 0000000000000046 ffff880e46cce380
> 0000000000012280
> [  599.580875]  ffff880e448cffd8 ffff880e448ce010 0000000000012280
> 0000000000012280
> [  599.580876]  ffff880e448cffd8 0000000000012280 ffff880e78e5a240
> ffff880e46cce380
> [  599.580877] Call Trace:
> [  599.580879]  [<ffffffff81620334>] schedule+0x24/0x70
> [  599.580884]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  599.580886]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580891]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  599.580893]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  599.580894]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580899]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  599.580905]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  599.580906]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  599.580907]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  599.580908]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  599.580910]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  599.580911]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  599.580913]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  599.580914]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
> [  599.580915] INFO: task kworker/5:1:1186 blocked for more than 120
> seconds.
> [  599.580915] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  599.580916] kworker/5:1     D ffffffff8180ebc0     0  1186      2
> 0x00000000
> [  599.580917]  ffff880e448a3c90 0000000000000046 ffff880e46d36600
> 0000000000012280
> [  599.580919]  ffff880e448a3fd8 ffff880e448a2010 0000000000012280
> 0000000000012280
> [  599.580920]  ffff880e448a3fd8 0000000000012280 ffff880e78e88300
> ffff880e46d36600
> [  599.580920] Call Trace:
> [  599.580922]  [<ffffffff81620334>] schedule+0x24/0x70
> [  599.580927]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  599.580929]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580934]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  599.580936]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  599.580937]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580942]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  599.580948]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  599.580949]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  599.580950]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  599.580951]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  599.580952]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  599.580954]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  599.580955]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  599.580957]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
> [  599.580966] INFO: task ceph-osd:3248 blocked for more than 120 seconds.
> [  599.580966] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  599.580967] ceph-osd        D 0000000000000006     0  3248      1
> 0x00000000
> [  599.580968]  ffff880bc4201c38 0000000000000082 ffff880e3efc4480
> 0000000000012280
> [  599.580970]  ffff880bc4201fd8 ffff880bc4200010 0000000000012280
> 0000000000012280
> [  599.580971]  ffff880bc4201fd8 0000000000012280 ffff880e78f4a180
> ffff880e3efc4480
> [  599.580971] Call Trace:
> [  599.580972]  [<ffffffff81620334>] schedule+0x24/0x70
> [  599.580978]  [<ffffffffa009dd65>]
> btrfs_commit_transaction_async+0x1d5/0x240 [btrfs]
> [  599.580983]  [<ffffffffa0081eb6>] ? block_rsv_add_bytes+0x26/0x60 [btrfs]
> [  599.580985]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.580990]  [<ffffffffa0081f25>] ? block_rsv_migrate_bytes+0x35/0x50
> [btrfs]
> [  599.580997]  [<ffffffffa00ced2e>] btrfs_mksubvol+0x2be/0x350 [btrfs]
> [  599.581004]  [<ffffffffa00ceec9>]
> btrfs_ioctl_snap_create_transid+0x109/0x1a0 [btrfs]
> [  599.581010]  [<ffffffffa00d0bc4>]
> btrfs_ioctl_snap_create_v2+0x84/0xf0 [btrfs]
> [  599.581016]  [<ffffffffa00d353f>] btrfs_ioctl+0x76f/0x12d0 [btrfs]
> [  599.581019]  [<ffffffff8114459a>] ? fsnotify+0x1ba/0x2e0
> [  599.581021]  [<ffffffff8111ade3>] do_vfs_ioctl+0x93/0x4f0
> [  599.581022]  [<ffffffff8111b28a>] sys_ioctl+0x4a/0x80
> [  599.581024]  [<ffffffff81621ba2>] system_call_fastpath+0x16/0x1b
> [  599.581035] INFO: task ceph-osd:3278 blocked for more than 120 seconds.
> [  599.581035] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  599.581036] ceph-osd        D 0000000000000002     0  3278      1
> 0x00000000
> [  599.581038]  ffff880bc41fbc38 0000000000000082 ffff880e412283c0
> 0000000000012280
> [  599.581039]  ffff880bc41fbfd8 ffff880bc41fa010 0000000000012280
> 0000000000012280
> [  599.581040]  ffff880bc41fbfd8 0000000000012280 ffff880e46cce380
> ffff880e412283c0
> [  599.581040] Call Trace:
> [  599.581042]  [<ffffffff81620334>] schedule+0x24/0x70
> [  599.581048]  [<ffffffffa009dd65>]
> btrfs_commit_transaction_async+0x1d5/0x240 [btrfs]
> [  599.581053]  [<ffffffffa0081eb6>] ? block_rsv_add_bytes+0x26/0x60 [btrfs]
> [  599.581055]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.581059]  [<ffffffffa0081f25>] ? block_rsv_migrate_bytes+0x35/0x50
> [btrfs]
> [  599.581066]  [<ffffffffa00ced2e>] btrfs_mksubvol+0x2be/0x350 [btrfs]
> [  599.581071]  [<ffffffffa00ceec9>]
> btrfs_ioctl_snap_create_transid+0x109/0x1a0 [btrfs]
> [  599.581077]  [<ffffffffa00d0bc4>]
> btrfs_ioctl_snap_create_v2+0x84/0xf0 [btrfs]
> [  599.581082]  [<ffffffffa00d353f>] btrfs_ioctl+0x76f/0x12d0 [btrfs]
> [  599.581084]  [<ffffffff8114459a>] ? fsnotify+0x1ba/0x2e0
> [  599.581085]  [<ffffffff8111ade3>] do_vfs_ioctl+0x93/0x4f0
> [  599.581086]  [<ffffffff8111b28a>] sys_ioctl+0x4a/0x80
> [  599.581088]  [<ffffffff81621ba2>] system_call_fastpath+0x16/0x1b
> [  599.581094] INFO: task ceph-osd:3330 blocked for more than 120 seconds.
> [  599.581094] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  599.581095] ceph-osd        D 0000000000000005     0  3330      1
> 0x00000000
> [  599.581096]  ffff880bc3bf9c38 0000000000000086 ffff880bc3bd4740
> 0000000000012280
> [  599.581098]  ffff880bc3bf9fd8 ffff880bc3bf8010 0000000000012280
> 0000000000012280
> [  599.581099]  ffff880bc3bf9fd8 0000000000012280 ffff880e46d36600
> ffff880bc3bd4740
> [  599.581099] Call Trace:
> [  599.581101]  [<ffffffff81620334>] schedule+0x24/0x70
> [  599.581106]  [<ffffffffa009dd65>]
> btrfs_commit_transaction_async+0x1d5/0x240 [btrfs]
> [  599.581111]  [<ffffffffa0081eb6>] ? block_rsv_add_bytes+0x26/0x60 [btrfs]
> [  599.581113]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  599.581118]  [<ffffffffa0081f25>] ? block_rsv_migrate_bytes+0x35/0x50
> [btrfs]
> [  599.581123]  [<ffffffffa00ced2e>] btrfs_mksubvol+0x2be/0x350 [btrfs]
> [  599.581129]  [<ffffffffa00ceec9>]
> btrfs_ioctl_snap_create_transid+0x109/0x1a0 [btrfs]
> [  599.581134]  [<ffffffffa00d0bc4>]
> btrfs_ioctl_snap_create_v2+0x84/0xf0 [btrfs]
> [  599.581139]  [<ffffffffa00d353f>] btrfs_ioctl+0x76f/0x12d0 [btrfs]
> [  599.581141]  [<ffffffff8114459a>] ? fsnotify+0x1ba/0x2e0
> [  599.581142]  [<ffffffff8111ade3>] do_vfs_ioctl+0x93/0x4f0
> [  599.581143]  [<ffffffff8111b28a>] sys_ioctl+0x4a/0x80
> [  599.581145]  [<ffffffff81621ba2>] system_call_fastpath+0x16/0x1b
> [  719.395814] INFO: task kworker/6:0:29 blocked for more than 120 seconds.
> [  719.417426] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  719.439537] kworker/6:0     D ffffffff8180ebc0     0    29      2
> 0x00000000
> [  719.461937]  ffff880e78f4dc90 0000000000000046 ffff880e78f4a180
> 0000000000012280
> [  719.484547]  ffff880e78f4dfd8 ffff880e78f4c010 0000000000012280
> 0000000000012280
> [  719.507211]  ffff880e78f4dfd8 0000000000012280 ffff880e78e8c340
> ffff880e78f4a180
> [  719.530071] Call Trace:
> [  719.552729]  [<ffffffff81620334>] schedule+0x24/0x70
> [  719.552741]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  719.552744]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552752]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  719.552755]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  719.552756]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552762]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  719.552768]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  719.552770]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  719.552771]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  719.552772]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  719.552774]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  719.552776]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  719.552777]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  719.552779]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
> [  719.552781] INFO: task kworker/3:1:578 blocked for more than 120 seconds.
> [  719.552781] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  719.552783] kworker/3:1     D ffffffff8180ebc0     0   578      2
> 0x00000000
> [  719.552784]  ffff880e45dd3c90 0000000000000046 ffff880e7890e080
> 0000000000012280
> [  719.552786]  ffff880e45dd3fd8 ffff880e45dd2010 0000000000012280
> 0000000000012280
> [  719.552787]  ffff880e45dd3fd8 0000000000012280 ffff880e78e7e280
> ffff880e7890e080
> [  719.552787] Call Trace:
> [  719.552789]  [<ffffffff81620334>] schedule+0x24/0x70
> [  719.552795]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  719.552797]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552802]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  719.552804]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  719.552805]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552810]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  719.552816]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  719.552817]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  719.552818]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  719.552819]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  719.552820]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  719.552822]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  719.552824]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  719.552825]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
> [  719.552827] INFO: task kworker/2:1:1184 blocked for more than 120
> seconds.
> [  719.552827] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  719.552828] kworker/2:1     D ffffffff8180ebc0     0  1184      2
> 0x00000000
> [  719.552830]  ffff880e448cfc90 0000000000000046 ffff880e46cce380
> 0000000000012280
> [  719.552831]  ffff880e448cffd8 ffff880e448ce010 0000000000012280
> 0000000000012280
> [  719.552832]  ffff880e448cffd8 0000000000012280 ffff880e78e5a240
> ffff880e46cce380
> [  719.552832] Call Trace:
> [  719.552834]  [<ffffffff81620334>] schedule+0x24/0x70
> [  719.552839]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  719.552841]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552846]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  719.552848]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  719.552849]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552854]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  719.552859]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  719.552861]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  719.552862]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  719.552863]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  719.552864]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  719.552866]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  719.552867]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  719.552868]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
> [  719.552869] INFO: task kworker/5:1:1186 blocked for more than 120
> seconds.
> [  719.552869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  719.552870] kworker/5:1     D ffffffff8180ebc0     0  1186      2
> 0x00000000
> [  719.552872]  ffff880e448a3c90 0000000000000046 ffff880e46d36600
> 0000000000012280
> [  719.552873]  ffff880e448a3fd8 ffff880e448a2010 0000000000012280
> 0000000000012280
> [  719.552874]  ffff880e448a3fd8 0000000000012280 ffff880e78e88300
> ffff880e46d36600
> [  719.552874] Call Trace:
> [  719.552876]  [<ffffffff81620334>] schedule+0x24/0x70
> [  719.552881]  [<ffffffffa009b4c5>] wait_for_commit+0x55/0x90 [btrfs]
> [  719.552883]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552888]  [<ffffffffa009d095>]
> btrfs_commit_transaction+0x655/0xab0 [btrfs]
> [  719.552890]  [<ffffffff81076058>] ? idle_balance+0x108/0x130
> [  719.552891]  [<ffffffff81060140>] ? wake_up_bit+0x40/0x40
> [  719.552896]  [<ffffffffa009d7f0>] ? btrfs_end_transaction+0x20/0x20
> [btrfs]
> [  719.552901]  [<ffffffffa009d80a>] do_async_commit+0x1a/0x30 [btrfs]
> [  719.552902]  [<ffffffff81058eff>] process_one_work+0x11f/0x470
> [  719.552903]  [<ffffffff8105b128>] worker_thread+0x178/0x400
> [  719.552904]  [<ffffffff8105afb0>] ? manage_workers+0x210/0x210
> [  719.552906]  [<ffffffff8105fc46>] kthread+0x96/0xa0
> [  719.552907]  [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10
> [  719.552909]  [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130
> [  719.552910]  [<ffffffff81622dd0>] ? gs_change+0xb/0xb
>

This isn't showing the guy who's actually trying to commit the 
transaction.  Next time this happens can you do a sysrq+w and capture 
the output and post it here so we can see what everybody is doing?  Thanks,

Josef
