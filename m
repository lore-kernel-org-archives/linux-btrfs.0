Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab3J2CpP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 22:45:15 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9T2jEkP028140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 02:45:15 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9T2jD9k023461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 02:45:14 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9T2jDD4001390
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 02:45:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not run snapshot-aware defragment on error
Date: Tue, 29 Oct 2013 10:45:05 +0800
Message-Id: <1383014705-759-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If something wrong happens in write endio, running snapshot-aware defragment
can end up with undefined results, maybe a crash, so we should avoid it.

In order to share similar code, this also adds a helper to free the struct for
snapshot-aware defrag.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 47 ++++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 51e3afa..8b8eff0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2367,10 +2367,23 @@ out_unlock:
 	return ret;
 }
 
+static void free_sa_defrag_extent(struct new_sa_defrag_extent *new)
+{
+	struct old_sa_defrag_extent *old, *tmp;
+
+	if (!new)
+		return;
+
+	list_for_each_entry_safe(old, tmp, &new->head, list) {
+		list_del(&old->list);
+		kfree(old);
+	}
+	kfree(new);
+}
+
 static void relink_file_extents(struct new_sa_defrag_extent *new)
 {
 	struct btrfs_path *path;
-	struct old_sa_defrag_extent *old, *tmp;
 	struct sa_defrag_extent_backref *backref;
 	struct sa_defrag_extent_backref *prev = NULL;
 	struct inode *inode;
@@ -2413,16 +2426,11 @@ static void relink_file_extents(struct new_sa_defrag_extent *new)
 	kfree(prev);
 
 	btrfs_free_path(path);
-
-	list_for_each_entry_safe(old, tmp, &new->head, list) {
-		list_del(&old->list);
-		kfree(old);
-	}
 out:
+	free_sa_defrag_extent(new);
+
 	atomic_dec(&root->fs_info->defrag_running);
 	wake_up(&root->fs_info->transaction_wait);
-
-	kfree(new);
 }
 
 static struct new_sa_defrag_extent *
@@ -2432,7 +2440,7 @@ record_old_file_extents(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct old_sa_defrag_extent *old, *tmp;
+	struct old_sa_defrag_extent *old;
 	struct new_sa_defrag_extent *new;
 	int ret;
 
@@ -2480,7 +2488,7 @@ record_old_file_extents(struct inode *inode,
 		if (slot >= btrfs_header_nritems(l)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
-				goto out_free_list;
+				goto out_free_path;
 			else if (ret > 0)
 				break;
 			continue;
@@ -2509,7 +2517,7 @@ record_old_file_extents(struct inode *inode,
 
 		old = kmalloc(sizeof(*old), GFP_NOFS);
 		if (!old)
-			goto out_free_list;
+			goto out_free_path;
 
 		offset = max(new->file_pos, key.offset);
 		end = min(new->file_pos + new->len, key.offset + num_bytes);
@@ -2531,15 +2539,10 @@ next:
 
 	return new;
 
-out_free_list:
-	list_for_each_entry_safe(old, tmp, &new->head, list) {
-		list_del(&old->list);
-		kfree(old);
-	}
 out_free_path:
 	btrfs_free_path(path);
 out_kfree:
-	kfree(new);
+	free_sa_defrag_extent(new);
 	return NULL;
 }
 
@@ -2710,8 +2713,14 @@ out:
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
 	/* for snapshot-aware defrag */
-	if (new)
-		relink_file_extents(new);
+	if (new) {
+		if (ret) {
+			free_sa_defrag_extent(new);
+			atomic_dec(&root->fs_info->defrag_running);
+		} else {
+			relink_file_extents(new);
+		}
+	}
 
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
-- 
1.8.2.1

