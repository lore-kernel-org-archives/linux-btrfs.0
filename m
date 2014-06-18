Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55036 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753982AbaFRFdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 01:33:39 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5I5XaXO028408
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 13:33:36 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: clean fsck noise for free inode generation 0
Date: Wed, 18 Jun 2014 13:28:22 +0800
Message-ID: <1403069302-12057-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we write a btrfs to full and then we have no space left for
free space cache.
The btrfs check will output msg as follows which is noise indeed:
	# free space inode generation (0) did not match
	  free space cache generation (XXX)

When the free space cache is not written out normally,
the free inode generation will be 0.
In this condition, no noise should be outputed.
Also, check 0-sized inode eariler together with 0-generationed inode.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 free-space-cache.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index bddde24..2440dd8 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -310,6 +310,13 @@ static int __load_free_space_cache(struct btrfs_root *root,
 	leaf = path->nodes[0];
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
+
+	inode_size = btrfs_inode_size(leaf, inode_item);
+	if (!inode_size || !btrfs_inode_generation(leaf, inode_item)) {
+		btrfs_release_path(path);
+		return 0;
+	}
+
 	if (btrfs_inode_generation(leaf, inode_item) != generation) {
 		printf("free space inode generation (%llu) did not match "
 		       "free space cache generation (%llu)\n",
@@ -320,10 +327,7 @@ static int __load_free_space_cache(struct btrfs_root *root,
 		return 0;
 	}
 
-	inode_size = btrfs_inode_size(leaf, inode_item);
 	btrfs_release_path(path);
-	if (inode_size == 0)
-		return 0;
 
 	if (!num_entries)
 		return 0;
-- 
1.8.1.4

