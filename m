Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754018AbdHYHXm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 03:23:42 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id D12274727AA8
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 15:23:37 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Make the process of create root tree to a function
Date: Fri, 25 Aug 2017 15:23:36 +0800
Message-ID: <1503645816-3450-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make_btrfs is too long to understand, make creatation of root tree
in a function.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 mkfs/common.c | 136 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 64 insertions(+), 72 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index 7d482c2..78297fa 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -34,6 +34,68 @@ static u64 reference_root_table[] = {
 	[6] =	BTRFS_CSUM_TREE_OBJECTID,
 };
 
+static int btrfs_create_root_tree(int fd, struct btrfs_mkfs_config *cfg,
+			struct extent_buffer *buf)
+{
+	struct btrfs_root_item root_item;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_disk_key disk_key;
+	u32 nritems = 0;
+	u32 itemoff = 0;
+	int ret = 0;
+	int blk = 0;
+
+	memset(buf->data + sizeof(struct btrfs_header), 0,
+		cfg->nodesize - sizeof(struct btrfs_header));
+	memset(&root_item, 0, sizeof(root_item));
+	memset(&disk_key, 0, sizeof(disk_key));
+
+	/* create the items for the root tree */
+	inode_item = &root_item.inode;
+	btrfs_set_stack_inode_generation(inode_item, 1);
+	btrfs_set_stack_inode_size(inode_item, 3);
+	btrfs_set_stack_inode_nlink(inode_item, 1);
+	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
+	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
+	btrfs_set_root_refs(&root_item, 1);
+	btrfs_set_root_used(&root_item, cfg->nodesize);
+	btrfs_set_root_generation(&root_item, 1);
+
+	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
+	btrfs_set_disk_key_offset(&disk_key, 0);
+	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) - sizeof(root_item);
+
+	for (blk = 0; blk < MKFS_BLOCK_COUNT; blk++) {
+		if (blk == MKFS_SUPER_BLOCK
+			|| blk == MKFS_ROOT_TREE
+			|| blk == MKFS_CHUNK_TREE)
+			continue;
+
+		btrfs_set_root_bytenr(&root_item, cfg->blocks[blk]);
+		btrfs_set_disk_key_objectid(&disk_key,
+			reference_root_table[blk]);
+		btrfs_set_item_key(buf, &disk_key, nritems);
+		btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+		btrfs_set_item_size(buf, btrfs_item_nr(nritems),
+				sizeof(root_item));
+		write_extent_buffer(buf, &root_item,
+			btrfs_item_ptr_offset(buf, nritems),
+			sizeof(root_item));
+		nritems++;
+		itemoff = itemoff - sizeof(root_item);
+	}
+
+	/* generate checksum */
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+
+	/* write back root tree */
+	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_ROOT_TREE]);
+	if (ret != cfg->nodesize)
+		return (ret < 0 ? -errno : -EIO);
+
+	return ret;
+}
+
 /*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  *
@@ -44,10 +106,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 {
 	struct btrfs_super_block super;
 	struct extent_buffer *buf;
-	struct btrfs_root_item root_item;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_extent_item *extent_item;
-	struct btrfs_inode_item *inode_item;
 	struct btrfs_chunk *chunk;
 	struct btrfs_dev_item *dev_item;
 	struct btrfs_dev_extent *dev_extent;
@@ -133,77 +193,9 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 			    btrfs_header_chunk_tree_uuid(buf),
 			    BTRFS_UUID_SIZE);
 
-	/* create the items for the root tree */
-	memset(&root_item, 0, sizeof(root_item));
-	inode_item = &root_item.inode;
-	btrfs_set_stack_inode_generation(inode_item, 1);
-	btrfs_set_stack_inode_size(inode_item, 3);
-	btrfs_set_stack_inode_nlink(inode_item, 1);
-	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
-	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
-	btrfs_set_root_refs(&root_item, 1);
-	btrfs_set_root_used(&root_item, cfg->nodesize);
-	btrfs_set_root_generation(&root_item, 1);
-
-	memset(&disk_key, 0, sizeof(disk_key));
-	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
-	btrfs_set_disk_key_offset(&disk_key, 0);
-	nritems = 0;
-
-	itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize) - sizeof(root_item);
-	btrfs_set_root_bytenr(&root_item, cfg->blocks[MKFS_EXTENT_TREE]);
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
-			    sizeof(root_item));
-	write_extent_buffer(buf, &root_item, btrfs_item_ptr_offset(buf,
-			    nritems), sizeof(root_item));
-	nritems++;
-
-	itemoff = itemoff - sizeof(root_item);
-	btrfs_set_root_bytenr(&root_item, cfg->blocks[MKFS_DEV_TREE]);
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_TREE_OBJECTID);
-	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
-			    sizeof(root_item));
-	write_extent_buffer(buf, &root_item,
-			    btrfs_item_ptr_offset(buf, nritems),
-			    sizeof(root_item));
-	nritems++;
-
-	itemoff = itemoff - sizeof(root_item);
-	btrfs_set_root_bytenr(&root_item, cfg->blocks[MKFS_FS_TREE]);
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FS_TREE_OBJECTID);
-	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
-			    sizeof(root_item));
-	write_extent_buffer(buf, &root_item,
-			    btrfs_item_ptr_offset(buf, nritems),
-			    sizeof(root_item));
-	nritems++;
-
-	itemoff = itemoff - sizeof(root_item);
-	btrfs_set_root_bytenr(&root_item, cfg->blocks[MKFS_CSUM_TREE]);
-	btrfs_set_disk_key_objectid(&disk_key, BTRFS_CSUM_TREE_OBJECTID);
-	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
-			    sizeof(root_item));
-	write_extent_buffer(buf, &root_item,
-			    btrfs_item_ptr_offset(buf, nritems),
-			    sizeof(root_item));
-	nritems++;
-
-
-	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_ROOT_TREE]);
-	if (ret != cfg->nodesize) {
-		ret = (ret < 0 ? -errno : -EIO);
+	ret = btrfs_create_root_tree(fd, cfg, buf);
+	if (ret < 0)
 		goto out;
-	}
 
 	/* create the items for the extent tree */
 	memset(buf->data + sizeof(struct btrfs_header), 0,
-- 
1.9.1



