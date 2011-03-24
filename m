From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] btrfs: Cleanup extent_buffer lockdep code
Date: Thu, 24 Mar 2011 18:43:06 +0100
Message-ID: <1300988588-13986-2-git-send-email-tj@kernel.org>
References: <1300988588-13986-1-git-send-email-tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
To: chris.mason@oracle.com, peterz@infradead.org, mingo@redhat.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300988588-13986-1-git-send-email-tj@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_set_buffer_lockdep_class() should be dependent upon
CONFIG_LOCKDEP instead of CONFIG_DEBUG_LOCK_ALLOC.  Collect the
related code into one place, use CONFIG_LOCKDEP instead and make some
cosmetic changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/btrfs/disk-io.c |   22 ++++++++++------------
 fs/btrfs/disk-io.h |   11 +++++------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e1ea3e..e973e0b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -97,7 +97,9 @@ struct async_submit_bio {
 	struct btrfs_work work;
 };
 
-/* These are used to set the lockdep class on the extent buffer locks.
+#ifdef CONFIG_LOCKDEP
+/*
+ * These are used to set the lockdep class on the extent buffer locks.
  * The class is set by the readpage_end_io_hook after the buffer has
  * passed csum validation but before the pages are unlocked.
  *
@@ -111,7 +113,6 @@ struct async_submit_bio {
  * the same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this
  * code needs update as well.
  */
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 # if BTRFS_MAX_LEVEL != 8
 #  error
 # endif
@@ -129,7 +130,13 @@ static const char *btrfs_eb_name[BTRFS_MAX_LEVEL + 1] = {
 	/* highest possible level */
 	"btrfs-extent-08",
 };
-#endif
+
+void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level)
+{
+	lockdep_set_class_and_name(&eb->lock, &btrfs_eb_class[level],
+				   btrfs_eb_name[level]);
+}
+#endif	/* CONFIG_LOCKDEP */
 
 /*
  * extents on the btree inode are pretty simple, there's one extent
@@ -419,15 +426,6 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 	return ret;
 }
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level)
-{
-	lockdep_set_class_and_name(&eb->lock,
-			   &btrfs_eb_class[level],
-			   btrfs_eb_name[level]);
-}
-#endif
-
 static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state)
 {
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 07b20dc..4ab3fa8 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -102,13 +102,12 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root);
 int btree_lock_page_hook(struct page *page);
 
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#ifdef CONFIG_LOCKDEP
 void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level);
 #else
 static inline void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb,
 						 int level)
-{
-}
-#endif
-#endif
+{ }
+#endif	/* CONFIG_LOCKDEP */
+
+#endif	/* __DISKIO__ */
-- 
1.7.1
