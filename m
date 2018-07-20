Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731251AbeGTPS7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:18:59 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6CBB5AD96
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 14:30:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: remove unused member btrfs_root::name
Date: Fri, 20 Jul 2018 16:30:18 +0200
Message-Id: <fb437253306a61e96a2871706778ee6c365ba9b5.1532096607.git.dsterba@suse.com>
In-Reply-To: <cover.1532096607.git.dsterba@suse.com>
References: <cover.1532096607.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added in 58176a9604c ("Btrfs: Add per-root block accounting and sysfs
entries") in 2007, the roots had names exported in sysfs. The code
was commented out in 4df27c4d5cc1dda54ed ("Btrfs: change how subvolumes
are organized") and cleaned by 182608c8294b5fe9 ("btrfs: remove old
unused commented out code").

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 1 -
 fs/btrfs/disk-io.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9c638931b75e..4ca6c4e141ea 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1219,7 +1219,6 @@ struct btrfs_root {
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
 	struct btrfs_key defrag_max;
-	char *name;
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9b208ccf24fe..3830867e0225 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1154,7 +1154,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->highest_objectid = 0;
 	root->nr_delalloc_inodes = 0;
 	root->nr_ordered_extents = 0;
-	root->name = NULL;
 	root->inode_tree = RB_ROOT;
 	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
 	root->block_rsv = NULL;
@@ -3849,7 +3848,6 @@ static void free_fs_root(struct btrfs_root *root)
 	free_extent_buffer(root->commit_root);
 	kfree(root->free_ino_ctl);
 	kfree(root->free_ino_pinned);
-	kfree(root->name);
 	btrfs_put_fs_root(root);
 }
 
-- 
2.18.0

