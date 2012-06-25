Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21038 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2FYLPc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 07:15:32 -0400
Date: Mon, 25 Jun 2012 14:15:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] Btrfs: fix error handling in __add_reloc_root()
Message-ID: <20120625111048.GA10393@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FE473F6.5000109@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We dereferenced "node" in the error message after freeing it.  Also
btrfs_panic() can return so we should return an error code instead of
continuing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: in the first version I just deleted the kfree().

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 790f492..4da0865 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1239,10 +1239,11 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 			      node->bytenr, &node->rb_node);
 	spin_unlock(&rc->reloc_root_tree.lock);
 	if (rb_node) {
-		kfree(node);
 		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
 			    "for start=%llu while inserting into relocation "
 			    "tree\n", node->bytenr);
+		kfree(node);
+		return -EEXIST;
 	}
 
 	list_add_tail(&root->root_list, &rc->reloc_roots);
