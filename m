Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:25095 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2HPEoF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 00:44:05 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7G4i4Hl009090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 04:44:04 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7G4i3q0027070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 04:44:04 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7G4i3X5005424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 23:44:03 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: use helper for logical resolve
Date: Thu, 16 Aug 2012 12:42:46 +0800
Message-Id: <1345092166-7089-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1345092166-7089-1-git-send-email-bo.li.liu@oracle.com>
References: <1345092166-7089-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already have a helper, iterate_inodes_from_logical(), for logical resolve,
so just use it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 405b279..f1ff21a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3210,12 +3210,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
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
@@ -3241,20 +3238,9 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 		goto out;
 	}
 
-	ret = extent_from_logical(root->fs_info, loi->logical, path, &key,
-				  &flags);
-	btrfs_release_path(path);
-
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
-		ret = -ENOENT;
-	if (ret < 0)
-		goto out;
-
-	extent_item_pos = loi->logical - key.objectid;
-	ret = iterate_extent_inodes(root->fs_info, key.objectid,
-					extent_item_pos, 0, build_ino_list,
-					inodes);
-
+	path->search_commit_root = 0;
+	ret = iterate_inodes_from_logical(loi->logical, root->fs_info, path,
+					  build_ino_list, inodes);
 	if (ret < 0)
 		goto out;
 
-- 
1.7.7.6

