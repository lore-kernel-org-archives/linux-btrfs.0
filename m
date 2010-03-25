From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 05/18] btrfs: Take num_copies out of loop for btree_read_extent_buffer_pages()
Date: Thu, 25 Mar 2010 20:30:17 +0800
Message-ID: <4BAB5759.7010903@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

num_copies's value is not changed in this function,
and it is not necessary to calculate its value multi-times.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 11d0ad3..79d9196 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -301,7 +301,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 {
 	struct extent_io_tree *io_tree;
 	int ret;
-	int num_copies = 0;
+	int num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+					  eb->start, eb->len);
 	int mirror_num = 0;
 
 	io_tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
@@ -312,8 +313,6 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 		    !verify_parent_transid(io_tree, eb, parent_transid))
 			return ret;
 
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      eb->start, eb->len);
 		if (num_copies == 1)
 			return ret;
 
-- 
1.6.5.2


