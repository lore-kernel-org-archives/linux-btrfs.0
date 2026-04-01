Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033812FD1AA
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775066278; cv=none; b=rXeIgZIo6afecU1kNcjP5cOgTe2UBm0R7gdPU11D59Mmjxt3SuJWHX31po71pqiu7ZcrJ4burud1tV9Rwfn3KQkPSvE0KyIwOvrLR6uxoxb1VlLBiJXteWQCcPwYKFZa3cxEYglK7CCG1utcGIToR5DEr/axlff4cx5hg64cVrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775066278; c=relaxed/simple;
	bh=2Hy+OkaZBDVxYN3ggzF5YQWHDbeAxxdwrZEQskfNrhc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ACE2v1Xy6uYaBb3B9XIH2ZMIFzUfGKVS21IUwGZOvhZ9AB2EKS+H5096Ll9Qyd8Y3oAxyhs+AiuQgTQVt4SNqvnHfNJ1PkzWfbVzcVIdYJNtkkfdngAQytlWdEWmoVi9JkEFedRf9ZJyIe8sJX5vHjRD8+LYhrsTCfqzzA/nknE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFxgwS8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFxgwS8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA85C4CEF7
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775066277;
	bh=2Hy+OkaZBDVxYN3ggzF5YQWHDbeAxxdwrZEQskfNrhc=;
	h=From:To:Subject:Date:From;
	b=PFxgwS8QzoDgh+5icepAooDSPMZnXpQVcGh2ElyXet2Sx9hvySWKzvw9zEEXM2dbc
	 XJu8Uy5dqQziYCgY+dWhLYAcHSs47hdOJe2zvBCDDdDlaCY608dvYg0oXyWpHB+hLO
	 264uRyOHO+9HUHu52XgrECy084UZ1JP+pFKfWQLCU5NAzr8zaxsSisZy3dlF+Tbfww
	 MI/rbmCXrw6z+wnBWwxxR+RBwhwuFVbraSLigOZfYq2QbtiFka39kk7f2YNmBXbbjp
	 GZV23siqMoiv41UKtCtiJStcvCPPJExwVYoH/FKb7Ee63CMzVdS4Pp0Sm2wjHhNmcs
	 krYei3H+Lz4qQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tag as unlikely if statements that check for fs in error state
Date: Wed,  1 Apr 2026 18:57:53 +0100
Message-ID: <8ea3a7a9c3c4e6123925646fa6484f6ba1524173.1775066198.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Having the filesystem in an error state, meaning we had a transaction
abort, is unexpected. Mark every check for the error state with the
unlikely annotation to convey that and to allow the compiler to generate
better code.

On x86_64, using gcc 14.2.0-19 from Debian, resulted in a sligthly
reduced object size and better code.

Before:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2008598	 175912	  15592	2200102	 219226	fs/btrfs/btrfs.ko

After:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2008450	 175912	  15592	2199954	 219192	fs/btrfs/btrfs.ko

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c     |  6 +++---
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/messages.c    |  2 +-
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/super.c       |  2 +-
 fs/btrfs/transaction.c | 10 +++++-----
 fs/btrfs/tree-log.c    |  2 +-
 fs/btrfs/volumes.c     |  2 +-
 10 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 14ce9bfc981b..f26b6b8810f3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1556,7 +1556,7 @@ static int transaction_kthread(void *arg)
 		wake_up_process(fs_info->cleaner_kthread);
 		mutex_unlock(&fs_info->transaction_kthread_mutex);
 
