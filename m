Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50585 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3JVLcU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 07:32:20 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Dan Greene <dan-greene@wi.rr.com>
Subject: [RFC PATCH] Btrfs: do not relocate system chunk when building on seeding disk
Date: Tue, 22 Oct 2013 19:32:04 +0800
Message-Id: <1382441524-17423-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we build btrfs on seeding disk, we simply add a disk to provide a RW disk
while seeding disk remains RO, as the disk that we're adding is the first rw
disk, we need to allocate new metadata chunk and system chunk on it for later
udpate use.

After all above is done, we don't need to relocate the system chunk again since
the relocation even tries to find free space on the added disk, the same disk where
we just create our metadata chunk and system chunk.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 043b215..00f3779 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2112,23 +2112,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
-
-		if (ret) /* transaction commit */
-			return ret;
-
-		ret = btrfs_relocate_sys_chunks(root);
-		if (ret < 0)
-			btrfs_error(root->fs_info, ret,
-				    "Failed to relocate sys chunks after "
-				    "device initialization. This can be fixed "
-				    "using the \"btrfs balance\" command.");
-		trans = btrfs_attach_transaction(root);
-		if (IS_ERR(trans)) {
-			if (PTR_ERR(trans) == -ENOENT)
-				return 0;
-			return PTR_ERR(trans);
-		}
-		ret = btrfs_commit_transaction(trans, root);
 	}
 
 	return ret;
-- 
1.7.7

