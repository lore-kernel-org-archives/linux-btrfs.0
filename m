Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51486 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbcKCEIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 00:08:10 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v4 3/4] btrfs-progs: receive: introduce option to dump send stream
Date: Thu,  3 Nov 2016 12:07:33 +0800
Message-Id: <20161103040734.8098-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new option, '--dump' for receive subcommand.

With this command, user can dump the metadata of a send stream.
Which is quite useful for education purpose or bug reporting.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-receive.asciidoc | 15 ++++++++++++++-
 cmds-receive.c                       | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index e246603..f12e949 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -9,12 +9,19 @@ SYNOPSIS
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
+If '--dump' option is given, *btrfs receive* will only do the validation of
+the stream, and print the stream metadata.
 
 *btrfs receive* will fail int the following cases:
 
@@ -56,6 +63,12 @@ By default the mountpoint is searched in '/proc/self/mounts'.
 If you do not have '/proc', eg. in a chroot environment, use this option to tell
 us where this filesystem is mounted.
 
+--dump::
+print the stream metadata
++
+Does not accept the 'path' parameter. So with this option, *btrfs receive* won't
+modify your filesystem, and can be run by non-privileged users.
+
 EXIT STATUS
 -----------
 *btrfs receive* returns a zero exit status if it succeeds. Non zero is
diff --git a/cmds-receive.c b/cmds-receive.c
index d0525bf..1dcdb1a 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -49,6 +49,7 @@
 #include "send.h"
 #include "send-stream.h"
 #include "send-utils.h"
+#include "send-dump.h"
 
 static int g_verbose = 0;
 
@@ -1214,6 +1215,7 @@ int cmd_receive(int argc, char **argv)
 	struct btrfs_receive r;
 	int receive_fd = fileno(stdin);
 	u64 max_errors = 1;
+	int dump = 0;
 	int ret = 0;
 
 	memset(&r, 0, sizeof(r));
@@ -1226,9 +1228,11 @@ int cmd_receive(int argc, char **argv)
 
 	while (1) {
 		int c;
+		enum { GETOPT_VAL_DUMP = 257 };
 		static const struct option long_opts[] = {
 			{ "max-errors", required_argument, NULL, 'E' },
 			{ "chroot", no_argument, NULL, 'C' },
+			{ "dump", no_argument, NULL, GETOPT_VAL_DUMP },
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -1265,6 +1269,9 @@ int cmd_receive(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case GETOPT_VAL_DUMP:
+			dump = 1;
+			break;
 		case '?':
 		default:
 			error("receive args invalid");
@@ -1272,7 +1279,9 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_exact(argc - optind, 1))
+	if (dump && check_argc_exact(argc - optind, 0))
+		usage(cmd_receive_usage);
+	if (!dump && check_argc_exact(argc - optind, 1))
 		usage(cmd_receive_usage);
 
 	tomnt = argv[optind];
@@ -1285,17 +1294,33 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
+	if (dump) {
+		struct btrfs_dump_send_args dump_args;
+
+		dump_args.root_path[0] = '.';
+		dump_args.root_path[1] = '\0';
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
+	"btrfs receive [options] <mount>",
+	"or",
+	"btrfs receive --dump [options]",
 	"Receive subvolumes from stdin.",
 	"Receives one or more subvolumes that were previously",
 	"sent with btrfs send. The received subvolumes are stored",
@@ -1322,5 +1347,7 @@ const char * const cmd_receive_usage[] = {
 	"-m <mountpoint>  The root mount point of the destination fs.",
 	"                 If you do not have /proc use this to tell us where ",
 	"                 this file system is mounted.",
+	"--dump           Exam and output metadata info of send stream.",
+	"                 Don't need <mount> parameter.",
 	NULL
 };
-- 
2.10.1



