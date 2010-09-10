From: Frank Morales II <altf2o@gmail.com>
Subject: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for using
 uninitialized variable
Date: Fri, 10 Sep 2010 07:42:04 -0700
Message-ID: <1284129724.23418.27.camel@ubuntu1004pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: chris.mason@oracle.com, josef@redhat.com, zheng.yan@oracle.com,
	jens.axboe@oracle.com, tj@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From 1c304defc543738f82ccb18fe10b558dd2098d74 Mon Sep 17 00:00:00 2001
From: Frank Morales II <altf2o@gmail.com>
Date: Fri, 10 Sep 2010 07:34:23 -0700
Subject: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for using uninitialized variable

In the function tree_search, the variable prev was used without first
being initialized, causing compiler warning messages. Initializing
prev to NULL resolved the issue.

Kernal patched against: 2.6.36-rc3 (df423dc7)

Signed-off-by: Frank Morales II <altf2o@gmail.com>
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
1.7.0.4
