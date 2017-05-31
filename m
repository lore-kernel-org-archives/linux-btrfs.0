Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57697 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751038AbdEaIJF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 04:09:05 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [RFC PATCH] btrfs: qgroup: Fix hang when using inode_cache and qgroup
Date: Wed, 31 May 2017 16:08:45 +0800
Message-ID: <20170531080845.3033-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 48a89bc4f2ce ("btrfs: qgroups: Retry after commit on getting EDQUOT")
is causing hang, with the following backtrace:

Call Trace:
 __schedule+0x374/0xaf0
 schedule+0x3d/0x90
 wait_for_commit+0x4a/0x80 [btrfs]
 ? wake_atomic_t_function+0x60/0x60
 btrfs_commit_transaction+0xe0/0xa10 [btrfs]  <<< Here
 ? start_transaction+0xad/0x510 [btrfs]
 qgroup_reserve+0x1f0/0x350 [btrfs]
 btrfs_qgroup_reserve_data+0xf8/0x2f0 [btrfs]
 ? _raw_spin_unlock+0x27/0x40
 btrfs_check_data_free_space+0x6d/0xb0 [btrfs]
 btrfs_delalloc_reserve_space+0x25/0x70 [btrfs]
 btrfs_save_ino_cache+0x402/0x650 [btrfs]
 commit_fs_roots+0xb7/0x170 [btrfs]
 btrfs_commit_transaction+0x425/0xa10 [btrfs] <<< And here
 qgroup_reserve+0x1f0/0x350 [btrfs]
 btrfs_qgroup_reserve_data+0xf8/0x2f0 [btrfs]
 ? _raw_spin_unlock+0x27/0x40
 btrfs_check_data_free_space+0x6d/0xb0 [btrfs]
 btrfs_delalloc_reserve_space+0x25/0x70 [btrfs]
 btrfs_direct_IO+0x1c5/0x3b0 [btrfs]
 generic_file_direct_write+0xab/0x150
 btrfs_file_write_iter+0x243/0x530 [btrfs]
 __vfs_write+0xc9/0x120
 vfs_write+0xcb/0x1f0
 SyS_pwrite64+0x79/0x90
 entry_SYSCALL_64_fastpath+0x18/0xad

The problem is that, inode_cache will be written in commit_fs_roots(),
which is called in btrfs_commit_transaction().

And when it fails to reserve enough data space, qgroup_reserve() will
try to call btrfs_commit_transaction() again, then we are waiting for
ourselves.

The patch will introduce can_retry parameter for qgroup_reserve(),
allowing related callers to avoid deadly commit transaction deadlock.

Now for space cache inode, we will not allow qgroup retry, so it will
not cause deadlock.

Fixes: 48a89bc4f2ce ("btrfs: qgroups: Retry after commit on getting EDQUOT")
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Commit  48a89bc4f2ce ("btrfs: qgroups: Retry after commit on getting EDQUOT")
is not only causing such deadlock, but also screwing up qgroup reserved
space for even generic test cases.

I'm afraid we may need to revert that commit if we can't find a good way
to fix the newly caused qgroup meta reserved space underflow.
(Unlike old bug which is qgroup data reserved space underflow, this time
the commit is causing new metadata space underflow).
---
 fs/btrfs/extent-tree.c |  7 +++++--
 fs/btrfs/qgroup.c      | 15 ++++++++++-----
 fs/btrfs/qgroup.h      |  2 +-
 fs/btrfs/transaction.c |  2 +-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451c72e6..15e7fcf3a7ab 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5817,7 +5817,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		/* One for parent inode, two for dir entries */
 		num_bytes = 3 * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta(root, num_bytes, true);
+		ret = btrfs_qgroup_reserve_meta(root, num_bytes, true, true);
 		if (ret)
 			return ret;
 	} else {
@@ -5945,6 +5945,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	u64 to_free = 0;
 	unsigned dropped;
 	bool release_extra = false;
+	bool can_qgroup_retry = true;
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -5957,6 +5958,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	if (btrfs_is_free_space_inode(inode)) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 		delalloc_lock = false;
+		can_qgroup_retry = false;
 	} else if (current->journal_info) {
 		flush = BTRFS_RESERVE_FLUSH_LIMIT;
 	}
@@ -5987,7 +5989,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		ret = btrfs_qgroup_reserve_meta(root,
-				nr_extents * fs_info->nodesize, true);
+				nr_extents * fs_info->nodesize, true,
+				can_qgroup_retry);
 		if (ret)
 			goto out_fail;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index deffbeb74a0b..3859acb03ae9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2322,7 +2322,8 @@ static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
 	return true;
 }
 
-static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
+static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
+			  bool can_retry)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2364,7 +2365,8 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 
 		qg = unode_aux_to_qgroup(unode);
 
-		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
+		if (enforce && !qgroup_check_limits(qg, num_bytes) &&
+		    can_retry) {
 			/*
 			 * Commit the tree and retry, since we may have
 			 * deletions which would free up space.
@@ -2813,12 +2815,15 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 	struct extent_changeset changeset;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
+	bool can_retry = true;
 	int ret;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags) ||
 	    !is_fstree(root->objectid) || len == 0)
 		return 0;
 
+	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
+		can_retry = false;
 	changeset.bytes_changed = 0;
 	ulist_init(&changeset.range_changed);
 	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
@@ -2828,7 +2833,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 					QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
-	ret = qgroup_reserve(root, changeset.bytes_changed, true);
+	ret = qgroup_reserve(root, changeset.bytes_changed, true, can_retry);
 	if (ret < 0)
 		goto cleanup;
 
@@ -2909,7 +2914,7 @@ int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len)
 }
 
 int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-			      bool enforce)
+			      bool enforce, bool can_retry)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -2920,7 +2925,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	trace_qgroup_meta_reserve(root, (s64)num_bytes);
-	ret = qgroup_reserve(root, num_bytes, enforce);
+	ret = qgroup_reserve(root, num_bytes, enforce, can_retry);
 	if (ret < 0)
 		return ret;
 	atomic64_add(num_bytes, &root->qgroup_meta_rsv);
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fe04d3f295c6..d129d586039d 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -248,7 +248,7 @@ int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
 
 int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-			      bool enforce);
+			      bool enforce, bool can_retry);
 void btrfs_qgroup_free_meta_all(struct btrfs_root *root);
 void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes);
 void btrfs_qgroup_check_reserved_leak(struct inode *inode);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2168654c90a1..1bfa33c0b541 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -509,7 +509,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	if (num_items && root != fs_info->chunk_root) {
 		qgroup_reserved = num_items * fs_info->nodesize;
 		ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved,
-						enforce_qgroups);
+						enforce_qgroups, true);
 		if (ret)
 			return ERR_PTR(ret);
 
-- 
2.13.0



