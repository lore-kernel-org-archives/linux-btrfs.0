Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43084 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbaFXO3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 10:29:49 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 24 Jun 2014 19:59:46 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id E5458E005D
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 20:00:56 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5OEUto725886732
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 20:00:55 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5OETfYI023551
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:59:43 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, bo.li.liu@oracle.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-btrfs@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V3 7/9] Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Tue, 24 Jun 2014 19:59:06 +0530
Message-Id: <1403620148-28774-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1403620148-28774-1-git-send-email-chandan@linux.vnet.ibm.com>
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

