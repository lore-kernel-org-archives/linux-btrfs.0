Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21761 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988AbbASMAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 07:00:52 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 08/16] Btrfs: btrfs_rm_dev_replace_blocked(): Use wait_event()
Date: Mon, 19 Jan 2015 19:20:57 +0800
Message-ID: <1421666465-3892-9-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421666465-3892-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 92109b7..5ec03d9 100644
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
+	wait_event(fs_info->replace_wait, !percpu_counter_sum(
+		   &fs_info->bio_counter));
 }
 
 /*
-- 
1.8.5.1

