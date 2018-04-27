Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757487AbeD0JWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 05:22:12 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 092FDAC79
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 09:22:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/5] btrfs: Unexport btrfs_alloc_delalloc_work
Date: Fri, 27 Apr 2018 12:21:50 +0300
Message-Id: <1524820914-30864-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1524820914-30864-1-git-send-email-nborisov@suse.com>
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's used only in inode.c so makes no sense to have it exported. Also
move the definition of btrfs_delalloc_work to inode.c since it's used
only this file.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 9 ---------
 fs/btrfs/inode.c | 8 ++++++++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 789c7da2721c..5b7080d2fbff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3167,15 +3167,6 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     struct extent_map *em);
 
 /* inode.c */
-struct btrfs_delalloc_work {
-	struct inode *inode;
-	struct completion completion;
-	struct list_head list;
-	struct btrfs_work work;
-};
-
-struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode);
-
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start,
 		u64 len, int create);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9b8f2904ad55..078e02c21825 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10145,6 +10145,13 @@ static int btrfs_rename2(struct inode *old_dir, struct dentry *old_dentry,
 	return btrfs_rename(old_dir, old_dentry, new_dir, new_dentry, flags);
 }
 
+struct btrfs_delalloc_work {
+	struct inode *inode;
+	struct completion completion;
+	struct list_head list;
+	struct btrfs_work work;
+};
+
 static void btrfs_run_delalloc_work(struct btrfs_work *work)
 {
 	struct btrfs_delalloc_work *delalloc_work;
@@ -10162,6 +10169,7 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
 	complete(&delalloc_work->completion);
 }
 
+static
 struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode)
 {
 	struct btrfs_delalloc_work *work;
-- 
2.7.4

