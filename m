Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39889 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965269AbbI2NxY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 09:53:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8TDqxRx021218
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 21:52:59 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: Fix lost-data-profile caused by auto removing bg
Date: Tue, 29 Sep 2015 21:51:42 +0800
Message-ID: <585889cfca0895674926445c0a8caa84f8fc6184.1443534660.git.zhaolei@cn.fujitsu.com>
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

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 79a5bd9..3505649 100644
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

