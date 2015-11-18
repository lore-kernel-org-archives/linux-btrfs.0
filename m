Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbbKRHYn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:43 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoS2007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 07/22] btrfs-progs: Reserve space for system/meta chunks and superblock
Date: Wed, 18 Nov 2015 15:22:07 +0800
Message-Id: <1447831342-15056-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now we have a free space cache tree, we can reserve space for system and
metadata chunks and super blocks.

With this patch, even for the temporary fs, metadata tree blocks will be
prevent from being allocated into possible data chunks.

This provides the basis for later btrfs-convert enhancement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  2 ++
 2 files changed, 87 insertions(+)

diff --git a/utils.c b/utils.c
index 42e333b..5619b85 100644
--- a/utils.c
+++ b/utils.c
@@ -367,6 +367,91 @@ out:
 }
 
 /*
+ * Reserve space from free_tree.
+ * The algorithm is very simple, find the first cache_extent with enough space
+ * and allocate from its beginning.
+ */
+static int reserve_free_space(struct cache_tree *free_tree, u64 len,
+			      u64 *ret_start)
+{
+	struct cache_extent *cache;
+	int found = 0;
+
+	BUG_ON(!ret_start);
+	cache = first_cache_extent(free_tree);
+	while (cache) {
+		if (cache->size > len) {
+			found = 1;
+			*ret_start = cache->start;
+
+			cache->size -= len;
+			if (cache->size == 0) {
+				remove_cache_extent(free_tree, cache);
+				free(cache);
+			} else {
+				cache->start += len;
+			}
+			break;
+		}
+		cache = next_cache_extent(cache);
+	}
+	if (!found)
+		return -ENOSPC;
+	return 0;
+}
+
+/*
+ * Improved version of make_btrfs().
+ *
+ * This one will not use bad behaved cfg->blocks[] array to arrange tree
+ * roots.
+ * Instead, it will use cfg->convert_used to calculate a free space tree,
+ * and then allocate system and metadata chunk, then put tree roots into
+ * corresponding chunks.
+ */
+static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
+{
+	struct cache_tree *free_tree;
+	struct cache_tree *used_tree = &cfg->convert_used;
+	u64 sys_chunk_start;
+	u64 meta_chunk_start;
+	int ret;
+
+	/* Shouldn't happen */
+	BUG_ON(cache_tree_empty(used_tree));
+
+	free_tree = malloc(sizeof(*free_tree));
+	if (!free_tree)
+		return -ENOMEM;
+	cache_tree_init(free_tree);
+
+	/* generate free space cache tree for later chunk allocation */
+	ret = calculate_available_space(used_tree, free_tree, cfg);
+	if (ret < 0)
+		goto out;
+
+	/* reserve space for temporary superblock first */
+	ret = reserve_free_space(free_tree, BTRFS_SUPER_INFO_SIZE,
+				 &cfg->super_bytenr);
+	if (ret < 0)
+		goto out;
+
+	/* Then reserve system and metadata chunk space*/
+	ret = reserve_free_space(free_tree, BTRFS_MKFS_SYSTEM_GROUP_SIZE,
+				 &sys_chunk_start);
+	if (ret < 0)
+		goto out;
+	ret = reserve_free_space(free_tree, BTRFS_CONVERT_META_GROUP_SIZE,
+				 &meta_chunk_start);
+	if (ret < 0)
+		goto out;
+
+out:
+	free(free_tree);
+	return ret;
+}
+
+/*
  * @fs_uuid - if NULL, generates a UUID, returns back the new filesystem UUID
  */
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
diff --git a/utils.h b/utils.h
index 6ac1ba8..cec30dc 100644
--- a/utils.h
+++ b/utils.h
@@ -123,6 +123,8 @@ struct btrfs_mkfs_config {
 	/*
 	 * Already used space in original filesystem before convert.
 	 * For normal mkfs case, it should be empty.
+	 *
+	 * Raw ext* used bytes.
 	 */
 	struct cache_tree convert_used;
 
-- 
2.6.2

