Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbcD1DGo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 23:06:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/2] btrfs: create degraded-RAID1 chunks
Date: Thu, 28 Apr 2016 11:06:19 +0800
Message-Id: <1461812780-538-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When RAID1 is degraded, newer chunks should be degraded-RAID1
chunks instead of single chunks.

The bug is because the devs_min for raid1 was wrong it should
be 1, instead of 2.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e2b54d546b7c..8b87ed6eb381 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -56,7 +56,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.sub_stripes	= 1,
 		.dev_stripes	= 1,
 		.devs_max	= 2,
-		.devs_min	= 2,
+		.devs_min	= 1,
 		.tolerated_failures = 1,
 		.devs_increment	= 2,
 		.ncopies	= 2,
@@ -4513,6 +4513,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int i;
 	int j;
 	int index;
+	int missing_dev = 0;
 
 	BUG_ON(!alloc_profile_is_valid(type, 0));
 
@@ -4627,14 +4628,35 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
 	     btrfs_cmp_device_info, NULL);
 
-	/* round down to number of usable stripes */
-	ndevs -= ndevs % devs_increment;
 
-	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
+	/*
+	 * For raid1 and raid10; ndevs = devs_min, is less than
+	 * (devs_increment * sub_stripes) = x in degraded mode.
+	 * For rest of the RAIDs, x is 1
+	 */
+	if (ndevs >= (devs_increment * sub_stripes)) {
+		/* round down to number of usable stripes */
+		ndevs -= ndevs % devs_increment;
+	}
+
+	/*
+	 * Fix devs_min for RAID10
+	 */
+	if (ndevs < devs_min) {
+		/* todo: look for better error reporting */
 		ret = -ENOSPC;
 		goto error;
 	}
 
+	/*
+	 * For RAID1 and RAID10 if there is no sufficient dev for mirror
+	 * or stripe, let the chunks be created in degraded mode.
+	 * And for rest of RAIDs its fine as (devs_increment * sub_stripes)
+	 * is 1.
+	 */
+	if (ndevs < (devs_increment * sub_stripes))
+		missing_dev = (devs_increment * sub_stripes) - ndevs;
+
 	if (devs_max && ndevs > devs_max)
 		ndevs = devs_max;
 	/*
@@ -4645,11 +4667,17 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	num_stripes = ndevs * dev_stripes;
 
 	/*
-	 * this will have to be fixed for RAID1 and RAID10 over
+	 * This will have to be fixed for RAID1 and RAID10 over
 	 * more drives
 	 */
 	data_stripes = num_stripes / ncopies;
 
+	if (type & BTRFS_BLOCK_GROUP_RAID1) {
+		if (missing_dev) {
+			/* For RAID1 data_stripes is always 1 rather */
+			data_stripes = num_stripes;
+		}
+	}
 	if (type & BTRFS_BLOCK_GROUP_RAID5) {
 		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
 				 btrfs_super_stripesize(info->super_copy));
-- 
2.7.0

