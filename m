Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39821 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752446AbdI1Hx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 03:53:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01327AAC5
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:53:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 2/2] btrfs: Remove received_uuid during received snapshot ro->rw switch
Date: Thu, 28 Sep 2017 10:53:18 +0300
Message-Id: <1506585198-32494-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1506585198-32494-1-git-send-email-nborisov@suse.com>
References: <20170927140007.GH31640@twin.jikos.cz>
 <1506585198-32494-1-git-send-email-nborisov@suse.com>
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

v3:
 * Rework the patch considering latest feedback from David Sterba i.e. 
 explicitly use btrfs_end_transaction 

 fs/btrfs/ioctl.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ee4ee7cbba72..c0374125cec2 100644
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
@@ -1824,22 +1835,33 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
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
+					btrfs_end_transaction(trans);
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
+			btrfs_end_transaction(trans);
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
 	if (ret < 0) {
-- 
2.7.4

