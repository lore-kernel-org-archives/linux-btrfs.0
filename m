Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752421AbdHUJn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 764FFABD6
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:55 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/10] btrfs: Remove unused parameter from check_direct_IO
Date: Mon, 21 Aug 2017 12:43:46 +0300
Message-Id: <1503308630-6652-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduced by 5a5f79b57069 ("Btrfs: allow unaligned DIO") and never used, 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61f1ad89e97a..f1b3d6146924 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8764,7 +8764,6 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 }
 
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
-			       struct kiocb *iocb,
 			       const struct iov_iter *iter, loff_t offset)
 {
 	int seg;
@@ -8811,7 +8810,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	bool relock = false;
 	ssize_t ret;
 
-	if (check_direct_IO(fs_info, iocb, iter, offset))
+	if (check_direct_IO(fs_info, iter, offset))
 		return 0;
 
 	inode_dio_begin(inode);
-- 
2.7.4

