Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49399 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPXC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:02 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so431530pbc.8
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:01 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 07/20] Btrfs-progs: fix magic return value in cmds-inspect.c
Date: Wed,  4 Sep 2013 23:22:24 +0800
Message-Id: <1378308157-4621-8-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-inspect.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 9101470..bdebf7d 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -44,7 +44,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 
 	fspath = malloc(4096);
 	if (!fspath)
-		return 1;
+		return -ENOMEM;
 
 	memset(fspath, 0, sizeof(*fspath));
 	ipa.inum = inum;
@@ -78,7 +78,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 
 out:
 	free(fspath);
-	return ret;
+	return !!ret;
 }
 
 static const char * const cmd_inode_resolve_usage[] = {
@@ -117,13 +117,13 @@ static int cmd_inode_resolve(int argc, char **argv)
 	fd = open_file_or_dir(argv[optind+1], &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
-		return 12;
+		return 1;
 	}
 
 	ret = __ino_to_path_fd(atoll(argv[optind]), fd, verbose,
 			       argv[optind+1]);
 	close_file_or_dir(fd, dirstream);
-	return ret;
+	return !!ret;
 
 }
 
@@ -256,7 +256,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 out:
 	close_file_or_dir(fd, dirstream);
 	free(inodes);
-	return ret;
+	return !!ret;
 }
 
 static const char * const cmd_subvolid_resolve_usage[] = {
-- 
1.7.11.7

