Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54914 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaCLOVl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 10:21:41 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Mar 2014 19:51:39 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id C5061125803E
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:53:52 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2CELWg737093514
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:51:32 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2CELbm5010944
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:51:37 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 6/6] Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Wed, 12 Mar 2014 19:50:33 +0530
Message-Id: <1394634033-2528-7-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 796d889..aa9e3bb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2617,12 +2617,6 @@ int open_ctree(struct super_block *sb,
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

