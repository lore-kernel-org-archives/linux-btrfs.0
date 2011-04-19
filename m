From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of kmalloc()
Date: Tue, 19 Apr 2011 14:27:08 +0900
Message-ID: <201104190527.AA00014@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The check on the return value of kmalloc() in inode.c is added.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a4157cf..c718d27 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -953,6 +953,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 			 1, 0, NULL, GFP_NOFS);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
+		BUG_ON(!async_cow);
 		async_cow->inode = inode;
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
@@ -5001,6 +5002,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
 	tmp = kmalloc(inline_size, GFP_NOFS);
+	if (!tmp)
+		return -ENOMEM;
 	ptr = btrfs_file_extent_inline_start(item);
 
 	read_extent_buffer(leaf, tmp, ptr, inline_size);

