From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: use btrfs_ino to access inode number
Date: Tue, 31 May 2011 19:08:14 +0200
Message-ID: <1306861694-5785-1-git-send-email-dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

commit 4cb5300bc ("Btrfs: add mount -o auto_defrag") accesses inode
number directly while it should use the helper with the new inode
number allocator.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/file.c  |    2 +-
 fs/btrfs/ioctl.c |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3ba6d19..dd4cb3e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -144,7 +144,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	if (!defrag)
 		return -ENOMEM;
 
-	defrag->ino = inode->i_ino;
+	defrag->ino = btrfs_ino(inode);
 	defrag->transid = transid;
 	defrag->root = root->root_key.objectid;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 85e818c..1a7deca 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -707,16 +707,17 @@ static int find_new_extents(struct btrfs_root *root,
 	struct btrfs_file_extent_item *extent;
 	int type;
 	int ret;
+	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	min_key.objectid = inode->i_ino;
+	min_key.objectid = ino;
 	min_key.type = BTRFS_EXTENT_DATA_KEY;
 	min_key.offset = *off;
 
-	max_key.objectid = inode->i_ino;
+	max_key.objectid = ino;
 	max_key.type = (u8)-1;
 	max_key.offset = (u64)-1;
 
@@ -727,7 +728,7 @@ static int find_new_extents(struct btrfs_root *root,
 					   path, 0, newer_than);
 		if (ret != 0)
 			goto none;
-		if (min_key.objectid != inode->i_ino)
+		if (min_key.objectid != ino)
 			goto none;
 		if (min_key.type != BTRFS_EXTENT_DATA_KEY)
 			goto none;
-- 
1.7.5.2.353.g5df3e

