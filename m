Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35199 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2JVTtr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 15:49:47 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id cyW9xAoWpnr1yRU4 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:49:46 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: Use btrfs_update_inode_fallback when creating a snapshot
Date: Mon, 22 Oct 2012 15:55:32 -0400
Message-ID: <1350935732-3113-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On a really full file system I was getting ENOSPC back from
btrfs_update_inode when trying to update the parent inode when creating a
snapshot.  Just use the fallback method so we can update the inode and not
have to worry about having a delayed ref.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    2 ++
 fs/btrfs/inode.c       |    7 +++----
 fs/btrfs/transaction.c |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 59141a4..b61d9b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3344,6 +3344,8 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
+int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root, struct inode *inode);
 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_cleanup(struct btrfs_root *root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4919cc3..8e78c6d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -95,8 +95,6 @@ static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
 				   unsigned long *nr_written, int unlock);
-static noinline int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, struct inode *inode);
 
 static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 				     struct inode *inode,  struct inode *dir,
@@ -3362,8 +3360,9 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	return btrfs_update_inode_item(trans, root, inode);
 }
 
-static noinline int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, struct inode *inode)
+noinline int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
+					 struct btrfs_root *root,
+					 struct inode *inode)
 {
 	int ret;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 83aa617..4e1def4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1198,7 +1198,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
-	ret = btrfs_update_inode(trans, parent_root, parent_inode);
+	ret = btrfs_update_inode_fallback(trans, parent_root, parent_inode);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 fail:
-- 
1.7.7.6

