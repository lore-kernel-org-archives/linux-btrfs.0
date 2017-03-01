Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23240 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751393AbdCADSD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:03 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 78F1B48A2945
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:20 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 18/20] btrfs-progs: cmds-check.c: repair nlinks lowmem
Date: Wed, 1 Mar 2017 11:14:01 +0800
Message-ID: <20170301031403.23902-19-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'repair_inode_nlinks_lowmem'.
If ref is 0, move the inode to "lost + found".
Set inode item's nlink to ref_count.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 233 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 179 insertions(+), 54 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 9ac08dfd..ae80d5f0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2912,15 +2912,17 @@ static int get_highest_inode(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path, u64 ino,
+				   char *name, u32 name_len, u8 filetype,
+				   u64 *ref_count);
 static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_path *path,
 			       struct inode_record *rec)
 {
-	char *dir_name = "lost+found";
 	char namebuf[BTRFS_NAME_LEN] = {0};
-	u64 lost_found_ino;
-	u32 mode = 0700;
 	u8 type = 0;
 	int namelen = 0;
 	int name_recovered = 0;
@@ -2957,55 +2959,11 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 	}
 
 	if (rec->found_link == 0) {
-		ret = get_highest_inode(trans, root, path, &lost_found_ino);
-		if (ret < 0)
-			goto out;
-		lost_found_ino++;
-		ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
-				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
-				  mode);
-		if (ret < 0) {
-			fprintf(stderr, "Failed to create '%s' dir: %s\n",
-				dir_name, strerror(-ret));
-			goto out;
-		}
-		ret = btrfs_add_link(trans, root, rec->ino, lost_found_ino,
-				     namebuf, namelen, type, NULL, 1, 0);
-		/*
-		 * Add ".INO" suffix several times to handle case where
-		 * "FILENAME.INO" is already taken by another file.
-		 */
-		while (ret == -EEXIST) {
-			/*
-			 * Conflicting file name, add ".INO" as suffix * +1 for '.'
-			 */
-			if (namelen + count_digits(rec->ino) + 1 >
-			    BTRFS_NAME_LEN) {
-				ret = -EFBIG;
-				goto out;
-			}
-			snprintf(namebuf + namelen, BTRFS_NAME_LEN - namelen,
-				 ".%llu", rec->ino);
-			namelen += count_digits(rec->ino) + 1;
-			ret = btrfs_add_link(trans, root, rec->ino,
-					     lost_found_ino, namebuf,
-					     namelen, type, NULL, 1, 0);
-		}
-		if (ret < 0) {
-			fprintf(stderr,
-				"Failed to link the inode %llu to %s dir: %s\n",
-				rec->ino, dir_name, strerror(-ret));
+		ret = link_inode_to_lostfound(trans, root, path, rec->ino,
+					      namebuf, namelen, type,
+					      (u64 *)&rec->found_link);
+		if (ret)
 			goto out;
-		}
-		/*
-		 * Just increase the found_link, don't actually add the
-		 * backref. This will make things easier and this inode
-		 * record will be freed after the repair is done.
-		 * So fsck will not report problem about this inode.
-		 */
-		rec->found_link++;
-		printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
-		       namelen, namebuf, dir_name);
 	}
 	printf("Fixed the nlink of inode %llu\n", rec->ino);
 out:
