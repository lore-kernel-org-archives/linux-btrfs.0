Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:39045 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbeGBHpT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 03:45:19 -0400
From: Ethan Lien <ethanlien@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Ethan Lien <ethanlien@synology.com>
Subject: [PATCH] btrfs: use correct compare function of dirty_metadata_bytes
Date: Mon,  2 Jul 2018 15:44:58 +0800
Message-Id: <20180702074458.16270-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use customized, nodesize batch value to update dirty_metadata_bytes.
We should also use batch version of compare function or we will easily
goto fast path and get false result from percpu_counter_compare().

Signed-off-by: Ethan Lien <ethanlien@synology.com>
---
 fs/btrfs/disk-io.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 205092dc9390..dfed08e70ec1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -961,8 +961,9 @@ static int btree_writepages(struct address_space *mapping,
 
 		fs_info = BTRFS_I(mapping->host)->root->fs_info;
 		/* this is a bit racy, but that's ok */
-		ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
-					     BTRFS_DIRTY_METADATA_THRESH);
+		ret = __percpu_counter_compare(&fs_info->dirty_metadata_bytes,
+					     BTRFS_DIRTY_METADATA_THRESH,
+					     fs_info->dirty_metadata_batch);
 		if (ret < 0)
 			return 0;
 	}
@@ -4150,8 +4151,9 @@ static void __btrfs_btree_balance_dirty(struct btrfs_fs_info *fs_info,
 	if (flush_delayed)
 		btrfs_balance_delayed_items(fs_info);
 
-	ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
-				     BTRFS_DIRTY_METADATA_THRESH);
+	ret = __percpu_counter_compare(&fs_info->dirty_metadata_bytes,
+				     BTRFS_DIRTY_METADATA_THRESH,
+				     fs_info->dirty_metadata_batch);
 	if (ret > 0) {
 		balance_dirty_pages_ratelimited(fs_info->btree_inode->i_mapping);
 	}
-- 
2.17.1

