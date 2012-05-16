Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50815 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135Ab2EPQvT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:51:19 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id 9CB73243
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:51:18 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix runtime warning in check-integrity check data mode
Date: Wed, 16 May 2012 18:51:18 +0200
Message-Id: <f903252285375d5baaf0252db39c3659d0eddd4e.1337186106.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a file_extent_item was located at the very end of a leaf and there was
not enough space to hold a full item, but there was enough space to hold
one of type BTRFS_FILE_EXTENT_INLINE or PREALLOC, and it was only such a
short item, a warning was printed anyway. This check is now fixed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
This patch is based on Josef's btrfs-next, i.e., it fixes an issue
introduced by "Btrfs: change integrity checker to support big blocks".

 fs/btrfs/check-integrity.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7f6cc35..ed76183 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1428,6 +1428,28 @@ static int btrfsic_handle_extent_data(
 
 	file_extent_item_offset = offsetof(struct btrfs_leaf, items) +
 				  item_offset;
+	if (file_extent_item_offset +
+	    offsetof(struct btrfs_file_extent_item, disk_num_bytes) >
+	    block_ctx->len) {
+		printk(KERN_INFO
+		       "btrfsic: file item out of bounce at logical %llu, dev %s\n",
+		       block_ctx->start, block_ctx->dev->name);
+		return -1;
+	}
+
+	btrfsic_read_from_block_data(block_ctx, &file_extent_item,
+		file_extent_item_offset,
+		offsetof(struct btrfs_file_extent_item, disk_num_bytes));
+	if (BTRFS_FILE_EXTENT_REG != file_extent_item.type ||
+	    ((u64)0) == le64_to_cpu(file_extent_item.disk_bytenr)) {
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
+			printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu\n",
+			       file_extent_item.type,
+			       (unsigned long long)
+			       le64_to_cpu(file_extent_item.disk_bytenr));
+		return 0;
+	}
+
 	if (file_extent_item_offset + sizeof(struct btrfs_file_extent_item) >
 	    block_ctx->len) {
 		printk(KERN_INFO
@@ -1452,9 +1474,6 @@ static int btrfsic_handle_extent_data(
 		       le64_to_cpu(file_extent_item.disk_bytenr),
 		       (unsigned long long)le64_to_cpu(file_extent_item.offset),
 		       (unsigned long long)num_bytes);
-	if (BTRFS_FILE_EXTENT_REG != file_extent_item.type ||
-	    ((u64)0) == le64_to_cpu(file_extent_item.disk_bytenr))
-		return 0;
 	while (num_bytes > 0) {
 		u32 chunk_len;
 		int num_copies;
-- 
1.7.10.2

