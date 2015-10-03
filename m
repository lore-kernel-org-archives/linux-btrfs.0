Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:20713 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752500AbbJCQal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 12:30:41 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t93GTtTm017031
	for <linux-btrfs@vger.kernel.org>; Sun, 4 Oct 2015 00:29:55 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 1/2] btrfs: Fix lost-data-profile caused by auto removing bg
Date: Sun, 4 Oct 2015 00:28:39 +0800
Message-ID: <a2ff95d73e0ccec4703c1f4d0b9af4c1a19fe4e2.1443889301.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1443889301.git.zhaolei@cn.fujitsu.com>
References: <cover.1443889301.git.zhaolei@cn.fujitsu.com>
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

Changelog v2->v3:
1: Use list_is_singular() instead of
   block_group->list.next == block_group->list.prev
   Suggested-by: Jeff Mahoney <jeffm@suse.com>

Changelog v1->v2:
1: Put code of checking block_group->list into
   semaphore of space_info->groups_sem.
Noticed-by: Filipe Manana <fdmanana@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 79a5bd9..c05b975 100644
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
+		if (list_is_singular(&block_group->list)) {
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

