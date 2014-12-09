Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10669 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754026AbaLII2I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:28:08 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RQUn013504
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 13/13] btrfs-progs: Add inode item rebuild function.
Date: Tue, 9 Dec 2014 16:27:32 +0800
Message-ID: <1418113652-25088-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a basic inode item rebuild function for I_ERR_NO_INODE_ITEM.
The main use case is to repair btrfs which fs root has corrupted leaf,
but it is already working for case if the corrupteed fs root leaf/node
contains no inode extent_data.

The repair needs 3 elements for inode rebuild:
1. inode number
   This is quite easy, existing inode_record codes will detect it quite
   well.

2. inode type
   This is the trick part. The only reliable method is to recovery it from
   parent's dir_index/item.
   The remaining method will search for regular file extent for FILE
   type or child's backref for DIR(todo).
   Fallback will be FILE.

Inode name(inode_ref) will be recoverd by nlink repair function.

This is just a fundamental implement, some advanced recovery can be
improved later with btrfs-progs infrastructure change.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   Newly introduced.
v3:
   Get rid of math lib.
v4:
   Don't do the mkdir() or add_link() things in this patch. Just pass it
   to nlink repair function.
---
 cmds-check.c | 161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ctree.h      |   3 ++
 inode.c      |   6 +--
 3 files changed, 163 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e68966b..691ce5c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1905,6 +1905,12 @@ static int find_file_type(struct inode_record *rec, u8 *type)
 {
 	struct inode_backref *backref;
 
+	/* For inode item recovered case */
+	if (rec->found_inode_item) {
+		*type = imode_to_type(rec->imode);
+		return 0;
+	}
+
 	list_for_each_entry(backref, &rec->backrefs, list) {
 		if (backref->found_dir_index || backref->found_dir_item) {
 			*type = backref->filetype;
@@ -2099,6 +2105,150 @@ out:
 	return ret;
 }
 
+/*
+ * Check if there is any normal(reg or prealloc) file extent for given
+ * ino.
+ * This is used to determine the file type when neither its dir_index/item or
+ * inode_item exists.
+ *
+ * This will *NOT* report error, if any error happens, just consider it does
+ * not have any normal file extent.
+ */
+static int find_normal_file_extent(struct btrfs_root *root,
+				   u64 ino)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_file_extent_item *fi;
+	u8 type;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		goto out;
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		ret = 0;
+		goto out;
+	}
+	if (ret && path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+		ret = btrfs_next_leaf(root, path);
+		if (ret) {
+			ret = 0;
+			goto out;
+		}
+	}
+	while (1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		if (found_key.objectid != ino ||
+		    found_key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(path->nodes[0], fi);
+		if (type != BTRFS_FILE_EXTENT_INLINE)
+			ret = 1;
+			goto out;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static u32 btrfs_type_to_imode(u8 type)
+{
+	static u32 imode_by_btrfs_type[] = {
+		[BTRFS_FT_REG_FILE]	= S_IFREG,
+		[BTRFS_FT_DIR]		= S_IFDIR,
+		[BTRFS_FT_CHRDEV]	= S_IFCHR,
+		[BTRFS_FT_BLKDEV]	= S_IFBLK,
+		[BTRFS_FT_FIFO]		= S_IFIFO,
+		[BTRFS_FT_SOCK]		= S_IFSOCK,
+		[BTRFS_FT_SYMLINK]	= S_IFLNK,
+	};
+
+	return imode_by_btrfs_type[(type)];
+}
+
+static int repair_inode_no_item(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_path *path,
+				struct inode_record *rec)
+{
+	u8 filetype;
+	u32 mode = 0700;
+	int type_recovered = 0;
+	int ret = 0;
+
+	/*
+	 * TODO:
+	 * 1. salvage data from existing file extent and
+	 *    punch hole to keep fi ext consistent.
+	 * 2. salvage data from extent tree
+	 */
+	printf("Trying to rebuild inode:%llu\n", rec->ino);
+
+	type_recovered = !find_file_type(rec, &filetype);
+
+	/*
+	 * Try to determine inode type if type not found.
+	 *
+	 * For found regular file extent, it must be FILE.
+	 * For found dir_item/index, it must be DIR.
+	 *
+	 * For undetermined one, use FILE as fallback.
+	 *
+	 * TODO:
+	 * 1. If found extent belong to it in extent tree, it must be FILE
+	 *    Need extra hook in extent tree scan.
+	 * 2. If found backref(inode_index/item is already handled) to it,
+	 *    it must be DIR.
+	 *    Need new inode-inode ref structure to allow search for that.
+	 */
+	if (!type_recovered) {
+		if (rec->found_file_extent &&
+		    find_normal_file_extent(root, rec->ino)) {
+			type_recovered = 1;
+			filetype = BTRFS_FT_REG_FILE;
+		} else if (rec->found_dir_item) {
+			type_recovered = 1;
+			filetype = BTRFS_FT_DIR;
+		} else {
+			printf("Can't determint the filetype for inode %llu, assume it is a normal file\n",
+			       rec->ino);
+			type_recovered = 1;
+			filetype = BTRFS_FT_REG_FILE;
+		}
+	}
+
+	ret = btrfs_new_inode(trans, root, rec->ino,
+			      mode | btrfs_type_to_imode(filetype));
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Here inode rebuild is done, we only rebuild the inode item,
+	 * don't repair the nlink(like move to lost+found).
+	 * That is the job of nlink repair.
+	 *
+	 * We just fill the record and return
+	 */
+	rec->found_dir_item = 1;
+	rec->imode = mode | btrfs_type_to_imode(filetype);
+	rec->nlink = 0;
+	rec->errors &= ~I_ERR_NO_INODE_ITEM;
+	/* Ensure the inode_nlinks repair function will be called */
+	rec->errors |= I_ERR_LINK_COUNT_WRONG;
+out:
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
@@ -2107,7 +2257,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 
 	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
 			     I_ERR_NO_ORPHAN_ITEM |
-			     I_ERR_LINK_COUNT_WRONG)))
+			     I_ERR_LINK_COUNT_WRONG |
+			     I_ERR_NO_INODE_ITEM)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
@@ -2127,7 +2278,9 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		return PTR_ERR(trans);
 	}
 
