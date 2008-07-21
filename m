From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs-progs new dir index support
Date: Mon, 21 Jul 2008 11:21:04 -0400
Message-ID: <20080721152104.GA25070@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here is the btrfs-progs patch needed for the new dir index stuff to work
properly.  Thanks,

Josef

diff -r 1235216d952d ctree.h
--- a/ctree.h	Fri Jul 11 18:39:36 2008 -0400
+++ b/ctree.h	Sat Jul 12 03:08:52 2008 -0400
@@ -349,6 +349,7 @@ struct btrfs_dev_extent {
 } __attribute__ ((__packed__));
 
 struct btrfs_inode_ref {
+	__le64 index;
 	__le16 name_len;
 	/* name goes here */
 } __attribute__ ((__packed__));
@@ -795,6 +796,7 @@ BTRFS_SETGET_STACK_FUNCS(block_group_fla
 
 /* struct btrfs_inode_ref */
 BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
+BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 
 /* struct btrfs_inode_item */
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
@@ -1461,7 +1463,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid);
+			   u64 inode_objectid, u64 ref_objectid, u64 index);
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
diff -r 1235216d952d inode-item.c
--- a/inode-item.c	Fri Jul 11 18:39:36 2008 -0400
+++ b/inode-item.c	Sat Jul 12 03:08:52 2008 -0400
@@ -106,7 +106,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
-			   u64 inode_objectid, u64 ref_objectid)
+			   u64 inode_objectid, u64 ref_objectid, u64 index)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -138,6 +138,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 				     struct btrfs_inode_ref);
 		ref = (struct btrfs_inode_ref *)((unsigned long)ref + old_size);
 		btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
+		btrfs_set_inode_ref_index(path->nodes[0], ref, index);
 		ptr = (unsigned long)(ref + 1);
 		ret = 0;
 	} else if (ret < 0) {
@@ -146,6 +147,7 @@ int btrfs_insert_inode_ref(struct btrfs_
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_inode_ref);
 		btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
+		btrfs_set_inode_ref_index(path->nodes[0], ref, index);
 		ptr = (unsigned long)(ref + 1);
 	}
 	write_extent_buffer(path->nodes[0], name, ptr, name_len);
diff -r 1235216d952d mkfs.c
--- a/mkfs.c	Fri Jul 11 18:39:36 2008 -0400
+++ b/mkfs.c	Sat Jul 12 03:08:52 2008 -0400
@@ -137,7 +137,7 @@ static int make_root_dir(int fd, const c
 
 	ret = btrfs_insert_inode_ref(trans, root->fs_info->tree_root,
 			     "default", 7, location.objectid,
-			     BTRFS_ROOT_TREE_DIR_OBJECTID);
+			     BTRFS_ROOT_TREE_DIR_OBJECTID, 0);
 	if (ret)
 		goto err;
 
diff -r 1235216d952d print-tree.c
--- a/print-tree.c	Fri Jul 11 18:39:36 2008 -0400
+++ b/print-tree.c	Sat Jul 12 03:08:52 2008 -0400
@@ -61,14 +61,16 @@ static int print_inode_ref_item(struct e
 	u32 cur = 0;
 	u32 len;
 	u32 name_len;
+	u64 index;
 	char namebuf[BTRFS_NAME_LEN];
 	total = btrfs_item_size(eb, item);
 	while(cur < total) {
 		name_len = btrfs_inode_ref_name_len(eb, ref);
+		index = btrfs_inode_ref_index(eb, ref);
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
 		read_extent_buffer(eb, namebuf, (unsigned long)(ref + 1), len);
-		printf("\t\tinode ref namelen %u name: %.*s\n",
-		       name_len, len, namebuf);
+		printf("\t\tinode ref index %llu namelen %u name: %.*s\n",
+		       index, name_len, len, namebuf);
 		len = sizeof(*ref) + name_len;
 		ref = (struct btrfs_inode_ref *)((char *)ref + len);
 		cur += len;
diff -r 1235216d952d utils.c
--- a/utils.c	Fri Jul 11 18:39:36 2008 -0400
+++ b/utils.c	Sat Jul 12 03:08:52 2008 -0400
@@ -561,7 +561,7 @@ int btrfs_make_root_dir(struct btrfs_tra
 	if (ret)
 		goto error;
 
-	ret = btrfs_insert_inode_ref(trans, root, "..", 2, objectid, objectid);
+	ret = btrfs_insert_inode_ref(trans, root, "..", 2, objectid, objectid, 0);
 	if (ret)
 		goto error;
 
