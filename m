From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: keep orphans for subvolume deletion
Date: Fri,  9 Dec 2011 10:42:56 +0100
Message-ID: <1323423776-12412-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since we have the free space caches, btrfs_orphan_cleanup also runs for
the tree_root. Unfortunately this also cleans up the orphans used to mark
subvol deletions in progress.
Currently if a subvol deletion gets interrupted twice by umount/mount, the
deletion will not be continued and the space permanently lost, though it
would be possible to write a tool to recover those lost subvol deletions.
This patch checks if the orphan belongs to a subvol (dead root) and skips
the deletion.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/inode.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c5ccec2..e30d38f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2158,6 +2158,38 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		if (ret && ret != -ESTALE)
 			goto out;
 
+		if (ret == -ESTALE && root == root->fs_info->tree_root) {
+			struct btrfs_root *dead_root;
+			struct btrfs_fs_info *fs_info = root->fs_info;
+			int is_dead_root = 0;
+
+			/*
+			 * this is an orphan in the tree root. Currently these
+			 * could come from 2 sources:
+			 *  a) a snapshot deletion in progress
+			 *  b) a free space cache inode
+			 * We need to distinguish those two, as the snapshot
+			 * orphan must not get deleted.
+			 * find_dead_roots already ran before us, so if this
+			 * is a snapshot deletion, we should find the root
+			 * in the dead_roots list
+			 */
+			spin_lock(&fs_info->trans_lock);
+			list_for_each_entry(dead_root, &fs_info->dead_roots,
+					    root_list) {
+				if (dead_root->root_key.objectid ==
+				    found_key.objectid) {
+					is_dead_root = 1;
+					break;
+				}
+			}
+			spin_unlock(&fs_info->trans_lock);
+			if (is_dead_root) {
+				/* prevent this orphan from being found again */
+				key.offset = found_key.objectid - 1;
+				continue;
+			}
+		}
 		/*
 		 * Inode is already gone but the orphan item is still there,
 		 * kill the orphan item.
-- 
1.7.3.4

