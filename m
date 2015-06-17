Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19003 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758109AbbFQHtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:49:08 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5H7lUJs015762
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:47:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: Export read_extent_data function.
Date: Wed, 17 Jun 2015 15:49:00 +0800
Message-ID: <1434527344-314-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export it for later btrfs-map-logical cleanup.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 34 ----------------------------------
 disk-io.c    | 34 ++++++++++++++++++++++++++++++++++
 disk-io.h    |  2 ++
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index db121b1..778f141 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5235,40 +5235,6 @@ static int check_space_cache(struct btrfs_root *root)
 	return error ? -EINVAL : 0;
 }
 
-static int read_extent_data(struct btrfs_root *root, char *data,
-			u64 logical, u64 *len, int mirror)
-{
-	u64 offset = 0;
-	struct btrfs_multi_bio *multi = NULL;
-	struct btrfs_fs_info *info = root->fs_info;
-	struct btrfs_device *device;
-	int ret = 0;
-	u64 max_len = *len;
-
-	ret = btrfs_map_block(&info->mapping_tree, READ, logical, len,
-			      &multi, mirror, NULL);
-	if (ret) {
-		fprintf(stderr, "Couldn't map the block %llu\n",
-				logical + offset);
-		goto err;
-	}
-	device = multi->stripes[0].dev;
-
-	if (device->fd == 0)
-		goto err;
-	if (*len > max_len)
-		*len = max_len;
-
-	ret = pread64(device->fd, data, *len, multi->stripes[0].physical);
-	if (ret != *len)
-		ret = -EIO;
-	else
-		ret = 0;
-err:
-	kfree(multi);
-	return ret;
-}
-
 static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 			u64 num_bytes, unsigned long leaf_offset,
 			struct extent_buffer *eb) {
diff --git a/disk-io.c b/disk-io.c
index 2a7feb0..720fee4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -340,6 +340,40 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	return ERR_PTR(ret);
 }
 
+int read_extent_data(struct btrfs_root *root, char *data,
+			   u64 logical, u64 *len, int mirror)
+{
+	u64 offset = 0;
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_device *device;
+	int ret = 0;
+	u64 max_len = *len;
+
+	ret = btrfs_map_block(&info->mapping_tree, READ, logical, len,
+			      &multi, mirror, NULL);
+	if (ret) {
+		fprintf(stderr, "Couldn't map the block %llu\n",
+				logical + offset);
+		goto err;
+	}
+	device = multi->stripes[0].dev;
+
+	if (device->fd == 0)
+		goto err;
+	if (*len > max_len)
+		*len = max_len;
+
+	ret = pread64(device->fd, data, *len, multi->stripes[0].physical);
+	if (ret != *len)
+		ret = -EIO;
+	else
+		ret = 0;
+err:
+	kfree(multi);
+	return ret;
+}
+
 int write_and_map_eb(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb)
diff --git a/disk-io.h b/disk-io.h
index 62eb566..87e1cd9 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -66,6 +66,8 @@ struct btrfs_device;
 int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror);
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
+int read_extent_data(struct btrfs_root *root, char *data, u64 logical,
+		     u64 *len, int mirror);
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			  u64 parent_transid);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-- 
2.4.3

