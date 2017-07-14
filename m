Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751003AbdGNSb2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 14:31:28 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 24885AAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 18:31:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: get fs_info from eb in btrfs_print_tree, remove argument
Date: Fri, 14 Jul 2017 20:30:13 +0200
Message-Id: <435a41686c772bc35d6c63e451a3d826fa9f4b9a.1500056930.git.dsterba@suse.com>
In-Reply-To: <cover.1500056930.git.dsterba@suse.com>
References: <cover.1500056930.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/print-tree.c | 5 +++--
 fs/btrfs/print-tree.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 569393ffd0fd..3823a6a64ded 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -319,8 +319,9 @@ void btrfs_print_leaf(struct extent_buffer *l)
 	}
 }
 
-void btrfs_print_tree(struct btrfs_fs_info *fs_info, struct extent_buffer *c)
+void btrfs_print_tree(struct extent_buffer *c)
 {
+	struct btrfs_fs_info *fs_info = c->fs_info;
 	int i; u32 nr;
 	struct btrfs_key key;
 	int level;
@@ -360,7 +361,7 @@ void btrfs_print_tree(struct btrfs_fs_info *fs_info, struct extent_buffer *c)
 		if (btrfs_header_level(next) !=
 		       level - 1)
 			BUG();
-		btrfs_print_tree(fs_info, next);
+		btrfs_print_tree(next);
 		free_extent_buffer(next);
 	}
 }
diff --git a/fs/btrfs/print-tree.h b/fs/btrfs/print-tree.h
index 689a52ee0cd1..3afd508ed8c5 100644
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -19,5 +19,5 @@
 #ifndef __PRINT_TREE_
 #define __PRINT_TREE_
 void btrfs_print_leaf(struct extent_buffer *l);
-void btrfs_print_tree(struct btrfs_fs_info *fs_info, struct extent_buffer *c);
+void btrfs_print_tree(struct extent_buffer *c);
 #endif
-- 
2.13.0

