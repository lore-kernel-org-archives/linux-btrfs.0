Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:35111 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056Ab3EGKXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 06:23:34 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] Btrfs: fix a comment
Date: Tue,  7 May 2013 12:23:30 +0200
Message-Id: <1367922210-1939-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The size parameter to btrfs_extend_item() is the number of bytes
to add to the item, not the size of the item after the operation
(like it is for btrfs_truncate_item(), there the size parameter
is not the number of bytes to take away, but the total size of
the item after truncation).
Fix it in the comment.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 566d99b..85e158e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4381,7 +4381,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 }
 
 /*
- * make the item pointed to by the path bigger, data_size is the new size.
+ * make the item pointed to by the path bigger, data_size is the added size.
  */
 void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 		       u32 data_size)
-- 
1.8.2.2

