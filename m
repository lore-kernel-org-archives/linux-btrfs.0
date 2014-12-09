Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10669 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754026AbaLII2F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:28:05 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RNVY013494
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:23 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 10/13] btrfs-progs: Add fixing function for inodes whose nlink dismatch
Date: Tue, 9 Dec 2014 16:27:29 +0800
Message-ID: <1418113652-25088-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
At least two users have already hit a bug in btrfs causing file
missing(Chromium config file).
The missing file's nlink is still 1 but its backref points to non-exist
parent inode.

This should be a kernel bug, but btrfsck fix is needed anyway.

[FIX]
For such nlink mismatch inode, we will reset all the inode_ref with its
dir_index/item (including valid one), and re-add the valids.
If there is no valid backref for it, create 'lost+found' under the root
of the subvolume and add link to the directory.

Reported-by: Mike Gavrilov <mikhail.v.gavrilov@gmail.com>
Reported-by: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

---
changelog:
v2:
   1.Use the a more generic fucntion, reset_nlink(), to repair the inode
     nlink.
     It will remove all, including valid, backref(along with
     dir_item/index) and set nlink to 0, and add valid ones back.
     This reset_nlink() method can handle more nlink error, not only
     invalid inode_ref but also pure nlinks mismatch(2 valid inode_ref but
     nlink is 1)

   2.Fix a small bug in check_dir_conflict() which may cause false
     conflict report.
v3:
   No change.

v4:
   1.Use the highed ino + 1 as the lost+found dir inode number.
     This cooperates with later leaf-dropping recover things.
   2.Get rid of math lib
   3.Add fallback file name and file type in nlink_repair, it is quite
     important to cooperate with inode item rebuild function.
---
 cmds-check.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 190 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 3ec619f..69142ef 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1837,6 +1837,18 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			struct btrfs_trans_handle *trans;
 			struct btrfs_key location;
 
+			ret = check_dir_conflict(root, backref->name,
+						 backref->namelen,
+						 backref->dir,
+						 backref->index);
+			if (ret) {
+				/*
+				 * let nlink fixing routine to handle it,
+				 * which can do it better.
+				 */
+				ret = 0;
+				break;
+			}
 			location.objectid = rec->ino;
 			location.type = BTRFS_INODE_ITEM_KEY;
 			location.offset = 0;
@@ -1915,20 +1927,192 @@ static int find_file_name(struct inode_record *rec,
 	return -ENOENT;
 }
 
