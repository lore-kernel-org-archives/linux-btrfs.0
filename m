Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7B2F7EEA
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864444; cv=none; b=RbrFIvQ8zVDo6JeZej3FNJiblNo1hWJZE4oUXkob5GhqDzLwPZ9LFrQJyujQX7ZaZj9ibtbMUoceJxWGmd0fpeWQrF391m0bsJmxlz8Q2gLHVe0Djgbh0zp8swBJeM0m0IXOlty7YS5fqQl7BR008+dD1vQ55VgE1XClKcVqIo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864444; c=relaxed/simple;
	bh=uc2Fg0SH5TGC1EKJaaengnF44bJlL0NSeMsvnI5Sh3c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8NPajmg5dKMOr+khmzfETZ7QvQ67XdhDJEfGSs+JpOqjzpMaeKA+7Q5UzY5EkmbaiW+nMvzBmFxWzFN9hcQMZoJacSo8pfa0rvNuvh9YaUpQAg5JAhog1ueIySQk6sDX7H/Di5zBX87rFYF/jzPKN0uw9w7jxQWrSE+P9pV5DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moEOBAhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moEOBAhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C03C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864443;
	bh=uc2Fg0SH5TGC1EKJaaengnF44bJlL0NSeMsvnI5Sh3c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=moEOBAhq2cHqraMYkyr0GKvGu9EktDrJ4p/nAqnsEhUnamGpBbDR2knBMlZQcrkf0
	 XHPzdJSfFD3m4A15j2itCGYzJMT65pIBaeoVRIm//aIFDtXErAZfjKlYVqL7TNSjtq
	 qZh5Z8/MdlexLquRoC4x1qlSMiQZdnNoFpUo6qY3JbKYxTWsU+8Al88K0xjuKTviP2
	 1Wyc9YzG8XKqH9k8CBMDnhyiryCBqNNnsgqOLz6i1lAIHjfSz8nLUUgulcaoVDFD9D
	 vw+egY+cFPlXazE5KuzZLcR3VKe3wUuroV02n430Kc9KOiT4h6wqNJ2mTEMijO6hbX
	 65PHbxIhwDYLw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/28] btrfs: tracepoints: add trace event for btrfs_log_inode()
Date: Fri, 15 May 2026 18:00:12 +0100
Message-ID: <f5142a40e34dc0588818348f5104269b960209d1.1778776707.git.fdmanana@suse.com>
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

btrfs_log_inode() is one of the most important steps called during a fsync,
as well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/super.c             |   1 +
 fs/btrfs/tree-log.c          |  16 +++--
 include/trace/events/btrfs.h | 116 +++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fb15decb0861..9de67276a8ed 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -60,6 +60,7 @@
 #include "verity.h"
 #include "super.h"
 #include "extent-tree.h"
+#include "tree-log.h"
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 70795cd76d6f..22066635f75f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6884,7 +6884,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			   struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_path *path;
-	struct btrfs_path *dst_path;
+	struct btrfs_path *dst_path = NULL;
 	struct btrfs_key min_key;
 	struct btrfs_key max_key;
 	struct btrfs_root *log = inode->root->log_root;
@@ -6900,13 +6900,17 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	LIST_HEAD(delayed_ins_list);
 	LIST_HEAD(delayed_del_list);
 
+	trace_btrfs_log_inode_enter(trans, inode, ctx, log_mode);
+
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	dst_path = btrfs_alloc_path();
 	if (!dst_path) {
-		btrfs_free_path(path);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	min_key.objectid = ino;
@@ -7221,6 +7225,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 					    &delayed_del_list);
 	}
 
+	trace_btrfs_log_inode_exit(trans, inode, ret);
+
 	return ret;
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index cd127c79a535..9f195d0d5378 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -33,6 +33,7 @@ struct raid56_bio_trace_info;
 struct find_free_extent_ctl;
 struct btrfs_trans_handle;
 struct btrfs_transaction;
