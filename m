Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387758AbeGTR1A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:00 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE56BAD55
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:55 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/7] btrfs: Remove fs_info argument from btrfs_add_dev_item
Date: Fri, 20 Jul 2018 19:37:47 +0300
Message-Id: <1532104673-28311-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced form the passed transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e8fb9d5d976e..e73b9e9d6c10 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1666,10 +1666,8 @@ static noinline int find_next_devid(struct btrfs_fs_info *fs_info,
  * the btrfs_device struct should be fully filled in
  */
 static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info,
 			    struct btrfs_device *device)
 {
-	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_dev_item *dev_item;
@@ -1685,8 +1683,8 @@ static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
 
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(*dev_item));
+	ret = btrfs_insert_empty_item(trans, trans->fs_info->chunk_root, path,
+				      &key, sizeof(*dev_item));
 	if (ret)
 		goto out;
 
@@ -1711,7 +1709,7 @@ static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 	ptr = btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, fs_info->fsid, ptr, BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, trans->fs_info->fsid, ptr, BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
@@ -2441,7 +2439,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		}
 	}
 
-	ret = btrfs_add_dev_item(trans, fs_info, device);
+	ret = btrfs_add_dev_item(trans, device);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto error_sysfs;
-- 
2.7.4

