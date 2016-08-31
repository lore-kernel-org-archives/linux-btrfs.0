Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30743 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754549AbcHaXiG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 19:38:06 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix endless loop in balancing block groups
Date: Wed, 31 Aug 2016 16:43:33 -0700
Message-Id: <1472687013-463-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qgroup function may overwrite the saved error 'err' with 0
in case quota is not enabled, and this ends up with a
endless loop in balance because we keep going back to balance
the same block group.

It really should use 'ret' instead.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8a2c2a0..c0c13dc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4200,9 +4200,11 @@ restart:
 		err = PTR_ERR(trans);
 		goto out_free;
 	}
-	err = qgroup_fix_relocated_data_extents(trans, rc);
-	if (err < 0) {
-		btrfs_abort_transaction(trans, err);
+	ret = qgroup_fix_relocated_data_extents(trans, rc);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+		if (!err)
+			err = ret;
 		goto out_free;
 	}
 	btrfs_commit_transaction(trans, rc->extent_root);
-- 
2.5.5

