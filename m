Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:17480 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab2KNS5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 13:57:33 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.3 OK) with ESMTP id X0333aoAEAlUyf
	for <linux-btrfs@vger.kernel.org>;
	Wed, 14 Nov 2012 19:57:29 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix BUG() in scrub when first superblock reading gives EIO
Date: Wed, 14 Nov 2012 19:57:29 +0100
Message-Id: <1352919449-28529-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a very special case that can be reproduced by just
disconnecting a disk at runtime, and without unmounting the
filesystem first, start scrub on the filesystem with the
disconnected disk. All read and write EIOs are handled
correctly, only the first superblock is an exception and gives
a BUG() in a subfunction. The BUG() is correct, it would crash
later otherwise. The subfunction must not be called for
superblocks and this is what the fix changes.

Reported-by: Joeri Vanthienen <mail@joerivanthienen.be>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---

This patch is for btrfs-next, not for 3.7rc.

 fs/btrfs/scrub.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 30ba997..37c6443 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -785,6 +785,17 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 
 	BUG_ON(sblock_to_check->page_count < 1);
 	fs_info = sctx->dev_root->fs_info;
+	if (sblock_to_check->pagev[0]->flags & BTRFS_EXTENT_FLAG_SUPER) {
+		/*
+		 * if we find an error in a super block, we just report it.
+		 * They will get written with the next transaction commit
+		 * anyway
+		 */
+		spin_lock(&sctx->stat_lock);
+		++sctx->stat.super_errors;
+		spin_unlock(&sctx->stat_lock);
+		return 0;
+	}
 	length = sblock_to_check->page_count * PAGE_SIZE;
 	logical = sblock_to_check->pagev[0]->logical;
 	generation = sblock_to_check->pagev[0]->generation;
-- 
1.8.0

