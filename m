Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39774 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaAPE0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 23:26:54 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so2076739pde.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 20:26:54 -0800 (PST)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Mitchel Humpherys <mitch.special@gmail.com>
Subject: [PATCH] btrfs-progs: add help switches where needed
Date: Wed, 15 Jan 2014 20:26:30 -0800
Message-Id: <1389846390-17585-2-git-send-email-mitch.special@gmail.com>
In-Reply-To: <1389846390-17585-1-git-send-email-mitch.special@gmail.com>
References: <1389846390-17585-1-git-send-email-mitch.special@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some of the btrfs programs don't support -h or --help. It's not really a
problem since everyone seems to fall back to printing usage text when an
option is not recognized, so passing -h or --help usually gets you the
usage text. However, it also usually gets you a "invalid option -- 'h'".

Fix this minor annoyance by adding proper support for -h and --help
where appropriate.

Signed-off-by: Mitchel Humpherys <mitch.special@gmail.com>
---
 btrfs-calc-size.c     | 3 ++-
 btrfs-convert.c       | 3 ++-
 btrfs-corrupt-block.c | 3 ++-
 btrfs-debug-tree.c    | 3 ++-
 btrfs-find-root.c     | 3 ++-
 btrfs-image.c         | 3 ++-
 btrfs-map-logical.c   | 4 +++-
 btrfs-select-super.c  | 3 ++-
 btrfs-show-super.c    | 3 ++-
 btrfs-zero-log.c      | 2 +-
 btrfs.c               | 2 +-
 btrfstune.c           | 3 ++-
 mkfs.c                | 4 +++-
 13 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index a832ee0..6617f4a 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -438,7 +438,7 @@ int main(int argc, char **argv)
 	int opt;
 	int ret = 0;
 
-	while ((opt = getopt(argc, argv, "vb")) != -1) {
+	while ((opt = getopt(argc, argv, "vbh")) != -1) {
 		switch (opt) {
 			case 'v':
 				verbose++;
@@ -446,6 +446,7 @@ int main(int argc, char **argv)
 			case 'b':
 				no_pretty = 1;
 				break;
+			case 'h':
 			default:
 				usage();
 				exit(1);
diff --git a/btrfs-convert.c b/btrfs-convert.c
index ae10eed..fb5f1ab 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2704,7 +2704,7 @@ int main(int argc, char *argv[])
 	int rollback = 0;
 	char *file;
 	while(1) {
-		int c = getopt(argc, argv, "dinr");
+		int c = getopt(argc, argv, "dinrh");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2720,6 +2720,7 @@ int main(int argc, char *argv[])
 			case 'r':
 				rollback = 1;
 				break;
+			case 'h':
 			default:
 				print_usage();
 				return 1;
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index f0c14a9..2765ef7 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -720,7 +720,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:h", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -787,6 +787,7 @@ int main(int ac, char **av)
 					print_usage();
 				}
 				break;
+			case 'h':
 			default:
 				print_usage();
 		}
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 4a83770..7c1f487 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -140,7 +140,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "deb:rRu");
+		c = getopt(ac, av, "deb:rRuh");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -163,6 +163,7 @@ int main(int ac, char **av)
 			case 'b':
 				block_only = atoll(optarg);
 				break;
+			case 'h':
 			default:
 				print_usage();
 		}
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 7572f52..0680d6a 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -286,7 +286,7 @@ int main(int argc, char **argv)
 	int opt;
 	int ret;
 
