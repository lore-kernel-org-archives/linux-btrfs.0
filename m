Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B5032B9B5
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724117; cv=none; b=I/Spgov+Mi/QajdlH1p4ne094HcF+XQvhfNEPDKxtD4ZDDoXMZ8vmrI/CqmRyFpRTg6tti9hsAv2/RWzDGrk6cUsm+O1LHmhUfDch3Ay8kaeB+aFSjpuPsedSQEx48BbexE6ndgbUxXEwrG+Gxcqs8+1NLpzT3hWo4wt019TPPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724117; c=relaxed/simple;
	bh=RWdL3l/xuuNibAjg5LIWMoPGdXu4+IZLu9J8r6dtMv4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhHen1plHQsZMqGvmzL+mWLPWmv+J8P1e3vrhtseOssNPNuHc5/RvO/nQqnFvA6UiIv41B0gFaGcHMFGBzJKpOBfL6PuW/tO2H4s+GNJK1FrSlRh3ANrsjDFRXBgmwqKYycxrQ+cwEHWz2C1qKzdu3qyk2dWXMvVVIde/OxexM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/YGasjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/YGasjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1FB1F00A3D
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724108;
	bh=e+V5VcrH8AsICfwh2A6bCqHeF5vl9p3H8RUlwFEuUA8=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=R/YGasjzOb0eDC7PfeUBypDSNj5t6u9VetR9WmiEjJmQdd8Pi2n0AgsqLvcVd0E+O
	 UpM970X5m2elhbKtt22vtE79LZrI2unZENzCHdzAydBchuoDOd6pn1nkjbFz41AbLK
	 +LrFHTphwKBd/egRLQpgLRVc8bagjTLerMxdwR+Z8NY5tJ/ser6TRFWJaUjKe6LvFi
	 S8kTU93JHlsF6mYn7Zr0onbPxqByRggXEcRCNy+8ToVb5fTtL49cyUUQXiCy2KlhgL
	 207h3d5jQAdsNOtq6cP5DAFN7p60eVNeB2lORDpcqtQftm4EoWoTy8tq4tnZn/TJ9o
	 ANvzATPoyaB+w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] btrfs: remove log batch counter use for fsync
Date: Wed, 22 Jul 2026 13:41:38 +0100
Message-ID: <209626ef986b9ad05af59d99e234c370517f6637.1784656641.git.fdmanana@suse.com>
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

We have the log batch counter defined per root which is now useless after
the previous patch (titled: "btrfs: stop sleeping for one jiffy in non-ssd
mounts during log commit"). The counter is incremented early in the fsync
path, before and after flushing dellaloc and waiting for writeback, and
then the counter is read during the log sync path. The goal was to wait
for tasks that are about to join a log transaction, so that we could
reduce the amount of IO and log syncing (flush all log tree extent buffers
and write super blocks), but that mechanism does not work since if there
are currently no log writers, btrfs_sync_log() does not unlock the root's
log_mutex, so no new log writers can join the log transaction. Having
concurrent fsync tasks increasing the log_batch counter only makes us loop
unncessarily in btrfs_sync_log() - that is always true since the previous
patch mentioned above and was true before that patch only when not using
the "-o ssd" mount option (which is activated by default if the filesystem
does not have rotational devices).

So remove the log batch counter. No performance changes were observed
after removing it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h    | 2 --
 fs/btrfs/disk-io.c  | 1 -
 fs/btrfs/file.c     | 4 ----
 fs/btrfs/tree-log.c | 8 +-------
 4 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0f2653182405..d5d8b3899258 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -196,8 +196,6 @@ struct btrfs_root {
 	/* Used only for log trees of subvolumes, not for the log root tree */
 	atomic_t log_writers;
 	atomic_t log_commit[2];
-	/* Used only for log trees of subvolumes, not for the log root tree */
-	atomic_t log_batch;
 	/*
 	 * Protected by the 'log_mutex' lock but can be read without holding
 	 * that lock to avoid unnecessary lock contention, in which case it
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37fc0d6b960d..1ee0a19e40a8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -669,7 +669,6 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_commit[0], 0);
 	atomic_set(&root->log_commit[1], 0);
 	atomic_set(&root->log_writers, 0);
-	atomic_set(&root->log_batch, 0);
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->snapshot_force_cow, 0);
 	atomic_set(&root->nr_swapfiles, 0);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8f078c58e940..aeecf1121b51 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1573,8 +1573,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	else
 		btrfs_inode_lock(inode, BTRFS_ILOCK_MMAP);
 
-	atomic_inc(&root->log_batch);
-
 	/*
 	 * Before we acquired the inode's lock and the mmap lock, someone may
 	 * have dirtied more pages in the target range. We need to make sure
@@ -1657,8 +1655,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (ret)
 		goto out_release_extents;
 
-	atomic_inc(&root->log_batch);
-
 	if (skip_inode_logging(&ctx)) {
 		/*
 		 * We've had everything committed since the last time we were
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ccc262833a7c..580f2aabc065 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3336,13 +3336,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
 		wait_log_commit(root, log_transid - 1);
 
-	while (1) {
-		int batch = atomic_read(&root->log_batch);
-
-		wait_for_writer(root);
-		if (batch == atomic_read(&root->log_batch))
-			break;
-	}
+	wait_for_writer(root);
 
 	/* bail out if we need to do a full commit */
 	if (btrfs_need_log_full_commit(trans)) {
-- 
2.47.2

