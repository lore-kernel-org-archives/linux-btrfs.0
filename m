Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48173 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbFAPYd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 11:24:33 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 2 Jun 2015 01:24:31 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id C82983578048
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2015 01:24:29 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t51FOLSw55181370
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:24:29 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t51FNuSu027445
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Jun 2015 01:23:57 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V11 07/21] Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Mon,  1 Jun 2015 20:52:42 +0530
Message-Id: <1433172176-8742-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allows mounting filesystems with blocksize smaller than the
PAGE_SIZE.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9800888..5dea6b4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2816,12 +2816,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_ERR "BTRFS: incompatible sector size (%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
-		goto fail_sb_buffer;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
@@ -3963,13 +3957,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Check the lower bound, the alignment and other constraints are
 	 * checked later.
 	 */
-	if (btrfs_super_nodesize(sb) < 4096) {
-		printk(KERN_ERR "BTRFS: nodesize too small: %u < 4096\n",
+	if (btrfs_super_nodesize(sb) < 2048) {
+		printk(KERN_ERR "BTRFS: nodesize too small: %u < 2048\n",
 				btrfs_super_nodesize(sb));
 		ret = -EINVAL;
 	}
-	if (btrfs_super_sectorsize(sb) < 4096) {
-		printk(KERN_ERR "BTRFS: sectorsize too small: %u < 4096\n",
+	if (btrfs_super_sectorsize(sb) < 2048) {
+		printk(KERN_ERR "BTRFS: sectorsize too small: %u < 2048\n",
 				btrfs_super_sectorsize(sb));
 		ret = -EINVAL;
 	}
-- 
2.1.0

