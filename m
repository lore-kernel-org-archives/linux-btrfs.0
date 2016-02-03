Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19557 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcBCAlv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 19:41:51 -0500
Date: Tue, 2 Feb 2016 16:41:42 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160203004142.GC26438@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 03, 2016 at 01:20:22AM +0500, Михаил Гаврилов wrote:
> Hi all! I have problem with hanging btrfs file system.

It's not clear that who held the lock, any luck to find clues in
sysrq+w?

Thanks,

-liubo
> 
> [17047.652816] INFO: task btrfs-cleaner:770 blocked for more than 120 seconds.
> [17047.652837]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.652853] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.652875] btrfs-cleaner   D ffff8807fe3d7a18 10264   770      2 0x00000080
> [17047.652880]  ffff8807e50f7a50 0000000000000092 ffffffff811067cd
> ffff880700000000
> [17047.652882]  ffff8807fa344000 ffff8807e68ec000 ffff8807e50f8000
> ffff880003753e90
> [17047.652884]  ffff8807e68ec000 ffff8807e68ec000 ffff8807e50f7a90
> ffff8807e50f7a68
> [17047.652886] Call Trace:
> [17047.652891]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.652894]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.652909]  [<ffffffffa0743ad2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [17047.652912]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.652918]  [<ffffffffa06d96d4>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [17047.652923]  [<ffffffffa06e15e9>] btrfs_search_forward+0x59/0x350 [btrfs]
> [17047.652927]  [<ffffffff81247cb1>] ? kmem_cache_alloc+0x281/0x310
> [17047.652931]  [<ffffffffa06d92aa>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [17047.652940]  [<ffffffffa073c946>]
> find_new_extents.constprop.43+0xa6/0x2d0 [btrfs]
> [17047.652942]  [<ffffffff81106739>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [17047.652943]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.652952]  [<ffffffffa0740418>] btrfs_defrag_file+0x8d8/0xd60 [btrfs]
> [17047.652955]  [<ffffffff81270ad9>] ? __sb_start_write+0xc9/0x110
> [17047.652963]  [<ffffffffa07197b2>] btrfs_run_defrag_inodes+0x242/0x390 [btrfs]
> [17047.652971]  [<ffffffffa0719660>] ?
> btrfs_run_defrag_inodes+0xf0/0x390 [btrfs]
> [17047.652978]  [<ffffffffa06fce1b>] cleaner_kthread+0xcb/0x210 [btrfs]
> [17047.652984]  [<ffffffffa06fcd50>] ?
> btree_read_extent_buffer_pages.constprop.54+0x110/0x110 [btrfs]
> [17047.652986]  [<ffffffff810d1351>] kthread+0x101/0x120
> [17047.652987]  [<ffffffff81106739>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [17047.652989]  [<ffffffff810d1250>] ? kthread_create_on_node+0x250/0x250
> [17047.652991]  [<ffffffff818673af>] ret_from_fork+0x3f/0x70
> [17047.652992]  [<ffffffff810d1250>] ? kthread_create_on_node+0x250/0x250
> [17047.652993] 1 lock held by btrfs-cleaner/770:
> [17047.652994]  #0:  (sb_writers#16){.+.+.+}, at: [<ffffffff81270ad9>]
> __sb_start_write+0xc9/0x110
> [17047.652999] INFO: task btrfs-transacti:771 blocked for more than 120 seconds.
> [17047.653019]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653032] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653053] btrfs-transacti D ffff8807fe1d7a18  9912   771      2 0x00000080
> [17047.653056]  ffff8807e50fbb20 0000000000000096 ffffffff811067cd
> ffff880700000000
> [17047.653058]  ffff8807fa33c000 ffff8807f7140000 ffff8807e50fc000
> ffff880003753e90
> [17047.653060]  ffff8807f7140000 ffff8807f7140000 ffff8807e50fbb60
> ffff8807e50fbb38
> [17047.653062] Call Trace:
> [17047.653063]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.653065]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653074]  [<ffffffffa0743ad2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [17047.653076]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.653081]  [<ffffffffa06d96d4>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [17047.653086]  [<ffffffffa06de8ff>] btrfs_search_slot+0x73f/0x9f0 [btrfs]
> [17047.653092]  [<ffffffffa06e04c1>] btrfs_insert_empty_items+0x71/0xc0 [btrfs]
> [17047.653101]  [<ffffffffa075e9e5>]
> __btrfs_run_delayed_items+0x135/0x600 [btrfs]
> [17047.653104]  [<ffffffff810e5e8c>] ? local_clock+0x1c/0x20
> [17047.653113]  [<ffffffffa075f4f3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [17047.653120]  [<ffffffffa0705fc0>]
> btrfs_commit_transaction+0x2f0/0xbd0 [btrfs]
> [17047.653127]  [<ffffffffa0700f48>] transaction_kthread+0x208/0x270 [btrfs]
> [17047.653134]  [<ffffffffa0700d40>] ?
> btrfs_cleanup_transaction+0x610/0x610 [btrfs]
> [17047.653135]  [<ffffffff810d1351>] kthread+0x101/0x120
> [17047.653137]  [<ffffffff81106739>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [17047.653138]  [<ffffffff810d1250>] ? kthread_create_on_node+0x250/0x250
> [17047.653140]  [<ffffffff818673af>] ret_from_fork+0x3f/0x70
> [17047.653141]  [<ffffffff810d1250>] ? kthread_create_on_node+0x250/0x250
> [17047.653142] 2 locks held by btrfs-transacti/771:
> [17047.653143]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
> at: [<ffffffffa0700db2>] transaction_kthread+0x72/0x270 [btrfs]
> [17047.653151]  #1:  (&delayed_node->mutex){+.+.-.}, at:
> [<ffffffffa075e9ac>] __btrfs_run_delayed_items+0xfc/0x600 [btrfs]
> [17047.653190] INFO: task systemd:2059 blocked for more than 120 seconds.
> [17047.653209]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653225] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653246] systemd         D ffff8807fe5d7a18 12696  2059      1 0x00000000
> [17047.653250]  ffff8807f6d9f9b8 0000000000000082 ffffffff81f62300
> 0000000000000004
> [17047.653252]  ffff880725b84000 ffff8807c0afc000 ffff8807f6da0000
> ffff880003753e90
> [17047.653253]  ffff8807c0afc000 ffff8807c0afc000 ffff8807f6d9f9f8
> ffff8807f6d9f9d0
> [17047.653255] Call Trace:
> [17047.653257]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653266]  [<ffffffffa0743ad2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [17047.653268]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.653273]  [<ffffffffa06d96d4>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [17047.653278]  [<ffffffffa06de8ff>] btrfs_search_slot+0x73f/0x9f0 [btrfs]
> [17047.653286]  [<ffffffffa0782058>] ? btrfs_crc32c+0x68/0x90 [btrfs]
> [17047.653292]  [<ffffffffa06f7b68>] btrfs_lookup_dir_item+0x78/0xc0 [btrfs]
> [17047.653300]  [<ffffffffa0713ab6>] btrfs_lookup_dentry+0xb6/0x550 [btrfs]
> [17047.653302]  [<ffffffff81866597>] ? _raw_spin_unlock+0x27/0x40
> [17047.653309]  [<ffffffffa0713f62>] btrfs_lookup+0x12/0x40 [btrfs]
> [17047.653311]  [<ffffffff81277dcd>] lookup_real+0x1d/0x60
> [17047.653312]  [<ffffffff81278d72>] __lookup_hash+0x42/0x60
> [17047.653314]  [<ffffffff8127c2ef>] walk_component+0x1df/0x2a0
> [17047.653315]  [<ffffffff8127c540>] link_path_walk+0x190/0x5a0
> [17047.653317]  [<ffffffff8127bb57>] ? path_init+0x557/0x800
> [17047.653318]  [<ffffffff8127bb0f>] ? path_init+0x50f/0x800
> [17047.653319]  [<ffffffff8127cb8b>] path_openat+0xab/0x1260
> [17047.653321]  [<ffffffff81025c09>] ? sched_clock+0x9/0x10
> [17047.653323]  [<ffffffff810e5e8c>] ? local_clock+0x1c/0x20
> [17047.653325]  [<ffffffff8127f1a1>] do_filp_open+0x91/0x100
> [17047.653326]  [<ffffffff81866597>] ? _raw_spin_unlock+0x27/0x40
> [17047.653328]  [<ffffffff8128f56f>] ? __alloc_fd+0xaf/0x180
> [17047.653330]  [<ffffffff8126cb9a>] do_sys_open+0x13a/0x230
> [17047.653332]  [<ffffffff8126ccae>] SyS_open+0x1e/0x20
> [17047.653333]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.653335] 1 lock held by systemd/2059:
> [17047.653335]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
> [<ffffffff8127c2e0>] walk_component+0x1d0/0x2a0
> [17047.653345] INFO: task gnome-shell:2455 blocked for more than 120 seconds.
> [17047.653362]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653377] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653398] gnome-shell     D ffff8807fe3d7a18 11064  2455   2276 0x00000000
> [17047.653401]  ffff8807b48cfb70 0000000000000096 ffff8807b5a64928
> ffff880700000000
> [17047.653403]  ffff8807fa344000 ffff8807b5a64000 ffff8807b48d0000
> 0000000000000246
> [17047.653405]  ffff8807e5fa0cd0 ffff8807b5a64000 00000000ffffffff
> ffff8807b48cfb88
> [17047.653407] Call Trace:
> [17047.653408]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653410]  [<ffffffff81860995>] schedule_preempt_disabled+0x15/0x20
> [17047.653412]  [<ffffffff81863390>] mutex_lock_nested+0x190/0x400
> [17047.653413]  [<ffffffff8127c2e0>] ? walk_component+0x1d0/0x2a0
> [17047.653414]  [<ffffffff8127c2e0>] ? walk_component+0x1d0/0x2a0
> [17047.653416]  [<ffffffff8127c2e0>] walk_component+0x1d0/0x2a0
> [17047.653417]  [<ffffffff8127c540>] link_path_walk+0x190/0x5a0
> [17047.653419]  [<ffffffff8127bb57>] ? path_init+0x557/0x800
> [17047.653420]  [<ffffffff8127bb0f>] ? path_init+0x50f/0x800
> [17047.653421]  [<ffffffff8127ca4c>] path_lookupat+0x7c/0x110
> [17047.653422]  [<ffffffff8127e5a1>] filename_lookup+0xb1/0x180
> [17047.653426]  [<ffffffff811258bd>] ? rcu_read_lock_sched_held+0x6d/0x80
> [17047.653428]  [<ffffffff81247cb1>] ? kmem_cache_alloc+0x281/0x310
> [17047.653429]  [<ffffffff8127e1a6>] ? getname_flags+0x56/0x1f0
> [17047.653432]  [<ffffffff81025c09>] ? sched_clock+0x9/0x10
> [17047.653433]  [<ffffffff8127e746>] user_path_at_empty+0x36/0x40
> [17047.653435]  [<ffffffff81272aa6>] vfs_fstatat+0x66/0xc0
> [17047.653436]  [<ffffffff8127303e>] SYSC_newstat+0x2e/0x60
> [17047.653439]  [<ffffffff8106e6a8>] ? __do_page_fault+0x1e8/0x470
> [17047.653441]  [<ffffffff81106739>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [17047.653443]  [<ffffffff81003044>] ? lockdep_sys_exit_thunk+0x12/0x14
> [17047.653445]  [<ffffffff812731ce>] SyS_newstat+0xe/0x10
> [17047.653446]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.653448] 1 lock held by gnome-shell/2455:
> [17047.653448]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
> [<ffffffff8127c2e0>] walk_component+0x1d0/0x2a0
> [17047.653471] INFO: task htop:3020 blocked for more than 120 seconds.
> [17047.653488]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653502] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653523] htop            D ffff8807fddd7a18 11800  3020   2972 0x00000000
> [17047.653527]  ffff88078866bcb8 0000000000000082 ffffffffffffffff
> ffff880700000000
> [17047.653529]  ffffffff81e12500 ffff88078b5dc000 ffff88078866c000
> ffff8807c0b66eb0
> [17047.653530]  ffffffffffffffff ffff8807c0b66ec8 ffff8807c0b66e00
> ffff88078866bcd0
> [17047.653532] Call Trace:
> [17047.653534]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653536]  [<ffffffff81864aff>] rwsem_down_read_failed+0xcf/0x140
> [17047.653539]  [<ffffffff8142af54>] call_rwsem_down_read_failed+0x14/0x30
> [17047.653541]  [<ffffffff81864363>] ? down_read+0x83/0xa0
> [17047.653544]  [<ffffffff812ec931>] ? proc_pid_cmdline_read+0xb1/0x560
> [17047.653546]  [<ffffffff812ec931>] proc_pid_cmdline_read+0xb1/0x560
> [17047.653547]  [<ffffffff81106739>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [17047.653549]  [<ffffffff8126cf57>] __vfs_read+0x37/0x100
> [17047.653551]  [<ffffffff813936b3>] ? security_file_permission+0xa3/0xc0
> [17047.653553]  [<ffffffff8126da66>] vfs_read+0x86/0x130
> [17047.653554]  [<ffffffff8126e7e8>] SyS_read+0x58/0xd0
> [17047.653555]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.653557] 1 lock held by htop/3020:
> [17047.653557]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff812ec931>]
> proc_pid_cmdline_read+0xb1/0x560
> [17047.653563] INFO: task SQLyog.exe:3780 blocked for more than 120 seconds.
> [17047.653579]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653595] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653616] SQLyog.exe      D ffff8807fe1d7a18 11192  3780   3069 0x00000000
> [17047.653619]  ffff8807384f7c90 0000000000000092 ffffffff811067cd
> ffff880700000000
> [17047.653621]  ffff8807fa33c000 ffff88073854c000 ffff8807384f8000
> ffff880003753e90
> [17047.653623]  ffff88073854c000 ffff88073854c000 ffff8807384f7cd0
> ffff8807384f7ca8
> [17047.653624] Call Trace:
> [17047.653626]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.653628]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653637]  [<ffffffffa0743ad2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [17047.653639]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.653644]  [<ffffffffa06d96d4>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [17047.653649]  [<ffffffffa06de8ff>] btrfs_search_slot+0x73f/0x9f0 [btrfs]
> [17047.653650]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.653652]  [<ffffffff81863ebe>] ? mutex_unlock+0xe/0x10
> [17047.653659]  [<ffffffffa070a819>] btrfs_real_readdir+0xe9/0x590 [btrfs]
> [17047.653662]  [<ffffffff81282d37>] iterate_dir+0x97/0x130
> [17047.653663]  [<ffffffff8128328a>] SyS_getdents+0x9a/0x130
> [17047.653664]  [<ffffffff81282ed0>] ? fillonedir+0x100/0x100
> [17047.653666]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.653667] 1 lock held by SQLyog.exe/3780:
> [17047.653668]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
> [<ffffffff81282d01>] iterate_dir+0x61/0x130
> [17047.653677] INFO: task chrome:3329 blocked for more than 120 seconds.
> [17047.653694]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653728] chrome          D ffff8807fe3d7a18 11432  3329   3267 0x00000000
> [17047.653732]  ffff88076ea27dc8 0000000000000086 ffffffffffffffff
> ffff880700000000
> [17047.653734]  ffff8807fa344000 ffff8807706f4000 ffff88076ea28000
> ffff8807f4ab00b0
> [17047.653735]  ffffffffffffffff ffff8807f4ab00c8 ffff8807706f4000
> ffff88076ea27de0
> [17047.653737] Call Trace:
> [17047.653739]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653741]  [<ffffffff81864aff>] rwsem_down_read_failed+0xcf/0x140
> [17047.653743]  [<ffffffff8142af54>] call_rwsem_down_read_failed+0x14/0x30
> [17047.653745]  [<ffffffff81864363>] ? down_read+0x83/0xa0
> [17047.653746]  [<ffffffff8106e89c>] ? __do_page_fault+0x3dc/0x470
> [17047.653748]  [<ffffffff8106e89c>] __do_page_fault+0x3dc/0x470
> [17047.653749]  [<ffffffff8126daf7>] ? vfs_read+0x117/0x130
> [17047.653751]  [<ffffffff8106e95f>] do_page_fault+0x2f/0x80
> [17047.653753]  [<ffffffff81869478>] page_fault+0x28/0x30
> [17047.653754] 1 lock held by chrome/3329:
> [17047.653755]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8106e89c>]
> __do_page_fault+0x3dc/0x470
> [17047.653774] INFO: task BrowserBlocking:3499 blocked for more than
> 120 seconds.
> [17047.653792]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.653807] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.653828] BrowserBlocking D ffff8807fddd7a18 10840  3499   3267 0x00000000
> [17047.653832]  ffff880767137658 0000000000000086 ffffffff811067cd
> ffff880700000000
> [17047.653834]  ffffffff81e12500 ffff8807c0ac0000 ffff880767138000
> ffff880003753e90
> [17047.653835]  ffff8807c0ac0000 ffff8807c0ac0000 ffff880767137698
> ffff880767137670
> [17047.653837] Call Trace:
> [17047.653839]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.653841]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.653850]  [<ffffffffa0743ad2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [17047.653851]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.653856]  [<ffffffffa06d96d4>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [17047.653861]  [<ffffffffa06de8ff>] btrfs_search_slot+0x73f/0x9f0 [btrfs]
> [17047.653868]  [<ffffffffa06f8959>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [17047.653876]  [<ffffffffa071a935>] __btrfs_drop_extents+0x185/0xd90 [btrfs]
> [17047.653878]  [<ffffffff8112515d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [17047.653885]  [<ffffffffa0706931>] ? start_transaction+0x91/0x610 [btrfs]
> [17047.653893]  [<ffffffffa070cac6>] cow_file_range_inline+0x1b6/0x690 [btrfs]
> [17047.653901]  [<ffffffffa0724c62>] ? __set_extent_bit+0x472/0x570 [btrfs]
> [17047.653909]  [<ffffffffa070d2ee>] cow_file_range+0x34e/0x440 [btrfs]
> [17047.653911]  [<ffffffff81866597>] ? _raw_spin_unlock+0x27/0x40
> [17047.653919]  [<ffffffffa0726485>] ? test_range_bit+0xe5/0x130 [btrfs]
> [17047.653927]  [<ffffffffa070e2fc>] run_delalloc_range+0x3bc/0x3f0 [btrfs]
> [17047.653935]  [<ffffffffa07266b7>] ?
> find_lock_delalloc_range.constprop.42+0x1e7/0x210 [btrfs]
> [17047.653944]  [<ffffffffa07267e5>]
> writepage_delalloc.isra.34+0x105/0x170 [btrfs]
> [17047.653952]  [<ffffffffa07285f5>] __extent_writepage+0xf5/0x3d0 [btrfs]
> [17047.653962]  [<ffffffffa0728bda>]
> extent_write_cache_pages.isra.31.constprop.47+0x30a/0x400 [btrfs]
> [17047.653965]  [<ffffffff81025c09>] ? sched_clock+0x9/0x10
> [17047.653967]  [<ffffffff810e5e8c>] ? local_clock+0x1c/0x20
> [17047.653977]  [<ffffffffa0729e8c>] extent_writepages+0x5c/0x90 [btrfs]
> [17047.653987]  [<ffffffffa070acc0>] ? btrfs_real_readdir+0x590/0x590 [btrfs]
> [17047.653994]  [<ffffffffa0708918>] btrfs_writepages+0x28/0x30 [btrfs]
> [17047.653996]  [<ffffffff811efc21>] do_writepages+0x21/0x30
> [17047.653998]  [<ffffffff811e08e6>] __filemap_fdatawrite_range+0xc6/0x100
> [17047.654000]  [<ffffffff811e09f3>] filemap_fdatawrite_range+0x13/0x20
> [17047.654008]  [<ffffffffa071cd90>] btrfs_fdatawrite_range+0x20/0x50 [btrfs]
> [17047.654016]  [<ffffffffa071cdd9>] start_ordered_ops+0x19/0x30 [btrfs]
> [17047.654023]  [<ffffffffa071ce73>] btrfs_sync_file+0x83/0x420 [btrfs]
> [17047.654026]  [<ffffffff812a894b>] vfs_fsync_range+0x4b/0xb0
> [17047.654029]  [<ffffffff8128ee4a>] ? __fget_light+0x2a/0x90
> [17047.654031]  [<ffffffff812a8a0d>] do_fsync+0x3d/0x70
> [17047.654032]  [<ffffffff812a8cf3>] SyS_fdatasync+0x13/0x20
> [17047.654034]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.654035] 1 lock held by BrowserBlocking/3499:
> [17047.654035]  #0:  (sb_internal#2){.+.+..}, at: [<ffffffff81270ad9>]
> __sb_start_write+0xc9/0x110
> [17047.654040] INFO: task BrowserBlocking:3500 blocked for more than
> 120 seconds.
> [17047.654057]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.654071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.654089] BrowserBlocking D ffff8807fe9d7a18 10840  3500   3267 0x00000000
> [17047.654092]  ffff88074fc03ac8 0000000000000086 ffffffff811067cd
> ffff880700000000
> [17047.654094]  ffff8807fa364000 ffff880767f40000 ffff88074fc04000
> ffff880003753e90
> [17047.654096]  ffff880767f40000 ffff880767f40000 ffff88074fc03b08
> ffff88074fc03ae0
> [17047.654097] Call Trace:
> [17047.654099]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.654101]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.654108]  [<ffffffffa0743ad2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [17047.654109]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.654113]  [<ffffffffa06d96d4>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [17047.654117]  [<ffffffffa06de8ff>] btrfs_search_slot+0x73f/0x9f0 [btrfs]
> [17047.654123]  [<ffffffffa06fa85e>] btrfs_lookup_inode+0x3e/0xc0 [btrfs]
> [17047.654129]  [<ffffffffa0713059>] btrfs_iget+0xf9/0x6a0 [btrfs]
> [17047.654133]  [<ffffffffa06e1869>] ? btrfs_search_forward+0x2d9/0x350 [btrfs]
> [17047.654140]  [<ffffffffa0749d14>] btrfs_log_inode_parent+0xbc4/0xeb0 [btrfs]
> [17047.654147]  [<ffffffffa074aff2>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
> [17047.654153]  [<ffffffffa071d0ee>] btrfs_sync_file+0x2fe/0x420 [btrfs]
> [17047.654154]  [<ffffffff812a894b>] vfs_fsync_range+0x4b/0xb0
> [17047.654155]  [<ffffffff8128ee4a>] ? __fget_light+0x2a/0x90
> [17047.654156]  [<ffffffff812a8a0d>] do_fsync+0x3d/0x70
> [17047.654157]  [<ffffffff812a8cf3>] SyS_fdatasync+0x13/0x20
> [17047.654158]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.654160] 2 locks held by BrowserBlocking/3500:
> [17047.654160]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
> [<ffffffffa071cf3f>] btrfs_sync_file+0x14f/0x420 [btrfs]
> [17047.654167]  #1:  (sb_internal#2){.+.+..}, at: [<ffffffff81270ad9>]
> __sb_start_write+0xc9/0x110
> [17047.654170] INFO: task Chrome_DBThread:3501 blocked for more than
> 120 seconds.
> [17047.654187]       Not tainted 4.3.5-300.fc23.x86_64+debug #1
> [17047.654201] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17047.654218] Chrome_DBThread D ffff8807fe3d7a18 10536  3501   3267 0x00000000
> [17047.654221]  ffff880759bf3cf0 0000000000000092 ffffffff811067cd
> ffff880700000000
> [17047.654222]  ffff8807fa344000 ffff880767f68000 ffff880759bf4000
> ffff880037c60800
> [17047.654224]  0000000000000001 0000000000000000 ffff880037c60780
> ffff880759bf3d08
> [17047.654226] Call Trace:
> [17047.654227]  [<ffffffff811067cd>] ? trace_hardirqs_on+0xd/0x10
> [17047.654228]  [<ffffffff818605ba>] schedule+0x3a/0x90
> [17047.654235]  [<ffffffffa0722434>]
> btrfs_start_ordered_extent+0x164/0x1f0 [btrfs]
> [17047.654237]  [<ffffffff810fa7b0>] ? wake_atomic_t_function+0x70/0x70
> [17047.654245]  [<ffffffffa0722939>] btrfs_wait_ordered_range+0xa9/0x110 [btrfs]
> [17047.654252]  [<ffffffffa0711c23>] btrfs_truncate+0x43/0x2c0 [btrfs]
> [17047.654260]  [<ffffffffa0712584>] btrfs_setattr+0x1f4/0x370 [btrfs]
> [17047.654261]  [<ffffffff8128e095>] notify_change+0x245/0x360
> [17047.654264]  [<ffffffff8126b5b7>] do_truncate+0x77/0xc0
> [17047.654266]  [<ffffffff8126b942>] do_sys_ftruncate.constprop.13+0x112/0x160
> [17047.654267]  [<ffffffff8126b9ce>] SyS_ftruncate+0xe/0x10
> [17047.654269]  [<ffffffff81867032>] entry_SYSCALL_64_fastpath+0x12/0x76
> [17047.654270] 2 locks held by Chrome_DBThread/3501:
> [17047.654271]  #0:  (sb_writers#16){.+.+.+}, at: [<ffffffff81270ad9>]
> __sb_start_write+0xc9/0x110
> [17047.654274]  #1:  (&sb->s_type->i_mutex_key#19){+.+.+.}, at:
> [<ffffffff8126b5a9>] do_truncate+0x69/0xc0
> 
> 
> 
> --
> Best Regards,
> Mike Gavrilov.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
