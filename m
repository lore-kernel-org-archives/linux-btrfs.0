From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 07/21] Btrfs: add basic infrastructure for selective balancing
Date: Tue, 23 Aug 2011 23:01:48 +0300
Message-ID: <1314129722-31601-8-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This allows to have a separate set of filters for each chunk type
(data,meta,sys).  The code however is generic and switch on chunk type
is only done once.

This commit also adds a type filter: it allows to balance for example
meta and system chunks w/o touching data ones.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h |   12 +++++++++
 2 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e4a276..95c6310 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2175,6 +2175,30 @@ static void unset_restripe_control(struct btrfs_fs_info *fs_info)
 	kfree(rctl);
 }
 
+static int should_restripe_chunk(struct btrfs_root *root,
+				 struct extent_buffer *leaf,
+				 struct btrfs_chunk *chunk, u64 chunk_offset)
+{
+	struct restripe_control *rctl = root->fs_info->restripe_ctl;
+	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
+	struct btrfs_restripe_args *rargs = NULL;
+
+	/* type filter */
+	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
+	      (rctl->flags & BTRFS_RESTRIPE_TYPE_MASK))) {
+		return 0;
+	}
+
+	if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
+		rargs = &rctl->data;
+	else if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
+		rargs = &rctl->sys;
+	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
+		rargs = &rctl->meta;
+
+	return 1;
+}
+
 static int __btrfs_restripe(struct btrfs_root *dev_root)
 {
 	struct list_head *devices;
@@ -2182,10 +2206,13 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 	u64 old_size;
 	u64 size_to_free;
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
+	struct btrfs_chunk *chunk;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_trans_handle *trans;
+	struct extent_buffer *leaf;
+	int slot;
 	int ret;
 	int enospc_errors = 0;
 
@@ -2241,8 +2268,10 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 		if (ret)
 			BUG_ON(1); /* DIS - break ? */
 
-		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
-				      path->slots[0]);
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+
 		if (found_key.objectid != key.objectid)
 			break;
 
@@ -2250,6 +2279,14 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 		if (found_key.offset == 0)
 			break;
 
+		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+
+		if (!should_restripe_chunk(chunk_root, leaf, chunk,
+					   found_key.offset)) {
+			btrfs_release_path(path);
+			goto loop;
+		}
+
 		btrfs_release_path(path);
 		ret = btrfs_relocate_chunk(chunk_root,
 					   chunk_root->root_key.objectid,
@@ -2259,6 +2296,7 @@ static int __btrfs_restripe(struct btrfs_root *dev_root)
 			goto error;
 		if (ret == -ENOSPC)
 			enospc_errors++;
+loop:
 		key.offset = found_key.offset - 1;
 	}
 
@@ -2285,8 +2323,30 @@ int btrfs_restripe(struct restripe_control *rctl)
 	mutex_lock(&fs_info->volume_mutex);
 
 	/*
-	 * Profile changing sanity checks
+	 * In case of mixed groups both data and meta should be picked,
+	 * and identical options should be given for both of them.
 	 */
+	allowed = btrfs_super_incompat_flags(&fs_info->super_copy);
+	if ((allowed & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
+	    (rctl->flags & (BTRFS_RESTRIPE_DATA | BTRFS_RESTRIPE_METADATA))) {
+		if (!(rctl->flags & BTRFS_RESTRIPE_DATA) ||
+		    !(rctl->flags & BTRFS_RESTRIPE_METADATA) ||
+		    memcmp(&rctl->data, &rctl->meta, sizeof(rctl->data))) {
+			printk(KERN_ERR "btrfs: with mixed groups data and "
+			       "metadata restripe options must be the same\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	/*
+	 * Profile changing sanity checks.  Skip them if a simple
+	 * balance is requested.
+	 */
+	if (!((rctl->data.flags | rctl->sys.flags | rctl->meta.flags) &
+	      BTRFS_RESTRIPE_ARGS_CONVERT))
+		goto do_restripe;
+
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	if (fs_info->fs_devices->num_devices == 1)
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
@@ -2344,6 +2404,7 @@ int btrfs_restripe(struct restripe_control *rctl)
 		}
 	}
 
+do_restripe:
 	set_restripe_control(rctl);
 	mutex_unlock(&fs_info->volume_mutex);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8804c5c..f40227e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -168,6 +168,18 @@ struct map_lookup {
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+/*
+ * Restriper's general "type" filter.  Shares bits with chunk type for
+ * simplicity, RESTRIPE prefix is used to avoid confusion.
+ */
+#define BTRFS_RESTRIPE_DATA		(1ULL << 0)
+#define BTRFS_RESTRIPE_SYSTEM		(1ULL << 1)
+#define BTRFS_RESTRIPE_METADATA		(1ULL << 2)
+
+#define BTRFS_RESTRIPE_TYPE_MASK	(BTRFS_RESTRIPE_DATA |		    \
+					 BTRFS_RESTRIPE_SYSTEM |	    \
+					 BTRFS_RESTRIPE_METADATA)
+
 #define BTRFS_RESTRIPE_FORCE		(1ULL << 3)
 
 /*
-- 
1.7.5.4

