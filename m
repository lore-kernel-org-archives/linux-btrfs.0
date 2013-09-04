Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43830 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPXE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:04 -0400
Received: by mail-pb0-f51.google.com with SMTP id jt11so448815pbb.24
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:04 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 08/20] Btrfs-progs: fix magic return value in cmds-qgroup.c
Date: Wed,  4 Sep 2013 23:22:25 +0800
Message-Id: <1378308157-4621-9-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 6fa4c17..ff2a1fa 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -54,12 +54,12 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	 */
 	if ((args.src >> 48) >= (args.dst >> 48)) {
 		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
-		return 12;
+		return 1;
 	}
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
@@ -68,7 +68,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
 			strerror(e));
-		return 30;
+		return 1;
 	}
 	return 0;
 }
@@ -92,7 +92,7 @@ static int qgroup_create(int create, int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
@@ -101,7 +101,7 @@ static int qgroup_create(int create, int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to create quota group: %s\n",
 			strerror(e));
-		return 30;
+		return 1;
 	}
 	return 0;
 }
@@ -310,19 +310,17 @@ static int cmd_qgroup_show(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = list_qgroups(fd);
 	e = errno;
 	close_file_or_dir(fd, dirstream);
-	if (ret < 0) {
+	if (ret < 0)
 		fprintf(stderr, "ERROR: can't list qgroups: %s\n",
 				strerror(e));
-		return 30;
-	}
 
-	return ret;
+	return !!ret;
 }
 
 static const char * const cmd_qgroup_limit_usage[] = {
@@ -392,12 +390,12 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		ret = test_issubvolume(path);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: error accessing '%s'\n", path);
-			return 12;
+			return 1;
 		}
 		if (!ret) {
 			fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
 				path);
-			return 13;
+			return 1;
 		}
 		/*
 		 * keep qgroupid at 0, this indicates that the subvolume the
@@ -412,7 +410,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-		return 12;
+		return 1;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
@@ -421,7 +419,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to limit requested quota group: "
 			"%s\n", strerror(e));
-		return 30;
+		return 1;
 	}
 	return 0;
 }
-- 
1.7.11.7

