From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 09/16] Btrfs: remove redundant code for dir item lookup
Date: Thu, 14 Jul 2011 11:17:52 +0800
Message-ID: <4E1E5FE0.7080608@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When we search a dir item with a specific hash code, we can
just return NULL without further checking if btrfs_search_slot()
returns 1.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/dir-item.c |   30 ++----------------------------
 1 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 685f259..81533a0 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -203,8 +203,6 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ins_len = mod < 0 ? -1 : 0;
 	int cow = mod != 0;
-	struct btrfs_key found_key;
-	struct extent_buffer *leaf;
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
@@ -214,18 +212,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
-	if (ret > 0) {
-		if (path->slots[0] == 0)
-			return NULL;
-		path->slots[0]--;
-	}
-
-	leaf = path->nodes[0];
-	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-
-	if (found_key.objectid != dir ||
-	    btrfs_key_type(&found_key) != BTRFS_DIR_ITEM_KEY ||
-	    found_key.offset != key.offset)
+	if (ret > 0)
 		return NULL;
 
 	return btrfs_match_dir_item_name(root, path, name, name_len);
@@ -320,8 +307,6 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ins_len = mod < 0 ? -1 : 0;
 	int cow = mod != 0;
-	struct btrfs_key found_key;
-	struct extent_buffer *leaf;
 
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
@@ -329,18 +314,7 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
-	if (ret > 0) {
-		if (path->slots[0] == 0)
-			return NULL;
-		path->slots[0]--;
-	}
-
-	leaf = path->nodes[0];
-	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-
-	if (found_key.objectid != dir ||
-	    btrfs_key_type(&found_key) != BTRFS_XATTR_ITEM_KEY ||
-	    found_key.offset != key.offset)
+	if (ret > 0)
 		return NULL;
 
 	return btrfs_match_dir_item_name(root, path, name, name_len);
-- 
1.7.3.1
