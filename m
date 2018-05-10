Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37500 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753693AbeEJGV1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 02:21:27 -0400
Received: by mail-pg0-f68.google.com with SMTP id a13-v6so504687pgu.4
        for <linux-btrfs@vger.kernel.org>; Wed, 09 May 2018 23:21:27 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 01/10] Btrfs: remove stale comment referencing vmtruncate()
Date: Wed,  9 May 2018 23:21:02 -0700
Message-Id: <d50e22690bdea060f485ac1dc19a54fa4d6e4411.1525932796.git.osandov@fb.com>
In-Reply-To: <cover.1525932796.git.osandov@fb.com>
References: <cover.1525932796.git.osandov@fb.com>
In-Reply-To: <cover.1525932796.git.osandov@fb.com>
References: <cover.1525932796.git.osandov@fb.com>
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

