Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:32811 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbbHGHHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 03:07:35 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 7 Aug 2015 17:07:32 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 839302BB005B
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 17:07:30 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7777Hoq2031964
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 17:07:25 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7776vxl032239
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 17:06:58 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com,
        quwenruo@cn.fujitsu.com
Subject: [PATCH V2 09/11] Btrfs: Limit inline extents to root->sectorsize
Date: Fri,  7 Aug 2015 12:35:56 +0530
Message-Id: <1438931158-20888-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cow_file_range_inline() limits the size of an inline extent to
PAGE_CACHE_SIZE. This breaks in subpagesize-blocksize scenarios. Fix this by
comparing against root->sectorsize.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1acee74..daf2462 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -257,7 +257,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 		data_len = compressed_size;
 
 	if (start > 0 ||
-	    actual_end > PAGE_CACHE_SIZE ||
+	    actual_end > root->sectorsize ||
 	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
 	    (!compressed_size &&
 	    (actual_end & (root->sectorsize - 1)) == 0) ||
-- 
2.1.0

