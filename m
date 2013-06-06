Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36229 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3FFRXH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 13:23:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B5C3D9A0697
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Jun 2013 11:23:06 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 8zIzTcGrl760C7LC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 06 Jun 2013 11:23:05 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: exclude logged extents before replying when we are mixed
Date: Thu, 6 Jun 2013 13:23:03 -0400
Message-ID: <1370539383-16494-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With non-mixed block groups we replay the logs before we're allowed to do any
writes, so we get away with not pinning/removing the data extents until right
when we replay them.  However with mixed block groups we allocate out of the
same pool, so we could easily allocate a metadata block that was logged in our
tree log.  To deal with this we just need to notice that we have mixed block
groups and do the normal excluding/removal dance during the pin stage of the log
replay and that way we don't allocate metadata blocks from areas we have logged
data extents.  With this patch we now pass xfstests generic/311 with mixed
block groups turned on.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    2 +
 fs/btrfs/extent-tree.c |  122 +++++++++++++++++++++++++++++++++--------------
 fs/btrfs/tree-log.c    |   12 +++++
 3 files changed, 99 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80ab1a6..0049fe0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3067,6 +3067,8 @@ int btrfs_pin_extent(struct btrfs_root *root,
 		     u64 bytenr, u64 num, int reserved);
 int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 				    u64 bytenr, u64 num_bytes);
+int btrfs_exclude_logged_extents(struct btrfs_root *root,
+				 struct extent_buffer *eb);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e14f8bd..f84d53b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5214,6 +5214,80 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 	return ret;
 }
 
+static int __exclude_logged_extent(struct btrfs_root *root, u64 start, u64 num_bytes)
+{
+	int ret;
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_caching_control *caching_ctl;
+
+	block_group = btrfs_lookup_block_group(root->fs_info, start);
+	if (!block_group)
+		return -EINVAL;
+
+	cache_block_group(block_group, 0);
+	caching_ctl = get_caching_control(block_group);
+
+	if (!caching_ctl) {
+		/* Logic error */
+		BUG_ON(!block_group_cache_done(block_group));
+		ret = btrfs_remove_free_space(block_group, start, num_bytes);
+	} else {
+		mutex_lock(&caching_ctl->mutex);
+
+		if (start >= caching_ctl->progress) {
+			ret = add_excluded_extent(root, start, num_bytes);
+		} else if (start + num_bytes <= caching_ctl->progress) {
+			ret = btrfs_remove_free_space(block_group,
+						      start, num_bytes);
+		} else {
+			num_bytes = caching_ctl->progress - start;
+			ret = btrfs_remove_free_space(block_group,
+						      start, num_bytes);
+			if (ret)
+				goto out_lock;
+
+			num_bytes = (start + num_bytes) -
+				caching_ctl->progress;
+			start = caching_ctl->progress;
+			ret = add_excluded_extent(root, start, num_bytes);
+		}
+out_lock:
+		mutex_unlock(&caching_ctl->mutex);
+		put_caching_control(caching_ctl);
+	}
+	btrfs_put_block_group(block_group);
+	return ret;
+}
+
+int btrfs_exclude_logged_extents(struct btrfs_root *log,
+				 struct extent_buffer *eb)
+{
+	struct btrfs_file_extent_item *item;
+	struct btrfs_key key;
+	int found_type;
+	int i;
+
+	if (!btrfs_fs_incompat(log->fs_info, MIXED_GROUPS))
+		return 0;
+
+	for (i = 0; i < btrfs_header_nritems(eb); i++) {
+		btrfs_item_key_to_cpu(eb, &key, i);
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+		item = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
+		found_type = btrfs_file_extent_type(eb, item);
+		if (found_type == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+		if (btrfs_file_extent_disk_bytenr(eb, item) == 0)
+			continue;
+		key.objectid = btrfs_file_extent_disk_bytenr(eb, item);
+		key.offset = btrfs_file_extent_disk_num_bytes(eb, item);
+		__exclude_logged_extent(log, key.objectid, key.offset);
+	}
+
+	return 0;
+}
+
 /**
  * btrfs_update_reserved_bytes - update the block_group and space info counters
  * @cache:	The cache we are manipulating
@@ -6585,52 +6659,26 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	struct btrfs_block_group_cache *block_group;
-	struct btrfs_caching_control *caching_ctl;
-	u64 start = ins->objectid;
-	u64 num_bytes = ins->offset;
-
-	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	cache_block_group(block_group, 0);
-	caching_ctl = get_caching_control(block_group);
 
-	if (!caching_ctl) {
-		BUG_ON(!block_group_cache_done(block_group));
-		ret = btrfs_remove_free_space(block_group, start, num_bytes);
-		if (ret)
-			goto out;
-	} else {
-		mutex_lock(&caching_ctl->mutex);
-
-		if (start >= caching_ctl->progress) {
-			ret = add_excluded_extent(root, start, num_bytes);
-		} else if (start + num_bytes <= caching_ctl->progress) {
-			ret = btrfs_remove_free_space(block_group,
-						      start, num_bytes);
-		} else {
-			num_bytes = caching_ctl->progress - start;
-			ret = btrfs_remove_free_space(block_group,
-						      start, num_bytes);
-			if (ret)
-				goto out_lock;
-
-			start = caching_ctl->progress;
-			num_bytes = ins->objectid + ins->offset -
-				    caching_ctl->progress;
-			ret = add_excluded_extent(root, start, num_bytes);
-		}
-out_lock:
-		mutex_unlock(&caching_ctl->mutex);
-		put_caching_control(caching_ctl);
+	/*
+	 * Mixed block groups will exclude before processing the log so we only
+	 * need to do the exlude dance if this fs isn't mixed.
+	 */
+	if (!btrfs_fs_incompat(root->fs_info, MIXED_GROUPS)) {
+		ret = __exclude_logged_extent(root, ins->objectid, ins->offset);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
+	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
+	if (!block_group)
+		return -EINVAL;
+
 	ret = btrfs_update_reserved_bytes(block_group, ins->offset,
 					  RESERVE_ALLOC_NO_ACCOUNT);
 	BUG_ON(ret); /* logic error */
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
-out:
 	btrfs_put_block_group(block_group);
 	return ret;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 831ddd4..2c67914 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -280,11 +280,23 @@ static int process_one_buffer(struct btrfs_root *log,
 {
 	int ret = 0;
 
+	/*
+	 * If this fs is mixed then we need to be able to process the leaves to
+	 * pin down any logged extents, so we have to read the block.
+	 */
+	if (btrfs_fs_incompat(log->fs_info, MIXED_GROUPS)) {
+		ret = btrfs_read_buffer(eb, gen);
+		if (ret)
+			return ret;
+	}
+
 	if (wc->pin)
 		ret = btrfs_pin_extent_for_log_replay(log->fs_info->extent_root,
 						      eb->start, eb->len);
 
 	if (!ret && btrfs_buffer_uptodate(eb, gen, 0)) {
+		if (wc->pin && btrfs_header_level(eb) == 0)
+			ret = btrfs_exclude_logged_extents(log, eb);
 		if (wc->write)
 			btrfs_write_tree_block(eb);
 		if (wc->wait)
-- 
1.7.7.6

