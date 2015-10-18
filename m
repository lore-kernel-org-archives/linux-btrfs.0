Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31949 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbbJRFpR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 01:45:17 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9I5jGJc016074
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 05:45:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t9I5jFAf009489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 05:45:16 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t9I5jFXW032414
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 05:45:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix btrfs-convert rollback to check ROOT_BACKREF
Date: Sun, 18 Oct 2015 13:44:41 +0800
Message-Id: <1445147081-13511-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has changed to delete subvolume/snapshot asynchronously, which means that
after umount itself, if we've already deleted 'ext2_saved', rollback can still
be completed.

So this adds a check for ROOT_BACKREF before checking ROOT_ITEM since
ROOT_BACKREF is immediately not in the btree after ioctl(BTRFS_IOC_SNAP_DESTROY)
returns.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-convert.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 802930c..f8a6c16 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2591,6 +2591,22 @@ static int do_rollback(const char *devname)
 	btrfs_init_path(&path);
 
 	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = BTRFS_FS_TREE_OBJECTID;
+	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path, 0,
+				0);
+	btrfs_release_path(&path);
+	if (ret > 0) {
+		fprintf(stderr, "unable to open subvol %llu\n",
+			(unsigned long long)key.objectid);
+		goto fail;
+	} else if (ret < 0) {
+		fprintf(stderr, "unable to open subvol %llu ret %d\n",
+			(unsigned long long)key.objectid, ret);
+		goto fail;
+	}
+
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
 	image_root = btrfs_read_fs_root(root->fs_info, &key);
-- 
1.8.2.1

