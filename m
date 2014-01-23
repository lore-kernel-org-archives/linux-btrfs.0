Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18955 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaAWGAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 01:00:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0N5n25v002329
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 13:49:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix protection between walking backrefs and root deletion
Date: Thu, 23 Jan 2014 13:47:48 +0800
Message-Id: <1390456069-5577-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a race condition between resolving indirect ref and root deletion,
and we should gurantee that root can not be destroyed to avoid accessing
broken tree here.

Here we fix it by holding @subvol_srcu, and we will release it as soon
as we have held root node lock.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 964679c..fd9ae72 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -299,23 +299,34 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 	int root_level;
 	int level = ref->level;
+	int index;
 
 	root_key.objectid = ref->root_id;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root_key.offset = (u64)-1;
+
+	index = srcu_read_lock(&fs_info->subvol_srcu);
+
 	root = btrfs_read_fs_root_no_name(fs_info, &root_key);
 	if (IS_ERR(root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
 		ret = PTR_ERR(root);
 		goto out;
 	}
 
 	root_level = btrfs_old_root_level(root, time_seq);
 
-	if (root_level + 1 == level)
+	if (root_level + 1 == level) {
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
 		goto out;
+	}
 
 	path->lowest_level = level;
 	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
+
+	/* root node has been locked, we can release @subvol_srcu safely here */
+	srcu_read_unlock(&fs_info->subvol_srcu, index);
+
 	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
 		 "%d for key (%llu %u %llu)\n",
 		 ref->root_id, level, ref->count, ret,
-- 
1.8.3.1

