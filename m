Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33614 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdEHCKS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 May 2017 22:10:18 -0400
Received: by mail-pg0-f68.google.com with SMTP id s62so8449492pgc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 07 May 2017 19:10:18 -0700 (PDT)
From: Daichou <tommy0705c@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: Daichou <tommy0705c@gmail.com>
Subject: [PATCH] Btrfs:Unused comments:"FIXME: check if the IDs really exist" in ioctl.c
Date: Mon,  8 May 2017 10:10:02 +0800
Message-Id: <20170508021002.12262-1-tommy0705c@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These comments were already fixed in 2013.
btrfs_add_qgroup_relation, btrfs_ioctl_qgroup_create, btrfs_limit_qgroup
btrfs_add_qgroup_relation, btrfs_del_qgroup_relation have checked qgroupid existed.

Signed-off-by: Daichou <tommy0705c@gmail.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a29dc3fd7152..6db06f4708f7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4900,7 +4900,6 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		goto out;
 	}
 
-	/* FIXME: check if the IDs really exist */
 	if (sa->assign) {
 		ret = btrfs_add_qgroup_relation(trans, fs_info,
 						sa->src, sa->dst);
@@ -4959,7 +4958,6 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto out;
 	}
 
-	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
 		ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid);
 	} else {
@@ -5013,7 +5011,6 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		qgroupid = root->root_key.objectid;
 	}
 
-	/* FIXME: check if the IDs really exist */
 	ret = btrfs_limit_qgroup(trans, fs_info, qgroupid, &sa->lim);
 
 	err = btrfs_end_transaction(trans);
-- 
2.12.2

