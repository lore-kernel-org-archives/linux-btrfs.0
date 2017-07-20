Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39183 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936517AbdGTSrX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 14:47:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BD74520929
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 14:47:22 -0400 (EDT)
Message-Id: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
From: Paul Jackson <pj@usa.net>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: kernel btrfs file system wedged -- is it toast?
Date: Thu, 20 Jul 2017 13:47:22 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


This may be a repeat, in a slightly variant form, of the problem that
Marc MERLIN reports in:

  https://www.spinics.net/lists/linux-btrfs/msg67393.html
  20170716160658.r4uxuqlfe24hgi5n@merlins.org
  BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists (since 3.4 / 2012)

I would have replied to the above thread, but just signed up for the
linux-btrfs email list a few minutes ago, and don't know how to
reply to older email on the list.

I am running Linux kernel 4.11.10-1-MANJARO on an Intel Sandy Bridge CPU.

I was running both a "btrfs balance" and a "btrfs receive" into the same file system.

Then I noticed that the disk light (on an 8TB helium filled 5400 RPM drive) stopped blinking
(it should have been blinking for many more hours, just on the btrfs balance command.)

My dmesg output shows (including the last few successful balance entries):

======================
[50583.100966] BTRFS info (device sde1): relocating block group 5980234448896 flags data
[50607.655851] BTRFS info (device sde1): found 5076 extents
[50650.791868] BTRFS info (device sde1): found 5076 extents
[50651.561918] BTRFS info (device sde1): relocating block group 5979160707072 flags data
[50671.583960] BTRFS info (device sde1): found 5326 extents
[50715.786757] BTRFS info (device sde1): found 5326 extents
[50716.365571] BTRFS info (device sde1): relocating block group 5978086965248 flags data
[50738.280469] BTRFS info (device sde1): found 5539 extents
[50779.009891] BTRFS info (device sde1): found 5539 extents
[50781.939661] BTRFS info (device sde1): relocating block group 5977013223424 flags data
[50805.881194] BTRFS info (device sde1): found 10658 extents
[50994.082530] INFO: task btrfs-cleaner:9958 blocked for more than 120 seconds.
[50994.082532]       Tainted: G           O    4.11.10-1-MANJARO #1
[50994.082533] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[50994.082534] btrfs-cleaner   D    0  9958      2 0x00000000
[50994.082536] Call Trace:
[50994.082542]  __schedule+0x22e/0x8e0
[50994.082543]  schedule+0x3d/0x90
[50994.082545]  schedule_preempt_disabled+0x15/0x20
[50994.082547]  __mutex_lock.isra.0+0x2ac/0x530
[50994.082549]  __mutex_lock_slowpath+0x13/0x20
[50994.082550]  ? __mutex_lock_slowpath+0x13/0x20
[50994.082551]  mutex_lock+0x25/0x30
[50994.082564]  btrfs_delete_unused_bgs+0xc2/0x3b0 [btrfs]
[50994.082566]  ? iput+0x1ae/0x240
[50994.082575]  cleaner_kthread+0x15e/0x170 [btrfs]
[50994.082577]  kthread+0x125/0x140
[50994.082585]  ? btrfs_destroy_pinned_extent+0xd0/0xd0 [btrfs]
[50994.082586]  ? kthread_create_on_node+0x70/0x70
[50994.082588]  ret_from_fork+0x25/0x30
[51239.838954] INFO: task btrfs-cleaner:9958 blocked for more than 120 seconds.
[51239.838956]       Tainted: G           O    4.11.10-1-MANJARO #1
[51239.838956] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51239.838957] btrfs-cleaner   D    0  9958      2 0x00000000
[51239.838959] Call Trace:
[51239.838964]  __schedule+0x22e/0x8e0
[51239.838965]  schedule+0x3d/0x90
[51239.838966]  schedule_preempt_disabled+0x15/0x20
[51239.838967]  __mutex_lock.isra.0+0x2ac/0x530
[51239.838969]  __mutex_lock_slowpath+0x13/0x20
[51239.838970]  ? __mutex_lock_slowpath+0x13/0x20
[51239.838970]  mutex_lock+0x25/0x30
[51239.838980]  btrfs_delete_unused_bgs+0xc2/0x3b0 [btrfs]
[51239.838981]  ? iput+0x1ae/0x240
[51239.838987]  cleaner_kthread+0x15e/0x170 [btrfs]
[51239.838988]  kthread+0x125/0x140
[51239.838993]  ? btrfs_destroy_pinned_extent+0xd0/0xd0 [btrfs]
[51239.838994]  ? kthread_create_on_node+0x70/0x70
[51239.838995]  ret_from_fork+0x25/0x30
[51239.838997] INFO: task btrfs:23561 blocked for more than 120 seconds.
[51239.838997]       Tainted: G           O    4.11.10-1-MANJARO #1
[51239.838997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51239.838998] btrfs           D    0 23561   5610 0x00000000
[51239.838999] Call Trace:
[51239.839000]  __schedule+0x22e/0x8e0
[51239.839001]  schedule+0x3d/0x90
[51239.839002]  schedule_timeout+0x224/0x3c0
[51239.839004]  ? wake_up_process+0x15/0x20
[51239.839005]  wait_for_common+0xb9/0x180
[51239.839005]  ? wait_for_common+0xb9/0x180
[51239.839006]  ? wake_up_q+0x80/0x80
[51239.839007]  wait_for_completion+0x1d/0x20
[51239.839012]  btrfs_async_run_delayed_refs+0x119/0x140 [btrfs]
[51239.839017]  __btrfs_end_transaction+0x1fa/0x300 [btrfs]
[51239.839022]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
[51239.839028]  relocate_block_group+0x3f2/0x620 [btrfs]
[51239.839034]  btrfs_relocate_block_group+0x18c/0x270 [btrfs]
[51239.839040]  btrfs_relocate_chunk+0x38/0xd0 [btrfs]
[51239.839045]  btrfs_balance+0xbdc/0x1340 [btrfs]
[51239.839046]  ? ttwu_do_wakeup.isra.16+0x1e/0x170
[51239.839053]  btrfs_ioctl_balance+0x316/0x380 [btrfs]
[51239.839058]  btrfs_ioctl+0x1177/0x24a0 [btrfs]
[51239.839060]  ? tty_flip_buffer_push+0x2b/0x30
[51239.839061]  ? remove_wait_queue+0x4d/0x60
[51239.839062]  ? __wake_up+0x44/0x50
[51239.839064]  do_vfs_ioctl+0xa5/0x600
[51239.839065]  ? do_vfs_ioctl+0xa5/0x600
[51239.839066]  ? vfs_write+0x168/0x1a0
[51239.839067]  SyS_ioctl+0x79/0x90
[51239.839069]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51239.839069] RIP: 0033:0x7fb06bfe6c47
[51239.839070] RSP: 002b:00007ffdc77cd118 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[51239.839071] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fb06bfe6c47
[51239.839071] RDX: 00007ffdc77cd1b0 RSI: 00000000c4009420 RDI: 0000000000000003
[51239.839072] RBP: 0000000000000003 R08: 00007fb06cf2f8c0 R09: 00007fb06cf2f8c0
[51239.839072] R10: 0000000000000545 R11: 0000000000000206 R12: 00007ffdc77cd1b0
[51239.839073] R13: 0000000000480525 R14: 0000000000000000 R15: 00007ffdc77cf591
[51239.839076] INFO: task btrfs:29186 blocked for more than 120 seconds.
[51239.839077]       Tainted: G           O    4.11.10-1-MANJARO #1
[51239.839077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51239.839078] btrfs           D    0 29186  27726 0x00000000
[51239.839079] Call Trace:
[51239.839080]  __schedule+0x22e/0x8e0
[51239.839081]  schedule+0x3d/0x90
[51239.839082]  schedule_timeout+0x224/0x3c0
[51239.839086]  ? btrfs_leaf_free_space+0x54/0xa0 [btrfs]
[51239.839087]  ? wake_up_process+0x15/0x20
[51239.839088]  wait_for_common+0xb9/0x180
[51239.839089]  ? wait_for_common+0xb9/0x180
[51239.839089]  ? wake_up_q+0x80/0x80
[51239.839090]  wait_for_completion+0x1d/0x20
[51239.839095]  btrfs_async_run_delayed_refs+0x119/0x140 [btrfs]
[51239.839100]  __btrfs_end_transaction+0x1fa/0x300 [btrfs]
[51239.839105]  btrfs_end_transaction+0x10/0x20 [btrfs]
[51239.839110]  btrfs_setattr+0x129/0x3b0 [btrfs]
[51239.839111]  notify_change+0x2c7/0x430
[51239.839112]  do_truncate+0x73/0xc0
[51239.839113]  vfs_truncate+0x14e/0x190
[51239.839114]  ? user_path_at_empty+0x36/0x40
[51239.839115]  do_sys_truncate.part.0+0x8a/0xa0
[51239.839116]  SyS_truncate+0x13/0x20
[51239.839117]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51239.839118] RIP: 0033:0x7f325f704ce7
[51239.839118] RSP: 002b:00007ffda084a908 EFLAGS: 00000297 ORIG_RAX: 000000000000004c
[51239.839119] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f325f704ce7
[51239.839119] RDX: 0000000000000000 RSI: 000000001124aa3b RDI: 00007ffda084a910
[51239.839120] RBP: 00007ffda084ba20 R08: 0000000000000057 R09: 0000000001e56170
[51239.839120] R10: 0000000001e561c0 R11: 0000000000000297 R12: 000000000000000f
[51239.839121] R13: 000000000000c06b R14: 00000000e37b700a R15: 00007ffda084ba24
[51362.717193] INFO: task btrfs:29898 blocked for more than 120 seconds.
[51362.717195]       Tainted: G           O    4.11.10-1-MANJARO #1
[51362.717195] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51362.717196] btrfs           D    0 29898  23640 0x00000004
[51362.717198] Call Trace:
[51362.717203]  __schedule+0x22e/0x8e0
[51362.717205]  schedule+0x3d/0x90
[51362.717218]  btrfs_pause_balance+0xc7/0x110 [btrfs]
[51362.717220]  ? wake_bit_function+0x60/0x60
[51362.717228]  btrfs_ioctl+0x1adb/0x24a0 [btrfs]
[51362.717230]  ? lru_cache_add_active_or_unevictable+0x36/0xb0
[51362.717231]  ? __handle_mm_fault+0xa5b/0x12a0
[51362.717233]  ? _copy_to_user+0x51/0x60
[51362.717235]  do_vfs_ioctl+0xa5/0x600
[51362.717236]  ? do_vfs_ioctl+0xa5/0x600
[51362.717237]  ? handle_mm_fault+0xde/0x240
[51362.717239]  ? __do_page_fault+0x2b9/0x520
[51362.717240]  SyS_ioctl+0x79/0x90
[51362.717242]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51362.717243] RIP: 0033:0x7f60efce0c47
[51362.717244] RSP: 002b:00007ffd965895a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[51362.717245] RAX: ffffffffffffffda RBX: 0000000000008041 RCX: 00007f60efce0c47
[51362.717246] RDX: 0000000000000001 RSI: 0000000040049421 RDI: 0000000000000003
[51362.717246] RBP: 00007f60eff9bae0 R08: 0000000000000003 R09: 000000000000007c
[51362.717247] R10: 0000000000000545 R11: 0000000000000202 R12: 0000000000000000
[51362.717248] R13: 00007f60eff9bb38 R14: 0000000000008060 R15: 0000000000000000
[51485.595419] INFO: task btrfs:29898 blocked for more than 120 seconds.
[51485.595421]       Tainted: G           O    4.11.10-1-MANJARO #1
[51485.595422] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51485.595423] btrfs           D    0 29898  23640 0x00000004
[51485.595426] Call Trace:
[51485.595431]  __schedule+0x22e/0x8e0
[51485.595434]  schedule+0x3d/0x90
[51485.595447]  btrfs_pause_balance+0xc7/0x110 [btrfs]
[51485.595449]  ? wake_bit_function+0x60/0x60
[51485.595455]  btrfs_ioctl+0x1adb/0x24a0 [btrfs]
[51485.595457]  ? lru_cache_add_active_or_unevictable+0x36/0xb0
[51485.595459]  ? __handle_mm_fault+0xa5b/0x12a0
[51485.595460]  ? _copy_to_user+0x51/0x60
[51485.595462]  do_vfs_ioctl+0xa5/0x600
[51485.595462]  ? do_vfs_ioctl+0xa5/0x600
[51485.595463]  ? handle_mm_fault+0xde/0x240
[51485.595465]  ? __do_page_fault+0x2b9/0x520
[51485.595466]  SyS_ioctl+0x79/0x90
[51485.595467]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51485.595469] RIP: 0033:0x7f60efce0c47
[51485.595469] RSP: 002b:00007ffd965895a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[51485.595470] RAX: ffffffffffffffda RBX: 0000000000008041 RCX: 00007f60efce0c47
[51485.595471] RDX: 0000000000000001 RSI: 0000000040049421 RDI: 0000000000000003
[51485.595471] RBP: 00007f60eff9bae0 R08: 0000000000000003 R09: 000000000000007c
[51485.595472] R10: 0000000000000545 R11: 0000000000000202 R12: 0000000000000000
[51485.595472] R13: 00007f60eff9bb38 R14: 0000000000008060 R15: 0000000000000000
[51608.473644] INFO: task btrfs:29898 blocked for more than 120 seconds.
[51608.473646]       Tainted: G           O    4.11.10-1-MANJARO #1
[51608.473647] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51608.473648] btrfs           D    0 29898  23640 0x00000004
[51608.473650] Call Trace:
[51608.473655]  __schedule+0x22e/0x8e0
[51608.473657]  schedule+0x3d/0x90
[51608.473671]  btrfs_pause_balance+0xc7/0x110 [btrfs]
[51608.473673]  ? wake_bit_function+0x60/0x60
[51608.473683]  btrfs_ioctl+0x1adb/0x24a0 [btrfs]
[51608.473685]  ? lru_cache_add_active_or_unevictable+0x36/0xb0
[51608.473687]  ? __handle_mm_fault+0xa5b/0x12a0
[51608.473689]  ? _copy_to_user+0x51/0x60
[51608.473691]  do_vfs_ioctl+0xa5/0x600
[51608.473692]  ? do_vfs_ioctl+0xa5/0x600
[51608.473694]  ? handle_mm_fault+0xde/0x240
[51608.473696]  ? __do_page_fault+0x2b9/0x520
[51608.473697]  SyS_ioctl+0x79/0x90
[51608.473699]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51608.473701] RIP: 0033:0x7f60efce0c47
[51608.473701] RSP: 002b:00007ffd965895a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[51608.473703] RAX: ffffffffffffffda RBX: 0000000000008041 RCX: 00007f60efce0c47
[51608.473704] RDX: 0000000000000001 RSI: 0000000040049421 RDI: 0000000000000003
[51608.473704] RBP: 00007f60eff9bae0 R08: 0000000000000003 R09: 000000000000007c
[51608.473705] R10: 0000000000000545 R11: 0000000000000202 R12: 0000000000000000
[51608.473706] R13: 00007f60eff9bb38 R14: 0000000000008060 R15: 0000000000000000
[51731.351862] INFO: task btrfs-cleaner:9958 blocked for more than 120 seconds.
[51731.351864]       Tainted: G           O    4.11.10-1-MANJARO #1
[51731.351864] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51731.351865] btrfs-cleaner   D    0  9958      2 0x00000000
[51731.351867] Call Trace:
[51731.351873]  __schedule+0x22e/0x8e0
[51731.351874]  schedule+0x3d/0x90
[51731.351876]  schedule_preempt_disabled+0x15/0x20
[51731.351877]  __mutex_lock.isra.0+0x2ac/0x530
[51731.351879]  __mutex_lock_slowpath+0x13/0x20
[51731.351880]  ? __mutex_lock_slowpath+0x13/0x20
[51731.351881]  mutex_lock+0x25/0x30
[51731.351894]  btrfs_delete_unused_bgs+0xc2/0x3b0 [btrfs]
[51731.351895]  ? iput+0x1ae/0x240
[51731.351904]  cleaner_kthread+0x15e/0x170 [btrfs]
[51731.351906]  kthread+0x125/0x140
[51731.351914]  ? btrfs_destroy_pinned_extent+0xd0/0xd0 [btrfs]
[51731.351915]  ? kthread_create_on_node+0x70/0x70
[51731.351917]  ret_from_fork+0x25/0x30
[51731.351919] INFO: task btrfs:23561 blocked for more than 120 seconds.
[51731.351920]       Tainted: G           O    4.11.10-1-MANJARO #1
[51731.351920] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51731.351921] btrfs           D    0 23561   5610 0x00000000
[51731.351922] Call Trace:
[51731.351924]  __schedule+0x22e/0x8e0
[51731.351925]  schedule+0x3d/0x90
[51731.351927]  schedule_timeout+0x224/0x3c0
[51731.351929]  ? wake_up_process+0x15/0x20
[51731.351930]  wait_for_common+0xb9/0x180
[51731.351931]  ? wait_for_common+0xb9/0x180
[51731.351932]  ? wake_up_q+0x80/0x80
[51731.351934]  wait_for_completion+0x1d/0x20
[51731.351941]  btrfs_async_run_delayed_refs+0x119/0x140 [btrfs]
[51731.351950]  __btrfs_end_transaction+0x1fa/0x300 [btrfs]
[51731.351959]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
[51731.351968]  relocate_block_group+0x3f2/0x620 [btrfs]
[51731.351977]  btrfs_relocate_block_group+0x18c/0x270 [btrfs]
[51731.351987]  btrfs_relocate_chunk+0x38/0xd0 [btrfs]
[51731.351996]  btrfs_balance+0xbdc/0x1340 [btrfs]
[51731.351997]  ? ttwu_do_wakeup.isra.16+0x1e/0x170
[51731.352007]  btrfs_ioctl_balance+0x316/0x380 [btrfs]
[51731.352016]  btrfs_ioctl+0x1177/0x24a0 [btrfs]
[51731.352018]  ? tty_flip_buffer_push+0x2b/0x30
[51731.352020]  ? remove_wait_queue+0x4d/0x60
[51731.352021]  ? __wake_up+0x44/0x50
[51731.352023]  do_vfs_ioctl+0xa5/0x600
[51731.352024]  ? do_vfs_ioctl+0xa5/0x600
[51731.352026]  ? vfs_write+0x168/0x1a0
[51731.352027]  SyS_ioctl+0x79/0x90
[51731.352029]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51731.352030] RIP: 0033:0x7fb06bfe6c47
[51731.352031] RSP: 002b:00007ffdc77cd118 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[51731.352032] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fb06bfe6c47
[51731.352033] RDX: 00007ffdc77cd1b0 RSI: 00000000c4009420 RDI: 0000000000000003
[51731.352034] RBP: 0000000000000003 R08: 00007fb06cf2f8c0 R09: 00007fb06cf2f8c0
[51731.352034] R10: 0000000000000545 R11: 0000000000000206 R12: 00007ffdc77cd1b0
[51731.352035] R13: 0000000000480525 R14: 0000000000000000 R15: 00007ffdc77cf591
[51731.352040] INFO: task btrfs:29186 blocked for more than 120 seconds.
[51731.352041]       Tainted: G           O    4.11.10-1-MANJARO #1
[51731.352041] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[51731.352042] btrfs           D    0 29186  27726 0x00000000
[51731.352043] Call Trace:
[51731.352045]  __schedule+0x22e/0x8e0
[51731.352046]  schedule+0x3d/0x90
[51731.352048]  schedule_timeout+0x224/0x3c0
[51731.352049]  ? wake_up_process+0x15/0x20
[51731.352051]  wait_for_common+0xb9/0x180
[51731.352052]  ? wait_for_common+0xb9/0x180
[51731.352053]  ? wake_up_q+0x80/0x80
[51731.352055]  wait_for_completion+0x1d/0x20
[51731.352063]  btrfs_async_run_delayed_refs+0x119/0x140 [btrfs]
[51731.352072]  __btrfs_end_transaction+0x1fa/0x300 [btrfs]
[51731.352080]  btrfs_end_transaction+0x10/0x20 [btrfs]
[51731.352088]  btrfs_alloc_data_chunk_ondemand+0xfa/0x370 [btrfs]
[51731.352096]  btrfs_check_data_free_space+0x53/0xa0 [btrfs]
[51731.352106]  __btrfs_buffered_write.isra.4+0x185/0x6e0 [btrfs]
[51731.352115]  btrfs_file_write_iter+0x186/0x4e0 [btrfs]
[51731.352117]  new_sync_write+0xc3/0x110
[51731.352119]  __vfs_write+0x26/0x40
[51731.352120]  vfs_write+0xb5/0x1a0
[51731.352121]  SyS_pwrite64+0x95/0xb0
[51731.352123]  ? exit_to_usermode_loop+0x72/0xb0
[51731.352125]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[51731.352125] RIP: 0033:0x7f325f9d4053
[51731.352126] RSP: 002b:00007ffda084a8e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
[51731.352127] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f325f9d4053
[51731.352128] RDX: 000000000000c000 RSI: 00007ffda084ba8e RDI: 0000000000000006
[51731.352129] RBP: 00007ffda084ba20 R08: 0000ffff00000000 R09: 0000000001e56170
[51731.352129] R10: 000000000264c000 R11: 0000000000000246 R12: 000000000000000f
[51731.352130] R13: 000000000000c060 R14: 00000000ee954cf5 R15: 00007ffda084ba24

