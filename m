Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42023 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbeCLJaY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 05:30:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7EA8BAE82
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 09:30:23 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove received information from snapshot on ro->rw switch
Date: Mon, 12 Mar 2018 11:30:20 +0200
Message-Id: <1520847020-8049-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently when a read-only snapshot is received and subsequently its
ro property is set to false i.e. switched to rw-mode the
received_uuid/stime/rtime/stransid/rtransid of that subvol remains
intact. However, once the received volume is switched to RW mode we
cannot guaranteee that it contains the same data, so it makes sense
to remove those fields which indicate this volume was ever
send/received. Additionally, sending such volume can cause conflicts
due to the presence of received_uuid.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Suggested-by: David Sterba <dsterba@suse.cz>
---
Changes: 
 * changed the title to make it more generic. Old was: "btrfs: Remove
 received_uuid during received snapshot ro->rw switch"

 * Clear additional fields that pertain to subvol receive operation. 

 fs/btrfs/ioctl.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5011b6272cfa..987b4843272f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1758,6 +1758,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	struct btrfs_trans_handle *trans;
 	u64 root_flags;
 	u64 flags;
+	bool clear_received_state = false;
 	int ret = 0;
 
 	if (!inode_owner_or_capable(inode))
@@ -1807,6 +1808,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 			btrfs_set_root_flags(&root->root_item,
 				     root_flags & ~BTRFS_ROOT_SUBVOL_RDONLY);
 			spin_unlock(&root->root_item_lock);
+			clear_received_state = true;
 		} else {
 			spin_unlock(&root->root_item_lock);
 			btrfs_warn(fs_info,
@@ -1823,6 +1825,31 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_reset;
 	}
 
+	if (clear_received_state) {
+	        if (!btrfs_is_empty_uuid(root->root_item.received_uuid)) {
+			struct btrfs_root_item *root_item = &root->root_item;
+
+	                ret = btrfs_uuid_tree_rem(trans, fs_info,
+	                                root->root_item.received_uuid,
+	                                BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+	                                root->root_key.objectid);
+
+	                if (ret && ret != -ENOENT) {
+	                        btrfs_abort_transaction(trans, ret);
+	                        btrfs_end_transaction(trans);
+	                        goto out_reset;
+	                }
+
+	                memset(root_item->received_uuid, 0, BTRFS_UUID_SIZE);
+			btrfs_set_root_stransid(root_item, 0);
+			btrfs_set_root_rtransid(root_item, 0);
+			btrfs_set_stack_timespec_sec(&root_item->stime, 0);
+			btrfs_set_stack_timespec_nsec(&root_item->stime, 0);
+			btrfs_set_stack_timespec_sec(&root_item->rtime, 0);
+			btrfs_set_stack_timespec_nsec(&root_item->rtime, 0);
+	        }
+	}
+
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
 	if (ret < 0) {
-- 
2.7.4

