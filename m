From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix typo in fallocate to make it honor actual size
Date: Mon, 22 Nov 2010 13:50:32 -0500
Message-ID: <1290451832-7930-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a typo in __btrfs_prealloc_file_range() where we set the i_size to
actual_len/cur_offset, and then just set it to cur_offset again, and do the same
with btrfs_ordered_update_i_size().  This fixes it back to keeping i_size in a
local variable and then updating i_size properly.  Tested this with

xfs_io -F -f -c "falloc 0 1" -c "pwrite 0 1" foo

stat'ing foo gives us a size of 1 instead of 4096 like it was.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bdc0a9e..d83f288 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6841,6 +6841,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 cur_offset = start;
+	u64 i_size;
 	int ret = 0;
 	bool own_trans = true;
 
@@ -6882,11 +6883,11 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		    (actual_len > inode->i_size) &&
 		    (cur_offset > inode->i_size)) {
 			if (cur_offset > actual_len)
-				i_size_write(inode, actual_len);
+				i_size = actual_len;
 			else
-				i_size_write(inode, cur_offset);
-			i_size_write(inode, cur_offset);
-			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
+				i_size = cur_offset;
+			i_size_write(inode, i_size);
+			btrfs_ordered_update_i_size(inode, i_size, NULL);
 		}
 
 		ret = btrfs_update_inode(trans, root, inode);
-- 
1.6.6.1

