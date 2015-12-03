Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbbLCQ6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:58:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 67759ADD8
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:58:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/12] btrfs: remove wait from struct btrfs_delalloc_work
Date: Thu,  3 Dec 2015 17:56:29 +0100
Message-Id: <3042460136bee7bf48860f16a391e6d75f2d0d5c.1449161602.git.dsterba@suse.com>
In-Reply-To: <cover.1449161602.git.dsterba@suse.com>
References: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value is 0 and never changes, we can propagate the value, remove
wait and the implied dead code.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h |  1 -
 fs/btrfs/inode.c | 11 +++--------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cb540251f666..a61c53bce162 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3902,7 +3902,6 @@ void btrfs_extent_item_to_extent_map(struct inode *inode,
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
-	int wait;
 	int delay_iput;
 	struct completion completion;
 	struct list_head list;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9898b0d79c5a..15b29e879ffc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9440,14 +9440,10 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
 	delalloc_work = container_of(work, struct btrfs_delalloc_work,
 				     work);
 	inode = delalloc_work->inode;
-	if (delalloc_work->wait) {
-		btrfs_wait_ordered_range(inode, 0, (u64)-1);
-	} else {
+	filemap_flush(inode->i_mapping);
+	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+				&BTRFS_I(inode)->runtime_flags))
 		filemap_flush(inode->i_mapping);
-		if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-			     &BTRFS_I(inode)->runtime_flags))
-			filemap_flush(inode->i_mapping);
-	}
 
 	if (delalloc_work->delay_iput)
 		btrfs_add_delayed_iput(inode);
@@ -9468,7 +9464,6 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 	init_completion(&work->completion);
 	INIT_LIST_HEAD(&work->list);
 	work->inode = inode;
-	work->wait = 0;
 	work->delay_iput = delay_iput;
 	WARN_ON_ONCE(!inode);
 	btrfs_init_work(&work->work, btrfs_flush_delalloc_helper,
-- 
2.6.2

