Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab3B1KA0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 05:00:26 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r1SA0Ot8005880
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 18:00:24 +0800
Message-ID: <512F2AEB.5000705@cn.fujitsu.com>
Date: Thu, 28 Feb 2013 18:01:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: remove unnecessary dget_parent/dput when creating
 the pending snapshot
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have grabbed the parent inode at the beginning of the
snapshot creation, and both sync and async snapshot creation
release it after the pending snapshots are actually created,
it is safe to access the parent inode directly during the snapshot
creation, we needn't use dget_parent/dput to fix the parent dentry
and get the dir inode.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c       |   10 ++++++----
 fs/btrfs/transaction.c |    5 +----
 fs/btrfs/transaction.h |    1 +
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2bbbed5..75c551d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -530,9 +530,10 @@ fail:
 	return ret;
 }
 
-static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
-			   char *name, int namelen, u64 *async_transid,
-			   bool readonly, struct btrfs_qgroup_inherit *inherit)
+static int create_snapshot(struct btrfs_root *root, struct inode *dir,
+			   struct dentry *dentry, char *name, int namelen,
+			   u64 *async_transid, bool readonly,
+			   struct btrfs_qgroup_inherit *inherit)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -551,6 +552,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
 	pending_snapshot->readonly = readonly;
+	pending_snapshot->dir = dir;
 	pending_snapshot->inherit = inherit;
 
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 6);
@@ -728,7 +730,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 		goto out_up_read;
 
 	if (snap_src) {
-		error = create_snapshot(snap_src, dentry, name, namelen,
+		error = create_snapshot(snap_src, dir, dentry, name, namelen,
 					async_transid, readonly, inherit);
 	} else {
 		error = create_subvol(BTRFS_I(dir)->root, dentry,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 955204c..63390a3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1061,7 +1061,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct inode *parent_inode;
 	struct btrfs_path *path;
 	struct btrfs_dir_item *dir_item;
-	struct dentry *parent;
 	struct dentry *dentry;
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
@@ -1118,8 +1117,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	trans->block_rsv = &pending->block_rsv;
 
 	dentry = pending->dentry;
-	parent = dget_parent(dentry);
-	parent_inode = parent->d_inode;
+	parent_inode = pending->dir;
 	parent_root = BTRFS_I(parent_inode)->root;
 	record_root_in_trans(trans, parent_root);
 
@@ -1267,7 +1265,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 fail:
-	dput(parent);
 	trans->block_rsv = rsv;
 no_free_objectid:
 	kfree(new_root_item);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5afd7b1..5f67fba 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -84,6 +84,7 @@ struct btrfs_trans_handle {
 
 struct btrfs_pending_snapshot {
 	struct dentry *dentry;
+	struct inode *dir;
 	struct btrfs_root *root;
 	struct btrfs_root *snap;
 	struct btrfs_qgroup_inherit *inherit;
-- 
1.6.5.2
