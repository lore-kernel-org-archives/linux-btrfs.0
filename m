Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43852 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaCVGrd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 02:47:33 -0400
Date: Fri, 21 Mar 2014 23:47:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140322064718.GB32023@merlins.org>
References: <20140321060632.GD28005@merlins.org>
 <532C83ED.3040103@fb.com>
 <20140322005123.GO18959@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140322005123.GO18959@merlins.org>
Subject: Re: btrfs deadlock (3.14 kernel)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 21, 2014 at 05:51:23PM -0700, Marc MERLIN wrote:
> On Fri, Mar 21, 2014 at 02:24:45PM -0400, Josef Bacik wrote:
> > >Is thre anything I can try to unwedge or prevent this problem next time I 
> > >try?
> > 
> > Sysrq+w would be nice so I can see what everybody is doing.  Thanks,
> 
> Sure thing. There you go
> http://marc.merlins.org/tmp/sysreq-w-btrfs.txt
> (too big to paste on the list)

Later on, on the same filesystem, I removed a drive, added another one, and did a balance.
It's still running as of now, but I'm getting some more blocked messages if that helps.

polgara:/mnt/btrfs_backupcopy# btrfs balance start . 
[ 2478.807643] BTRFS info (device dm-8): relocating block group 610296528896 flags 132
[ 2533.497984] BTRFS info (device dm-8): found 10755 extents
[ 2534.171970] BTRFS info (device dm-8): relocating block group 600632852480 flags 129
[ 2605.128529] perf samples too long (2510 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 2658.269914] BTRFS info (device dm-8): found 152415 extents
[ 2720.016436] BTRFS info (device dm-8): found 152414 extents
[ 2725.331007] BTRFS info (device dm-8): relocating block group 590969176064 flags 129
[ 2893.950429] BTRFS info (device dm-8): found 61122 extents
[ 2918.439790] BTRFS info (device dm-8): found 61122 extents
[ 2919.622722] BTRFS info (device dm-8): relocating block group 589761216512 flags 132
[ 3024.003479] BTRFS info (device dm-8): found 40540 extents
[ 3024.809596] BTRFS info (device dm-8): relocating block group 588553256960 flags 132
[ 3190.396757] BTRFS info (device dm-8): found 65999 extents
[ 3190.998052] BTRFS info (device dm-8): relocating block group 587345297408 flags 132
[ 3373.859850] BTRFS info (device dm-8): found 68408 extents
[ 3374.492637] BTRFS info (device dm-8): relocating block group 586137337856 flags 132
[ 3541.988379] BTRFS info (device dm-8): found 62940 extents
[ 3542.747725] BTRFS info (device dm-8): relocating block group 576473661440 flags 129
[ 3811.800110] BTRFS info (device dm-8): found 847969 extents
[ 4150.174138] BTRFS info (device dm-8): found 847969 extents
[ 4187.253411] BTRFS info (device dm-8): relocating block group 566809985024 flags 129
[ 4363.966721] BTRFS info (device dm-8): found 171089 extents
[ 4402.735354] BTRFS info (device dm-8): found 171089 extents
[ 4404.593423] BTRFS info (device dm-8): relocating block group 557146308608 flags 129
[ 4589.878118] BTRFS info (device dm-8): found 39967 extents
[ 4601.308021] BTRFS info (device dm-8): found 39967 extents
[ 4602.115166] BTRFS info (device dm-8): relocating block group 547482632192 flags 129
[ 5040.560066] INFO: task btrfs:7773 blocked for more than 120 seconds.
[ 5040.560073]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5040.560075] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5040.560078] btrfs           D ffff88005f096780     0  7773   6854 0x00000080
[ 5040.560083]  ffff88005bf07940 0000000000000086 ffff88005bf07fd8 ffff88005f096250
[ 5040.560089]  00000000000141c0 ffff88005f096250 ffff88007fc141c0 ffff88005f096250
[ 5040.560094]  ffff88005bf079e0 0000000000000002 ffffffff810fe5f2 ffff88005bf07950
[ 5040.560099] Call Trace:
[ 5040.560108]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[ 5040.560113]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5040.560117]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[ 5040.560121]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[ 5040.560124]  [<ffffffff8160c866>] __wait_on_bit_lock+0x46/0x8a
[ 5040.560128]  [<ffffffff810fe6bb>] __lock_page+0x69/0x6b
[ 5040.560134]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[ 5040.560138]  [<ffffffff810fec39>] ? find_get_page+0x69/0x75
[ 5040.560142]  [<ffffffff810feeb9>] lock_page+0x19/0x1c
[ 5040.560145]  [<ffffffff810fef15>] find_lock_page+0x33/0x55
[ 5040.560150]  [<ffffffff81266d4a>] relocate_file_extent_cluster+0x117/0x32c
[ 5040.560154]  [<ffffffff81266ff1>] relocate_data_extent+0x92/0xa7
[ 5040.560158]  [<ffffffff8126aa58>] relocate_block_group+0x2b2/0x49a
[ 5040.560162]  [<ffffffff8123f526>] ? btrfs_wait_ordered_roots+0x107/0x140
[ 5040.560166]  [<ffffffff8126ad98>] btrfs_relocate_block_group+0x158/0x26a
[ 5040.560171]  [<ffffffff81249544>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
[ 5040.560176]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5040.560180]  [<ffffffff812452f7>] ? free_extent_buffer+0x8a/0x8d
[ 5040.560184]  [<ffffffff8124bdca>] btrfs_balance+0x9b6/0xb74
[ 5040.560188]  [<ffffffff8113f328>] ? trace_kmalloc+0x15/0x74
[ 5040.560193]  [<ffffffff812523b9>] btrfs_ioctl_balance+0x23e/0x2b7
[ 5040.560197]  [<ffffffff81255fa9>] btrfs_ioctl+0x1223/0x24b1
[ 5040.560202]  [<ffffffff811610e4>] ? path_openat+0x237/0x4de
[ 5040.560206]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5040.560210]  [<ffffffff81611e15>] ? __do_page_fault+0x330/0x3df
[ 5040.560215]  [<ffffffff81125bc6>] ? vma_link+0x74/0x93
[ 5040.560219]  [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
[ 5040.560223]  [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
[ 5040.560227]  [<ffffffff81611ed2>] ? do_page_fault+0xe/0x10
[ 5040.560236]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[ 5160.560062] INFO: task btrfs:7773 blocked for more than 120 seconds.
[ 5160.560068]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5160.560071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5160.560073] btrfs           D ffff88005f096780     0  7773   6854 0x00000080
[ 5160.560079]  ffff88005bf07940 0000000000000086 ffff88005bf07fd8 ffff88005f096250
[ 5160.560085]  00000000000141c0 ffff88005f096250 ffff88007fc141c0 ffff88005f096250
[ 5160.560089]  ffff88005bf079e0 0000000000000002 ffffffff810fe5f2 ffff88005bf07950
[ 5160.560094] Call Trace:
[ 5160.560103]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[ 5160.560108]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5160.560112]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[ 5160.560116]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[ 5160.560120]  [<ffffffff8160c866>] __wait_on_bit_lock+0x46/0x8a
[ 5160.560124]  [<ffffffff810fe6bb>] __lock_page+0x69/0x6b
[ 5160.560129]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[ 5160.560133]  [<ffffffff810fec39>] ? find_get_page+0x69/0x75
[ 5160.560137]  [<ffffffff810feeb9>] lock_page+0x19/0x1c
[ 5160.560141]  [<ffffffff810fef15>] find_lock_page+0x33/0x55
[ 5160.560146]  [<ffffffff81266d4a>] relocate_file_extent_cluster+0x117/0x32c
[ 5160.560150]  [<ffffffff81266ff1>] relocate_data_extent+0x92/0xa7
[ 5160.560153]  [<ffffffff8126aa58>] relocate_block_group+0x2b2/0x49a
[ 5160.560158]  [<ffffffff8123f526>] ? btrfs_wait_ordered_roots+0x107/0x140
[ 5160.560162]  [<ffffffff8126ad98>] btrfs_relocate_block_group+0x158/0x26a
[ 5160.560166]  [<ffffffff81249544>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
[ 5160.560171]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5160.560175]  [<ffffffff812452f7>] ? free_extent_buffer+0x8a/0x8d
[ 5160.560179]  [<ffffffff8124bdca>] btrfs_balance+0x9b6/0xb74
[ 5160.560184]  [<ffffffff8113f328>] ? trace_kmalloc+0x15/0x74
[ 5160.560188]  [<ffffffff812523b9>] btrfs_ioctl_balance+0x23e/0x2b7
[ 5160.560193]  [<ffffffff81255fa9>] btrfs_ioctl+0x1223/0x24b1
[ 5160.560197]  [<ffffffff811610e4>] ? path_openat+0x237/0x4de
[ 5160.560201]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5160.560205]  [<ffffffff81611e15>] ? __do_page_fault+0x330/0x3df
[ 5160.560210]  [<ffffffff81125bc6>] ? vma_link+0x74/0x93
[ 5160.560213]  [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
[ 5160.560218]  [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
[ 5160.560222]  [<ffffffff81611ed2>] ? do_page_fault+0xe/0x10
[ 5160.560226]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[ 5280.560028] INFO: task kworker/0:1:30 blocked for more than 120 seconds.
[ 5280.560034]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560036] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560039] kworker/0:1     D ffff88007c376600     0    30      2 0x00000000
[ 5280.560044]  ffff88007c379b70 0000000000000046 ffff88007c379fd8 ffff88007c3760d0
[ 5280.560050]  00000000000141c0 ffff88007c3760d0 ffff880079e4e530 ffff880079e4e534
[ 5280.560055]  ffff88007c3760d0 ffff880079e4e538 00000000ffffffff ffff88007c379b80
[ 5280.560060] Call Trace:
[ 5280.560068]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560073]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560077]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560082]  [<ffffffff8160ea3d>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
[ 5280.560086]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560091]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560097]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560102]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560106]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560109]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560113]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560118]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560123]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560128]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560133]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560137]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560141]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560145]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560148]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560152]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560157]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560161]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560165]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560174] INFO: task kworker/u9:2:282 blocked for more than 120 seconds.
[ 5280.560176]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560179] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560181] kworker/u9:2    D ffff88007b446540     0   282      2 0x00000000
[ 5280.560185]  ffff88007a463b70 0000000000000046 ffff88007a463fd8 ffff88007b446010
[ 5280.560190]  00000000000141c0 ffff88007b446010 ffff880079e4e530 ffff880079e4e534
[ 5280.560195]  ffff88007b446010 ffff880079e4e538 00000000ffffffff ffff88007a463b80
[ 5280.560200] Call Trace:
[ 5280.560204]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560208]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560212]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560238]  [<ffffffffa0142a76>] ? mvs_queue_command+0x3d/0x29b [mvsas]
[ 5280.560241]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560244]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560247]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560249]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560252]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560254]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560257]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560260]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560263]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560266]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560268]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560271]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560274]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560276]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560278]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560281]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560284]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560287]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560289]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560321] INFO: task kworker/0:0:7518 blocked for more than 120 seconds.
[ 5280.560323]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560325] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560326] kworker/0:0     D ffff880060524b40     0  7518      2 0x00000080
[ 5280.560329]  ffff880060527b70 0000000000000046 ffff880060527fd8 ffff880060524610
[ 5280.560332]  00000000000141c0 ffff880060524610 ffff880079e4e530 ffff880079e4e534
[ 5280.560335]  ffff880060524610 ffff880079e4e538 00000000ffffffff ffff880060527b80
[ 5280.560339] Call Trace:
[ 5280.560342]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560344]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560347]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560350]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560352]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560355]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560358]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560361]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560363]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560366]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560369]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560371]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560374]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560377]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560380]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560382]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560385]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560387]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560390]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560393]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560395]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560398]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560402] INFO: task kworker/0:3:7702 blocked for more than 120 seconds.
[ 5280.560403]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560406] kworker/0:3     D ffff88005f31cb80     0  7702      2 0x00000080
[ 5280.560409]  ffff88005f31fb70 0000000000000046 ffff88005f31ffd8 ffff88005f31c650
[ 5280.560412]  00000000000141c0 ffff88005f31c650 ffff880079e4e530 ffff880079e4e534
[ 5280.560415]  ffff88005f31c650 ffff880079e4e538 00000000ffffffff ffff88005f31fb80
[ 5280.560419] Call Trace:
[ 5280.560422]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560424]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560427]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560430]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560432]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560435]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560438]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560440]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560443]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560446]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560448]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560451]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560454]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560457]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560459]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560462]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560464]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560467]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560469]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560472]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560475]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560477]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560480] INFO: task kworker/1:4:7705 blocked for more than 120 seconds.
[ 5280.560482]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560484] kworker/1:4     D ffff88005e0acc40     0  7705      2 0x00000080
[ 5280.560487]  ffff88005e0afb70 0000000000000046 ffff88005e0affd8 ffff88005e0ac710
[ 5280.560490]  00000000000141c0 ffff88005e0ac710 ffff880079e4e530 ffff880079e4e534
[ 5280.560494]  ffff88005e0ac710 ffff880079e4e538 00000000ffffffff ffff88005e0afb80
[ 5280.560497] Call Trace:
[ 5280.560500]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560502]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560505]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560508]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560510]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560513]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560516]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560519]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560521]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560524]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560527]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560529]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560532]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560535]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560537]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560540]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560543]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560545]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560548]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560550]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560553]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560556]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560559] INFO: task btrfs:7773 blocked for more than 120 seconds.
[ 5280.560560]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560562] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560563] btrfs           D ffff88005f096780     0  7773   6854 0x00000080
[ 5280.560566]  ffff88005bf07940 0000000000000086 ffff88005bf07fd8 ffff88005f096250
[ 5280.560569]  00000000000141c0 ffff88005f096250 ffff88007fc141c0 ffff88005f096250
[ 5280.560572]  ffff88005bf079e0 0000000000000002 ffffffff810fe5f2 ffff88005bf07950
[ 5280.560576] Call Trace:
[ 5280.560579]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[ 5280.560581]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560584]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[ 5280.560586]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[ 5280.560589]  [<ffffffff8160c866>] __wait_on_bit_lock+0x46/0x8a
[ 5280.560592]  [<ffffffff810fe6bb>] __lock_page+0x69/0x6b
[ 5280.560595]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[ 5280.560598]  [<ffffffff810fec39>] ? find_get_page+0x69/0x75
[ 5280.560600]  [<ffffffff810feeb9>] lock_page+0x19/0x1c
[ 5280.560603]  [<ffffffff810fef15>] find_lock_page+0x33/0x55
[ 5280.560606]  [<ffffffff81266d4a>] relocate_file_extent_cluster+0x117/0x32c
[ 5280.560609]  [<ffffffff81266ff1>] relocate_data_extent+0x92/0xa7
[ 5280.560611]  [<ffffffff8126aa58>] relocate_block_group+0x2b2/0x49a
[ 5280.560614]  [<ffffffff8123f526>] ? btrfs_wait_ordered_roots+0x107/0x140
[ 5280.560617]  [<ffffffff8126ad98>] btrfs_relocate_block_group+0x158/0x26a
[ 5280.560620]  [<ffffffff81249544>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
[ 5280.560623]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560626]  [<ffffffff812452f7>] ? free_extent_buffer+0x8a/0x8d
[ 5280.560628]  [<ffffffff8124bdca>] btrfs_balance+0x9b6/0xb74
[ 5280.560632]  [<ffffffff8113f328>] ? trace_kmalloc+0x15/0x74
[ 5280.560635]  [<ffffffff812523b9>] btrfs_ioctl_balance+0x23e/0x2b7
[ 5280.560638]  [<ffffffff81255fa9>] btrfs_ioctl+0x1223/0x24b1
[ 5280.560641]  [<ffffffff811610e4>] ? path_openat+0x237/0x4de
[ 5280.560643]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560646]  [<ffffffff81611e15>] ? __do_page_fault+0x330/0x3df
[ 5280.560649]  [<ffffffff81125bc6>] ? vma_link+0x74/0x93
[ 5280.560652]  [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
[ 5280.560655]  [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
[ 5280.560658]  [<ffffffff81611ed2>] ? do_page_fault+0xe/0x10
[ 5280.560660]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[ 5280.560663] INFO: task kworker/0:5:7774 blocked for more than 120 seconds.
[ 5280.560664]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560666] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560667] kworker/0:5     D ffff88005f7fa840     0  7774      2 0x00000080
[ 5280.560670]  ffff88005be7db70 0000000000000046 ffff88005be7dfd8 ffff88005f7fa310
[ 5280.560673]  00000000000141c0 ffff88005f7fa310 ffff880079e4e530 ffff880079e4e534
[ 5280.560676]  ffff88005f7fa310 ffff880079e4e538 00000000ffffffff ffff88005be7db80
[ 5280.560679] Call Trace:
[ 5280.560682]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560685]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560688]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560690]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560693]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560696]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560699]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560701]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560704]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560706]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560709]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560712]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560715]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560718]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560720]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560723]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560725]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560728]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560730]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560733]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560736]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560739]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560741] INFO: task kworker/1:8:7797 blocked for more than 120 seconds.
[ 5280.560743]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[ 5280.560744] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5280.560745] kworker/1:8     D ffff8800544ba5c0     0  7797      2 0x00000080
[ 5280.560748]  ffff880050c2db70 0000000000000046 ffff880050c2dfd8 ffff8800544ba090
[ 5280.560751]  00000000000141c0 ffff8800544ba090 ffff880079e4e530 ffff880079e4e534
[ 5280.560754]  ffff8800544ba090 ffff880079e4e538 00000000ffffffff ffff880050c2db80
[ 5280.560758] Call Trace:
[ 5280.560761]  [<ffffffff8160c331>] schedule+0x73/0x75
[ 5280.560763]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[ 5280.560766]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[ 5280.560769]  [<ffffffff814a9598>] ? ata_qc_issue+0x291/0x2f1
[ 5280.560772]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[ 5280.560775]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[ 5280.560778]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[ 5280.560780]  [<ffffffff8107c349>] ? account_entity_enqueue+0x5a/0x8b
[ 5280.560783]  [<ffffffff8107e7da>] ? check_preempt_wakeup+0x128/0x1f9
[ 5280.560785]  [<ffffffff8107c826>] ? hrtick_update+0x1b/0x4d
[ 5280.560788]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[ 5280.560791]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[ 5280.560794]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[ 5280.560796]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560799]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[ 5280.560802]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[ 5280.560804]  [<ffffffff8160ea6c>] ? _raw_spin_unlock_irq+0x1c/0x2f
[ 5280.560807]  [<ffffffff81066944>] ? worker_thread+0x41/0x205
[ 5280.560809]  [<ffffffff81066903>] ? rescuer_thread+0x27a/0x27a
[ 5280.560812]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[ 5280.560815]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5280.560817]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[ 5280.560820]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[ 5338.750443] BTRFS info (device dm-8): found 453260 extents
[ 5427.502521] BTRFS info (device dm-8): found 453260 extents
[ 5437.708990] BTRFS info (device dm-8): relocating block group 537818955776 flags 129

Best,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
