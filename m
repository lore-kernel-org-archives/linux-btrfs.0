Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7352 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdCCI5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 03:57:51 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 03/17] fs, btrfs: convert extent_map.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:12 +0200
Message-Id: <1488531326-21271-4-git-send-email-elena.reshetova@intel.com>
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
 fs/btrfs/extent_io.c         |  4 ++--
 fs/btrfs/extent_map.c        | 10 +++++-----
 fs/btrfs/extent_map.h        |  3 ++-
 fs/btrfs/tree-log.c          |  2 +-
 fs/btrfs/volumes.c           |  2 +-
 include/trace/events/btrfs.h |  2 +-
 6 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c3abf84..3cf0b02 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2852,7 +2852,7 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
 		em = *em_cached;
 		if (extent_map_in_tree(em) && start >= em->start &&
 		    start < extent_map_end(em)) {
-			atomic_inc(&em->refs);
+			refcount_inc(&em->refs);
 			return em;
 		}
 
@@ -2863,7 +2863,7 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
 	em = get_extent(BTRFS_I(inode), page, pg_offset, start, len, 0);
 	if (em_cached && !IS_ERR_OR_NULL(em)) {
 		BUG_ON(*em_cached);
-		atomic_inc(&em->refs);
+		refcount_inc(&em->refs);
 		*em_cached = em;
 	}
 	return em;
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 26f9ac7..6985015 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -55,7 +55,7 @@ struct extent_map *alloc_extent_map(void)
 	em->flags = 0;
 	em->compress_type = BTRFS_COMPRESS_NONE;
 	em->generation = 0;
-	atomic_set(&em->refs, 1);
+	refcount_set(&em->refs, 1);
 	INIT_LIST_HEAD(&em->list);
 	return em;
 }
@@ -71,8 +71,8 @@ void free_extent_map(struct extent_map *em)
 {
 	if (!em)
 		return;
-	WARN_ON(atomic_read(&em->refs) == 0);
-	if (atomic_dec_and_test(&em->refs)) {
+	WARN_ON(refcount_read(&em->refs) == 0);
+	if (refcount_dec_and_test(&em->refs)) {
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
 		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
@@ -322,7 +322,7 @@ static inline void setup_extent_mapping(struct extent_map_tree *tree,
 					struct extent_map *em,
 					int modified)
 {
-	atomic_inc(&em->refs);
+	refcount_inc(&em->refs);
 	em->mod_start = em->start;
 	em->mod_len = em->len;
 
@@ -381,7 +381,7 @@ __lookup_extent_mapping(struct extent_map_tree *tree,
 	if (strict && !(end > em->start && start < extent_map_end(em)))
 		return NULL;
 
-	atomic_inc(&em->refs);
+	refcount_inc(&em->refs);
 	return em;
 }
 
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index eb8b8fa..a67b2de 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -2,6 +2,7 @@
 #define __EXTENTMAP__
 
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 
 #define EXTENT_MAP_LAST_BYTE ((u64)-4)
 #define EXTENT_MAP_HOLE ((u64)-3)
@@ -41,7 +42,7 @@ struct extent_map {
 		 */
 		struct map_lookup *map_lookup;
 	};
-	atomic_t refs;
+	refcount_t refs;
 	unsigned int compress_type;
 	struct list_head list;
 };
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a59674c..ccfe9fe 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4196,7 +4196,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		if (em->generation <= test_gen)
 			continue;
 		/* Need a ref to keep it from getting evicted from cache */
-		atomic_inc(&em->refs);
+		refcount_inc(&em->refs);
 		set_bit(EXTENT_FLAG_LOGGING, &em->flags);
 		list_add_tail(&em->list, &extents);
 		num++;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a8fd2e9..c23a383 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4833,7 +4833,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	ret = add_extent_mapping(em_tree, em, 0);
 	if (!ret) {
 		list_add_tail(&em->list, &trans->transaction->pending_chunks);
-		atomic_inc(&em->refs);
+		refcount_inc(&em->refs);
 	}
 	write_unlock(&em_tree->lock);
 	if (ret) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a3c3cab..9dd29e8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -213,7 +213,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		__entry->block_start	= map->block_start;
 		__entry->block_len	= map->block_len;
 		__entry->flags		= map->flags;
-		__entry->refs		= atomic_read(&map->refs);
+		__entry->refs		= refcount_read(&map->refs);
 		__entry->compress_type	= map->compress_type;
 	),
 
-- 
2.7.4

