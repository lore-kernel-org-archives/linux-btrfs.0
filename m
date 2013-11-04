Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60789 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3KDNe7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 08:34:59 -0500
From: Aldo Iljazi <mail@aldo.io>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] FS: BTRFS: fixed a styling issue
Date: Mon,  4 Nov 2013 15:34:44 +0200
Message-Id: <1383572084-19299-1-git-send-email-mail@aldo.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Line 363:
Added a space before the open parenthesis.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 6aad98c..91338d2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -360,7 +360,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
 	bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
-	if(!bio) {
+	if (!bio) {
 		kfree(cb);
 		return -ENOMEM;
 	}
-- 
1.8.3.2

