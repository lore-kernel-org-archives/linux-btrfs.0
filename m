Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36495 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbbI3KaC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:30:02 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 20:30:00 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id E5D1C2BB0051
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:57 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UATnXY49872960
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:57 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UATOuw023883
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:25 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V5 09/13] Btrfs: Limit inline extents to root->sectorsize
Date: Wed, 30 Sep 2015 15:58:28 +0530
Message-Id: <1443608912-31667-10-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index b1ceba4..b2eedb9 100644
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

