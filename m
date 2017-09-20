Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33959 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdITGSB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 02:18:01 -0400
From: Allen Pais <allen.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH v2] fs:btrfs: return -ENOMEM on allocation failure.
Date: Wed, 20 Sep 2017 11:47:46 +0530
Message-Id: <1505888266-23526-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2: return -ENOMEM from btrfsic_dev_state_alloc() too.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 fs/btrfs/check-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7d5a9b5..9db1e76 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2913,7 +2913,7 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
 	state = kvzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state) {
 		pr_info("btrfs check-integrity: allocation failed!\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	if (!btrfsic_is_initialized) {
@@ -2945,7 +2945,7 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
 		if (NULL == ds) {
 			pr_info("btrfs check-integrity: kmalloc() failed!\n");
 			mutex_unlock(&btrfsic_mutex);
-			return -1;
+			return -ENOMEM;
 		}
 		ds->bdev = device->bdev;
 		ds->state = state;
-- 
2.7.4

