Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ED333ADBF
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724117; cv=none; b=m6KRuns4vgksSPCHqVJNF+Xz/JAhxogsWYy9Oi6O7QgtRCW0y6vB56yYL/DYyeCdUdd68dLLU2tZs6d3p5dmtKWBJkreoo6bAigd9wXtM/NcZ77RKfXkzP+D2bCVFgDfxI4dn+oOdRN4jWO8M5OgQdxehqQvUZyfdAod+QfxzIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724117; c=relaxed/simple;
	bh=DIrdL2zRChfwB8P/JT1FcZMq7/Wtu1Vg7Le9UJsNTNA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncxOvGa7E5b9uVl+MRMZtsUlawyr3NgkRddGyWnNQdXz4aNdOS5gkOjfaYNZAAmHNwXpiXTVj0zPNXpTxm3sPyQZyswNO6SgNbCAVFWoU4EHzuztTSrqkaVDzvdEUrS9OODJb0JDIKyKG1GMsjgZyCUyZtK2tN8U8wxBjXU+E14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/P/3EMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/P/3EMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992C31F00AC4
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724111;
	bh=VTRwoASwdtzSDcQ1YWAKAcP9U/xx9lk8QI7FiEwvsfQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=L/P/3EMyHNDx2QA/Ecl5h4f+yx1s1Qfsqd8uvRzAJT5hYp9ItwF1V8n+9zdMA5GEg
	 qTH+FvypYQUyrrJxC8uUOFHuoIRe5dDYR4/tkr1K0AEMitbDID0W/ZArfLa/0ki+RO
	 2/mB46E7PUJKXGPYy/r7UTk+dyWo1OgYEnT5d8S5CY3SEXEdWxuLQVPksSjvaO2LJK
	 GCitCqqGUR8dcWOL5UVgw8tExBZLFVUc7/YB4t1bNYM+MXnoDkhrqg8luZ4Im5rvOo
	 YrxD1n6ZEdYgbxk/CJeJs1b+dOIWyl8ha1l2u6bjfo1vv0AVSPHUD5ABvtn4ZqnWQB
	 nOtB/vqvgmNwg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] btrfs: move condition for log commit wait into wait_log_commit()
Date: Wed, 22 Jul 2026 13:41:41 +0100
Message-ID: <08265bae62c5366ec73e1f958863ba2449270215.1784656641.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1784656641.git.fdmanana@suse.com>
References: <cover.1784656641.git.fdmanana@suse.com>
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
 fs/btrfs/tree-log.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 08af1e66c758..f33392da78ef 100644
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
@@ -3298,8 +3296,6 @@ static inline void btrfs_remove_all_log_ctxs(struct btrfs_root *root,
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		   struct btrfs_root *root, struct btrfs_log_ctx *ctx)
 {
-	int index1;
-	int index2;
 	int mark;
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -3307,6 +3303,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
 	struct btrfs_root_item new_root_item;
 	int log_transid = ctx->log_transid;
+	int index1 = log_transid % 2;
+	int index2;
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
 	u64 log_root_start;
@@ -3327,9 +3325,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		return ctx->log_ret;
 	}
 
-	index1 = log_transid % 2;
-	if (atomic_read(&root->log_commit[index1])) {
-		wait_log_commit(root, log_transid);
+	if (wait_log_commit(root, log_transid)) {
 		trace_btrfs_sync_log_exit(trans, root, ctx, ctx->log_ret);
 		mutex_unlock(&root->log_mutex);
 		return ctx->log_ret;
@@ -3339,8 +3335,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	atomic_set(&root->log_commit[index1], 1);
 
 	/* wait for previous tree log sync to complete */
-	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
-		wait_log_commit(root, log_transid - 1);
+	wait_log_commit(root, log_transid - 1);
 
 	wait_for_writer(root);
 
@@ -3473,10 +3468,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
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