-	while ((opt = getopt(argc, argv, "l:o:g:")) != -1) {
+	while ((opt = getopt(argc, argv, "l:o:g:h")) != -1) {
 		switch(opt) {
 			errno = 0;
 			case 'o':
@@ -315,6 +315,7 @@ int main(int argc, char **argv)
 					exit(1);
 				}
 				break;
+			case 'h':
 			default:
 				usage();
 				exit(1);
diff --git a/btrfs-image.c b/btrfs-image.c
index 7bcfc06..98f5864 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2475,7 +2475,7 @@ int main(int argc, char *argv[])
 	FILE *out;
 
 	while (1) {
-		int c = getopt(argc, argv, "rc:t:oswm");
+		int c = getopt(argc, argv, "rc:t:oswmh");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -2505,6 +2505,7 @@ int main(int argc, char *argv[])
 			create = 0;
 			multi_devices = 1;
 			break;
+		case 'h':
 		default:
 			print_usage();
 		}
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 51179a3..da8d896 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -107,6 +107,7 @@ static struct option long_options[] = {
 	{ "copy", 1, NULL, 'c' },
 	{ "output", 1, NULL, 'o' },
 	{ "bytes", 1, NULL, 'b' },
+	{ "help", 0, NULL, 'h' },
 	{ NULL, 0, NULL, 0}
 };
 
@@ -126,7 +127,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:o:b:", long_options,
+		c = getopt_long(ac, av, "l:c:o:b:h", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -158,6 +159,7 @@ int main(int ac, char **av)
 			case 'o':
 				output_file = strdup(optarg);
 				break;
+			case 'h':
 			default:
 				print_usage();
 		}
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 6a458b8..18ae7b2 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -48,7 +48,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "s:");
+		c = getopt(ac, av, "s:h");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -56,6 +56,7 @@ int main(int ac, char **av)
 				num = atol(optarg);
 				bytenr = btrfs_sb_offset(num);
 				break;
+			case 'h':
 			default:
 				print_usage();
 		}
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 0c3c73c..225cb84 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -62,7 +62,7 @@ int main(int argc, char **argv)
 	int arg, i;
 	u64 sb_bytenr = btrfs_sb_offset(0);
 
-	while ((opt = getopt(argc, argv, "ai:")) != -1) {
+	while ((opt = getopt(argc, argv, "ai:h")) != -1) {
 		switch (opt) {
 		case 'i':
 			arg = atoi(optarg);
@@ -81,6 +81,7 @@ int main(int argc, char **argv)
 			all = 1;
 			break;
 
+		case 'h':
 		default:
 			print_usage();
 			exit(1);
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index ab7f418..4ae468c 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -46,7 +46,7 @@ int main(int ac, char **av)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (ac != 2)
+	if (ac != 2 || !strcmp(av[1], "--help") || !strcmp(av[1], "-h"))
 		print_usage();
 
 	radix_tree_init();
diff --git a/btrfs.c b/btrfs.c
index d5fc738..7ca4427 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -112,7 +112,7 @@ static void handle_help_options_next_level(const struct cmd_struct *cmd,
 	if (argc < 2)
 		return;
 
-	if (!strcmp(argv[1], "--help")) {
+	if (!strcmp(argv[1], "--help") || !strcmp(argv[1], "-h")) {
 		if (cmd->next) {
 			argc--;
 			argv++;
diff --git a/btrfstune.c b/btrfstune.c
index 50724ba..47077f5 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -116,7 +116,7 @@ int main(int argc, char *argv[])
 	int ret;
 
 	while(1) {
-		int c = getopt(argc, argv, "S:rx");
+		int c = getopt(argc, argv, "S:rxh");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -130,6 +130,7 @@ int main(int argc, char *argv[])
 		case 'x':
 			skinny_flag = 1;
 			break;
+		case 'h':
 		default:
 			print_usage();
 			return 1;
diff --git a/mkfs.c b/mkfs.c
index 33369f9..f475b5d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -350,6 +350,7 @@ static struct option long_options[] = {
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
 	{ "features", 0, NULL, 'O' },
+	{ "help", 0, NULL, 'h' },
 	{ NULL, 0, NULL, 0}
 };
 
@@ -1264,7 +1265,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:VMK",
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:VMKh",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1336,6 +1337,7 @@ int main(int ac, char **av)
 			case 'K':
 				discard = 0;
 				break;
+			case 'h':
 			default:
 				print_usage();
 		}
-- 
Mitch
