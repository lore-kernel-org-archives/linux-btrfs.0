Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbcC3OGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:19 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1F5FEAC42
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 14:06:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: fallback to vmalloc in btrfs_compare_tree
Date: Wed, 30 Mar 2016 16:05:43 +0200
Message-Id: <1459346743-17191-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The allocation of node could fail if the memory is too fragmented for a
given node size, practically observed with 64k.

http://article.gmane.org/gmane.comp.file-systems.btrfs/54689

Reported-by: Jean-Denis Girard <jd.girard@sysnux.pf>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 77592931ab4f..ec7928a27aaa 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
+#include <linux/vmalloc.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -5361,10 +5362,13 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		goto out;
 	}
 
-	tmp_buf = kmalloc(left_root->nodesize, GFP_KERNEL);
+	tmp_buf = kmalloc(left_root->nodesize, GFP_KERNEL | __GFP_NOWARN);
 	if (!tmp_buf) {
-		ret = -ENOMEM;
-		goto out;
+		tmp_buf = vmalloc(left_root->nodesize);
+		if (!tmp_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	left_path->search_commit_root = 1;
@@ -5565,7 +5569,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 out:
 	btrfs_free_path(left_path);
 	btrfs_free_path(right_path);
-	kfree(tmp_buf);
+	kvfree(tmp_buf);
 	return ret;
 }
 
-- 
2.7.1

