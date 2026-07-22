Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7963321445
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724121; cv=none; b=Yy1SPlJk9qJsH8/fvnJsG/URZ6jI1xC6w2j9Hl1wMExN6nWhQB3zRvoRq2+TFeWwpFxOhbj6ZRHm6nsx8nEcCDRbMo1Kq19RYrdSb3zfuz0WRRNh346oh1cwyAumKAAm3HieXVHJMxHqNgGkqDzJxBubqMyeybwXpaqTa7sZE7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724121; c=relaxed/simple;
	bh=1QGrDMfF8JW/23gj0WhU5p7T2/n7PccaEdrw8QOcSbg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYCl8/HSJn42i0hA8cq8RsBfgBJykzbcz2k5mrAzb1qrFDcBIoK1OIX59pTvCogj+sFC9rHDoxJg/hRu7xgNHVIZ+XBzR7m3gPRO+Th/qAacT/5xEHvDrD/cMquZUUnwpQRsnb2OfME8oAUIk+8SkwsetLIFL5nDY2ChW8hWAAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfmNSLc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfmNSLc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5521F00A3A
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 12:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724112;
	bh=dwuvd9LwrZyJ2FTj+qOohdWRGxeVcMK9GPsLllHEbBs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZfmNSLc3stDId52ZdZH0ZHftyDGe52vl1o5EKeWVctSKz4Q48TTL6znWHfutkFvzF
	 AMkxwzj4Cb1fLgCVnTB2CG7sBsRX00F6Arrpol6Acjw9HVojlYCSZZwz8dtIdKeBa7
	 Rmmj7kWzkKYfGyTdIUokY8f85TpM8o/XzBE2rEKs5Zou3A/4Uo1IO4qazAMLZQ4+jC
	 1UXUnDITwiUmiLZC+14JQZDgjrbNkHktor7oIAb2vEksBYMwqf5Qv0TH9nT+lQPoSe
	 ZLOVmTwdDzjBsxGKBnQNeUGnBuOfWhPZR8XSlkaezVtGxKJFyRct1YNGw8I282dyI/
	 MzB+POZXOVLuQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] btrfs: use simple booleans for log_commit field in struct btrfs_root
Date: Wed, 22 Jul 2026 13:41:43 +0100
Message-ID: <2388f2c7376b24ffa67eec995f539e0bbd12c469.1784656641.git.fdmanana@suse.com>
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

We are using atomic types for the log_commit array of struct btrfs_root
but all we need is simple booleans. The log_commit array elements are
always protected by the root's log_mutex, both for writes and reads, so
we can use a simple boolean. The use of atomics if from the very early
days of the log tree code where the access to the fields was not protected
by any lock.

