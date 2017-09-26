Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46387 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S969604AbdIZO1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 10:27:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8395EAC1B
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 14:27:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH 2/2] btrfs: Remove received_uuid during received snapshot ro->rw switch
Date: Tue, 26 Sep 2017 17:27:42 +0300
Message-Id: <1506436062-23825-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1506436062-23825-1-git-send-email-nborisov@suse.com>
References: <1506436062-23825-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently when a read-only snapshot is received and subsequently its ro property
is set to false i.e. switched to rw-mode the received_uuid of that subvol remains
intact. However, once the received volume is switched to RW mode we cannot
guaranteee that it contains the same data, so it makes sense to remove the
received uuid.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

This patch has been inspired by the problem described in 
https://www.spinics.net/lists/linux-btrfs/msg68879.html

 fs/btrfs/ioctl.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 09fcd51f0e8c..71fd28caefdd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1811,6 +1811,17 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_sem;
 
 	root_flags = btrfs_root_flags(&root->root_item);
+
+	/*
+	 * 1 - root item
+	 * 1 - uuid item
+	 */
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_drop_sem;
+	}
+
 	if (flags & BTRFS_SUBVOL_RDONLY) {
 		btrfs_set_root_flags(&root->root_item,
 				     root_flags | BTRFS_ROOT_SUBVOL_RDONLY);
@@ -1824,30 +1835,38 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 			btrfs_set_root_flags(&root->root_item,
 				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
 			spin_unlock(&root->root_item_lock);
+			if (!btrfs_is_empty_uuid(root->root_item.received_uuid)) {
+				ret = btrfs_uuid_tree_rem(trans, fs_info,
+                                          root->root_item.received_uuid,
+                                          BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+                                          root->root_key.objectid);
+
+				if (ret && ret != -ENOENT) {
+					btrfs_abort_transaction(trans, ret);
+					goto out_end_trans;
+				}
+
+				memset(root->root_item.received_uuid, 0,
+				       BTRFS_UUID_SIZE);
+			}
 		} else {
 			spin_unlock(&root->root_item_lock);
 			btrfs_warn(fs_info,
 				   "Attempt to set subvolume %llu read-write during send",
 				   root->root_key.objectid);
 			ret = -EPERM;
-			goto out_drop_sem;
+			btrfs_abort_transaction(trans, ret);
+			goto out_end_trans;
 		}
 	}
 
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out_reset;
-	}
-
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
 	if (ret < 0)
 		btrfs_abort_transaction(trans, ret);
 
+out_end_trans:
 	btrfs_commit_transaction(trans);
-
-out_reset:
 	if (ret)
 		btrfs_set_root_flags(&root->root_item, root_flags);
 out_drop_sem:
-- 
2.7.4

