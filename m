Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64409 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755351AbbIAIrc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 04:47:32 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t818lLbK027297
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 16:47:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 08/14] btrfs: qgroup: Introduce function to release/free reserved data range
Date: Tue, 1 Sep 2015 16:45:25 +0800
Message-ID: <1441097125-2773-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441097125-2773-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1441097125-2773-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce functions btrfs_qgroup_release/free_data() to release/free
reserved data range.

Release means, just remove the data range from data rsv map, but doesn't
free the reserved space.
Free means not only remove data range, but also free reserved space.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index eee07c2..7ccbd4c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2941,6 +2941,52 @@ next:
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
+	ret = release_data_range(map, tmp, start, len, &reserved);
+	/* release_data_range() won't fail only check if memory is used */
+	if (ret == 0)
+		kfree(tmp);
+	if (free_reserved)
+		btrfs_qgroup_free(BTRFS_I(inode)->root, reserved);
+	return 0;
+}
+
+/*
+ * Caller should be truncate/invalidate_page.
+ * As it will release the reserved data.
+ */
+int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len)
+{
+	return __btrfs_qgroup_release_data(inode, start, len, 1);
+}
+
+/*
+ * Caller should be finish_ordered_io
+ * As qgroup accouting happens at commit time, for data written to disk
+ * its reserved space should not be freed until commit.
+ * Or we may beyond the limit.
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
2.5.1

