Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:55444 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbJDJGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Oct 2015 05:06:15 -0400
From: Geliang Tang <geliangtang@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix a comment typo
Date: Sun,  4 Oct 2015 17:05:32 +0800
Message-Id: <336ea7cc85aeb2231eeb1766081b16303b17316a.1443949442.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just fix a typo in the code comment.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/btrfs/free-space-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index abe3a66..7332995 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1215,7 +1215,7 @@ out:
  * @offset - the offset for the key we'll insert
  *
  * This function writes out a free space cache struct to disk for quick recovery
- * on mount.  This will return 0 if it was successfull in writing the cache out,
+ * on mount.  This will return 0 if it was successful in writing the cache out,
  * or an errno if it was not.
  */
 static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
-- 
2.5.0


