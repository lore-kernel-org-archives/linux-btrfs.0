Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21484 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754900AbbKRHYr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:47 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoS6007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:58 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 11/22] btrfs-progs: Introduce function to initialize device tree
Date: Wed, 18 Nov 2015 15:22:11 +0800
Message-Id: <1447831342-15056-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_device_tree(), to setup temporary
device tree for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index a91b70c..3be484a 100644
--- a/utils.c
+++ b/utils.c
@@ -787,6 +787,59 @@ out:
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
@@ -879,7 +932,8 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 				    chunk_bytenr);
 	if (ret < 0)
 		goto out;
-
+	ret = setup_temp_dev_tree(fd, cfg, sys_chunk_start, meta_chunk_start,
+				  dev_bytenr);
 out:
 	free(free_tree);
 	return ret;
-- 
2.6.2

