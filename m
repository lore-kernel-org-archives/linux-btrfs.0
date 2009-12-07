From: Li Dongyang <jerry87905@gmail.com>
Subject: [PATCH] Btrfs: fix comipler warning with tree_search
Date: Mon, 7 Dec 2009 09:35:06 +0800
Message-ID: <200912070935.06900.jerry87905@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fix comipler warning with tree_search

Signed-off-by: Li Dongyang <Jerry87905@gmail.com>
---
 fs/btrfs/ordered-data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ab21c29..8877fa0 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -133,7 +133,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 					  u64 file_offset)
 {
 	struct rb_root *root = &tree->tree;
-	struct rb_node *prev;
+	struct rb_node *prev = NULL;
 	struct rb_node *ret;
 	struct btrfs_ordered_extent *entry;
 
-- 
1.6.5.3

