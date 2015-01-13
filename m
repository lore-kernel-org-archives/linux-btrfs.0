Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42603 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752363AbbAMMgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 07:36:07 -0500
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 07/15] Btrfs: Cleanup btrfs_bio_counter_inc_blocked()
Date: Tue, 13 Jan 2015 20:34:40 +0800
Message-ID: <1421152488-30548-8-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1421152488-30548-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1421152488-30548-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

1: Remove no-need DEFINE_WAIT(wait)
2: Add likely() for BTRFS_FS_STATE_DEV_REPLACING condition
3: Use while loop instead of goto

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
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

