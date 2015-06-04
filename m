Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:31832 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbbFDL1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 07:27:54 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 5/5] Btrfs: incremental send, fix rmdir not send utimes
Date: Thu,  4 Jun 2015 19:18:10 +0800
Message-Id: <1433416690-19177-6-git-send-email-robbieko@synology.com>
In-Reply-To: <1433416690-19177-1-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one case where we can't issue a utimes operation for a directory.
When 263 will delete, waiting 261 and set 261 rmdir_ino, but 262 earlier
processed and update uime between two parent directory.
So fix this by not update non exist utimes for this case.

Example:

Parent snapshot:
|---- a/ (ino 259)
  |---- c (ino 264)
|---- b/ (ino 260)
  |---- d (ino 265)
|---- del/ (ino 263)
  |---- item1/ (ino 261)
  |---- item2/ (ino 262)

Send snapshot:
|---- a/ (ino 259)
|---- b/ (ino 260)
|---- c/ (ino 2)
  |---- item2 (ino 259)
|---- d/ (ino 257)
  |---- item1/ (ino 258)

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e8eb3ab..46f954c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2468,7 +2468,7 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
-	if (ret < 0)
+	if (ret != 0)
 		goto out;
 
 	eb = path->nodes[0];
-- 
1.9.1

