Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38637 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbdJUAzo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 20:55:44 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L0th5D023620
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 00:55:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9L0tgWI022201
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 00:55:43 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9L0tgVX014171
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 00:55:42 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove redundant btrfs_balance_delayed_items
Date: Fri, 20 Oct 2017 17:53:41 -0600
Message-Id: <20171020235341.17019-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In functions like btrfs_create(), we run both
btrfs_balance_delayed_items() and btrfs_btree_balance_dirty() after
the operation, but btrfs_btree_balance_dirty() is surely going to run
btrfs_balance_delayed_items().

This keeps only btrfs_btree_balance_dirty().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bd9f01..da57b03 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6599,7 +6599,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 
 out_unlock:
 	btrfs_end_transaction(trans);
-	btrfs_balance_delayed_items(fs_info);
 	btrfs_btree_balance_dirty(fs_info);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
@@ -6680,7 +6679,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-	btrfs_balance_delayed_items(fs_info);
 	btrfs_btree_balance_dirty(fs_info);
 	return err;
 
@@ -6755,7 +6753,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent);
 	}
 
-	btrfs_balance_delayed_items(fs_info);
 fail:
 	if (trans)
 		btrfs_end_transaction(trans);
@@ -6833,7 +6830,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-	btrfs_balance_delayed_items(fs_info);
 	btrfs_btree_balance_dirty(fs_info);
 	return err;
 
@@ -10757,7 +10753,6 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	btrfs_end_transaction(trans);
 	if (ret)
 		iput(inode);
-	btrfs_balance_delayed_items(fs_info);
 	btrfs_btree_balance_dirty(fs_info);
 	return ret;
 
-- 
2.9.4

