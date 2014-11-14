Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56686 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017AbaKNPjh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 10:39:37 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 15 Nov 2014 01:39:36 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 9170E2BB0057
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:34 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAEFd9i940960074
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:17 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAEFd1i5021340
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:02 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, aneesh.kumar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, chandan@mykolab.com,
        steve.capper@linaro.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V9 07/17] Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Fri, 14 Nov 2014 21:08:09 +0530
Message-Id: <1415979499-15821-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
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

