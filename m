Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53357 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3LBGxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 01:53:08 -0500
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 2 Dec 2013 12:23:05 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id A4EE3394004E
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Dec 2013 12:23:03 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rB26r1AQ52297946
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 12:23:01 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rB26r22n008589
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 12:23:02 +0530
Received: from localhost.localdomain ([9.124.35.31])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id rB26r2vf008580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 12:23:02 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs: Add linear chunk allocation support.
Date: Mon, 02 Dec 2013 12:23:02 +0630
Message-ID: <1674620.BNzKaL6CNE@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch implements the *core* of the idea suggested at
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Linear_chunk_allocation_mode.
Other required changes (e.g. balance/restripe) will be made based on
the reviews obtained for this patch.

On a multi-disk filesystem instance using single mode storage, we could
minimize the data loss (due to a hard drive failure) by filling up a disk
completely before starting to use another disk.

Chunk allocation is performed based on the increasing order of devid i.e.
the device with the lowest devid will be used for allocating the new chunk.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h   |  4 +++-
 fs/btrfs/volumes.c | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 82e2b74..fb13d85 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -522,6 +522,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_LINEAR_CHUNK_ALLOC (1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -539,7 +540,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_LINEAR_CHUNK_ALLOC)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0db6370..8288fb5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3884,7 +3884,7 @@ static int btrfs_add_system_chunk(struct btrfs_root *root,
 /*
  * sort the devices in descending order by max_avail, total_avail
  */
-static int btrfs_cmp_device_info(const void *a, const void *b)
+static int btrfs_cmp_device_info_space(const void *a, const void *b)
 {
 	const struct btrfs_device_info *di_a = a;
 	const struct btrfs_device_info *di_b = b;
@@ -3900,6 +3900,18 @@ static int btrfs_cmp_device_info(const void *a, const void *b)
 	return 0;
 }
 
+static int btrfs_cmp_device_info_devid(const void *a, const void *b)
+{
+	const struct btrfs_device_info *di_a = a;
+	const struct btrfs_device_info *di_b = b;
+
+	if (di_a->dev->devid > di_b->dev->devid)
+		return 1;
+	if (di_a->dev->devid < di_b->dev->devid)
+		return -1;
+	return 0;
+}
+
 static struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
 		.sub_stripes	= 2,
@@ -3985,6 +3997,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct extent_map *em;
 	struct btrfs_device_info *devices_info = NULL;
 	u64 total_avail;
+	u64 incompat_flags;
 	int num_stripes;	/* total number of stripes to allocate */
 	int data_stripes;	/* number of stripes that count for
 				   block group size */
@@ -4106,11 +4119,22 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		++ndevs;
 	}
 
-	/*
-	 * now sort the devices by hole size / available space
-	 */
-	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
-	     btrfs_cmp_device_info, NULL);
+	incompat_flags = btrfs_super_incompat_flags(info->super_copy);
+
+	if ((chunk_to_extended(type) & BTRFS_AVAIL_ALLOC_BIT_SINGLE)
+		&& (incompat_flags & BTRFS_FEATURE_INCOMPAT_LINEAR_CHUNK_ALLOC)) {
+		/*
+		 * Sort the devices obtained based on devid.
+		 */
+		sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
+			btrfs_cmp_device_info_devid, NULL);
+	} else {
+		/*
+		 * now sort the devices by hole size / available space
+		 */
+		sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
+			btrfs_cmp_device_info_space, NULL);
+	}
 
 	/* round down to number of usable stripes */
 	ndevs -= ndevs % devs_increment;
-- 
1.8.3.1


