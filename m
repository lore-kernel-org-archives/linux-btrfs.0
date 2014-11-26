Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17394 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751847AbaKZNDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:03:25 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQD32lv015522
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 21:03:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 10/11] Btrfs: fix possible deadlock caused by pending I/O in plug list
Date: Wed, 26 Nov 2014 21:04:50 +0800
Message-ID: <1417007091-11885-11-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>

The increase/decrease of bio counter is on the I/O path, so we should
use io_schedule() instead of schedule(), or the deadlock might be
triggered by the pending I/O in the plug list. io_schedule() can help
us because it will flush all the pending I/O before the task is going
to sleep.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v2 -> v3:
- New patch to fix possible deadlock caused by the pending bios in the
  plug list when the io submitters were going to sleep.

Changelog v1 -> v2:
- None.
---
 fs/btrfs/dev-replace.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index fa27b4e..894796a 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -928,16 +928,23 @@ void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 		wake_up(&fs_info->replace_wait);
 }
 
+#define btrfs_wait_event_io(wq, condition)				\
+do {									\
+	if (condition)							\
+		break;							\
+	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+			    io_schedule());				\
+} while (0)
+
 void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 {
-	DEFINE_WAIT(wait);
 again:
 	percpu_counter_inc(&fs_info->bio_counter);
 	if (test_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state)) {
 		btrfs_bio_counter_dec(fs_info);
-		wait_event(fs_info->replace_wait,
-			   !test_bit(BTRFS_FS_STATE_DEV_REPLACING,
-				     &fs_info->fs_state));
+		btrfs_wait_event_io(fs_info->replace_wait,
+				    !test_bit(BTRFS_FS_STATE_DEV_REPLACING,
+					      &fs_info->fs_state));
 		goto again;
 	}
 
-- 
1.9.3

