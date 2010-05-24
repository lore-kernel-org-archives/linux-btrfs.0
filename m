From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH]: Fix warning in tree_search()
Date: Mon, 24 May 2010 11:16:39 -0400
Message-ID: <20100524151136.6797.38612.sendpatchset@prarit.bos.redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	jbacik@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix uninitialized variable warning:

fs/btrfs/ordered-data.c: In function 'btrfs_dec_test_ordered_pending':
fs/btrfs/ordered-data.c:135: warning: 'prev' may be used uninitialized in this function

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a127c0e..7638f3c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -132,7 +132,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 					  u64 file_offset)
 {
 	struct rb_root *root = &tree->tree;
-	struct rb_node *prev;
+	struct rb_node *uninitialized_var(prev);
 	struct rb_node *ret;
 	struct btrfs_ordered_extent *entry;
 
