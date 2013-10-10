Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f46.google.com ([209.85.128.46]:53618 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3JJWQJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 18:16:09 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, joe@perches.com, kernel-br@googlegroups.com,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v5] btrfs: Fix memory leakage in the tree-log.c
Date: Thu, 10 Oct 2013 19:11:22 -0300
Message-Id: <1381443082-7670-1-git-send-email-geyslan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In add_inode_ref() function:

Initializes local pointers.

Reduces the logical condition with the __add_inode_ref() return
value by using only one 'goto out'.

Centralizes the exiting, ensuring the freeing of all used memory.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/btrfs/tree-log.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..beb41b0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1113,11 +1113,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				  struct extent_buffer *eb, int slot,
 				  struct btrfs_key *key)
 {
-	struct inode *dir;
-	struct inode *inode;
+	struct inode *dir = NULL;
+	struct inode *inode = NULL;
 	unsigned long ref_ptr;
 	unsigned long ref_end;
-	char *name;
+	char *name = NULL;
 	int namelen;
 	int ret;
 	int search_done = 0;
@@ -1150,13 +1150,15 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 	 * care of the rest
 	 */
 	dir = read_one_inode(root, parent_objectid);
-	if (!dir)
-		return -ENOENT;
+	if (!dir) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	inode = read_one_inode(root, inode_objectid);
 	if (!inode) {
-		iput(dir);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	while (ref_ptr < ref_end) {
@@ -1169,14 +1171,17 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			 */
 			if (!dir)
 				dir = read_one_inode(root, parent_objectid);
-			if (!dir)
-				return -ENOENT;
+			if (!dir) {
+				ret = -ENOENT;
+				goto out;
+			}
 		} else {
 			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
 					     &ref_index);
 		}
 		if (ret)
-			return ret;
+			goto out;
+
 
 		/* if we already have a perfect match, we're done */
 		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
@@ -1196,12 +1201,12 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 						      parent_objectid,
 						      ref_index, name, namelen,
 						      &search_done);
-				if (ret == 1) {
-					ret = 0;
+
+				if (ret) {
+					if (ret == 1)
+						ret--;
 					goto out;
 				}
-				if (ret)
-					goto out;
 			}
 
 			/* insert our name */
@@ -1215,6 +1220,8 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
 		kfree(name);
+		name = NULL;
+
 		if (log_ref_ver) {
 			iput(dir);
 			dir = NULL;
@@ -1225,6 +1232,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 	ret = overwrite_item(trans, root, path, eb, slot, key);
 out:
 	btrfs_release_path(path);
+	kfree(name);
 	iput(dir);
 	iput(inode);
 	return ret;
-- 
1.8.4

