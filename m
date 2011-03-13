From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] BTRFS: Fix mem leak in btrfs_submit_direct()
Date: Sun, 13 Mar 2011 21:49:18 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1103132145250.29706@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When memory is low and the allocation for 'dip->csums' fail in 
fs/btrfs/inode.c:btrfs_submit_direct() we make the situation worse by 
leaking the memory allocated to 'dip'.
This patch removes the leak by kfree()'ing 'dip' before jumping to the 
'free_ordered' label.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 inode.c |    1 +
 1 file changed, 1 insertion(+)

 compile tested only.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0efdb65..53f4c8e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6056,6 +6056,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 	if (!skip_sum) {
 		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
 		if (!dip->csums) {
+			kfree(dip);
 			ret = -ENOMEM;
 			goto free_ordered;
 		}


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
