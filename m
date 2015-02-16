Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3827 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbbBPD5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 22:57:38 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1G3uoHQ030850
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 11:56:50 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 1/3] btrfs: cleanup: remove unuesd DEDINE_WAIT() in btrfs_bio_counter_inc_blocked()
Date: Mon, 16 Feb 2015 11:56:28 +0800
Message-ID: <1424058988-30118-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

1: Remove unused DEFINE_WAIT(wait)
2: Use a loop instead of goto

Changelog v2->v3:
 s/look/loop in description.

Changelog v1->v2:
 Remove likely() in v1 because it is not a performance sensitive path,
 suggesed by: David Sterba <dsterba@suse.cz>

Acked-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ca6a3a3..e444eeb 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -932,15 +932,14 @@ void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 
 void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 {
-	DEFINE_WAIT(wait);
-again:
-	percpu_counter_inc(&fs_info->bio_counter);
-	if (test_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state)) {
+	while (1) {
+		percpu_counter_inc(&fs_info->bio_counter);
+		if (!test_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state))
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

