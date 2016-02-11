Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbcBKRXk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:40 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C3664AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 17:23:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: switch dev stats item to the permanent item key
Date: Thu, 11 Feb 2016 18:23:38 +0100
Message-Id: <242e2956e4afde7727fffe21adc0a7b198b77f96.1455209994.git.dsterba@suse.com>
In-Reply-To: <cover.1455209994.git.dsterba@suse.com>
References: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 5 ++++-
 fs/btrfs/volumes.c | 8 ++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ffc081e11277..70054ed2bd7b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -100,6 +100,9 @@ struct btrfs_ordered_sum;
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* device stats in the device tree */
+#define BTRFS_DEV_STATS_OBJECTID 0ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -2219,7 +2222,7 @@ struct btrfs_ioctl_defrag_range_args {
  *
  * - device statistics, store IO stats in the device tree, one key for all
  *   stats
- *   (0, BTRFS_DEV_STATS_KEY, 0)
+ *   (BTRFS_DEV_STATS_OBJECTID, BTRFS_DEV_STATS_KEY, 0)
  */
 #define BTRFS_PERSISTENT_ITEM_KEY	249
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b306a205504b..177a0a8dfd31 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6705,8 +6705,8 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
 		int item_size;
 		struct btrfs_dev_stats_item *ptr;
 
-		key.objectid = 0;
-		key.type = BTRFS_DEV_STATS_KEY;
+		key.objectid = BTRFS_DEV_STATS_OBJECTID;
+		key.type = BTRFS_PERSISTENT_ITEM_KEY;
 		key.offset = device->devid;
 		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
 		if (ret) {
@@ -6753,8 +6753,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 	int ret;
 	int i;
 
-	key.objectid = 0;
-	key.type = BTRFS_DEV_STATS_KEY;
+	key.objectid = BTRFS_DEV_STATS_OBJECTID;
+	key.type = BTRFS_PERSISTENT_ITEM_KEY;
 	key.offset = device->devid;
 
 	path = btrfs_alloc_path();
-- 
2.7.1

