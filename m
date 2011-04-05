From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't kzalloc the ordered extents
Date: Tue,  5 Apr 2011 19:20:49 -0400
Message-ID: <1302045649-1580-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We initialize almost all of the fields when we allocate an ordered extent, so
use kmalloc instead of kzalloc and just initialize the other fields that we
don't already initialize yet.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ordered-data.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 083a554..2edc837 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -179,7 +179,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	struct btrfs_ordered_extent *entry;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	entry = kzalloc(sizeof(*entry), GFP_NOFS);
+	entry = kmalloc(sizeof(*entry), GFP_NOFS);
 	if (!entry)
 		return -ENOMEM;
 
@@ -190,6 +190,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->bytes_left = len;
 	entry->inode = inode;
 	entry->compress_type = compress_type;
+	entry->flags = 0;
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -201,6 +202,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	init_waitqueue_head(&entry->wait);
 	INIT_LIST_HEAD(&entry->list);
 	INIT_LIST_HEAD(&entry->root_extent_list);
+	RB_CLEAR_NODE(&entry->rb_node);
 
 	spin_lock(&tree->lock);
 	node = tree_insert(&tree->tree, file_offset,
-- 
1.7.2.3

