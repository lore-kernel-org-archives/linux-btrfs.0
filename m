Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:58186 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaAAOLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jan 2014 09:11:53 -0500
From: Pascal VITOUX <vitoux.pascal@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Pascal VITOUX <vitoux.pascal@gmail.com>
Subject: [PATCH] Skip non-regular files in recursive defrag
Date: Wed,  1 Jan 2014 15:10:25 +0100
Message-Id: <1388585425-7051-1-git-send-email-vitoux.pascal@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1c1926b..979dbd9 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -646,7 +646,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	int e = 0;
 	int fd = 0;
 
-	if (typeflag == FTW_F) {
+	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
 		fd = open(fpath, O_RDWR);
-- 
1.8.5.2

