Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43598 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2IHCDk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2012 22:03:40 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, dave@jikos.cz
Subject: [PATCH v2 5/6] Btrfs: use helper for logical resolve
Date: Sat,  8 Sep 2012 10:01:29 +0800
Message-Id: <1347069690-30223-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
References: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already have a helper, iterate_inodes_from_logical(), for logical resolve,
so just use it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 365e3e4..7bf3984 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3218,12 +3218,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 {
 	int ret = 0;
 	int size;
-	u64 extent_item_pos;
-	u64 flags = 0;
 	struct btrfs_ioctl_logical_ino_args *loi;
 	struct btrfs_data_container *inodes = NULL;
 	struct btrfs_path *path = NULL;
-	struct btrfs_key key;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3249,23 +3246,13 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 		goto out;
 	}
 
-	ret = extent_from_logical(root->fs_info, loi->logical, path, &key,
-				  &flags);
-	btrfs_release_path(path);
-
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+	ret = iterate_inodes_from_logical(loi->logical, root->fs_info, path,
+					  build_ino_list, inodes);
+	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
 		goto out;
 
-	extent_item_pos = loi->logical - key.objectid;
-	ret = iterate_extent_inodes(root->fs_info, key.objectid,
-					extent_item_pos, 0, build_ino_list,
-					inodes);
-
-	if (ret < 0)
-		goto out;
-
 	ret = copy_to_user((void *)(unsigned long)loi->inodes,
 			   (void *)(unsigned long)inodes, size);
 	if (ret)
-- 
1.7.7.6

