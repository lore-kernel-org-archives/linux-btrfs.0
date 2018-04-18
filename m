Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:41244 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752882AbeDRHMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 03:12:32 -0400
From: Ting-Chang <tchou@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Ting-Chang Hou <tchou@synology.com>
Subject: [PATCH] btrfs-progs: restore: fix mistake on overwrite_ok() if relative path is given
Date: Wed, 18 Apr 2018 15:12:15 +0800
Message-Id: <1524035535-20385-1-git-send-email-tchou@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Ting-Chang Hou <tchou@synology.com>

fstatat will return -1 with errno EBADF if path_name is relative path.
This caused an error of the return value of overwrite_ok().
When restoring the subvolume to destination with relative path,
it will overwrite the existing file rather than skip it.

Signed-off-by: tchou <tchou@synology.com>
---
 cmds-restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index ade35f0..dc042e2 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -825,7 +825,7 @@ static int overwrite_ok(const char * path)
 	int ret;
 
 	/* don't be fooled by symlinks */
-	ret = fstatat(-1, path_name, &st, AT_SYMLINK_NOFOLLOW);
+	ret = fstatat(AT_FDCWD, path_name, &st, AT_SYMLINK_NOFOLLOW);
 
 	if (!ret) {
 		if (overwrite)
-- 
2.7.4

