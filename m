From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH v2] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Sat, 20 Aug 2011 10:17:47 +0800
Message-ID: <1313806667-30495-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <torvalds@linux-foundation.org>, <mingo@kernel.org>,
	<jwboyer@gmail.com>, <josef@redhat.com>,
	<linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>,
	<dave@jikos.cz>
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When doing div operation of u64 type, we need to be careful and use do_div
to avoid compile ERROR on 32bit box:

"ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
make[1]: *** [__modpost] Error 1

v1->v2:
- fix stupid do_div() with type "signed integer".

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..e43e4f1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6735,9 +6735,10 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_device *device;
 	u64 min_free;
+	u32 dev_min = 1;
+	u32 dev_nr = 0;
+	u32 dup = 2;
 	int index;
-	int dev_nr = 0;
-	int dev_min = 1;
 	int full = 0;
 	int ret = 0;
 
@@ -6796,14 +6797,14 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	index = get_block_group_index(block_group);
 	if (index == 0) {
 		dev_min = 4;
-		min_free /= 2;
+		do_div(min_free, dup);
 	} else if (index == 1) {
 		dev_min = 2;
 	} else if (index == 2) {
-		min_free *= 2;
+		min_free *= dup;
 	} else if (index == 3) {
 		dev_min = fs_devices->rw_devices;
-		min_free /= dev_min;
+		do_div(min_free, dev_min);
 	}
 
 	mutex_lock(&root->fs_info->chunk_mutex);
-- 
1.6.5.2

