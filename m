Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46095 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753569AbeEORwN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:52:13 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6] Btrfs: grab write lock directly if write_lock_level is the max level
Date: Wed, 16 May 2018 01:52:07 +0800
Message-Id: <1526406728-109055-6-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of (cow && (p->keep_locks || p->lowest_level)), write_lock_level
is the max level, and we should grab write lock of root node from the very
beginning.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cf34eca41d4e..f7c3f581f647 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2633,20 +2633,23 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 		goto out;
 	}
 
-	/*
-	 * we don't know the level of the root node until we actually
-	 * have it read locked
-	 */
-	b = btrfs_read_lock_root_node(root);
-	level = btrfs_header_level(b);
-	if (level > write_lock_level)
-		goto out;
+	if (write_lock_level < BTRFS_MAX_LEVEL) {
+		/*
+		 * we don't know the level of the root node until we actually
+		 * have it read locked
+		 */
+		b = btrfs_read_lock_root_node(root);
+		level = btrfs_header_level(b);
+		if (level > write_lock_level)
+			goto out;
+
+		/*
+		 * whoops, must trade for write lock
+		 */
+		btrfs_tree_read_unlock(b);
+		free_extent_buffer(b);
+	}
 
-	/*
-	 * whoops, must trade for write lock
-	 */
-	btrfs_tree_read_unlock(b);
-	free_extent_buffer(b);
 	b = btrfs_lock_root_node(root);
 	root_lock = BTRFS_WRITE_LOCK;
 	/*
-- 
1.8.3.1

