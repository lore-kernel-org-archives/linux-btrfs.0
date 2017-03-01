Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21599 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751473AbdCADZt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:25:49 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1D06B42B4B03
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:12 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 04/20] btrfs-progs: cmds-check.c: change find_inode_ref's arg
Date: Wed, 1 Mar 2017 11:13:47 +0800
Message-ID: <20170301031403.23902-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For further lowmem repairs, change the index type u64 to u64 *.
So we could get the index of ref.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index fb239968..246f4735 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4422,22 +4422,23 @@ next:
 }
 
 /*
- * Find INODE_REF/INODE_EXTREF for the given key and check it with the specified
- * DIR_ITEM/DIR_INDEX match.
+ * Find INODE_REF/INODE_EXTREF for the given key and check it with the
+ * specified DIR_ITEM/DIR_INDEX match.Returned with right @index.
  *
  * @root:	the root of the fs/file tree
  * @key:	the key of the INODE_REF/INODE_EXTREF
  * @name:	the name in the INODE_REF/INODE_EXTREF
  * @namelen:	the length of name in the INODE_REF/INODE_EXTREF
- * @index:	the index in the INODE_REF/INODE_EXTREF, for DIR_ITEM set index
- * to (u64)-1
+ * @index_ret:	the index in the INODE_REF/INODE_EXTREF,
+ *              value (64)-1 means do not check index and return
+ *              with matched index.
  * @ext_ref:	the EXTENDED_IREF feature
  *
  * Return 0 if no error occurred.
  * Return >0 for error bitmap
  */
 static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
-			  char *name, int namelen, u64 index,
+			  const char *name, int namelen, u64 *index_ret,
 			  unsigned int ext_ref)
 {
 	struct btrfs_path path;
@@ -4474,7 +4475,8 @@ static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
 
 		ref_namelen = btrfs_inode_ref_name_len(node, ref);
 		ref_index = btrfs_inode_ref_index(node, ref);
-		if (index != (u64)-1 && index != ref_index)
+		if (index_ret && *index_ret != (u64)-1 &&
+		    *index_ret != ref_index)
 			goto next_ref;
 
 		if (ref_namelen <= BTRFS_NAME_LEN) {
@@ -4492,7 +4494,8 @@ static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
 
 		if (len != namelen || strncmp(ref_namebuf, name, len))
 			goto next_ref;
-
+		if (index_ret)
+			*index_ret = ref_index;
 		ret = 0;
 		goto out;
 next_ref:
@@ -4533,7 +4536,8 @@ extref:
 		ref_namelen = btrfs_inode_extref_name_len(node, extref);
 		ref_index = btrfs_inode_extref_index(node, extref);
 		parent = btrfs_inode_extref_parent(node, extref);
-		if (index != (u64)-1 && index != ref_index)
+		if (index_ret && *index_ret != (u64)-1 &&
+		    *index_ret != ref_index)
 			goto next_extref;
 
 		if (parent != dir_id)
@@ -4555,6 +4559,8 @@ extref:
 		if (len != namelen || strncmp(ref_namebuf, name, len))
 			goto next_extref;
 
+		if (index_ret)
+			*index_ret = ref_index;
 		ret = 0;
 		goto out;
 
@@ -4668,7 +4674,7 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 		location.type = BTRFS_INODE_REF_KEY;
 		location.offset = key->objectid;
 		ret = find_inode_ref(root, &location, namebuf, len,
-				       index, ext_ref);
+				       &index, ext_ref);
 		err |= ret;
 		if (ret & INODE_REF_MISSING)
 			error("root %llu %s[%llu %llu] relative INODE_REF missing namelen %u filename %s filetype %d",
-- 
2.11.1



