From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 14/21] Btrfs: save restripe parameters to disk
Date: Tue, 23 Aug 2011 23:01:55 +0300
Message-ID: <1314129722-31601-15-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new btree objectid for storing restripe item.  The reason is
to be able to resume restriper after a crash with the same parameters.
Restripe item has a very high objectid and goes into tree of tree roots.

The key for the new item is as follows:

    [ BTRFS_RESTRIPE_OBJECTID ; 0 ; 0 ]

Older kernels simply ignore it so it's safe to mount with an older
kernel and then go back to the newer one.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c |  105 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 228 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 65d7562..b524034 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -85,6 +85,9 @@ struct btrfs_ordered_sum;
 /* holds checksums of all the data extents */
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 
+/* for storing restripe params in the root tree */
+#define BTRFS_RESTRIPE_OBJECTID -4ULL
+
 /* orhpan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -649,6 +652,47 @@ struct btrfs_root_ref {
 	__le16 name_len;
 } __attribute__ ((__packed__));
 
+/*
+ * Restriper stuff
+ */
+struct btrfs_disk_restripe_args {
+	/* profiles to touch, in-memory format */
+	__le64 profiles;
+
+	/* usage filter */
+	__le64 usage;
+
+	/* devid filter */
+	__le64 devid;
+
+	/* devid subset filter [pstart..pend) */
+	__le64 pstart;
+	__le64 pend;
+
+	/* btrfs virtual address space subset filter [vstart..vend) */
+	__le64 vstart;
+	__le64 vend;
+
+	/* profile to convert to, in-memory format */
+	__le64 target;
+
+	/* BTRFS_RESTRIPE_ARGS_* */
+	__le64 flags;
+
+	__le64 unused[8];
+} __attribute__ ((__packed__));
+
+struct btrfs_restripe_item {
+	/* BTRFS_RESTRIPE_* */
+	__le64 flags;
+
+	struct btrfs_disk_restripe_args data;
+	struct btrfs_disk_restripe_args sys;
+	struct btrfs_disk_restripe_args meta;
+
+	__le64 unused[4];
+} __attribute__ ((__packed__));
+
 #define BTRFS_FILE_EXTENT_INLINE 0
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
@@ -727,7 +771,8 @@ struct btrfs_csum_item {
 					 BTRFS_BLOCK_GROUP_RAID10)
 /*
  * We need a bit for restriper to be able to tell when chunks of type
- * SINGLE are available.  It is used in avail_*_alloc_bits.
+ * SINGLE are available.  It is used in avail_*_alloc_bits and restripe
+ * item fields.
  */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE (1 << 7)
 
@@ -2000,8 +2045,86 @@ static inline bool btrfs_root_readonly(struct btrfs_root *root)
 	return root->root_item.flags & BTRFS_ROOT_SUBVOL_RDONLY;
 }
 
-/* struct btrfs_super_block */
+/* struct btrfs_restripe_item */
+BTRFS_SETGET_FUNCS(restripe_flags, struct btrfs_restripe_item, flags, 64);
+
+static inline void btrfs_restripe_data(struct extent_buffer *eb,
+				       struct btrfs_restripe_item *ri,
+				       struct btrfs_disk_restripe_args *ra)
+{
+	read_eb_member(eb, ri, struct btrfs_restripe_item, data, ra);
+}
 
