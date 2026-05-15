Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436C74F7999
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864442; cv=none; b=lC2mbViwaexejRCyvnFL61kwbAO3c6ZImJilPwhIBHdswRBZuakMZrg8nqQFtyDZXxRTxlgWV+wKZi7EPH3n5F+I+ha55fE8XAbaNMOTAMzrXQYvSJAqVDCaeabOu32glNwgF5GmzNfJnwKT8XkcwkB0p9aYdXZQnjimdINKkkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864442; c=relaxed/simple;
	bh=xGHV2DfT+Tg+sam4bdkC2a49o92cMKwqR5s3wtUswJw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhYnfWXKMHHs0DaBq+vpIWUhF0pm7AP0B5ATsRFirqZm6/XGhP8c8Rkb6AlEa73PSG4e8vMhVIKKTDQEv02vQZPyKsI+rLkyN6raKF4QMa4a/ClA4lnBv/4G957xsXI7KHsFXa0PIQ8Nqi7vM0NBCkyI9QJj0OKPfN6/yMkCiJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5TvFqLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5TvFqLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C5EC2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864442;
	bh=xGHV2DfT+Tg+sam4bdkC2a49o92cMKwqR5s3wtUswJw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p5TvFqLu1rM7efVzJwRSkHxfbmZv9XqvnSpjNKQEOz+rJhPyzFOb9weouu8em2QPY
	 P79ySeYrWLMfpZeKpDJl9DW857gcM+85lzoGRPxhaGJAysxxi+u9tTgoiTBjVR6hAy
	 7tGPFMLxc47KiCraW5Um9vaUpvo7io+hOl0dsdQQSa90NAYS4j3wRYHvDRPp14JlKY
	 j+g2pVWVU7b2MaIKR/p5GEh7xHf89uSOUAePWL3N1KPCLg56YrZATog9ihcAu3s7LT
	 JDCF9ORKG4vuYAGaiF/OLrtowZr6CJyKF5Jg3wiwA/RGZRvF6GWsalWUwUx+ADRa4V
	 HPSRNGTj+pvDA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/28] btrfs: tracepoints: add trace event for btrfs_log_inode_parent()
Date: Fri, 15 May 2026 18:00:10 +0100
Message-ID: <a349800228e2f25fb003d2a71ad9bea62c20841a.1778776707.git.fdmanana@suse.com>
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

btrfs_log_inode_parent() is one of the most important steps called during
a fsync operation as well as during rename and link operations on inodes
that were previously logged. Add trace events for when entering and
exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 31 +++++++++----
 include/trace/events/btrfs.h | 85 ++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9123adafa0d1..f03bc6588210 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7541,27 +7541,37 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	bool log_dentries;
 
-	if (btrfs_test_opt(fs_info, NOTREELOG))
-		return BTRFS_LOG_FORCE_COMMIT;
+	trace_btrfs_log_inode_parent_enter(trans, inode);
 
-	if (btrfs_root_refs(&root->root_item) == 0)
-		return BTRFS_LOG_FORCE_COMMIT;
+	if (btrfs_test_opt(fs_info, NOTREELOG)) {
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
+	}
+
+	if (btrfs_root_refs(&root->root_item) == 0) {
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
+	}
 
 	/*
 	 * If we're logging an inode from a subvolume created in the current
 	 * transaction we must force a commit since the root is not persisted.
 	 */
-	if (btrfs_root_generation(&root->root_item) == trans->transid)
-		return BTRFS_LOG_FORCE_COMMIT;
+	if (btrfs_root_generation(&root->root_item) == trans->transid) {
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
+	}
 
 	/* Skip already logged inodes and without new extents. */
 	if (btrfs_inode_in_log(inode, trans->transid) &&
-	    list_empty(&ctx->ordered_extents))
-		return BTRFS_NO_LOG_SYNC;
+	    list_empty(&ctx->ordered_extents)) {
+		ret = BTRFS_NO_LOG_SYNC;
+		goto out;
+	}
 
 	ret = start_log_trans(trans, root, ctx);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = btrfs_log_inode(trans, inode, inode_only, ctx);
 	if (ret)
@@ -7649,6 +7659,9 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		btrfs_remove_log_ctx(root, ctx);
 	btrfs_end_log_trans(root);
 
+out:
+	trace_btrfs_log_inode_parent_exit(trans, inode, ret);
+
 	return ret;
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1b19364eabff..cd127c79a535 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -34,6 +34,16 @@ struct find_free_extent_ctl;
 struct btrfs_trans_handle;
 struct btrfs_transaction;
 
+#define show_inode_type(mode)					\
+	__print_symbolic((mode) & S_IFMT,			\
+		 { S_IFDIR,  "DIR" },	          		\
+		 { S_IFREG,  "REG" },	          		\
+		 { S_IFLNK,  "LNK" },	          		\
+		 { S_IFIFO,  "FIFO" },	          		\
+		 { S_IFCHR,  "CHR" },		  		\
+		 { S_IFBLK,  "BLK" },	          		\
+		 { S_IFSOCK, "SOCK" })
+
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
 		{ BTRFS_TREE_BLOCK_REF_KEY, 	"TREE_BLOCK_REF" },	\
@@ -866,6 +876,81 @@ TRACE_EVENT(btrfs_sync_file_exit,
 			__entry->ino, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_inode_parent_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans, struct btrfs_inode *inode),
+
+	TP_ARGS(trans, inode),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,	 	ino			)
+		__field(	umode_t,	mode			)
+		__field(	u64,		transid			)
+		__field(	u64,		generation		)
+		__field(	u64,		logged_trans		)
+		__field(	u64,		last_unlink_trans	)
+		__field(	int,		last_sub_trans		)
+		__field(	int,		inode_last_log_commit	)
+		__field(	int,		root_last_log_commit	)
+	),
+
+	TP_fast_assign(
+		struct btrfs_root *root = inode->root;
+
+		TP_fast_assign_fsid(root->fs_info);
+		__entry->root_objectid		= btrfs_root_id(root);
+		__entry->ino			= btrfs_ino(inode);
+		__entry->mode			= inode->vfs_inode.i_mode;
+		__entry->transid		= trans->transid;
+		__entry->generation		= inode->generation;
+		spin_lock(&inode->lock);
+		__entry->logged_trans		= inode->logged_trans;
+		__entry->last_unlink_trans	= inode->last_unlink_trans;
+		__entry->last_sub_trans		= inode->last_sub_trans;
+		__entry->inode_last_log_commit	= inode->last_log_commit;
+		spin_unlock(&inode->lock);
+		__entry->root_last_log_commit	= btrfs_get_root_last_log_commit(root);
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu type=%s transid=%llu gen=%llu"
+			" logged_trans=%llu last_unlink_trans=%llu last_sub_trans=%d"
+			" inode_last_log_commit=%d root_last_log_commit=%d",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			show_inode_type(__entry->mode), __entry->transid,
+			__entry->generation, __entry->logged_trans,
+			__entry->last_unlink_trans, __entry->last_sub_trans,
+			__entry->inode_last_log_commit, __entry->root_last_log_commit)
+);
+
+TRACE_EVENT(btrfs_log_inode_parent_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode,
+		 int ret),
+
+	TP_ARGS(trans, inode, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid	)
+		__field(	u64,	 	ino		)
+		__field(	u64,		transid		)
+		__field(	int,		ret		)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->ino			= btrfs_ino(inode);
+		__entry->transid		= trans->transid;
+		__entry->ret			= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu transid=%llu ret=%d",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			__entry->transid, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

