Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcBKRXa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:30 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F0B0AAB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 17:23:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: introduce key type for persistent temporary items
Date: Thu, 11 Feb 2016 18:23:28 +0100
Message-Id: <0bbbccb17fea86818e1a058faf5903aefd20b31a.1455209994.git.dsterba@suse.com>
In-Reply-To: <cover.1455209994.git.dsterba@suse.com>
References: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The number of distinct key types is not that big that we could waste one
for something new we want to store in the tree. We'll introduce a new
name for an existing key value and use the objectid for further
extension.  The victim is the BTRFS_BALANCE_ITEM_KEY (248).

The nature of the balance status item is a good example of the temporary
item. It exists from beginning of the balance, keeps the status until it
finishes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfe4a337fb4d..e20f40649917 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2185,9 +2185,25 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_QGROUP_RELATION_KEY       246
 
+/*
+ * Obsolete name, see BTRFS_TEMPORARY_ITEM_KEY.
+ */
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
+ * The key type for tree items that are stored persistently, but do not need to
+ * exist for extended period of time. The items can exist in any tree.
+ *
+ * [subtype, BTRFS_TEMPORARY_ITEM_KEY, data]
+ *
+ * Existing items:
+ *
+ * - balance status item
+ *   (BTRFS_BALANCE_OBJECTID, BTRFS_TEMPORARY_ITEM_KEY, 0)
+ */
+#define BTRFS_TEMPORARY_ITEM_KEY	248
+
+/*
  * Persistantly stores the io stats in the device tree.
  * One key for all stats, (0, BTRFS_DEV_STATS_KEY, devid).
  */
-- 
2.7.1

