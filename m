Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36950 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbcEBXAl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 19:00:41 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: master.b.at.raven@chefmail.de
Subject: [PATCH] Btrfs: fix unexpected balance crash due to BUG_ON
Date: Mon,  2 May 2016 16:01:02 -0700
Message-Id: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mounting a btrfs can resume previous balance operations asynchronously.
An user got a crash when one drive has some corrupt sectors.

Since balance can cancel itself in case of any error, we can gracefully
return errors to upper layers and let balance do the cancel job.

Reported-by: sash <master.b.at.raven@chefmail.de>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bd0f45f..5aed2e2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3418,13 +3418,25 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
 		if (ret == -ENOSPC)
 			break;
-		BUG_ON(ret);
+		if (ret) {
+			/* btrfs_shrink_device never returns ret > 0 */
+			WARN_ON_ONCE(ret > 0);
+			goto error;
+		}
 
 		trans = btrfs_start_transaction(dev_root, 0);
-		BUG_ON(IS_ERR(trans));
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto error;
+		}
 
 		ret = btrfs_grow_device(trans, device, old_size);
-		BUG_ON(ret);
+		if (ret) {
+			btrfs_end_transaction(trans, dev_root);
+			/* btrfs_grow_device never returns ret > 0 */
+			WARN_ON_ONCE(ret > 0);
+			goto error;
+		}
 
 		btrfs_end_transaction(trans, dev_root);
 	}
-- 
2.5.5

