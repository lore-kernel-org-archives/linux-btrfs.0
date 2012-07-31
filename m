Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:20307 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2GaRJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 13:09:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp4) (RZmta 30.2 OK) with ESMTP id 604ec5o6V9eXwP
	for <linux-btrfs@vger.kernel.org>;
	Tue, 31 Jul 2012 19:09:45 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: detect corrupted filesystem after write I/O errors
Date: Tue, 31 Jul 2012 19:09:44 +0200
Message-Id: <1343754585-18084-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In check-integrity, detect when a superblock is written that points
to blocks that have not been written to disk due to I/O write errors.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 9197e2e..5a3e45d 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -37,8 +37,9 @@
  *        the file system was mounted, (i.e., they have been
  *        referenced by the super block) or they have been
  *        written since then and the write completion callback
- *        was called and a FLUSH request to the device where
- *        these blocks are located was received and completed.
+ *        was called and no write error was indicated and a
+ *        FLUSH request to the device where these blocks are
+ *        located was received and completed.
  *    2b. All referenced blocks need to have a generation
  *        number which is equal to the parent's number.
  *
@@ -2601,6 +2602,17 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       (unsigned long long)l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num);
 			ret = -1;
+		} else if (l->block_ref_to->iodone_w_error) {
+			printk(KERN_INFO "btrfs: attempt to write superblock"
+			       " which references block %c @%llu (%s/%llu/%d)"
+			       " which has write error!\n",
+			       btrfsic_get_block_type(state, l->block_ref_to),
+			       (unsigned long long)
+			       l->block_ref_to->logical_bytenr,
+			       l->block_ref_to->dev_state->name,
+			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num);
+			ret = -1;
 		} else if (l->parent_generation !=
 			   l->block_ref_to->generation &&
 			   BTRFSIC_GENERATION_UNKNOWN !=
-- 
1.7.11.4

