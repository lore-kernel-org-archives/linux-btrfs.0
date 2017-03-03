Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5477 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdCCJ2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:28:54 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 06/17] fs, btrfs: convert btrfs_delayed_ref_node.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:15 +0200
Message-Id: <1488531326-21271-7-git-send-email-elena.reshetova@intel.com>
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
 fs/btrfs/backref.c     | 2 +-
 fs/btrfs/delayed-ref.c | 8 ++++----
 fs/btrfs/delayed-ref.h | 8 +++++---
 fs/btrfs/disk-io.c     | 2 +-
 fs/btrfs/extent-tree.c | 6 +++---
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7699e16..1163383 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1286,7 +1286,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
 		if (head) {
 			if (!mutex_trylock(&head->mutex)) {
-				atomic_inc(&head->node.refs);
+				refcount_inc(&head->node.refs);
 				spin_unlock(&delayed_refs->lock);
 
 				btrfs_release_path(path);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6eb8095..be70d90 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -164,7 +164,7 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	if (mutex_trylock(&head->mutex))
 		return 0;
 
-	atomic_inc(&head->node.refs);
+	refcount_inc(&head->node.refs);
 	spin_unlock(&delayed_refs->lock);
 
 	mutex_lock(&head->mutex);
@@ -590,7 +590,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	/* first set the basic ref node struct up */
-	atomic_set(&ref->refs, 1);
+	refcount_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
 	ref->ref_mod = count_mod;
@@ -682,7 +682,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	/* first set the basic ref node struct up */
-	atomic_set(&ref->refs, 1);
+	refcount_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
 	ref->ref_mod = 1;
@@ -739,7 +739,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		seq = atomic64_read(&fs_info->tree_mod_seq);
 
 	/* first set the basic ref node struct up */
-	atomic_set(&ref->refs, 1);
+	refcount_set(&ref->refs, 1);
 	ref->bytenr = bytenr;
 	ref->num_bytes = num_bytes;
 	ref->ref_mod = 1;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 0e537f9..c0264ff 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -18,6 +18,8 @@
 #ifndef __DELAYED_REF__
 #define __DELAYED_REF__
 
+#include <linux/refcount.h>
+
 /* these are the possible values of struct btrfs_delayed_ref_node->action */
 #define BTRFS_ADD_DELAYED_REF    1 /* add one backref to the tree */
 #define BTRFS_DROP_DELAYED_REF   2 /* delete one backref from the tree */
@@ -53,7 +55,7 @@ struct btrfs_delayed_ref_node {
 	u64 seq;
 
 	/* ref count on this data structure */
-	atomic_t refs;
+	refcount_t refs;
 
 	/*
 	 * how many refs is this entry adding or deleting.  For
@@ -220,8 +222,8 @@ btrfs_free_delayed_extent_op(struct btrfs_delayed_extent_op *op)
 
 static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 {
-	WARN_ON(atomic_read(&ref->refs) == 0);
-	if (atomic_dec_and_test(&ref->refs)) {
+	WARN_ON(refcount_read(&ref->refs) == 0);
+	if (refcount_dec_and_test(&ref->refs)) {
 		WARN_ON(ref->in_tree);
 		switch (ref->type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dca6432..913df60 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4343,7 +4343,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
 				href_node);
 		if (!mutex_trylock(&head->mutex)) {
-			atomic_inc(&head->node.refs);
+			refcount_inc(&head->node.refs);
 			spin_unlock(&delayed_refs->lock);
 
 			mutex_lock(&head->mutex);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 796001b..11a1b07 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -891,7 +891,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
 	if (head) {
 		if (!mutex_trylock(&head->mutex)) {
-			atomic_inc(&head->node.refs);
+			refcount_inc(&head->node.refs);
 			spin_unlock(&delayed_refs->lock);
 
 			btrfs_release_path(path);
@@ -2979,7 +2979,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				struct btrfs_delayed_ref_node *ref;
 
 				ref = &head->node;
-				atomic_inc(&ref->refs);
+				refcount_inc(&ref->refs);
 
 				spin_unlock(&delayed_refs->lock);
 				/*
@@ -3056,7 +3056,7 @@ static noinline int check_delayed_ref(struct btrfs_root *root,
 	}
 
 	if (!mutex_trylock(&head->mutex)) {
-		atomic_inc(&head->node.refs);
+		refcount_inc(&head->node.refs);
 		spin_unlock(&delayed_refs->lock);
 
 		btrfs_release_path(path);
-- 
2.7.4

