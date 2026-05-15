Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FA02F7F14
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864448; cv=none; b=oR9hSJ0pnaE1D1z0F7Qhllj0exhrjBw1bgQMDV0AY0ZG+1m2BDX7joYkVKSnRwpFNCDYoQfor8hROpMeez4Gh9o68bBtvb2HT8YkQ8drRAi/Lk4NkJGypbEjc/kdYJJIeIvwo96c5zUTwDZSbCl1GnpCw9+injugMyzUHAXxH4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864448; c=relaxed/simple;
	bh=lynX7/KMsYzIC5gVykboE1siqzajSpjaMVA92D2tNAk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZVSzwcCyex3jyCC5LbZk2VrLw8Ai9p5LsGAOhB4qa7pvZjDcGZiFaDuaFwPLsQ8PjloLbA4GhX3YEO94KS1vtUXZu0mAKxVuiRzz0yJ8yaYE45bz1uN5GXYKyrCiRRyNciBkn6F0oP1KsP5uT1kQNSaf84M8oXyi74fUq8HSuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pv+giMuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pv+giMuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2473FC2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864448;
	bh=lynX7/KMsYzIC5gVykboE1siqzajSpjaMVA92D2tNAk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pv+giMuLSfywevN7t+ShySTGcOAeheHjjXnpWDL3V5S22cDHnmzrqnWrdKzAcLxpW
	 qZQAxlK6URirTqU5LI74a4J15evOHCpqaskfHbJHVAAjXwqA2ctTMZANOHW/wVWjUE
	 8ZxDusMH+yLZMp/aalokggC11kDUbh/H15gtt/furSHu5ENDAkNiLof6AfW7o3OO+k
	 9xI1i4d8Vur/v/0dhro4xC+OwBZD2EuyjGb+NPvyHPUPGnPmqH76QPblDgwV2csG9K
	 bfPoCO4w7ghvlwjNNwVqgkeRynzO8vyDLWgFLOuV8KFKfN2Jf4/a2x47zS+oKJ1jFf
	 H0ASrpoRfrciQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 20/28] btrfs: tracepoints: add trace event for log_conflicting_inodes()
Date: Fri, 15 May 2026 18:00:17 +0100
Message-ID: <3430c22c27c7aaae80238db5e863a018fe8492c2.1778776707.git.fdmanana@suse.com>
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

log_conflicting_inodes() is an important step called during a fsync, as
well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          |  9 ++++++
 include/trace/events/btrfs.h | 53 ++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8e2a2b8982d7..dab1452dc4d1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6262,7 +6262,15 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 	if (ctx->logging_conflict_inodes)
 		return 0;
 
+	/*
+	 * Avoid any work if no conflicting inodes and emitting the trace event
+	 * which only adds noise and it's useless if there are no inodes.
+	 */
+	if (list_empty(&ctx->conflict_inodes))
+		return 0;
+
 	ctx->logging_conflict_inodes = true;
+	trace_btrfs_log_conflicting_inodes_enter(trans, ctx);
 
 	/*
 	 * New conflicting inodes may be found and added to the list while we
@@ -6356,6 +6364,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 	ctx->logging_conflict_inodes = false;
 	if (ret)
 		free_conflicting_inodes(ctx);
+	trace_btrfs_log_conflicting_inodes_exit(trans, ctx, ret);
 
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a10901b94f0d..8fd18365a3ac 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1294,6 +1294,59 @@ TRACE_EVENT(btrfs_add_conflicting_inode_exit,
 			__entry->conflict_ino_parent, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_conflicting_inodes_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_log_ctx *ctx),
+
+	TP_ARGS(trans, ctx),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ctx_ino			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(ctx->inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ctx_ino		= btrfs_ino(ctx->inode);
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ctx_ino)
+);
+
+TRACE_EVENT(btrfs_log_conflicting_inodes_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_log_ctx *ctx,
+		 int ret),
+
+	TP_ARGS(trans, ctx, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ctx_ino			)
+		__field(	int,		ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(ctx->inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ctx_ino		= btrfs_ino(ctx->inode);
+		__entry->ret			= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu ret=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ctx_ino, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

