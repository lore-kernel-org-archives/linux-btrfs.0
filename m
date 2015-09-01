Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbbIBHvZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 03:51:25 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t810XlIj023763
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 08:33:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 06/14] btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function
Date: Tue,  1 Sep 2015 08:31:46 +0800
Message-Id: <1441067515-21105-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new function will do all the hard work to reserve precious space
for a write.

The overall work flow will be the following.

File A already has some dirty pages:

0	4K	8K	12K	16K
|///////|	|///////|

And then, someone want to write some data into range [4K, 16K).
	|<------desired-------->|

Unlike the old and wrong implement, which reserve 12K, this function
will only reserve space for newly dirty part:
	|\\\\\\\|	|\\\\\\\|
Which only takes 8K reserve space, as other part has already allocated
their own reserve space.

So the final reserve map will be:
|///////////////////////////////|

This provides the basis to resolve the long existing qgroup limit bug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3948882..31ddc6d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2764,6 +2764,54 @@ insert:
 }
 
 /*
+ * TODO: to handle nocow case, like NODATACOW or write into prealloc space
+ * along with other mixed case.
+ * Like write 2M, first 1M can be nocowed, but next 1M is on hole and need COW.
+ */
+int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
+{
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	struct btrfs_root *root = binode->root;
+	struct btrfs_qgroup_data_rsv_map *reserve_map;
+	struct data_rsv_range *tmp = NULL;
+	struct ulist *insert_list;
+	int ret;
+
+	if (!root->fs_info->quota_enabled || !is_fstree(root->objectid) ||
+	    len == 0)
+		return 0;
+
+	if (!binode->qgroup_rsv_map) {
+		ret = btrfs_qgroup_init_data_rsv_map(inode);
+		if (ret < 0)
+			return ret;
+	}
+	reserve_map = binode->qgroup_rsv_map;
+	insert_list = ulist_alloc(GFP_NOFS);
+	if (!insert_list)
+		return -ENOMEM;
+	tmp = kzalloc(sizeof(*tmp), GFP_NOFS);
+	if (!tmp) {
+		ulist_free(insert_list);
+		return -ENOMEM;
+	}
+
+	spin_lock(&reserve_map->lock);
+	ret = reserve_data_range(root, reserve_map, tmp, insert_list, start,
+				 len);
+	if (ret < 0) {
+		kfree(tmp);
+		goto out;
+	}
+	if (ret == 0)
+		kfree(tmp);
+out:
+	spin_unlock(&reserve_map->lock);
+	ulist_free(insert_list);
+	return ret;
+}
+
+/*
  * Init data_rsv_map for a given inode.
  *
  * This is needed at write time as quota can be disabled and then enabled
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index c87b7dc..366b853 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -87,4 +87,5 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 /* for qgroup reserve */
 int btrfs_qgroup_init_data_rsv_map(struct inode *inode);
 void btrfs_qgroup_free_data_rsv_map(struct inode *inode);
+int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len);
 #endif /* __BTRFS_QGROUP__ */
-- 
2.5.0

