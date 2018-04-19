Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751010AbeDSHqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:46:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52962ADCC
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 07:46:43 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/6] btrfs: Remove btrfs_wait_and_free_delalloc_work
Date: Thu, 19 Apr 2018 10:46:39 +0300
Message-Id: <1524123999-4220-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1524123999-4220-1-git-send-email-nborisov@suse.com>
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is called from only 1 place and is effectively a wrapper
over wait_completion/kfree. It doesn't really bring any value having
those two calls in a separate function. Just open code it and remove it.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 1 -
 fs/btrfs/inode.c | 9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7526d31f80a4..c6239068117c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3173,7 +3173,6 @@ struct btrfs_delalloc_work {
 
 struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 						    int delay_iput);
-void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
 
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b4158c2b6f3e..a5986402b172 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10018,12 +10018,6 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 	return work;
 }
 
-void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work)
-{
-	wait_for_completion(&work->completion);
-	kfree(work);
-}
-
 /*
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
@@ -10080,7 +10074,8 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 out:
 	list_for_each_entry_safe(work, next, &works, list) {
 		list_del_init(&work->list);
-		btrfs_wait_and_free_delalloc_work(work);
+		wait_for_completion(&work->completion);
+		kfree(work);
 	}
 
 	if (!list_empty(&splice)) {
-- 
2.7.4

