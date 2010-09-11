From: Jean Sacren <sakiwit@gmail.com>
Subject: [PATCH 1/1] btrfs: Fix warning: 'prev' may be used uninitialized
 in this function
Date: Sat, 11 Sep 2010 00:10:23 -0600
Message-ID: <20100911061023.GA18545@mail.gmail.com>
References: <20100911060848.GA18516@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux BTRFS Filesystem Discussion <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100911060848.GA18516@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

warning: 'prev' may be used uninitialized in this function

Initialize the variable 'prev' to NULL so that gcc doesn't complain.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 fs/btrfs/ordered-data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e56c72b..fad2616 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -141,7 +141,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 					  u64 file_offset)
 {
 	struct rb_root *root = &tree->tree;
-	struct rb_node *prev;
+	struct rb_node *prev = NULL;
 	struct rb_node *ret;
 	struct btrfs_ordered_extent *entry;
 
-- 
1.7.1
