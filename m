Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:42196 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab2K0QKY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 11:10:24 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.5 OK) with ESMTP id p04b40oARBKcVp
	for <linux-btrfs@vger.kernel.org>;
	Tue, 27 Nov 2012 17:10:21 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix race in check-integrity caused by usage of bitfield
Date: Tue, 27 Nov 2012 17:10:21 +0100
Message-Id: <1354032621-20265-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The structure member mirror_num is modified concurrently to the
structure member is_iodone. This doesn't require any locking by
design, unless everything is stored in the same 32 bits of a
bit field. This was the case and xfstest 284 was able to
trigger false warnings from the checker code. This patch
seperates the bits and fixes the race.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 5a3e45d..a6baa8e 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -137,7 +137,7 @@ struct btrfsic_block {
 	unsigned int never_written:1;	/* block was added because it was
 					 * referenced, not because it was
 					 * written */
-	unsigned int mirror_num:2;	/* large enough to hold
+	unsigned int mirror_num;	/* large enough to hold
 					 * BTRFS_SUPER_MIRROR_MAX */
 	struct btrfsic_dev_state *dev_state;
 	u64 dev_bytenr;		/* key, physical byte num on disk */
-- 
1.8.0.1

