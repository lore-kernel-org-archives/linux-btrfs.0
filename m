Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55619 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaBXG6s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:58:48 -0500
Date: Sun, 23 Feb 2014 22:58:47 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
Message-ID: <20140224065847.GE15937@merlins.org>
References: <20140224061426.GB15937@merlins.org> <20140224061714.GC15937@merlins.org> <pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 06:42:30AM +0000, Duncan wrote:
> I believe there's a fix coming (a cancel that blows away the tracking 
> file if it finds it and no actual running scrub is the most obvious fix), 
> but meanwhile, see the /var/lib/btrfs/scrub.status.* files.  That's where 
> scrub state is stored, and manually blowing away the appropriate file 
> should clear btrfs' memory of the aborted scrub, so you can scrub start 
> properly.

Ah, silly me, I thought this was all in the kernel and not in userspace.

Yep, I cleared the stats, and that part is back to ok, thanks.

I'm not getting btrfs hang on /mnt/btrfs_pool2 after reboot, so that's good.

But I'm still seeing these, albeit less often. 
Any idea what they could be linked to?
(I have a btrs send/receive going right now, it could hanging /mnt/btrfs_pool1
in a way that affects smbd, but the array feels ok otherwise, weird...)

[ 1332.548370] INFO: task smbd:21882 blocked for more than 120 seconds.
[ 1332.587455]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 1332.625478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1332.673439] smbd            D c18d2600     0 21882   9962 0x00000080
[ 1332.713505]  ef78be88 00000086 c18d2600 c18d2600 c11e39bc 00002675 00000000 000000c5
[ 1332.761149]  f6e362d0 00000f16 00000000 ef78be58 c11d3ce9 00001000 00000002 00000000
[ 1332.808763]  00000f14 ef78be64 c1062374 00000246 ef78be74 00000246 ef78be74 c150348b
[ 1332.856382] Call Trace:
[ 1332.872106]  [<c11e39bc>] ? btrfs_tree_read_lock+0xb4/0xbc
[ 1332.906057]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 1332.942646]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 1332.976094]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 1333.013744]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 1333.048272]  [<c1501477>] schedule+0x63/0x65
[ 1333.074985]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 1333.111090]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 1333.140429]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 1333.172874]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 1333.206894]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 1333.239169]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 1333.270531]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 1333.302913]  [<c11140f0>] update_time+0x1e/0x95
[ 1333.331136]  [<c111474d>] touch_atime+0xd1/0x105
[ 1333.359834]  [<c110f201>] iterate_dir+0x87/0x9f
[ 1333.388016]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 1333.417730]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 1333.444837]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 1375.924436] nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
[ 1453.574620] INFO: task smbd:21882 blocked for more than 120 seconds.
[ 1453.613832]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 1453.652896] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1453.700923] smbd            D c18d2600     0 21882   9962 0x00000080
[ 1453.740164]  ef78be88 00000086 c18d2600 c18d2600 c11e39bc 00002675 00000000 000000c5
[ 1453.787879]  f6e362d0 00000f16 00000000 ef78be58 c11d3ce9 00001000 00000002 00000000
[ 1453.835604]  00000f14 ef78be64 c1062374 00000246 ef78be74 00000246 ef78be74 c150348b
[ 1453.883360] Call Trace:
[ 1453.899608]  [<c11e39bc>] ? btrfs_tree_read_lock+0xb4/0xbc
[ 1453.933661]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 1453.970338]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 1454.003890]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 1454.042674]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 1454.077390]  [<c1501477>] schedule+0x63/0x65
[ 1454.104194]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 1454.140351]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 1454.169714]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 1454.202140]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 1454.236090]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 1454.267416]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 1454.298728]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 1454.331069]  [<c11140f0>] update_time+0x1e/0x95
[ 1454.359214]  [<c111474d>] touch_atime+0xd1/0x105
[ 1454.388673]  [<c110f201>] iterate_dir+0x87/0x9f
[ 1454.416795]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 1454.446479]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 1454.473500]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 1574.608832] INFO: task smbd:21882 blocked for more than 120 seconds.
[ 1574.648653]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 1574.696703] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1574.745534] smbd            D c18d2600     0 21882   9962 0x00000084
[ 1574.785358]  ef78be88 00000086 c18d2600 c18d2600 c11e39bc 00002675 00000000 000000c5
[ 1574.833328]  f6e362d0 00000f16 00000000 ef78be58 c11d3ce9 00001000 00000002 00000000
[ 1574.881651]  00000f14 ef78be64 c1062374 00000246 ef78be74 00000246 ef78be74 c150348b
[ 1574.929217] Call Trace:
[ 1574.944894]  [<c11e39bc>] ? btrfs_tree_read_lock+0xb4/0xbc
[ 1574.978788]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 1575.015288]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 1575.048692]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 1575.087065]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 1575.122403]  [<c1501477>] schedule+0x63/0x65
[ 1575.149032]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 1575.185033]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 1575.214277]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 1575.246646]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 1575.280609]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 1575.311902]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 1575.343127]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 1575.375386]  [<c11140f0>] update_time+0x1e/0x95
[ 1575.403470]  [<c111474d>] touch_atime+0xd1/0x105
[ 1575.432043]  [<c110f201>] iterate_dir+0x87/0x9f
[ 1575.460837]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 1575.490433]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 1575.517402]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 1695.646996] INFO: task smbd:21882 blocked for more than 120 seconds.
[ 1695.686233]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 1695.724419] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1695.772929] smbd            D c18d2600     0 21882   9962 0x00000084
[ 1695.813545]  ef78be88 00000086 c18d2600 c18d2600 c11e39bc 00002675 00000000 000000c5
[ 1695.862111]  f6e362d0 00000f16 00000000 ef78be58 c11d3ce9 00001000 00000002 00000000
[ 1695.883936]  00000f14 ef78be64 c1062374 00000246 ef78be74 00000246 ef78be74 c150348b
[ 1695.883942] Call Trace:
[ 1695.883944]  [<c11e39bc>] ? btrfs_tree_read_lock+0xb4/0xbc
[ 1695.883951]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 1695.883954]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 1695.883958]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 1695.883961]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 1695.883966]  [<c1501477>] schedule+0x63/0x65
[ 1695.883969]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 1695.883973]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 1695.883999]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 1695.884003]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 1695.884005]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 1695.884009]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 1695.884011]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 1695.884014]  [<c11140f0>] update_time+0x1e/0x95
[ 1695.884217]  [<c111474d>] touch_atime+0xd1/0x105
[ 1695.884219]  [<c110f201>] iterate_dir+0x87/0x9f
[ 1695.884221]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 1695.884223]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 1695.884225]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 1695.884420] INFO: task sync:31933 blocked for more than 120 seconds.
[ 1695.884421]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 1695.884422] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1695.884423] sync            D c18d2600     0 31933  31598 0x00000080
[ 1695.884425]  c30f3ee4 00000086 c18d2600 c18d2600 00011d30 00000000 00000000 00000153
[ 1695.884429]  f6f90150 00000000 00000000 f1e8a070 c30f3eb0 c11cde6b 00000000 c30f3eb4
[ 1695.884432]  c150345e c30f3ec0 c1062374 00000246 c30f3ed0 00000246 c30f3ed0 c150348b
[ 1695.884436] Call Trace:
[ 1695.884436]  [<c11cde6b>] ? find_first_extent_bit_state+0x13/0x3f
[ 1695.884608]  [<c150345e>] ? _raw_spin_unlock+0x15/0x26
[ 1695.884609]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 1695.884611]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 1695.884613]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 1695.884615]  [<c1501477>] schedule+0x63/0x65
[ 1695.884617]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 1695.884619]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 1695.884621]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 1695.884623]  [<c11ba6e7>] btrfs_attach_transaction_barrier+0x1c/0x41
[ 1695.884625]  [<c11995fb>] btrfs_sync_fs+0x67/0xa5
[ 1695.884628]  [<c1199594>] ? ftrace_raw_event_btrfs_space_reservation+0xe2/0xe2
[ 1695.884630]  [<c11225af>] ? SyS_tee+0x1e1/0x1e1
[ 1695.884633]  [<c11225cb>] sync_fs_one_sb+0x1c/0x1e
[ 1695.884635]  [<c1104c23>] iterate_supers+0x5b/0xa0
[ 1695.884637]  [<c1122996>] sys_sync+0x54/0x7e
[ 1695.884638]  [<c1508c8d>] sysenter_do_call+0x12/0x28

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
