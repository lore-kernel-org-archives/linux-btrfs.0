Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3GIUh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 16:37:28 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E27BEA51FF
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 22:37:26 +0200 (CEST)
Message-ID: <51DC7481.8020005@suse.com>
Date: Tue, 09 Jul 2013 16:37:21 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fall back to global reservation when removing subvolumes
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I recently did some ENOSPC testing that involved filling the disk
while create and removing snapshots in a loop. During the test cycle,
I ran into an ENOSPC when trying to remove a snapshot, leaving the fs
stuck in ENOSPC even after a umount/mount cycle.

This patch allow subvolume removal to fall back onto the global
block reservation in order to succeed when it would have failed
otherwise.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |    8 +++++++-
 fs/btrfs/ioctl.c       |    7 ++++---
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/fs/btrfs/ctree.h	2013-07-09 13:29:35.396801859 -0400
+++ b/fs/btrfs/ctree.h	2013-07-09 14:38:04.132071707 -0400
@@ -3186,7 +3186,7 @@ void btrfs_orphan_release_metadata(struc
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems,
-				     u64 *qgroup_reserved);
+				     u64 *qgroup_reserved, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv,
 				      u64 qgroup_reserved);
--- a/fs/btrfs/extent-tree.c	2013-07-09 13:45:53.226342333 -0400
+++ b/fs/btrfs/extent-tree.c	2013-07-09 15:24:09.639950458 -0400
@@ -4735,10 +4735,12 @@ void btrfs_orphan_release_metadata(struc
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int items,
-				     u64 *qgroup_reserved)
+				     u64 *qgroup_reserved,
+				     bool use_global_rsv)
 {
 	u64 num_bytes;
 	int ret;
+	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 
 	if (root->fs_info->quota_enabled) {
 		/* One for parent inode, two for dir entries */
@@ -4757,6 +4759,10 @@ int btrfs_subvolume_reserve_metadata(str
 					    BTRFS_BLOCK_GROUP_METADATA);
 	ret = btrfs_block_rsv_add(root, rsv, num_bytes,
 				  BTRFS_RESERVE_FLUSH_ALL);
+
+	if (ret == -ENOSPC && use_global_rsv)
+		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes);
+
 	if (ret) {
 		if (*qgroup_reserved)
 			btrfs_qgroup_free(root, *qgroup_reserved);
--- a/fs/btrfs/ioctl.c	2013-07-09 14:37:25.828624893 -0400
+++ b/fs/btrfs/ioctl.c	2013-07-09 14:37:45.868335492 -0400
@@ -396,7 +396,7 @@ static noinline int create_subvol(struct
 	 * of create_snapshot().
 	 */
 	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
-					       7, &qgroup_reserved);
+					       7, &qgroup_reserved, false);
 	if (ret)
 		return ret;
 
@@ -576,7 +576,8 @@ static int create_snapshot(struct btrfs_
 	 */
 	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
 					&pending_snapshot->block_rsv, 7,
-					&pending_snapshot->qgroup_reserved);
+					&pending_snapshot->qgroup_reserved,
+					false);
 	if (ret)
 		goto out;
 
@@ -2174,7 +2175,7 @@ static noinline int btrfs_ioctl_snap_des
 	 * ref/backref.
 	 */
 	err = btrfs_subvolume_reserve_metadata(root, &block_rsv,
-					       5, &qgroup_reserved);
+					       5, &qgroup_reserved, true);
 	if (err)
 		goto out_up_write;
 

-- 
Jeff Mahoney
SUSE Labs
