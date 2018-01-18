Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754805AbeARMrK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 07:47:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73808ACDC
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 12:47:09 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use IS_ALIGNED in btrfs_truncate_block instead of opencoding it
Date: Thu, 18 Jan 2018 14:47:06 +0200
Message-Id: <1516279626-6111-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes, just makes the code more readable

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 269d129ffb1f..e9690e2aba09 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4775,8 +4775,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	u64 block_start;
 	u64 block_end;
 
-	if ((offset & (blocksize - 1)) == 0 &&
-	    (!len || ((len & (blocksize - 1)) == 0)))
+	if (IS_ALIGNED(offset, blocksize) &&
+	    (!len || IS_ALIGNED(len, blocksize)))
 		goto out;
 
 	block_start = round_down(from, blocksize);
-- 
2.7.4

