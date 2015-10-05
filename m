Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50508 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbJEQos (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 12:44:48 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 5 Oct 2015 22:14:46 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 483091258018
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2015 22:14:22 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t95GiYG28126930
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 22:14:36 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t95GiX9o011249
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 22:14:33 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: open_ctree: Fix possible memory leak
Date: Mon,  5 Oct 2015 22:14:25 +0530
Message-Id: <1444063465-5641-2-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reading one of chunk or tree root tree's root node from disk, if the
root node does not have EXTENT_BUFFER_UPTODATE flag set, we fail to release
the memory used by the root node. Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index aa59871..807f685 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2842,6 +2842,8 @@ int open_ctree(struct super_block *sb,
 	    !extent_buffer_uptodate(chunk_root->node)) {
 		printk(KERN_ERR "BTRFS: failed to read chunk root on %s\n",
 		       sb->s_id);
+		if (!IS_ERR(chunk_root->node))
+			free_extent_buffer(chunk_root->node);
 		chunk_root->node = NULL;
 		goto fail_tree_roots;
 	}
@@ -2880,6 +2882,8 @@ retry_root_backup:
 	    !extent_buffer_uptodate(tree_root->node)) {
 		printk(KERN_WARNING "BTRFS: failed to read tree root on %s\n",
 		       sb->s_id);
+		if (!IS_ERR(tree_root->node))
+			free_extent_buffer(tree_root->node);
 		tree_root->node = NULL;
 		goto recovery_tree_root;
 	}
-- 
2.1.0

