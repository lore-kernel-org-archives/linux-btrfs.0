From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: check root_key's offset instead
Date: Wed, 08 Jun 2011 17:46:13 +0800
Message-ID: <4DEF44E5.6020906@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we use reloc root to cow or copy a tree block, we do not set the block's
owner, instead we set its header's flag with BTRFS_HEADER_FLAG_RELOC.

So here we should check for root_key's offset.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5b9b6b6..0bda273 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6160,7 +6160,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			parent = path->nodes[level + 1]->start;
 		else
-			BUG_ON(root->root_key.objectid !=
+			BUG_ON(root->root_key.offset !=
 			       btrfs_header_owner(path->nodes[level + 1]));
 	}
 
-- 
1.6.5.2


