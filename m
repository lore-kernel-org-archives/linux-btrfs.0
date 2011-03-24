From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] btrfs: Use separate lockdep class keys for different roots
Date: Thu, 24 Mar 2011 18:43:07 +0100
Message-ID: <1300988588-13986-3-git-send-email-tj@kernel.org>
References: <1300988588-13986-1-git-send-email-tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
To: chris.mason@oracle.com, peterz@infradead.org, mingo@redhat.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300988588-13986-1-git-send-email-tj@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Due to the custom extent_buffer locking implementation, currently
lockdep doesn't have visibility into btrfs locking when the locks are
switched to blocking, hiding most of lock ordering issues from
lockdep.

With planned switch to mutex, all extent_buffer locking operations
will be visible to lockdep.  As btrfs_root's used for different
purposes can be lock-nested, sharing the same set of lockdep class
keys leads to spurious locking dependency warnings.

This patch makes btrfs_set_buffer_lockdep_class() take @root parameter
which indicates the btrfs_root the @eb belongs to and use different
sets of keys according to the type of @root.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/btrfs/disk-io.c     |   91 +++++++++++++++++++++++++++++++++--------------
 fs/btrfs/disk-io.h     |   10 ++++--
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/volumes.c     |    2 +-
 4 files changed, 73 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e973e0b..710efbd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -99,42 +99,79 @@ struct async_submit_bio {
 
 #ifdef CONFIG_LOCKDEP
 /*
- * These are used to set the lockdep class on the extent buffer locks.
- * The class is set by the readpage_end_io_hook after the buffer has
- * passed csum validation but before the pages are unlocked.
+ * Lockdep class keys for extent_buffer->lock's in this root.  For a given
+ * eb, the lockdep key is determined by the btrfs_root it belongs to and
+ * the level the eb occupies in the tree.
  *
- * The lockdep class is also set by btrfs_init_new_buffer on freshly
- * allocated blocks.
+ * Different roots are used for different purposes and may nest inside each
+ * other and they require separate keysets.  As lockdep keys should be
+ * static, assign keysets according to the purpose of the root as indicated
+ * by btrfs_root->objectid.  This ensures that all special purpose roots
+ * have separate keysets.
  *
- * The class is based on the level in the tree block, which allows lockdep
- * to know that lower nodes nest inside the locks of higher nodes.
+ * Lock-nesting across peer nodes is always done with the immediate parent
+ * node locked thus preventing deadlock.  As lockdep doesn't know this, use
+ * subclass to avoid triggering lockdep warning in such cases.
  *
- * We also add a check to make sure the highest level of the tree is
- * the same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this
- * code needs update as well.
+ * The key is set by the readpage_end_io_hook after the buffer has passed
+ * csum validation but before the pages are unlocked.  It is also set by
+ * btrfs_init_new_buffer on freshly allocated blocks.
+ *
+ * We also add a check to make sure the highest level of the tree is the
+ * same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this code
+ * needs update as well.
  */
 # if BTRFS_MAX_LEVEL != 8
 #  error
 # endif
-static struct lock_class_key btrfs_eb_class[BTRFS_MAX_LEVEL + 1];
-static const char *btrfs_eb_name[BTRFS_MAX_LEVEL + 1] = {
-	/* leaf */
-	"btrfs-extent-00",
-	"btrfs-extent-01",
-	"btrfs-extent-02",
-	"btrfs-extent-03",
-	"btrfs-extent-04",
-	"btrfs-extent-05",
-	"btrfs-extent-06",
-	"btrfs-extent-07",
-	/* highest possible level */
-	"btrfs-extent-08",
+
+static struct btrfs_lockdep_keyset {
+	u64			id;		/* root objectid */
+	const char		*name_stem;	/* lock name stem */
+	char			names[BTRFS_MAX_LEVEL + 1][20];
+	struct lock_class_key	keys[BTRFS_MAX_LEVEL + 1];
+} btrfs_lockdep_keysets[] = {
+	{ .id = BTRFS_ROOT_TREE_OBJECTID,	.name_stem = "root"	},
+	{ .id = BTRFS_EXTENT_TREE_OBJECTID,	.name_stem = "extent"	},
+	{ .id = BTRFS_CHUNK_TREE_OBJECTID,	.name_stem = "chunk"	},
+	{ .id = BTRFS_DEV_TREE_OBJECTID,	.name_stem = "dev"	},
+	{ .id = BTRFS_FS_TREE_OBJECTID,		.name_stem = "fs"	},
+	{ .id = BTRFS_CSUM_TREE_OBJECTID,	.name_stem = "csum"	},
+	{ .id = BTRFS_ORPHAN_OBJECTID,		.name_stem = "orphan"	},
+	{ .id = BTRFS_TREE_LOG_OBJECTID,	.name_stem = "log"	},
+	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
+	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
+	{ .id = 0,				.name_stem = "tree"	},
 };
 
-void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level)
+void __init btrfs_init_lockdep(void)
+{
+	int i, j;
+
+	/* initialize lockdep class names */
+	for (i = 0; i < ARRAY_SIZE(btrfs_lockdep_keysets); i++) {
+		struct btrfs_lockdep_keyset *ks = &btrfs_lockdep_keysets[i];
+
+		for (j = 0; j < ARRAY_SIZE(ks->names); j++)
+			snprintf(ks->names[j], sizeof(ks->names[j]),
+				 "btrfs-%s-%02d", ks->name_stem, j);
+	}
+}
+
+void btrfs_set_buffer_lockdep_class(struct btrfs_root *root,
+				    struct extent_buffer *eb, int level)
 {
-	lockdep_set_class_and_name(&eb->lock, &btrfs_eb_class[level],
-				   btrfs_eb_name[level]);
+	struct btrfs_lockdep_keyset *ks;
+
+	BUG_ON(level >= ARRAY_SIZE(ks->keys));
+
+	/* find the matching keyset, id 0 is the default entry */
+	for (ks = btrfs_lockdep_keysets; ks->id; ks++)
+		if (ks->id == root->objectid)
+			break;
+
+	lockdep_set_class_and_name(&eb->lock,
+				   &ks->keys[level], ks->names[level]);
 }
 #endif	/* CONFIG_LOCKDEP */
 
@@ -480,7 +517,7 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	}
 	found_level = btrfs_header_level(eb);
 
