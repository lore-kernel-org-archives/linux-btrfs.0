Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55931 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3GWVJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 17:09:05 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2C7D47C06A0
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 15:09:05 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id 01FxjiBkOH2LTZw9 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 15:09:04 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup reloc roots properly on error
Date: Tue, 23 Jul 2013 17:09:02 -0400
Message-ID: <1374613742-19983-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was hitting the BUG_ON() at the end of merge_reloc_roots() because we were
aborting the transaction at some point previously and then getting an error when
we tried to drop the reloc root.  I fixed btrfs_drop_snapshot to re-add us to
the dead roots list if we failed, but this isn't the right thing to do for reloc
roots since it uses root->root_list for it's own stuff in order to know what
needs to be cleaned up.  So fix btrfs_drop_snapshot to only do the re-add if we
aren't dropping for reloc, and handle errors from merge_reloc_root() by dropping
the reloc root we are processing since it won't be on the list of roots to
cleanup.  With this patch my reproducer no longer panics.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/relocation.c  |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ca02d3c..e868c35 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7696,7 +7696,7 @@ out:
 	 * don't have it in the radix (like when we recover after a power fail
 	 * or unmount) so we don't leak memory.
 	 */
-	if (root_dropped == false)
+	if (!for_reloc && root_dropped == false)
 		btrfs_add_dead_root(root);
 	if (err)
 		btrfs_std_error(root->fs_info, err);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 295a611..5a23d87 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2314,8 +2314,13 @@ again:
 			BUG_ON(root->reloc_root != reloc_root);
 
 			ret = merge_reloc_root(rc, root);
-			if (ret)
+			if (ret) {
+				__update_reloc_root(reloc_root, 1);
+				free_extent_buffer(reloc_root->node);
+				free_extent_buffer(reloc_root->commit_root);
+				kfree(reloc_root);
 				goto out;
+			}
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-- 
1.7.7.6

