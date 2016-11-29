Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56327 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753016AbcK2Env (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 23:43:51 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id DAF8741B4BDF
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 12:42:56 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount option
Date: Tue, 29 Nov 2016 12:42:39 +0800
Message-Id: <20161129044241.27407-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
References: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
The easist way to reproduce the bug is:
------
 # mkfs.btrfs -f $dev -n 16K
 # mount $dev $mnt -o inode_cache
 # btrfs quota enable $mnt
 # btrfs quota rescan -w $mnt
 # btrfs qgroup show $mnt
qgroupid         rfer         excl
--------         ----         ----
0/5          32.00KiB     32.00KiB
             ^^ Twice the correct value
------

And fstests/btrfs qgroup test group can easily detect them with
inode_cache mount option.
Although some of them are false alerts since old test cases are using
fixed golden output.
While new test cases will use "btrfs check" to detect qgroup mismatch.

[CAUSE]
Inode_cache mount option will make commit_fs_roots() to call
btrfs_save_ino_cache() to update fs/subvol trees, and generate new
delayed refs.

However we call btrfs_qgroup_prepare_account_extents() too early, before
commit_fs_roots().
This makes the "old_roots" for newly generated extents are always NULL.
For freeing extent case, this makes both new_roots and old_roots to be
empty, while correct old_roots should not be empty.
This causing qgroup numbers not decreased correctly.

[FIX]
Modify the timing of calling btrfs_qgroup_prepare_account_extents() to
just before btrfs_qgroup_account_extents(), and add needed delayed_refs
handler.
So qgroup can handle inode_map mount options correctly.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e66a18e..f65659b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2102,13 +2102,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto scrub_continue;
 	}
 
-	/* Reocrd old roots for later qgroup accounting */
-	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
-	if (ret) {
-		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto scrub_continue;
-	}
-
 	/*
 	 * make sure none of the code above managed to slip in a
 	 * delayed item
@@ -2151,6 +2144,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_free_log_root_tree(trans, root->fs_info);
 
 	/*
+	 * commit_fs_roots() can call btrfs_save_ino_cache(), which generates
+	 * new delayed refs. Must handle them or qgroup can be wrong.
+	 */
+	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+	if (ret) {
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto scrub_continue;
+	}
+
+	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
+	if (ret) {
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto scrub_continue;
+	}
+
+	/*
 	 * Since fs roots are all committed, we can get a quite accurate
 	 * new_roots. So let's do quota accounting.
 	 */
-- 
2.10.2



