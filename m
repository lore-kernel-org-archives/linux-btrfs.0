From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 06/21] Btrfs: add basic infrastructure for selective balancing
Date: Fri,  6 Jan 2012 16:30:54 +0200
Message-ID: <1325860269-15013-7-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This allows to have a separate set of filters for each chunk type
(data,meta,sys).  The code however is generic and switch on chunk type
is only done once.

This commit also adds a type filter: it allows to balance for example
meta and system chunks w/o touching data ones.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c   |    3 ++
 fs/btrfs/volumes.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h |   11 +++++++++
 3 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 221bae0..e20d0cb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3101,6 +3101,9 @@ static long btrfs_ioctl_balance(struct btrfs_root *root, void __user *arg)
 		memcpy(&bctl->sys, &bargs->sys, sizeof(bctl->sys));
 
 		bctl->flags = bargs->flags;
+	} else {
+		/* balance everything - no filters */
+		bctl->flags |= BTRFS_BALANCE_TYPE_MASK;
 	}
 
 	ret = btrfs_balance(bctl, 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e8d6e78..0e6cddd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2102,6 +2102,30 @@ static void unset_balance_control(struct btrfs_fs_info *fs_info)
 	kfree(bctl);
 }
 
+static int should_balance_chunk(struct btrfs_root *root,
+				struct extent_buffer *leaf,
+				struct btrfs_chunk *chunk, u64 chunk_offset)
+{
+	struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
+	struct btrfs_balance_args *bargs = NULL;
+	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
+
+	/* type filter */
+	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
+	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
+		return 0;
+	}
+
+	if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
+		bargs = &bctl->data;
+	else if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
+		bargs = &bctl->sys;
+	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
+		bargs = &bctl->meta;
+
+	return 1;
+}
+
 static u64 div_factor(u64 num, int factor)
 {
 	if (factor == 10)
@@ -2119,10 +2143,13 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	struct btrfs_device *device;
 	u64 old_size;
 	u64 size_to_free;
+	struct btrfs_chunk *chunk;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_trans_handle *trans;
+	struct extent_buffer *leaf;
+	int slot;
 	int ret;
 	int enospc_errors = 0;
 
@@ -2177,8 +2204,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		if (ret)
 			BUG(); /* FIXME break ? */
 
-		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
-				      path->slots[0]);
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+
 		if (found_key.objectid != key.objectid)
 			break;
 
@@ -2186,7 +2215,14 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		if (found_key.offset == 0)
 			break;
 
+		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+
+		ret = should_balance_chunk(chunk_root, leaf, chunk,
+					   found_key.offset);
 		btrfs_release_path(path);
+		if (!ret)
+			goto loop;
+
 		ret = btrfs_relocate_chunk(chunk_root,
 					   chunk_root->root_key.objectid,
 					   found_key.objectid,
@@ -2195,6 +2231,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 			goto error;
 		if (ret == -ENOSPC)
 			enospc_errors++;
+loop:
 		key.offset = found_key.offset - 1;
 	}
 
@@ -2221,11 +2258,28 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 int btrfs_balance(struct btrfs_balance_control *bctl, int resume)
 {
 	struct btrfs_fs_info *fs_info = bctl->fs_info;
+	u64 allowed;
 	int ret;
 
 	if (btrfs_fs_closing(fs_info)) {
 		ret = -EINVAL;
 		goto out;
+
+	/*
+	 * In case of mixed groups both data and meta should be picked,
+	 * and identical options should be given for both of them.
+	 */
+	allowed = btrfs_super_incompat_flags(fs_info->super_copy);
+	if ((allowed & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
+	    (bctl->flags & (BTRFS_BALANCE_DATA | BTRFS_BALANCE_METADATA))) {
+		if (!(bctl->flags & BTRFS_BALANCE_DATA) ||
+		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
+		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
+			printk(KERN_ERR "btrfs: with mixed groups data and "
+			       "metadata balance options must be the same\n");
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	if (!resume)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b9daddc..7a78051 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -186,6 +186,17 @@ struct map_lookup {
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+/*
+ * Restriper's general type filter
+ */
+#define BTRFS_BALANCE_DATA		(1ULL << 0)
+#define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
+#define BTRFS_BALANCE_METADATA		(1ULL << 2)
+
+#define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
+					 BTRFS_BALANCE_SYSTEM |	    \
+					 BTRFS_BALANCE_METADATA)
+
 struct btrfs_balance_args;
 struct btrfs_balance_control {
 	struct btrfs_fs_info *fs_info;
-- 
1.7.6.3