So switch to simple booleans, which results in cheaper code and slightly
reduces the object size too.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h             |  2 +-
 fs/btrfs/disk-io.c           |  2 --
 fs/btrfs/transaction.c       |  8 ++------
 fs/btrfs/tree-log.c          | 16 ++++++++--------
 include/trace/events/btrfs.h |  4 ++--
 5 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d5d8b3899258..22ba2b4505b3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -195,7 +195,7 @@ struct btrfs_root {
 	struct list_head log_ctxs[2];
 	/* Used only for log trees of subvolumes, not for the log root tree */
 	atomic_t log_writers;
-	atomic_t log_commit[2];
+	bool log_commit[2];
 	/*
 	 * Protected by the 'log_mutex' lock but can be read without holding
 	 * that lock to avoid unnecessary lock contention, in which case it
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ee0a19e40a8..d17e087b9cbe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -666,8 +666,6 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
 	init_waitqueue_head(&root->log_commit_wait[1]);
 	INIT_LIST_HEAD(&root->log_ctxs[0]);
 	INIT_LIST_HEAD(&root->log_ctxs[1]);
-	atomic_set(&root->log_commit[0], 0);
-	atomic_set(&root->log_commit[1], 0);
 	atomic_set(&root->log_writers, 0);
 	refcount_set(&root->refs, 1);
 	atomic_set(&root->snapshot_force_cow, 0);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 45149d027740..91b41f55a3ce 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1517,12 +1517,8 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			ASSERT(atomic_read(&root->log_writers) == 0,
 			       "atomic_read(&root->log_writers)=%d",
 			       atomic_read(&root->log_writers));
-			ASSERT(atomic_read(&root->log_commit[0]) == 0,
-			       "atomic_read(&root->log_commit[0])=%d",
-			       atomic_read(&root->log_commit[0]));
-			ASSERT(atomic_read(&root->log_commit[1]) == 0,
-			       "atomic_read(&root->log_commit[1])=%d",
-			       atomic_read(&root->log_commit[1]));
+			ASSERT(!root->log_commit[0]);
+			ASSERT(!root->log_commit[1]);
 
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)btrfs_root_id(root),
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f2d0f6fb3eae..263e229c181c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3170,7 +3170,7 @@ static bool wait_log_commit(struct btrfs_root *root, int transid)
 	DEFINE_WAIT(wait);
 	int index = transid % 2;
 
-	if (atomic_read(&root->log_commit[index]) == 0)
+	if (!root->log_commit[index])
 		return false;
 
 	/*
@@ -3187,7 +3187,7 @@ static bool wait_log_commit(struct btrfs_root *root, int transid)
 		mutex_lock(&root->log_mutex);
 
 		if (!(root->log_transid_committed < transid &&
-		      atomic_read(&root->log_commit[index]) != 0))
+		      root->log_commit[index]))
 			break;
 	}
 	finish_wait(&root->log_commit_wait[index], &wait);
@@ -3332,7 +3332,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 	ASSERT(log_transid == root->log_transid,
 	       "log_transid=%d root->log_transid=%d", log_transid, root->log_transid);
-	atomic_set(&root->log_commit[index1], 1);
+	root->log_commit[index1] = true;
 
 	/* wait for previous tree log sync to complete */
 	wait_log_commit(root, log_transid - 1);
@@ -3452,7 +3452,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (atomic_read(&log_root_tree->log_commit[index2])) {
+	if (log_root_tree->log_commit[index2]) {
 		blk_finish_plug(&plug);
 		ret = btrfs_wait_tree_log_extents(log, mark);
 		wait_log_commit(log_root_tree,
@@ -3466,7 +3466,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	ASSERT(root_log_ctx.log_transid == log_root_tree->log_transid,
 	       "root_log_ctx.log_transid=%d log_root_tree->log_transid=%d",
 		root_log_ctx.log_transid, log_root_tree->log_transid);
-	atomic_set(&log_root_tree->log_commit[index2], 1);
+	log_root_tree->log_commit[index2] = true;
 
 	wait_log_commit(log_root_tree, root_log_ctx.log_transid - 1);
 
@@ -3566,7 +3566,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	/*
 	 * We know there can only be one task here, since we have not yet set
-	 * root->log_commit[index1] to 0 and any task attempting to sync the
+	 * root->log_commit[index1] to false and any task attempting to sync the
 	 * log must wait for the previous log transaction to commit if it's
 	 * still in progress or wait for the current log transaction commit if
 	 * someone else already started it. We use <= and not < because the
@@ -3582,7 +3582,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	btrfs_remove_all_log_ctxs(log_root_tree, index2, ret);
 
 	log_root_tree->log_transid_committed++;
-	atomic_set(&log_root_tree->log_commit[index2], 0);
+	log_root_tree->log_commit[index2] = false;
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	/*
@@ -3595,7 +3595,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_lock(&root->log_mutex);
 	btrfs_remove_all_log_ctxs(root, index1, ret);
 	root->log_transid_committed++;
-	atomic_set(&root->log_commit[index1], 0);
+	root->log_commit[index1] = false;
 	mutex_unlock(&root->log_mutex);
 
 	/*
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4c5c47c5edb7..083519ceecbf 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1578,9 +1578,9 @@ TRACE_EVENT(btrfs_sync_log_enter,
 		__entry->log_transid_committed	=
 			data_race(root->log_transid_committed);
 		__entry->log_committing		=
-			atomic_read(&root->log_commit[ctx->log_transid % 2]);
+			root->log_commit[ctx->log_transid % 2];
 		__entry->log_committing_prev	=
-			atomic_read(&root->log_commit[(ctx->log_transid + 1) % 2]);
+			root->log_commit[(ctx->log_transid + 1) % 2];
 		__entry->log_writers		= atomic_read(&root->log_writers);
 	),
 
-- 
2.47.2

