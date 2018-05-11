Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:34451 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbeEKH4V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:21 -0400
Received: by mail-pl0-f66.google.com with SMTP id ay10-v6so2844779plb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:21 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 01/11] Btrfs: remove stale comment referencing vmtruncate()
Date: Fri, 11 May 2018 00:56:06 -0700
Message-Id: <d50e22690bdea060f485ac1dc19a54fa4d6e4411.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Commit a41ad394a03b ("Btrfs: convert to the new truncate sequence")
changed vmtruncate() to truncate_setsize() but didn't update the comment
above it. truncate_setsize() never fails (the IS_SWAPFILE() check
happens elsewhere), so remove the comment.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..fef8dbb6a93f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5106,7 +5106,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		if (ret)
 			return ret;
 
-		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
 
 		/* Disable nonlocked read DIO to avoid the end less truncate */
-- 
2.17.0

