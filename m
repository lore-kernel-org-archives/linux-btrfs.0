From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: fix missing break in switch phrase
Date: Wed, 26 Jan 2011 14:22:33 +0800
Message-ID: <4D3FBDA9.2060005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


There is a missing break in switch, fix it.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/print-tree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 0d126be..fb2605d 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -260,6 +260,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 #else
 			BUG();
 #endif
+			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
 					    struct btrfs_block_group_item);
-- 
1.6.5.2
