Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64272 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3LaLqJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Dec 2013 06:46:09 -0500
Received: from [192.168.0.2] ([93.82.95.55]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MDi9C-1WDsav42YQ-00H4D9 for
 <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 12:46:08 +0100
Message-ID: <52C2AE7C.5020601@gmx.at>
Date: Tue, 31 Dec 2013 12:46:04 +0100
From: Sulla <Sulla@gmx.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-transaction blocked for more than 120 seconds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all!

On my Ubuntu Server 13.10 I use a RAID5 blockdevice consisting of 3 WD20EARS
drives. On this I built a LVM and in this LVM I use quite normal partitions
/, /home, SWAP (/boot resides on a RAID1.) and also a custom /data
partition. Everything (except boot and swap) is on btrfs.

sometimes my system hangs for quite some time (top is showing a high wait
percentage), then runs on normally. I get kernel messages into
/var/log/sylsog, see below. I am unable to make any sense of the kernel
messages, there is no reference to the filesystem or drive affected (at
least I can not find one).

Question: What is happening here?
* Is a HDD failing (smart looks good, however)
* Is something wrong with my btrfs-filesystem? with which one?
* How can I find the cause?

thanks, Wolfgang


Dec 31 12:27:49 freedom kernel: [ 4681.264112] INFO: task
btrfs-transacti:529 blocked for more than 120 seconds.

Dec 31 12:27:49 freedom kernel: [ 4681.264239] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.

Dec 31 12:27:49 freedom kernel: [ 4681.264367] btrfs-transacti D
ffff88013fc14580     0   529      2 0x00000000

Dec 31 12:27:49 freedom kernel: [ 4681.264377]  ffff880138345e10
0000000000000046 ffff880138345fd8 0000000000014580

Dec 31 12:27:49 freedom kernel: [ 4681.264386]  ffff880138345fd8
0000000000014580 ffff880135615dc0 ffff880132fb6a00

Dec 31 12:27:49 freedom kernel: [ 4681.264393]  ffff880133f45800
ffff880138345e30 ffff880137ee2000 ffff880137ee2070

Dec 31 12:27:49 freedom kernel: [ 4681.264402] Call Trace:

Dec 31 12:27:49 freedom kernel: [ 4681.264418]  [<ffffffff816eaa79>]
schedule+0x29/0x70

Dec 31 12:27:49 freedom kernel: [ 4681.264477]  [<ffffffffa032a57d>]
btrfs_commit_transaction+0x34d/0x980 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.264487]  [<ffffffff81085580>] ?
wake_up_atomic_t+0x30/0x30

Dec 31 12:27:49 freedom kernel: [ 4681.264517]  [<ffffffffa0321be5>]
transaction_kthread+0x1a5/0x240 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.264548]  [<ffffffffa0321a40>] ?
verify_parent_transid+0x150/0x150 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.264557]  [<ffffffff810847b0>]
kthread+0xc0/0xd0

Dec 31 12:27:49 freedom kernel: [ 4681.264565]  [<ffffffff810846f0>] ?
kthread_create_on_node+0x120/0x120

Dec 31 12:27:49 freedom kernel: [ 4681.264573]  [<ffffffff816f566c>]
ret_from_fork+0x7c/0xb0

Dec 31 12:27:49 freedom kernel: [ 4681.264580]  [<ffffffff810846f0>] ?
kthread_create_on_node+0x120/0x120

Dec 31 12:27:49 freedom kernel: [ 4681.264610] INFO: task kworker/u4:0:9975
blocked for more than 120 seconds.

Dec 31 12:27:49 freedom kernel: [ 4681.264722] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.

Dec 31 12:27:49 freedom kernel: [ 4681.264847] kworker/u4:0    D
ffff88013fd14580     0  9975      2 0x00000000

Dec 31 12:27:49 freedom kernel: [ 4681.264861] Workqueue: writeback
bdi_writeback_workfn (flush-btrfs-4)

Dec 31 12:27:49 freedom kernel: [ 4681.264865]  ffff8800a8739538
0000000000000046 ffff8800a8739fd8 0000000000014580

