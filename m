Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65020 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3J3Vmv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 17:42:51 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so1974345pbc.36
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 14:42:51 -0700 (PDT)
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: Replace multiple atomic_inc() with atomic_add()
Date: Thu, 31 Oct 2013 03:12:42 +0530
Message-Id: <1383169362-25993-1-git-send-email-rashika.kheria@gmail.com>
In-Reply-To: <20131030212314.GA25069@gmail.com>
References: <20131030212314.GA25069@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch replaces multiple atomic_inc() with atomic_add() in
delayed-inode.c to reduce source code and have few instructions
for compilation.

Reviewed-by: Zach Brown <zab@redhat.com>
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision-
Space in comment

 fs/btrfs/delayed-inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index cbd9523..504a9b5 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -108,8 +108,8 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 			return node;
 		}
 		btrfs_inode->delayed_node = node;
-		atomic_inc(&node->refs);	/* can be accessed */
-		atomic_inc(&node->refs);	/* cached in the inode */
+		/* can be accessed and cached in the inode */
+		atomic_add(2, &node->refs);
 		spin_unlock(&root->inode_lock);
 		return node;
 	}
@@ -138,8 +138,8 @@ again:
 		return ERR_PTR(-ENOMEM);
 	btrfs_init_delayed_node(node, root, ino);
 
-	atomic_inc(&node->refs);	/* cached in the btrfs inode */
-	atomic_inc(&node->refs);	/* can be accessed */
+	/* cached in the btrfs inode and can be accessed */
+	atomic_add(2, &node->refs);
 
 	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
 	if (ret) {
-- 
1.7.9.5

