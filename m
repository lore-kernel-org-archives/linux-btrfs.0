Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46361 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691AbbBLHnZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:43:25 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1C7gaZt016506
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 15:42:36 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs: cleanup: remove unuesd DEDINE_WAIT() in btrfs_bio_counter_inc_blocked()
Date: Thu, 12 Feb 2015 15:42:11 +0800
Message-ID: <1423726931-7706-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

1: Remove unused DEFINE_WAIT(wait)
2: Add likely() for BTRFS_FS_STATE_DEV_REPLACING condition
3: Use a look instead of goto

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ca6a3a3..92109b7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -932,15 +932,15 @@ void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 
 void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 {
-	DEFINE_WAIT(wait);
-again:
-	percpu_counter_inc(&fs_info->bio_counter);
-	if (test_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state)) {
+	while (1) {
+		percpu_counter_inc(&fs_info->bio_counter);
+		if (likely(!test_bit(BTRFS_FS_STATE_DEV_REPLACING,
+				     &fs_info->fs_state)))
+			break;
+
 		btrfs_bio_counter_dec(fs_info);
 		wait_event(fs_info->replace_wait,
 			   !test_bit(BTRFS_FS_STATE_DEV_REPLACING,
 				     &fs_info->fs_state));
-		goto again;
 	}
-
 }
-- 
1.8.5.1

