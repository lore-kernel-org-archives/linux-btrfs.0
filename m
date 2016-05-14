Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbcENAF0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:05:26 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4E05Ojr018025
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05O92000323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u4E05OmZ008376
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] Btrfs: replace BUG_ON with WARN in merge_bio
Date: Fri, 13 May 2016 17:07:00 -0700
Message-Id: <1463184422-13584-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have two BUG_ON in merge_bio, but since it can gracefully return errors
to callers, use WARN_ONCE to give error information and don't leave a
possible panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 1 -
 fs/btrfs/inode.c     | 6 ++++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e601e0f..99286d1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2746,7 +2746,6 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 	if (tree->ops && tree->ops->merge_bio_hook)
 		ret = tree->ops->merge_bio_hook(rw, page, offset, size, bio,
 						bio_flags);
-	BUG_ON(ret < 0);
 	return ret;
 
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5874562..3a989e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1827,8 +1827,10 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 	map_length = length;
 	ret = btrfs_map_block(root->fs_info, rw, logical,
 			      &map_length, NULL, 0);
-	/* Will always return 0 with map_multi == NULL */
-	BUG_ON(ret < 0);
+	if (ret < 0) {
+		WARN_ONCE(ret < 0, KERN_ERR "ret = %d\n", ret);
+		return ret;
+	}
 	if (map_length < length + size)
 		return 1;
 	return 0;
-- 
2.5.5

