From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: fix memory leak in resolver code
Date: Fri, 16 Mar 2012 13:57:20 +0200
Message-ID: <1331899040-3503-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

init_ipath() allocates btrfs_data_container which is never freed.  Free
it in free_ipath() and nuke the comment for init_data_container() - we
can safely free it with kfree().

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/backref.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 98f6bf10..b4b3522 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1338,12 +1338,6 @@ int paths_from_inode(u64 inum, struct inode_fs_paths *ipath)
 				inode_to_path, ipath);
 }
 
-/*
- * allocates space to return multiple file system paths for an inode.
- * total_bytes to allocate are passed, note that space usable for actual path
- * information will be total_bytes - sizeof(struct inode_fs_paths).
- * the returned pointer must be freed with free_ipath() in the end.
- */
 struct btrfs_data_container *init_data_container(u32 total_bytes)
 {
 	struct btrfs_data_container *data;
@@ -1399,5 +1393,6 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 
 void free_ipath(struct inode_fs_paths *ipath)
 {
+	kfree(ipath->fspath);
 	kfree(ipath);
 }
-- 
1.7.9.1

