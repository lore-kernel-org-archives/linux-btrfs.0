Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54080 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3KNCNY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 21:13:24 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9B5847C06AD
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 19:13:23 -0700 (MST)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id uOttVFap6266SEYf (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 19:13:23 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix check-integrity to look at the referenced data properly
Date: Wed, 13 Nov 2013 21:13:20 -0500
Message-ID: <1384395200-3291-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were looking at file_extent_num_bytes unconditionally when looking at
referenced data bytes, but this isn't correct for compression.  Fix this by
checking the compression of the file extent we are and setting num_bytes to
disk_num_bytes in the case of compression so that we are marking the proper
bytes as referenced.  This fixes check_int_data freaking out when running
btrfs/004.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/check-integrity.c | 12 ++++++++----
 fs/btrfs/ctree.h           |  4 ++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index e0aab44..b6eac53 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1447,10 +1447,14 @@ static int btrfsic_handle_extent_data(
 	btrfsic_read_from_block_data(block_ctx, &file_extent_item,
 				     file_extent_item_offset,
 				     sizeof(struct btrfs_file_extent_item));
-	next_bytenr = btrfs_stack_file_extent_disk_bytenr(&file_extent_item) +
-		      btrfs_stack_file_extent_offset(&file_extent_item);
-	generation = btrfs_stack_file_extent_generation(&file_extent_item);
-	num_bytes = btrfs_stack_file_extent_num_bytes(&file_extent_item);
+	next_bytenr = btrfs_stack_file_extent_disk_bytenr(&file_extent_item);
+	if (btrfs_stack_file_extent_compression(&file_extent_item) ==
+	    BTRFS_COMPRESS_NONE) {
+		next_bytenr += btrfs_stack_file_extent_offset(&file_extent_item);
+		num_bytes = btrfs_stack_file_extent_num_bytes(&file_extent_item);
+	} else {
+		num_bytes = btrfs_stack_file_extent_disk_num_bytes(&file_extent_item);
+	}
 	generation = btrfs_stack_file_extent_generation(&file_extent_item);
 
 	if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b6a137a..8ff6387 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2927,6 +2927,10 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_generation,
 			 struct btrfs_file_extent_item, generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_num_bytes,
 			 struct btrfs_file_extent_item, num_bytes, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
+			 struct btrfs_file_extent_item, disk_num_bytes, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
+			 struct btrfs_file_extent_item, compression, 8);
 
 static inline unsigned long
 btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
-- 
1.8.3.1