+struct btrfs_log_ctx;
 
 #define show_inode_type(mode)					\
 	__print_symbolic((mode) & S_IFMT,			\
@@ -124,6 +125,9 @@ struct btrfs_transaction;
 	EM( TRANS_STATE_SUPER_COMMITTED,	"TRANS_STATE_SUPER_COMMITTED")	\
 	EMe(TRANS_STATE_COMPLETED,		"TRANS_STATE_COMPLETED")
 
+#define LOG_MODES							\
+	EM( LOG_INODE_ALL,		"LOG_INODE_ALL")		\
+	EMe(LOG_INODE_EXISTS,		"LOG_INODE_EXISTS")
 /*
  * First define the enums in the above macros to be exported to userspace via
  * TRACE_DEFINE_ENUM().
@@ -140,6 +144,7 @@ QGROUP_RSV_TYPES
 IO_TREE_OWNER
 FLUSH_STATES
 TRANSACTION_STATES
+LOG_MODES
 
 /*
  * Now redefine the EM and EMe macros to map the enums to the strings that will
@@ -951,6 +956,117 @@ TRACE_EVENT(btrfs_log_inode_parent_exit,
 			__entry->transid, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_inode_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans, struct btrfs_inode *inode,
+		 const struct btrfs_log_ctx *ctx, int log_mode),
+
+	TP_ARGS(trans, inode, ctx, log_mode),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     		root_objectid			)
+		__field(	u64,	 		ino				)
+		__field(	umode_t,		mode				)
+		__field(	u64,			transid				)
+		__field(	u64,			generation			)
+		__field(	u64,			logged_trans			)
+		__field(	u64,			last_unlink_trans		)
+		__field(	u64,			last_reflink_trans		)
+		__field(	int,			last_sub_trans			)
+		__field(	int,			last_log_commit			)
+		__field(	bool,			logging_new_name		)
+		__field(	bool,			logging_new_delayed_dentries	)
+		__field(        bool,			is_conflict_inode		)
+		__field(	bool,			full_sync			)
+		__field(	bool,			copy_everything			)
+		__field(	bool,			no_xattrs			)
+		__field(	int,   			log_mode			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid			= btrfs_root_id(inode->root);
+		__entry->ino				= btrfs_ino(inode);
+		__entry->mode				= inode->vfs_inode.i_mode;
+		__entry->transid			= trans->transid;
+		__entry->generation			= inode->generation;
+		spin_lock(&inode->lock);
+		__entry->logged_trans			= inode->logged_trans;
+		__entry->last_unlink_trans		= inode->last_unlink_trans;
+		__entry->last_reflink_trans		= inode->last_reflink_trans;
+		__entry->last_sub_trans			= inode->last_sub_trans;
+		__entry->last_log_commit		= inode->last_log_commit;
+		spin_unlock(&inode->lock);
+		__entry->logging_new_name		= ctx->logging_new_name;
+		__entry->logging_new_delayed_dentries	= ctx->logging_new_delayed_dentries;
+		__entry->is_conflict_inode		= ctx->logging_conflict_inodes;
+		__entry->full_sync			=
+			test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags);
+		__entry->copy_everything		=
+			test_bit(BTRFS_INODE_COPY_EVERYTHING, &inode->runtime_flags);
+		__entry->no_xattrs			=
+			test_bit(BTRFS_INODE_NO_XATTRS, &inode->runtime_flags);
+		__entry->log_mode			= log_mode;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu type=%s transid=%llu gen=%llu"
+			" logged_trans=%llu last_unlink_trans=%llu"
+			" last_reflink_trans=%llu last_sub_trans=%d last_log_commit=%d"
+			" logging_new_name=%d logging_new_delayed_dentries=%d"
+			" is_conflict_inode=%d full_sync=%d copy_everything=%d"
+			" no_xattrs=%d log_mode=%d(%s)",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			show_inode_type(__entry->mode), __entry->transid,
+			__entry->generation, __entry->logged_trans,
+			__entry->last_unlink_trans, __entry->last_reflink_trans,
+			__entry->last_sub_trans, __entry->last_log_commit,
+			__entry->logging_new_name, __entry->logging_new_delayed_dentries,
+			__entry->is_conflict_inode, __entry->log_mode,
+			__entry->full_sync, __entry->copy_everything, __entry->no_xattrs,
+			__print_symbolic(__entry->log_mode, LOG_MODES))
+);
+
+TRACE_EVENT(btrfs_log_inode_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans, struct btrfs_inode *inode,
+		 int ret),
+
+	TP_ARGS(trans, inode, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,    	root_objectid		)
+		__field(	u64,		ino			)
+		__field(	u64,		transid			)
+		__field(	u64,		logged_trans		)
+		__field(	u64,		last_reflink_trans	)
+		__field(	int,		last_sub_trans		)
+		__field(	int,		last_log_commit		)
+		__field(	int,		ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid			= btrfs_root_id(inode->root);
+		__entry->ino				= btrfs_ino(inode);
+		__entry->transid			= trans->transid;
+		spin_lock(&inode->lock);
+		__entry->logged_trans			= inode->logged_trans;
+		__entry->last_reflink_trans		= inode->last_reflink_trans;
+		__entry->last_sub_trans			= inode->last_sub_trans;
+		__entry->last_log_commit		= inode->last_log_commit;
+		spin_unlock(&inode->lock);
+		__entry->ret				= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu transid=%llu logged_trans=%llu"
+			" last_reflink_trans=%llu last_sub_trans=%d"
+			" last_log_commit=%d ret=%d",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			__entry->transid, __entry->logged_trans,
+			__entry->last_reflink_trans, __entry->last_sub_trans,
+			__entry->last_log_commit, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