-	btrfs_set_buffer_lockdep_class(eb, found_level);
+	btrfs_set_buffer_lockdep_class(root, eb, found_level);
 
 	ret = csum_tree_block(root, eb, 1);
 	if (ret)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4ab3fa8..4e511e6 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -103,10 +103,14 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 int btree_lock_page_hook(struct page *page);
 
 #ifdef CONFIG_LOCKDEP
-void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level);
+void btrfs_init_lockdep(void);
+void btrfs_set_buffer_lockdep_class(struct btrfs_root *root,
+				    struct extent_buffer *eb, int level);
 #else
-static inline void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb,
-						 int level)
+static inline void btrfs_init_lockdep(void)
+{ }
+static inline void btrfs_set_buffer_lockdep_class(struct btrfs_root *root,
+					struct extent_buffer *eb, int level)
 { }
 #endif	/* CONFIG_LOCKDEP */
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f1db57d..5e5fbf6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5634,7 +5634,7 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 	btrfs_set_header_generation(buf, trans->transid);
-	btrfs_set_buffer_lockdep_class(buf, level);
+	btrfs_set_buffer_lockdep_class(root, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(trans, root, buf);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 94334d9..1e38522 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3664,7 +3664,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	if (!sb)
 		return -ENOMEM;
 	btrfs_set_buffer_uptodate(sb);
-	btrfs_set_buffer_lockdep_class(sb, 0);
+	btrfs_set_buffer_lockdep_class(root, sb, 0);
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
-- 
1.7.1