@@ -5430,6 +5388,160 @@ out:
 }
 
 /*
+ * Link inode to dir 'lost+found'. Increase @ref_count.
+ *
+ * Returns 0 means success.
+ * Returns <0 means failure.
+ */
+static int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path,
+				   u64 ino, char *namebuf, u32 name_len,
+				   u8 filetype, u64 *ref_count)
+{
+	char *dir_name = "lost+found";
+	u64 lost_found_ino;
+	int ret;
+	u32 mode = 0700;
+
+	btrfs_release_path(path);
+	ret = get_highest_inode(trans, root, path, &lost_found_ino);
+	if (ret < 0)
+		goto out;
+	lost_found_ino++;
+
+	ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
+			  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
+			  mode);
+	if (ret < 0) {
+		error("Failed to create '%s' dir: %s\n", dir_name,
+		      strerror(-ret));
+		goto out;
+	}
+	ret = btrfs_add_link(trans, root, ino, lost_found_ino,
+			     namebuf, name_len, filetype, NULL, 1, 0);
+	/*
+	 * Add ".INO" suffix several times to handle case where
+	 * "FILENAME.INO" is already taken by another file.
+	 */
+	while (ret == -EEXIST) {
+		/*
+		 * Conflicting file name, add ".INO" as suffix * +1
+		 * for '.'
+		 */
+		if (name_len + count_digits(ino) + 1 >
+		    BTRFS_NAME_LEN) {
+			ret = -EFBIG;
+			goto out;
+		}
+		snprintf(namebuf + name_len, BTRFS_NAME_LEN - name_len,
+			 ".%llu", ino);
+		name_len += count_digits(ino) + 1;
+		ret = btrfs_add_link(trans, root, ino,
+				     lost_found_ino, namebuf,
+				     name_len, filetype, NULL, 1, 0);
+	}
+	if (ret < 0) {
+		error("Failed to link the inode %llu to %s dir: %s\n",
+		      ino, dir_name, strerror(-ret));
+		goto out;
+	}
+
+	++*ref_count;
+	printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
+	       name_len, namebuf, dir_name);
+out:
+	btrfs_release_path(path);
+	if (ret)
+		error("Failed to move file '%.*s' to '%s' dir",
+		      name_len, namebuf, dir_name);
+	return ret;
+}
+
+/* Reset inode_item nlink to @ref_count.
+ * If @ref_count == 0, move it to "lost+found" and increase @ref_count
+ * first.
+ *
+ * @ref_count: the refs counts found
+ * @nlink    : return with value of nlink after repair
+ * Returns 0 means success
+ * Returns <0 means failure
+ */
+static int repair_inode_nlinks_lowmem(struct btrfs_root *root,
+				      struct btrfs_path *path, u64 ino,
+				      const char *name, u32 namelen,
+				      u64 ref_count, u8 filetype, u64 *nlink)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_inode_item *ii;
+	struct btrfs_key key;
+	struct btrfs_key key_store;
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	int name_len;
+	int ret;
+	int ret2;
+	/* save the key */
+	btrfs_item_key_to_cpu(path->nodes[0], &key_store, path->slots[0]);
+
+	if (name && namelen) {
+		ASSERT(namelen <= BTRFS_NAME_LEN);
+		memcpy(namebuf, name, namelen);
+		name_len = namelen;
+	} else {
+		sprintf(namebuf, "%llu", ino);
+		name_len = count_digits(ino);
+		printf("Can't find file name for inode %llu, use %s instead\n",
+		       ino, namebuf);
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_release_path(path);
+	if (ref_count == 0) {
+		ret = link_inode_to_lostfound(trans, root, path, ino, namebuf,
+					      name_len, filetype, &ref_count);
+		if (ret)
+			goto out;
+	}
+	/* reset inode_item's nlink to ref_count */
+	btrfs_release_path(path);
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret)
+		goto out;
+
+	ii = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_inode_item);
+	btrfs_set_inode_nlink(path->nodes[0], ii, ref_count);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(path);
+
+	btrfs_commit_transaction(trans, root);
+out:
+	btrfs_release_path(path);
+	if (nlink)
+		*nlink = ref_count;
+
+	if (!ret)
+		printf("Fixed the nlink of inode %llu root %llu name %s filetype %u\n",
+		       root->objectid, ino, namebuf, filetype);
+	else
+		printf("Fixed the nlink of inode %llu root %llu name %s filetype %u\n",
+		       root->objectid, ino, namebuf, filetype);
+
+	/* research */
+	btrfs_release_path(path);
+	ret2 = btrfs_search_slot(NULL, root, &key_store, path, 0, 0);
+	if (ret2 < 0)
+		return ret2;
+	return ret;
+}
+
+/*
  * Check INODE_ITEM and related ITEMs (the same inode number)
  * 1. check link count
  * 2. check inode ref/extref
@@ -5554,6 +5666,13 @@ out:
 
 	/* verify INODE_ITEM nlink/isize/nbytes */
 	if (dir) {
+		if ((nlink != 1 || refs != 1) && repair)
+			ret = repair_inode_nlinks_lowmem(root, path,
+							 inode_id,
+							 namebuf, name_len,
+							 refs,
+							 imode_to_type(mode),
+							 &nlink);
 		if (nlink != 1) {
 			err |= LINK_COUNT_ERROR;
 			error("root %llu DIR INODE[%llu] shouldn't have more than one link(%llu)",
@@ -5583,9 +5702,15 @@ out:
 		}
 	} else {
 		if (nlink != refs) {
-			err |= LINK_COUNT_ERROR;
-			error("root %llu INODE[%llu] nlink(%llu) not equal to inode_refs(%llu)",
-			      root->objectid, inode_id, nlink, refs);
+			if (repair)
+				ret = repair_inode_nlinks_lowmem(root,
+								 path,
+								 inode_id,
+								 namebuf,
+								 name_len,
+								 refs,
+								 imode_to_type(mode),
+								 &nlink);
 		} else if (!nlink) {
 			if (repair)
 				ret = repair_inode_orphan_item_lowmem(root,
-- 
2.11.1



