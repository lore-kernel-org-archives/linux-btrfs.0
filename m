Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189542F7F05
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864448; cv=none; b=NDlMhWc3pxbQhtHZRlc4OZ0WrKrHT9orHROCQ5Jse/t1lVMZ6FgDHF0MnO53oNGjKx+3LYDd3JmfRT3e8dc5yXIQC02JzTZKADf7wthcy+xG0uKiNWaqlgpPCGilAModhJ0ZWY7vCDLzlfV8h8qV3TYwAlanlda86KyJ/Ownfxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864448; c=relaxed/simple;
	bh=zLLXKTs/PcivD3VszKsUS2BRbgE4OdYreKfF/IZkM+Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXeWFHFMxNkjZF3CNTboNx4pW/R9EPUBGQICC6YCbdNqNP165isAPaAclJDUAbgZWQFapwFPxFc6URm/++JEBMTSerRHLmoQcnv7dIdcbaywIE0RoYu+vW56LRukvchfV1sAYFuBfHWVyMnDOLJlkFQLARO3vLZmg1tE7L/ygj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SK5qbkep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SK5qbkep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319D0C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864447;
	bh=zLLXKTs/PcivD3VszKsUS2BRbgE4OdYreKfF/IZkM+Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SK5qbkepNhH4vD9XZcnRasL+FgtS4UBvLaV41d6qJOJy09sITmS4Xjj/tq0bUtlnZ
	 xxI0zn0GSQnuh7HkcEC0Igp55l2VH7VVpEey/NIokAsNCHs+YDpjXo5OWU0dLsyTH3
	 yVPPD0FHHJ4bnGkrteLO6xP740lw2wW5w/gzGw9eY+2LBdWQkcZC6L2/pO2Ly59pCF
	 HzXS0yKo30RVTYbZ/MaJVC9KY7D6mb1ipNsZRCnEkr68jWyebJxo50+XxFrVwdO0A5
	 m7ep+7BxsFMflktRuzC8jiahoEhXo4fULGJP2k/4O7NEjpUkUI0I7cw88WZLinJ6DH
	 Mn/LG/4aef+FQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 19/28] btrfs: tracepoints: add trace event for add_conflicting_inode()
Date: Fri, 15 May 2026 18:00:16 +0100
Message-ID: <238c79ed66ab85e05394448aeddf91899839ca22.1778776707.git.fdmanana@suse.com>
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

add_conflicting_inode() is an important step called during a fsync, as
well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 39 ++++++++++++++-------
 include/trace/events/btrfs.h | 66 ++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 44c7d250b810..8e2a2b8982d7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6121,6 +6121,9 @@ static int add_conflicting_inode(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_ino_list *ino_elem;
 	struct btrfs_inode *inode;
+	int ret = 0;
+
+	trace_btrfs_add_conflicting_inode_enter(trans, ctx, ino, parent);
 
 	/*
 	 * It's rare to have a lot of conflicting inodes, in practice it is not
@@ -6129,8 +6132,10 @@ static int add_conflicting_inode(struct btrfs_trans_handle *trans,
 	 * LOG_INODE_EXISTS mode) and slow down other fsyncs or transaction
 	 * commits.
 	 */
-	if (ctx->num_conflict_inodes >= MAX_CONFLICT_INODES)
-		return BTRFS_LOG_FORCE_COMMIT;
+	if (ctx->num_conflict_inodes >= MAX_CONFLICT_INODES) {
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
+	}
 
 	inode = btrfs_iget_logging(ino, root);
 	/*
@@ -6157,23 +6162,25 @@ static int add_conflicting_inode(struct btrfs_trans_handle *trans,
 		int ret = PTR_ERR(inode);
 
 		if (ret != -ENOENT)
-			return ret;
+			goto out;
 
 		ret = conflicting_inode_is_dir(root, ino, path);
 		/* Not a directory or we got an error. */
 		if (ret <= 0)
-			return ret;
+			goto out;
 
 		/* Conflicting inode is a directory, so we'll log its parent. */
 		ino_elem = kmalloc_obj(*ino_elem, GFP_NOFS);
-		if (!ino_elem)
-			return -ENOMEM;
+		if (!ino_elem) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		ino_elem->ino = ino;
 		ino_elem->parent = parent;
 		list_add_tail(&ino_elem->list, &ctx->conflict_inodes);
 		ctx->num_conflict_inodes++;
-
-		return 0;
+		ret = 0;
+		goto out;
 	}
 
 	/*
@@ -6213,25 +6220,31 @@ static int add_conflicting_inode(struct btrfs_trans_handle *trans,
 	 */
 	if (!need_log_inode(trans, inode)) {
 		btrfs_add_delayed_iput(inode);
-		return 0;
+		goto out;
 	}
 
 	if (!can_log_conflicting_inode(trans, inode)) {
 		btrfs_add_delayed_iput(inode);
-		return BTRFS_LOG_FORCE_COMMIT;
+		ret = BTRFS_LOG_FORCE_COMMIT;
+		goto out;
 	}
 
 	btrfs_add_delayed_iput(inode);
 
 	ino_elem = kmalloc_obj(*ino_elem, GFP_NOFS);
-	if (!ino_elem)
-		return -ENOMEM;
+	if (!ino_elem) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ino_elem->ino = ino;
 	ino_elem->parent = parent;
 	list_add_tail(&ino_elem->list, &ctx->conflict_inodes);
 	ctx->num_conflict_inodes++;
 
-	return 0;
+out:
+	trace_btrfs_add_conflicting_inode_exit(trans, ctx, ino, parent, ret);
+
+	return ret;
 }
 
 static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index c13c1ce0b344..a10901b94f0d 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1228,6 +1228,72 @@ TRACE_EVENT(btrfs_log_new_dir_dentries_exit,
 			__entry->transid, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_add_conflicting_inode_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_log_ctx *ctx,
+		 u64 ino, u64 parent),
+
+	TP_ARGS(trans, ctx, ino, parent),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ctx_ino			)
+		__field(	u64,	 	conflict_ino		)
+		__field(	u64,	 	conflict_ino_parent	)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(ctx->inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ctx_ino		= btrfs_ino(ctx->inode);
+		__entry->conflict_ino		= ino;
+		__entry->conflict_ino_parent	= parent;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu conflic_ino=%llu"
+			" conflict_ino_parent=%llu",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ctx_ino, __entry->conflict_ino,
+			__entry->conflict_ino_parent)
+);
+
+TRACE_EVENT(btrfs_add_conflicting_inode_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_log_ctx *ctx,
+		 u64 ino, u64 parent, int ret),
+
+	TP_ARGS(trans, ctx, ino, parent, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ctx_ino			)
+		__field(	u64,	 	conflict_ino		)
+		__field(	u64,	 	conflict_ino_parent	)
+		__field(	int,	 	ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(ctx->inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ctx_ino		= btrfs_ino(ctx->inode);
+		__entry->conflict_ino		= ino;
+		__entry->conflict_ino_parent	= parent;
+		__entry->ret			= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu conflic_ino=%llu"
+			" conflict_ino_parent=%llu ret=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ctx_ino, __entry->conflict_ino,
+			__entry->conflict_ino_parent, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

