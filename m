Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54666 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbaBTCwp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 21:52:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K2qdnB013317
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 10:52:41 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: judge the return value of check_mounted more accurately
Date: Thu, 20 Feb 2014 10:49:03 +0800
Message-Id: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs-convert, btrfstune, btrfs rescue, they report "device busy"
when given a device that does not actually exist e.g.

	# btrfstune -x abcdefg (this device does not exist)
	$ ...device busy...

We deal with this case by add "ret < 0" error check when
judging the return value of check_mounted.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-convert.c |  7 ++++++-
 btrfstune.c     |  7 ++++++-
 cmds-rescue.c   | 14 +++++++++++---
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 1b66de7..a8b2c51 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2729,7 +2729,12 @@ int main(int argc, char *argv[])
 	}
 
 	file = argv[optind];
-	if (check_mounted(file)) {
+	ret = check_mounted(file);
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+		return 1;
+	} else if (ret) {
 		fprintf(stderr, "%s is mounted\n", file);
 		return 1;
 	}
diff --git a/btrfstune.c b/btrfstune.c
index da82f36..2e623f3 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -151,7 +151,12 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (check_mounted(device)) {
+	ret = check_mounted(device);
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+		return 1;
+	} else if (ret) {
 		fprintf(stderr, "%s is mounted\n", device);
 		return 1;
 	}
diff --git a/cmds-rescue.c b/cmds-rescue.c
index e18eb98..f20a206 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -80,9 +80,13 @@ int cmd_chunk_recover(int argc, char *argv[])
 	file = argv[optind];
 
 	ret = check_mounted(file);
-	if (ret) {
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+		return 1;
+	} else if (ret) {
 		fprintf(stderr, "the device is busy\n");
-		return ret;
+		return 1;
 	}
 
 	ret = btrfs_recover_chunk_tree(file, verbose, yes);
@@ -133,7 +137,11 @@ int cmd_super_recover(int argc, char **argv)
 
 	dname = argv[optind];
 	ret = check_mounted(dname);
-	if (ret) {
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+		return 1;
+	} else if (ret) {
 		fprintf(stderr, "the device is busy\n");
 		return 1;
 	}
-- 
1.8.1.4

