Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46666 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2L0JEC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:04:02 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR941lr013050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:04:02 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR940GH019592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:04:01 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR940ud019919
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:04:00 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] Btrfs: record first logical byte in memory
Date: Thu, 27 Dec 2012 17:01:23 +0800
Message-Id: <1356598884-22952-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This'd save us a rbtree search which may become expensive in large filesystem.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/extent-tree.c |   19 ++++++++++++++++++-
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d709c4d..c2f24a0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1250,6 +1250,7 @@ struct btrfs_fs_info {
 
 	/* block group cache stuff */
 	spinlock_t block_group_cache_lock;
+	u64 first_logical_byte;
 	struct rb_root block_group_cache_tree;
 
 	/* keep track of unallocated space */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8f652d..456b80f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2126,6 +2126,7 @@ int open_ctree(struct super_block *sb,
 
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree = RB_ROOT;
+	fs_info->first_logical_byte = (u64)-1;
 
 	extent_io_tree_init(&fs_info->freed_extents[0],
 			     fs_info->btree_inode->i_mapping);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7a87e19..60d5081 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -161,6 +161,10 @@ static int btrfs_add_block_group_cache(struct btrfs_fs_info *info,
 	rb_link_node(&block_group->cache_node, parent, p);
 	rb_insert_color(&block_group->cache_node,
 			&info->block_group_cache_tree);
+
+	if (info->first_logical_byte > block_group->key.objectid)
+		info->first_logical_byte = block_group->key.objectid;
+
 	spin_unlock(&info->block_group_cache_lock);
 
 	return 0;
@@ -202,8 +206,11 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
 			break;
 		}
 	}
-	if (ret)
+	if (ret) {
 		btrfs_get_block_group(ret);
+		if (bytenr == 0 && info->first_logical_byte > ret->key.objectid)
+			info->first_logical_byte = ret->key.objectid;
+	}
 	spin_unlock(&info->block_group_cache_lock);
 
 	return ret;
@@ -4815,6 +4822,13 @@ static u64 first_logical_byte(struct btrfs_root *root, u64 search_start)
 	struct btrfs_block_group_cache *cache;
 	u64 bytenr;
 
+	spin_lock(&root->fs_info->block_group_cache_lock);
+	bytenr = root->fs_info->first_logical_byte;
+	spin_unlock(&root->fs_info->block_group_cache_lock);
+
+	if (bytenr < (u64)-1)
+		return bytenr;
+
 	cache = btrfs_lookup_first_block_group(root->fs_info, search_start);
 	if (!cache)
 		return 0;
@@ -8024,6 +8038,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
+
+	if (root->fs_info->first_logical_byte == block_group->key.objectid)
+		root->fs_info->first_logical_byte = (u64)-1;
 	spin_unlock(&root->fs_info->block_group_cache_lock);
 
 	down_write(&block_group->space_info->groups_sem);
-- 
1.7.7.6

