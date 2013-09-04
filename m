Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63111 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762901Ab3IDPXH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:07 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so457009pbb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:07 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 09/20] Btrfs-progs: fix magic return value in cmds-quota.c
Date: Wed,  4 Sep 2013 23:22:26 +0800
Message-Id: <1378308157-4621-10-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-quota.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-quota.c b/cmds-quota.c
index 94e3a5c..89cc89c 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -48,7 +48,7 @@ static int quota_ctl(int cmd, int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_QUOTA_CTL, &args);
@@ -57,7 +57,7 @@ static int quota_ctl(int cmd, int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: quota command failed: %s\n",
 			strerror(e));
-		return 30;
+		return 1;
 	}
 	return 0;
 }
@@ -132,7 +132,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 
 	if (ioctlnum != BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
 		fprintf(stderr, "ERROR: -w cannot be used with -s\n");
-		return 12;
+		return 1;
 	}
 
 	if (check_argc_exact(argc - optind, 1))
@@ -144,7 +144,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, ioctlnum, &args);
@@ -160,7 +160,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: quota rescan failed: "
 				"%s\n", strerror(e));
-			return 30;
+			return 1;
 		}  else {
 			printf("quota rescan started\n");
 		}
-- 
1.7.11.7

