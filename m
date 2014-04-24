Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46702 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751451AbaDXDWb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 23:22:31 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3O3MGgE005675
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 11:22:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs-progs: fsck: add ability to check reloc roots
Date: Thu, 24 Apr 2014 11:19:18 +0800
Message-ID: <1398309558-29509-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1398309558-29509-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1398309558-29509-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
 cmds-check.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e6fb380..93342ad 100644
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
@@ -2059,8 +2070,15 @@ static int check_fs_roots(struct btrfs_root *root,
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
 		if (key.type == BTRFS_ROOT_ITEM_KEY &&
 		    fs_root_objectid(key.objectid)) {
-			key.offset = (u64)-1;
-			tmp_root = btrfs_read_fs_root(root->fs_info, &key);
+			if (key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID ||
+			    key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
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
-- 
1.9.0

