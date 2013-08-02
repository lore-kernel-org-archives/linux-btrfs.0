Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32792 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3HBGuE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 02:50:04 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r726o3JN011097
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Aug 2013 06:50:04 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r726o2Mt026808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Aug 2013 06:50:02 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r726o1D9002361
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Aug 2013 06:50:01 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allow compressed extents to be merged during defragment
Date: Fri,  2 Aug 2013 14:49:54 +0800
Message-Id: <1375426194-28121-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The rule originally comes from nocow writing, but snapshot-aware
defrag is a different case, the extent has been writen and we're
not going to change the extent but add a reference on the data.

So we're able to allow such compressed extents to be merged into
one bigger extent if they're pointing to the same data.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 55dda87..a7aeecc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2229,7 +2229,7 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 
 static int relink_is_mergable(struct extent_buffer *leaf,
 			      struct btrfs_file_extent_item *fi,
-			      u64 disk_bytenr)
+			      u64 disk_bytenr, u8 compress)
 {
 	if (btrfs_file_extent_disk_bytenr(leaf, fi) != disk_bytenr)
 		return 0;
@@ -2237,8 +2237,10 @@ static int relink_is_mergable(struct extent_buffer *leaf,
 	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
 		return 0;
 
-	if (btrfs_file_extent_compression(leaf, fi) ||
-	    btrfs_file_extent_encryption(leaf, fi) ||
+	if (btrfs_file_extent_compression(leaf, fi) != compress)
+		return 0;
+
+	if (btrfs_file_extent_encryption(leaf, fi) ||
 	    btrfs_file_extent_other_encoding(leaf, fi))
 		return 0;
 
@@ -2382,8 +2384,9 @@ again:
 				    struct btrfs_file_extent_item);
 		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
 
-		if (relink_is_mergable(leaf, fi, new->bytenr) &&
-		    extent_len + found_key.offset == start) {
+		if (extent_len + found_key.offset == start &&
+		    relink_is_mergable(leaf, fi, new->bytenr,
+				       new->compress_type)) {
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							extent_len + len);
 			btrfs_mark_buffer_dirty(leaf);
-- 
1.8.1.4

