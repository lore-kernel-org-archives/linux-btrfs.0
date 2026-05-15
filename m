Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434D72F7EE3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864443; cv=none; b=tTkteVFbZrGYsEgtv6/RgOkJRG1/VcidHAH1Bkqk0m1k2cN0LrNnWPlkquToqFF3gH1ClxqdqxklCW/ZYxpzVLBynXVG9mgRHkrK3NmVdjgapECVJiPoZjqKcRn7Rc0qUz/616BGo5m9yMOmgP0fqamu8SXUDT70uiOZj+cOAHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864443; c=relaxed/simple;
	bh=+naXAtiX2AjdgRW3pWz22UZ4e++miToTIyjsic5B9qU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw5GSOq09Zqiq4+IcFQPnPZieTHQunzeRh1k/ZBjNahuV/b9/37wkATjffL44GxVJjlWD4peng/D841nHJxHiIJ/UNG5O0SvYYDc87oOe1rbAFHhwU9XMTL0iQ3ikgsAltROQuod1a7WxWqzpha7Z8r03LBS+wU80mPPA8WkOaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+1IUelW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+1IUelW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743A2C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864443;
	bh=+naXAtiX2AjdgRW3pWz22UZ4e++miToTIyjsic5B9qU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=R+1IUelWCiUbHYMq9bg4cZDpX5CS8bObg7TUNIOTHlJtz+aN9f8SYCjFLxgLCubaT
	 qFnevB4WEUNWMWahAOJsTbFShoqg8hR8uXRX3/xc/hUp8rezsn5WExQ97vG0SzpP0d
	 Zs/hd2R9jY1TebHm6JKYk3d7Gco5JtIsIPzotN/YCmuLB1EH6Zs7cr950l+BDYaNt8
	 ax85kXChCQMhOqs4KZUeTWP+dkXTUse/Xth55wAAgvUg4m3SRwfHk1DiR2RuI7JN8h
	 WgJ4Sw+Buxc8Ea/UUvhDC7puevPTavOvs2c31OmMaWCEG201DrHvKlVk+TXRWI139o
	 E1NH1kco3mVWQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/28] btrfs: use a named enum for the log mode in inode log functions
Date: Fri, 15 May 2026 18:00:11 +0100
Message-ID: <feb81b3111ccaa27a651be697149ed362dd54c3b.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We use this unnamed enum for the log mode and then pass it around log
functions as an int type with the odd name "inode_only" which suggests a
boolean. So add a name to the enum and change the type everywhere to that
enum and rename the parameters to something more clear - "log_mode".
Also move the enum into tree-log.h - it will be used later by new trace
events.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 62 ++++++++++++++++++---------------------------
 fs/btrfs/tree-log.h |  7 +++++
 2 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f03bc6588210..70795cd76d6f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -33,17 +33,6 @@
 
 #define MAX_CONFLICT_INODES 10
 
