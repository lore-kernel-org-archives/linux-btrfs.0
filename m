Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40628 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755258AbaDXKyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 06:54:13 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3OAs7De000516
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 18:54:08 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/3] Btrfs-progs: fsck: add ability to check reloc roots
Date: Thu, 24 Apr 2014 18:51:10 +0800
Message-ID: <1398336670-26496-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When encountering system crash or balance enospc errors,
there maybe still some reloc roots left.

The way we store reloc root is different from fs root:

reloc root's root key(BTRFS_RELOC_TREE_OBJECTID, ROOT_ITEM, objectid)
fs root's root key(objectid, ROOT_ITEM, -1)
reloc data's root key(BTRFS_DATA_RELOC_TREE_OBJECTID, ROOT_ITEM, 0)

So this patch use right key to search corresponding root node, and
avoid using normal fs root cache for reloc roots.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2: fix memory leaks and use normal fs root cache for data
	relocation root node.
---
 cmds-check.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e6fb380..2a87398 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -299,8 +299,22 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	return rec;
 }
 
-static void print_inode_error(int errors)
+static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 {
+	u64 root_objectid = root->root_key.objectid;
+	int errors = rec->errors;
+
+	if (!errors)
+		return;
+	/* reloc root errors, we print its corresponding fs root objectid*/
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		root_objectid = root->root_key.offset;
+		fprintf(stderr, "reloc");
+	}
+	fprintf(stderr, "root %llu inode %llu errors %x",
+		(unsigned long long) root_objectid,
+		(unsigned long long) rec->ino, rec->errors);
+
 	if (errors & I_ERR_NO_INODE_ITEM)
 		fprintf(stderr, ", no inode item");
 	if (errors & I_ERR_NO_ORPHAN_ITEM)
@@ -1598,10 +1612,7 @@ static int check_inode_recs(struct btrfs_root *root,
 			rec->errors |= I_ERR_NO_INODE_ITEM;
 		if (rec->found_link != rec->nlink)
 			rec->errors |= I_ERR_LINK_COUNT_WRONG;
-		fprintf(stderr, "root %llu inode %llu errors %x",
-			(unsigned long long) root->root_key.objectid,
-			(unsigned long long) rec->ino, rec->errors);
-		print_inode_error(rec->errors);
+		print_inode_error(root, rec);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
 				backref->errors |= REF_ERR_NO_DIR_ITEM;
@@ -2059,8 +2070,14 @@ static int check_fs_roots(struct btrfs_root *root,
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
 		if (key.type == BTRFS_ROOT_ITEM_KEY &&
 		    fs_root_objectid(key.objectid)) {
-			key.offset = (u64)-1;
-			tmp_root = btrfs_read_fs_root(root->fs_info, &key);
+			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+				tmp_root = btrfs_read_fs_root_no_cache(
+						root->fs_info, &key);
+			} else {
+				key.offset = (u64)-1;
+				tmp_root = btrfs_read_fs_root(
+						root->fs_info, &key);
+			}
 			if (IS_ERR(tmp_root)) {
 				err = 1;
 				goto next;
@@ -2068,6 +2085,8 @@ static int check_fs_roots(struct btrfs_root *root,
 			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret)
 				err = 1;
+			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+				btrfs_free_fs_root(tmp_root);
 		} else if (key.type == BTRFS_ROOT_REF_KEY ||
 			   key.type == BTRFS_ROOT_BACKREF_KEY) {
 			process_root_ref(leaf, path.slots[0], &key,
-- 
1.9.0

