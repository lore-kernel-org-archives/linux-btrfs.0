Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbcF2FQv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 01:16:51 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id 228644056401
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 13:16:46 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix fsfreeze hang caused by delayed iputs deal
Date: Wed, 29 Jun 2016 13:15:10 +0800
Message-Id: <20160629051510.17222-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running fstests generic/068, sometimes we got below WARNING:
  xfs_io          D ffff8800331dbb20     0  6697   6693 0x00000080
  ffff8800331dbb20 ffff88007acfc140 ffff880034d895c0 ffff8800331dc000
  ffff880032d243e8 fffffffeffffffff ffff880032d24400 0000000000000001
  ffff8800331dbb38 ffffffff816a9045 ffff880034d895c0 ffff8800331dbba8
  Call Trace:
  [<ffffffff816a9045>] schedule+0x35/0x80
  [<ffffffff816abab2>] rwsem_down_read_failed+0xf2/0x140
  [<ffffffff8118f5e1>] ? __filemap_fdatawrite_range+0xd1/0x100
  [<ffffffff8134f978>] call_rwsem_down_read_failed+0x18/0x30
  [<ffffffffa06631fc>] ? btrfs_alloc_block_rsv+0x2c/0xb0 [btrfs]
  [<ffffffff810d32b5>] percpu_down_read+0x35/0x50
  [<ffffffff81217dfc>] __sb_start_write+0x2c/0x40
  [<ffffffffa067f5d5>] start_transaction+0x2a5/0x4d0 [btrfs]
  [<ffffffffa067f857>] btrfs_join_transaction+0x17/0x20 [btrfs]
  [<ffffffffa068ba34>] btrfs_evict_inode+0x3c4/0x5d0 [btrfs]
  [<ffffffff81230a1a>] evict+0xba/0x1a0
  [<ffffffff812316b6>] iput+0x196/0x200
  [<ffffffffa06851d0>] btrfs_run_delayed_iputs+0x70/0xc0 [btrfs]
  [<ffffffffa067f1d8>] btrfs_commit_transaction+0x928/0xa80 [btrfs]
  [<ffffffffa0646df0>] btrfs_freeze+0x30/0x40 [btrfs]
  [<ffffffff81218040>] freeze_super+0xf0/0x190
  [<ffffffff81229275>] do_vfs_ioctl+0x4a5/0x5c0
  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
  [<ffffffff810038cf>] ? syscall_trace_enter_phase1+0x11f/0x140
  [<ffffffff81229409>] SyS_ioctl+0x79/0x90
  [<ffffffff81003c12>] do_syscall_64+0x62/0x110
  [<ffffffff816acbe1>] entry_SYSCALL64_slow_path+0x25/0x25

>From this warning, freeze_super() already holds SB_FREEZE_FS, but
btrfs_freeze() will call btrfs_commit_transaction() again, if
btrfs_commit_transaction() finds that it has delayed iputs to handle,
it'll start_transaction(), which will try to get SB_FREEZE_FS lock
again, then deadlock occurs.

The root cause is that in btrfs, sync_filesystem(sb) does not make
sure all metadata is updated. See below race window in freeze_super():
	sync_filesystem(sb);
		|
		| race window
		| In this period, cleaner_kthread() may be scheduled to
		| run, and it call btrfs_delete_unused_bgs() which will
		| add some delayed iputs.
		|
	sb->s_writers.frozen = SB_FREEZE_FS;
	sb_wait_write(sb, SB_FREEZE_FS);
	if (sb->s_op->freeze_fs) {
		/* freeze_fs will call btrfs_commit_transaction() */
		ret = sb->s_op->freeze_fs(sb);

So if btrfs is doing freeze job, we should block
btrfs_delete_unused_bgs(), to avoid add delayed iputs.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 863bf7a..fdbe0df 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1846,8 +1846,11 @@ static int cleaner_kthread(void *arg)
 		 * after acquiring fs_info->delete_unused_bgs_mutex. So we
 		 * can't hold, nor need to, fs_info->cleaner_mutex when deleting
 		 * unused block groups.
+		 *
 		 */
+		__sb_start_write(root->fs_info->sb, SB_FREEZE_WRITE, true);
 		btrfs_delete_unused_bgs(root->fs_info);
+		__sb_end_write(root->fs_info->sb, SB_FREEZE_WRITE);
 sleep:
 		if (!again) {
 			set_current_state(TASK_INTERRUPTIBLE);
-- 
2.9.0



