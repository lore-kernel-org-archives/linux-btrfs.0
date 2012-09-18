Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33606 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2IRJym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 05:54:42 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8I9seIE008378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 09:54:41 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8I9sdr8023620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 09:54:40 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8I9sdEO002663
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 04:54:39 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix off-by-one in file clone
Date: Tue, 18 Sep 2012 17:52:23 +0800
Message-Id: <1347961943-18185-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs uses inclusive range end for lock_extent(), unlock_extent() and
related functions, so we made off-by-one errors in file clone.

This fixes it and also fixes some style problems.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 00ddf22..225761c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2463,13 +2463,13 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	   another, and lock file content */
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(src)->io_tree, off, off+len);
-		ordered = btrfs_lookup_first_ordered_extent(src, off+len);
+		lock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
+		ordered = btrfs_lookup_first_ordered_extent(src, off + len - 1);
 		if (!ordered &&
-		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off+len,
-				   EXTENT_DELALLOC, 0, NULL))
+		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off + len - 1,
+				    EXTENT_DELALLOC, 0, NULL))
 			break;
-		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len);
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 		btrfs_wait_ordered_range(src, off, len);
@@ -2543,7 +2543,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			btrfs_release_path(path);
 
 			if (key.offset + datal <= off ||
-			    key.offset >= off+len)
+			    key.offset >= off + len - 1)
 				goto next;
 
 			memcpy(&new_key, &key, sizeof(new_key));
@@ -2644,8 +2644,8 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 					new_key.offset += skip;
 				}
 
-				if (key.offset + datal > off+len)
-					trim = key.offset + datal - (off+len);
+				if (key.offset + datal > off + len)
+					trim = key.offset + datal - (off + len);
 
 				if (comp && (skip || trim)) {
 					ret = -EINVAL;
@@ -2722,7 +2722,7 @@ next:
 	ret = 0;
 out:
 	btrfs_release_path(path);
-	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len);
+	unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
-- 
1.7.7.6

