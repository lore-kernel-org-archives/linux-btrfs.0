Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46982 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3GYTNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 15:13:44 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 901B57C0643
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 13:13:43 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id iJ2FifkfCS2ptTuN (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 13:13:42 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check to see if root_list is empty before adding it to dead roots
Date: Thu, 25 Jul 2013 15:13:40 -0400
Message-ID: <1374779620-28788-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a panic when running with autodefrag and deleting snapshots.
This is because we could end up trying to add the root to the dead roots list
twice.  To fix this check to see if we are empty before adding ourselves to the
dead roots list.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/transaction.c |    8 ++++----
 fs/btrfs/transaction.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 61a5c2c..18f7e71 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -983,12 +983,12 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
  * a dirty root struct and adds it into the list of dead roots that need to
  * be deleted
  */
-int btrfs_add_dead_root(struct btrfs_root *root)
+void btrfs_add_dead_root(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
-	list_add_tail(&root->root_list, &root->fs_info->dead_roots);
+	if (list_empty(&root->root_list))
+		list_add_tail(&root->root_list, &root->fs_info->dead_roots);
 	spin_unlock(&root->fs_info->trans_lock);
-	return 0;
 }
 
 /*
@@ -1925,7 +1925,7 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	}
 	root = list_first_entry(&fs_info->dead_roots,
 			struct btrfs_root, root_list);
-	list_del(&root->root_list);
+	list_del_init(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
 	pr_debug("btrfs: cleaner removing %llu\n",
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 005b037..defbc42 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -143,7 +143,7 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 
-int btrfs_add_dead_root(struct btrfs_root *root);
+void btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root);
 int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

