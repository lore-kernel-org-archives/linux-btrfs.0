Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7775 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755326AbbI3LNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 07:13:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8UBCaLC031148
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 19:12:36 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs: Fix lost-data-profile caused by auto removing bg
Date: Wed, 30 Sep 2015 19:11:18 +0800
Message-ID: <aaa2dcf7018bd29459e20f0571ff490fe1abee51.1443611403.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce:
 (In integration-4.3 branch)

 TEST_DEV=(/dev/vdg /dev/vdh)
 TEST_DIR=/mnt/tmp

 umount "$TEST_DEV" >/dev/null
 mkfs.btrfs -f -d raid1 "${TEST_DEV[@]}"

 mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
 umount "$TEST_DEV"

 mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
 btrfs filesystem usage $TEST_DIR

We can see the data chunk changed from raid1 to single:
 # btrfs filesystem usage $TEST_DIR
 Data,single: Size:8.00MiB, Used:0.00B
    /dev/vdg        8.00MiB
 #

Reason:
 When a empty filesystem mount with -o nospace_cache, the last
 data blockgroup will be auto-removed in umount.

 Then if we mount it again, there is no data chunk in the
 filesystem, so the only available data profile is 0x0, result
 is all new chunks are created as single type.

Fix:
 Don't auto-delete last blockgroup for a raid type.

Test:
 Test by above script, and confirmed the logic by debug output.

Changelog v1->v2:
1: Put code of checking block_group->list into
   semaphore of space_info->groups_sem.
Noticed-by: Filipe Manana <fdmanana@gmail.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 79a5bd9..ed9426c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10010,8 +10010,18 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		block_group = list_first_entry(&fs_info->unused_bgs,
 					       struct btrfs_block_group_cache,
 					       bg_list);
-		space_info = block_group->space_info;
 		list_del_init(&block_group->bg_list);
+
+		space_info = block_group->space_info;
+
+		down_read(&space_info->groups_sem);
+		if (block_group->list.next == block_group->list.prev) {
+			up_read(&space_info->groups_sem);
+			btrfs_put_block_group(block_group);
+			continue;
+		}
+		up_read(&space_info->groups_sem);
+
 		if (ret || btrfs_mixed_space_info(space_info)) {
 			btrfs_put_block_group(block_group);
 			continue;
-- 
1.8.5.1

