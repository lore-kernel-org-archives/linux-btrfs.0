Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50917 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3GAONp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 10:13:45 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r61E7ORT016574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jul 2013 14:07:25 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r61EDhDX011401
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jul 2013 14:13:43 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r61EDgmW007213
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jul 2013 14:13:42 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a bug of snapshot-aware defrag to make it work on partial extents
Date: Mon,  1 Jul 2013 22:13:26 +0800
Message-Id: <1372688006-18176-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For partial extents, snapshot-aware defrag does not work as expected,
since
a) we use the wrong logical offset to search for parents, which should be
   disk_bytenr + extent_offset, not just disk_bytenr,
b) 'offset' returned by the backref walking just refers to key.offset, not
   the 'offset' stored in btrfs_extent_data_ref which is
   (key.offset - extent_offset).

The reproducer:
$ mkfs.btrfs sda
$ mount sda /mnt
$ btrfs sub create /mnt/sub
$ for i in `seq 5 -1 1`; do dd if=/dev/zero of=/mnt/sub/foo bs=5k count=1 seek=$i conv=notrunc oflag=sync; done
$ btrfs sub snap /mnt/sub /mnt/snap1
$ btrfs sub snap /mnt/sub /mnt/snap2
$ sync; btrfs filesystem defrag /mnt/sub/foo;
$ umount /mnt
$ btrfs-debug-tree sda (Here we can check whether the defrag operation is snapshot-awared.

This addresses the above two problems.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c931a4d..ab87862 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2134,16 +2134,23 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		if (btrfs_file_extent_disk_bytenr(leaf, extent) != old->bytenr)
 			continue;
 
-		extent_offset = btrfs_file_extent_offset(leaf, extent);
-		if (key.offset - extent_offset != offset)
+		/*
+		 * 'offset' refers to the exact key.offset,
+		 * NOT the 'offset' field in btrfs_extent_data_ref, ie.
+		 * (key.offset - extent_offset).
+		 */
+		if (key.offset != offset)
 			continue;
 
+		extent_offset = btrfs_file_extent_offset(leaf, extent);
 		num_bytes = btrfs_file_extent_num_bytes(leaf, extent);
+
 		if (extent_offset >= old->extent_offset + old->offset +
 		    old->len || extent_offset + num_bytes <=
 		    old->extent_offset + old->offset)
 			continue;
 
+		ret = 0;
 		break;
 	}
 
@@ -2155,7 +2162,7 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 
 	backref->root_id = root_id;
 	backref->inum = inum;
-	backref->file_pos = offset + extent_offset;
+	backref->file_pos = offset;
 	backref->num_bytes = num_bytes;
 	backref->extent_offset = extent_offset;
 	backref->generation = btrfs_file_extent_generation(leaf, extent);
@@ -2178,7 +2185,8 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 	new->path = path;
 
 	list_for_each_entry_safe(old, tmp, &new->head, list) {
-		ret = iterate_inodes_from_logical(old->bytenr, fs_info,
+		ret = iterate_inodes_from_logical(old->bytenr +
+						  old->extent_offset, fs_info,
 						  path, record_one_backref,
 						  old);
 		BUG_ON(ret < 0 && ret != -ENOENT);
-- 
1.7.7

