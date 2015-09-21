Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17678 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752966AbbIUNAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 09:00:52 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8LD0WkH002837
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 21:00:32 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Fix no space bug caused by removing bg
Date: Mon, 21 Sep 2015 20:59:13 +0800
Message-ID: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs in v4.3-rc1 failed many xfstests items with '-o nospace_cache'
mount option.

Failed cases are:
 btrfs/008,016,019,020,026,027,028,029,031,041,046,048,050,051,053,054,
 077,083,084,087,092,094
 generic/004,010,014,023,024,074,075,080,086,087,089,091,092,100,112,123,
 124,125,126,127,131,133,192,193,198,207,208,209,213,214,215,228,239,240,
 246,247,248,255,263,285,306,313,316,323

We can reproduce this bug with following simple command:
 TEST_DEV=/dev/vdh
 TEST_DIR=/mnt/tmp

 umount "$TEST_DEV" >/dev/null
 mkfs.btrfs -f "$TEST_DEV"
 mount "$TEST_DEV" "$TEST_DIR"

 umount "$TEST_DEV"
 mount "$TEST_DEV" "$TEST_DIR"

 cp /bin/bash $TEST_DIR

Result is:
 (omit previous commands)
 # cp /bin/bash $TEST_DIR
 cp: writing `/mnt/tmp/bash': No space left on device

By bisect, we can see it is triggered by patch titled:
 commit e44163e17796
 ("btrfs: explictly delete unused block groups in close_ctree and ro-remount")

But the wrong code is not in above patch, btrfs delete all chunks
if no data in filesystem, and above patch just make it obviously.

Detail reason:
 1: mkfs a blank filesystem, or delete everything in filesystem
 2: umount fs
    (current code will delete all data chunks)
 3: mount fs
    Because no any data chunks, data's space_cache have no chance
    to init, it means: space_info->total_bytes == 0, and
    space_info->full == 1.
 4: do some write
    Current code will ignore chunk allocate because space_info->full,
    and return -ENOSPC.

Fix:
 Don't auto-delete last blockgroup for a raid type.
 If we delete all blockgroup for a raidtype, it not only cause above bug,
 but also may change filesystem to all-single in some case.

Test:
 Test by above script, and confirmed the logic by debug output.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5411f0a..35cf7eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10012,7 +10012,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 					       bg_list);
 		space_info = block_group->space_info;
 		list_del_init(&block_group->bg_list);
-		if (ret || btrfs_mixed_space_info(space_info)) {
+		if (ret || btrfs_mixed_space_info(space_info) ||
+		    block_group->list.next == block_group->list.prev) {
 			btrfs_put_block_group(block_group);
 			continue;
 		}
-- 
1.8.5.1

