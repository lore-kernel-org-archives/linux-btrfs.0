Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50795 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2HaFip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:38:45 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5chdi019118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:44 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5chLp026147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:43 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5ch1O023960
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:38:43 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs: use helper for logical resolve
Date: Fri, 31 Aug 2012 13:36:58 +0800
Message-Id: <1346391419-4278-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
References: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already have a helper, iterate_inodes_from_logical(), for logical resolve,
so just use it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 123ffee..7544134 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3216,12 +3216,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
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
@@ -3247,23 +3244,13 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
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

