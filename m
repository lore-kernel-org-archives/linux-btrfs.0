Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751344AbeA0GPl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 01:15:41 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, anand.jain@oracle.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix UAF
Date: Fri, 26 Jan 2018 15:20:27 +0200
Message-Id: <1516972827-1481-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 4fde46f0cc71 ("Btrfs: free the stale device") introduced
btrfs_free_stale_device which iterates the device lists for all
registered btrfs filesystems and deletes those devices which aren't
mounted. In a btrfs_devices structure has only 1 device attached to it
and it is unused then btrfs_free_stale_devices will proceed to also
free the btrfs_fs_devices struct itself. Currently this leads to a UAF
since list_for_each_entry will try to perform a check on the already-
freed memory to see if it has to terminated the loop.

The fix is to use 'break' when we know we are freeing the current
fs_devs.

Fixes: 4fde46f0cc71 ("Btrfs: free the stale device")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f7147740b68e..c3ab55336ee0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -645,6 +645,7 @@ static void btrfs_free_stale_devices(const char *path,
 				btrfs_sysfs_remove_fsid(fs_devs);
 				list_del(&fs_devs->list);
 				free_fs_devices(fs_devs);
+				break;
 			} else {
 				fs_devs->num_devices--;
 				list_del(&dev->dev_list);
-- 
2.7.4

