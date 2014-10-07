Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22977 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548AbaJGG5V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 02:57:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s976vJ1R001043
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Oct 2014 14:57:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Always return positive value to avoid meaningless return value
Date: Tue, 7 Oct 2014 14:57:18 +0800
Message-ID: <1412665038-3405-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs command may return minus value, however most shell only supports
return value in range [0,255], so minus return value will overflow,
which is quite confusing for end user.

This patch will do the minus check return value check before return it
to shell for all the btrfs-progs commands.

Also fix several easy-to-find errno leak and insane manual return value.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-calc-size.c     | 2 ++
 btrfs-corrupt-block.c | 4 ++++
 btrfs-crc.c           | 7 +++----
 btrfs-debug-tree.c    | 5 ++++-
 btrfs-find-root.c     | 2 ++
 btrfs-map-logical.c   | 6 +++++-
 btrfs-select-super.c  | 6 ++++--
 btrfs.c               | 6 +++++-
 8 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 501111c..221dc1f 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -511,5 +511,7 @@ int main(int argc, char **argv)
 out:
 	close_ctree(root);
 	free(roots);
+	if (ret < 0)
+		ret = -ret;
 	return ret;
 }
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 474d48f..e543adc 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -988,8 +988,12 @@ int main(int ac, char **av)
 		logical += root->sectorsize;
 		bytes -= root->sectorsize;
 	}
+	if (ret < 0)
+		ret = -ret;
 	return ret;
 out_close:
 	close_ctree(root);
+	if (ret < 0)
+		ret = -ret;
 	return ret;
 }
diff --git a/btrfs-crc.c b/btrfs-crc.c
index 723e0b7..9fcc8f3 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -57,9 +57,8 @@ int main(int argc, char **argv)
 			seed = atol(optarg);
 			break;
 		case 'h':
+		default:
 			usage();
-		case '?':
-			return 255;
 		}
 	}
 
@@ -68,7 +67,7 @@ int main(int argc, char **argv)
 
 	if (!loop) {
 		if (check_argc_min(argc - optind, 1))
-			return 255;
+			return EINVAL;
 
 		printf("%12u - %s\n", crc32c(~1, str, strlen(str)), str);
 		return 0;
@@ -76,7 +75,7 @@ int main(int argc, char **argv)
 
 	buf = malloc(length);
 	if (!buf)
-		return -ENOMEM;
+		return ENOMEM;
 	srand(seed);
 
 	while (1) {
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index e46500d..6fd6858 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -408,5 +408,8 @@ no_node:
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", BTRFS_BUILD_VERSION);
 close_root:
-	return close_ctree(root);
+	ret = close_ctree(root);
+	if (ret < 0)
+		ret = -ret;
+	return ret;
 }
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 408d471..b23ada8 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -329,5 +329,7 @@ int main(int argc, char **argv)
 	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	ret = find_root(root);
 	close_ctree(root);
+	if (ret < 0)
+		ret = -ret;
 	return ret;
 }
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 6b475fc..2be39cc 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -173,8 +173,10 @@ int main(int ac, char **av)
 			info_file = stderr;
 		} else {
 			out_fd = open(output_file, O_RDWR | O_CREAT, 0600);
-			if (out_fd < 0)
+			if (out_fd < 0) {
+				ret = errno;
 				goto close;
+			}
 			ret = ftruncate(out_fd, 0);
 			if (ret) {
 				ret = 1;
@@ -211,5 +213,7 @@ out_close_fd:
 		close(out_fd);
 close:
 	close_ctree(root);
+	if (ret < 0)
+		ret = -ret;
 	return ret;
 }
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 6231d42..d6aa25a 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -81,10 +81,10 @@ int main(int ac, char **av)
 
 	if((ret = check_mounted(av[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
-		return ret;
+		return -ret;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
-		return -EBUSY;
+		return EBUSY;
 	}
 
 	root = open_ctree(av[optind], bytenr, 1);
@@ -104,5 +104,7 @@ int main(int ac, char **av)
 	 */
 	printf("using SB copy %llu, bytenr %llu\n", (unsigned long long)num,
 	       (unsigned long long)bytenr);
+	if (ret < 0)
+		ret = -ret;
 	return ret;
 }
diff --git a/btrfs.c b/btrfs.c
index e83349c..4d09464 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -216,6 +216,7 @@ int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
 	const char *bname;
+	int ret;
 
 	if ((bname = strrchr(argv[0], '/')) != NULL)
 		bname++;
@@ -244,5 +245,8 @@ int main(int argc, char **argv)
 	crc32c_optimization_init();
 
 	fixup_argv0(argv, cmd->token);
-	exit(cmd->fn(argc, argv));
+	ret = cmd->fn(argc, argv);
+	if (ret < 0)
+		ret = -ret;
+	exit(ret);
 }
-- 
2.1.2

