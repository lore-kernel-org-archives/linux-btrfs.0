Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55403 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1758598AbcJRBb7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 21:31:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: rgoldwyn@suse.com, rgoldwyn@suse.de
Subject: [PATCH 2/4] btrfs: qgroup: Rename functions to make it follow reserve,trace,account steps
Date: Tue, 18 Oct 2016 09:31:27 +0800
Message-Id: <20161018013129.23331-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
References: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename btrfs_qgroup_insert_dirty_extent(_nolock) to
btrfs_qgroup_trace_extent(_nolock), according to the new
reserve/trace/account naming schema.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c       |  2 +-
 fs/btrfs/extent-tree.c       |  6 +++---
 fs/btrfs/qgroup.c            |  8 ++++----
 fs/btrfs/qgroup.h            | 13 +++++++------
 fs/btrfs/relocation.c        |  2 +-
 fs/btrfs/tree-log.c          |  2 +-
 include/trace/events/btrfs.h |  2 +-
 7 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8d93854..a1cd0da 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -606,7 +606,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		qrecord->num_bytes = num_bytes;
 		qrecord->old_roots = NULL;
 
-		if(btrfs_qgroup_insert_dirty_extent_nolock(fs_info,
+		if(btrfs_qgroup_trace_extent_nolock(fs_info,
 					delayed_refs, qrecord))
 			kfree(qrecord);
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 210c94a..024eb5d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8568,8 +8568,8 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
 
 		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 
-		ret = btrfs_qgroup_insert_dirty_extent(trans, root->fs_info,
-				bytenr, num_bytes, GFP_NOFS);
+		ret = btrfs_qgroup_trace_extent(trans, root->fs_info,
+						bytenr, num_bytes, GFP_NOFS);
 		if (ret)
 			return ret;
 	}
@@ -8718,7 +8718,7 @@ walk_down:
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
 
-			ret = btrfs_qgroup_insert_dirty_extent(trans,
+			ret = btrfs_qgroup_trace_extent(trans,
 					root->fs_info, child_bytenr,
 					root->nodesize, GFP_NOFS);
 			if (ret)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 11f4fff..e73eea3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1450,7 +1450,7 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_qgroup_insert_dirty_extent_nolock(struct btrfs_fs_info *fs_info,
+int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
 				struct btrfs_delayed_ref_root *delayed_refs,
 				struct btrfs_qgroup_extent_record *record)
 {
@@ -1460,7 +1460,7 @@ int btrfs_qgroup_insert_dirty_extent_nolock(struct btrfs_fs_info *fs_info,
 	u64 bytenr = record->bytenr;
 
 	assert_spin_locked(&delayed_refs->lock);
-	trace_btrfs_qgroup_insert_dirty_extent(fs_info, record);
+	trace_btrfs_qgroup_trace_extent(fs_info, record);
 
 	while (*p) {
 		parent_node = *p;
@@ -1479,7 +1479,7 @@ int btrfs_qgroup_insert_dirty_extent_nolock(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_qgroup_insert_dirty_extent(struct btrfs_trans_handle *trans,
+int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
 		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
 		gfp_t gfp_flag)
 {
@@ -1502,7 +1502,7 @@ int btrfs_qgroup_insert_dirty_extent(struct btrfs_trans_handle *trans,
 	record->old_roots = NULL;
 
 	spin_lock(&delayed_refs->lock);
-	ret = btrfs_qgroup_insert_dirty_extent_nolock(fs_info, delayed_refs,
+	ret = btrfs_qgroup_trace_extent_nolock(fs_info, delayed_refs,
 						      record);
 	spin_unlock(&delayed_refs->lock);
 	if (ret > 0)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index a72bf21..9303e09 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -93,8 +93,8 @@ struct btrfs_delayed_extent_op;
 int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 /*
- * Insert one dirty extent record into @delayed_refs, informing qgroup to
- * account that extent at commit trans time.
+ * Inform qgroup to trace one dirty extent, its info is recorded in @record.
+ * So qgroup can account it at commit trans time.
  *
  * No lock version, caller must acquire delayed ref lock and allocate memory.
  *
@@ -102,14 +102,15 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
  * Return >0 for existing record, caller can free @record safely.
  * Error is not possible
  */
-int btrfs_qgroup_insert_dirty_extent_nolock(
+int btrfs_qgroup_trace_extent_nolock(
 		struct btrfs_fs_info *fs_info,
 		struct btrfs_delayed_ref_root *delayed_refs,
 		struct btrfs_qgroup_extent_record *record);
 
 /*
- * Insert one dirty extent record into @delayed_refs, informing qgroup to
- * account that extent at commit trans time.
+ * Inform qgroup to trace one dirty extent, specified by @bytenr and
+ * @num_bytes.
+ * So qgroup can account it at commit trans time.
  *
  * Better encapsulated version.
  *
@@ -117,7 +118,7 @@ int btrfs_qgroup_insert_dirty_extent_nolock(
  * Return <0 for error, like memory allocation failure or invalid parameter
  * (NULL trans)
  */
-int btrfs_qgroup_insert_dirty_extent(struct btrfs_trans_handle *trans,
+int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
 		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
 		gfp_t gfp_flag);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0ec8ffa..33cde30 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4005,7 +4005,7 @@ static int qgroup_fix_relocated_data_extents(struct btrfs_trans_handle *trans,
 		if (btrfs_file_extent_type(path->nodes[0], fi) !=
 				BTRFS_FILE_EXTENT_REG)
 			goto next;
-		ret = btrfs_qgroup_insert_dirty_extent(trans, fs_info,
+		ret = btrfs_qgroup_trace_extent(trans, fs_info,
 			btrfs_file_extent_disk_bytenr(path->nodes[0], fi),
 			btrfs_file_extent_disk_num_bytes(path->nodes[0], fi),
 			GFP_NOFS);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 688df71..8ad7665 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -689,7 +689,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		 * as the owner of the file extent changed from log tree
 		 * (doesn't affect qgroup) to fs/file tree(affects qgroup)
 		 */
-		ret = btrfs_qgroup_insert_dirty_extent(trans, root->fs_info,
+		ret = btrfs_qgroup_trace_extent(trans, root->fs_info,
 				btrfs_file_extent_disk_bytenr(eb, item),
 				btrfs_file_extent_disk_num_bytes(eb, item),
 				GFP_NOFS);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e030d6f..e61bbc3 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1406,7 +1406,7 @@ DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_account_extents,
 	TP_ARGS(fs_info, rec)
 );
 
-DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_insert_dirty_extent,
+DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_trace_extent,
 
 	TP_PROTO(struct btrfs_fs_info *fs_info,
 		 struct btrfs_qgroup_extent_record *rec),
-- 
2.10.0



