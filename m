Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3KOIXj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 03:23:39 -0500
Message-ID: <1384503816.4623.4.camel@hsew-frn.HIPERSCAN>
Subject: Re: invalid opcode: 0000 [#1] SMP
From: Franziska =?ISO-8859-1?Q?N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
Reply-To: franziska.naepelt@hiperscan.com
To: linux-btrfs@vger.kernel.org
Date: Fri, 15 Nov 2013 09:23:36 +0100
In-Reply-To: <pan$d06e7$206fd374$423b51c3$17212f9e@cox.net>
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are sometimes other stacktraces, maybe this can help to find the
initil error:

 Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564931] btrfs-transacti D
ffff88063fc72ec0     0  2289      2 0x00000000
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564936]  ffff880622d41140
0000000000000046 ffff8806268e1750 ffffffff81057ef7
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564941]  0000000000012ec0
ffff88061a4a3fd8 ffff88061a4a3fd8 ffff880622d41140
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564945]  0000000000000246
ffff88062522cea8 ffff880622bf51e8 ffff88061a4a3de0
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564949] Call Trace:
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564957]
[<ffffffff81057ef7>] ? finish_task_switch+0x7e/0xa8
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564989]
[<ffffffffa01d0bb1>] ? wait_current_trans.isra.28+0xbc/0x117 [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.564994]
[<ffffffff8104fd15>] ? wake_up_atomic_t+0x22/0x22
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565015]
[<ffffffffa01d24df>] ? start_transaction+0x1d3/0x46d [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565019]
[<ffffffff81057f3e>] ? should_resched+0x5/0x23
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565038]
[<ffffffffa01cb82f>] ? transaction_kthread+0xbe/0x183 [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565057]
[<ffffffffa01cb771>] ? btrfs_alloc_root+0x1c/0x1c [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565076]
[<ffffffffa01cb771>] ? btrfs_alloc_root+0x1c/0x1c [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565080]
[<ffffffff8104f375>] ? kthread+0x81/0x89
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565084]
[<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565089]
[<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565093]
[<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565109] nfsd            D
ffff88063fc72ec0     0  3858      2 0x00000000
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565113]  ffff88062370c100
0000000000000046 ffff8806268e1750 ffffea0014fefc20
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565117]  0000000000012ec0
ffff88061531dfd8 ffff88061531dfd8 ffff88062370c100
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565121]  0000000000000246
ffff88062522cea8 ffff88062583d9e8 ffff88061531db10
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565125] Call Trace:
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565145]
[<ffffffffa01d0bb1>] ? wait_current_trans.isra.28+0xbc/0x117 [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565150]
[<ffffffff8104fd15>] ? wake_up_atomic_t+0x22/0x22
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565170]
[<ffffffffa01d24df>] ? start_transaction+0x1d3/0x46d [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565191]
[<ffffffffa01d6acb>] ? btrfs_dirty_inode+0x24/0xa5 [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565196]
[<ffffffff81114d7b>] ? touch_atime+0xe3/0x11c
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565201]
[<ffffffff81123668>] ? generic_file_splice_read+0x4e/0x5a
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565205]
[<ffffffff81122a0f>] ? splice_direct_to_actor+0xa2/0x179
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565213]
[<ffffffffa063c33d>] ? commit_metadata+0x3b/0x3b [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565222]
[<ffffffffa063c802>] ? nfsd_vfs_read.isra.10+0x79/0x12b [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565231]
[<ffffffffa063d201>] ? nfsd_read+0x1a8/0x212 [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565242]
[<ffffffffa0642b85>] ? nfsd3_proc_read+0x85/0xbc [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565250]
[<ffffffffa0639951>] ? nfsd_dispatch+0x8f/0x146 [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565262]
[<ffffffffa05f71e6>] ? svc_process_common+0x289/0x3de [sunrpc]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565269]
[<ffffffffa063945c>] ? nfsd_destroy+0x59/0x59 [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565280]
[<ffffffffa05f7d68>] ? svc_process+0xfb/0x117 [sunrpc]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565288]
[<ffffffffa0639519>] ? nfsd+0xbd/0x114 [nfsd]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565292]
[<ffffffff8104f375>] ? kthread+0x81/0x89
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565296]
[<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565299]
[<ffffffff81371f2c>] ? ret_from_fork+0x7c/0xb0
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565303]
[<ffffffff8104f2f4>] ? __kthread_parkme+0x5d/0x5d
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565328] bash            D
ffff88063fc32ec0     0  5672   5291 0x00000000
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565332]  ffff8806140b3100
0000000000000086 ffff8806268df890 0000000000000000
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565336]  0000000000012ec0
ffff880618a1ffd8 ffff880618a1ffd8 ffff8806140b3100
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565339]  0000000000000246
ffff88062522cea8 ffff88062583d9e8 ffff880618a1fc30
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565343] Call Trace:
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565364]
[<ffffffffa01d0bb1>] ? wait_current_trans.isra.28+0xbc/0x117 [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565368]
[<ffffffff8104fd15>] ? wake_up_atomic_t+0x22/0x22
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565389]
[<ffffffffa01d24df>] ? start_transaction+0x1d3/0x46d [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565410]
[<ffffffffa01d6acb>] ? btrfs_dirty_inode+0x24/0xa5 [btrfs]
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565414]
[<ffffffff81114d7b>] ? touch_atime+0xe3/0x11c
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565419]
[<ffffffff810bfdc3>] ? generic_file_aio_read+0x55a/0x5b9
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565424]
[<ffffffff81101aaf>] ? do_sync_read+0x55/0x7c
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565428]
[<ffffffff811024f9>] ? vfs_read+0x93/0xf5
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565432]
[<ffffffff81102672>] ? SyS_read+0x51/0x85
Nov 12 08:11:19 hsad-srv-03 kernel: [  240.565436]
[<ffffffff81371fd2>] ? system_call_fastpath+0x16/0x1b


