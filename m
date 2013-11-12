Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab3KLMAG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 07:00:06 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rACBZkMd009667
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 19:36:26 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: remove unused function btrfs_get_inode_ref_index()
Date: Tue, 12 Nov 2013 19:32:03 +0800
Message-Id: <1384255924-15851-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit d52be818e6(Btrfs: simplify unlink reservations),
btrfs_get_inode_ref_index() is no loner called.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h      |  6 -----
 fs/btrfs/inode-item.c | 65 ---------------------------------------------------
 2 files changed, 71 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f013a31..7038acc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3570,12 +3570,6 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   const char *name, int name_len,
 			   u64 inode_objectid, u64 ref_objectid, u64 *index);
-int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len,
-			      u64 inode_objectid, u64 ref_objectid, int mod,
-			      u64 *ret_index);
 int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid);
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index ec82fae..2be38df 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -91,32 +91,6 @@ int btrfs_find_name_in_ext_backref(struct btrfs_path *path, u64 ref_objectid,
 	return 0;
 }
 
-static struct btrfs_inode_ref *
-btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       struct btrfs_path *path,
-		       const char *name, int name_len,
-		       u64 inode_objectid, u64 ref_objectid, int ins_len,
-		       int cow)
-{
-	int ret;
-	struct btrfs_key key;
-	struct btrfs_inode_ref *ref;
-
-	key.objectid = inode_objectid;
-	key.type = BTRFS_INODE_REF_KEY;
-	key.offset = ref_objectid;
-
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
-		return NULL;
-	if (!find_name_in_backref(path, name, name_len, &ref))
-		return NULL;
-	return ref;
-}
-
 /* Returns NULL if no extref found */
 struct btrfs_inode_extref *
 btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
@@ -144,45 +118,6 @@ btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
 	return extref;
 }
 
-int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
-			      struct btrfs_path *path,
-			      const char *name, int name_len,
-			      u64 inode_objectid, u64 ref_objectid, int mod,
-			      u64 *ret_index)
-{
-	struct btrfs_inode_ref *ref;
-	struct btrfs_inode_extref *extref;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
-
-	ref = btrfs_lookup_inode_ref(trans, root, path, name, name_len,
-				     inode_objectid, ref_objectid, ins_len,
-				     cow);
-	if (IS_ERR(ref))
-		return PTR_ERR(ref);
-
-	if (ref != NULL) {
-		*ret_index = btrfs_inode_ref_index(path->nodes[0], ref);
-		return 0;
-	}
-
-	btrfs_release_path(path);
-
-	extref = btrfs_lookup_inode_extref(trans, root, path, name,
-					   name_len, inode_objectid,
-					   ref_objectid, ins_len, cow);
-	if (IS_ERR(extref))
-		return PTR_ERR(extref);
-
-	if (extref) {
-		*ret_index = btrfs_inode_extref_index(path->nodes[0], extref);
-		return 0;
-	}
-
-	return -ENOENT;
-}
-
 static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  const char *name, int name_len,
-- 
1.8.3.1

