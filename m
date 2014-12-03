Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25179 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbaLCERw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 23:17:52 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB34HULJ008397
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Dec 2014 12:17:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND v2 5/6] btrfs-progs: Add btrfs_mkdir() function for the incoming 'lost+found' fsck mechanism.
Date: Wed, 3 Dec 2014 12:18:31 +0800
Message-ID: <1417580312-8516-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the previous btrfs inode operations patches, now we can use
btrfs_mkdir() to create the 'lost+found' dir to do some data salvage in
btrfsck.

This patch along with previous ones will make data salvage easier.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changlog:
v2:
   Fix a bug that returns the parent ino other than the existing dir
   ino.
---
 ctree.h |  2 ++
 inode.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/ctree.h b/ctree.h
index 21bafd2..682255c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2459,4 +2459,6 @@ int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct btrfs_path *path,
 			  u64 ino);
+int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		char *name, int namelen, u64 parent_ino, u64 *ino, int mode);
 #endif
diff --git a/inode.c b/inode.c
index aeb0a5c..b354f5a 100644
--- a/inode.c
+++ b/inode.c
@@ -436,3 +436,95 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+/* Fill inode item with 'mode'. Uid/gid to root/root */
+static void fill_inode_item(struct btrfs_trans_handle *trans,
+			    struct btrfs_inode_item *inode_item,
+			    u32 mode, u32 nlink)
+{
+	time_t now = time(NULL);
+
+	btrfs_set_stack_inode_generation(inode_item, trans->transid);
+	btrfs_set_stack_inode_uid(inode_item, 0);
+	btrfs_set_stack_inode_gid(inode_item, 0);
+	btrfs_set_stack_inode_size(inode_item, 0);
+	btrfs_set_stack_inode_mode(inode_item, mode);
+	btrfs_set_stack_inode_nlink(inode_item, nlink);
+	btrfs_set_stack_timespec_sec(&inode_item->atime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item->atime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item->mtime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item->mtime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item->ctime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item->ctime, 0);
+}
+
+/*
+ * Unlike kernel btrfs_new_inode(), we only create the INODE_ITEM, without
+ * its backref.
+ * The backref is added by btrfs_add_link().
+ */
+static int btrfs_new_inode(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   u64 ino, u32 mode)
+{
+	struct btrfs_inode_item inode_item = {0};
+	int ret = 0;
+
+	fill_inode_item(trans, &inode_item, mode, 0);
+	ret = btrfs_insert_inode(trans, root, ino, &inode_item);
+	return ret;
+}
+
+/*
+ * Make a dir under the parent inode 'parent_ino' with 'name'
+ * and 'mode', The owner will be root/root.
+ */
+int btrfs_mkdir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		char *name, int namelen, u64 parent_ino, u64 *ino, int mode)
+{
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_path *path;
+	u64 ret_ino;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	dir_item = btrfs_lookup_dir_item(NULL, root, path, parent_ino,
+					 name, namelen, 0);
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		goto out;
+	}
+
+	if (dir_item) {
+		struct btrfs_key found_key;
+
+		/*
+		 * Already have conflicting name, check if it is a dir.
+		 * Either way, no need to continue.
+		 */
+		btrfs_dir_item_key_to_cpu(path->nodes[0], dir_item, &found_key);
+		ret_ino = found_key.objectid;
+		if (btrfs_dir_type(path->nodes[0], dir_item) != BTRFS_FT_DIR)
+			ret = -EEXIST;
+		goto out;
+	}
+
+	ret = btrfs_find_free_objectid(NULL, root, parent_ino, &ret_ino);
+	if (ret)
+		goto out;
+	ret = btrfs_new_inode(trans, root, ret_ino, mode | S_IFDIR);
+	if (ret)
+		goto out;
+	ret = btrfs_add_link(trans, root, ret_ino, parent_ino, name, namelen,
+			     BTRFS_FT_DIR, NULL, 1);
+	if (ret)
+		goto out;
+out:
+	btrfs_free_path(path);
+	if (ret == 0 && ino)
+		*ino = ret_ino;
+	return ret;
+}
-- 
2.1.3