-	if (rec->errors & I_ERR_DIR_ISIZE_WRONG)
+	if (rec->errors & I_ERR_NO_INODE_ITEM)
+		ret = repair_inode_no_item(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
 		ret = repair_inode_isize(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
 		ret = repair_inode_orphan_item(trans, root, path, rec);
@@ -2283,6 +2436,8 @@ static int check_inode_recs(struct btrfs_root *root,
 			}
 		}
 
+		if (!rec->found_inode_item)
+			rec->errors |= I_ERR_NO_INODE_ITEM;
 		if (rec->found_link != rec->nlink)
 			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		if (repair) {
@@ -2295,8 +2450,6 @@ static int check_inode_recs(struct btrfs_root *root,
 		}
 
 		error++;
-		if (!rec->found_inode_item)
-			rec->errors |= I_ERR_NO_INODE_ITEM;
 		print_inode_error(root, rec);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
diff --git a/ctree.h b/ctree.h
index 682255c..dbe9b39 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2449,6 +2449,9 @@ static inline int is_fstree(u64 rootid)
 int check_dir_conflict(struct btrfs_root *root,
 		       char *name, int namelen,
 		       u64 dir, u64 index);
+int btrfs_new_inode(struct btrfs_trans_handle *trans,
+		    struct btrfs_root *root,
+		    u64 ino, u32 mode);
 int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   u64 ino, u64 parent_ino, char *name, int namelen,
 		   u8 type, u64 *index, int add_backref);
diff --git a/inode.c b/inode.c
index de35bd1..c99fe38 100644
--- a/inode.c
+++ b/inode.c
@@ -463,9 +463,9 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
  * its backref.
  * The backref is added by btrfs_add_link().
  */
-static int btrfs_new_inode(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   u64 ino, u32 mode)
+int btrfs_new_inode(struct btrfs_trans_handle *trans,
+		    struct btrfs_root *root,
+		    u64 ino, u32 mode)
 {
 	struct btrfs_inode_item inode_item = {0};
 	int ret = 0;
-- 
2.1.3

