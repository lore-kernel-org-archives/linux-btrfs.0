Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:18963 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753943AbaBTOty (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 09:49:54 -0500
Date: Thu, 20 Feb 2014 16:44:30 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: don't remove BTRFS_BLOCK_GROUP_DUP in chunk type
Message-ID: <20140220144428.GA31816@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During restoring of image (-r using btrfs-image) we zero out RAID
profile in chunk type but forget to save BTRFS_BLOCK_GROUP_DUP if
present. This results in some false messages being printed by btrfsck.

$  ./mkfs.btrfs /dev/sdb2 -f
$  ./btrfs-image /dev/sdb2 btrfs_image_output
$  ./btrfs-image -r btrfs_image_output disk-image
$  ./btrfsck disk-image
Checking filesystem on disk-image
UUID: e644be2d-7701-4bd4-8804-7487f560d2a7
checking extents
Chunk[256, 228, 20971520]: length(8388608), offset(20971520), type(2) mismatch with block group[20971520, 192, 8388608]: offset(8388608), objectid(20971520), flags(34)
Chunk[256, 228, 29360128]: length(1073741824), offset(29360128), type(4) mismatch with block group[29360128, 192, 1073741824]: offset(1073741824), objectid(29360128), flags(36)
Block group[20971520, 8388608] (flags = 34) didn't find the relative chunk.
Block group[29360128, 1073741824] (flags = 36) didn't find the relative chunk.

Even though ./btrfsck on /dev/sdb2 seemed fine. This is due to type
mismatch above and type mismatch occured because we zero'ed out
BTRFS_BLOCK_GROUP_DUP while handling chunk trees.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 btrfs-image.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 7bcfc06..2be54a7 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1521,7 +1521,8 @@ static int fixup_chunk_tree_block(struct mdrestore_struct *mdres,
 			type = btrfs_stack_chunk_type(&chunk);
 			type &= (BTRFS_BLOCK_GROUP_DATA |
 				 BTRFS_BLOCK_GROUP_SYSTEM |
-				 BTRFS_BLOCK_GROUP_METADATA);
+				 BTRFS_BLOCK_GROUP_METADATA |
+				 BTRFS_BLOCK_GROUP_DUP);
 			btrfs_set_stack_chunk_type(&chunk, type);
 
 			btrfs_set_stack_chunk_num_stripes(&chunk, 1);
-- 
1.8.3.1

