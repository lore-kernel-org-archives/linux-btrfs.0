Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54670 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3G3LKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 07:10:05 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so5861673wgh.8
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 04:10:03 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] Btrfs-progs: add missing path alloc return value check
Date: Tue, 30 Jul 2013 12:09:55 +0100
Message-Id: <1375182595-31458-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
References: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also remove unused path in extent-tree.c:finish_current_insert().

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: added 1 more path alloc check and removed unnecessary path
    allocation in extent-tree.c:finish_current_insert().
V3: added missing path alloc checks to dir-item.c, file-item.c
    and btrfs-corrupt-block.c too.
V4: added missing patch alloc checks to cmd-checks.c and
    root-tree.c.

 btrfs-corrupt-block.c |    2 ++
 cmds-check.c          |    2 ++
 dir-item.c            |    2 ++
 extent-tree.c         |    8 ++++----
 file-item.c           |    2 ++
 root-tree.c           |    2 ++
 6 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 8176fad..22facd4 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -159,6 +159,8 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 	int should_del = rand() % 3;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = bytenr;
 	key.type = (u8)-1;
diff --git a/cmds-check.c b/cmds-check.c
index 8015288..c1a0df9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4561,6 +4561,8 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 		flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	/* step one, make sure all of the backrefs agree */
 	ret = verify_backrefs(trans, info, path, rec);
diff --git a/dir-item.c b/dir-item.c
index f00485a..0ab3c5e 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -123,6 +123,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 	key.offset = btrfs_name_hash(name, name_len);
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
diff --git a/extent-tree.c b/extent-tree.c
index f597e16..e4adaa3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1487,6 +1487,8 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	}
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 1;
 
 	key.objectid = bytenr;
@@ -1577,6 +1579,8 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 1;
 
 	key.objectid = bytenr;
@@ -2078,7 +2082,6 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	u64 end;
 	u64 priv;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct btrfs_path *path;
 	struct pending_extent_op *extent_op;
 	struct btrfs_key key;
 	int ret;
@@ -2086,8 +2089,6 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 		btrfs_fs_incompat(extent_root->fs_info,
 				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
-	path = btrfs_alloc_path();
-
 	while(1) {
 		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
 					    &end, EXTENT_LOCKED);
@@ -2121,7 +2122,6 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 				  GFP_NOFS);
 		kfree(extent_op);
 	}
-	btrfs_free_path(path);
 	return 0;
 }
 
diff --git a/file-item.c b/file-item.c
index 9c787f0..82bf99e 100644
--- a/file-item.c
+++ b/file-item.c
@@ -417,6 +417,8 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	while (1) {
 		key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
diff --git a/root-tree.c b/root-tree.c
index ba380bd..efcdb7b 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -264,6 +264,8 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = root_id;
 	key.type = type;
-- 
1.7.9.5

