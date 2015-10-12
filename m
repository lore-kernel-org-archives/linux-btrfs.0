Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:48251 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752815AbbJLD3c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 23:29:32 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9C3SodE029205
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 11:28:50 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Add all missing close_ctree and btrfs_close_all_devices
Date: Mon, 12 Oct 2015 11:27:39 +0800
Message-ID: <097939b7e85d73c1dc7ac82565b8683b5b0a2a8d.1444620452.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch add all missing close_ctree and btrfs_close_all_devices
to several tools in btrfs progs, to avoid memory leak.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-calc-size.c    |  1 +
 btrfs-debug-tree.c   |  5 ++++-
 btrfs-find-root.c    |  1 +
 btrfs-map-logical.c  |  1 +
 btrfs-select-super.c |  3 +++
 btrfstune.c          |  1 +
 cmds-filesystem.c    | 14 ++++++++------
 cmds-property.c      |  2 ++
 cmds-rescue.c        |  5 ++++-
 cmds-restore.c       |  1 +
 cmds-scrub.c         |  4 +++-
 11 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 7287858..b756693 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -508,5 +508,6 @@ int main(int argc, char **argv)
 out:
 	close_ctree(root);
 	free(roots);
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 7d8e876..8adc39f 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -28,6 +28,7 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
+#include "volumes.h"
 #include "utils.h"
 
 static int print_usage(int ret)
@@ -428,5 +429,7 @@ no_node:
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", PACKAGE_STRING);
 close_root:
-	return close_ctree(root);
+	ret = close_ctree(root);
+	btrfs_close_all_devices();
+	return ret;
 }
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 01b3603..fc3812c 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -216,5 +216,6 @@ int main(int argc, char **argv)
 out:
 	btrfs_find_root_free(&result);
 	close_ctree(root);
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index d9fa6b2..deccb03 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -357,6 +357,7 @@ out_close_fd:
 close:
 	free(output_file);
 	close_ctree(root);
+	btrfs_close_all_devices();
 	if (ret < 0)
 		ret = 1;
 	return ret;
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index b790f3e..df74153 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -23,6 +23,7 @@
 #include <sys/stat.h>
 #include "kerncompat.h"
 #include "ctree.h"
+#include "volumes.h"
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
@@ -101,5 +102,7 @@ int main(int ac, char **av)
 	 */
 	printf("using SB copy %llu, bytenr %llu\n", (unsigned long long)num,
 	       (unsigned long long)bytenr);
+	close_ctree(root);
+	btrfs_close_all_devices();
 	return ret;
 }
diff --git a/btrfstune.c b/btrfstune.c
index c248ee6..0907aa9 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -548,6 +548,7 @@ int main(int argc, char *argv[])
 	}
 out:
 	close_ctree(root);
+	btrfs_close_all_devices();
 
 	return ret;
 }
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 3663734..a14cb85 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -918,6 +918,7 @@ devs_only:
 	}
 out:
 	printf("%s\n", PACKAGE_STRING);
+	btrfs_close_all_devices();
 	free_seen_fsid();
 	return ret;
 }
@@ -1279,21 +1280,22 @@ static const char * const cmd_filesystem_label_usage[] = {
 
 static int cmd_filesystem_label(int argc, char **argv)
 {
+	int ret;
+
 	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
 		usage(cmd_filesystem_label_usage);
 
 	if (argc > 2) {
-		return set_label(argv[1], argv[2]);
+		ret = set_label(argv[1], argv[2]);
 	} else {
 		char label[BTRFS_LABEL_SIZE];
-		int ret;
-
 		ret = get_label(argv[1], label);
 		if (!ret)
-			fprintf(stdout, "%s\n", label);
-
-		return ret;
+			printf("%s\n", label);
 	}
+
+	btrfs_close_all_devices();
+	return ret;
 }
 
 static const char filesystem_cmd_group_info[] =
diff --git a/cmds-property.c b/cmds-property.c
index 0ffd250..f8c2823 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -22,6 +22,7 @@
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 
+#include "volumes.h"
 #include "commands.h"
 #include "props.h"
 #include "ctree.h"
@@ -319,6 +320,7 @@ static int setget_prop(int types, const char *object,
 	else
 		ret = 0;
 
+	btrfs_close_all_devices();
 out:
 	return ret;
 
diff --git a/cmds-rescue.c b/cmds-rescue.c
index fb3227b..4885b8a 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -19,6 +19,7 @@
 #include "kerncompat.h"
 
 #include <getopt.h>
+#include "volumes.h"
 #include "ctree.h"
 #include "transaction.h"
 #include "disk-io.h"
@@ -101,6 +102,7 @@ static int cmd_rescue_chunk_recover(int argc, char *argv[])
 	} else {
 		fprintf(stdout, "Fail to recover the chunk tree.\n");
 	}
+	btrfs_close_all_devices();
 	return ret;
 }
 
@@ -149,6 +151,7 @@ static int cmd_rescue_super_recover(int argc, char **argv)
 		return 1;
 	}
 	ret = btrfs_recover_superblocks(dname, verbose, yes);
+	btrfs_close_all_devices();
 	return ret;
 }
 
@@ -196,7 +199,7 @@ static int cmd_rescue_zero_log(int argc, char **argv)
 	btrfs_set_super_log_root_level(sb, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
-
+	btrfs_close_all_devices();
 out:
 	return !!ret;
 }
diff --git a/cmds-restore.c b/cmds-restore.c
index a1445d4..f978022 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1611,5 +1611,6 @@ out:
 	if (mreg)
 		regfree(mreg);
 	close_ctree(root);
+	btrfs_close_all_devices();
 	return !!ret;
 }
diff --git a/cmds-scrub.c b/cmds-scrub.c
index ea6ffc9..5df48b9 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1549,6 +1549,7 @@ out:
 			unlink(sock_path);
 	}
 	close_file_or_dir(fdmnt, dirstream);
+	btrfs_close_all_devices();
 
 	if (err)
 		return 1;
@@ -1631,6 +1632,7 @@ static int cmd_scrub_cancel(int argc, char **argv)
 
 out:
 	close_file_or_dir(fdmnt, dirstream);
+	btrfs_close_all_devices();
 	return ret;
 }
 
@@ -1798,7 +1800,7 @@ out:
 	if (fdres > -1)
 		close(fdres);
 	close_file_or_dir(fdmnt, dirstream);
-
+	btrfs_close_all_devices();
 	return !!err;
 }
 
-- 
1.8.5.1

