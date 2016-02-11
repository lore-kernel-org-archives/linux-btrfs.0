Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbcBKRXg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7F0E4AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 17:23:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: introduce key type for persistent permanent items
Date: Thu, 11 Feb 2016 18:23:35 +0100
Message-Id: <50c2d5abe64c1726b48d292a2ab04f60e8238933.1455209994.git.dsterba@suse.com>
In-Reply-To: <cover.1455209994.git.dsterba@suse.com>
References: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The number of distinct key types is not that big that we could waste one
for something new we want to store in the tree.

Similar to the temporary items, we'll introduce a new name for an
existing key value and use the objectid for further extension.  The
victim is the BTRFS_DEV_STATS_KEY (248).

The device stats are an example of a permanent item.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e20f40649917..ffc081e11277 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2204,10 +2204,24 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_TEMPORARY_ITEM_KEY	248
 
 /*
- * Persistantly stores the io stats in the device tree.
- * One key for all stats, (0, BTRFS_DEV_STATS_KEY, devid).
+ * Obsolete name, see BTRFS_PERSISTENT_ITEM_KEY
  */
-#define BTRFS_DEV_STATS_KEY	249
+#define BTRFS_DEV_STATS_KEY		249
+
+/*
+ * The key type for tree items that are stored persistently and usually exist
+ * for a long period, eg. filesystem lifetime. The item kinds can be status
+ * information, stats or preference values. The item can exist in any tree.
+ *
+ * [subtype, BTRFS_PERSISTENT_ITEM_KEY, data]
+ *
+ * Existing items:
+ *
+ * - device statistics, store IO stats in the device tree, one key for all
+ *   stats
+ *   (0, BTRFS_DEV_STATS_KEY, 0)
+ */
+#define BTRFS_PERSISTENT_ITEM_KEY	249
 
 /*
  * Persistantly stores the device replace state in the device tree.
-- 
2.7.1

