Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E398380FD3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864455; cv=none; b=QXQJD+nvf9mXPAERLk6SvJpIYeV6RBc1OAl6qb2OtXNHzgIHWTIWehmlEnOObPNxAB9LA3J1SH5AGFY6HqGrDDTq5ZS6DyABVBUkUZHZOY+Izi7D/2LnI3vIYzazqVHYwX5r7JmOiV8EvFBLm9O8iUtl0QDfyC7aWyNWofurZcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864455; c=relaxed/simple;
	bh=xR2NgJMEoPpgm4BVHzG4XLLtGX4RKuThpQYRoD2tEak=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSP0WMyDnOTMTaz2D5kJgsQMMPMd+mYGoAuFyG1ervK3gacJOlGXf0n7jidKc1ceeuM+h5w2kX88lWFqkN6orwSRG6MKtCJgJZ4UVcUx3EA5baQJbbXa1GXBMSAzofG7DHuwPibvpWz0tQ+H/nNYT0RXmfj74naYWmphPjdKDeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFBgL1N+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFBgL1N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCFCC2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864455;
	bh=xR2NgJMEoPpgm4BVHzG4XLLtGX4RKuThpQYRoD2tEak=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IFBgL1N+y+aqEbO1dEGgWB56RJcTuotS/ywR5c1OC3BWe+vIJB5mFZ3kDVpMyLKht
	 ou2Qn3+oxuyY5a88Qgd5fc8QOp2dcpfK0iSQ0b756kkIyPcqYKnPhgebtOGlaixlju
	 4DLCZTcNZTBdPPM4AfVB6BpN8vdmzbI7NdLNHZDEz7IOo/pfWOfZDxCiBzNh/1lskv
	 K0r8Q4M90zur9R6V7v9BwagHc+Ez0yr8tMeVeaHsMieqx3CFGrAw5BfoT+ltUBp5yl
	 ivb8NurjnU7supcgXsAPX1cOgWqFPrRToCyFEndCo+qyxRp8Qq/hIhRmGNMcPH96R5
	 qDBW5aGYvpbQQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 27/28] btrfs: tracepoints: add trace event for btrfs_sync_log()
Date: Fri, 15 May 2026 18:00:24 +0100
Message-ID: <a9ca387993d128d3c2d611f2f249d6aae24a2c97.1778776707.git.fdmanana@suse.com>
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

btrfs_sync_log() is one of the main functions called during a fsync.
Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 15 +++++++
 include/trace/events/btrfs.h | 85 ++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 807747725509..bcccddcc568c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3322,8 +3322,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	u64 log_root_level;
 
 	mutex_lock(&root->log_mutex);
+	trace_btrfs_sync_log_enter(trans, root, ctx);
 	log_transid = ctx->log_transid;
 	if (root->log_transid_committed >= log_transid) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
 		mutex_unlock(&root->log_mutex);
 		return ctx->log_ret;
 	}
@@ -3331,6 +3333,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	index1 = log_transid % 2;
 	if (atomic_read(&root->log_commit[index1])) {
 		wait_log_commit(root, log_transid);
+		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
 		mutex_unlock(&root->log_mutex);
 		return ctx->log_ret;
 	}
@@ -3359,6 +3362,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	/* bail out if we need to do a full commit */
 	if (btrfs_need_log_full_commit(trans)) {
 		ret = BTRFS_LOG_FORCE_COMMIT;
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		mutex_unlock(&root->log_mutex);
 		goto out;
 	}
@@ -3385,6 +3389,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (ret == -EAGAIN && btrfs_is_zoned(fs_info))
 		ret = 0;
 	if (ret) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		blk_finish_plug(&plug);
 		btrfs_set_log_full_commit(trans);
 		mutex_unlock(&root->log_mutex);
@@ -3422,6 +3427,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		if (!log_root_tree->node) {
 			ret = btrfs_alloc_log_tree_node(trans, log_root_tree);
 			if (ret) {
+				trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 				mutex_unlock(&fs_info->tree_root->log_mutex);
 				blk_finish_plug(&plug);
 				goto out;
@@ -3445,6 +3451,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 */
 	ret = update_log_root(trans, log, &new_root_item);
 	if (ret) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		list_del_init(&root_log_ctx.list);
 		blk_finish_plug(&plug);
 		btrfs_set_log_full_commit(trans);
@@ -3462,6 +3469,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		list_del_init(&root_log_ctx.list);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = root_log_ctx.log_ret;
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		goto out;
 	}
 
@@ -3473,6 +3481,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		mutex_unlock(&log_root_tree->log_mutex);
 		if (!ret)
 			ret = root_log_ctx.log_ret;
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		goto out;
 	}
 	ASSERT(root_log_ctx.log_transid == log_root_tree->log_transid,
@@ -3494,6 +3503,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = BTRFS_LOG_FORCE_COMMIT;
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		goto out_wake_log_root;
 	}
 
