Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58622 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762934Ab3IDPXM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:12 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so463932pdj.6
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:12 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 11/20] Btrfs-progs: fix magic return value in cmds-restore.c
Date: Wed,  4 Sep 2013 23:22:28 +0800
Message-Id: <1378308157-4621-12-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 4c87483..04a8382 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -247,7 +247,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	outbuf = malloc(ram_size);
 	if (!outbuf) {
 		fprintf(stderr, "No memory\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	ret = decompress(buf, outbuf, len, &ram_size, compress);
@@ -305,7 +305,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	inbuf = malloc(disk_size);
 	if (!inbuf) {
 		fprintf(stderr, "No memory\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	if (compress != BTRFS_COMPRESS_NONE) {
@@ -313,7 +313,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 		if (!outbuf) {
 			fprintf(stderr, "No memory\n");
 			free(inbuf);
-			return -1;
+			return -ENOMEM;
 		}
 	}
 again:
@@ -543,7 +543,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	path = btrfs_alloc_path();
 	if (!path) {
 		fprintf(stderr, "Ran out of memory\n");
-		return -1;
+		return -ENOMEM;
 	}
 	path->skip_locking = 1;
 
@@ -676,7 +676,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 	path = btrfs_alloc_path();
 	if (!path) {
 		fprintf(stderr, "Ran out of memory\n");
-		return -1;
+		return -ENOMEM;
 	}
 	path->skip_locking = 1;
 
@@ -823,7 +823,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			if (!dir) {
 				fprintf(stderr, "Ran out of memory\n");
 				btrfs_free_path(path);
-				return -1;
+				return -ENOMEM;
 			}
 
 			if (location.type == BTRFS_ROOT_ITEM_KEY) {
@@ -917,7 +917,7 @@ static int do_list_roots(struct btrfs_root *root)
 	path = btrfs_alloc_path();
 	if (!path) {
 		fprintf(stderr, "Failed to alloc path\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	key.offset = 0;
@@ -1210,7 +1210,7 @@ int cmd_restore(int argc, char **argv)
 	if ((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
 			strerror(-ret));
-		return ret;
+		return 1;
 	} else if (ret) {
 		fprintf(stderr, "%s is currently mounted.  Aborting.\n", argv[optind]);
 		return 1;
@@ -1284,5 +1284,5 @@ out:
 	if (mreg)
 		regfree(mreg);
 	close_ctree(root);
-	return ret;
+	return !!ret;
 }
-- 
1.7.11.7