======================

I also have issued a "btrfs balance pause" command, which is now in an unkillable
wait in the kernel.

I will reboot after sending this present email and see what I can see.

But based on Marc's thread mentioned above, I am quite concerned
that I should NEVER trust this particular btrfs file system again, and
that I should reformat that 8 TB disk partition and rebuild the file
store on that disk from scratch.

If so, I must conclude that I should NEVER trust btrfs again.

======================

Questions:

Is there anyway to recover this receiving btrfs file system?

Is there anyway to know, with confidence, that this receiving btrfs  file
system is healthy?

If not is there any reliable way to avoid hitting this disaster again?

===

If not that either, then know that I will necessarily throw out the
last couple of months work I've spent, developing a backup system
for my particular purposes that relies heavily on btrfs snapshots,
sent and received to create off-site and off-line backups from multiple
locations.

Just rebuilding the file system I was sending to would take me days
of work.  This target file system contains backups of a half dozen
other btrfs file systems.

As Marc said:
> If so, this blows, and I'm not really wanting to recreate a clean 12TB
> filesystem "just because", especially since this could just happen
> again after I've rebuilt it.

(Unlike Marc's disk, this target disk was only 8 TB, but it's a slow 8 TB ...)

I have coped with and worked through a variety of ways of messing
up btrfs snapshots and copies over the last two months ... but I can NOT
accept bugs that wipe out whole file systems.

Fortunately, my primary file systems are still EXT ... so it's just my
backup file systems, spanning about 40 TB of disks, and a couple
months of work, that are at risk.

P.S. -- About 50 minutes after issuing the above "btrfs balance pause",
just before I was about to hit send on this email, I noticed:

1.  my disk light flashing again
2.  that pause command returnedto the shell prompt (pause command exited),
3. the in progress balance command also exited, stating "balance paused by user"), and
4. the sequence of "btrfs receives" into that file system resumed progress.

Is that good news, bad news, or impossible to say news?

-- 
                Paul Jackson
                pj@usa.net
