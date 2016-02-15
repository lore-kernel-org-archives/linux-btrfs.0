Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbcBOReo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:44 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, anand.jain@oracle.com
Subject: [PATCH 13/15] btrfs: use existing device constraints table btrfs_raid_array
Date: Mon, 15 Feb 2016 18:34:39 +0100
Message-Id: <1294a3215cb0e28a81c33ed1b8921aae95043619.1455556900.git.dsterba@suse.com>
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
References: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should avoid duplicating the device constraints, let's use the
btrfs_raid_array in btrfs_check_raid_min_devices.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a67249582a6f..8fee24f92574 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1730,6 +1730,7 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
 {
 	u64 all_avail;
 	unsigned seq;
+	int i;
 
 	do {
 		seq = read_seqbegin(&fs_info->profiles_lock);
@@ -1739,22 +1740,16 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
 			    fs_info->avail_metadata_alloc_bits;
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices < 4) {
-		return BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
-	}
-
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices < 2) {
-		return BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET;
-	}
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		if (!(all_avail & btrfs_raid_group[i]))
+			continue;
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
-	    fs_info->fs_devices->rw_devices < 2) {
-		return BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
-	}
+		if (num_devices < btrfs_raid_array[i].devs_min) {
+			int ret = btrfs_raid_mindev_error[i];
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
-	    fs_info->fs_devices->rw_devices < 3) {
-		return BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
-- 
2.7.1

