Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaLDPLZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 10:11:25 -0500
Date: Thu, 4 Dec 2014 23:11:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: Warning of qgroup accounting from btrfs/057
Message-ID: <20141204150910.GA2140@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While running xfstests, btrfs/057 complained with a WARNING, and I've
changed WARNING a bit to show the wrong accounting number.

(This did not occur in every run, but it's quite easy to reproduce on
my box, and I use two 2G ramdisks.)

Can someone who is familar with qgroup take a look at this problem?

======================================================================
The warning is

	WARN_ON(sign < 0 && qgroup->excl < oper->num_bytes);

======================================================================
Here is the output of xfstests: 

SECTION       -- btrfs
RECREATING    -- btrfs on /dev/vdd
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 localhost 3.18.0-rc6+
MKFS_OPTIONS  -- /dev/vdc
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/vdc /mnt/scratch

btrfs/057        - output mismatch (see
/root/1_source/xfstests/results/120414_1913/btrfs/btrfs/057.out.bad)
    --- tests/btrfs/057.out     2014-08-15 10:17:55.025724505 +0800
    +++
/root/1_source/xfstests/results/120414_1913/btrfs/btrfs/057.out.bad 2014-12-04 19:13:38.825553475 +0800
    @@ -1,3 +1,3 @@
     QA output created by 057
    -4096 4096
    -4096 4096
    +4096 18446744073709547520
    +4096 18446744073709547520
    ...
    (Run 'diff -u tests/btrfs/057.out
/root/1_source/xfstests/results/120414_1913/btrfs/btrfs/057.out.bad'  to see the entire diff)
Ran: btrfs/057
Failures: btrfs/057
Failed 1 of 1 tests
======================================================================
Here is the stack:

[   43.120200] BTRFS info (device vdc): disk space caching is enabled
[   43.125667] BTRFS: creating UUID tree
[   43.128145] SELinux: initialized (dev vdc, type btrfs), uses mountpoint labeling
[   47.171882] BTRFS info (device vdc): qgroup_rescan_init failed with -115
[   47.276730] BTRFS info (device vdc): qgroup scan completed
[   47.476488] ------------[ cut here ]------------
[   47.477682] WARNING: CPU: 1 PID: 61 at fs/btrfs/qgroup.c:1422 btrfs_delayed_qgroup_accounting+0x5a0/0xf50()
[   47.480016] qgroup->excl=217088, oper->num=221184
(              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ )

[   47.481182] Modules linked in:
[   47.482092] CPU: 1 PID: 61 Comm: kworker/u8:1 Not tainted 3.18.0-rc6+ #446
[   47.483951] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   47.487439] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[   47.488621]  0000000000000009 ffff88001e12baf8 ffffffff81820d8d 0000000000000001
[   47.490674]  ffff88001e12bb48 ffff88001e12bb38 ffffffff8107819c 0000000000000000
[   47.492559]  ffff88001e441000 ffff88001f4fce08 ffffffffffffffff ffff88001e441058
[   47.494379] Call Trace:
[   47.494884]  [<ffffffff81820d8d>] dump_stack+0x4e/0x68
[   47.495722]  [<ffffffff8107819c>] warn_slowpath_common+0x8c/0xc0
[   47.496964]  [<ffffffff81078286>] warn_slowpath_fmt+0x46/0x50
[   47.497944]  [<ffffffff81829a11>] ? _raw_spin_lock+0x41/0x50
[   47.498907]  [<ffffffff814092d0>] btrfs_delayed_qgroup_accounting+0x5a0/0xf50
[   47.500047]  [<ffffffff81390991>] btrfs_run_delayed_refs+0x271/0x2c0
[   47.500999]  [<ffffffff81391077>] delayed_ref_async_start+0x37/0x90
[   47.501967]  [<ffffffff813d2bdd>] normal_work_helper+0xdd/0x330
[   47.502930]  [<ffffffff813d3062>] btrfs_extent_refs_helper+0x12/0x20
[   47.503992]  [<ffffffff81090f75>] process_one_work+0x1c5/0x500
[   47.504936]  [<ffffffff81090efc>] ? process_one_work+0x14c/0x500
[   47.505924]  [<ffffffff8109167b>] worker_thread+0x11b/0x450
[   47.506862]  [<ffffffff81091560>] ? rescuer_thread+0x270/0x270
[   47.507822]  [<ffffffff810975a4>] kthread+0xe4/0x100
[   47.508672]  [<ffffffff810974c0>] ? flush_kthread_worker+0x70/0x70
[   47.509699]  [<ffffffff8182a7ec>] ret_from_fork+0x7c/0xb0
[   47.510605]  [<ffffffff810974c0>] ? flush_kthread_worker+0x70/0x70
[   47.511618] ---[ end trace 48407548559b14ea ]---
[   47.872350] ------------[ cut here ]------------
[   47.873122] WARNING: CPU: 0 PID: 1361 at fs/btrfs/qgroup.c:1422 btrfs_delayed_qgroup_accounting+0x5a0/0xf50()
[   47.874957] qgroup->excl=0, oper->num=4096
(              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ )

[   47.884067] Modules linked in:
[   47.885312] CPU: 0 PID: 1361 Comm: btrfs Tainted: G        W 3.18.0-rc6+ #446
[   47.887145] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   47.890041]  0000000000000009 ffff88003e8e7aa8 ffffffff81820d8d 0000000000000001
[   47.892044]  ffff88003e8e7af8 ffff88003e8e7ae8 ffffffff8107819c 0000000000000000
[   47.894031]  ffff880020a87080 ffff88001f4fc388 ffffffffffffffff ffff880020a870d8
[   47.895992] Call Trace:
[   47.896630]  [<ffffffff81820d8d>] dump_stack+0x4e/0x68
[   47.897779]  [<ffffffff8107819c>] warn_slowpath_common+0x8c/0xc0
[   47.899107]  [<ffffffff81078286>] warn_slowpath_fmt+0x46/0x50
[   47.900404]  [<ffffffff81829a11>] ? _raw_spin_lock+0x41/0x50
[   47.901683]  [<ffffffff814092d0>] btrfs_delayed_qgroup_accounting+0x5a0/0xf50
[   47.903259]  [<ffffffff81390991>] btrfs_run_delayed_refs+0x271/0x2c0
[   47.904670]  [<ffffffff813a1b7e>] btrfs_commit_transaction+0x4e/0xa10
[   47.906121]  [<ffffffff8136ea77>] btrfs_sync_fs+0x67/0xe0
[   47.907380]  [<ffffffff813db62d>] btrfs_ioctl+0x1a2d/0x2b50
[   47.908673]  [<ffffffff8182a2bb>] ? _raw_spin_unlock+0x2b/0x40
[   47.910241]  [<ffffffff81437c24>] ? avc_has_perm+0x24/0x1d0
[   47.911497]  [<ffffffff81437d0d>] ? avc_has_perm+0x10d/0x1d0
[   47.912776]  [<ffffffff81437d25>] ? avc_has_perm+0x125/0x1d0
[   47.914231]  [<ffffffff81437c24>] ? avc_has_perm+0x24/0x1d0
[   47.915512]  [<ffffffff810efb4b>] ? current_kernel_time+0x5b/0xb0
[   47.916995]  [<ffffffff81207fc8>] do_vfs_ioctl+0x88/0x570
[   47.918216]  [<ffffffff81439347>] ? inode_has_perm.isra.24+0x27/0x30
[   47.919644]  [<ffffffff814393e7>] ? file_has_perm+0x97/0xb0
[   47.920909]  [<ffffffff811222a4>] ? __audit_syscall_entry+0xb4/0x110
[   47.922331]  [<ffffffff81208541>] SyS_ioctl+0x91/0xb0
[   47.923485]  [<ffffffff8182a892>] system_call_fastpath+0x12/0x17
[   47.925122] ---[ end trace 48407548559b14eb ]---

Thanks,

-liubo