-/* magic values for the inode_only field in btrfs_log_inode:
- *
- * LOG_INODE_ALL means to log everything
- * LOG_INODE_EXISTS means to log just enough to recreate the inode
- * during log replay
- */
-enum {
-	LOG_INODE_ALL,
-	LOG_INODE_EXISTS,
-};
-
 /*
  * directory trouble cases
  *
@@ -227,7 +216,7 @@ static void do_abort_log_replay(struct walk_control *wc, const char *function,
 
 static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode *inode,
-			   int inode_only,
+			   enum btrfs_log_mode log_mode,
 			   struct btrfs_log_ctx *ctx);
 static int link_to_fixup_dir(struct walk_control *wc, u64 objectid);
 static noinline int replay_dir_deletes(struct walk_control *wc,
@@ -4771,7 +4760,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_inode *inode,
 			       struct btrfs_path *dst_path,
 			       struct btrfs_path *src_path,
-			       int start_slot, int nr, int inode_only,
+			       int start_slot, int nr, enum btrfs_log_mode log_mode,
 			       u64 logged_isize, struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_root *log = inode->root->log_root;
@@ -4985,7 +4974,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			inode_item = btrfs_item_ptr(dst_path->nodes[0], dst_slot,
 						    struct btrfs_inode_item);
 			fill_inode_item(trans, dst_path->nodes[0], inode_item,
-					inode, inode_only == LOG_INODE_EXISTS,
+					inode, log_mode == LOG_INODE_EXISTS,
 					logged_isize);
 		} else {
 			copy_extent_buffer(dst_path->nodes[0], src, dst_offset,
@@ -6359,7 +6348,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				   struct btrfs_path *path,
 				   struct btrfs_path *dst_path,
 				   const u64 logged_isize,
-				   const int inode_only,
+				   const enum btrfs_log_mode log_mode,
 				   struct btrfs_log_ctx *ctx,
 				   bool *need_log_inode_item)
 {
@@ -6415,7 +6404,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				}
 				ret = copy_items(trans, inode, dst_path, path,
 						 ins_start_slot, ins_nr,
-						 inode_only, logged_isize, ctx);
+						 log_mode, logged_isize, ctx);
 				if (ret < 0)
 					return ret;
 				ins_nr = 0;
@@ -6434,7 +6423,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				goto next_slot;
 			ret = copy_items(trans, inode, dst_path, path,
 					 ins_start_slot,
-					 ins_nr, inode_only, logged_isize, ctx);
+					 ins_nr, log_mode, logged_isize, ctx);
 			if (ret < 0)
 				return ret;
 			ins_nr = 0;
@@ -6451,7 +6440,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 		}
 
 		ret = copy_items(trans, inode, dst_path, path, ins_start_slot,
-				 ins_nr, inode_only, logged_isize, ctx);
+				 ins_nr, log_mode, logged_isize, ctx);
 		if (ret < 0)
 			return ret;
 		ins_nr = 1;
@@ -6465,7 +6454,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 		}
 		if (ins_nr) {
 			ret = copy_items(trans, inode, dst_path, path,
-					 ins_start_slot, ins_nr, inode_only,
+					 ins_start_slot, ins_nr, log_mode,
 					 logged_isize, ctx);
 			if (ret < 0)
 				return ret;
@@ -6491,12 +6480,12 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 	}
 	if (ins_nr) {
 		ret = copy_items(trans, inode, dst_path, path, ins_start_slot,
-				 ins_nr, inode_only, logged_isize, ctx);
+				 ins_nr, log_mode, logged_isize, ctx);
 		if (ret)
 			return ret;
 	}
 
-	if (inode_only == LOG_INODE_ALL && S_ISREG(inode->vfs_inode.i_mode)) {
+	if (log_mode == LOG_INODE_ALL && S_ISREG(inode->vfs_inode.i_mode)) {
 		/*
 		 * Release the path because otherwise we might attempt to double
 		 * lock the same leaf with btrfs_log_prealloc_extents() below.
@@ -6891,7 +6880,7 @@ static int log_new_delayed_dentries(struct btrfs_trans_handle *trans,
  */
 static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode *inode,
-			   int inode_only,
+			   enum btrfs_log_mode log_mode,
 			   struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_path *path;
@@ -6931,13 +6920,13 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	if (S_ISDIR(inode->vfs_inode.i_mode) ||
 	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 		       &inode->runtime_flags) &&
-	     inode_only >= LOG_INODE_EXISTS))
+	     log_mode >= LOG_INODE_EXISTS))
 		max_key.type = BTRFS_XATTR_ITEM_KEY;
 	else
 		max_key.type = (u8)-1;
 	max_key.offset = (u64)-1;
 
-	if (S_ISDIR(inode->vfs_inode.i_mode) && inode_only == LOG_INODE_ALL)
+	if (S_ISDIR(inode->vfs_inode.i_mode) && log_mode == LOG_INODE_ALL)
 		full_dir_logging = true;
 
 	/*
@@ -6988,7 +6977,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	 * for symlinks).
 	 */
 	if (S_ISLNK(inode->vfs_inode.i_mode))
