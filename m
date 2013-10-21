Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:42908 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab3JUMSU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 08:18:20 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (RZmta 32.10 OK) with ESMTP id X03a4dp9LAVQIt
	for <linux-btrfs@vger.kernel.org>;
	Mon, 21 Oct 2013 14:18:17 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix check_int 'leaf item out of bounce' regression
Date: Mon, 21 Oct 2013 14:18:17 +0200
Message-Id: <aad45add55d8da007ae8f35730c8b2fb1d801999.1382357581.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yet another cleanup patch broke code for which no xfstest exists.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1c47be1..3281f7e 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1038,7 +1038,7 @@ leaf_item_out_of_bounce_error:
 						     disk_item_offset,
 						     sizeof(struct btrfs_item));
 			item_offset = btrfs_stack_item_offset(&disk_item);
-			item_size = btrfs_stack_item_offset(&disk_item);
+			item_size = btrfs_stack_item_size(&disk_item);
 			disk_key = &disk_item.key;
 			type = btrfs_disk_key_type(disk_key);
 
-- 
1.8.4

