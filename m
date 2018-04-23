Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50893 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754152AbeDWHyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 03:54:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 27424AE0C
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 07:54:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/5] btrfs: Remove delayed_iput member from btrfs_delalloc_work
Date: Mon, 23 Apr 2018 10:54:16 +0300
Message-Id: <1524470057-21969-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1524470057-21969-1-git-send-email-nborisov@suse.com>
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When allocating a delalloc work we are always setting the delayed_iput
to 0. So remove the delay_iput member of btrfs_delalloc_work, as a
result also remove it as a parameter from btrfs_alloc_delalloc_work
since it's not used anymore.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h |  4 +---
 fs/btrfs/inode.c | 11 +++--------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1ac983270bb7..91f51a80334f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3165,14 +3165,12 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
-	int delay_iput;
 	struct completion completion;
 	struct list_head list;
 	struct btrfs_work work;
 };
 
-struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
-						    int delay_iput);
+struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode);
 
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 42a2590559df..9b8f2904ad55 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10158,15 +10158,11 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
 				&BTRFS_I(inode)->runtime_flags))
 		filemap_flush(inode->i_mapping);
 
-	if (delalloc_work->delay_iput)
-		btrfs_add_delayed_iput(inode);
-	else
-		iput(inode);
+	iput(inode);
 	complete(&delalloc_work->completion);
 }
 
-struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
-						    int delay_iput)
+struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode)
 {
 	struct btrfs_delalloc_work *work;
 
@@ -10177,7 +10173,6 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 	init_completion(&work->completion);
 	INIT_LIST_HEAD(&work->list);
 	work->inode = inode;
-	work->delay_iput = delay_iput;
 	WARN_ON_ONCE(!inode);
 	btrfs_init_work(&work->work, btrfs_flush_delalloc_helper,
 			btrfs_run_delalloc_work, NULL, NULL);
@@ -10217,7 +10212,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int nr)
 		}
 		spin_unlock(&root->delalloc_lock);
 
-		work = btrfs_alloc_delalloc_work(inode, 0);
+		work = btrfs_alloc_delalloc_work(inode);
 		if (!work) {
 			iput(inode);
 			ret = -ENOMEM;
-- 
2.7.4