-		inode_only = LOG_INODE_ALL;
+		log_mode = LOG_INODE_ALL;
 
 	/*
 	 * Before logging the inode item, cache the value returned by
@@ -7023,7 +7012,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			ret = drop_inode_items(trans, log, path, inode,
 					       BTRFS_XATTR_ITEM_KEY);
 	} else {
-		if (inode_only == LOG_INODE_EXISTS) {
+		if (log_mode == LOG_INODE_EXISTS) {
 			/*
 			 * Make sure the new inode item we write to the log has
 			 * the same isize as the current one (if it exists).
@@ -7043,7 +7032,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		}
 		if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			     &inode->runtime_flags)) {
-			if (inode_only == LOG_INODE_EXISTS) {
+			if (log_mode == LOG_INODE_EXISTS) {
 				max_key.type = BTRFS_XATTR_ITEM_KEY;
 				if (ctx->logged_before)
 					ret = drop_inode_items(trans, log, path,
@@ -7059,15 +7048,15 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			}
 		} else if (test_and_clear_bit(BTRFS_INODE_COPY_EVERYTHING,
 					      &inode->runtime_flags) ||
-			   inode_only == LOG_INODE_EXISTS) {
-			if (inode_only == LOG_INODE_ALL)
+			   log_mode == LOG_INODE_EXISTS) {
+			if (log_mode == LOG_INODE_ALL)
 				fast_search = true;
 			max_key.type = BTRFS_XATTR_ITEM_KEY;
 			if (ctx->logged_before)
 				ret = drop_inode_items(trans, log, path, inode,
 						       max_key.type);
 		} else {
-			if (inode_only == LOG_INODE_ALL)
+			if (log_mode == LOG_INODE_ALL)
 				fast_search = true;
 			inode_item_dropped = false;
 			goto log_extents;
@@ -7102,8 +7091,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	ret = copy_inode_items_to_log(trans, inode, &min_key, &max_key,
 				      path, dst_path, logged_isize,
-				      inode_only, ctx,
-				      &need_log_inode_item);
+				      log_mode, ctx, &need_log_inode_item);
 	if (ret)
 		goto out_unlock;
 
@@ -7146,7 +7134,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		ret = btrfs_log_changed_extents(trans, inode, dst_path, ctx);
 		if (ret)
 			goto out_unlock;
-	} else if (inode_only == LOG_INODE_ALL) {
+	} else if (log_mode == LOG_INODE_ALL) {
 		struct extent_map *em, *n;
 
 		write_lock(&em_tree->lock);
@@ -7202,7 +7190,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	 *    a power failure unless the log was synced as part of an fsync
 	 *    against any other unrelated inode.
 	 */
-	if (!ctx->logging_new_name && inode_only != LOG_INODE_EXISTS)
+	if (!ctx->logging_new_name && log_mode != LOG_INODE_EXISTS)
 		inode->last_log_commit = inode->last_sub_trans;
 	spin_unlock(&inode->lock);
 
@@ -7210,7 +7198,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	 * Reset the last_reflink_trans so that the next fsync does not need to
 	 * go through the slower path when logging extents and their checksums.
 	 */
-	if (inode_only == LOG_INODE_ALL)
+	if (log_mode == LOG_INODE_ALL)
 		inode->last_reflink_trans = 0;
 
 out_unlock:
@@ -7533,7 +7521,7 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode *inode,
 				  struct dentry *parent,
-				  int inode_only,
+				  enum btrfs_log_mode log_mode,
 				  struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_root *root = inode->root;
@@ -7573,7 +7561,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_log_inode(trans, inode, inode_only, ctx);
+	ret = btrfs_log_inode(trans, inode, log_mode, ctx);
 	if (ret)
 		goto end_trans;
 
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 4a626dc6a58b..81ab5eeeb974 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -11,6 +11,13 @@
 #include <linux/fscrypt.h>
 #include "transaction.h"
 
+enum btrfs_log_mode {
+	/* Log everything about an inode. */
+	LOG_INODE_ALL,
+	/* Log just enough to recreate the inode during log replay. */
+	LOG_INODE_EXISTS,
+};
+
 struct inode;
 struct dentry;
 struct btrfs_ordered_extent;
-- 
2.47.2

