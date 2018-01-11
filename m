Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42330 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753084AbeAKDDQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 22:03:16 -0500
Date: Thu, 11 Jan 2018 04:03:13 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: hang in btrfs_async_reclaim_metadata_space
Message-ID: <20180111030313.inlo26nmzslm3gjd@angband.pl>
References: <20180106051059.kpultyyfhgxjowf5@angband.pl>
 <80c373ee-1bd7-d59b-a252-04309c8b0210@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <80c373ee-1bd7-d59b-a252-04309c8b0210@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 07, 2018 at 01:17:19PM +0200, Nikolay Borisov wrote:
> On  6.01.2018 07:10, Adam Borowski wrote:
> > Hi!
> > I got a reproducible infinite hang, reliably triggered by the testsuite of
> > "flatpak"; fails on at least 4.15-rc6, 4.9.75, and on another machine with
> > Debian's 4.14.2-1.
> > 
> > [580632.355107] INFO: task kworker/u8:2:11105 blocked for more than 120 seconds.
> > [580632.355120]       Not tainted 4.14.0-1-amd64 #1 Debian 4.14.2-1
> > [580632.355124] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [580632.355129] kworker/u8:2    D    0 11105      2 0x80000000
> > [580632.355176] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
> > [580632.355179] Call Trace:
> > [580632.355192]  __schedule+0x28e/0x880
> > [580632.355196]  schedule+0x2c/0x80
> > [580632.355200]  wb_wait_for_completion+0x64/0x90
> > [580632.355205]  ? finish_wait+0x80/0x80
> > [580632.355207]  __writeback_inodes_sb_nr+0xa1/0xd0
> > [580632.355210]  writeback_inodes_sb_nr+0x10/0x20
> > [580632.355235]  flush_space+0x3ed/0x520 [btrfs]
> > [580632.355238]  ? pick_next_task_fair+0x158/0x590
> > [580632.355242]  ? __switch_to+0x1f3/0x460
> > [580632.355267]  btrfs_async_reclaim_metadata_space+0xf6/0x4a0 [btrfs]
> > [580632.355278]  process_one_work+0x198/0x390
> > [580632.355281]  worker_thread+0x35/0x3c0
> > [580632.355284]  kthread+0x125/0x140
> > [580632.355287]  ? process_one_work+0x390/0x390
> > [580632.355289]  ? kthread_create_on_node+0x70/0x70
> > [580632.355292]  ? SyS_exit_group+0x14/0x20
> > [580632.355295]  ret_from_fork+0x25/0x30
> > 
> > The machines are distinct enough that this probably should happen
> > everywhere:
> > 
> > AMD Phenom2, SSD, noatime,compress=lzo,space_cache=v2
> > Intel Braswell, rust, noatime,autodefrag,space_cache=v2

It does cause data loss: while everything seems to work ok, files that are
written to while there's this stuck worker become size 0 after rebooting.
Only after a longish time other processes start getting stuck as well.

For this reason, I was reluctant to try on a real system -- but somehow I
don't seem to be able to reproduce on minimal VMs.

> Provide output of echo w > /proc/sysrq-trigger when the hang happens.

