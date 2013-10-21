Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:32954 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3JUQrA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 12:47:00 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (RZmta 32.10 OK) with ESMTP id g03c20p9LBChjf
	for <linux-btrfs@vger.kernel.org>;
	Mon, 21 Oct 2013 18:46:58 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check_int, remove warning for mixed-mode
Date: Mon, 21 Oct 2013 18:46:58 +0200
Message-Id: <f7dff37ee2384827ced07b15c3dc7be5e6492b6f.1382373903.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In mixed-mode, when a data-block was later reused for metadata, a
warning was printed. This condition is now filtered out and the
warning is eliminated in this case.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 3281f7e..656b076 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1900,7 +1900,9 @@ again:
 							       dev_state,
 							       dev_bytenr);
 			}
-			if (block->logical_bytenr != bytenr) {
+			if (block->logical_bytenr != bytenr &&
+			    !(!block->is_metadata &&
+			      block->logical_bytenr == 0))
 				printk(KERN_INFO
 				       "Written block @%llu (%s/%llu/%d)"
 				       " found in hash table, %c,"
@@ -1910,15 +1912,14 @@ again:
 				       block->mirror_num,
 				       btrfsic_get_block_type(state, block),
 				       block->logical_bytenr);
-				block->logical_bytenr = bytenr;
-			} else if (state->print_mask &
-				   BTRFSIC_PRINT_MASK_VERBOSE)
+			else if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO
 				       "Written block @%llu (%s/%llu/%d)"
 				       " found in hash table, %c.\n",
 				       bytenr, dev_state->name, dev_bytenr,
 				       block->mirror_num,
 				       btrfsic_get_block_type(state, block));
+			block->logical_bytenr = bytenr;
 		} else {
 			if (num_pages * PAGE_CACHE_SIZE <
 			    state->datablock_size) {
-- 
1.8.4

