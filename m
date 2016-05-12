Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.18.44]:54924 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcELTzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 15:55:21 -0400
From: btrfs@oss.m-berberich.de
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, M G Berberich <btrfs@oss.m-berberich.de>
Subject: [PATCH] btrfs-progs: added quiet-option for scripts
Date: Thu, 12 May 2016 21:49:25 +0200
Message-Id: <1463082565-17924-1-git-send-email-btrfs@oss.m-berberich.de>
In-Reply-To: <20160512114131.GO29353@twin.jikos.cz>
References: <20160512114131.GO29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: M G Berberich <btrfs@oss.m-berberich.de>

-q,--quiet to prevent status-messages on stderr
--verbose as alternative for -v
moved 'Mode NO_FILE_DATA enabled' message to stderr
changed default for g_verbose to 1
---
 cmds-send.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 4063475..81b086e 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -44,7 +44,9 @@
 #include "send.h"
 #include "send-utils.h"
 
-static int g_verbose = 0;
+/* default is 1 for historical reasons
+   changing may break scripts */
+static int g_verbose = 1;
 
 struct btrfs_send {
 	int send_fd;
@@ -301,10 +303,10 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 				"Try upgrading your kernel or don't use -e.\n");
 		goto out;
 	}
-	if (g_verbose > 0)
+	if (g_verbose > 1)
 		fprintf(stderr, "BTRFS_IOC_SEND returned %d\n", ret);
 
-	if (g_verbose > 0)
+	if (g_verbose > 1)
 		fprintf(stderr, "joining genl thread\n");
 
 	close(pipefd[1]);
@@ -429,9 +431,11 @@ int cmd_send(int argc, char **argv)
 	while (1) {
 		enum { GETOPT_VAL_SEND_NO_DATA = 256 };
 		static const struct option long_options[] = {
+			{ "verbose", no_argument, NULL, 'v' },
+			{ "quiet", no_argument, NULL, 'q' },
 			{ "no-data", no_argument, NULL, GETOPT_VAL_SEND_NO_DATA }
 		};
-		int c = getopt_long(argc, argv, "vec:f:i:p:", long_options, NULL);
+		int c = getopt_long(argc, argv, "vqec:f:i:p:", long_options, NULL);
 
 		if (c < 0)
 			break;
@@ -440,6 +444,9 @@ int cmd_send(int argc, char **argv)
 		case 'v':
 			g_verbose++;
 			break;
+		case 'q':
+			g_verbose--;
+			break;
 		case 'e':
 			new_end_cmd_semantic = 1;
 			break;
@@ -622,8 +629,8 @@ int cmd_send(int argc, char **argv)
 		}
 	}
 
-	if (send_flags & BTRFS_SEND_FLAG_NO_FILE_DATA)
-		printf("Mode NO_FILE_DATA enabled\n");
+	if ((send_flags & BTRFS_SEND_FLAG_NO_FILE_DATA) && g_verbose > 1)
+		fprintf(stderr, "Mode NO_FILE_DATA enabled\n");
 
 	for (i = optind; i < argc; i++) {
 		int is_first_subvol;
@@ -632,7 +639,8 @@ int cmd_send(int argc, char **argv)
 		free(subvol);
 		subvol = argv[i];
 
-		fprintf(stderr, "At subvol %s\n", subvol);
+		if (g_verbose > 0)
+			fprintf(stderr, "At subvol %s\n", subvol);
 
 		subvol = realpath(subvol, NULL);
 		if (!subvol) {
@@ -713,8 +721,9 @@ const char * const cmd_send_usage[] = {
 	"which case 'btrfs send' will determine a suitable parent among the",
 	"clone sources itself.",
 	"\n",
-	"-v               Enable verbose debug output. Each occurrence of",
+	"-v, --verbose    Enable verbose debug output. Each occurrence of",
 	"                 this option increases the verbose level more.",
+	"-q, --quiet      suppress messages to stderr.",
 	"-e               If sending multiple subvols at once, use the new",
 	"                 format and omit the end-cmd between the subvols.",
 	"-p <parent>      Send an incremental stream from <parent> to",
@@ -728,5 +737,6 @@ const char * const cmd_send_usage[] = {
 	"                 does not contain any file data and thus cannot be used",
 	"                 to transfer changes. This mode is faster and useful to",
 	"                 show the differences in metadata.",
+	"--help           display this help and exit",
 	NULL
 };
-- 
2.8.1

