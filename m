Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab3EOWcL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 18:32:11 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Peter Stuge <peter@stuge.se>
Subject: [PATCH] btrfs-progs: restore: use long option for the path regex
Date: Thu, 16 May 2013 00:32:02 +0200
Message-Id: <1368657122-13323-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current way of specifying the path to match is not very comfortable, but
the feature itself is very useful. Let's save the short option -m for a
more user friendly syntax and keep a long option --path-regex with the
current syntax.

CC: Peter Stuge <peter@stuge.se>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-restore.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 52852bc..8a4f75a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -32,6 +32,7 @@
 #include <lzo/lzo1x.h>
 #include <zlib.h>
 #include <regex.h>
+#include <getopt.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -924,6 +925,11 @@ out:
 	return ret;
 }
 
+static struct option long_options[] = {
+	{ "path-regex", 1, NULL, 256},
+	{ 0, 0, 0, 0}
+};
+
 const char * const cmd_restore_usage[] = {
 	"btrfs restore [options] <device>",
 	"Try to restore files from a damaged filesystem (unmounted)",
@@ -936,6 +942,10 @@ const char * const cmd_restore_usage[] = {
 	"-f <offset>     filesystem location",
 	"-u <block>      super mirror",
 	"-d              find dir",
+	"--path-regex <regex>",
+	"                restore only filenames matching regex,",
+	"                you have to use following syntax (possibly quoted):",
+	"                ^/(|home(|/username(|/Desktop(|/.*))))$",
 	NULL
 };
 
@@ -950,6 +960,7 @@ int cmd_restore(int argc, char **argv)
 	int len;
 	int ret;
 	int opt;
+	int option_index = 0;
 	int super_mirror = 0;
 	int find_dir = 0;
 	int list_roots = 0;
@@ -958,7 +969,8 @@ int cmd_restore(int argc, char **argv)
 	regex_t match_reg, *mreg = NULL;
 	char reg_err[256];
 
-	while ((opt = getopt(argc, argv, "sviot:u:df:r:lcm:")) != -1) {
+	while ((opt = getopt_long(argc, argv, "sviot:u:df:r:lc", long_options,
+					&option_index)) != -1) {
 
 		switch (opt) {
 			case 's':
@@ -1016,7 +1028,8 @@ int cmd_restore(int argc, char **argv)
 			case 'c':
 				match_cflags |= REG_ICASE;
 				break;
-			case 'm':
+			/* long option without single letter alternative */
+			case 256:
 				match_regstr = optarg;
 				break;
 			default:
-- 
1.8.2

