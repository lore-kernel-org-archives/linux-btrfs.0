Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32982 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdALOBL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:11 -0500
Received: by mail-lf0-f67.google.com with SMTP id k62so1945737lfg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:11 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 13/24] btrfs: Make btrfs_get_logged_extents take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:39 +0200
Message-Id: <1484229650-24554-14-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/ordered-data.c | 4 ++--
 fs/btrfs/ordered-data.h | 2 +-
 fs/btrfs/tree-log.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 041c3326d109..7ae350a64c77 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -432,7 +432,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 }
 
 /* Needs to either be called under a log transaction or the log_mutex */
-void btrfs_get_logged_extents(struct inode *inode,
+void btrfs_get_logged_extents(struct btrfs_inode *inode,
 			      struct list_head *logged_list,
 			      const loff_t start,
 			      const loff_t end)
@@ -442,7 +442,7 @@ void btrfs_get_logged_extents(struct inode *inode,
 	struct rb_node *n;
 	struct rb_node *prev;
 
-	tree = &BTRFS_I(inode)->ordered_tree;
+	tree = &inode->ordered_tree;
 	spin_lock_irq(&tree->lock);
 	n = __tree_search(&tree->tree, end, &prev);
 	if (!n)
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 5f2b0ca28705..b02b71d41d83 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -201,7 +201,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
 			       const u64 range_start, const u64 range_len);
 int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
 			      const u64 range_start, const u64 range_len);
-void btrfs_get_logged_extents(struct inode *inode,
+void btrfs_get_logged_extents(struct btrfs_inode *inode,
 			      struct list_head *logged_list,
 			      const loff_t start,
 			      const loff_t end);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 98b40e65d880..657c118aed63 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4192,7 +4192,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
-	btrfs_get_logged_extents(inode, logged_list, start, end);
+	btrfs_get_logged_extents(BTRFS_I(inode), logged_list, start, end);
 	/*
 	 * Some ordered extents started by fsync might have completed
 	 * before we could collect them into the list logged_list, which
-- 
2.7.4

