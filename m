Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:54128 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932343AbbJICU7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:20:59 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992KCxq022965
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:20:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 08/23] btrfs: qgroup: Introduce function to release/free reserved data range
Date: Fri, 9 Oct 2015 10:18:34 +0800
Message-ID: <1444357115-32088-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce functions btrfs_qgroup_release/free_data() to release/free
reserved data range.

Release means, just remove the data range from data rsv map, but doesn't
free the reserved space.
This is for normal buffered write case, when data is written into disc
and its metadata is added into tree, its reserved space should still be
kept until commit_trans().
So in that case, we only release dirty range, but keep the reserved
space recorded some other place until commit_tran().

Free means not only remove data range, but also free reserved space.
This is used for case for cleanup.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Fix comment typo
  Update comment, to make it clear that the reserved space for any page
  cache will either be released(it goes to disk) or freed directly
  (truncated before reaching disk)
---
 fs/btrfs/qgroup.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.h |  2 ++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9934929..dbc0d06 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -85,7 +85,7 @@ struct btrfs_qgroup {
 
 	/*
 	 * temp variables for accounting operations
-	 * Refer to qgroup_shared_accouting() for details.
+	 * Refer to qgroup_shared_accounting() for details.
 	 */
 	u64 old_refcnt;
 	u64 new_refcnt;
@@ -2985,6 +2985,59 @@ next:
 	return 0;
 }
 
+static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
+				       int free_reserved)
+{
+	struct data_rsv_range *tmp;
+	struct btrfs_qgroup_data_rsv_map *map;
+	u64 reserved = 0;
+	int ret;
+
+	spin_lock(&BTRFS_I(inode)->qgroup_init_lock);
+	map = BTRFS_I(inode)->qgroup_rsv_map;
+	spin_unlock(&BTRFS_I(inode)->qgroup_init_lock);
+	if (!map)
+		return 0;
+
+	tmp = kmalloc(sizeof(*tmp), GFP_NOFS);
+	if (!tmp)
+		return -ENOMEM;
+	spin_lock(&map->lock);
+	ret = release_data_range(map, tmp, start, len, &reserved);
+	/* release_data_range() won't fail only check if memory is used */
+	if (ret == 0)
+		kfree(tmp);
+	if (free_reserved)
+		btrfs_qgroup_free(BTRFS_I(inode)->root, reserved);
+	spin_unlock(&map->lock);
+	return 0;
+}
+
+/*
+ * Free a reserved space range from its qgroup.
+ *
+ * Should be called when a delalloc page cache is going to be invalidated
+ * For a page cache, it will will be released (as it's written to disk) or
+ * freed directly (doesn't reach disk).
+ */
+int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len)
+{
+	return __btrfs_qgroup_release_data(inode, start, len, 1);
+}
+
+/*
+ * Release a reserved space range, but doesn't free it's qgroup reserved space
+ * The reserved space will still takes space until delayed refs is run.
+ * 
+ * As qgroup accouting happens at commit time, for data written to disk
+ * its reserved space should not be freed until commit.
+ * Or we may exceed the limit.
+ */
+int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len)
+{
+	return __btrfs_qgroup_release_data(inode, start, len, 0);
+}
+
 /*
  * Init data_rsv_map for a given inode.
  *
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 366b853..8e69dc1 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -88,4 +88,6 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 int btrfs_qgroup_init_data_rsv_map(struct inode *inode);
 void btrfs_qgroup_free_data_rsv_map(struct inode *inode);
 int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len);
+int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
+int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
 #endif /* __BTRFS_QGROUP__ */
-- 
2.6.1

