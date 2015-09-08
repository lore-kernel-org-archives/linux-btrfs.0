Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6973 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866AbbIHJKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 05:10:43 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t889AT3J009924
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 17:10:29 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/19] btrfs: qgroup: Introduce new functions to reserve/free metadata
Date: Tue, 8 Sep 2015 17:08:38 +0800
Message-ID: <1441703318-25733-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new functions btrfs_qgroup_reserve/free_meta() to reserve/free
metadata reserved space.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |  3 +++
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/qgroup.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h  |  4 ++++
 4 files changed, 48 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..ae86025 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1943,6 +1943,9 @@ struct btrfs_root {
 	int send_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshoted;
+
+	/* For qgroup metadata space reserve */
+	atomic_t qgroup_meta_rsv;
 };
 
 struct btrfs_ioctl_defrag_range_args {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0b658d0..704d212 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1259,6 +1259,7 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
 	atomic_set(&root->orphan_inodes, 0);
 	atomic_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshoted, 0);
+	atomic_set(&root->qgroup_meta_rsv, 0);
 	root->log_transid = 0;
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5a69a2d..b759e96 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3102,3 +3102,43 @@ void btrfs_qgroup_free_data_rsv_map(struct inode *inode)
 	kfree(dirty_map);
 	binode->qgroup_rsv_map = NULL;
 }
+
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes)
+{
+	int ret;
+
+	if (!root->fs_info->quota_enabled || !is_fstree(root->objectid) ||
+	    num_bytes == 0)
+		return 0;
+
+	BUG_ON(num_bytes != round_down(num_bytes, root->nodesize));
+	ret = btrfs_qgroup_reserve(root, num_bytes);
+	if (ret < 0)
+		return ret;
+	atomic_add(num_bytes, &root->qgroup_meta_rsv);
+	return ret;
+}
+
+void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
+{
+	int reserved;
+
+	if (!root->fs_info->quota_enabled || !is_fstree(root->objectid))
+		return;
+
+	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
+	if (reserved == 0)
+		return;
+	btrfs_qgroup_free(root, reserved);
+}
+
+void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
+{
+	if (!root->fs_info->quota_enabled || !is_fstree(root->objectid))
+		return;
+
+	BUG_ON(num_bytes != round_down(num_bytes, root->nodesize));
+	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
+	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
+	btrfs_qgroup_free(root, num_bytes);
+}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 49fa15e..2d507c8 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -96,4 +96,8 @@ void btrfs_qgroup_free_data_rsv_map(struct inode *inode);
 int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
+
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes);
+void btrfs_qgroup_free_meta_all(struct btrfs_root *root);
+void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes);
 #endif /* __BTRFS_QGROUP__ */
-- 
2.5.1

