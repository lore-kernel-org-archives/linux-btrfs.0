Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30064 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3HBIaz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 04:30:55 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com
Subject: [PATCH v2] Btrfs: allow compressed extents to be merged during defragment
Date: Fri,  2 Aug 2013 16:30:40 +0800
Message-Id: <1375432240-30174-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The rule originally comes from nocow writing, but snapshot-aware
defrag is a different case, the extent has been writen and we're
not going to change the extent but add a reference on the data.

So we're able to allow such compressed extents to be merged into
one bigger extent if they're pointing to the same data.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v1->v2:
	- pass the whole struct instead to keep the code simple.

 fs/btrfs/inode.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 55dda87..7c8d2a28 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2229,16 +2229,18 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 
 static int relink_is_mergable(struct extent_buffer *leaf,
 			      struct btrfs_file_extent_item *fi,
-			      u64 disk_bytenr)
+			      struct new_sa_defrag_extent *new)
 {
-	if (btrfs_file_extent_disk_bytenr(leaf, fi) != disk_bytenr)
+	if (btrfs_file_extent_disk_bytenr(leaf, fi) != new->bytenr)
 		return 0;
 
 	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
 		return 0;
 
-	if (btrfs_file_extent_compression(leaf, fi) ||
-	    btrfs_file_extent_encryption(leaf, fi) ||
+	if (btrfs_file_extent_compression(leaf, fi) != new->compress_type)
+		return 0;
+
+	if (btrfs_file_extent_encryption(leaf, fi) ||
 	    btrfs_file_extent_other_encoding(leaf, fi))
 		return 0;
 
@@ -2382,8 +2384,8 @@ again:
 				    struct btrfs_file_extent_item);
 		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
 
-		if (relink_is_mergable(leaf, fi, new->bytenr) &&
-		    extent_len + found_key.offset == start) {
+		if (extent_len + found_key.offset == start &&
+		    relink_is_mergable(leaf, fi, new)) {
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							extent_len + len);
 			btrfs_mark_buffer_dirty(leaf);
-- 
1.8.1.4

