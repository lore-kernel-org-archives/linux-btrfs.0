Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C3A3859CE
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733897; cv=none; b=pA4rAZHT6pAA3BD9N3EYgRtw5LcDa2Nrftx/TPMHLp2YQfFd5ofbyLnKriITmVWaNMHSCJ0o156NO+QDvVU79NAOAG3mo71sdhqpTux2J6J/qaJRA8W3PDirwYPKoYn0g30KwTIZ7qhfIPN6BUdKdtO5srvnw1hJvOGS/FKPcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733897; c=relaxed/simple;
	bh=1rew5WsP1e0ragZcqvqdPQhisA8/EnM9Pgw0vAlg28U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6BsvLuJxG2sk8vrBxqwFtiquKsAdK2AkPZo/LRgMuM9I4JA2EISr+B3gp+LzUg0WsfuNq67QdPyV1U4WOf2cxyO2EG8KAFzrPz/fJO/yMNvII9pT4TiK57f4MeTN1uDrjUfK3x1Mvj91jBORbnuTERLd7qAI2GfTAPZrHTAL+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwPEYCk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwPEYCk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D761F00A3E
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784733888;
	bh=+Ec1e7Joy0T5k0oJrgtXLMEoLZu2wOEA7yJsJSlDVSA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PwPEYCk9UhFuF+TfAR/smtQU1Bc1QW6mQFu+PSCuKzLh7yc5GhGtWPiCcUcXRIUce
	 hjQQywBFMgGVVTL3HeF45I0xCH7UtbHGTxc8Wa5o4tlCzrcPkDb8gzLGHe5Wtx3bSr
	 hbwniIDMrmYqkxLG9MeEoTzL5etFKhG3cagcUoSg5jto1sOMhio7HcyojaPf42fa0u
	 HZ/wVesM/aqwWqsb0g/p0TWpv1yYRYw90nT8x1d5kbCR2UhhmQ1z5qzMJpfA1t5XMh
	 lDKrCyrLRS2zRVUmHvFbVRg1dNv7rJHRjeeq4bGosj/4Eh3PubqmquKHVhRZaBx51y
	 iNPr1RgU1rGuA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/5] btrfs: move condition for log commit wait into wait_log_commit()
Date: Wed, 22 Jul 2026 16:24:40 +0100
Message-ID: <842ef70c9ca3ddf17f8660ad24f63f6272621afa.1784733396.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784733395.git.fdmanana@suse.com>
References: <cover.1784733395.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Instead of having every caller check for root->log_commit[] being non-zero
and then call wait_log_commit(), move the check into wait_log_commit() and
have the callers call it unconditionally.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 580f2aabc065..b6ed6671ee26 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -221,7 +221,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 static int link_to_fixup_dir(struct walk_control *wc, u64 objectid);
 static noinline int replay_dir_deletes(struct walk_control *wc,
 				       u64 dirid, bool del_all);
-static void wait_log_commit(struct btrfs_root *root, int transid);
+static bool wait_log_commit(struct btrfs_root *root, int transid);
 
 /*
  * tree logging is a special write ahead log used to make sure that
@@ -305,17 +305,13 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 
 again:
 	if (root->log_root) {
-		int index = (root->log_transid + 1) % 2;
-
 		if (btrfs_need_log_full_commit(trans)) {
 			ret = BTRFS_LOG_FORCE_COMMIT;
 			goto out;
 		}
 
-		if (zoned && atomic_read(&root->log_commit[index])) {
-			wait_log_commit(root, root->log_transid - 1);
+		if (zoned && wait_log_commit(root, root->log_transid - 1))
 			goto again;
-		}
 	} else {
 		/*
 		 * This means fs_info->log_root_tree was already created
@@ -363,13 +359,9 @@ static int join_running_log_trans(struct btrfs_root *root)
 	mutex_lock(&root->log_mutex);
 again:
 	if (root->log_root) {
-		int index = (root->log_transid + 1) % 2;
-
 		ret = 0;
-		if (zoned && atomic_read(&root->log_commit[index])) {
-			wait_log_commit(root, root->log_transid - 1);
+		if (zoned && wait_log_commit(root, root->log_transid - 1))
 			goto again;
-		}
 		atomic_inc(&root->log_writers);
 	}
 	mutex_unlock(&root->log_mutex);
@@ -3172,11 +3164,15 @@ static int update_log_root(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void wait_log_commit(struct btrfs_root *root, int transid)
+/* Returns true if we had to wait, false otherwise. */
+static bool wait_log_commit(struct btrfs_root *root, int transid)
 {
 	DEFINE_WAIT(wait);
 	int index = transid % 2;
 
+	if (atomic_read(&root->log_commit[index]) == 0)
+		return false;
+
 	/*
 	 * we only allow two pending log transactions at a time,
 	 * so we know that if ours is more than 2 older than the
@@ -3195,6 +3191,8 @@ static void wait_log_commit(struct btrfs_root *root, int transid)
 		mutex_lock(&root->log_mutex);
 	}
 	finish_wait(&root->log_commit_wait[index], &wait);
+
+	return true;
 }
 
 static void wait_for_writer(struct btrfs_root *root)
@@ -3298,15 +3296,15 @@ static inline void btrfs_remove_all_log_ctxs(struct btrfs_root *root,
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		   struct btrfs_root *root, struct btrfs_log_ctx *ctx)
 {
-	int index1;
-	int index2;
 	int mark;
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
 	struct btrfs_root_item new_root_item;
-	int log_transid = 0;
+	int log_transid = ctx->log_transid;
+	int index1 = log_transid % 2;
+	int index2;
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
 	u64 log_root_start;
@@ -3314,16 +3312,13 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&root->log_mutex);
 	trace_btrfs_sync_log_enter(trans, root, ctx);
-	log_transid = ctx->log_transid;
 	if (root->log_transid_committed >= log_transid) {
 		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
 		mutex_unlock(&root->log_mutex);
 		return ctx->log_ret;
 	}
 
-	index1 = log_transid % 2;
-	if (atomic_read(&root->log_commit[index1])) {
-		wait_log_commit(root, log_transid);
+	if (wait_log_commit(root, log_transid)) {
 		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
 		mutex_unlock(&root->log_mutex);
 		return ctx->log_ret;
@@ -3333,8 +3328,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	atomic_set(&root->log_commit[index1], 1);
 
 	/* wait for previous tree log sync to complete */
-	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
-		wait_log_commit(root, log_transid - 1);
+	wait_log_commit(root, log_transid - 1);
 
 	wait_for_writer(root);
 
@@ -3467,10 +3461,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		root_log_ctx.log_transid, log_root_tree->log_transid);
 	atomic_set(&log_root_tree->log_commit[index2], 1);
 
-	if (atomic_read(&log_root_tree->log_commit[(index2 + 1) % 2])) {
-		wait_log_commit(log_root_tree,
-				root_log_ctx.log_transid - 1);
-	}
+	wait_log_commit(log_root_tree, root_log_ctx.log_transid - 1);
 
 	/*
 	 * now that we've moved on to the tree of log tree roots,
-- 
2.47.2

