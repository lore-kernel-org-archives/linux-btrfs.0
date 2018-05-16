Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36677 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752957AbeEPI27 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 04:28:59 -0400
From: Ethan Lien <ethanlien@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Ethan Lien <ethanlien@synology.com>
Subject: [PATCH] btrfs: Skip some btrfs_cross_ref_exist() check in nocow path
Date: Wed, 16 May 2018 16:28:54 +0800
Message-Id: <20180516082854.29254-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In nocow path, we check if the extent is snapshotted in
btrfs_cross_ref_exist(). We can do the similar check earlier and avoid
unnecessary search into extent tree.

Signed-off-by: Ethan Lien <ethanlien@synology.com>
---
 fs/btrfs/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..96927f2ccd4b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1373,6 +1373,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			    btrfs_file_extent_encryption(leaf, fi) ||
 			    btrfs_file_extent_other_encoding(leaf, fi))
 				goto out_check;
+			if (btrfs_file_extent_generation(leaf, fi) <=
+			    btrfs_root_last_snapshot(&root->root_item))
+				goto out_check;
 			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
 				goto out_check;
 			if (btrfs_extent_readonly(fs_info, disk_bytenr))
@@ -7368,6 +7371,10 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	    btrfs_file_extent_other_encoding(leaf, fi))
 		goto out;
 
+	if (btrfs_file_extent_generation(leaf, fi) <=
+	    btrfs_root_last_snapshot(&root->root_item))
+		goto out;
+
 	backref_offset = btrfs_file_extent_offset(leaf, fi);
 
 	if (orig_start) {
-- 
2.17.0

