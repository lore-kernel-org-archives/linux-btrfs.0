Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57214 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080AbcFWJqz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 05:46:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5N9iSYC022235
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 05:46:54 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23qd1j4wr8-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 05:46:53 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 23 Jun 2016 03:46:53 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com,
        bo.li.liu@oracle.com
Subject: [PATCH] Btrfs: Force stripesize to the value of sectorsize
Date: Thu, 23 Jun 2016 15:16:44 +0530
Message-Id: <1466675204-31299-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs code currently assumes stripesize to be same as
sectorsize. However Btrfs-progs (until commit
df05c7ed455f519e6e15e46196392e4757257305) has been setting
btrfs_super_block->stripesize to a value of 4096.

This commit makes sure that the value of btrfs_super_block->stripesize
is a power of 2. Later, it unconditionally sets btrfs_root->stripesize
to sectorsize.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 6 ++----
 fs/btrfs/volumes.c | 4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54cca7a..60ce119 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2806,7 +2806,7 @@ int open_ctree(struct super_block *sb,
 
 	nodesize = btrfs_super_nodesize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = btrfs_super_stripesize(disk_super);
+	stripesize = sectorsize;
 	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
 	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
 
@@ -4133,9 +4133,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 		       btrfs_super_bytes_used(sb));
 		ret = -EINVAL;
 	}
-	if (!is_power_of_2(btrfs_super_stripesize(sb)) ||
-		((btrfs_super_stripesize(sb) != sectorsize) &&
-			(btrfs_super_stripesize(sb) != 4096))) {
+	if (!is_power_of_2(btrfs_super_stripesize(sb))) {
 		btrfs_err(fs_info, "invalid stripesize %u",
 		       btrfs_super_stripesize(sb));
 		ret = -EINVAL;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c3a2900..64eec2c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4694,12 +4694,12 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	if (type & BTRFS_BLOCK_GROUP_RAID5) {
 		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
-				 btrfs_super_stripesize(info->super_copy));
+						extent_root->stripesize);
 		data_stripes = num_stripes - 1;
 	}
 	if (type & BTRFS_BLOCK_GROUP_RAID6) {
 		raid_stripe_len = find_raid56_stripe_len(ndevs - 2,
-				 btrfs_super_stripesize(info->super_copy));
+						extent_root->stripesize);
 		data_stripes = num_stripes - 2;
 	}
 
-- 
2.5.5

