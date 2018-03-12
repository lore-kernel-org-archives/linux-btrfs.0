Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751104AbeCLMsO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 08:48:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B812EACD2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 12:48:13 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Handle error from btrfs_uuid_tree_rem call in _btrfs_ioctl_set_received_subvol
Date: Mon, 12 Mar 2018 14:48:09 +0200
Message-Id: <1520858889-17729-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As with every function which deals with modifying the btree
btrfs_uuid_tree_rem can fail for any number of reasons (ie. EIO/ENOMEM).
Handle return error value from this function gracefully by aborting the
transaction.

Fixes: dd5f9615fc5c ("Btrfs: maintain subvolume items in the UUID tree")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 987b4843272f..0abe9ca83a9e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5075,10 +5075,17 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 	received_uuid_changed = memcmp(root_item->received_uuid, sa->uuid,
 				       BTRFS_UUID_SIZE);
 	if (received_uuid_changed &&
-	    !btrfs_is_empty_uuid(root_item->received_uuid))
-		btrfs_uuid_tree_rem(trans, fs_info, root_item->received_uuid,
-				    BTRFS_UUID_KEY_RECEIVED_SUBVOL,
-				    root->root_key.objectid);
+	    !btrfs_is_empty_uuid(root_item->received_uuid)) {
+		ret = btrfs_uuid_tree_rem(trans, fs_info,
+					  root_item->received_uuid,
+					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+					  root->root_key.objectid);
+		if (ret && ret != -ENOENT) {
+		        btrfs_abort_transaction(trans, ret);
+		        btrfs_end_transaction(trans);
+		        goto out;
+		}
+	}
 	memcpy(root_item->received_uuid, sa->uuid, BTRFS_UUID_SIZE);
 	btrfs_set_root_stransid(root_item, sa->stransid);
 	btrfs_set_root_rtransid(root_item, sa->rtransid);
-- 
2.7.4

