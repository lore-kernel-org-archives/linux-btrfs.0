Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33994 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933963AbdBQOnx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:53 -0500
Received: by mail-wm0-f68.google.com with SMTP id c85so2930243wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:52 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/38] btrfs: Make btrfs_set_inode_index take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:55 +0200
Message-Id: <1487342609-20652-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c       | 22 +++++++++++-----------
 fs/btrfs/ioctl.c       |  2 +-
 fs/btrfs/transaction.c |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8796391eed3..a4ccfffa4082 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6033,21 +6033,21 @@ static int btrfs_set_inode_index_count(struct btrfs_inode *inode)
  * helper to find a free sequence number in a given directory.  This current
  * code is very simple, later versions will do smarter things in the btree
  */
-int btrfs_set_inode_index(struct inode *dir, u64 *index)
+int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index)
 {
 	int ret = 0;
 
-	if (BTRFS_I(dir)->index_cnt == (u64)-1) {
-		ret = btrfs_inode_delayed_dir_index_count(BTRFS_I(dir));
+	if (dir->index_cnt == (u64)-1) {
+		ret = btrfs_inode_delayed_dir_index_count(dir);
 		if (ret) {
-			ret = btrfs_set_inode_index_count(BTRFS_I(dir));
+			ret = btrfs_set_inode_index_count(dir);
 			if (ret)
 				return ret;
 		}
 	}
 
-	*index = BTRFS_I(dir)->index_cnt;
-	BTRFS_I(dir)->index_cnt++;
+	*index = dir->index_cnt;
+	dir->index_cnt++;
 
 	return ret;
 }
@@ -6108,7 +6108,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (dir && name) {
 		trace_btrfs_inode_request(dir);
 
-		ret = btrfs_set_inode_index(dir, index);
+		ret = btrfs_set_inode_index(BTRFS_I(dir), index);
 		if (ret) {
 			btrfs_free_path(path);
 			iput(inode);
@@ -6489,7 +6489,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
-	err = btrfs_set_inode_index(dir, &index);
+	err = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (err)
 		goto fail;
 
@@ -9479,10 +9479,10 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	 * We need to find a free sequence number both in the source and
 	 * in the destination directory for the exchange.
 	 */
-	ret = btrfs_set_inode_index(new_dir, &old_idx);
+	ret = btrfs_set_inode_index(BTRFS_I(new_dir), &old_idx);
 	if (ret)
 		goto out_fail;
-	ret = btrfs_set_inode_index(old_dir, &new_idx);
+	ret = btrfs_set_inode_index(BTRFS_I(old_dir), &new_idx);
 	if (ret)
 		goto out_fail;
 
@@ -9790,7 +9790,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (dest != root)
 		btrfs_record_root_in_trans(trans, dest);
 
-	ret = btrfs_set_inode_index(new_dir, &index);
+	ret = btrfs_set_inode_index(BTRFS_I(new_dir), &index);
 	if (ret)
 		goto out_fail;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 952762582b3d..be206285ba81 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -580,7 +580,7 @@ static noinline int create_subvol(struct inode *dir,
 	/*
 	 * insert the directory item
 	 */
-	ret = btrfs_set_inode_index(dir, &index);
+	ret = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 294563216dd3..05c2bbff2a28 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1505,7 +1505,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	/*
 	 * insert the directory item
 	 */
-	ret = btrfs_set_inode_index(parent_inode, &index);
+	ret = btrfs_set_inode_index(BTRFS_I(parent_inode), &index);
 	BUG_ON(ret); /* -ENOMEM */
 
 	/* check if there is a file/dir which has the same name. */
-- 
2.7.4

