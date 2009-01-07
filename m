From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs: check inode allocaton earlier in btrfs_fill_super
Date: Wed, 07 Jan 2009 14:56:48 +0800
Message-ID: <49645230.9050403@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Just after it's allocation.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/btrfs/super.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b4c101d..4c31c4f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -322,6 +322,11 @@ static int btrfs_fill_super(struct super_block *sb,
 	disk_super = &tree_root->fs_info->super_copy;
 	inode = btrfs_iget_locked(sb, BTRFS_FIRST_FREE_OBJECTID,
 				  tree_root->fs_info->fs_root);
+	if (!inode) {
+		err = -ENOMEM;
+		goto fail_close;
+	}
+
 	bi = BTRFS_I(inode);
 	bi->location.objectid = inode->i_ino;
 	bi->location.offset = 0;
@@ -329,10 +334,6 @@ static int btrfs_fill_super(struct super_block *sb,
 
 	btrfs_set_key_type(&bi->location, BTRFS_INODE_ITEM_KEY);
 
-	if (!inode) {
-		err = -ENOMEM;
-		goto fail_close;
-	}
 	if (inode->i_state & I_NEW) {
 		btrfs_read_locked_inode(inode);
 		unlock_new_inode(inode);
-- 
1.6.0.6