[ 5679.403833] INFO: task kworker/u12:2:9904 blocked for more than 120 seconds.
[ 5679.413938]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5679.423336] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5679.434136] kworker/u12:2   D    0  9904      2 0x80000000
[ 5679.442528] Workqueue: writeback wb_workfn (flush-btrfs-1)
[ 5679.450809] Call Trace:
[ 5679.455920]  ? __schedule+0x1a5/0x6e0
[ 5679.462251]  ? check_preempt_curr+0x74/0x80
[ 5679.468950]  ? atomic_t_wait+0x50/0x50
[ 5679.475134]  schedule+0x23/0x80
[ 5679.480670]  bit_wait+0x8/0x50
[ 5679.485985]  __wait_on_bit+0x3d/0x80
[ 5679.491828]  ? atomic_t_wait+0x50/0x50
[ 5679.497726]  __inode_wait_for_writeback+0x9e/0xc0
[ 5679.504531]  ? bit_waitqueue+0x30/0x30
[ 5679.510292]  inode_wait_for_writeback+0x18/0x30
[ 5679.516782]  evict+0xa4/0x180
[ 5679.521596]  btrfs_run_delayed_iputs+0x61/0xb0
[ 5679.527842]  btrfs_commit_transaction+0x7b0/0x8c0
[ 5679.534310]  ? start_transaction+0xa0/0x390
[ 5679.540151]  __writeback_single_inode+0x168/0x1b0
[ 5679.546477]  writeback_sb_inodes+0x1be/0x420
[ 5679.552264]  wb_writeback+0xe0/0x1d0
[ 5679.557292]  wb_workfn+0x7d/0x2c0
[ 5679.561984]  ? __switch_to+0x17c/0x370
[ 5679.567045]  process_one_work+0x1a7/0x340
[ 5679.572286]  worker_thread+0x26/0x3f0
[ 5679.577043]  ? create_worker+0x190/0x190
[ 5679.582007]  kthread+0x107/0x120
[ 5679.586198]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 5679.592200]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 5679.598122]  ret_from_fork+0x1f/0x30
[ 5679.602549] INFO: task testlibrary:12647 blocked for more than 120 seconds.
[ 5679.610434]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5679.617758] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5679.626453] testlibrary     D    0 12647  12606 0x00000000
[ 5679.632812] Call Trace:
[ 5679.636038]  ? __schedule+0x1a5/0x6e0
[ 5679.640483]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5679.645881]  schedule+0x23/0x80
[ 5679.649790]  wb_wait_for_completion+0x39/0x70
[ 5679.654901]  ? wait_woken+0x80/0x80
[ 5679.659092]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5679.664325]  sync_filesystem+0x21/0x80
[ 5679.668797]  SyS_syncfs+0x44/0x90
[ 5679.672809]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5679.678136] RIP: 0033:0x7fe82599e057
[ 5679.682405] RSP: 002b:00007ffdfda6cf18 EFLAGS: 00000202
[ 5679.682431] INFO: task pool:14436 blocked for more than 120 seconds.
[ 5679.695395]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5679.702499] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5679.711041] pool            D    0 14436      1 0x00000000
[ 5679.717217] Call Trace:
[ 5679.720280]  ? __schedule+0x1a5/0x6e0
[ 5679.724619]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5679.729890]  schedule+0x23/0x80
[ 5679.733698]  wb_wait_for_completion+0x39/0x70
[ 5679.738748]  ? wait_woken+0x80/0x80
[ 5679.742899]  sync_inodes_sb+0xb4/0x240
[ 5679.747312]  sync_filesystem+0x4f/0x80
[ 5679.751709]  SyS_syncfs+0x44/0x90
[ 5679.755679]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5679.760935] RIP: 0033:0x7fb356793057
[ 5679.765156] RSP: 002b:00007fb34f2c0128 EFLAGS: 00000202
[ 5679.765173] INFO: task flatpak:14514 blocked for more than 120 seconds.
[ 5679.778395]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5679.785540] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5679.794171] flatpak         D    0 14514  12658 0x00000000
[ 5679.800390] Call Trace:
[ 5679.803440]  ? __schedule+0x1a5/0x6e0
[ 5679.807735]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5679.813027]  schedule+0x23/0x80
[ 5679.816805]  wb_wait_for_completion+0x39/0x70
[ 5679.821809]  ? wait_woken+0x80/0x80
[ 5679.825948]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5679.831133]  sync_filesystem+0x21/0x80
[ 5679.835496]  SyS_syncfs+0x44/0x90
[ 5679.839442]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5679.844744] RIP: 0033:0x7fe919246057
[ 5679.848965] RSP: 002b:00007fff86bf7288 EFLAGS: 00000202
[ 5679.848976] INFO: task flatpak:14728 blocked for more than 120 seconds.
[ 5679.862238]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5679.869360] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5679.877916] flatpak         D    0 14728  13226 0x00000000
[ 5679.884129] Call Trace:
[ 5679.887207]  ? __schedule+0x1a5/0x6e0
[ 5679.891562]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5679.896882]  schedule+0x23/0x80
[ 5679.900709]  wb_wait_for_completion+0x39/0x70
[ 5679.905749]  ? wait_woken+0x80/0x80
[ 5679.909916]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5679.915162]  sync_filesystem+0x21/0x80
[ 5679.919603]  SyS_syncfs+0x44/0x90
[ 5679.923599]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5679.928902] RIP: 0033:0x7fae19413057
[ 5679.933150] RSP: 002b:00007ffd3e6bfea8 EFLAGS: 00000246
[ 5679.933164] INFO: task flatpak:14948 blocked for more than 120 seconds.
[ 5679.946442]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5679.953577] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5679.962110] flatpak         D    0 14948  12759 0x00000000
[ 5679.968382] Call Trace:
[ 5679.971453]  ? __schedule+0x1a5/0x6e0
[ 5679.975801]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5679.981134]  schedule+0x23/0x80
[ 5679.984933]  wb_wait_for_completion+0x39/0x70
[ 5679.989965]  ? wait_woken+0x80/0x80
[ 5679.994163]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5679.999365]  sync_filesystem+0x21/0x80
[ 5680.003819]  SyS_syncfs+0x44/0x90
[ 5680.007781]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5680.013160] RIP: 0033:0x7f478310e057
[ 5680.017421] RSP: 002b:00007ffd73a67218 EFLAGS: 00000246
[ 5680.017433] INFO: task flatpak:15011 blocked for more than 120 seconds.
[ 5680.030701]       Not tainted 4.15.0-rc7-debug-00137-g13f8e1b5cc83 #1
[ 5680.037822] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5680.046373] flatpak         D    0 15011  12798 0x00000000
[ 5680.052602] Call Trace:
[ 5680.055682]  ? __schedule+0x1a5/0x6e0
[ 5680.060058]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5680.065417]  schedule+0x23/0x80
[ 5680.069204]  wb_wait_for_completion+0x39/0x70
[ 5680.074290]  ? wait_woken+0x80/0x80
[ 5680.078442]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5680.083677]  sync_filesystem+0x21/0x80
[ 5680.088091]  SyS_syncfs+0x44/0x90
[ 5680.092085]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5680.097418] RIP: 0033:0x7f0b36769057
[ 5680.101699] RSP: 002b:00007ffc0da951f8 EFLAGS: 00000246

