Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46638 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbbJRMGh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 08:06:37 -0400
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 18 Oct 2015 22:06:34 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 921D62CE8052
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:31 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9IC6AWL30605462
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:18 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9IC5woo029507
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:05:59 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V6 09/13] Btrfs: Limit inline extents to root->sectorsize
Date: Sun, 18 Oct 2015 17:34:59 +0530
Message-Id: <1445169903-13915-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1445169903-13915-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1445169903-13915-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cow_file_range_inline() limits the size of an inline extent to
PAGE_CACHE_SIZE. This breaks in subpagesize-blocksize scenarios. Fix this by
comparing against root->sectorsize.

Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1826603..c0c83f1 100644
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

