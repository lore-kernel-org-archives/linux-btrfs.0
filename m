Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23505 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754874AbbKRHYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:53 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoS9007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 14/22] btrfs-progs: Introduce function to setup temporary extent tree
Date: Wed, 18 Nov 2015 15:22:14 +0800
Message-Id: <1447831342-15056-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temporary_extent_tree() to build a
temporary extent tree for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 198 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 197 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index ee2a538..f5fadb1 100644
--- a/utils.c
+++ b/utils.c
@@ -885,6 +885,194 @@ out:
 }
 
 /*
+ * Insert one temporary extent item.
+ *
+ * NOTE: if skinny_metadata is not enabled, this function must be called
+ * after all other trees are initialized.
+ * Or fs without skinny-metadata will be screwed up.
+ */
+static int insert_temp_extent_item(int fd, struct extent_buffer *buf,
+				   struct btrfs_mkfs_config *cfg,
+				   int *slot, u32 *itemoff, u64 bytenr,
+				   u64 ref_root)
+{
+	struct extent_buffer *tmp;
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_disk_key tree_info_key;
+	struct btrfs_tree_block_info *info;
+	int itemsize;
+	int skinny_metadata = cfg->features &
+			      BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA;
+	int ret;
+
+	if (skinny_metadata)
+		itemsize = sizeof(*ei) + sizeof(*iref);
+	else
+		itemsize = sizeof(*ei) + sizeof(*iref) +
+			   sizeof(struct btrfs_tree_block_info);
+ 
+	btrfs_set_header_nritems(buf, *slot + 1);
+	*(itemoff) -= itemsize;
+
+	if (skinny_metadata) {
+		btrfs_set_disk_key_type(&disk_key, BTRFS_METADATA_ITEM_KEY);
+		btrfs_set_disk_key_offset(&disk_key, 0);
+	} else {
+		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
+		btrfs_set_disk_key_offset(&disk_key, cfg->nodesize);
+	}
+	btrfs_set_disk_key_objectid(&disk_key, bytenr);
+
+	btrfs_set_item_key(buf, &disk_key, *slot);
+	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(*slot), itemsize);
+
+	ei = btrfs_item_ptr(buf, *slot, struct btrfs_extent_item);
+	btrfs_set_extent_refs(buf, ei, 1);
+	btrfs_set_extent_generation(buf, ei, 1);
+	btrfs_set_extent_flags(buf, ei, BTRFS_EXTENT_FLAG_TREE_BLOCK);
+
+	if (skinny_metadata) {
+		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	} else {
+		info = (struct btrfs_tree_block_info *)(ei + 1);
+		iref = (struct btrfs_extent_inline_ref *)(info + 1);
+	}
+	btrfs_set_extent_inline_ref_type(buf, iref,
+					 BTRFS_TREE_BLOCK_REF_KEY);
+	btrfs_set_extent_inline_ref_offset(buf, iref, ref_root);
+
+	(*slot)++;
+	if (skinny_metadata)
+		return 0;
+
+	/*
+	 * Lastly, check the tree block key by read the tree block
+	 * Since we do 1:1 mapping for convert case, we can directly
+	 * read the bytenr from disk
+	 */
+	tmp = malloc(sizeof(*tmp) + cfg->nodesize);
+	if (!tmp)
+		return -ENOMEM;
+	ret = setup_temp_extent_buffer(tmp, cfg, bytenr, ref_root);
+	if (ret < 0)
+		goto out;
+	ret = pread(fd, tmp->data, cfg->nodesize, bytenr);
+	if (ret < cfg->nodesize) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
+	if (btrfs_header_nritems(tmp) == 0) {
+		btrfs_set_disk_key_type(&tree_info_key, 0);
+		btrfs_set_disk_key_objectid(&tree_info_key, 0);
+		btrfs_set_disk_key_offset(&tree_info_key, 0);
+	} else {
+		btrfs_item_key(tmp, &tree_info_key, 0);
+	}
+	btrfs_set_tree_block_key(buf, info, &tree_info_key);
+
+out:
+	free(tmp);
+	return ret;
+}
+
+static void insert_temp_block_group(struct extent_buffer *buf,
+				   struct btrfs_mkfs_config *cfg,
+				   int *slot, u32 *itemoff,
+				   u64 bytenr, u64 len, u64 used, u64 flag)
+{
+	struct btrfs_block_group_item bgi;
+	struct btrfs_disk_key disk_key;
+
+	btrfs_set_header_nritems(buf, *slot + 1);
+	(*itemoff) -= sizeof(bgi);
+	btrfs_set_disk_key_type(&disk_key, BTRFS_BLOCK_GROUP_ITEM_KEY);
+	btrfs_set_disk_key_objectid(&disk_key, bytenr);
+	btrfs_set_disk_key_offset(&disk_key, len);
+	btrfs_set_item_key(buf, &disk_key, *slot);
+	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(bgi));
+
+	btrfs_set_block_group_flags(&bgi, flag);
+	btrfs_set_block_group_used(&bgi, used);
+	btrfs_set_block_group_chunk_objectid(&bgi,
+			BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	write_extent_buffer(buf, &bgi, btrfs_item_ptr_offset(buf, *slot),
+			    sizeof(bgi));
+	(*slot)++;
+}
+
+static int setup_temp_extent_tree(int fd, struct btrfs_mkfs_config *cfg,
+				  u64 chunk_bytenr, u64 root_bytenr,
+				  u64 extent_bytenr, u64 dev_bytenr,
+				  u64 fs_bytenr, u64 csum_bytenr)
+{
+	struct extent_buffer *buf = NULL;
+	u32 itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize);
+	int slot = 0;
+	int ret;
+
+	/*
+	 * We must ensure provided bytenr are in ascending order,
+	 * or extent tree key order will be broken.
+	 */
+	BUG_ON(!(chunk_bytenr < root_bytenr && root_bytenr < extent_bytenr &&
+		 extent_bytenr < dev_bytenr && dev_bytenr < fs_bytenr &&
+		 fs_bytenr < csum_bytenr));
+	buf = malloc(sizeof(*buf) + cfg->nodesize);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = setup_temp_extent_buffer(buf, cfg, extent_bytenr,
+				       BTRFS_EXTENT_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+
+	ret = insert_temp_extent_item(fd, buf, cfg, &slot, &itemoff,
+			chunk_bytenr, BTRFS_CHUNK_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+
+	insert_temp_block_group(buf, cfg, &slot, &itemoff, chunk_bytenr,
+			BTRFS_MKFS_SYSTEM_GROUP_SIZE, cfg->nodesize,
+			BTRFS_BLOCK_GROUP_SYSTEM);
+
+	ret = insert_temp_extent_item(fd, buf, cfg, &slot, &itemoff,
+			root_bytenr, BTRFS_ROOT_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+
+	/* 5 tree block used, root, extent, dev, fs and csum*/
+	insert_temp_block_group(buf, cfg, &slot, &itemoff, root_bytenr,
+			BTRFS_CONVERT_META_GROUP_SIZE, cfg->nodesize * 5,
+			BTRFS_BLOCK_GROUP_METADATA);
+
+	ret = insert_temp_extent_item(fd, buf, cfg, &slot, &itemoff,
+			extent_bytenr, BTRFS_EXTENT_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+	ret = insert_temp_extent_item(fd, buf, cfg, &slot, &itemoff,
+			dev_bytenr, BTRFS_DEV_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+	ret = insert_temp_extent_item(fd, buf, cfg, &slot, &itemoff,
+			fs_bytenr, BTRFS_FS_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+	ret = insert_temp_extent_item(fd, buf, cfg, &slot, &itemoff,
+			csum_bytenr, BTRFS_CSUM_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+
+	ret = write_temp_extent_buffer(fd, buf, extent_bytenr);
+out:
+	free(buf);
+	return ret;
+}
+
+/*
  * Improved version of make_btrfs().
  *
  * This one will not use bad behaved cfg->blocks[] array to arrange tree
@@ -984,7 +1172,15 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 	if (ret < 0)
 		goto out;
 	ret = setup_temp_csum_tree(fd, cfg, csum_bytenr);
-
+	if (ret < 0)
+		goto out;
+	/*
+	 * Setup extent tree lastly, since it may need to read tree block key
+	 * for non-skinny metadata case.
+	 */
+	ret = setup_temp_extent_tree(fd, cfg, chunk_bytenr, root_bytenr,
+				     extent_bytenr, dev_bytenr, fs_bytenr,
+				     csum_bytenr);
 out:
 	free(free_tree);
 	return ret;
-- 
2.6.2

