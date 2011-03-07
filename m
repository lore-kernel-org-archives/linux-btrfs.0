From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: fix memory leak of empty filesystem after balance
Date: Mon, 07 Mar 2011 10:13:33 +0800
Message-ID: <4D743F4D.3090500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


After Josef's patch(commit 3c14874acc71180553fb5aba528e3cf57c5b958b),
btrfs will exclude super bytes when reading block groups(by marking a extent
state UPTODATE).  However, these bytes do not get freed while balance remove
unused block groups, and we won't process those removed ones any more, when
we do umount and unload the btrfs module,  btrfs hits a memory leak.

This patch add the missing free operation.

Reproduce steps:
$ mkfs.btrfs disk
$ mount disk /mnt/btrfs -o loop
$ btrfs filesystem balance /mnt/btrfs
$ umount /mnt/btrfs
$ rmmod btrfs

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 08525ee..a1af67a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8611,6 +8611,12 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
+	/*
+	 * Free the reserved super bytes from this block group before
+	 * remove it.
+	 */
+	free_excluded_extents(root, block_group);
+
 	memcpy(&key, &block_group->key, sizeof(key));
 	if (block_group->flags & (BTRFS_BLOCK_GROUP_DUP |
 				  BTRFS_BLOCK_GROUP_RAID1 |
-- 
1.6.5.2

