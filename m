Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51195 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLOUBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:01:42 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so15556841wgg.7
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:01:40 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/7] Add -v -q switches to mkfs.btrfs.
Date: Mon, 15 Dec 2014 21:02:54 +0100
Message-Id: <1418673780-22000-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add -v -q switches to mkfs.btrfs, to control the verbosity of mkfs.btrfs.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 mkfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index e10e62d..26f8041 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -288,8 +288,10 @@ static void print_usage(void)
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "\t -O --features comma separated list of filesystem features\n");
+	fprintf(stderr, "\t -q --quiet enable quiet mode\n");
 	fprintf(stderr, "\t -U --uuid specify the filesystem UUID\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
+	fprintf(stderr, "\t -v --verbose enable verbose mode\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -351,6 +353,8 @@ static struct option long_options[] = {
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
+	{ "verbose", 0, NULL, 'v' },
+	{ "quiet", 0, NULL, 'q' },
 	{ "features", 1, NULL, 'O' },
 	{ "uuid", required_argument, NULL, 'U' },
 	{ NULL, 0, NULL, 0}
@@ -998,7 +1002,7 @@ out:
  * This ignores symlinks with unreadable targets and subdirs that can't
  * be read.  It's a best-effort to give a rough estimate of the size of
  * a subdir.  It doesn't guarantee that prepopulating btrfs from this
- * tree won't still run out of space. 
+ * tree won't still run out of space.
  *
  * The rounding up to 4096 is questionable.  Previous code used du -B 4096.
  */
@@ -1266,6 +1270,8 @@ int main(int ac, char **av)
 	int discard = 1;
 	int ssd = 0;
 	int force_overwrite = 0;
+	int verbose = 0;
+	int quiet = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1355,6 +1361,12 @@ int main(int ac, char **av)
 			case 'K':
 				discard = 0;
 				break;
+			case 'v':
+				verbose = 1;
+				break;
+			case 'q':
+				quiet = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -1387,7 +1399,7 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
-	
+
 	while (dev_cnt-- > 0) {
 		file = av[optind++];
 		if (is_block_device(file))
-- 
2.1.3

