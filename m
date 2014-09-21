Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33132 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaIUSz6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 14:55:58 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 22 Sep 2014 04:55:57 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 490D62CE802D
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:55:56 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s8LIVpsC30015688
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:31:51 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s8LIttwZ017711
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 04:55:56 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V7 07/16] Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Mon, 22 Sep 2014 00:25:21 +0530
Message-Id: <1411325730-21817-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1411325730-21817-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index 6c6e8bb..2f3caaf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2634,12 +2634,6 @@ int open_ctree(struct super_block *sb,
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
2.1.0