+static inline void btrfs_set_restripe_data(struct extent_buffer *eb,
+					   struct btrfs_restripe_item *ri,
+					   struct btrfs_disk_restripe_args *ra)
+{
+	write_eb_member(eb, ri, struct btrfs_restripe_item, data, ra);
+}
+
+static inline void btrfs_restripe_meta(struct extent_buffer *eb,
+				       struct btrfs_restripe_item *ri,
+				       struct btrfs_disk_restripe_args *ra)
+{
+	read_eb_member(eb, ri, struct btrfs_restripe_item, meta, ra);
+}
+
+static inline void btrfs_set_restripe_meta(struct extent_buffer *eb,
+					   struct btrfs_restripe_item *ri,
+					   struct btrfs_disk_restripe_args *ra)
+{
+	write_eb_member(eb, ri, struct btrfs_restripe_item, meta, ra);
+}
+
+static inline void btrfs_restripe_sys(struct extent_buffer *eb,
+				      struct btrfs_restripe_item *ri,
+				      struct btrfs_disk_restripe_args *ra)
+{
+	read_eb_member(eb, ri, struct btrfs_restripe_item, sys, ra);
+}
+
+static inline void btrfs_set_restripe_sys(struct extent_buffer *eb,
+					  struct btrfs_restripe_item *ri,
+					  struct btrfs_disk_restripe_args *ra)
+{
+	write_eb_member(eb, ri, struct btrfs_restripe_item, sys, ra);
+}
+
+static inline void
+btrfs_disk_restripe_args_to_cpu(struct btrfs_restripe_args *cpu,
+				struct btrfs_disk_restripe_args *disk)
+{
+	memset(cpu, 0, sizeof(*cpu));
+
+	cpu->profiles = le64_to_cpu(disk->profiles);
+	cpu->usage = le64_to_cpu(disk->usage);
+	cpu->devid = le64_to_cpu(disk->devid);
+	cpu->pstart = le64_to_cpu(disk->pstart);
+	cpu->pend = le64_to_cpu(disk->pend);
+	cpu->vstart = le64_to_cpu(disk->vstart);
+	cpu->vend = le64_to_cpu(disk->vend);
+	cpu->target = le64_to_cpu(disk->target);
+	cpu->flags = le64_to_cpu(disk->flags);
+}
+
+static inline void
+btrfs_cpu_restripe_args_to_disk(struct btrfs_disk_restripe_args *disk,
+				struct btrfs_restripe_args *cpu)
+{
+	memset(disk, 0, sizeof(*disk));
+
+	disk->profiles = cpu_to_le64(cpu->profiles);
+	disk->usage = cpu_to_le64(cpu->usage);
+	disk->devid = cpu_to_le64(cpu->devid);
+	disk->pstart = cpu_to_le64(cpu->pstart);
+	disk->pend = cpu_to_le64(cpu->pend);
+	disk->vstart = cpu_to_le64(cpu->vstart);
+	disk->vend = cpu_to_le64(cpu->vend);
+	disk->target = cpu_to_le64(cpu->target);
+	disk->flags = cpu_to_le64(cpu->flags);
+}
+
+/* struct btrfs_super_block */
 BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(super_flags, struct btrfs_super_block, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_generation, struct btrfs_super_block,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index eccd458..1057ad3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2150,6 +2150,97 @@ error:
 	return ret;
 }
 
+static int insert_restripe_item(struct btrfs_root *root,
+				struct restripe_control *rctl)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_restripe_item *item;
+	struct btrfs_disk_restripe_args disk_rargs;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int ret, err;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	key.objectid = BTRFS_RESTRIPE_OBJECTID;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+				      sizeof(*item));
+	if (ret)
+		goto out;
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_restripe_item);
+
+	memset_extent_buffer(leaf, 0, (unsigned long)item, sizeof(*item));
+
+	btrfs_cpu_restripe_args_to_disk(&disk_rargs, &rctl->data);
+	btrfs_set_restripe_data(leaf, item, &disk_rargs);
+	btrfs_cpu_restripe_args_to_disk(&disk_rargs, &rctl->meta);
+	btrfs_set_restripe_meta(leaf, item, &disk_rargs);
+	btrfs_cpu_restripe_args_to_disk(&disk_rargs, &rctl->sys);
+	btrfs_set_restripe_sys(leaf, item, &disk_rargs);
+
+	btrfs_set_restripe_flags(leaf, item, rctl->flags);
+
+	btrfs_mark_buffer_dirty(leaf);
+out:
+	btrfs_free_path(path);
+	err = btrfs_commit_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
+	return ret;
+}
+
+static int del_restripe_item(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret, err;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	key.objectid = BTRFS_RESTRIPE_OBJECTID;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, path);
+out:
+	btrfs_free_path(path);
+	err = btrfs_commit_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
+	return ret;
+}
+
 /*
  * Should be called with both restripe and volume mutexes held to
  * serialize other volume operations (add_dev/rm_dev/resize) wrt
@@ -2485,6 +2576,7 @@ int btrfs_restripe(struct restripe_control *rctl)
 {
 	struct btrfs_fs_info *fs_info = rctl->fs_info;
 	u64 allowed;
+	int err;
 	int ret;
 
 	mutex_lock(&fs_info->volume_mutex);
@@ -2572,16 +2664,25 @@ int btrfs_restripe(struct restripe_control *rctl)
 	}
 
 do_restripe:
+	ret = insert_restripe_item(fs_info->tree_root, rctl);
+	if (ret && ret != -EEXIST)
+		goto out;
+	BUG_ON(ret == -EEXIST);
+
 	set_restripe_control(rctl);
 	mutex_unlock(&fs_info->volume_mutex);
 
-	ret = __btrfs_restripe(fs_info->dev_root);
+	err = __btrfs_restripe(fs_info->dev_root);
 
 	mutex_lock(&fs_info->volume_mutex);
+
 	unset_restripe_control(fs_info);
+	ret = del_restripe_item(fs_info->tree_root);
+	BUG_ON(ret);
+
 	mutex_unlock(&fs_info->volume_mutex);
 
-	return ret;
+	return err;
 
 out:
 	mutex_unlock(&fs_info->volume_mutex);
-- 
1.7.5.4

