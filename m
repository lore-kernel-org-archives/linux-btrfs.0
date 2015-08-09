Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41238 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037AbbHIPLA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Aug 2015 11:11:00 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 10 Aug 2015 01:10:58 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 9B8372CE8059
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:56 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t79FAmvr61866020
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:56 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t79FANc2009437
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 01:10:24 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V3 09/11] Btrfs: Limit inline extents to root->sectorsize
Date: Sun,  9 Aug 2015 20:39:30 +0530
Message-Id: <1439132972-24321-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1439132972-24321-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1439132972-24321-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index f7afdff..99288ff 100644
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

