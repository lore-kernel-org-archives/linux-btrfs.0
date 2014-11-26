Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62737 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKZDAi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 22:00:38 -0500
Received: by mail-pd0-f171.google.com with SMTP id y13so1849194pdi.30
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 19:00:37 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] Btrfs-progs, fsck: move root items repair after root rebuilding
Date: Wed, 26 Nov 2014 10:58:52 +0800
Message-Id: <1416970736-26623-4-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com>
References: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If some critical roots are corrupt, reapr_root_items() will fail,
this is detected by fsck_tests.sh's extent rebuilding tests.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 cmds-check.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index a102752..ae9005e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7987,22 +7987,6 @@ int cmd_check(int argc, char **argv)
 
 	root = info->fs_root;
 
-	ret = repair_root_items(info);
-	if (ret < 0)
-		goto close_out;
-	if (repair) {
-		fprintf(stderr, "Fixed %d roots.\n", ret);
-		ret = 0;
-	} else if (ret > 0) {
-		fprintf(stderr,
-		       "Found %d roots with an outdated root item.\n",
-		       ret);
-		fprintf(stderr,
-			"Please run a filesystem check with the option --repair to fix them.\n");
-		ret = 1;
-		goto close_out;
-	}
-
 	/*
 	 * repair mode will force us to commit transaction which
 	 * will make us fail to load log tree when mounting.
@@ -8101,6 +8085,22 @@ int cmd_check(int argc, char **argv)
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
 
+	ret = repair_root_items(info);
+	if (ret < 0)
+		goto close_out;
+	if (repair) {
+		fprintf(stderr, "Fixed %d roots.\n", ret);
+		ret = 0;
+	} else if (ret > 0) {
+		fprintf(stderr,
+		       "Found %d roots with an outdated root item.\n",
+		       ret);
+		fprintf(stderr,
+			"Please run a filesystem check with the option --repair to fix them.\n");
+		ret = 1;
+		goto close_out;
+	}
+
 	fprintf(stderr, "checking free space cache\n");
 	ret = check_space_cache(root);
 	if (ret)
-- 
2.1.0

