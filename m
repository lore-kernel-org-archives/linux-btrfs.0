Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31634 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348AbbBLOnz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 09:43:55 -0500
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id t1CEgDLR007470
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 06:43:54 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1sgtnr8bqh-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 06:43:54 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: abort the transaction if we fail to update the free space cache inode
Date: Thu, 12 Feb 2015 09:43:51 -0500
Message-ID: <1423752231-16864-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Our gluster boxes were hitting a problem where they'd run out of space when
updating the block group cache and therefore wouldn't be able to update the free
space inode.  This is a problem because this is how we invalidate the cache and
protect ourselves from errors further down the stack, so if this fails we have
to abort the transaction so we make sure we don't end up with stale free space
cache.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index eb30b90..071f515 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3211,6 +3211,8 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 		return 0;
 	}
 
+	if (trans->aborted)
+		return 0;
 again:
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
@@ -3246,6 +3248,20 @@ again:
 	 */
 	BTRFS_I(inode)->generation = 0;
 	ret = btrfs_update_inode(trans, root, inode);
+	if (ret) {
+		/*
+		 * So theoretically we could recover from this, simply set the
+		 * super cache generation to 0 so we know to invalidate the
+		 * cache, but then we'd have to keep track of the block groups
+		 * that fail this way so we know we _have_ to reset this cache
+		 * before the next commit or risk reading stale cache.  So to
+		 * limit our exposure to horrible edge cases lets just abort the
+		 * transaction, this only happens in really bad situations
+		 * anyway.
+		 */
+		btrfs_abort_transaction(trans, root, ret);
+		goto out_put;
+	}
 	WARN_ON(ret);
 
 	if (i_size_read(inode) > 0) {
-- 
1.8.3.1

