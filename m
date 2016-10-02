Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50487 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751438AbcJBNZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:25 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNE30009086
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:24 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25t9p8kke4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:24 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:23 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 04/19] Btrfs: Remove extent_io_tree's track_uptodate member
Date: Sun,  2 Oct 2016 18:54:13 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-5-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We now track block uptodate status using a page's PG_Uptodate
flag. Hence this commit removes the now unused
extent_io_tree->track_uptodate member.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c   | 1 -
 fs/btrfs/extent_io.h | 1 -
 fs/btrfs/inode.c     | 2 --
 3 files changed, 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 03ac601..9ff48a7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2085,7 +2085,6 @@ int btrfs_init_eb_info(struct btrfs_fs_info *fs_info)
 
 	eb_info->fs_info = fs_info;
 	extent_io_tree_init(&eb_info->io_tree, eb_info);
-	eb_info->io_tree.track_uptodate = 0;
 	eb_info->io_tree.ops = &btree_extent_io_ops;
 	extent_io_tree_init(&eb_info->io_failure_tree, eb_info);
 	INIT_RADIX_TREE(&eb_info->buffer_radix, GFP_ATOMIC);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 922f4c1..9aa22f9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -102,7 +102,6 @@ struct extent_io_tree {
 	struct rb_root state;
 	void *private_data;
 	u64 dirty_bytes;
-	int track_uptodate;
 	spinlock_t lock;
 	const struct extent_io_ops *ops;
 };
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 652d01d..ac4a7c0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9306,8 +9306,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	extent_map_tree_init(&ei->extent_tree);
 	extent_io_tree_init(&ei->io_tree, inode);
 	extent_io_tree_init(&ei->io_failure_tree, inode);
-	ei->io_tree.track_uptodate = 1;
-	ei->io_failure_tree.track_uptodate = 1;
 	atomic_set(&ei->sync_writers, 0);
 	mutex_init(&ei->log_mutex);
 	mutex_init(&ei->delalloc_mutex);
-- 
2.5.5

