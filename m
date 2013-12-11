Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:37231 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3LKXlC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:41:02 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:41:02 -0700
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 8A45219D803E
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:53 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07027.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLcpof262434
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:38:51 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNexSJ031944
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:59 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 7/7] btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE
Date: Wed, 11 Dec 2013 17:38:42 -0600
Message-Id: <1386805122-23972-8-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the final patch of the series that allows filesystems with
blocksize smaller than the PAGE_SIZE.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/btrfs/disk-io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ca1526d..d9bd450 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2615,12 +2615,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
-		goto fail_sb_buffer;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
-- 
1.7.12.4

