Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:46598 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934855AbcJGCHK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 22:07:10 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix leak subvol subv_writers conter
Date: Fri,  7 Oct 2016 10:01:29 +0800
Message-Id: <1475805689-9989-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

In run_delalloc_nocow, maybe not release subv_writers conter,
will lead to create snapshot hang.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6811c4..9722554 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1386,11 +1386,17 @@ next_slot:
 			 * this ensure that csum for a given extent are
 			 * either valid or do not exist.
 			 */
-			if (csum_exist_in_range(root, disk_bytenr, num_bytes))
+			if (csum_exist_in_range(root, disk_bytenr, num_bytes)) {
+				if (!nolock)
+					btrfs_end_write_no_snapshoting(root);
 				goto out_check;
+			}
 			if (!btrfs_inc_nocow_writers(root->fs_info,
-						     disk_bytenr))
+						     disk_bytenr)) {
+				if (!nolock)
+					btrfs_end_write_no_snapshoting(root);
 				goto out_check;
+			}
 			nocow = 1;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
-- 
1.9.1

