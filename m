Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4403 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752161AbdCCJHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:07:36 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 09/17] fs, btrfs: convert btrfs_root.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:18 +0200
Message-Id: <1488531326-21271-10-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/disk-io.h | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 557af39..c01bfca 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1221,7 +1221,7 @@ struct btrfs_root {
 	dev_t anon_dev;
 
 	spinlock_t root_item_lock;
-	atomic_t refs;
+	refcount_t refs;
 
 	struct mutex delalloc_mutex;
 	spinlock_t delalloc_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 913df60..ca89ae3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1340,7 +1340,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	atomic_set(&root->log_writers, 0);
 	atomic_set(&root->log_batch, 0);
 	atomic_set(&root->orphan_inodes, 0);
-	atomic_set(&root->refs, 1);
+	refcount_set(&root->refs, 1);
 	atomic_set(&root->will_be_snapshoted, 0);
 	atomic_set(&root->qgroup_meta_rsv, 0);
 	root->log_transid = 0;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 2e0ec29..21f1ceb 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -101,14 +101,14 @@ struct btrfs_root *btrfs_alloc_dummy_root(struct btrfs_fs_info *fs_info);
  */
 static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
 {
-	if (atomic_inc_not_zero(&root->refs))
+	if (refcount_inc_not_zero(&root->refs))
 		return root;
 	return NULL;
 }
 
 static inline void btrfs_put_fs_root(struct btrfs_root *root)
 {
-	if (atomic_dec_and_test(&root->refs))
+	if (refcount_dec_and_test(&root->refs))
 		kfree(root);
 }
 
-- 
2.7.4

