Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49340 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3EHUqh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 May 2013 16:46:37 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5DC609A0699
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 14:46:36 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id rhDdADnrt3KoK1rG (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 14:46:35 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove warn on in free space cache writeout
Date: Wed, 8 May 2013 16:46:33 -0400
Message-ID: <1368045993-4734-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This catches block groups that are too large to properly cache.  We deal with
this case fine, so the warning just confuses users.  Remove the warning.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/free-space-cache.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d61eae9..d7fb58d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -920,10 +920,8 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/* Make sure we can fit our crcs into the first page */
 	if (io_ctl.check_crcs &&
-	    (io_ctl.num_pages * sizeof(u32)) >= PAGE_CACHE_SIZE) {
-		WARN_ON(1);
+	    (io_ctl.num_pages * sizeof(u32)) >= PAGE_CACHE_SIZE)
 		goto out_nospc;
-	}
 
 	io_ctl_set_generation(&io_ctl, trans->transid);
 
-- 
1.7.7.6

