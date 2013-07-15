Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39509 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3GOLiM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 07:38:12 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl14so11134290pab.34
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:38:11 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, jbacik@fusionio.com, rusty@rustcorp.com.au,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] Btrfs: volume: Replace PTR_RET with PTR_ERR_OR_ZERO
Date: Mon, 15 Jul 2013 16:52:18 +0530
Message-Id: <1373887338-7463-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

PTR_RET is now deprecated. Use PTR_ERR_OR_ZERO instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested and based on the following tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git (PTR_RET)

Dependent on [1]
[1] http://lkml.indiana.edu/hypermail/linux/kernel/1306.2/00010.html
---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..67a0853 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3302,7 +3302,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 	}
 
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
-	return PTR_RET(tsk);
+	return PTR_ERR_OR_ZERO(tsk);
 }
 
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
-- 
1.7.9.5

