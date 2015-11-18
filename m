Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23505 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753709AbbKRHYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:48 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoS5007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 10/22] btrfs-progs: Introduce function to setup temporary chunk root
Date: Wed, 18 Nov 2015 15:22:10 +0800
Message-Id: <1447831342-15056-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_chunk_root(), to initialize temporary
chunk root for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/utils.c b/utils.c
index ce4d93c..a91b70c 100644
--- a/utils.c
+++ b/utils.c
@@ -622,6 +622,171 @@ out:
 	return ret;
 }
 
+static int insert_temp_dev_item(int fd, struct extent_buffer *buf,
+				struct btrfs_mkfs_config *cfg,
+				int *slot, u32 *itemoff)
+{
+	struct btrfs_disk_key disk_key;
+	struct btrfs_dev_item *dev_item;
+	char super_buf[BTRFS_SUPER_INFO_SIZE];
+	unsigned char dev_uuid[BTRFS_UUID_SIZE];
+	unsigned char fsid[BTRFS_FSID_SIZE];
+	struct btrfs_super_block *super = (struct btrfs_super_block*)super_buf;
+	int ret;
+
+	ret = pread(fd, super_buf, BTRFS_SUPER_INFO_SIZE, cfg->super_bytenr);
+	if (ret < BTRFS_SUPER_INFO_SIZE) {
+		ret = (ret < 0 ? -errno : -EIO);
+		goto out;
+	}
+
+	btrfs_set_header_nritems(buf, *slot + 1);
+	(*itemoff) -= sizeof(*dev_item);
+	/* setup device item 1, 0 is for replace case */
+	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
+	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_ITEMS_OBJECTID);
+	btrfs_set_disk_key_offset(&disk_key, 1);
+	btrfs_set_item_key(buf, &disk_key, *slot);
+	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(*dev_item));
+
+	dev_item = btrfs_item_ptr(buf, *slot, struct btrfs_dev_item);
+	/* Generate device uuid */
+	uuid_generate(dev_uuid);
+	write_extent_buffer(buf, dev_uuid, (unsigned long)btrfs_device_uuid(dev_item),
+			    BTRFS_UUID_SIZE);
+	uuid_parse(cfg->fs_uuid, fsid);
+	write_extent_buffer(buf, fsid, (unsigned long)btrfs_device_fsid(dev_item),
+			    BTRFS_FSID_SIZE);
+	btrfs_set_device_id(buf, dev_item, 1);
+	btrfs_set_device_generation(buf, dev_item, 0);
+	btrfs_set_device_total_bytes(buf, dev_item, cfg->num_bytes);
+	/*
+	 * The number must match the initial SYSTEM and META chunk size
+	 */
+	btrfs_set_device_bytes_used(buf, dev_item,
+			BTRFS_MKFS_SYSTEM_GROUP_SIZE +
+			BTRFS_CONVERT_META_GROUP_SIZE);
+	btrfs_set_device_io_align(buf, dev_item, cfg->sectorsize);
+	btrfs_set_device_io_width(buf, dev_item, cfg->sectorsize);
+	btrfs_set_device_sector_size(buf, dev_item, cfg->sectorsize);
+	btrfs_set_device_type(buf, dev_item, 0);
+
+	/* Super dev_item is not complete, copy the complete one to sb */
+	read_extent_buffer(buf, &super->dev_item, (unsigned long)dev_item,
+			   sizeof(*dev_item));
+	ret = write_temp_super(fd, super, cfg->super_bytenr);
+	(*slot)++;
+out:
+	return ret;
+}
+
+static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
+				  struct btrfs_mkfs_config *cfg,
+				  int *slot, u32 *itemoff, u64 start, u64 len,
+				  u64 type)
+{
+	struct btrfs_chunk *chunk;
+	struct btrfs_disk_key disk_key;
+	char super_buf[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *sb = (struct btrfs_super_block *)super_buf;
+	int ret = 0;
+
+	ret = pread(fd, super_buf, BTRFS_SUPER_INFO_SIZE,
+		    cfg->super_bytenr);
+	if (ret < BTRFS_SUPER_INFO_SIZE) {
+		ret = (ret < 0 ? ret : -EIO);
+		return ret;
+	}
+
+	btrfs_set_header_nritems(buf, *slot + 1);
+	(*itemoff) -= btrfs_chunk_item_size(1);
+	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
+	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_disk_key_offset(&disk_key, start);
+	btrfs_set_item_key(buf, &disk_key, *slot);
+	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(*slot),
+			    btrfs_chunk_item_size(1));
+
+	chunk = btrfs_item_ptr(buf, *slot, struct btrfs_chunk);
+	btrfs_set_chunk_length(buf, chunk, len);
+	btrfs_set_chunk_owner(buf, chunk, BTRFS_EXTENT_TREE_OBJECTID);
+	btrfs_set_chunk_stripe_len(buf, chunk, 64 * 1024);
+	btrfs_set_chunk_type(buf, chunk, type);
+	btrfs_set_chunk_io_align(buf, chunk, cfg->sectorsize);
+	btrfs_set_chunk_io_width(buf, chunk, cfg->sectorsize);
+	btrfs_set_chunk_sector_size(buf, chunk, cfg->sectorsize);
+	btrfs_set_chunk_num_stripes(buf, chunk, 1);
+	/* TODO: Support DUP profile for system chunk */
+	btrfs_set_stripe_devid_nr(buf, chunk, 0, 1);
+	/* We are doing 1:1 mapping, so start is its dev offset */
+	btrfs_set_stripe_offset_nr(buf, chunk, 0, start);
+	write_extent_buffer(buf, &sb->dev_item.uuid,
+			    (unsigned long)btrfs_stripe_dev_uuid_nr(chunk, 0),
+			    BTRFS_UUID_SIZE);
+	(*slot)++;
+
+	/*
+	 * If it's system chunk, also copy it to super block.
+	 */
+	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
+		char *cur;
+
+		cur = (char *)sb->sys_chunk_array + sb->sys_chunk_array_size;
+		memcpy(cur, &disk_key, sizeof(disk_key));
+		cur += sizeof(disk_key);
+		read_extent_buffer(buf, cur, (unsigned long int)chunk,
+				   btrfs_chunk_item_size(1));
+		sb->sys_chunk_array_size += btrfs_chunk_item_size(1) +
+					    sizeof(disk_key);
+
+		ret = write_temp_super(fd, sb, cfg->super_bytenr);
+	}
+	return ret;
+}
+
+static int setup_temp_chunk_tree(int fd, struct btrfs_mkfs_config *cfg,
+				 u64 sys_chunk_start, u64 meta_chunk_start,
+				 u64 chunk_bytenr)
+{
+	struct extent_buffer *buf = NULL;
+	u32 itemoff = __BTRFS_LEAF_DATA_SIZE(cfg->nodesize);
+	int slot = 0;
+	int ret;
+
+	/* Must ensure SYS chunk starts before META chunk */
+	BUG_ON(meta_chunk_start < sys_chunk_start);
+	buf = malloc(sizeof(*buf) + cfg->nodesize);
+	if (!buf)
+		return -ENOMEM;
+	ret = setup_temp_extent_buffer(buf, cfg, chunk_bytenr,
+				       BTRFS_CHUNK_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+
+	ret = insert_temp_dev_item(fd, buf, cfg, &slot, &itemoff);
+	if (ret < 0)
+		goto out;
+	ret = insert_temp_chunk_item(fd, buf, cfg, &slot, &itemoff,
+				     sys_chunk_start,
+				     BTRFS_MKFS_SYSTEM_GROUP_SIZE,
+				     BTRFS_BLOCK_GROUP_SYSTEM);
+	if (ret < 0)
+		goto out;
+	ret = insert_temp_chunk_item(fd, buf, cfg, &slot, &itemoff,
+				     meta_chunk_start,
+				     BTRFS_CONVERT_META_GROUP_SIZE,
+				     BTRFS_BLOCK_GROUP_METADATA);
+	if (ret < 0)
+		goto out;
+	ret = write_temp_extent_buffer(fd, buf, chunk_bytenr);
+
+out:
+	free(buf);
+	return ret;
+}
+
 /*
  * Improved version of make_btrfs().
  *
@@ -710,6 +875,10 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 				   dev_bytenr, fs_bytenr, csum_bytenr);
 	if (ret < 0)
 		goto out;
+	ret = setup_temp_chunk_tree(fd, cfg, sys_chunk_start, meta_chunk_start,
+				    chunk_bytenr);
+	if (ret < 0)
+		goto out;
 
 out:
 	free(free_tree);
-- 
2.6.2

