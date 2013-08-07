Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36390 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210Ab3HGVrZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 17:47:25 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 7/7] btrfs: cleanup: removed unused 'btrfs_get_inode_ref_index'
Date: Thu,  8 Aug 2013 00:43:23 +0300
Message-Id: <1375911803-17318-8-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Found by uselex.rb:
> btrfs_get_inode_ref_index: [R]: exported from: fs/btrfs/inode-item.o fs/btrfs/btrfs.o fs/btrfs/built-in.o

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/ctree.h      |  6 -----
 fs/btrfs/inode-item.c | 65 ---------------------------------------------------
 2 files changed, 71 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f35e086..4822c84 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3480,12 +3480,6 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
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
index e0b7034..d07e982 100644
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
1.8.3.2

