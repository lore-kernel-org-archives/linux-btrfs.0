Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58343 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3DXUt2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 16:49:28 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 98F3C7C0423
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:49:27 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id nZxAitPKwAm3XpmA (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:49:26 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix extent logging with O_DIRECT into prealloc
Date: Wed, 24 Apr 2013 16:49:25 -0400
Message-ID: <1366836565-1936-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the same as the fix from commit

Btrfs: fix bad extent logging

but for O_DIRECT.  I missed this when I fixed the problem originally, we were
still using the em for the orig_start and orig_block_len, which would be the
merged extent.  We need to use the actual extent from the on disk file extent
item, which we have to lookup to make sure it's ok to nocow anyway so just pass
in some pointers to hold this info.  Thanks,

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e24e1a5..9b2df0b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6504,7 +6504,9 @@ out:
  * block must be cow'd
  */
 static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
-				      struct inode *inode, u64 offset, u64 len)
+				      struct inode *inode, u64 offset, u64 len,
+				      u64 *orig_start, u64 *orig_block_len,
+				      u64 *ram_bytes)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -6561,6 +6563,10 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	backref_offset = btrfs_file_extent_offset(leaf, fi);
 
+	*orig_start = disk_bytenr;
+	*orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
+	*ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+
 	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
 	if (extent_end < offset + len) {
 		/* extent doesn't include our full range, must cow */
@@ -6790,7 +6796,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	     em->block_start != EXTENT_MAP_HOLE)) {
 		int type;
 		int ret;
-		u64 block_start;
+		u64 block_start, orig_start, orig_block_len, ram_bytes;
 
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			type = BTRFS_ORDERED_PREALLOC;
@@ -6808,11 +6814,8 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		if (IS_ERR(trans))
 			goto must_cow;
 
-		if (can_nocow_odirect(trans, inode, start, len) == 1) {
-			u64 orig_start = em->orig_start;
-			u64 orig_block_len = em->orig_block_len;
-			u64 ram_bytes = em->ram_bytes;
-
+		if (can_nocow_odirect(trans, inode, start, len, &orig_start,
+				      &orig_block_len, &ram_bytes) == 1) {
 			if (type == BTRFS_ORDERED_PREALLOC) {
 				free_extent_map(em);
 				em = create_pinned_em(inode, start, len,
-- 
1.7.7.6

