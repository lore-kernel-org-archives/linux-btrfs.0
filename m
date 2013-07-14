Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39632 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3GNOcb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 10:32:31 -0400
Received: by mail-pb0-f50.google.com with SMTP id wz7so10490030pbc.37
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 07:32:30 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs-progs: listing subvols and getting default subvol don't need a subv path
Date: Sun, 14 Jul 2013 22:32:23 +0800
Message-Id: <1373812343-5068-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Listing subvolumes and getting default subvol in the filesystem don't need a
subv path,Any valid path related to Btrfs filesystem is ok to finish the work.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..52c6485 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -420,18 +420,6 @@ static int cmd_subvol_list(int argc, char **argv)
 	}
 
 	subvol = argv[optind];
-
-	ret = test_issubvolume(subvol);
-	if (ret < 0) {
-		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		goto out;
-	}
-	if (!ret) {
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		ret = -1;
-		goto out;
-	}
-
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
 		ret = -1;
@@ -652,17 +640,6 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		usage(cmd_subvol_get_default_usage);
 
 	subvol = argv[1];
-
-	ret = test_issubvolume(subvol);
-	if (ret < 0) {
-		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		return 1;
-	}
-	if (!ret) {
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		return 1;
-	}
-
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
-- 
1.7.11.7

