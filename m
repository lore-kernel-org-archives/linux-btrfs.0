Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbaGPEFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 00:05:41 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: use check_argc_* to check arg number for all tools
Date: Wed, 16 Jul 2014 11:59:46 +0800
Message-ID: <1405483186-10908-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1404954405-16290-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1404954405-16290-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since this patch:
	btrfs-progs: move the check_argc_* functions into utils.c

All tools including the independent tools(e.g. btrfs-image, btrfs-convert)
can share the convenience of the check_argc_* functions, so this patch
adopt the argc check functions globally.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
        v1->v2: make show-super, check and send cmds work correctly
---
 btrfs-calc-size.c     | 4 +++-
 btrfs-convert.c       | 3 ++-
 btrfs-corrupt-block.c | 3 ++-
 btrfs-crc.c           | 7 ++++---
 btrfs-debug-tree.c    | 3 ++-
 btrfs-find-root.c     | 4 +++-
 btrfs-fragments.c     | 8 +++++---
 btrfs-map-logical.c   | 3 ++-
 btrfs-select-super.c  | 3 ++-
 btrfs-show-super.c    | 3 ++-
 btrfs-zero-log.c      | 3 ++-
 btrfstune.c           | 3 ++-
 cmds-check.c          | 2 +-
 cmds-restore.c        | 5 +++--
 cmds-send.c           | 2 +-
 15 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 5eabdfc..501111c 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -452,7 +452,9 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (optind >= argc) {
+	set_argv0(argv);
+	argc = argc - optind;
+	if (check_argc_min(argc, 1)) {
 		usage();
 		exit(1);
 	}
diff --git a/btrfs-convert.c b/btrfs-convert.c
index d62d4f8..952e3e6 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2723,7 +2723,8 @@ int main(int argc, char *argv[])
 		}
 	}
 	argc = argc - optind;
-	if (argc != 1) {
+	set_argv0(argv);
+	if (check_argc_exact(argc, 1)) {
 		print_usage();
 		return 1;
 	}
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 6ecbe47..1a3ac35 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -865,8 +865,9 @@ int main(int ac, char **av)
 				print_usage();
 		}
 	}
+	set_argv0(av);
 	ac = ac - optind;
-	if (ac == 0)
+	if (check_argc_min(ac, 1))
 		print_usage();
 	dev = av[optind];
 
diff --git a/btrfs-crc.c b/btrfs-crc.c
index 1990534..723e0b7 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -20,6 +20,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include "crc32c.h"
+#include "utils.h"
 
 void usage(void)
 {
@@ -62,13 +63,13 @@ int main(int argc, char **argv)
 		}
 	}
 
+	set_argv0(argv);
 	str = argv[optind];
 
 	if (!loop) {
-		if (optind >= argc) {
-			fprintf(stderr, "not enough arguments\n");
+		if (check_argc_min(argc - optind, 1))
 			return 255;
-		}
+
 		printf("%12u - %s\n", crc32c(~1, str, strlen(str)), str);
 		return 0;
 	}
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 36e1115..e46500d 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -174,8 +174,9 @@ int main(int ac, char **av)
 				print_usage();
 		}
 	}
+	set_argv0(av);
 	ac = ac - optind;
-	if (ac != 1)
+	if (check_argc_exact(ac, 1))
 		print_usage();
 
 	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 7932308..6fe4b7b 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -305,7 +305,9 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (optind >= argc) {
+	set_argv0(argv);
+	argc = argc - optind;
+	if (check_argc_min(argc, 1)) {
 		usage();
 		exit(1);
 	}
diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index 160429a..d03c2c3 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -425,13 +425,15 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (optind < argc) {
-		path = argv[optind++];
-	} else {
+	set_argv0(argv);
+	argc = argc - optind;
+	if (check_argc_min(argc, 1)) {
 		usage();
 		exit(1);
 	}
 
+	path = argv[optind++];
+
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index e47a1ae..6b475fc 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -148,8 +148,9 @@ int main(int ac, char **av)
 				print_usage();
 		}
 	}
+	set_argv0(av);
 	ac = ac - optind;
-	if (ac == 0)
+	if (check_argc_min(ac, 1))
 		print_usage();
 	if (logical == 0)
 		print_usage();
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index d7cd187..6231d42 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -66,9 +66,10 @@ int main(int ac, char **av)
 				print_usage();
 		}
 	}
+	set_argv0(av);
 	ac = ac - optind;
 
-	if (ac != 1)
+	if (check_argc_exact(ac, 1))
 		print_usage();
 
 	if (bytenr == 0) {
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index ed0311f..38c5d26 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -95,7 +95,8 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (argc < optind + 1) {
+	set_argv0(argv);
+	if (check_argc_min(argc - optind, 1)) {
 		print_usage();
 		exit(1);
 	}
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index ab7f418..88998e9 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -46,7 +46,8 @@ int main(int ac, char **av)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (ac != 2)
+	set_argv0(av);
+	if (check_argc_exact(ac, 2))
 		print_usage();
 
 	radix_tree_init();
diff --git a/btrfstune.c b/btrfstune.c
index 3f2f0cd..b43c2f0 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -137,9 +137,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	set_argv0(argv);
 	argc = argc - optind;
 	device = argv[optind];
-	if (argc != 1) {
+	if (check_argc_exact(argc, 1)) {
 		print_usage();
 		return 1;
 	}
diff --git a/cmds-check.c b/cmds-check.c
index 6d3388f..078882b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7020,7 +7020,7 @@ int cmd_check(int argc, char **argv)
 	}
 	argc = argc - optind;
 
-	if (argc != 1)
+	if (check_argc_exact(argc, 1))
 		usage(cmd_check_usage);
 
 	radix_tree_init();
diff --git a/cmds-restore.c b/cmds-restore.c
index 3465f84..8e8afc5 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1214,9 +1214,10 @@ int cmd_restore(int argc, char **argv)
 		}
 	}
 
-	if (!list_roots && optind + 1 >= argc)
+	set_argv0(argv);
+	if (!list_roots && check_argc_min(argc - optind, 2))
 		usage(cmd_restore_usage);
-	else if (list_roots && optind >= argc)
+	else if (list_roots && check_argc_min(argc - optind, 1))
 		usage(cmd_restore_usage);
 
 	if (fs_location && root_objectid) {
diff --git a/cmds-send.c b/cmds-send.c
index 9a73b32..cbc21f8 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -556,7 +556,7 @@ int cmd_send(int argc, char **argv)
 		}
 	}
 
-	if (optind == argc)
+	if (check_argc_min(argc - optind, 1))
 		usage(cmd_send_usage);
 
 	if (g_total_data_size &&
-- 
1.8.1.4

