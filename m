Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33916 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdAQWiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:38:51 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so9420481wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:38:45 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 13/24] btrfs: Make btrfs_get_logged_extents take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:39 +0200
Message-Id: <1484692310-3987-14-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
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
index 9f2c42016825..0e061f91055e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4193,7 +4193,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
-	btrfs_get_logged_extents(inode, logged_list, start, end);
+	btrfs_get_logged_extents(BTRFS_I(inode), logged_list, start, end);
 	/*
 	 * Some ordered extents started by fsync might have completed
 	 * before we could collect them into the list logged_list, which
-- 
2.7.4

