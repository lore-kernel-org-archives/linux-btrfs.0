Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51869 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbcFWB2k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 21:28:40 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5N1SeM5012667
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u5N1Sdtd004283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:39 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1Sbtu023207
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:38 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup BUG_ON in merge_bio
Date: Wed, 22 Jun 2016 18:31:49 -0700
Message-Id: <1466645509-26910-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One can use btrfs-corrupt-block to hit BUG_ON() in merge_bio(),
thus this aims to stop anyone to panic the whole system by using
 their btrfs.

Since the error in merge_bio can only come from __btrfs_map_block()
when chunk tree mapping has something insane and __btrfs_map_block()
has already had printed the reason, we can just return errors in
merge_bio.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 1 -
 fs/btrfs/inode.c     | 8 ++++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index aa44d3e..a8661fb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2756,7 +2756,6 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 	if (tree->ops && tree->ops->merge_bio_hook)
 		ret = tree->ops->merge_bio_hook(rw, page, offset, size, bio,
 						bio_flags);
-	BUG_ON(ret < 0);
 	return ret;
 
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8b1212e..d203c06 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1822,6 +1822,10 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 /*
  * extent_io.c merge_bio_hook, this must check the chunk tree to make sure
  * we don't create bios that span stripes or chunks
+ *
+ * return 1 if page cannot be merged to bio
+ * return 0 if page can be merged to bio
+ * return error otherwise
  */
 int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
@@ -1840,8 +1844,8 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 	map_length = length;
 	ret = btrfs_map_block(root->fs_info, rw, logical,
 			      &map_length, NULL, 0);
-	/* Will always return 0 with map_multi == NULL */
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		return ret;
 	if (map_length < length + size)
 		return 1;
 	return 0;
-- 
2.5.5

