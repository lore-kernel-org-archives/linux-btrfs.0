From: Li Hong <lihong.hi@gmail.com>
Subject: [PATCH] btrfs: tree-log.c Remove some redundant code and comment.
Date: Sat, 17 Oct 2009 17:00:07 +0800
Message-ID: <20091017090007.GA6255@uhli>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From c8635be5ccdaff6d399c115b7c51ecc622cb9191 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Sat, 17 Oct 2009 16:48:56 +0800
Subject: [PATCH] btrfs: tree-log.c Remove some redundant code and comment.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f51bf13..c228499 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3148,13 +3148,7 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 	 * so the new name gets discovered.
 	 */
 	if (for_rename)
-		goto record;
-
-	/* we can safely do the unlink without any special recording */
-	return;
-
-record:
-	BTRFS_I(dir)->last_unlink_trans = trans->transid;
+		BTRFS_I(dir)->last_unlink_trans = trans->transid;
 }
 
 /*
-- 
1.6.0.4

