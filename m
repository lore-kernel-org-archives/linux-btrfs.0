From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix wrong extent buffer size when reading tree
 block
Date: Tue, 13 Jul 2010 17:18:04 +0800
Message-ID: <4C3C2F4C.6030402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

the root extent buffer of a tree may not be a leaf, so we must get the right
size by its level when reading it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 debug-tree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index 40628e0..cf637ab 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -208,7 +208,9 @@ again:
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
 			buf = read_tree_block(tree_root_scan,
 					      btrfs_root_bytenr(&ri),
-					      tree_root_scan->leafsize, 0);
+					      btrfs_level_size(tree_root_scan,
+							btrfs_root_level(&ri)),
+					      0);
 			switch(found_key.objectid) {
 			case BTRFS_ROOT_TREE_OBJECTID:
 				if (!skip)
-- 
1.7.0.1
