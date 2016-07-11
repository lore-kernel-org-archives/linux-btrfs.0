Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38803 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749AbcGKGnS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 02:43:18 -0400
Received: by mail-wm0-f41.google.com with SMTP id o80so36375435wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jul 2016 23:43:17 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <kernel@kyup.com>
Subject: [RESEND PATCH] btrfs: Handle uninitialised inode eviction
Date: Mon, 11 Jul 2016 09:43:09 +0300
Message-Id: <1468219389-28736-1-git-send-email-kernel@kyup.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The code flow in btrfs_new_inode allows for btrfs_evict_inode to be
called with not fully initialised inode (e.g. ->root member not
being set). This can happen when btrfs_set_inode_index in
btrfs_new_inode fails, which in turn would call iput for the newly
allocated inode. This in turn leads to vfs calling into btrfs_evict_inode.
This leads to null pointer dereference. To handle this situation check whether
the passed inode has root set and just free it in case it doesn't.

Signed-off-by: Nikolay Borisov <kernel@kyup.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Hello, 

I belive this is fixes the issue reported in 
http://thread.gmane.org/gmane.comp.file-systems.btrfs/57809

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4421954720b8..b51723811d01 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5159,11 +5159,18 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv, *global_rsv;
 	int steal_from_global = 0;
-	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	u64 min_size;
 	int ret;
 
 	trace_btrfs_inode_evict(inode);
 
+	if (!root) {
+		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+		return;
+	}
+
+	min_size = btrfs_calc_trunc_metadata_size(root, 1);
+
 	evict_inode_truncate_pages(inode);
 
 	if (inode->i_nlink &&
-- 
2.5.0

