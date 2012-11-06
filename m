Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:45420 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 30.22 OK)
	with ESMTP id g03dbeoA6AsjWr for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/26] Btrfs: in scrub repair code, optimize the reading of mirrors
Date: Tue,  6 Nov 2012 17:38:22 +0100
Message-Id: <d9eb008e95ec1a230ba3a118c49d8c55de29fe75.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

In case that disk blocks need to be repaired (rewritten), the
current code at first (for simplicity reasons) reads all alternate
mirrors in the first step, afterwards selects the best one in a
second step. This is now changed to read one alternate mirror
after the other and to leave the loop early when a perfect mirror
is found.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 15ac82a..7d38f40 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -819,26 +819,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 
 	/*
 	 * now build and submit the bios for the other mirrors, check
-	 * checksums
-	 */
-	for (mirror_index = 0;
-	     mirror_index < BTRFS_MAX_MIRRORS &&
-	     sblocks_for_recheck[mirror_index].page_count > 0;
-	     mirror_index++) {
-		if (mirror_index == failed_mirror_index)
-			continue;
-
-		/* build and submit the bios, check checksums */
-		ret = scrub_recheck_block(fs_info,
-					  sblocks_for_recheck + mirror_index,
-					  is_metadata, have_csum, csum,
-					  generation, sctx->csum_size);
-		if (ret)
-			goto did_not_correct_error;
-	}
-
-	/*
-	 * first try to pick the mirror which is completely without I/O
+	 * checksums.
+	 * First try to pick the mirror which is completely without I/O
 	 * errors and also does not have a checksum error.
 	 * If one is found, and if a checksum is present, the full block
 	 * that is known to contain an error is rewritten. Afterwards
@@ -854,10 +836,17 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	     mirror_index < BTRFS_MAX_MIRRORS &&
 	     sblocks_for_recheck[mirror_index].page_count > 0;
 	     mirror_index++) {
-		struct scrub_block *sblock_other = sblocks_for_recheck +
-						   mirror_index;
+		struct scrub_block *sblock_other;
 
-		if (!sblock_other->header_error &&
+		if (mirror_index == failed_mirror_index)
+			continue;
+		sblock_other = sblocks_for_recheck + mirror_index;
+
+		/* build and submit the bios, check checksums */
+		ret = scrub_recheck_block(fs_info, sblock_other, is_metadata,
+					  have_csum, csum, generation,
+					  sctx->csum_size);
+		if (!ret && !sblock_other->header_error &&
 		    !sblock_other->checksum_error &&
 		    sblock_other->no_io_error_seen) {
 			int force_write = is_metadata || have_csum;
-- 
1.8.0