-		if (BTRFS_FS_ERROR(fs_info))
+		if (unlikely(BTRFS_FS_ERROR(fs_info)))
 			btrfs_cleanup_transaction(fs_info);
 		if (!kthread_should_stop() &&
 				(!btrfs_transaction_blocked(fs_info) ||
@@ -4148,7 +4148,7 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 		drop_ref = true;
 	spin_unlock(&fs_info->fs_roots_radix_lock);
 
-	if (BTRFS_FS_ERROR(fs_info)) {
+	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		ASSERT(root->log_root == NULL);
 		if (root->reloc_root) {
 			btrfs_put_root(root->reloc_root);
@@ -4276,7 +4276,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * extents.  This will generate delayed iputs, thus we want to handle
 	 * it first.
 	 */
-	if (unlikely(BTRFS_FS_ERROR(fs_info)))
+	if (BTRFS_FS_ERROR(fs_info))
 		btrfs_error_commit_super(fs_info);
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9d7ca80477fd..1ba8a7d3587b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2400,7 +2400,7 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 	 * and it only returns 0 or errors.
 	 */
 	ASSERT(ret <= 0);
-	if (!ret && BTRFS_FS_ERROR(fs_info))
+	if (unlikely(!ret && BTRFS_FS_ERROR(fs_info)))
 		ret = -EROFS;
 
 	if (ctx.zoned_bg)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 06cc6e13cb62..cf1cb5c4db75 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1445,7 +1445,7 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, struct iov_iter *from,
 	 * have opened a file as writable, we have to stop this write operation
 	 * to ensure consistency.
 	 */
-	if (BTRFS_FS_ERROR(inode->root->fs_info))
+	if (unlikely(BTRFS_FS_ERROR(inode->root->fs_info)))
 		return -EROFS;
 
 	if (encoded && (iocb->ki_flags & IOCB_NOWAIT))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 769e96dbe639..808e52aa6ef2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8972,7 +8972,7 @@ int btrfs_start_delalloc_snapshot(struct btrfs_root *root, bool in_reclaim_conte
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	if (BTRFS_FS_ERROR(fs_info))
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
 		return -EROFS;
 	return start_delalloc_inodes(root, NULL, true, in_reclaim_context);
 }
@@ -8985,7 +8985,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 	LIST_HEAD(splice);
 	int ret;
 
-	if (BTRFS_FS_ERROR(fs_info))
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
 		return -EROFS;
 
 	mutex_lock(&fs_info->delalloc_root_mutex);
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 6190777924bf..7c60c14e60fa 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -37,7 +37,7 @@ static void btrfs_state_to_string(const struct btrfs_fs_info *info, char *buf)
 	memcpy(curr, STATE_STRING_PREFACE, sizeof(STATE_STRING_PREFACE));
 	curr += sizeof(STATE_STRING_PREFACE) - 1;
 
-	if (BTRFS_FS_ERROR(info)) {
+	if (unlikely(BTRFS_FS_ERROR(info))) {
 		*curr++ = 'E';
 		states_printed = true;
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0234971894fa..1ac609239cbe 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2974,7 +2974,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 	struct page *page;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
-	if (BTRFS_FS_ERROR(fs_info))
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
 		return -EROFS;
 
 	page = alloc_page(GFP_KERNEL);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 52137366b79b..b26aa9169e83 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1299,7 +1299,7 @@ static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 
-	if (BTRFS_FS_ERROR(fs_info)) {
+	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		btrfs_err(fs_info,
 			  "remounting read-write after error is not allowed");
 		return -EINVAL;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4358f4b63057..c9c316ce4bdc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -275,7 +275,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	spin_lock(&fs_info->trans_lock);
 loop:
 	/* The file system has been taken offline. No new transactions. */
-	if (BTRFS_FS_ERROR(fs_info)) {
+	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		spin_unlock(&fs_info->trans_lock);
 		return -EROFS;
 	}
@@ -333,7 +333,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		kfree(cur_trans);
 		goto loop;
-	} else if (BTRFS_FS_ERROR(fs_info)) {
+	} else if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		spin_unlock(&fs_info->trans_lock);
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
@@ -612,7 +612,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	bool do_chunk_alloc = false;
 	int ret;
 
-	if (BTRFS_FS_ERROR(fs_info))
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
 		return ERR_PTR(-EROFS);
 
 	if (current->journal_info) {
@@ -1120,7 +1120,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (throttle)
 		btrfs_run_delayed_iputs(info);
 
-	if (TRANS_ABORTED(trans) || BTRFS_FS_ERROR(info)) {
+	if (unlikely(TRANS_ABORTED(trans) || BTRFS_FS_ERROR(info))) {
 		wake_up_process(info->transaction_kthread);
 		if (TRANS_ABORTED(trans))
 			ret = trans->aborted;
@@ -2351,7 +2351,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		 * abort to prevent writing a new superblock that reflects a
 		 * corrupt state (pointing to trees with unwritten nodes/leafs).
 		 */
-		if (BTRFS_FS_ERROR(fs_info)) {
+		if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 			spin_unlock(&fs_info->trans_lock);
 			ret = -EROFS;
 			goto lockdep_release;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index aa84649f63c2..9123adafa0d1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3566,7 +3566,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * writing the super here would result in transid mismatches.  If there
 	 * is an error here just bail.
 	 */
-	if (BTRFS_FS_ERROR(fs_info)) {
+	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 		ret = -EIO;
 		btrfs_set_log_full_commit(trans);
 		btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d8f2722311c8..16e923987958 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3602,7 +3602,7 @@ int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset, bool v
 		 * If we had a transaction abort, stop all running scrubs.
 		 * See transaction.c:cleanup_transaction() why we do it here.
 		 */
-		if (BTRFS_FS_ERROR(fs_info))
+		if (unlikely(BTRFS_FS_ERROR(fs_info)))
 			btrfs_scrub_cancel(fs_info);
 		return ret;
 	}
-- 
2.47.2