Dec 31 12:27:49 freedom kernel: [ 4681.264873]  ffff8800a8739fd8
0000000000014580 ffff8801351e5dc0 ffff8801351e5dc0

Dec 31 12:27:49 freedom kernel: [ 4681.264880]  ffff880134c5e6a8
ffff880134c5e6b0 ffffffff00000000 ffff880134c5e6b8

Dec 31 12:27:49 freedom kernel: [ 4681.264887] Call Trace:

Dec 31 12:27:49 freedom kernel: [ 4681.264895]  [<ffffffff816eaa79>]
schedule+0x29/0x70

Dec 31 12:27:49 freedom kernel: [ 4681.264902]  [<ffffffff816ec465>]
rwsem_down_write_failed+0x105/0x1e0

Dec 31 12:27:49 freedom kernel: [ 4681.264911]  [<ffffffff8136257d>] ?
__rwsem_do_wake+0xdd/0x160

Dec 31 12:27:49 freedom kernel: [ 4681.264918]  [<ffffffff81369763>]
call_rwsem_down_write_failed+0x13/0x20

Dec 31 12:27:49 freedom kernel: [ 4681.264927]  [<ffffffff816e9e7d>] ?
down_write+0x2d/0x30

Dec 31 12:27:49 freedom kernel: [ 4681.264956]  [<ffffffffa030fbe0>]
cache_block_group+0x290/0x3b0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.264963]  [<ffffffff81085580>] ?
wake_up_atomic_t+0x30/0x30

Dec 31 12:27:49 freedom kernel: [ 4681.264991]  [<ffffffffa0317d48>]
find_free_extent+0xa38/0xac0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265022]  [<ffffffffa0317ef2>]
btrfs_reserve_extent+0xa2/0x1c0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265056]  [<ffffffffa033103d>]
__cow_file_range+0x15d/0x4a0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265090]  [<ffffffffa0331efa>]
cow_file_range+0x8a/0xd0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265122]  [<ffffffffa0332290>]
run_delalloc_range+0x350/0x390 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265158]  [<ffffffffa0346bf1>] ?
find_lock_delalloc_range.constprop.42+0x1d1/0x1f0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265194]  [<ffffffffa0348764>]
__extent_writepage+0x304/0x750 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265202]  [<ffffffff8109a1d5>] ?
set_next_entity+0x95/0xb0

Dec 31 12:27:49 freedom kernel: [ 4681.265212]  [<ffffffff810115c6>] ?
__switch_to+0x126/0x4b0

Dec 31 12:27:49 freedom kernel: [ 4681.265221]  [<ffffffff8104dee9>] ?
default_spin_lock_flags+0x9/0x10

Dec 31 12:27:49 freedom kernel: [ 4681.265229]  [<ffffffff8113f6c1>] ?
find_get_pages_tag+0xd1/0x180

Dec 31 12:27:49 freedom kernel: [ 4681.265266]  [<ffffffffa0348e32>]
extent_write_cache_pages.isra.31.constprop.46+0x282/0x3e0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265303]  [<ffffffffa034928d>]
extent_writepages+0x4d/0x70 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265336]  [<ffffffffa032ea90>] ?
btrfs_real_readdir+0x5c0/0x5c0 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265369]  [<ffffffffa032caa8>]
btrfs_writepages+0x28/0x30 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265378]  [<ffffffff8114a4ae>]
do_writepages+0x1e/0x40

Dec 31 12:27:49 freedom kernel: [ 4681.265387]  [<ffffffff811ce7d0>]
__writeback_single_inode+0x40/0x220

Dec 31 12:27:49 freedom kernel: [ 4681.265395]  [<ffffffff811ceb4b>]
writeback_sb_inodes+0x19b/0x3b0

Dec 31 12:27:49 freedom kernel: [ 4681.265403]  [<ffffffff811cedff>]
__writeback_inodes_wb+0x9f/0xd0

Dec 31 12:27:49 freedom kernel: [ 4681.265411]  [<ffffffff811cf623>]
wb_writeback+0x243/0x2c0

