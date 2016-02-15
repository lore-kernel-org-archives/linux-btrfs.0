Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbcBORek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:40 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, anand.jain@oracle.com
Subject: [PATCH 12/15] btrfs: indtroduce raid-type to error-code table, for minimum device constraint
Date: Mon, 15 Feb 2016 18:34:36 +0100
Message-Id: <d05a46053f82b1b716cad4178c91242ed515b166.1455556900.git.dsterba@suse.com>
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
References: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 15 +++++++++++++++
 fs/btrfs/volumes.h |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ae94e06f3e61..a67249582a6f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -118,6 +118,21 @@ const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID6]  = BTRFS_BLOCK_GROUP_RAID6,
 };
 
+/*
+ * Table to convert BTRFS_RAID_* to the error code if minimum number of devices
+ * condition is not met. Zero means there's no corresponding
+ * BTRFS_ERROR_DEV_*_NOT_MET value.
+ */
+const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES] = {
+	[BTRFS_RAID_RAID10] = BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
+	[BTRFS_RAID_RAID1]  = BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
+	[BTRFS_RAID_DUP]    = 0,
+	[BTRFS_RAID_RAID0]  = 0,
+	[BTRFS_RAID_SINGLE] = 0,
+	[BTRFS_RAID_RAID5]  = BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
+	[BTRFS_RAID_RAID6]  = BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
+};
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c73d027e2f8b..a13a538cb01e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -340,7 +340,7 @@ struct btrfs_raid_attr {
 };
 
 extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES];
-
+extern const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES];
 extern const u64 btrfs_raid_group[BTRFS_NR_RAID_TYPES];
 
 struct map_lookup {
-- 
2.7.1

