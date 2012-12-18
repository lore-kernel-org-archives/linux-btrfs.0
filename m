Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41459 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab2LRQkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 11:40:43 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id HjSh2bReR5ED0Xe0 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 09:40:41 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix panic when recovering tree log
Date: Tue, 18 Dec 2012 11:47:00 -0500
Message-ID: <1355849220-13962-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a BUG_ON(ret) that occured during tree log replay.  Ret was
-EAGAIN, so what I think happened is that we removed an extent that covered
a bitmap entry and an extent entry.  We remove the part from the bitmap and
return -EAGAIN and then search for the next piece we want to remove, which
happens to be an entire extent entry, so we just free the sucker and return.
The problem is ret is still set to -EAGAIN so we trip the BUG_ON().  The
user used btrfs-zero-log so I'm not 100% sure this is what happened so I've
added a WARN_ON() to catch the other possibility.  Thanks,

Reported-by: Jan Steffens <jan.steffens@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/free-space-cache.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 59ea2e4..0be7a87 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1862,11 +1862,13 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
-	int ret = 0;
+	int ret;
+	bool re_search = false;
 
 	spin_lock(&ctl->tree_lock);
 
 again:
+	ret = 0;
 	if (!bytes)
 		goto out_lock;
 
@@ -1879,17 +1881,17 @@ again:
 		info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
 					  1, 0);
 		if (!info) {
-			/* the tree logging code might be calling us before we
-			 * have fully loaded the free space rbtree for this
-			 * block group.  So it is possible the entry won't
-			 * be in the rbtree yet at all.  The caching code
-			 * will make sure not to put it in the rbtree if
-			 * the logging code has pinned it.
+			/*
+			 * If we found a partial bit of our free space in a
+			 * bitmap but then couldn't find the other part this may
+			 * be a problem, so WARN about it.
 			 */
+			WARN_ON(re_search);
 			goto out_lock;
 		}
 	}
 
+	re_search = false;
 	if (!info->bitmap) {
 		unlink_free_space(ctl, info);
 		if (offset == info->offset) {
@@ -1935,8 +1937,10 @@ again:
 	}
 
 	ret = remove_from_bitmap(ctl, info, &offset, &bytes);
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN) {
+		re_search = true;
 		goto again;
+	}
 	BUG_ON(ret); /* logic error */
 out_lock:
 	spin_unlock(&ctl->tree_lock);
-- 
1.7.7.6

