Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33123 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965593AbeFOP5R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 11:57:17 -0400
Date: Fri, 15 Jun 2018 17:54:28 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: sync log after logging new name
Message-ID: <20180615155428.GG24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180611182428.18102-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180611182428.18102-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 11, 2018 at 07:24:28PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
> Reported-by: Vijay Chidambaram <vvijay03@gmail.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

There are some warnings and possible lock up caused by this patch, the
1/2 alone is ok but 1/2 + 2/2 leads to the following warnings. I checked
twice, the patch base was the pull request ie. without any other 4.18
stuff.

It's a qemu with 4 cpus and 2g of memory.

btrfs/011

[  876.705586] watchdog: BUG: soft lockup - CPU#2 stuck for 77s!
[od:12857]
[  876.708167] Modules linked in: btrfs libcrc32c xor zstd_decompresszstd_compress xxhash raid6_pq loop
[  876.710717] CPU: 2 PID: 12857 Comm: od Not tainted4.17.0-rc7-default+ #143
[  876.712007] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[  876.713333] RIP: 0010:copy_user_generic_string+0x2c/0x40
[  876.714586] RSP: 0018:ffffa7968344bc68 EFLAGS: 00010246 ORIG_RAX:ffffffffffffff13
[  876.716411] RAX: 000055b128b4a370 RBX: 0000000000001000 RCX:0000000000000200
[  876.718023] RDX: 0000000000000000 RSI: 000055b128b49370 RDI:ffff88bb1b600000
[  876.719681] RBP: 0000000000001000 R08: ffff88bb1b600000 R09:ffff88bb00000000
[  876.721568] R10: 0000000000001000 R11: 0000000000000030 R12:0000000000001000
[  876.723123] R13: ffff88bb1b601000 R14: ffffa7968344be58 R15:0000000000000000
[  876.724087] FS:  00007f417c596540(0000) GS:ffff88bb7fd00000(0000)knlGS:0000000000000000
[  876.725165] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  876.726375] CR2: 000055c99ecbf298 CR3: 0000000068436000 CR4:00000000000006e0
[  876.728080] Call Trace:
[  876.728849]  copyin+0x22/0x30
[  876.729704]  iov_iter_copy_from_user_atomic+0x19a/0x410
[  876.730789]  ? ptep_clear_flush+0x40/0x40
[  876.731391]  btrfs_copy_from_user+0xab/0x120 [btrfs]
[  876.732058]  __btrfs_buffered_write+0x367/0x710 [btrfs]
[  876.732747]  btrfs_file_write_iter+0x2b8/0x5d0 [btrfs]
[  876.733507]  ? touch_atime+0x27/0xb0
[  876.734257]  __vfs_write+0xd4/0x130
[  876.734860]  vfs_write+0xad/0x1e0
[  876.735346]  ksys_write+0x42/0x90
[  876.735858]  do_syscall_64+0x4f/0xe0
[  876.736515]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  876.737690] RIP: 0033:0x7f417c0a3c94
[  876.738565] RSP: 002b:00007ffc07af7c48 EFLAGS: 00000246 ORIG_RAX:0000000000000001
[  876.740186] RAX: ffffffffffffffda RBX: 0000000000001000 RCX:00007f417c0a3c94
[  876.741263] RDX: 0000000000001000 RSI: 000055b128b49370 RDI:0000000000000001
[  876.742819] RBP: 000055b128b49370 R08: 00007f417c372760 R09:0000000000000000
[  876.744157] R10: 00000000000007d0 R11: 0000000000000246 R12:00007f417c372760
[  876.745507] R13: 0000000000001000 R14: 00007f417c36d760 R15:0000000000001000
[ 1463.260071] INFO: task kworker/u8:12:9261 blocked for more than 480seconds.
[ 1463.264100]       Tainted: G             L    4.17.0-rc7-default+#143
[ 1463.267639] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"disables this message.
[ 1463.272086] kworker/u8:12   D    0  9261      2 0x80000000
[ 1463.274224] Workqueue: btrfs-submit btrfs_submit_helper [btrfs]
[ 1463.275442] Call Trace:
[ 1463.276221]  ? __schedule+0x268/0x7f0
[ 1463.277348]  schedule+0x33/0x90
[ 1463.278105]  io_schedule+0x16/0x40
[ 1463.279053]  wbt_wait+0x19b/0x310
[ 1463.280085]  ? finish_wait+0x80/0x80
[ 1463.281153]  blk_mq_make_request+0xba/0x6f0
[ 1463.282354]  generic_make_request+0x173/0x3d0
[ 1463.283617]  ? submit_bio+0x6c/0x140
[ 1463.284678]  submit_bio+0x6c/0x140
[ 1463.285705]  run_scheduled_bios+0x18e/0x480 [btrfs]
[ 1463.287121]  ? normal_work_helper+0x6a/0x330 [btrfs]
[ 1463.288543]  normal_work_helper+0x6a/0x330 [btrfs]
[ 1463.289937]  process_one_work+0x16d/0x380
[ 1463.291119]  worker_thread+0x2e/0x380
[ 1463.292205]  ? process_one_work+0x380/0x380
[ 1463.293420]  kthread+0x111/0x130
[ 1463.294377]  ? kthread_create_worker_on_cpu+0x50/0x50
[ 1463.295782]  ret_from_fork+0x1f/0x30
[ 1463.296827] INFO: task btrfs-transacti:5799 blocked for more than 480 seconds.
[ 1463.298874]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1463.300596] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1463.302784] btrfs-transacti D    0  5799      2 0x80000000
[ 1463.305441] Call Trace:
[ 1463.306176]  ? __schedule+0x268/0x7f0
[ 1463.307207]  schedule+0x33/0x90
[ 1463.308134]  wait_for_commit+0x2c/0x60 [btrfs]
[ 1463.309359]  ? finish_wait+0x80/0x80
[ 1463.310389]  btrfs_commit_transaction+0x18c/0x920 [btrfs]
[ 1463.311852]  ? start_transaction+0xa1/0x3f0 [btrfs]
[ 1463.313209]  transaction_kthread+0x151/0x180 [btrfs]
[ 1463.314541]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[ 1463.316024]  kthread+0x111/0x130
[ 1463.316868]  ? kthread_create_worker_on_cpu+0x50/0x50
[ 1463.318134]  ret_from_fork+0x1f/0x30
[ 1463.319116] INFO: task btrfs:12859 blocked for more than 480 seconds.
[ 1463.320402]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1463.321759] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1463.323299] btrfs           D    0 12859      1 0x00000002
[ 1463.324395] Call Trace:
[ 1463.325049]  ? __schedule+0x268/0x7f0
[ 1463.325987]  ? bit_wait+0x50/0x50
[ 1463.326835]  schedule+0x33/0x90
[ 1463.327646]  io_schedule+0x16/0x40
[ 1463.328556]  bit_wait_io+0xd/0x50
[ 1463.329512]  __wait_on_bit+0x42/0x80
[ 1463.330471]  ? submit_bio+0x6c/0x140
[ 1463.331425]  out_of_line_wait_on_bit+0x81/0x90
[ 1463.332581]  ? init_wait_var_entry+0x40/0x40
[ 1463.333731]  write_all_supers+0x3fe/0xe60 [btrfs]
[ 1463.334947]  btrfs_commit_transaction+0x5aa/0x920 [btrfs]
[ 1463.336326]  ? start_transaction+0xa1/0x3f0 [btrfs]
[ 1463.337588]  btrfs_dev_replace_finishing+0x49e/0x520 [btrfs]
[ 1463.338957]  btrfs_dev_replace_start+0x42e/0x590 [btrfs]
[ 1463.340188]  btrfs_dev_replace_by_ioctl+0x35/0x60 [btrfs]
[ 1463.341496]  btrfs_ioctl+0x263f/0x3080 [btrfs]
[ 1463.342609]  ? alloc_set_pte+0x10a/0x3b0
[ 1463.343593]  ? filemap_map_pages+0x127/0x2a0
[ 1463.344644]  ? __handle_mm_fault+0x84e/0xc60
[ 1463.345704]  ? do_vfs_ioctl+0x8d/0x5d0
[ 1463.346675]  do_vfs_ioctl+0x8d/0x5d0
[ 1463.347629]  ? handle_mm_fault+0xe6/0x220
[ 1463.348668]  ksys_ioctl+0x3a/0x70
[ 1463.349575]  __x64_sys_ioctl+0x16/0x20
[ 1463.350576]  do_syscall_64+0x4f/0xe0
[ 1463.351529]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1463.352824] RIP: 0033:0x7f2105516967
[ 1463.353787] RSP: 002b:00007ffe5626bd98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1463.355689] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2105516967
[ 1463.357422] RDX: 00007ffe5626c1d0 RSI: 00000000ca289435 RDI: 0000000000000003
[ 1463.359146] RBP: 0000000000000004 R08: 00007f21067308c0 R09: 00007f21059fe2a0
[ 1463.360889] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe5626f368
[ 1463.362625] R13: 0000000000000000 R14: 0000000000000001 R15: 000056541bbfd2a0
[ 1463.364368] INFO: task btrfs:12861 blocked for more than 480 seconds.
[ 1463.365917]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1463.367483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1463.369453] btrfs           D    0 12861  19330 0x00000000
[ 1463.370799] Call Trace:
[ 1463.371492]  ? __schedule+0x268/0x7f0
[ 1463.372453]  schedule+0x33/0x90
[ 1463.373316]  schedule_preempt_disabled+0x15/0x20
[ 1463.374472]  __mutex_lock.isra.3+0x282/0x500
[ 1463.375562]  ? btrfs_dev_replace_cancel+0x3f/0x270 [btrfs]
[ 1463.376915]  btrfs_dev_replace_cancel+0x3f/0x270 [btrfs]
[ 1463.378245]  btrfs_ioctl+0xe8b/0x3080 [btrfs]
[ 1463.379172]  ? mem_cgroup_commit_charge+0x54/0x470
[ 1463.380228]  ? __alloc_pages_nodemask+0xb2/0x220
[ 1463.381341]  ? get_mem_cgroup_from_mm+0x6f/0xc0
[ 1463.382309]  ? __handle_mm_fault+0x65b/0xc60
[ 1463.383186]  ? do_vfs_ioctl+0x8d/0x5d0
[ 1463.384010]  do_vfs_ioctl+0x8d/0x5d0
[ 1463.384851]  ? handle_mm_fault+0xe6/0x220
[ 1463.385808]  ksys_ioctl+0x3a/0x70
[ 1463.386671]  __x64_sys_ioctl+0x16/0x20
[ 1463.387635]  do_syscall_64+0x4f/0xe0
[ 1463.388462]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1463.389714] RIP: 0033:0x7fa32c72d967
[ 1463.390643] RSP: 002b:00007fff8d37f398 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[ 1463.392538] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa32c72d967
[ 1463.394208] RDX: 00007fff8d37f3b0 RSI: 00000000ca289435 RDI: 0000000000000003
[ 1463.395913] RBP: 00007fff8d37f3b0 R08: 0000000000000003 R09: 00007fa32c6e1490
[ 1463.397332] R10: 0000000000000573 R11: 0000000000000202 R12: 0000000000000003
[ 1463.398682] R13: 00007fff8d382368 R14: 0000000000000000 R15: 0000000000000000
[ 1954.780101] INFO: task kworker/u8:12:9261 blocked for more than 480 seconds.
[ 1954.783606]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1954.785435] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1954.787603] kworker/u8:12   D    0  9261      2 0x80000000
[ 1954.789838] Workqueue: btrfs-submit btrfs_submit_helper [btrfs]
[ 1954.791942] Call Trace:
[ 1954.792896]  ? __schedule+0x268/0x7f0
[ 1954.794021]  schedule+0x33/0x90
[ 1954.794781]  io_schedule+0x16/0x40
[ 1954.795687]  wbt_wait+0x19b/0x310
[ 1954.796663]  ? finish_wait+0x80/0x80
[ 1954.797528]  blk_mq_make_request+0xba/0x6f0
[ 1954.798404]  generic_make_request+0x173/0x3d0
[ 1954.799477]  ? submit_bio+0x6c/0x140
[ 1954.800427]  submit_bio+0x6c/0x140
[ 1954.801008]  run_scheduled_bios+0x18e/0x480 [btrfs]
[ 1954.802338]  ? normal_work_helper+0x6a/0x330 [btrfs]
[ 1954.803289]  normal_work_helper+0x6a/0x330 [btrfs]
[ 1954.803931]  process_one_work+0x16d/0x380
[ 1954.804493]  worker_thread+0x2e/0x380
[ 1954.805014]  ? process_one_work+0x380/0x380
[ 1954.805838]  kthread+0x111/0x130
[ 1954.806679]  ? kthread_create_worker_on_cpu+0x50/0x50
[ 1954.807709]  ret_from_fork+0x1f/0x30
[ 1954.808620] INFO: task btrfs-transacti:5799 blocked for more than 480 seconds.
[ 1954.810106]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1954.811695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1954.813547] btrfs-transacti D    0  5799      2 0x80000000
[ 1954.814841] Call Trace:
[ 1954.815397]  ? __schedule+0x268/0x7f0
[ 1954.816027]  schedule+0x33/0x90
[ 1954.816510]  wait_for_commit+0x2c/0x60 [btrfs]
[ 1954.817111]  ? finish_wait+0x80/0x80
[ 1954.817918]  btrfs_commit_transaction+0x18c/0x920 [btrfs]
[ 1954.819088]  ? start_transaction+0xa1/0x3f0 [btrfs]
[ 1954.820060]  transaction_kthread+0x151/0x180 [btrfs]
[ 1954.821122]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[ 1954.822076]  kthread+0x111/0x130
[ 1954.822561]  ? kthread_create_worker_on_cpu+0x50/0x50
[ 1954.823215]  ret_from_fork+0x1f/0x30
[ 1954.823724] INFO: task btrfs:12859 blocked for more than 480 seconds.
[ 1954.824519]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1954.825355] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1954.827235] btrfs           D    0 12859      1 0x00000002
[ 1954.828439] Call Trace:
[ 1954.828977]  ? __schedule+0x268/0x7f0
[ 1954.829776]  ? bit_wait+0x50/0x50
[ 1954.830560]  schedule+0x33/0x90
[ 1954.831467]  io_schedule+0x16/0x40
[ 1954.832322]  bit_wait_io+0xd/0x50
[ 1954.833109]  __wait_on_bit+0x42/0x80
[ 1954.833931]  ? submit_bio+0x6c/0x140
[ 1954.834754]  out_of_line_wait_on_bit+0x81/0x90
[ 1954.835755]  ? init_wait_var_entry+0x40/0x40
[ 1954.836717]  write_all_supers+0x3fe/0xe60 [btrfs]
[ 1954.837879]  btrfs_commit_transaction+0x5aa/0x920 [btrfs]
[ 1954.839093]  ? start_transaction+0xa1/0x3f0 [btrfs]
[ 1954.840340]  btrfs_dev_replace_finishing+0x49e/0x520 [btrfs]
[ 1954.841258]  btrfs_dev_replace_start+0x42e/0x590 [btrfs]
[ 1954.841954]  btrfs_dev_replace_by_ioctl+0x35/0x60 [btrfs]
[ 1954.842657]  btrfs_ioctl+0x263f/0x3080 [btrfs]
[ 1954.843258]  ? alloc_set_pte+0x10a/0x3b0
[ 1954.843800]  ? filemap_map_pages+0x127/0x2a0
[ 1954.844382]  ? __handle_mm_fault+0x84e/0xc60
[ 1954.844962]  ? do_vfs_ioctl+0x8d/0x5d0
[ 1954.845557]  do_vfs_ioctl+0x8d/0x5d0
[ 1954.846438]  ? handle_mm_fault+0xe6/0x220
[ 1954.847293]  ksys_ioctl+0x3a/0x70
[ 1954.847861]  __x64_sys_ioctl+0x16/0x20
[ 1954.848398]  do_syscall_64+0x4f/0xe0
[ 1954.848910]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1954.849589] RIP: 0033:0x7f2105516967
[ 1954.850272] RSP: 002b:00007ffe5626bd98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1954.851350] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2105516967
[ 1954.852212] RDX: 00007ffe5626c1d0 RSI: 00000000ca289435 RDI: 0000000000000003
[ 1954.853069] RBP: 0000000000000004 R08: 00007f21067308c0 R09: 00007f21059fe2a0
[ 1954.854601] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe5626f368
[ 1954.855957] R13: 0000000000000000 R14: 0000000000000001 R15: 000056541bbfd2a0
[ 1954.857196] INFO: task btrfs:12861 blocked for more than 480 seconds.
[ 1954.858748]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 1954.860162] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1954.861666] btrfs           D    0 12861  19330 0x00000000
[ 1954.863070] Call Trace:
[ 1954.863797]  ? __schedule+0x268/0x7f0
[ 1954.864782]  schedule+0x33/0x90
[ 1954.865511]  schedule_preempt_disabled+0x15/0x20
[ 1954.866394]  __mutex_lock.isra.3+0x282/0x500
[ 1954.867398]  ? btrfs_dev_replace_cancel+0x3f/0x270 [btrfs]
[ 1954.869333]  btrfs_dev_replace_cancel+0x3f/0x270 [btrfs]
[ 1954.870820]  btrfs_ioctl+0xe8b/0x3080 [btrfs]
[ 1954.874085]  ? mem_cgroup_commit_charge+0x54/0x470
[ 1954.875247]  ? __alloc_pages_nodemask+0xb2/0x220
[ 1954.875927]  ? get_mem_cgroup_from_mm+0x6f/0xc0
[ 1954.876541]  ? __handle_mm_fault+0x65b/0xc60
[ 1954.877126]  ? do_vfs_ioctl+0x8d/0x5d0
[ 1954.877808]  do_vfs_ioctl+0x8d/0x5d0
[ 1954.878421]  ? handle_mm_fault+0xe6/0x220
[ 1954.878988]  ksys_ioctl+0x3a/0x70
[ 1954.879476]  __x64_sys_ioctl+0x16/0x20
[ 1954.880015]  do_syscall_64+0x4f/0xe0
[ 1954.880533]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1954.881200] RIP: 0033:0x7fa32c72d967
[ 1954.882170] RSP: 002b:00007fff8d37f398 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[ 1954.884106] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa32c72d967
[ 1954.885784] RDX: 00007fff8d37f3b0 RSI: 00000000ca289435 RDI: 0000000000000003
[ 1954.886774] RBP: 00007fff8d37f3b0 R08: 0000000000000003 R09: 00007fa32c6e1490
[ 1954.887639] R10: 0000000000000573 R11: 0000000000000202 R12: 0000000000000003
[ 1954.888524] R13: 00007fff8d382368 R14: 0000000000000000 R15: 0000000000000000
[ 2446.300063] INFO: task kworker/u8:12:9261 blocked for more than 480 seconds.
[ 2446.304546]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 2446.308635] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2446.311008] kworker/u8:12   D    0  9261      2 0x80000000
[ 2446.312565] Workqueue: btrfs-submit btrfs_submit_helper [btrfs]
[ 2446.314264] Call Trace:
[ 2446.315048]  ? __schedule+0x268/0x7f0
[ 2446.316167]  schedule+0x33/0x90
[ 2446.317137]  io_schedule+0x16/0x40
[ 2446.318178]  wbt_wait+0x19b/0x310
[ 2446.319184]  ? finish_wait+0x80/0x80
[ 2446.320270]  blk_mq_make_request+0xba/0x6f0
[ 2446.321515]  generic_make_request+0x173/0x3d0
[ 2446.322842]  ? submit_bio+0x6c/0x140
[ 2446.323900]  submit_bio+0x6c/0x140
[ 2446.324936]  run_scheduled_bios+0x18e/0x480 [btrfs]
[ 2446.326333]  ? normal_work_helper+0x6a/0x330 [btrfs]
[ 2446.327699]  normal_work_helper+0x6a/0x330 [btrfs]
[ 2446.328901]  process_one_work+0x16d/0x380
[ 2446.329809]  worker_thread+0x2e/0x380
[ 2446.330711]  ? process_one_work+0x380/0x380
[ 2446.331858]  kthread+0x111/0x130
[ 2446.332840]  ? kthread_create_worker_on_cpu+0x50/0x50
[ 2446.333796]  ret_from_fork+0x1f/0x30
[ 2446.334822] INFO: task btrfs-transacti:5799 blocked for more than 480 seconds.
[ 2446.336809]       Tainted: G             L    4.17.0-rc7-default+ #143
[ 2446.337828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2446.338864] btrfs-transacti D    0  5799      2 0x80000000
[ 2446.339562] Call Trace:
[ 2446.339964]  ? __schedule+0x268/0x7f0
[ 2446.340490]  schedule+0x33/0x90
[ 2446.340973]  wait_for_commit+0x2c/0x60 [btrfs]
[ 2446.341905]  ? finish_wait+0x80/0x80
[ 2446.342947]  btrfs_commit_transaction+0x18c/0x920 [btrfs]
[ 2446.344438]  ? start_transaction+0xa1/0x3f0 [btrfs]
[ 2446.345781]  transaction_kthread+0x151/0x180 [btrfs]
[ 2446.347136]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[ 2446.348645]  kthread+0x111/0x130
[ 2446.349577]  ? kthread_create_worker_on_cpu+0x50/0x50
[ 2446.350932]  ret_from_fork+0x1f/0x30
