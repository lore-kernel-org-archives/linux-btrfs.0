Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPXp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:45 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so450633pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:44 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 20/20] Btrfs-progs: fix magic return value in cmds-scrub.c
Date: Wed,  4 Sep 2013 23:22:37 +0800
Message-Id: <1378308157-4621-21-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

There will be four kinds of return value for command "scrub start":

0: scrub dosen't find errors and return success.
1: usage or syntax errors.
3: scrub finds errors and correct all of them.
4: scrub finds errors and some of them are not correctable.

Three kinds of return values for scrub cancel/resume:

0: cancel successfully.
1: usage or syntax errors.
2: cancel a not started or finished scrub.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-scrub.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 55da405..605af45 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1018,7 +1018,7 @@ static int mkdir_p(char *path)
 		path[i] = '\0';
 		ret = mkdir(path, 0777);
 		if (ret && errno != EEXIST)
-			return 1;
+			return -errno;
 		path[i] = '/';
 	}
 
@@ -1155,7 +1155,7 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	if (fdmnt < 0) {
 		ERR(!do_quiet, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
@@ -1261,8 +1261,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		if (!do_quiet)
 			printf("scrub: nothing to resume for %s, fsid %s\n",
 			       path, fsid);
-		err = 0;
-		goto out;
+		return 2;
 	}
 
 	ret = prg_fd = socket(AF_UNIX, SOCK_STREAM, 0);
@@ -1501,9 +1500,9 @@ out:
 	if (err)
 		return 1;
 	if (e_correctable)
-		return 7;
+		return 3;
 	if (e_uncorrectable)
-		return 8;
+		return 4;
 	return 0;
 }
 
@@ -1557,7 +1556,10 @@ static int cmd_scrub_cancel(int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: scrub cancel failed on %s: %s\n", path,
 			errno == ENOTCONN ? "not running" : strerror(errno));
-		ret = 1;
+		if (errno == ENOTCONN)
+			ret = 2;
+		else
+			ret = 1;
 		goto out;
 	}
 
@@ -1642,7 +1644,7 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
@@ -1727,7 +1729,7 @@ out:
 		close(fdres);
 	close_file_or_dir(fdmnt, dirstream);
 
-	return err;
+	return !!err;
 }
 
 const struct cmd_group scrub_cmd_group = {
-- 
1.7.11.7

