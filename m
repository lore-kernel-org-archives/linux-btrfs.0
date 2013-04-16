Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38209 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3DPFTA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 01:19:00 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id D5E383EE0BD
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:58 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id BBF3445DE50
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:58 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id A62F045DE4F
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:58 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9AF161DB8037
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:58 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 453BAE08001
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:58 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 1FA279F7D61
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:58 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id C7D5D9F7CC5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:57 +0900 (JST)
Message-Id: <201304160518.AA00026@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 16 Apr 2013 14:18:49 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs: remove unused argument of btrfs_extend_item()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'trans' is not used in btrfs_extend_item().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c       | 3 +--
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/dir-item.c    | 2 +-
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/file-item.c   | 2 +-
 fs/btrfs/inode-item.c  | 4 ++--
 fs/btrfs/tree-log.c    | 2 +-
 7 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 76e11d7..d5f22db 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4378,8 +4378,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 /*
  * make the item pointed to by the path bigger, data_size is the new size.
  */
-void btrfs_extend_item(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 		       u32 data_size)
 {
 	int slot;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7da1b74..de3b483 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3197,8 +3197,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid);
 int btrfs_block_can_be_shared(struct btrfs_root *root,
 			      struct extent_buffer *buf);
-void btrfs_extend_item(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 		       u32 data_size);
 void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 			 u32 new_size, int from_end);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 47cab8d..71fa113 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -49,7 +49,7 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
 		if (di)
 			return ERR_PTR(-EEXIST);
-		btrfs_extend_item(trans, root, path, data_size);
+		btrfs_extend_item(root, path, data_size);
 	} else if (ret < 0)
 		return ERR_PTR(ret);
 	WARN_ON(ret > 0);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d265625..151b0ad 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1001,7 +1001,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 		return ret;
 	BUG_ON(ret); /* Corruption */
 
-	btrfs_extend_item(trans, root, path, new_size);
+	btrfs_extend_item(root, path, new_size);
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1614,7 +1614,7 @@ void setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	type = extent_ref_type(parent, owner);
 	size = btrfs_extent_inline_ref_size(type);
 
-	btrfs_extend_item(trans, root, path, size);
+	btrfs_extend_item(root, path, size);
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index def004f..da9edca 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -834,7 +834,7 @@ again:
 		diff /= csum_size;
 		diff *= csum_size;
 
-		btrfs_extend_item(trans, root, path, diff);
+		btrfs_extend_item(root, path, diff);
 		goto csum;
 	}
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index cb44398..1640e03 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -361,7 +361,7 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 						   name, name_len, NULL))
 			goto out;
 
-		btrfs_extend_item(trans, root, path, ins_len);
+		btrfs_extend_item(root, path, ins_len);
 		ret = 0;
 	}
 	if (ret < 0)
@@ -417,7 +417,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			goto out;
 
 		old_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
-		btrfs_extend_item(trans, root, path, ins_len);
+		btrfs_extend_item(root, path, ins_len);
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_inode_ref);
 		ref = (struct btrfs_inode_ref *)((unsigned long)ref + old_size);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c2d55ed..0a5601b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -410,7 +410,7 @@ insert:
 		if (found_size > item_size)
 			btrfs_truncate_item(root, path, item_size, 1);
 		else if (found_size < item_size)
-			btrfs_extend_item(trans, root, path,
+			btrfs_extend_item(root, path,
 					  item_size - found_size);
 	} else if (ret) {
 		return ret;
-- 
1.7.12.2

