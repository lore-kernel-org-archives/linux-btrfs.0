Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32429 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751714AbeC0HHN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:13 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4F9924D0EFD9
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:07 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 01/10] btrfs-progs: copy btrfs_del_orphan_item from kernel
Date: Tue, 27 Mar 2018 15:06:49 +0800
Message-ID: <20180327070658.13064-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
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
index fa861ba0b4c3..0fc31dd8d998 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2793,6 +2793,8 @@ int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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
2.16.2



