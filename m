Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42537 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab3GKOjU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 10:39:20 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6ABCB7C0417
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 08:39:19 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id HG3YZxuH0LxOBLna (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 08:39:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: allow splitting of hole em's when dropping extent cache
Date: Thu, 11 Jul 2013 10:39:16 -0400
Message-ID: <1373553556-18927-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed while running multi-threaded fsync tests that sometimes fsck would
complain about an improper gap.  This happens because we fail to add a hole
extent to the file, which was happening when we'd split a hole EM because
btrfs_drop_extent_cache was just discarding the whole em instead of splitting
it.  So this patch fixes this by allowing us to split a hole em properly, which
means that added holes actually get logged properly and we no longer see this
fsck error.  Thankfully we're tolerant of these sort of problems so a user would
not see any adverse effects of this bug, other than fsck complaining.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file.c |   62 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2d70849..dda2efb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -595,20 +595,29 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 		if (no_splits)
 			goto next;
 
-		if (em->block_start < EXTENT_MAP_LAST_BYTE &&
-		    em->start < start) {
+		if (em->start < start) {
 			split->start = em->start;
 			split->len = start - em->start;
-			split->orig_start = em->orig_start;
-			split->block_start = em->block_start;
 
-			if (compressed)
-				split->block_len = em->block_len;
-			else
-				split->block_len = split->len;
-			split->ram_bytes = em->ram_bytes;
-			split->orig_block_len = max(split->block_len,
-						    em->orig_block_len);
+			if (em->block_start < EXTENT_MAP_LAST_BYTE) {
+				split->orig_start = em->orig_start;
+				split->block_start = em->block_start;
+
+				if (compressed)
+					split->block_len = em->block_len;
+				else
+					split->block_len = split->len;
+				split->orig_block_len = max(split->block_len,
+						em->orig_block_len);
+				split->ram_bytes = em->ram_bytes;
+			} else {
+				split->orig_start = split->start;
+				split->block_len = 0;
+				split->block_start = em->block_start;
+				split->orig_block_len = 0;
+				split->ram_bytes = split->len;
+			}
+
 			split->generation = gen;
 			split->bdev = em->bdev;
 			split->flags = flags;
@@ -619,8 +628,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split = split2;
 			split2 = NULL;
 		}
-		if (em->block_start < EXTENT_MAP_LAST_BYTE &&
-		    testend && em->start + em->len > start + len) {
+		if (testend && em->start + em->len > start + len) {
 			u64 diff = start + len - em->start;
 
 			split->start = start + len;
@@ -629,18 +637,28 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split->flags = flags;
 			split->compress_type = em->compress_type;
 			split->generation = gen;
-			split->orig_block_len = max(em->block_len,
+
+			if (em->block_start < EXTENT_MAP_LAST_BYTE) {
+				split->orig_block_len = max(em->block_len,
 						    em->orig_block_len);
-			split->ram_bytes = em->ram_bytes;
 
-			if (compressed) {
-				split->block_len = em->block_len;
-				split->block_start = em->block_start;
-				split->orig_start = em->orig_start;
+				split->ram_bytes = em->ram_bytes;
+				if (compressed) {
+					split->block_len = em->block_len;
+					split->block_start = em->block_start;
+					split->orig_start = em->orig_start;
+				} else {
+					split->block_len = split->len;
+					split->block_start = em->block_start
+						+ diff;
+					split->orig_start = em->orig_start;
+				}
 			} else {
-				split->block_len = split->len;
-				split->block_start = em->block_start + diff;
-				split->orig_start = em->orig_start;
+				split->ram_bytes = split->len;
+				split->orig_start = split->start;
+				split->block_len = 0;
+				split->block_start = em->block_start;
+				split->orig_block_len = 0;
 			}
 
 			ret = add_extent_mapping(em_tree, split, modified);
-- 
1.7.7.6