@@ -3507,11 +3517,13 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * deadlock. Bail out to the full commit instead.
 	 */
 	if (ret == -EAGAIN && btrfs_is_zoned(fs_info)) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		btrfs_set_log_full_commit(trans);
 		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
 		goto out_wake_log_root;
 	} else if (ret) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		btrfs_set_log_full_commit(trans);
 		mutex_unlock(&log_root_tree->log_mutex);
 		goto out_wake_log_root;
@@ -3521,6 +3533,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		ret = btrfs_wait_tree_log_extents(log_root_tree,
 						  EXTENT_DIRTY_LOG1 | EXTENT_DIRTY_LOG2);
 	if (ret) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		btrfs_set_log_full_commit(trans);
 		mutex_unlock(&log_root_tree->log_mutex);
 		goto out_wake_log_root;
@@ -3557,6 +3570,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 */
 	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		ret = -EIO;
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		btrfs_set_log_full_commit(trans);
 		btrfs_abort_transaction(trans, ret);
 		mutex_unlock(&fs_info->tree_log_mutex);
@@ -3568,6 +3582,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	ret = write_all_supers(trans);
 	mutex_unlock(&fs_info->tree_log_mutex);
 	if (unlikely(ret)) {
+		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		btrfs_set_log_full_commit(trans);
 		btrfs_abort_transaction(trans, ret);
 		goto out_wake_log_root;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4e5bb434f53a..2285f5156f29 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1547,6 +1547,91 @@ TRACE_EVENT(btrfs_log_new_name_exit,
 			__entry->ino, __entry->old_dir_ino, __entry->ret)
 );
 
+/* Ideally call this while under root->log_mutex (but not always possible). */
+TRACE_EVENT(btrfs_sync_log_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_root *root,
+		 const struct btrfs_log_ctx *ctx),
+
+	TP_ARGS(trans, root, ctx),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	int,	 	ctx_log_transid		)
+		__field(	int,		root_log_transid	)
+		__field(	int,	 	log_transid_committed	)
+		__field(	bool,	 	log_committing		)
+		__field(	bool,	 	log_committing_prev	)
+		__field(	int,		log_writers		)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(root);
+		__entry->transid		= trans->transid;
+		__entry->ctx_log_transid	= ctx->log_transid;
+		__entry->root_log_transid	= btrfs_get_root_log_transid(root);
+		__entry->log_transid_committed	=
+			data_race(root->log_transid_committed);
+		__entry->log_committing		=
+			atomic_read(&root->log_commit[ctx->log_transid % 2]);
+		__entry->log_committing_prev	=
+			atomic_read(&root->log_commit[(ctx->log_transid + 1) % 2]);
+		__entry->log_writers		= atomic_read(&root->log_writers);
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_log_transid=%d"
+			" root_log_transid=%d log_transid_committed=%d"
+			" log_committing=%d log_committing_prev=%d log_writers=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ctx_log_transid, __entry->root_log_transid,
+			__entry->log_transid_committed, __entry->log_committing,
+			__entry->log_committing_prev, __entry->log_writers)
+);
+
+/*
+ * Ideally call this while under root->log_mutex and in the same critical
+ * section that calls the btrfs_sync_log_enter() trace event (though it's not
+ * always possible).
+ */
+TRACE_EVENT(btrfs_sync_log_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_root *root,
+		 const struct btrfs_log_ctx *ctx,
+		 int ret),
+
+	TP_ARGS(trans, root, ctx, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	int,	 	ctx_log_transid		)
+		__field(	int,		root_log_transid	)
+		__field(	int,	 	log_transid_committed	)
+		__field(	int,		ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(root);
+		__entry->transid		= trans->transid;
+		__entry->ctx_log_transid	= ctx->log_transid;
+		__entry->root_log_transid	= btrfs_get_root_log_transid(root);
+		__entry->log_transid_committed	=
+			data_race(root->log_transid_committed);
+		__entry->ret			= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_log_transid=%d"
+			" root_log_transid=%d log_transid_committed=%d ret=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ctx_log_transid, __entry->root_log_transid,
+			__entry->log_transid_committed, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

