Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([125.16.236.4]:34226 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbcDNNjB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 09:39:01 -0400
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 14 Apr 2016 19:08:58 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3EDdCsh66846778
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 19:09:12 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3EJ6v8x010189
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 00:37:00 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com, aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH V17 07/18] Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize < PAGE_SIZE
Date: Thu, 14 Apr 2016 19:08:16 +0530
Message-Id: <1460641107-13834-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1460641107-13834-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1460641107-13834-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allows mounting filesystems with sectorsize smaller than the
PAGE_SIZE.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 708b8cb..1db0063 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4076,17 +4076,12 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Check sectorsize and nodesize first, other check will need it.
 	 * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
 	 */
-	if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
+	if (!is_power_of_2(sectorsize) || sectorsize < 2048 ||
 	    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		printk(KERN_ERR "BTRFS: invalid sectorsize %llu\n", sectorsize);
 		ret = -EINVAL;
 	}
-	/* Only PAGE SIZE is supported yet */
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_ERR "BTRFS: sectorsize %llu not supported yet, only support %lu\n",
-				sectorsize, PAGE_SIZE);
-		ret = -EINVAL;
-	}
+
 	if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
 	    nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		printk(KERN_ERR "BTRFS: invalid nodesize %llu\n", nodesize);
@@ -4110,6 +4105,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				btrfs_super_chunk_root(sb));
 		ret = -EINVAL;
 	}
+
 	if (!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize)) {
 		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
 				btrfs_super_log_root(sb));
-- 
2.1.0

