Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726751AbeIMNn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:43:29 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80988AD49
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 08:35:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove logically dead code from btrfs_orphan_cleanup
Date: Thu, 13 Sep 2018 11:35:00 +0300
Message-Id: <1536827700-20477-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_orphan_cleanup the final 'if (ret) goto out' cannot ever be
executed. This is due to the last assignment to 'ret' depending on
the return value of btrfs_iget. If an error other than -ENOENT is
returned then the loop is prematurely terminated by 'goto out'.
On the other hand, if the error value is ENOENT then a subsequent
if branch is executed that always re-assigns 'ret' and in case it's
an error just terminates the loop. No functional changes.

CID: 1437392
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f03fec06a3a..64df0378a22f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3471,8 +3471,6 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 		/* this will do delete_inode and everything for us */
 		iput(inode);
-		if (ret)
-			goto out;
 	}
 	/* release the path since we're done with it */
 	btrfs_release_path(path);
-- 
2.7.4