[ 5693.149233] sysrq: SysRq : Show Blocked State
[ 5693.167203]   task                        PC stack   pid father
[ 5693.177433] kworker/u12:2   D    0  9904      2 0x80000000
[ 5693.187073] Workqueue: writeback wb_workfn (flush-btrfs-1)
[ 5693.196725] Call Trace:
[ 5693.203260]  ? __schedule+0x1a5/0x6e0
[ 5693.211069]  ? check_preempt_curr+0x74/0x80
[ 5693.219360]  ? atomic_t_wait+0x50/0x50
[ 5693.227185]  schedule+0x23/0x80
[ 5693.234390]  bit_wait+0x8/0x50
[ 5693.241482]  __wait_on_bit+0x3d/0x80
[ 5693.249104]  ? atomic_t_wait+0x50/0x50
[ 5693.256882]  __inode_wait_for_writeback+0x9e/0xc0
[ 5693.265687]  ? bit_waitqueue+0x30/0x30
[ 5693.273489]  inode_wait_for_writeback+0x18/0x30
[ 5693.282092]  evict+0xa4/0x180
[ 5693.289042]  btrfs_run_delayed_iputs+0x61/0xb0
[ 5693.297478]  btrfs_commit_transaction+0x7b0/0x8c0
[ 5693.306156]  ? start_transaction+0xa0/0x390
[ 5693.314215]  __writeback_single_inode+0x168/0x1b0
[ 5693.322824]  writeback_sb_inodes+0x1be/0x420
[ 5693.331013]  wb_writeback+0xe0/0x1d0
[ 5693.338452]  wb_workfn+0x7d/0x2c0
[ 5693.345622]  ? __switch_to+0x17c/0x370
[ 5693.353252]  process_one_work+0x1a7/0x340
[ 5693.361138]  worker_thread+0x26/0x3f0
[ 5693.368673]  ? create_worker+0x190/0x190
[ 5693.376459]  kthread+0x107/0x120
[ 5693.383532]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 5693.392494]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 5693.401390]  ret_from_fork+0x1f/0x30
[ 5693.408823] testlibrary     D    0 12647  12606 0x00000000
[ 5693.418201] Call Trace:
[ 5693.424392]  ? __schedule+0x1a5/0x6e0
[ 5693.431751]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5693.440035]  schedule+0x23/0x80
[ 5693.446831]  wb_wait_for_completion+0x39/0x70
[ 5693.454857]  ? wait_woken+0x80/0x80
[ 5693.462002]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5693.470229]  sync_filesystem+0x21/0x80
[ 5693.477625]  SyS_syncfs+0x44/0x90
[ 5693.484547]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5693.492823] RIP: 0033:0x7fe82599e057
[ 5693.500018] RSP: 002b:00007ffdfda6cf18 EFLAGS: 00000202
[ 5693.500050] pool            D    0 14436      1 0x00000000
[ 5693.518253] Call Trace:
[ 5693.524294]  ? __schedule+0x1a5/0x6e0
[ 5693.531590]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5693.539833]  schedule+0x23/0x80
[ 5693.546564]  wb_wait_for_completion+0x39/0x70
[ 5693.554496]  ? wait_woken+0x80/0x80
[ 5693.561468]  sync_inodes_sb+0xb4/0x240
[ 5693.568678]  sync_filesystem+0x4f/0x80
[ 5693.575860]  SyS_syncfs+0x44/0x90
[ 5693.582610]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5693.590716] RIP: 0033:0x7fb356793057
[ 5693.597716] RSP: 002b:00007fb34f2c0128 EFLAGS: 00000202
[ 5693.597721] flatpak         D    0 14514  12658 0x00000000
[ 5693.615475] Call Trace:
[ 5693.621387]  ? __schedule+0x1a5/0x6e0
[ 5693.628482]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5693.636552]  schedule+0x23/0x80
[ 5693.643158]  wb_wait_for_completion+0x39/0x70
[ 5693.650979]  ? wait_woken+0x80/0x80
[ 5693.657928]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5693.665904]  sync_filesystem+0x21/0x80
[ 5693.673110]  SyS_syncfs+0x44/0x90
[ 5693.679802]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5693.687858] RIP: 0033:0x7fe919246057
[ 5693.694820] RSP: 002b:00007fff86bf7288 EFLAGS: 00000202
[ 5693.694827] flatpak         D    0 14728  13226 0x00000000
[ 5693.712525] Call Trace:
[ 5693.718340]  ? __schedule+0x1a5/0x6e0
[ 5693.725433]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5693.733536]  schedule+0x23/0x80
[ 5693.740143]  wb_wait_for_completion+0x39/0x70
[ 5693.747989]  ? wait_woken+0x80/0x80
[ 5693.754947]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5693.762977]  sync_filesystem+0x21/0x80
[ 5693.770224]  SyS_syncfs+0x44/0x90
[ 5693.777002]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5693.785128] RIP: 0033:0x7fae19413057
[ 5693.792160] RSP: 002b:00007ffd3e6bfea8 EFLAGS: 00000246
[ 5693.792167] flatpak         D    0 14948  12759 0x00000000
[ 5693.809982] Call Trace:
[ 5693.815894]  ? __schedule+0x1a5/0x6e0
[ 5693.823054]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5693.831225]  schedule+0x23/0x80
[ 5693.837851]  wb_wait_for_completion+0x39/0x70
[ 5693.845736]  ? wait_woken+0x80/0x80
[ 5693.852727]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5693.860862]  sync_filesystem+0x21/0x80
[ 5693.868132]  SyS_syncfs+0x44/0x90
[ 5693.875017]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5693.883237] RIP: 0033:0x7f478310e057
[ 5693.890352] RSP: 002b:00007ffd73a67218 EFLAGS: 00000246
[ 5693.890357] flatpak         D    0 15011  12798 0x00000000
[ 5693.908228] Call Trace:
[ 5693.914196]  ? __schedule+0x1a5/0x6e0
[ 5693.921402]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5693.929611]  schedule+0x23/0x80
[ 5693.936316]  wb_wait_for_completion+0x39/0x70
[ 5693.944271]  ? wait_woken+0x80/0x80
[ 5693.951303]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5693.959447]  sync_filesystem+0x21/0x80
[ 5693.966778]  SyS_syncfs+0x44/0x90
[ 5693.973654]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5693.981816] RIP: 0033:0x7f0b36769057
[ 5693.988935] RSP: 002b:00007ffc0da951f8 EFLAGS: 00000246

