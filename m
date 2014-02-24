Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55333 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaBXGO0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:14:26 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WHoo6-0006p1-AU
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Feb 2014 22:14:26 -0800
Date: Sun, 23 Feb 2014 22:14:26 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.13.5 kernel hangs some processes with btrfs
Message-ID: <20140224061426.GB15937@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does someone know how I can debug further why this is hanging?

It seems that accessing a certain directory on one of my btrfs filesystems
causes this.

The rest of my system seems ok, as long as I'm not touching this filesystem.

Is this a bug, or a performance problem?

[ 1930.287192] INFO: task mc:4759 blocked for more than 120 seconds.
[ 1930.323551]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 1930.360857] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1930.408072] mc              D c18d2600     0  4759   4568 0x00000084
[ 1930.445960]  f10f9e88 00000082 c18d2600 c18d2600 00000000 00000000 f3e38c80 00000000
[ 1930.492442]  ef34c490 00000e27 00000000 f10f9e58 c11d3ce9 00001000 00000002 00000000
[ 1930.538992]  00000e25 f10f9e64 c1062374 00000246 f10f9e74 00000246 f10f9e74 c150348b
[ 1930.585546] Call Trace:
[ 1930.600231]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 1930.635615]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 1930.667889]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 1930.704425]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 1930.737751]  [<c1501477>] schedule+0x63/0x65
[ 1930.763255]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 1930.798146]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 1930.826278]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 1930.857529]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 1930.890353]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 1930.920576]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 1930.950781]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 1930.982039]  [<c11140f0>] update_time+0x1e/0x95
[ 1931.009124]  [<c111474d>] touch_atime+0xd1/0x105
[ 1931.036727]  [<c110f201>] iterate_dir+0x87/0x9f
[ 1931.063819]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 1931.092482]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 1931.127855]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 2051.257792] INFO: task mc:4759 blocked for more than 120 seconds.
[ 2051.294060]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 2051.331042] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2051.377904] mc              D c18d2600     0  4759   4568 0x00000084
[ 2051.415943]  f10f9e88 00000082 c18d2600 c18d2600 00000000 00000000 f3e38c80 00000000
[ 2051.465288]  ef34c490 00000e27 00000000 f10f9e58 c11d3ce9 00001000 00000002 00000000
[ 2051.514381]  00000e25 f10f9e64 c1062374 00000246 f10f9e74 00000246 f10f9e74 c150348b
[ 2051.565902] Call Trace:
[ 2051.582441]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 2051.619402]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 2051.653297]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 2051.691230]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 2051.726027]  [<c1501477>] schedule+0x63/0x65
[ 2051.753324]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 2051.790796]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 2051.821899]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 2051.855772]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 2051.890151]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 2051.921943]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 2051.954211]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 2051.986914]  [<c11140f0>] update_time+0x1e/0x95
[ 2052.015485]  [<c111474d>] touch_atime+0xd1/0x105
[ 2052.044702]  [<c110f201>] iterate_dir+0x87/0x9f
[ 2052.073201]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 2052.103355]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 2052.130848]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 2096.805058] perf samples too long (2503 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 2096.861168] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 56.110 msecs
[ 2172.260339] INFO: task mc:4759 blocked for more than 120 seconds.
[ 2172.298384]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 2172.338045] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2172.387803] mc              D c18d2600     0  4759   4568 0x00000084
[ 2172.427411]  f10f9e88 00000082 c18d2600 c18d2600 00000000 00000000 f3e38c80 00000000
[ 2172.475461]  ef34c490 00000e27 00000000 f10f9e58 c11d3ce9 00001000 00000002 00000000
[ 2172.523521]  00000e25 f10f9e64 c1062374 00000246 f10f9e74 00000246 f10f9e74 c150348b
[ 2172.571674] Call Trace:
[ 2172.587871]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 2172.624823]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 2172.659881]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 2172.698558]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 2172.733853]  [<c1501477>] schedule+0x63/0x65
[ 2172.762269]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 2172.799382]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 2172.830296]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 2172.868749]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 2172.908785]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 2172.944813]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 2172.977512]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 2173.010264]  [<c11140f0>] update_time+0x1e/0x95
[ 2173.038796]  [<c111474d>] touch_atime+0xd1/0x105
[ 2173.073517]  [<c110f201>] iterate_dir+0x87/0x9f
[ 2173.102140]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 2173.133333]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 2173.160751]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 2293.290687] INFO: task mc:4759 blocked for more than 120 seconds.
[ 2293.331803]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 2293.373134] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2293.422548] mc              D c18d2600     0  4759   4568 0x00000084
[ 2293.461998]  f10f9e88 00000082 c18d2600 c18d2600 00000000 00000000 f3e38c80 00000000
[ 2293.510991]  ef34c490 00000e27 00000000 f10f9e58 c11d3ce9 00001000 00000002 00000000
[ 2293.559835]  00000e25 f10f9e64 c1062374 00000246 f10f9e74 00000246 f10f9e74 c150348b
[ 2293.607832] Call Trace:
[ 2293.623798]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 2293.661353]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 2293.696040]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 2293.734968]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 2293.770187]  [<c1501477>] schedule+0x63/0x65
[ 2293.797124]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 2293.833396]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 2293.864027]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 2293.896638]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 2293.931754]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 2293.963336]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 2293.994908]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 2294.027580]  [<c11140f0>] update_time+0x1e/0x95
[ 2294.056016]  [<c111474d>] touch_atime+0xd1/0x105
[ 2294.085036]  [<c110f201>] iterate_dir+0x87/0x9f
[ 2294.114382]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 2294.144591]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 2294.172042]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 2414.300956] INFO: task mc:4759 blocked for more than 120 seconds.
[ 2414.340086]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 2414.384979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2414.453036] mc              D c18d2600     0  4759   4568 0x00000084
[ 2414.493492]  f10f9e88 00000082 c18d2600 c18d2600 00000000 00000000 f3e38c80 00000000
[ 2414.543276]  ef34c490 00000e27 00000000 f10f9e58 c11d3ce9 00001000 00000002 00000000
[ 2414.591394]  00000e25 f10f9e64 c1062374 00000246 f10f9e74 00000246 f10f9e74 c150348b
[ 2414.640205] Call Trace:
[ 2414.657776]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 2414.694825]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 2414.729268]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 2414.769847]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 2414.805628]  [<c1501477>] schedule+0x63/0x65
[ 2414.832453]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 2414.869475]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 2414.902581]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 2414.936769]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 2414.972268]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 2415.006395]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 2415.038491]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 2415.071052]  [<c11140f0>] update_time+0x1e/0x95
[ 2415.099609]  [<c111474d>] touch_atime+0xd1/0x105
[ 2415.131526]  [<c110f201>] iterate_dir+0x87/0x9f
[ 2415.160521]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 2415.191060]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 2415.218491]  [<c1508c8d>] sysenter_do_call+0x12/0x28
[ 2535.351188] INFO: task mc:4759 blocked for more than 120 seconds.
[ 2535.390988]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
[ 2535.435219] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2535.487488] mc              D c18d2600     0  4759   4568 0x00000084
[ 2535.526773]  f10f9e88 00000082 c18d2600 c18d2600 00000000 00000000 f3e38c80 00000000
[ 2535.577238]  ef34c490 00000e27 00000000 f10f9e58 c11d3ce9 00001000 00000002 00000000
[ 2535.624866]  00000e25 f10f9e64 c1062374 00000246 f10f9e74 00000246 f10f9e74 c150348b
[ 2535.673086] Call Trace:
[ 2535.689644]  [<c11d3ce9>] ? map_private_extent_buffer+0x7e/0xa2
[ 2535.726646]  [<c1062374>] ? arch_local_irq_save+0x12/0x17
[ 2535.827566]  [<c150348b>] ? _raw_spin_unlock_irqrestore+0x1c/0x2d
[ 2535.918809]  [<c105e6d6>] ? prepare_to_wait_event+0x85/0xb6
[ 2535.958677]  [<c1501477>] schedule+0x63/0x65
[ 2535.987216]  [<c11b9288>] wait_current_trans.isra.14+0x7e/0xcb
[ 2536.026184]  [<c105e774>] ? finish_wait+0x4e/0x4e
[ 2536.059817]  [<c11ba35c>] start_transaction+0x21f/0x4f0
[ 2536.094450]  [<c11ba67b>] btrfs_join_transaction+0x18/0x1a
[ 2536.132300]  [<c11be973>] btrfs_dirty_inode+0x22/0x91
[ 2536.173076]  [<c11bea4b>] btrfs_update_time+0x69/0x75
[ 2536.205513]  [<c11be9e2>] ? btrfs_dirty_inode+0x91/0x91
[ 2536.240373]  [<c11140f0>] update_time+0x1e/0x95
[ 2536.270982]  [<c111474d>] touch_atime+0xd1/0x105
[ 2536.303949]  [<c110f201>] iterate_dir+0x87/0x9f
[ 2536.332996]  [<c110f65f>] SyS_getdents64+0x65/0xbb
[ 2536.365792]  [<c110f3d9>] ? filldir+0xdf/0xdf
[ 2536.395033]  [<c1508c8d>] sysenter_do_call+0x12/0x28

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
