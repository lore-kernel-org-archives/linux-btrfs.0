Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17735 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2HPGMN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 02:12:13 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7G6CC0m014507
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 06:12:13 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7G6CCHF025661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 06:12:12 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7G6CBvr012414
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 01:12:11 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] Btrfs: use helper for logical resolve
Date: Thu, 16 Aug 2012 14:10:52 +0800
Message-Id: <1345097452-7939-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1345097452-7939-1-git-send-email-bo.li.liu@oracle.com>
References: <1345097452-7939-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already have a helper, iterate_inodes_from_logical(), for logical resolve,
so just use it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v1->v2: patch -EINVAL to -ENOENT to keep the behaviour, thanks to Jan.

 fs/btrfs/ioctl.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 405b279..be51870 100644
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
@@ -3241,23 +3238,13 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
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

