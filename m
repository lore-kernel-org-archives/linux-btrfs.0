Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35208 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbbBLHnZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:43:25 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1C7gbic016512
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 15:42:37 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: cleanup: use wait_event() for btrfs_rm_dev_replace_blocked()
Date: Thu, 12 Feb 2015 15:42:15 +0800
Message-ID: <1423726935-7745-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

wait_event() is just suit for these hand-made code.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 92109b7..1a2d440 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -440,18 +440,9 @@ leave:
  */
 static void btrfs_rm_dev_replace_blocked(struct btrfs_fs_info *fs_info)
 {
-	s64 writers;
-	DEFINE_WAIT(wait);
-
 	set_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state);
-	do {
-		prepare_to_wait(&fs_info->replace_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		writers = percpu_counter_sum(&fs_info->bio_counter);
-		if (writers)
-			schedule();
-		finish_wait(&fs_info->replace_wait, &wait);
-	} while (writers);
+	wait_event(fs_info->replace_wait,
+		   !percpu_counter_sum(&fs_info->bio_counter));
 }
 
 /*
-- 
1.8.5.1

