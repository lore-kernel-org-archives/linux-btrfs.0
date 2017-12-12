Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44434 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdLLHfF (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:35:05 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 14/14] Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"
Date: Tue, 12 Dec 2017 15:34:36 +0800
Message-Id: <20171212073436.16447-15-wqu@suse.com>
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
References: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 48a89bc4f2ceab87bc858a8eb189636b09c846a7.

The idea to commit transaction and free some space after hitting qgroup
limit is good, although the problem is it will easily cause deadlocks.

One deadlock example is caused by trying to flush data while still
holding it:
Call Trace:
 __schedule+0x49d/0x10f0
 schedule+0xc6/0x290
 schedule_timeout+0x187/0x1c0
 wait_for_completion+0x204/0x3a0
 btrfs_wait_ordered_extents+0xa40/0xaf0 [btrfs]
 qgroup_reserve+0x913/0xa10 [btrfs]
 btrfs_qgroup_reserve_data+0x3ef/0x580 [btrfs]
 btrfs_check_data_free_space+0x96/0xd0 [btrfs]
 __btrfs_buffered_write+0x3ac/0xd40 [btrfs]
 btrfs_file_write_iter+0x62a/0xba0 [btrfs]
 __vfs_write+0x320/0x430
 vfs_write+0x107/0x270
 SyS_write+0xbf/0x150
 do_syscall_64+0x1b0/0x3d0
 entry_SYSCALL64_slow_path+0x25/0x25

Another case can be caused by trying to commit one transaction while
nesting with trans handler hold by ourselves:
btrfs_start_transaction()
|- btrfs_qgroup_reserve_meta_pertrans()
   |- qgroup_reserve()
      |- btrfs_join_transaction()
      |- btrfs_commit_transaction()

The retry is causing more problem than expectation when limit is
enabled.
At least graceful EDQUOT is way better than kernel deadlock.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ee5b05dd10a9..02effd919452 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2416,7 +2416,6 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
-	int retried = 0;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 
@@ -2457,27 +2456,6 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 		qg = unode_aux_to_qgroup(unode);
 
 		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
-			/*
-			 * Commit the tree and retry, since we may have
-			 * deletions which would free up space.
-			 */
-			if (!retried && qgroup_rsv_total(qg) > 0) {
-				struct btrfs_trans_handle *trans;
-
-				spin_unlock(&fs_info->qgroup_lock);
-				ret = btrfs_start_delalloc_inodes(root, 0);
-				if (ret)
-					return ret;
-				btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
-				trans = btrfs_join_transaction(root);
-				if (IS_ERR(trans))
-					return PTR_ERR(trans);
-				ret = btrfs_commit_transaction(trans);
-				if (ret)
-					return ret;
-				retried++;
-				goto retry;
-			}
 			ret = -EDQUOT;
 			goto out;
 		}
-- 
2.15.1

