Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57643 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALNio (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 08:38:44 -0500
Received: by mail-pb0-f45.google.com with SMTP id rp16so6301252pbb.4
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 05:38:43 -0800 (PST)
Received: from linux-b0ol.localdomain ([223.65.51.231])
        by mx.google.com with ESMTPSA id jn12sm30944540pbd.37.2014.01.12.05.38.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jan 2014 05:38:43 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: fix to search previous metadata extent item since skinny metadata
Date: Sun, 12 Jan 2014 21:38:33 +0800
Message-Id: <1389533914-2272-3-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
References: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

There is a bug that using btrfs_previous_item() to search metadata extent item.
This is because in btrfs_previous_item(), we need type match, however, since
skinny metada was introduced by josef, we may mix this two types. So just
use btrfs_previous_item() is not working right.

To keep btrfs_previous_item() like normal tree search, i introduce another
function btrfs_previous_extent_item().

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c |  3 +--
 fs/btrfs/ctree.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/scrub.c   |  3 +--
 4 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 835b6c9..964679c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1303,8 +1303,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		return ret;
-	ret = btrfs_previous_item(fs_info->extent_root, path,
-					0, BTRFS_EXTENT_ITEM_KEY);
+	ret = btrfs_previous_extent_item(fs_info->extent_root, path, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9e9de68..30f5b11 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5955,3 +5955,46 @@ int btrfs_previous_item(struct btrfs_root *root,
 	}
 	return 1;
 }
+
+/*
+ * search in extent tree to find a previous Metadata/Data extent item with
+ * min objecitd.
+ *
+ * returns 0 if something is found, 1 if nothing was found and < 0 on error
+ */
+int btrfs_previous_extent_item(struct btrfs_root *root,
+			struct btrfs_path *path, u64 min_objectid)
+{
+	struct btrfs_key found_key;
+	struct extent_buffer *leaf;
+	u32 nritems;
+	int ret;
+
+	while (1) {
+		if (path->slots[0] == 0) {
+			btrfs_set_path_blocking(path);
+			ret = btrfs_prev_leaf(root, path);
+			if (ret != 0)
+				return ret;
+		} else {
+			path->slots[0]--;
+		}
+		leaf = path->nodes[0];
+		nritems = btrfs_header_nritems(leaf);
+		if (nritems == 0)
+			return 1;
+		if (path->slots[0] == nritems)
+			path->slots[0]--;
+
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid < min_objectid)
+			break;
+		if (found_key.type == BTRFS_EXTENT_ITEM_KEY ||
+		    found_key.type == BTRFS_METADATA_ITEM_KEY)
+			return 0;
+		if (found_key.objectid == min_objectid &&
+		    found_key.type < BTRFS_EXTENT_ITEM_KEY)
+			break;
+	}
+	return 1;
+}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3cebb4a..81f8190 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3331,6 +3331,8 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
+int btrfs_previous_extent_item(struct btrfs_root *root,
+			struct btrfs_path *path, u64 min_objectid);
 void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 			     struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e0677e4..51c342b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2385,8 +2385,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			goto out;
 
 		if (ret > 0) {
-			ret = btrfs_previous_item(root, path, 0,
-						  BTRFS_EXTENT_ITEM_KEY);
+			ret = btrfs_previous_extent_item(root, path, 0);
 			if (ret < 0)
 				goto out;
 			if (ret > 0) {
-- 
1.8.4

