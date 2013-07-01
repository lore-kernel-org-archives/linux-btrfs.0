Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:56918 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3GAUMa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 16:12:30 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A00089A040C
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 14:12:29 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id tfgCmNCQpWxNKlwX (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Jul 2013 14:12:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: only do the tree_mod_log_free_eb if this is our last ref
Date: Mon, 1 Jul 2013 16:12:27 -0400
Message-ID: <1372709547-29418-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is another bug in the tree mod log stuff in that we're calling
tree_mod_log_free_eb every single time a block is cow'ed.  The problem with this
is that if this block is shared by multiple snapshots we will call this multiple
times per block, so if we go to rewind the mod log for this block we'll BUG_ON()
in __tree_mod_log_rewind because we try to rewind a free twice.  We only want to
call tree_mod_log_free_eb if we are actually freeing the block.  With this patch
I no longer hit the panic in __tree_mod_log_rewind.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 32e30ad..127e1fd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1093,7 +1093,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
-		tree_mod_log_free_eb(root->fs_info, buf);
+		if (last_ref)
+			tree_mod_log_free_eb(root->fs_info, buf);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
 				      last_ref);
 	}
-- 
1.7.7.6

