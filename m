Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13953 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202AbaE3HPJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 03:15:09 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4U7F6hc028211
	for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 15:15:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Avoid trucating page or punching hole in a already existed hole.
Date: Fri, 30 May 2014 15:16:10 +0800
Message-ID: <1401434170-30695-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_punch_hole() will truncate unaligned pages or punch hole on a
already existed hole.
This will cause unneeded zero page or holes splitting the original huge
hole.

This patch will skip already existed holes before any page truncating or
hole punching.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 98 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ae6af07..93915d1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2168,6 +2168,37 @@ out:
 	return 0;
 }
 
+/*
+ * Find a hole extent on given inode and change start/len to the end of hole
+ * extent.(hole/vacuum extent whose em->start <= start &&
+ *	   em->start + em->len > start)
+ * When a hole extent is found, return 1 and modify start/len.
+ */
+static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
+{
+	struct extent_map *em;
+	int ret = 0;
+
+	em = btrfs_get_extent(inode, NULL, 0, *start, *len, 0);
+	if (IS_ERR_OR_NULL(em)) {
+		if (!em)
+			ret = -ENOMEM;
+		else
+			ret = PTR_ERR(em);
+		return ret;
+	}
+
+	/* Hole or vacuum extent(only exists in no-hole mode) */
+	if (em->block_start == EXTENT_MAP_HOLE) {
+		ret = 1;
+		*len = em->start + em->len > *start + *len ?
+		       0 : *start + *len - em->start - em->len;
+		*start = em->start + em->len;
+	}
+	free_extent_map(em);
+	return ret;
+}
+
 static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -2175,17 +2206,18 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *rsv;
 	struct btrfs_trans_handle *trans;
-	u64 lockstart = round_up(offset, BTRFS_I(inode)->root->sectorsize);
-	u64 lockend = round_down(offset + len,
-				 BTRFS_I(inode)->root->sectorsize) - 1;
-	u64 cur_offset = lockstart;
+	u64 lockstart;
+	u64 lockend;
+	u64 tail_start;
+	u64 tail_len;
+	u64 orig_start = offset;
+	u64 cur_offset;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 	u64 drop_end;
 	int ret = 0;
 	int err = 0;
 	int rsv_count;
-	bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
-			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
+	bool same_page;
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 	u64 ino_size = round_up(inode->i_size, PAGE_CACHE_SIZE);
 
@@ -2194,6 +2226,21 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		return ret;
 
 	mutex_lock(&inode->i_mutex);
+	ret = find_first_non_hole(inode, &offset, &len);
+	if (ret < 0)
+		goto out_only_mutex;
+	if (ret && !len) {
+		/* Already in a large hole */
+		ret = 0;
+		goto out_only_mutex;
+	}
+
+	lockstart = round_up(offset , BTRFS_I(inode)->root->sectorsize);
+	lockend = round_down(offset + len,
+			     BTRFS_I(inode)->root->sectorsize) - 1;
+	same_page = ((offset >> PAGE_CACHE_SHIFT) ==
+		    ((offset + len - 1) >> PAGE_CACHE_SHIFT));
+
 	/*
 	 * We needn't truncate any page which is beyond the end of the file
 	 * because we are sure there is no data there.
@@ -2205,8 +2252,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (same_page && len < PAGE_CACHE_SIZE) {
 		if (offset < ino_size)
 			ret = btrfs_truncate_page(inode, offset, len, 0);
-		mutex_unlock(&inode->i_mutex);
-		return ret;
+		goto out_only_mutex;
 	}
 
 	/* zero back part of the first page */
@@ -2218,12 +2264,39 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		}
 	}
 
-	/* zero the front end of the last page */
-	if (offset + len < ino_size) {
-		ret = btrfs_truncate_page(inode, offset + len, 0, 1);
-		if (ret) {
-			mutex_unlock(&inode->i_mutex);
-			return ret;
+	/* Check the aligned pages after the first unaligned page,
+	 * if offset != orig_start, which means the first unaligned page
+	 * including serveral following pages are already in holes,
+	 * the extra check can be skipped */
+	if (offset == orig_start) {
+		/* after truncate page, check hole again */
+		len = offset + len - lockstart;
+		offset = lockstart;
+		ret = find_first_non_hole(inode, &offset, &len);
+		if (ret < 0)
+			goto out_only_mutex;
+		if (ret && !len) {
+			ret = 0;
+			goto out_only_mutex;
+		}
+		lockstart = offset;
+	}
+
+	/* Check the tail unaligned part is in a hole */
+	tail_start = lockend + 1;
+	tail_len = offset + len - tail_start;
+	if (tail_len) {
+		ret = find_first_non_hole(inode, &tail_start, &tail_len);
+		if (unlikely(ret < 0))
+			goto out_only_mutex;
+		if (!ret) {
+			/* zero the front end of the last page */
+			if (tail_start + tail_len < ino_size) {
+				ret = btrfs_truncate_page(inode,
+						tail_start + tail_len, 0, 1);
+				if (ret)
+					goto out_only_mutex;
+				}
 		}
 	}
 
@@ -2299,6 +2372,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	BUG_ON(ret);
 	trans->block_rsv = rsv;
 
+	cur_offset = lockstart;
+	len = lockend - cur_offset;
 	while (cur_offset < lockend) {
 		ret = __btrfs_drop_extents(trans, root, inode, path,
 					   cur_offset, lockend + 1,
@@ -2339,6 +2414,14 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 					      rsv, min_size);
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
+
+		ret = find_first_non_hole(inode, &cur_offset, &len);
+		if (unlikely(ret < 0))
+			break;
+		if (ret && !len) {
+			ret = 0;
+			break;
+		}
 	}
 
 	if (ret) {
@@ -2372,6 +2455,7 @@ out_free:
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state, GFP_NOFS);
+out_only_mutex:
 	mutex_unlock(&inode->i_mutex);
 	if (ret && !err)
 		err = ret;
-- 
1.9.3

