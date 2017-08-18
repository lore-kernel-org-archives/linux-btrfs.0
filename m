Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51643 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdHRWRN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:17:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 6/7] Btrfs: remove BUG_ON in __add_tree_block
Date: Fri, 18 Aug 2017 15:15:23 -0600
Message-Id: <20170818211524.31325-7-bo.li.liu@oracle.com>
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BUG_ON() can be triggered when the caller is processing an invalid
extent inline ref, e.g.

a shared data ref is offered instead of a extent data ref, such that
it tries to find a non-exist tree block and then btrfs_search_slot
returns 1 for no such item.

This replaces the BUG_ON() with a WARN() followed by calling
btrfs_print_leaf() to show more details about what's going on and
returning -EINVAL to upper callers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 53fc798..71d38dd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -32,6 +32,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "qgroup.h"
+#include "print-tree.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3485,7 +3486,16 @@ static int __add_tree_block(struct reloc_control *rc,
 			goto again;
 		}
 	}
-	BUG_ON(ret);
+	if (ret) {
+		ASSERT(ret == 1);
+		btrfs_print_leaf(rc->extent_root->fs_info, path->nodes[0]);
+		btrfs_err(fs_info,
+	     "tree block extent item (%llu) is not found in extent tree",
+		     bytenr);
+		WARN_ON(1);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = add_tree_block(rc, &key, path, blocks);
 out:
-- 
2.9.4