+/* Reset the nlink of the inode to the correct one */
+static int reset_nlink(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       struct btrfs_path *path,
+		       struct inode_record *rec)
+{
+	struct inode_backref *backref;
+	struct inode_backref *tmp;
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	int ret = 0;
+
+	/* Remove all backref including the valid ones */
+	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
+		ret = btrfs_unlink(trans, root, rec->ino, backref->dir,
+				   backref->index, backref->name,
+				   backref->namelen, 0);
+		if (ret < 0)
+			goto out;
+
+		/* remove invalid backref, so it won't be added back */
+		if (!(backref->found_dir_index &&
+		      backref->found_dir_item &&
+		      backref->found_inode_ref)) {
+			list_del(&backref->list);
+			free(backref);
+		}
+	}
+
+	/* Set nlink to 0 */
+	key.objectid = rec->ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+	btrfs_set_inode_nlink(path->nodes[0], inode_item, 0);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_release_path(path);
+
+	/*
+	 * Add back valid inode_ref/dir_item/dir_index,
+	 * add_link() will handle the nlink inc, so new nlink must be correct
+	 */
+	list_for_each_entry(backref, &rec->backrefs, list) {
+		ret = btrfs_add_link(trans, root, rec->ino, backref->dir,
+				     backref->name, backref->namelen,
+				     backref->ref_type, &backref->index, 1);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	btrfs_release_path(path);
+	return ret;
+}
+
+static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       struct inode_record *rec)
+{
+	char *dir_name = "lost+found";
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	u64 lost_found_ino;
+	u32 mode = 0700;
+	u8 type = 0;
+	int namelen = 0;
+	int name_recovered = 0;
+	int type_recovered = 0;
+	int ret = 0;
+
+	/*
+	 * Get file name and type first before these invalid inode ref
+	 * are deleted by remove_all_invalid_backref()
+	 */
+	name_recovered = !find_file_name(rec, namebuf, &namelen);
+	type_recovered = !find_file_type(rec, &type);
+
+	if (!name_recovered) {
+		printf("Can't get file name for inode %llu, use '%llu' as fallback\n",
+		       rec->ino, rec->ino);
+		namelen = count_digit(rec->ino);
+		sprintf(namebuf, "%llu", rec->ino);
+		name_recovered = 1;
+	}
+	if (!type_recovered) {
+		printf("Can't get file type for inode %llu, use FILE as fallback\n",
+		       rec->ino);
+		type = BTRFS_FT_REG_FILE;
+		type_recovered = 1;
+	}
+
+	ret = reset_nlink(trans, root, path, rec);
+	if (ret < 0) {
+		fprintf(stderr,
+			"Fail to reset nlink for inode %llu: %s\n",
+			rec->ino, strerror(-ret));
+		goto out;
+	}
+
+	if (rec->found_link == 0) {
+		lost_found_ino = root->highest_inode;
+		if (lost_found_ino >= BTRFS_LAST_FREE_OBJECTID) {
+			ret = -EOVERFLOW;
+			goto out;
+		}
+		lost_found_ino++;
+		ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
+				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
+				  mode);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to create '%s' dir: %s",
+				dir_name, strerror(-ret));
+			goto out;
+		}
+		ret = btrfs_add_link(trans, root, rec->ino, lost_found_ino,
+				     namebuf, namelen, type, NULL, 1);
+		if (ret == -EEXIST) {
+			/*
+			 * Conflicting file name, add ".INO" as suffix
+			 * +1 for '.'
+			 */
+			if (namelen + count_digit(rec->ino) + 1 >
+			    BTRFS_NAME_LEN) {
+				ret = -EFBIG;
+				goto out;
+			}
+			snprintf(namebuf + namelen, BTRFS_NAME_LEN - namelen,
+				 ".%llu", rec->ino);
+			namelen += count_digit(rec->ino) + 1;
+			ret = btrfs_add_link(trans, root, rec->ino,
+					     lost_found_ino, namebuf,
+					     namelen, type, NULL, 1);
+		}
+		if (ret < 0) {
+			fprintf(stderr,
+				"Fail to link the inode %llu to %s dir: %s",
+				rec->ino, dir_name, strerror(-ret));
+			goto out;
+		}
+		/*
+		 * Just increase the found_link, don't actually add the
+		 * backref. This will make things easiler and this inode
+		 * record will be freed after the repair is done.
+		 * So fsck will not report problem about this inode.
+		 */
+		rec->found_link++;
+		printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
+		       namelen, namebuf, dir_name);
+	}
+	rec->errors &= ~I_ERR_LINK_COUNT_WRONG;
+	printf("Fixed the nlink of inode %llu\n", rec->ino);
+out:
+	btrfs_release_path(path);
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	int ret = 0;
 
-	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG | I_ERR_NO_ORPHAN_ITEM)))
+	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
+			     I_ERR_NO_ORPHAN_ITEM |
+			     I_ERR_LINK_COUNT_WRONG)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * For nlink repair, it may create a dir and add link, so
+	 * 2 for parent(256)'s dir_index and dir_item
+	 * 2 for lost+found dir's inode_item and inode_ref
+	 * 1 for the new inode_ref of the file
+	 * 2 for lost+found dir's dir_index and dir_item for the file
+	 */
+	trans = btrfs_start_transaction(root, 7);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
 		return PTR_ERR(trans);
@@ -1938,6 +2122,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_inode_isize(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
 		ret = repair_inode_orphan_item(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_LINK_COUNT_WRONG)
+		ret = repair_inode_nlinks(trans, root, path, rec);
 	btrfs_commit_transaction(trans, root);
 	btrfs_free_path(path);
 	return ret;
@@ -2088,6 +2274,8 @@ static int check_inode_recs(struct btrfs_root *root,
 			}
 		}
 
+		if (rec->found_link != rec->nlink)
+			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		if (repair) {
 			ret = try_repair_inode(root, rec);
 			if (ret == 0 && can_free_inode_rec(rec)) {
@@ -2100,8 +2288,6 @@ static int check_inode_recs(struct btrfs_root *root,
 		error++;
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
-		if (rec->found_link != rec->nlink)
-			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		print_inode_error(root, rec);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
-- 
2.1.3

