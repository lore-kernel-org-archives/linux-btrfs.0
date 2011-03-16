From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add checks to verify dir items are correct
Date: Wed, 16 Mar 2011 16:49:51 -0400
Message-ID: <1300308591-3594-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We need to make sure the dir items we get are valid dir items.  So any time we
try and read one check it with verify_dir_item, which will do various sanity
checks to make sure it looks sane.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h    |    2 ++
 fs/btrfs/dir-item.c |   35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c    |    5 +++++
 fs/btrfs/tree-log.c |    7 +++++++
 fs/btrfs/xattr.c    |    2 ++
 5 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 841330f..037d6ef 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2393,6 +2393,8 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  struct btrfs_path *path, u64 dir,
 					  const char *name, u16 name_len,
 					  int mod);
+int verify_dir_item(struct extent_buffer *leaf,
+		    struct btrfs_dir_item *dir_item);
 
 /* orphan.c */
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index f0cad5a..02c97ad 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -377,6 +377,9 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_root *root,
 
 	leaf = path->nodes[0];
 	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
+	if (verify_dir_item(root, leaf, dir_item))
+		return NULL;
+
 	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
 	while (cur < total_len) {
 		this_len = sizeof(*dir_item) +
@@ -429,3 +432,35 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 	}
 	return ret;
 }
+
+int verify_dir_item(struct btrfs_root *root,
+		    struct extent_buffer *leaf,
+		    struct btrfs_dir_item *dir_item)
+{
+	u16 namelen = BTRFS_NAME_LEN;
+	u8 type = btrfs_dir_type(leaf, dir_item);
+
+	if (type >= BTRFS_FT_MAX) {
+		printk(KERN_CRIT "btrfs: invalid dir item type: %d\n",
+		       (int)type);
+		return 1;
+	}
+
+	if (type == BTRFS_FT_XATTR)
+		namelen = XATTR_NAME_MAX;
+
+	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
+		printk(KERN_CRIT "btrfS: invalid dir item name len: %u\n",
+		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		return 1;
+	}
+
+	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
+	if (btrfs_dir_data_len(leaf, dir_item) > BTRFS_MAX_XATTR_SIZE(root)) {
+		printk(KERN_CRIT "btrfs: invalid dir item data len: %u\n",
+		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		return 1;
+	}
+
+	return 0;
+}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 888dbdb..e7568de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4266,6 +4266,9 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 		filp->f_pos = found_key.offset;
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
+		if (verify_dir_item(root, leaf, di))
+			continue;
+
 		di_cur = 0;
 		di_total = btrfs_item_size(leaf, item);
 
@@ -4310,6 +4313,8 @@ skip:
 				 btrfs_dir_data_len(leaf, di) + sizeof(*di);
 			di_cur += di_len;
 			di = (struct btrfs_dir_item *)((char *)di + di_len);
+			if (verify_dir_item(root, leaf, di))
+				break;
 		}
 	}
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a4bbb85..429cfcf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1286,6 +1286,8 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
+		if (verify_dir_item(root, eb, di))
+			return -EIO;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
 		BUG_ON(ret);
@@ -1412,6 +1414,11 @@ again:
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
+		if (verify_dir_item(root, eb, di)) {
+			ret = -EIO;
+			goto out;
+		}
+
 		name_len = btrfs_dir_name_len(eb, di);
 		name = kmalloc(name_len, GFP_NOFS);
 		if (!name) {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index a577653..e5d22f2 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -242,6 +242,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			break;
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
+		if (verify_dir_item(root, leaf, di))
+			continue;
 
 		name_len = btrfs_dir_name_len(leaf, di);
 		total_size += name_len + 1;
-- 
1.7.2.3

