Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbcAFLCV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 06:02:21 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 1254941890FD
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2016 19:02:02 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: merge functions for wait snapshot creation
Date: Wed, 6 Jan 2016 19:00:19 +0800
Message-ID: <167af3bb5cddb73607e9012a809144d74662e998.1452078012.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
References: <9b89157957abcc87a6ea0530989a4984794484cd.1452078012.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

wait_for_snapshot_creation() is in same group with oher two:
 btrfs_start_write_no_snapshoting()
 btrfs_end_write_no_snapshoting()

Rename wait_for_snapshot_creation() and move it into same place
with other two.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c | 20 ++++++++++++++++++++
 fs/btrfs/inode.c       | 22 +---------------------
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0912f89..5d7a2c4d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3566,6 +3566,7 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 int __get_raid_index(u64 flags);
 int btrfs_start_write_no_snapshoting(struct btrfs_root *root);
 void btrfs_end_write_no_snapshoting(struct btrfs_root *root);
+void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
 void check_system_chunk(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			const u64 type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dc3763a..e83ffa8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10704,3 +10704,23 @@ int btrfs_start_write_no_snapshoting(struct btrfs_root *root)
 	}
 	return 1;
 }
+
+static int wait_snapshoting_atomic_t(atomic_t *a)
+{
+	schedule();
+	return 0;
+}
+
+void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
+{
+	while (true) {
+		int ret;
+
+		ret = btrfs_start_write_no_snapshoting(root);
+		if (ret)
+			break;
+		wait_on_atomic_t(&root->will_be_snapshoted,
+				 wait_snapshoting_atomic_t,
+				 TASK_UNINTERRUPTIBLE);
+	}
+}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 994490d..21d7cd1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4897,26 +4897,6 @@ next:
 	return err;
 }
 
-static int wait_snapshoting_atomic_t(atomic_t *a)
-{
-	schedule();
-	return 0;
-}
-
-static void wait_for_snapshot_creation(struct btrfs_root *root)
-{
-	while (true) {
-		int ret;
-
-		ret = btrfs_start_write_no_snapshoting(root);
-		if (ret)
-			break;
-		wait_on_atomic_t(&root->will_be_snapshoted,
-				 wait_snapshoting_atomic_t,
-				 TASK_UNINTERRUPTIBLE);
-	}
-}
-
 static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -4948,7 +4928,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		 * truncation, it must capture all writes that happened before
 		 * this truncation.
 		 */
-		wait_for_snapshot_creation(root);
+		btrfs_wait_for_snapshot_creation(root);
 		ret = btrfs_cont_expand(inode, oldsize, newsize);
 		if (ret) {
 			btrfs_end_write_no_snapshoting(root);
-- 
1.8.5.1



