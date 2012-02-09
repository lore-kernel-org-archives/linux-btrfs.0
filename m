From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix trim 0 bytes after a device delete
Date: Thu, 9 Feb 2012 18:17:41 +0800
Message-ID: <1328782661-2603-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <lutz.euler@freenet.de>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a bug of btrfs's trim, that is we will trim 0 bytes
after a device delete.

The reproducer:

$ mkfs.btrfs disk1
$ mkfs.btrfs disk2
$ mount disk1 /mnt
$ fstrim -v /mnt
$ btrfs device add disk2 /mnt
$ btrfs device del disk1 /mnt
$ fstrim -v /mnt

This is because after we delete the device, the block group may start from
a non-zero place, which will confuse trim to discard nothing.

Reported-by: Lutz Euler <lutz.euler@freenet.de>
Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 77ea23c..b6e2c92 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7653,9 +7653,16 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
+	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	int ret = 0;
 
-	cache = btrfs_lookup_block_group(fs_info, range->start);
+	/*
+	 * try to trim all FS space, our block group may start from non-zero.
+	 */
+	if (range->len == total_bytes)
+		cache = btrfs_lookup_first_block_group(fs_info, range->start);
+	else
+		cache = btrfs_lookup_block_group(fs_info, range->start);
 
 	while (cache) {
 		if (cache->key.objectid >= (range->start + range->len)) {
-- 
1.6.5.2

