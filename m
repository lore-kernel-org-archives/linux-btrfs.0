Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46579 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbaBFV3s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 16:29:48 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s16LM3Av012581
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Feb 2014 13:29:47 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0a-00082601.pphosted.com with ESMTP id 1hvg6fgfsj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 13:29:47 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: balance delayed inode updates V2
Date: Thu, 6 Feb 2014 16:29:45 -0500
Message-ID: <1391722185-5349-1-git-send-email-jbacik@fb.com>
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
V1->V2: this time without the debug part I was using.

 fs/btrfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

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

