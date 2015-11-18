Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21484 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755183AbbKRHY4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:56 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSD007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 18/22] btrfs-progs: convert: Introduce new function to create ext2 image
Date: Wed, 18 Nov 2015 15:22:18 +0800
Message-Id: <1447831342-15056-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use new function, create_ext2_image_v2() to create ext2 image.

Unlike old function which is called after copying all inodes, this
function need to be called before copying inodes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h         |   1 +
 2 files changed, 154 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 4626bbd..18701b1 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1237,6 +1237,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 fail:
 	return ret;
 }
+
 /*
  * Create the ext2fs image file.
  */
@@ -1430,6 +1431,158 @@ fail:
 	return ret;
 }
 
+static int create_image_file_range_v2(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct cache_tree *used,
+				      struct btrfs_inode_item *inode,
+				      u64 ino, u64 bytenr, u64 *ret_len,
+				      int datacsum)
+{
+	struct cache_extent *cache;
+	struct btrfs_block_group_cache *bg_cache;
+	u64 len = *ret_len;
+	u64 disk_bytenr;
+	int ret;
+
+	BUG_ON(bytenr != round_down(bytenr, root->sectorsize));
+	BUG_ON(len != round_down(len, root->sectorsize));
+	len = min_t(u64, len, BTRFS_MAX_EXTENT_SIZE);
+
+	cache = search_cache_extent(used, bytenr);
+	if (cache) {
+		if (cache->start <= bytenr) {
+			/*
+			 * |///////Used///////|
+			 *	|<--insert--->|
+			 *	bytenr
+			 */
+			len = min_t(u64, len, cache->start + cache->size -
+				    bytenr);
+			disk_bytenr = bytenr;
+		} else {
+			/*
+			 *		|//Used//|
+			 *  |<-insert-->|
+			 *  bytenr
+			 */
+			len = min(len, cache->start - bytenr);
+			disk_bytenr = 0;
+			datacsum = 0;
+		}
+	} else {
+		/*
+		 * |//Used//|		|EOF
+		 * 	    |<-insert-->|
+		 * 	    bytenr
+		 */
+		disk_bytenr = 0;
+		datacsum = 0;
+	}
+
+	if (disk_bytenr) {
+		/* Check if the range is in a data block group */
+		bg_cache = btrfs_lookup_block_group(root->fs_info, bytenr);
+		if (!bg_cache)
+			return -ENOENT;
+		if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_DATA))
+			return -EINVAL;
+	
+		/* The extent should never cross block group boundary */
+		len = min_t(u64, len, bg_cache->key.objectid +
+			    bg_cache->key.offset - bytenr);
+	}
+
+	BUG_ON(len != round_down(len, root->sectorsize));
+	ret = btrfs_record_file_extent(trans, root, ino, inode, bytenr,
+				       disk_bytenr, len);
+	if (ret < 0)
+		return ret;
+
+	if (datacsum)
+		ret = csum_disk_extent(trans, root, bytenr, len);
+	*ret_len = len;
+	return ret;
+}
+
+static int create_ext2_image_v2(struct btrfs_root *root,
+				struct btrfs_mkfs_config *cfg, u64 size,
+				char *name, int datacsum)
+{
+	struct btrfs_inode_item buf;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	u64 cur;
+	u64 ino;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		return -ENOMEM;
+	ret = btrfs_find_free_objectid(trans, root, BTRFS_FIRST_FREE_OBJECTID,
+				       &ino);
+	if (ret < 0)
+		goto out;
+	ret = btrfs_new_inode(trans, root, ino, 0600 | S_IFREG);
+	if (ret < 0)
+		goto out;
+	ret = btrfs_add_link(trans, root, ino, BTRFS_FIRST_FREE_OBJECTID, name,
+			     strlen(name), BTRFS_FT_REG_FILE, NULL, 1);
+	if (ret < 0)
+		goto out;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret) {
+		ret = (ret > 0 ? -ENOENT : ret);
+		goto out;
+	}
+	read_extent_buffer(path->nodes[0], &buf,
+			btrfs_item_ptr_offset(path->nodes[0], path->slots[0]),
+			sizeof(buf));
+	btrfs_release_path(path);
+
+	/*
+	 * Skip the first 1M, it should be reserved and will be handled later
+	 */
+	cur = 1024 * 1024;
+	while (cur < size) {
+		u64 len = size - cur;
+
+		ret = create_image_file_range_v2(trans, root,
+				&cfg->convert_used, &buf, ino, cur, &len,
+				datacsum);
+		if (ret < 0)
+			goto out;
+		cur += len;
+	}
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret) {
+		ret = (ret > 0 ? -ENOENT : ret);
+		goto out;
+	}
+	btrfs_set_stack_inode_size(&buf, cfg->num_bytes);
+	write_extent_buffer(path->nodes[0], &buf,
+			btrfs_item_ptr_offset(path->nodes[0], path->slots[0]),
+			sizeof(buf));
+out:
+	btrfs_free_path(path);
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
 static struct btrfs_root * link_subvol(struct btrfs_root *root,
 		const char *base, u64 root_objectid)
 {
diff --git a/ctree.h b/ctree.h
index f97af7e..6e3e919 100644
--- a/ctree.h
+++ b/ctree.h
@@ -570,6 +570,7 @@ struct btrfs_extent_item_v0 {
 
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r) >> 4) - \
 					sizeof(struct btrfs_item))
+#define BTRFS_MAX_EXTENT_SIZE		(128 * 1024 * 1024)
 
 #define BTRFS_EXTENT_FLAG_DATA		(1ULL << 0)
 #define BTRFS_EXTENT_FLAG_TREE_BLOCK	(1ULL << 1)
-- 
2.6.2

