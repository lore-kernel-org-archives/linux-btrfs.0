Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:38434 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab2HCVFo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Aug 2012 17:05:44 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id LhsrhPvaK5GUKU3n (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 15:05:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use a slab for btrfs_dio_private
Date: Fri, 3 Aug 2012 17:10:47 -0400
Message-ID: <1344028247-3143-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is in the IO path, let's try to avoid latencies by having our own slab.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8a8f0d6..351dd3b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -75,6 +75,7 @@ struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_transaction_cachep;
 struct kmem_cache *btrfs_path_cachep;
 struct kmem_cache *btrfs_free_space_cachep;
+struct kmem_cache *btrfs_dip_cachep;
 
 #define S_SHIFT 12
 static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
@@ -6076,7 +6077,7 @@ failed:
 		      dip->logical_offset + dip->bytes - 1);
 	bio->bi_private = dip->private;
 
-	kfree(dip);
+	kmem_cache_free(btrfs_dip_cachep, dip);
 
 	/* If we had a csum failure make sure to clear the uptodate flag */
 	if (err)
@@ -6121,7 +6122,7 @@ out_test:
 out_done:
 	bio->bi_private = dip->private;
 
-	kfree(dip);
+	kmem_cache_free(btrfs_dip_cachep, dip);
 
 	/* If we had an error make sure to clear the uptodate flag */
 	if (err)
@@ -6344,7 +6345,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	dip = kmalloc(sizeof(*dip), GFP_NOFS);
+	dip = kmem_cache_alloc(btrfs_dip_cachep, GFP_NOFS);
 	if (!dip) {
 		ret = -ENOMEM;
 		goto free_ordered;
@@ -7062,6 +7063,8 @@ void btrfs_destroy_cachep(void)
 		kmem_cache_destroy(btrfs_path_cachep);
 	if (btrfs_free_space_cachep)
 		kmem_cache_destroy(btrfs_free_space_cachep);
+	if (btrfs_dip_cachep)
+		kmem_cache_destroy(btrfs_dip_cachep);
 }
 
 int btrfs_init_cachep(void)
@@ -7096,6 +7099,12 @@ int btrfs_init_cachep(void)
 	if (!btrfs_free_space_cachep)
 		goto fail;
 
+	btrfs_dip_cachep = kmem_cache_create("btrfs_dio_private_cache",
+			sizeof(struct btrfs_dio_private), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
+	if (!btrfs_dip_cachep)
+		goto fail;
+
 	return 0;
 fail:
 	btrfs_destroy_cachep();
-- 
1.7.7.6