Dec 31 12:27:49 freedom kernel: [ 4681.265418]  [<ffffffff811d1489>]
bdi_writeback_workfn+0x1b9/0x3d0

Dec 31 12:27:49 freedom kernel: [ 4681.265426]  [<ffffffff8107d05c>]
process_one_work+0x17c/0x430

Dec 31 12:27:49 freedom kernel: [ 4681.265432]  [<ffffffff8107dcac>]
worker_thread+0x11c/0x3c0

Dec 31 12:27:49 freedom kernel: [ 4681.265439]  [<ffffffff8107db90>] ?
manage_workers.isra.24+0x2a0/0x2a0

Dec 31 12:27:49 freedom kernel: [ 4681.265447]  [<ffffffff810847b0>]
kthread+0xc0/0xd0

Dec 31 12:27:49 freedom kernel: [ 4681.265454]  [<ffffffff810846f0>] ?
kthread_create_on_node+0x120/0x120

Dec 31 12:27:49 freedom kernel: [ 4681.265461]  [<ffffffff816f566c>]
ret_from_fork+0x7c/0xb0

Dec 31 12:27:49 freedom kernel: [ 4681.265469]  [<ffffffff810846f0>] ?
kthread_create_on_node+0x120/0x120

Dec 31 12:27:49 freedom kernel: [ 4681.265476] INFO: task smbd:10275 blocked
for more than 120 seconds.

Dec 31 12:27:49 freedom kernel: [ 4681.265579] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.

Dec 31 12:27:49 freedom kernel: [ 4681.265704] smbd            D
ffff88013fc14580     0 10275    723 0x00000004

Dec 31 12:27:49 freedom kernel: [ 4681.265711]  ffff8800a5abbbc0
0000000000000046 ffff8800a5abbfd8 0000000000014580

Dec 31 12:27:49 freedom kernel: [ 4681.265718]  ffff8800a5abbfd8
0000000000014580 ffff880133d5aee0 ffff880137ee2000

Dec 31 12:27:49 freedom kernel: [ 4681.265726]  ffff880133db79e8
ffff880133db79e8 0000000000000001 ffff880132d2dc80

Dec 31 12:27:49 freedom kernel: [ 4681.265733] Call Trace:

Dec 31 12:27:49 freedom kernel: [ 4681.265739]  [<ffffffff816eaa79>]
schedule+0x29/0x70

Dec 31 12:27:49 freedom kernel: [ 4681.265772]  [<ffffffffa03296df>]
wait_current_trans.isra.18+0xbf/0x120 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265778]  [<ffffffff81085580>] ?
wake_up_atomic_t+0x30/0x30

Dec 31 12:27:49 freedom kernel: [ 4681.265810]  [<ffffffffa032af06>]
start_transaction+0x356/0x520 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265843]  [<ffffffffa032b0eb>]
btrfs_start_transaction+0x1b/0x20 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265876]  [<ffffffffa0334887>]
btrfs_cont_expand+0x1c7/0x460 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265911]  [<ffffffffa033cc26>]
btrfs_file_aio_write+0x346/0x520 [btrfs]

Dec 31 12:27:49 freedom kernel: [ 4681.265919]  [<ffffffff811b9810>] ?
poll_select_copy_remaining+0x130/0x130

Dec 31 12:27:49 freedom kernel: [ 4681.265928]  [<ffffffff811a6640>]
do_sync_write+0x80/0xb0

Dec 31 12:27:49 freedom kernel: [ 4681.265936]  [<ffffffff811a6d7d>]
vfs_write+0xbd/0x1e0

Dec 31 12:27:49 freedom kernel: [ 4681.265942]  [<ffffffff811a7932>]
SyS_pwrite64+0x72/0xb0

Dec 31 12:27:49 freedom kernel: [ 4681.265949]  [<ffffffff816f571d>]
system_call_fastpath+0x1a/0x1f


-- 
For a successful technology, reality must take precedence over
public relations, for Nature cannot be fooled.
  Richard P. Feynman















