Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31228 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S935205AbcIGA3p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 20:29:45 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id C64274042402
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 08:29:38 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam and dump send stream
Date: Wed, 7 Sep 2016 08:29:34 +0800
Message-ID: <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new option, '--dump' for receive subcommand.

With this command, user can exam and dump the metadata info of a send
stream.
Which is quite useful for education purpose or bug reporting.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-receive.asciidoc | 17 +++++++++++++--
 cmds-receive.c                       | 41 ++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index e246603..e4e3ba4 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -3,18 +3,25 @@ btrfs-receive(8)
 
 NAME
 ----
-btrfs-receive - receive subvolumes from send stream
+btrfs-receive - receive/exam subvolumes from send stream
 
 SYNOPSIS
 --------
 *btrfs receive* [options] <path>
 
+or
+
+*btrfs receive* --dump [options]
+
 DESCRIPTION
 -----------
 
 Receive a stream of changes and replicate one or more subvolumes that were
 previously used with *btrfs send* The received subvolumes are stored to
-'path'.
+'path', if '--dump' option is not given.
+
+If '--dump' option is given, *btrfs receive* will only exam the validation of
+the stream, and print the metadata info for debug usage.
 
 *btrfs receive* will fail int the following cases:
 
@@ -56,6 +63,12 @@ By default the mountpoint is searched in '/proc/self/mounts'.
 If you do not have '/proc', eg. in a chroot environment, use this option to tell
 us where this filesystem is mounted.
 
+--dump::
+exam the stream and print metadata info for debug/education purpose.
++
+Does not accept 'path' parameter. So with this option, *btrfs receive* won't
+modify your filesystem, and can be run by non-privileged users.
+
 EXIT STATUS
 -----------
 *btrfs receive* returns a zero exit status if it succeeds. Non zero is
diff --git a/cmds-receive.c b/cmds-receive.c
index f4a3a4f..32bf086 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -49,6 +49,7 @@
 #include "send.h"
 #include "send-stream.h"
 #include "send-utils.h"
+#include "send-dump.h"
 
 static int g_verbose = 0;
 
@@ -1194,6 +1195,7 @@ int cmd_receive(int argc, char **argv)
 	struct btrfs_receive r;
 	int receive_fd = fileno(stdin);
 	u64 max_errors = 1;
+	int dump = 0;
 	int ret = 0;
 
 	memset(&r, 0, sizeof(r));
@@ -1206,9 +1208,11 @@ int cmd_receive(int argc, char **argv)
 
 	while (1) {
 		int c;
+		enum { GETOPT_VAL_DUMP = 257 };
 		static const struct option long_opts[] = {
 			{ "max-errors", required_argument, NULL, 'E' },
 			{ "chroot", no_argument, NULL, 'C' },
+			{ "dump", no_argument, NULL, GETOPT_VAL_DUMP },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -1245,6 +1249,9 @@ int cmd_receive(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case GETOPT_VAL_DUMP:
+			dump = 1;
+			break;
 		case '?':
 		default:
 			error("receive args invalid");
@@ -1252,7 +1259,9 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_exact(argc - optind, 1))
+	if (dump && check_argc_exact(argc - optind, 0))
+		usage(cmd_receive_usage);
+	if (!dump && check_argc_exact(argc - optind, 1))
 		usage(cmd_receive_usage);
 
 	tomnt = argv[optind];
@@ -1265,19 +1274,37 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
+	if (dump) {
+		struct btrfs_dump_send_args dump_args;
+
+		dump_args.root_path = malloc(PATH_MAX);
+		dump_args.root_path[0] = '.';
+		dump_args.root_path[1] = '\0';
+		dump_args.full_subvol_path = malloc(PATH_MAX);
+		dump_args.full_subvol_path[0] = '.';
+		dump_args.full_subvol_path[1] = '\0';
+		ret = btrfs_read_and_process_send_stream(receive_fd,
+				&btrfs_print_send_ops, &dump_args, 0, 0);
+		if (ret < 0)
+			error("failed to dump the send stream: %s",
+			      strerror(-ret));
+	} else {
+		ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
+	}
+
 	if (receive_fd != fileno(stdin))
 		close(receive_fd);
-
 out:
 
 	return !!ret;
 }
 
 const char * const cmd_receive_usage[] = {
-	"btrfs receive [-ve] [-f <infile>] [--max-errors <N>] <mount>",
-	"Receive subvolumes from stdin.",
-	"Receives one or more subvolumes that were previously",
+	"btrfs receive [options] <mount>",
+	"or"
+	"btrfs receive --dump [options]",
+	"Receive/exam subvolumes from stdin.",
+	"Receives/exams one or more subvolumes that were previously",
 	"sent with btrfs send. The received subvolumes are stored",
 	"into <mount>.",
 	"btrfs receive will fail in case a receiving subvolume",
@@ -1302,5 +1329,7 @@ const char * const cmd_receive_usage[] = {
 	"-m <mountpoint>  The root mount point of the destination fs.",
 	"                 If you do not have /proc use this to tell us where ",
 	"                 this file system is mounted.",
+	"--dump           Exam and output metadata info of send stream.",
+	"                 Don't need <mount> parameter.",
 	NULL
 };
-- 
2.9.3



