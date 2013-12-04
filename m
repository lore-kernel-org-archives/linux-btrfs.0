Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3LDLzs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 06:55:48 -0500
Date: Wed, 4 Dec 2013 11:55:44 +0000
From: Mel Gorman <mgorman@suse.de>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.cz>
Subject: btrfs deadlocks under stress up until 3.12
Message-ID: <20131204115544.GA8473@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I queued up a number of tests including IO stress tests a few weeks ago
and had noticed that some of the btrfs tests failed to complete but only
looked today.  Specfically, stress tests with reaims alltests configuration
on btrfs failed up until 3.12 with a console log that looked like

[ 2882.975251] INFO: task btrfs-transacti:2816 blocked for more than 480 seconds.
[ 2882.994789] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2883.015070] btrfs-transacti D ffff88023fc13600     0  2816      2 0x00000000
[ 2883.034734]  ffff880234539dc0 0000000000000046 ffff880234539fd8 0000000000013600
[ 2883.054847]  ffff880234539fd8 0000000000013600 ffff880230a44540 ffff8801c97868b8
[ 2883.075027]  ffff8802346be9e8 ffff8802346be9e8 0000000000000000 ffff8801ef4a6770
[ 2883.095256] Call Trace:
[ 2883.110170]  [<ffffffff815de804>] schedule+0x24/0x70
[ 2883.127723]  [<ffffffff8128460f>] wait_current_trans.isra.18+0xaf/0x110
[ 2883.147034]  [<ffffffff810741f0>] ? wake_up_atomic_t+0x30/0x30
[ 2883.165492]  [<ffffffff81285c70>] start_transaction+0x270/0x510
[ 2883.184214]  [<ffffffff81285fc2>] btrfs_attach_transaction+0x12/0x20
[ 2883.203282]  [<ffffffff8127cb74>] transaction_kthread+0x74/0x220
[ 2883.221941]  [<ffffffff8127cb00>] ? verify_parent_transid+0x170/0x170
[ 2883.241048]  [<ffffffff8107347b>] kthread+0xbb/0xc0
[ 2883.258423]  [<ffffffff810733c0>] ? kthread_create_on_node+0x110/0x110
[ 2883.277654]  [<ffffffff815e7efc>] ret_from_fork+0x7c/0xb0
[ 2883.295561]  [<ffffffff810733c0>] ? kthread_create_on_node+0x110/0x110
[ 2883.314535] INFO: task kworker/u16:3:21786 blocked for more than 480 seconds.
[ 2883.334131] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2883.354587] kworker/u16:3   D ffff88023fc13600     0 21786      2 0x00000000
[ 2883.374274] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[ 2883.393428]  ffff8801d450bbb0 0000000000000046 ffff8801d450bfd8 0000000000013600
[ 2883.413681]  ffff8801d450bfd8 0000000000013600 ffff8801f540a440 ffff88021c9473b0
[ 2883.433798]  ffff88023463a000 ffff8801d450bbd0 ffff8801c97868b8 ffff8801c9786928
[ 2883.453815] Call Trace:
[ 2883.468366]  [<ffffffff815de804>] schedule+0x24/0x70
[ 2883.485395]  [<ffffffff81285305>] btrfs_commit_transaction+0x265/0x960
[ 2883.503928]  [<ffffffff810741f0>] ? wake_up_atomic_t+0x30/0x30
[ 2883.521745]  [<ffffffff81292140>] btrfs_write_inode+0x70/0xb0
[ 2883.539623]  [<ffffffff811aa317>] __writeback_single_inode+0x167/0x220
[ 2883.558528]  [<ffffffff811aae5f>] writeback_sb_inodes+0x19f/0x400
[ 2883.577137]  [<ffffffff811ab273>] wb_writeback+0xe3/0x2b0
[ 2883.595184]  [<ffffffff8106efe1>] ? set_worker_desc+0x71/0x80
[ 2883.613730]  [<ffffffff811ace00>] bdi_writeback_workfn+0x100/0x3d0
[ 2883.632837]  [<ffffffff8106c0a8>] process_one_work+0x178/0x410
[ 2883.651553]  [<ffffffff8106ccb9>] worker_thread+0x119/0x3a0
[ 2883.669822]  [<ffffffff8106cba0>] ? rescuer_thread+0x360/0x360
[ 2883.688338]  [<ffffffff8107347b>] kthread+0xbb/0xc0
[ 2883.705761]  [<ffffffff810733c0>] ? kthread_create_on_node+0x110/0x110
[ 2883.724865]  [<ffffffff815e7efc>] ret_from_fork+0x7c/0xb0
[ 2883.742994]  [<ffffffff810733c0>] ? kthread_create_on_node+0x110/0x110

Tests were executed by mmtests using the
configs/config-global-dhp__reaim-stress-alltests as a baseline but with
the following parameters added to use a test partition

export TESTDISK_PARTITION=/dev/sda6
export TESTDISK_FILESYSTEM=btrfs
export TESTDISK_MKFS_PARAM="-f"
export TESTDISK_MOUNT_ARGS=

While it is apparently fixed at the moment, any distribution using btrfs
with 3.10-longterm or 3.11 may file bugs and nag about the general stability
of btrfs even though the issues are already resolved.  I note there are
a number of deadlock-related fixes merged for btrfs between 3.11 and
3.12. Are there plans to backport them?

-- 
Mel Gorman
SUSE Labs
