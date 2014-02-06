Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23795 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbaBFVH5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 16:07:57 -0500
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s16L5ojs020779
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Feb 2014 13:07:57 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1hvd6x12p3-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 13:07:57 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: balance delayed inode updates
Date: Thu, 6 Feb 2014 16:07:53 -0500
Message-ID: <1391720873-4961-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While trying to reproduce a delayed ref problem I noticed the box kept falling
over using all 80gb of my ram with btrfs_inode's and btrfs_delayed_node's.
Turns out this is because we only throttle delayed inode updates in
btrfs_dirty_inode, which doesn't actually get called that often, especially when
all you are doing is creating a bunch of files.  So balance delayed inode
updates everytime we create a new inode.  With this patch we no longer use up
all of our ram with delayed inode updates.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 1 +
 fs/btrfs/inode.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9c9ecc9..1d9d9ce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2660,6 +2660,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
 		atomic_read(&trans->transaction->delayed_refs.num_entries);
 	u64 avg_runtime;
 
+	return 1;
 	smp_mb();
 	avg_runtime = fs_info->avg_delayed_ref_runtime;
 	if (num_entries * avg_runtime >= NSEC_PER_SEC)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af34d0..d44ff9f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5795,6 +5795,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	}
 out_unlock:
 	btrfs_end_transaction(trans, root);
+	btrfs_balance_delayed_items(root);
 	btrfs_btree_balance_dirty(root);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
@@ -5868,6 +5869,7 @@ out_unlock:
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
+	btrfs_balance_delayed_items(root);
 	btrfs_btree_balance_dirty(root);
 	return err;
 }
@@ -5926,6 +5928,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	btrfs_end_transaction(trans, root);
+	btrfs_balance_delayed_items(root);
 fail:
 	if (drop_inode) {
 		inode_dec_link_count(inode);
@@ -5992,6 +5995,7 @@ out_fail:
 	btrfs_end_transaction(trans, root);
 	if (drop_on_err)
 		iput(inode);
+	btrfs_balance_delayed_items(root);
 	btrfs_btree_balance_dirty(root);
 	return err;
 }
-- 
1.8.3.1

