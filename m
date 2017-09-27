Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752454AbdI0IyE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 04:54:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E882BAABA
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 08:54:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, dsterba@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Remove received_uuid during received snapshot ro->rw switch
Date: Wed, 27 Sep 2017 11:53:58 +0300
Message-Id: <1506502438-15550-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1506436062-23825-2-git-send-email-nborisov@suse.com>
References: <1506436062-23825-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently when a read-only snapshot is received and subsequently its ro property
is set to false i.e. switched to rw-mode the received_uuid of that subvol remains
intact. However, once the received volume is switched to RW mode we cannot
guaranteee that it contains the same data, so it makes sense to remove the
received uuid. The presence of the received_uuid can also cause problems when
the volume is being send.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Changes since v1: 
 * Dropped patch 1/2 which was doing a bit of refactoring w.r.t transaction 
 failure handling and instead folded the once change with made sense (
 ret = btrfs_commit_transaction) under the out_reset label.

 fs/btrfs/ioctl.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d6715c2bcdc4..2049da6a0698 100644
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
@@ -1824,27 +1835,36 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
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
+					goto out_reset;
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
+			goto out_reset;
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
 
-	btrfs_commit_transaction(trans);
 out_reset:
+	ret = btrfs_commit_transaction(trans);
 	if (ret)
 		btrfs_set_root_flags(&root->root_item, root_flags);
 out_drop_sem:
-- 
2.7.4

