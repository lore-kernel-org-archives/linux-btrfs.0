Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:14764 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2EWQM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 12:12:57 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id B788419B
	for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 18:12:55 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix false positive in check-integrity on unmount
Date: Wed, 23 May 2012 18:12:55 +0200
Message-Id: <1337789575-29685-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During unmount, it could happen that the integrity checker printed a
warning message "attempt to free ... on umount which is not yet iodone"
which turned out to be a false positive.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d85b9d1..b5e9891 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -3338,7 +3338,7 @@ void btrfsic_unmount(struct btrfs_root *root,
 				btrfsic_block_link_free(l);
 		}
 
-		if (b_all->is_iodone)
+		if (b_all->is_iodone || b_all->never_written)
 			btrfsic_block_free(b_all);
 		else
 			printk(KERN_INFO "btrfs: attempt to free %c-block"
-- 
1.7.10.2

