Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17807 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751422AbdCMHwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:52:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EC5ED48A294B
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:52:45 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/9] btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount option
Date: Mon, 13 Mar 2017 15:52:10 +0800
Message-ID: <20170313075216.5125-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 fs/btrfs/transaction.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 61b807de3e16..894c4980c15c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2130,13 +2130,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	/* Reocrd old roots for later qgroup accounting */
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret) {
-		mutex_unlock(&fs_info->reloc_mutex);
-		goto scrub_continue;
-	}
-
 	/*
 	 * make sure none of the code above managed to slip in a
 	 * delayed item
@@ -2179,6 +2172,24 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_free_log_root_tree(trans, fs_info);
 
 	/*
+	 * commit_fs_roots() can call btrfs_save_ino_cache(), which generates
+	 * new delayed refs. Must handle them or qgroup can be wrong.
+	 */
+	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	if (ret) {
+		mutex_unlock(&fs_info->tree_log_mutex);
+		mutex_unlock(&fs_info->reloc_mutex);
+		goto scrub_continue;
+	}
+
+	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
+	if (ret) {
+		mutex_unlock(&fs_info->tree_log_mutex);
+		mutex_unlock(&fs_info->reloc_mutex);
+		goto scrub_continue;
+	}
+
+	/*
 	 * Since fs roots are all committed, we can get a quite accurate
 	 * new_roots. So let's do quota accounting.
 	 */
-- 
2.12.0



