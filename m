From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: [PATCH] Log parent inode if it is newer than the last commit
Date: Sat, 6 Nov 2010 20:03:05 +0900
Message-ID: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


In the file sync path, file's parent inode is logged if it is newer than the last
commit. This patch checks also the last_trans field as well as generation.

As btrfs_log_inode updates the logged_trans field of parent dir's inode, tree-log
lookup operations are suppressed upon unlink.

The patch is for the latest btrfs-unstable tree.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

---
 fs/btrfs/tree-log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a29f193..db63ae4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3007,7 +3007,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
                if (root != BTRFS_I(inode)->root)
                        break;
 
-               if (BTRFS_I(inode)->generation >
+               if (max(BTRFS_I(inode)->generation, BTRFS_I(inode)->last_trans) >
                    root->fs_info->last_trans_committed) {
                        ret = btrfs_log_inode(trans, root, inode, inode_only);
                        if (ret)
-- 
1.7.2.3
