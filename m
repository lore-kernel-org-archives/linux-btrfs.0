Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18034 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3BGGCB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 01:02:01 -0500
Message-ID: <51134384.6040601@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 14:02:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Alex Lyakas <alex.btrfs@zadarastorage.com>, Arne Jansen <sensille@gmx.net>
Subject: [PATCH 2/2] Btrfs: fix memory leak of pending_snapshot->inherit
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The argument "inherit" of btrfs_ioctl_snap_create_transid() was assigned
to NULL during we created the snapshots, so we didn't free it though we
called kfree() in the caller.

But since we are sure the snapshot creation is done after the function -
btrfs_ioctl_snap_create_transid() - completes, it is safe that we don't
assign the pointer "inherit" to NULL, and just free it in the caller of
btrfs_ioctl_snap_create_transid(). In this way, the code can become more
readable.

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Arne Jansen <sensille@gmx.net>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 02d3035..40f2fbf 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -367,7 +367,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 				  struct dentry *dentry,
 				  char *name, int namelen,
 				  u64 *async_transid,
-				  struct btrfs_qgroup_inherit **inherit)
+				  struct btrfs_qgroup_inherit *inherit)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
@@ -401,8 +401,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid,
-				   inherit ? *inherit : NULL);
+	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid, inherit);
 	if (ret)
 		goto fail;
 
@@ -530,7 +529,7 @@ fail:
 
 static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 			   char *name, int namelen, u64 *async_transid,
-			   bool readonly, struct btrfs_qgroup_inherit **inherit)
+			   bool readonly, struct btrfs_qgroup_inherit *inherit)
 {
 	struct inode *inode;
 	struct btrfs_pending_snapshot *pending_snapshot;
@@ -549,10 +548,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
 	pending_snapshot->readonly = readonly;
-	if (inherit) {
-		pending_snapshot->inherit = *inherit;
-		*inherit = NULL;	/* take responsibility to free it */
-	}
+	pending_snapshot->inherit = inherit;
 
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 6);
 	if (IS_ERR(trans)) {
@@ -692,7 +688,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
 				   char *name, int namelen,
 				   struct btrfs_root *snap_src,
 				   u64 *async_transid, bool readonly,
-				   struct btrfs_qgroup_inherit **inherit)
+				   struct btrfs_qgroup_inherit *inherit)
 {
 	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
@@ -1454,7 +1450,7 @@ out:
 static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 				char *name, unsigned long fd, int subvol,
 				u64 *transid, bool readonly,
-				struct btrfs_qgroup_inherit **inherit)
+				struct btrfs_qgroup_inherit *inherit)
 {
 	int namelen;
 	int ret = 0;
@@ -1563,7 +1559,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
 					      vol_args->fd, subvol, ptr,
-					      readonly, &inherit);
+					      readonly, inherit);
 
 	if (ret == 0 && ptr &&
 	    copy_to_user(arg +
-- 
1.7.11.7
