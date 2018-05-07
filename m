Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45920 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751880AbeEGDKo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:44 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5DA844B31495
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:42 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 01/10] btrfs-progs: copy btrfs_del_orphan_item from kernel
Date: Mon, 7 May 2018 11:10:24 +0800
Message-ID: <20180507031033.4125-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs_del_orphan_item for the later subvolume undelete.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ctree.h |  2 ++
 inode.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/ctree.h b/ctree.h
index 1fef37c93485..46a1dbfd2f27 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2796,6 +2796,8 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct btrfs_path *path,
 			  u64 ino);
+int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 offset);
 int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
 struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root, const char *base,
diff --git a/inode.c b/inode.c
index 2398bca4a109..8d0812c7cf50 100644
--- a/inode.c
+++ b/inode.c
@@ -262,6 +262,36 @@ int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
 	return btrfs_insert_empty_item(trans, root, path, &key, 0);
 }
 
+int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 offset)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret = 0;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = offset;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, path);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * Unlink an inode, which will remove its backref and corresponding dir_index/
  * dir_item if any of them exists.
-- 
2.17.0



