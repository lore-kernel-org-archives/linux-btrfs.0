Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbcA2FRN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:17:13 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 06/22] btrfs-progs: Introduce function to setup temporary tree root
Date: Fri, 29 Jan 2016 13:03:16 +0800
Message-Id: <1454043812-7893-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_tree_root(), to initialize temporary
tree root for make_btrfs_v2().

The new function will setup tree root at metadata chunk and ensure data
won't be written into metadata chunk.

Also, new make_btrfs_v2() will have a much better code structure than
old make_btrfs().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 utils.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)

diff --git a/utils.c b/utils.c
index ed5476d..0b5df7e 100644
--- a/utils.c
+++ b/utils.c
@@ -305,6 +305,136 @@ out:
 }
 
 /*
+ * Setup an extent buffer for tree block.
+ */
+static int setup_temp_extent_buffer(struct extent_buffer *buf,
+				    struct btrfs_mkfs_config *cfg,
+				    u64 bytenr, u64 owner)
+{
+	unsigned char fsid[BTRFS_FSID_SIZE];
+	unsigned char chunk_uuid[BTRFS_UUID_SIZE];
+	int ret;
+
+	/* We rely on cfg->fs_uuid and chunk_uuid to fsid and chunk uuid */
+	BUG_ON(!cfg->fs_uuid || !cfg->chunk_uuid);
+	ret = uuid_parse(cfg->fs_uuid, fsid);
+	if (ret)
+		return -EINVAL;
+	ret = uuid_parse(cfg->chunk_uuid, chunk_uuid);
+	if (ret)
+		return -EINVAL;
+
+	memset(buf->data, 0, cfg->nodesize);
+	buf->len = cfg->nodesize;
+	btrfs_set_header_bytenr(buf, bytenr);
+	btrfs_set_header_generation(buf, 1);
+	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
+	btrfs_set_header_owner(buf, owner);
+	btrfs_set_header_flags(buf, BTRFS_HEADER_FLAG_WRITTEN);
+	write_extent_buffer(buf, chunk_uuid, btrfs_header_chunk_tree_uuid(buf),
+			    BTRFS_UUID_SIZE);
+	write_extent_buffer(buf, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
+	return 0;
+}
+
+static inline int write_temp_extent_buffer(int fd, struct extent_buffer *buf,
+					   u64 bytenr)
+{
+	int ret;
+
+	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
+
+	/* Temporary extent buffer is always mapped 1:1 on disk */
+	ret = pwrite(fd, buf->data, buf->len, bytenr);
+	if (ret < buf->len)
+		ret = (ret < 0 ? ret : -EIO);
+	else
+		ret = 0;
+	return ret;
+}
+
+/*
+ * Insert a root item for temporary tree root
+ *
+ * Only used in make_btrfs_v2().
+ */
+static void insert_temp_root_item(struct extent_buffer *buf,
+				  struct btrfs_mkfs_config *cfg,
+				  int *slot, u32 *itemoff, u64 objectid,
+				  u64 bytenr)
+{
+	struct btrfs_root_item root_item;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_disk_key disk_key;
+
+	btrfs_set_header_nritems(buf, *slot + 1);
+	(*itemoff) -= sizeof(root_item);
+	memset(&root_item, 0, sizeof(root_item));
+	inode_item = &root_item.inode;
+	btrfs_set_stack_inode_generation(inode_item, 1);
+	btrfs_set_stack_inode_size(inode_item, 3);
+	btrfs_set_stack_inode_nlink(inode_item, 1);
+	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
+	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
+	btrfs_set_root_refs(&root_item, 1);
+	btrfs_set_root_used(&root_item, cfg->nodesize);
+	btrfs_set_root_generation(&root_item, 1);
+	btrfs_set_root_bytenr(&root_item, bytenr);
+
+	memset(&disk_key, 0, sizeof(disk_key));
+	btrfs_set_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
+	btrfs_set_disk_key_objectid(&disk_key, objectid);
+	btrfs_set_disk_key_offset(&disk_key, 0);
+
+	btrfs_set_item_key(buf, &disk_key, *slot);
+	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(root_item));
+	write_extent_buffer(buf, &root_item,
+			    btrfs_item_ptr_offset(buf, *slot),
+			    sizeof(root_item));
+	(*slot)++;
+}
+
+static int setup_temp_root_tree(int fd, struct btrfs_mkfs_config *cfg,
+				u64 root_bytenr, u64 extent_bytenr,
+				u64 dev_bytenr, u64 fs_bytenr, u64 csum_bytenr)
+{
+	struct extent_buffer *buf = NULL;
+	u32 itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize);
+	int slot = 0;
+	int ret;
+
+	/*
+	 * Provided bytenr must in ascending order, or tree root will have a
+	 * bad key order.
+	 */
+	BUG_ON(!(root_bytenr < extent_bytenr && extent_bytenr < dev_bytenr &&
+		 dev_bytenr < fs_bytenr && fs_bytenr < csum_bytenr));
+	buf = malloc(sizeof(*buf) + cfg->nodesize);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = setup_temp_extent_buffer(buf, cfg, root_bytenr,
+				       BTRFS_ROOT_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+
+	insert_temp_root_item(buf, cfg, &slot, &itemoff,
+			      BTRFS_EXTENT_TREE_OBJECTID, extent_bytenr);
+	insert_temp_root_item(buf, cfg, &slot, &itemoff,
+			      BTRFS_DEV_TREE_OBJECTID, dev_bytenr);
+	insert_temp_root_item(buf, cfg, &slot, &itemoff,
+			      BTRFS_FS_TREE_OBJECTID, fs_bytenr);
+	insert_temp_root_item(buf, cfg, &slot, &itemoff,
+			      BTRFS_CSUM_TREE_OBJECTID, csum_bytenr);
+
+	ret = write_temp_extent_buffer(fd, buf, root_bytenr);
+out:
+	free(buf);
+	return ret;
+}
+
+/*
  * Improved version of make_btrfs().
  *
  * This one will
@@ -326,6 +456,11 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 	u64 chunk_bytenr;
 	/* metadata trees bytenr, in metadata chunk */
 	u64 root_bytenr;
+	u64 extent_bytenr;
+	u64 dev_bytenr;
+	u64 fs_bytenr;
+	u64 csum_bytenr;
+	/* Above bytenrs are just for better readablity */
 	int ret;
 
 	/* Shouldn't happen */
@@ -357,6 +492,8 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 		goto out;
 
 	/*
+	 * Allocated meta/sys chunks will be mapped 1:1 with device offset.
+	 *
 	 * Inside the allocate metadata chunk, its layout will be:
 	 *  | offset		| contents	|
 	 *  -------------------------------------
@@ -374,9 +511,20 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 	 */
 	chunk_bytenr = sys_chunk_start;
 	root_bytenr = meta_chunk_start;
+	extent_bytenr = meta_chunk_start + cfg->nodesize;
+	dev_bytenr = meta_chunk_start + cfg->nodesize * 2;
+	fs_bytenr = meta_chunk_start + cfg->nodesize * 3;
+	csum_bytenr = meta_chunk_start + cfg->nodesize * 4;
+
 	ret = setup_temp_super(fd, cfg, root_bytenr, chunk_bytenr);
 	if (ret < 0)
 		goto out;
+
+	ret = setup_temp_root_tree(fd, cfg, root_bytenr, extent_bytenr,
+				   dev_bytenr, fs_bytenr, csum_bytenr);
+	if (ret < 0)
+		goto out;
+
 out:
 	return ret;
 }
-- 
2.7.0



