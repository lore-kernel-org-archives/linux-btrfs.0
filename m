Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9155 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbcA2FQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:16:32 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 08/22] btrfs-progs: Introduce function to initialize device tree
Date: Fri, 29 Jan 2016 13:03:18 +0800
Message-Id: <1454043812-7893-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_device_tree(), to setup temporary
device tree for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 utils.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 65bb11f..4d29b1e 100644
--- a/utils.c
+++ b/utils.c
@@ -601,6 +601,59 @@ out:
 	return ret;
 }
 
+static void insert_temp_dev_extent(struct extent_buffer *buf,
+				   int *slot, u32 *itemoff, u64 start, u64 len)
+{
+	struct btrfs_dev_extent *dev_extent;
+	struct btrfs_disk_key disk_key;
+
+	btrfs_set_header_nritems(buf, *slot + 1);
+	(*itemoff) -= sizeof(*dev_extent);
+	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
+	btrfs_set_disk_key_objectid(&disk_key, 1);
+	btrfs_set_disk_key_offset(&disk_key, start);
+	btrfs_set_item_key(buf, &disk_key, *slot);
+	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(*dev_extent));
+
+	dev_extent = btrfs_item_ptr(buf, *slot, struct btrfs_dev_extent);
+	btrfs_set_dev_extent_chunk_objectid(buf, dev_extent,
+					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_dev_extent_length(buf, dev_extent, len);
+	btrfs_set_dev_extent_chunk_offset(buf, dev_extent, start);
+	btrfs_set_dev_extent_chunk_tree(buf, dev_extent,
+					BTRFS_CHUNK_TREE_OBJECTID);
+	(*slot)++;
+}
+
+static int setup_temp_dev_tree(int fd, struct btrfs_mkfs_config *cfg,
+			       u64 sys_chunk_start, u64 meta_chunk_start,
+			       u64 dev_bytenr)
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
+	ret = setup_temp_extent_buffer(buf, cfg, dev_bytenr,
+				       BTRFS_DEV_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+	insert_temp_dev_extent(buf, &slot, &itemoff, sys_chunk_start,
+			       BTRFS_MKFS_SYSTEM_GROUP_SIZE);
+	insert_temp_dev_extent(buf, &slot, &itemoff, meta_chunk_start,
+			       BTRFS_CONVERT_META_GROUP_SIZE);
+	ret = write_temp_extent_buffer(fd, buf, dev_bytenr);
+out:
+	free(buf);
+	return ret;
+}
+
 /*
  * Improved version of make_btrfs().
  *
@@ -695,7 +748,8 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 				    chunk_bytenr);
 	if (ret < 0)
 		goto out;
-
+	ret = setup_temp_dev_tree(fd, cfg, sys_chunk_start, meta_chunk_start,
+				  dev_bytenr);
 out:
 	return ret;
 }
-- 
2.7.0



