Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27624 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdCCCmZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 21:42:25 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: remove ASSERT in btrfs_truncate_inode_items
Date: Thu,  2 Mar 2017 18:41:19 -0800
Message-Id: <1488508879-25326-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After 76b42abbf748 ("Btrfs: fix data loss after truncate when using the
no-holes feature"),

For either NO_HOLES or inline extents, we've set last_size to newsize to
avoid data loss after remount or inode got evicted and read again, thus,
we don't need this check anymore.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ee6978d..5652f5f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4603,13 +4603,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 	btrfs_free_path(path);
 
-	if (err == 0) {
-		/* only inline file may have last_size != new_size */
-		if (new_size >= fs_info->sectorsize ||
-		    new_size > fs_info->max_inline)
-			ASSERT(last_size == new_size);
-	}
-
 	if (be_nice && bytes_deleted > SZ_32M) {
 		unsigned long updates = trans->delayed_ref_updates;
 		if (updates) {
-- 
1.8.3.1