[ 5702.930722] sysrq: SysRq : Show Blocked State
[ 5702.947430]   task                        PC stack   pid father
[ 5702.957101] kworker/u12:2   D    0  9904      2 0x80000000
[ 5702.966186] Workqueue: writeback wb_workfn (flush-btrfs-1)
[ 5702.975298] Call Trace:
[ 5702.981336]  ? __schedule+0x1a5/0x6e0
[ 5702.988605]  ? check_preempt_curr+0x74/0x80
[ 5702.996390]  ? atomic_t_wait+0x50/0x50
[ 5703.003764]  schedule+0x23/0x80
[ 5703.010507]  bit_wait+0x8/0x50
[ 5703.017144]  __wait_on_bit+0x3d/0x80
[ 5703.024270]  ? atomic_t_wait+0x50/0x50
[ 5703.031558]  __inode_wait_for_writeback+0x9e/0xc0
[ 5703.039822]  ? bit_waitqueue+0x30/0x30
[ 5703.047116]  inode_wait_for_writeback+0x18/0x30
[ 5703.055205]  evict+0xa4/0x180
[ 5703.061698]  btrfs_run_delayed_iputs+0x61/0xb0
[ 5703.069695]  btrfs_commit_transaction+0x7b0/0x8c0
[ 5703.077970]  ? start_transaction+0xa0/0x390
[ 5703.085721]  __writeback_single_inode+0x168/0x1b0
[ 5703.093990]  writeback_sb_inodes+0x1be/0x420
[ 5703.101817]  wb_writeback+0xe0/0x1d0
[ 5703.108935]  wb_workfn+0x7d/0x2c0
[ 5703.115764]  ? __switch_to+0x17c/0x370
[ 5703.123043]  process_one_work+0x1a7/0x340
[ 5703.130546]  worker_thread+0x26/0x3f0
[ 5703.137710]  ? create_worker+0x190/0x190
[ 5703.145127]  kthread+0x107/0x120
[ 5703.151813]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 5703.160362]  ? kthread_create_worker_on_cpu+0x40/0x40
[ 5703.168870]  ret_from_fork+0x1f/0x30
[ 5703.175948] testlibrary     D    0 12647  12606 0x00000000
[ 5703.184926] Call Trace:
[ 5703.190824]  ? __schedule+0x1a5/0x6e0
[ 5703.197950]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5703.206098]  schedule+0x23/0x80
[ 5703.212732]  wb_wait_for_completion+0x39/0x70
[ 5703.220581]  ? wait_woken+0x80/0x80
[ 5703.227549]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5703.235558]  sync_filesystem+0x21/0x80
[ 5703.242793]  SyS_syncfs+0x44/0x90
[ 5703.249570]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5703.257666] RIP: 0033:0x7fe82599e057
[ 5703.264707] RSP: 002b:00007ffdfda6cf18 EFLAGS: 00000202
[ 5703.264736] pool            D    0 14436      1 0x00000000
[ 5703.282426] Call Trace:
[ 5703.288348]  ? __schedule+0x1a5/0x6e0
[ 5703.295511]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5703.303593]  schedule+0x23/0x80
[ 5703.310201]  wb_wait_for_completion+0x39/0x70
[ 5703.318023]  ? wait_woken+0x80/0x80
[ 5703.325008]  sync_inodes_sb+0xb4/0x240
[ 5703.332208]  sync_filesystem+0x4f/0x80
[ 5703.339370]  SyS_syncfs+0x44/0x90
[ 5703.346100]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5703.354128] RIP: 0033:0x7fb356793057
[ 5703.361128] RSP: 002b:00007fb34f2c0128 EFLAGS: 00000202
[ 5703.361134] flatpak         D    0 14514  12658 0x00000000
[ 5703.378754] Call Trace:
[ 5703.384622]  ? __schedule+0x1a5/0x6e0
[ 5703.391709]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5703.399780]  schedule+0x23/0x80
[ 5703.406359]  wb_wait_for_completion+0x39/0x70
[ 5703.414158]  ? wait_woken+0x80/0x80
[ 5703.421041]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5703.428961]  sync_filesystem+0x21/0x80
[ 5703.436118]  SyS_syncfs+0x44/0x90
[ 5703.442782]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5703.450734] RIP: 0033:0x7fe919246057
[ 5703.457664] RSP: 002b:00007fff86bf7288 EFLAGS: 00000202
[ 5703.457670] flatpak         D    0 14728  13226 0x00000000
[ 5703.475169] Call Trace:
[ 5703.480987]  ? __schedule+0x1a5/0x6e0
[ 5703.488057]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5703.496106]  schedule+0x23/0x80
[ 5703.502667]  wb_wait_for_completion+0x39/0x70
[ 5703.510447]  ? wait_woken+0x80/0x80
[ 5703.517345]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5703.525294]  sync_filesystem+0x21/0x80
[ 5703.532447]  SyS_syncfs+0x44/0x90
[ 5703.539161]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5703.547197] RIP: 0033:0x7fae19413057
[ 5703.554192] RSP: 002b:00007ffd3e6bfea8 EFLAGS: 00000246
[ 5703.554199] flatpak         D    0 14948  12759 0x00000000
[ 5703.571833] Call Trace:
[ 5703.577715]  ? __schedule+0x1a5/0x6e0
[ 5703.584815]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5703.592924]  schedule+0x23/0x80
[ 5703.599505]  wb_wait_for_completion+0x39/0x70
[ 5703.607337]  ? wait_woken+0x80/0x80
[ 5703.614278]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5703.622321]  sync_filesystem+0x21/0x80
[ 5703.629544]  SyS_syncfs+0x44/0x90
[ 5703.636346]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5703.644461] RIP: 0033:0x7f478310e057
[ 5703.651515] RSP: 002b:00007ffd73a67218 EFLAGS: 00000246
[ 5703.651520] flatpak         D    0 15011  12798 0x00000000
[ 5703.669280] Call Trace:
[ 5703.675215]  ? __schedule+0x1a5/0x6e0
[ 5703.682367]  ? bdi_split_work_to_wbs+0x159/0x290
[ 5703.690521]  schedule+0x23/0x80
[ 5703.697150]  wb_wait_for_completion+0x39/0x70
[ 5703.705026]  ? wait_woken+0x80/0x80
[ 5703.712000]  __writeback_inodes_sb_nr+0x95/0xa0
[ 5703.720071]  sync_filesystem+0x21/0x80
[ 5703.727336]  SyS_syncfs+0x44/0x90
[ 5703.734134]  entry_SYSCALL_64_fastpath+0x17/0x70
[ 5703.742254] RIP: 0033:0x7f0b36769057
[ 5703.749328] RSP: 002b:00007ffc0da951f8 EFLAGS: 00000246

[ 5711.188611] sysrq: SysRq : Resetting


Meow!
-- 
How to exploit the Bible for weight loss:
Pr28:25: he that putteth his trust in the ʟᴏʀᴅ shall be made fat.
