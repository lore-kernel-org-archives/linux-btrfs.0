Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59767 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcBKRtU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:49:20 -0500
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 12 Feb 2016 03:49:17 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 5CEF53578056
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:49:15 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1BHn2lv43122824
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:49:10 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1BHmgCJ021343
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Feb 2016 04:48:43 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V15 07/15] Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Thu, 11 Feb 2016 23:17:45 +0530
Message-Id: <1455212873-14829-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1455212873-14829-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allows mounting filesystems with blocksize smaller than the
PAGE_SIZE.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ea540ba..07ccae3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4095,17 +4095,12 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
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
-	if (sectorsize != PAGE_CACHE_SIZE) {
-		printk(KERN_ERR "BTRFS: sectorsize %llu not supported yet, only support %lu\n",
-				sectorsize, PAGE_CACHE_SIZE);
-		ret = -EINVAL;
-	}
+
 	if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
 	    nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		printk(KERN_ERR "BTRFS: invalid nodesize %llu\n", nodesize);
@@ -4129,6 +4124,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				btrfs_super_chunk_root(sb));
 		ret = -EINVAL;
 	}
+
 	if (!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize)) {
 		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
 				btrfs_super_log_root(sb));
-- 
2.1.0

