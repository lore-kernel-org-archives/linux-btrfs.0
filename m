Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33778 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753680AbcHSIQc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 04:16:32 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id ACA8F42BC535
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 16:13:16 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs-progs: convert: Fix a regression that ext2_save/image is not readonly
Date: Fri, 19 Aug 2016 16:13:05 +0800
Message-ID: <20160819081308.21348-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
References: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new convert treats the convert image as a normal file, without any
special flags and permissions.

This is different from original code:
1) Permission changed from 0400 to 0600
2) Inode lacks READONLY flag

This makes we can read-write mount the ext2 image and cause rollback
failure.

Follow old code behavior, use 0400 permission and add back READONLY
flag to fix it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c |  9 ++++++++-
 ctree.h         |  2 ++
 inode.c         | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index b18de59..a8852d6 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1527,8 +1527,12 @@ static int create_image(struct btrfs_root *root,
 	struct cache_tree used_tmp;
 	u64 cur;
 	u64 ino;
+	u64 flags = BTRFS_INODE_READONLY;
 	int ret;
 
+	if (!datacsum)
+		flags |= BTRFS_INODE_NODATASUM;
+
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans)
 		return -ENOMEM;
@@ -1539,7 +1543,10 @@ static int create_image(struct btrfs_root *root,
 				       &ino);
 	if (ret < 0)
 		goto out;
-	ret = btrfs_new_inode(trans, root, ino, 0600 | S_IFREG);
+	ret = btrfs_new_inode(trans, root, ino, 0400 | S_IFREG);
+	if (ret < 0)
+		goto out;
+	ret = btrfs_change_inode_flags(trans, root, ino, flags);
 	if (ret < 0)
 		goto out;
 	ret = btrfs_add_link(trans, root, ino, BTRFS_FIRST_FREE_OBJECTID, name,
diff --git a/ctree.h b/ctree.h
index dda72d0..b9fb732 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2578,6 +2578,8 @@ int check_dir_conflict(struct btrfs_root *root, char *name, int namelen,
 		u64 dir, u64 index);
 int btrfs_new_inode(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		u64 ino, u32 mode);
+int btrfs_change_inode_flags(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 ino, u64 flags);
 int btrfs_add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   u64 ino, u64 parent_ino, char *name, int namelen,
 		   u8 type, u64 *index, int add_backref);
diff --git a/inode.c b/inode.c
index ed6d529..991b8dd 100644
--- a/inode.c
+++ b/inode.c
@@ -472,6 +472,42 @@ int btrfs_new_inode(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 }
 
 /*
+ * Change inode flags to given value
+ */
+int btrfs_change_inode_flags(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 ino, u64 flags)
+{
+	struct btrfs_inode_item *item;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_inode_item);
+	btrfs_set_inode_flags(path->nodes[0], item, flags);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
  * Make a dir under the parent inode 'parent_ino' with 'name'
  * and 'mode', The owner will be root/root.
  */
-- 
2.9.3



