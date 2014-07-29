Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52221 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaG2LOY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:14:24 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 16:44:22 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 6E603E004B
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:46:06 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6TBEMgN60489970
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:22 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6TBEJCE013121
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 16:44:20 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V5 07/12] Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Tue, 29 Jul 2014 16:43:42 +0530
Message-Id: <1406632427-2209-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1406632427-2209-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Chandra Seetharaman <sekharan@us.ibm.com>

This patch allows mounting filesystems with blocksize smaller than the
PAGE_SIZE.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 28a45f6..3bb7072 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2599,12 +2599,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "BTRFS: Incompatible sector size(%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
-		goto fail_sb_buffer;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
-- 
1.8.3.1

