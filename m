Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45249 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab3BFVpF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 16:45:05 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 792757C0415
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Feb 2013 14:45:04 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id Z2bvnD0OUbmpoQSG (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 14:45:03 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: handle errors in compression submission path
Date: Wed, 6 Feb 2013 16:51:55 -0500
Message-ID: <1360187515-2302-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed we would deadlock if we aborted a transaction while doing
compressed io.  This is because we don't unlock our pages if something goes
horribly wrong.  To fix this we need to make sure that we call
extent_clear_unlock_delalloc in order to unlock all the pages.  If we have
to cow in the async submission thread we need to make sure to unlock our
locked_page as the cow error path will not unlock the locked page as it
depends on the caller to unlock that page.  With this patch we no longer
deadlock on the page lock when we have an aborted transaction.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5398883..44d95d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -608,7 +608,7 @@ static noinline int submit_compressed_extents(struct inode *inode,
 	if (list_empty(&async_cow->extents))
 		return 0;
 
-
+again:
 	while (!list_empty(&async_cow->extents)) {
 		async_extent = list_entry(async_cow->extents.next,
 					  struct async_extent, list);
@@ -648,6 +648,8 @@ retry:
 						  async_extent->ram_size - 1,
 						  btrfs_get_extent,
 						  WB_SYNC_ALL);
+			else if (ret)
+				unlock_page(async_cow->locked_page);
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -672,6 +674,7 @@ retry:
 
 		if (ret) {
 			int i;
+
 			for (i = 0; i < async_extent->nr_pages; i++) {
 				WARN_ON(async_extent->pages[i]->mapping);
 				page_cache_release(async_extent->pages[i]);
@@ -679,12 +682,10 @@ retry:
 			kfree(async_extent->pages);
 			async_extent->nr_pages = 0;
 			async_extent->pages = NULL;
-			unlock_extent(io_tree, async_extent->start,
-				      async_extent->start +
-				      async_extent->ram_size - 1);
+
 			if (ret == -ENOSPC)
 				goto retry;
-			goto out_free; /* JDM: Requeue? */
+			goto out_free;
 		}
 
 		/*
@@ -696,7 +697,8 @@ retry:
 					async_extent->ram_size - 1, 0);
 
 		em = alloc_extent_map();
-		BUG_ON(!em); /* -ENOMEM */
+		if (!em)
+			goto out_free_reserve;
 		em->start = async_extent->start;
 		em->len = async_extent->ram_size;
 		em->orig_start = em->start;
@@ -728,6 +730,9 @@ retry:
 						async_extent->ram_size - 1, 0);
 		}
 
+		if (ret)
+			goto out_free_reserve;
+
 		ret = btrfs_add_ordered_extent_compress(inode,
 						async_extent->start,
 						ins.objectid,
@@ -735,7 +740,8 @@ retry:
 						ins.offset,
 						BTRFS_ORDERED_COMPRESSED,
 						async_extent->compress_type);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			goto out_free_reserve;
 
 		/*
 		 * clear dirty, set writeback and unlock the pages.
@@ -756,18 +762,30 @@ retry:
 				    ins.objectid,
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages);
-
-		BUG_ON(ret); /* -ENOMEM */
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
+		if (ret)
+			goto out;
 		cond_resched();
 	}
 	ret = 0;
 out:
 	return ret;
+out_free_reserve:
+	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
 out_free:
+	extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
+				     async_extent->start,
+				     async_extent->start +
+				     async_extent->ram_size - 1,
+				     NULL, EXTENT_CLEAR_UNLOCK_PAGE |
+				     EXTENT_CLEAR_UNLOCK |
+				     EXTENT_CLEAR_DELALLOC |
+				     EXTENT_CLEAR_DIRTY |
+				     EXTENT_SET_WRITEBACK |
+				     EXTENT_END_WRITEBACK);
 	kfree(async_extent);
-	goto out;
+	goto again;
 }
 
 static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
-- 
1.7.7.6

