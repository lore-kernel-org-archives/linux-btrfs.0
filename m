From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 15/21] Btrfs: save balance parameters to disk
Date: Fri,  6 Jan 2012 16:31:03 +0200
Message-ID: <1325860269-15013-16-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new btree objectid for storing balance item.  The reason is
to be able to resume restriper after a crash with the same parameters.
Balance item has a very high objectid and goes into tree of tree roots.

The key for the new item is as follows:

	[ BTRFS_BALANCE_OBJECTID ; BTRFS_BALANCE_ITEM_KEY ; 0 ]

Older kernels simply ignore it so it's safe to mount with an older
kernel and then go back to the newer one.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c |  100 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 232 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1e7aea6..9997a59 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -86,6 +86,9 @@ struct btrfs_ordered_sum;
 /* holds checksums of all the data extents */
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 
+/* for storing balance parameters in the root tree */
+#define BTRFS_BALANCE_OBJECTID -4ULL
+
 /* orhpan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -692,6 +695,54 @@ struct btrfs_root_ref {
 	__le16 name_len;
 } __attribute__ ((__packed__));
 
+struct btrfs_disk_balance_args {
+	/*
+	 * profiles to operate on, single is denoted by
+	 * BTRFS_AVAIL_ALLOC_BIT_SINGLE
+	 */
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
+	/*
+	 * profile to convert to, single is denoted by
+	 * BTRFS_AVAIL_ALLOC_BIT_SINGLE
+	 */
+	__le64 target;
+
+	/* BTRFS_BALANCE_ARGS_* */
+	__le64 flags;
+
+	__le64 unused[8];
+} __attribute__ ((__packed__));
+
+/*
+ * store balance parameters to disk so that balance can be properly
+ * resumed after crash or unmount
+ */
+struct btrfs_balance_item {
+	/* BTRFS_BALANCE_* */
+	__le64 flags;
+
+	struct btrfs_disk_balance_args data;
+	struct btrfs_disk_balance_args meta;
+	struct btrfs_disk_balance_args sys;
+
+	__le64 unused[4];
+} __attribute__ ((__packed__));
+
 #define BTRFS_FILE_EXTENT_INLINE 0
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
@@ -1409,6 +1460,8 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+#define BTRFS_BALANCE_ITEM_KEY	248
+
 /*
  * string items are for debugging.  They just store a short string of
  * data in the FS
@@ -2103,8 +2156,86 @@ BTRFS_SETGET_STACK_FUNCS(backup_bytes_used, struct btrfs_root_backup,
 BTRFS_SETGET_STACK_FUNCS(backup_num_devices, struct btrfs_root_backup,
 		   num_devices, 64);
 
-/* struct btrfs_super_block */
+/* struct btrfs_balance_item */
+BTRFS_SETGET_FUNCS(balance_flags, struct btrfs_balance_item, flags, 64);
+
+static inline void btrfs_balance_data(struct extent_buffer *eb,
+				      struct btrfs_balance_item *bi,
+				      struct btrfs_disk_balance_args *ba)
+{
+	read_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
+}
+
+static inline void btrfs_set_balance_data(struct extent_buffer *eb,
+					  struct btrfs_balance_item *bi,
+					  struct btrfs_disk_balance_args *ba)
+{
+	write_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
+}
+
+static inline void btrfs_balance_meta(struct extent_buffer *eb,
+				      struct btrfs_balance_item *bi,
+				      struct btrfs_disk_balance_args *ba)
+{
+	read_eb_member(eb, bi, struct btrfs_balance_item, meta, ba);
+}
+
+static inline void btrfs_set_balance_meta(struct extent_buffer *eb,
+					  struct btrfs_balance_item *bi,
+					  struct btrfs_disk_balance_args *ba)
+{
+	write_eb_member(eb, bi, struct btrfs_balance_item, meta, ba);
+}
+
+static inline void btrfs_balance_sys(struct extent_buffer *eb,
+				     struct btrfs_balance_item *bi,
+				     struct btrfs_disk_balance_args *ba)
+{
+	read_eb_member(eb, bi, struct btrfs_balance_item, sys, ba);
+}
+
+static inline void btrfs_set_balance_sys(struct extent_buffer *eb,
+					 struct btrfs_balance_item *bi,
+					 struct btrfs_disk_balance_args *ba)
+{
+	write_eb_member(eb, bi, struct btrfs_balance_item, sys, ba);
+}
 
+static inline void
+btrfs_disk_balance_args_to_cpu(struct btrfs_balance_args *cpu,
+			       struct btrfs_disk_balance_args *disk)
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
+btrfs_cpu_balance_args_to_disk(struct btrfs_disk_balance_args *disk,
+			       struct btrfs_balance_args *cpu)
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
index d1beac1..1f9fdb7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2073,6 +2073,97 @@ error:
 	return ret;
 }
 
+static int insert_balance_item(struct btrfs_root *root,
+			       struct btrfs_balance_control *bctl)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_balance_item *item;
+	struct btrfs_disk_balance_args disk_bargs;
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
+	key.objectid = BTRFS_BALANCE_OBJECTID;
+	key.type = BTRFS_BALANCE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+				      sizeof(*item));
+	if (ret)
+		goto out;
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
+
+	memset_extent_buffer(leaf, 0, (unsigned long)item, sizeof(*item));
+
+	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->data);
+	btrfs_set_balance_data(leaf, item, &disk_bargs);
+	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->meta);
+	btrfs_set_balance_meta(leaf, item, &disk_bargs);
+	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->sys);
+	btrfs_set_balance_sys(leaf, item, &disk_bargs);
+
+	btrfs_set_balance_flags(leaf, item, bctl->flags);
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
+static int del_balance_item(struct btrfs_root *root)
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
+	key.objectid = BTRFS_BALANCE_OBJECTID;
+	key.type = BTRFS_BALANCE_ITEM_KEY;
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
  * Should be called with both balance and volume mutexes held to
  * serialize other volume operations (add_dev/rm_dev/resize) with
@@ -2419,7 +2510,11 @@ error:
 
 static void __cancel_balance(struct btrfs_fs_info *fs_info)
 {
+	int ret;
+
 	unset_balance_control(fs_info);
+	ret = del_balance_item(fs_info->tree_root);
+	BUG_ON(ret);
 }
 
 /*
@@ -2521,6 +2616,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl, int resume)
 	}
 
 do_balance:
+	ret = insert_balance_item(fs_info->tree_root, bctl);
+	if (ret && ret != -EEXIST)
+		goto out;
+	BUG_ON((ret == -EEXIST && !resume) || (ret != -EEXIST && resume));
+
 	if (!resume)
 		set_balance_control(bctl);
 
-- 
1.7.6.3

