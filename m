Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29449 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2K3L0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 06:26:15 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAUBQEv5032045
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 11:26:14 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qAUBQDrM013460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 11:26:14 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qAUBQDAa029663
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 05:26:13 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: put delayed iput tracking list inside in-memory inode
Date: Fri, 30 Nov 2012 19:24:43 +0800
Message-Id: <1354274683-17762-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This can save us a dynamic memory allocation/free.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/btrfs_inode.h |    3 +++
 fs/btrfs/inode.c       |   36 +++++++++++++-----------------------
 2 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ed8ca7c..446ce73 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -79,6 +79,9 @@ struct btrfs_inode {
 	 */
 	struct list_head delalloc_inodes;
 
+	/* for delayed iput */
+	struct list_head iput_list;
+
 	/*
 	 * list for tracking inodes that must be sent to disk before a
 	 * rename or truncate commit
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..0c7161d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2070,34 +2070,23 @@ zeroit:
 	return -EIO;
 }
 
-struct delayed_iput {
-	struct list_head list;
-	struct inode *inode;
-};
-
-/* JDM: If this is fs-wide, why can't we add a pointer to
- * btrfs_inode instead and avoid the allocation? */
 void btrfs_add_delayed_iput(struct inode *inode)
 {
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
-	struct delayed_iput *delayed;
-
-	if (atomic_add_unless(&inode->i_count, -1, 1))
-		return;
-
-	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
-	delayed->inode = inode;
+	if (atomic_add_unless(&inode->i_count, -1, 1) == 0) {
+		struct btrfs_inode *bi = BTRFS_I(inode);
+		struct btrfs_fs_info *fs_info = bi->root->fs_info;
 
-	spin_lock(&fs_info->delayed_iput_lock);
-	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
-	spin_unlock(&fs_info->delayed_iput_lock);
+		spin_lock(&fs_info->delayed_iput_lock);
+		list_add_tail(&bi->iput_list, &fs_info->delayed_iputs);
+		spin_unlock(&fs_info->delayed_iput_lock);
+	}
 }
 
 void btrfs_run_delayed_iputs(struct btrfs_root *root)
 {
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct delayed_iput *delayed;
+	struct btrfs_inode *bi = NULL;
 	int empty;
 
 	spin_lock(&fs_info->delayed_iput_lock);
@@ -2111,10 +2100,9 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root)
 	spin_unlock(&fs_info->delayed_iput_lock);
 
 	while (!list_empty(&list)) {
-		delayed = list_entry(list.next, struct delayed_iput, list);
-		list_del(&delayed->list);
-		iput(delayed->inode);
-		kfree(delayed);
+		bi = list_entry(list.next, struct btrfs_inode, iput_list);
+		list_del_init(&bi->iput_list);
+		iput(&bi->vfs_inode);
 	}
 }
 
@@ -7097,6 +7085,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
+	INIT_LIST_HEAD(&ei->iput_list);
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
 
@@ -7120,6 +7109,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(BTRFS_I(inode)->reserved_extents);
 	WARN_ON(BTRFS_I(inode)->delalloc_bytes);
 	WARN_ON(BTRFS_I(inode)->csum_bytes);
+	WARN_ON(!list_empty(&BTRFS_I(inode)->iput_list));
 
 	/*
 	 * This can happen where we create an inode, but somebody else also
-- 
1.7.7.6

