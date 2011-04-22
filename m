From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH v2] Btrfs: check return value of kmalloc()
Date: Fri, 22 Apr 2011 11:35:52 +0900
Message-ID: <201104220235.AA00016@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The check on the return value of kmalloc() is added to some places.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
V1->V2: adding check code to relocate_one_extent() for the readability,
        which is suggested by David Sterba.

 fs/btrfs/extent-tree.c |    4 ++++
 fs/btrfs/inode.c       |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31f33ba..cd52f7f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8059,6 +8059,10 @@ static noinline int relocate_one_extent(struct btrfs_root *extent_root,
 				u64 group_start = group->key.objectid;
 				new_extents = kmalloc(sizeof(*new_extents),
 						      GFP_NOFS);
+				if (!new_extents) {
+					ret = -ENOMEM;
+					goto out;
+				}
 				nr_extents = 1;
 				ret = get_new_locations(reloc_inode,
 							extent_key,
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

