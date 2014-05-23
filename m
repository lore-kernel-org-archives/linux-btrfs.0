Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42539 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaEWSPJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 14:15:09 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so1254549wiw.3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 11:15:07 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: receive, allow to continue after errors happen
Date: Fri, 23 May 2014 20:14:56 +0100
Message-Id: <1400872496-7619-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Due to either bugs in send (kernel) that generate a command against
a wrong path for example, or transient errors on the receiving side,
we stopped processing the send stream immediately and exited with
an error.

It's often desirable to continue processing the send stream even if an
error happens while processing a single command from the send stream.

This change just adds a --max-errors <N> parameter, whose default value
is 1 (preserving current behaviour), that allows to tolerate N errors
before stopping. A value of 0 means to never stop no matter how many
errors we get into while processing the send stream. Regardless of its
value, errors are always printed to stderr when they happen, just like
before this change.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 Documentation/btrfs-receive.txt |  3 +++
 cmds-receive.c                  | 24 +++++++++++++++++++-----
 send-stream.c                   | 22 ++++++++++++++++++----
 send-stream.h                   |  3 ++-
 4 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/Documentation/btrfs-receive.txt b/Documentation/btrfs-receive.txt
index a67bc66..a87c086 100644
--- a/Documentation/btrfs-receive.txt
+++ b/Documentation/btrfs-receive.txt
@@ -38,6 +38,9 @@ Use this option to specify a file to use instead.
 Terminate after receiving an <end cmd> in the data stream.
 Without this option, the receiver terminates only if an error is recognized
 or on EOF.
+--max-errors <N>::
+Terminate as soon as N errors happened while processing commands from the send
+stream. Default value is 1. A value of 0 means no limit.
 
 EXIT STATUS
 -----------
diff --git a/cmds-receive.c b/cmds-receive.c
index 13db4c9..1aa4e52 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -33,6 +33,7 @@
 #include <wait.h>
 #include <assert.h>
 #include <time.h>
+#include <getopt.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -954,7 +955,8 @@ static struct btrfs_send_ops send_ops = {
 	.fallocate = process_fallocate,
 };
 
-static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
+static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
+		      u64 max_errors)
 {
 	int ret;
 	char *dest_dir_full_path;
@@ -1006,7 +1008,8 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 
 	while (!end) {
 		ret = btrfs_read_and_process_send_stream(r_fd, &send_ops, r,
-							 r->honor_end_cmd);
+							 r->honor_end_cmd,
+							 max_errors);
 		if (ret < 0)
 			goto out;
 		if (ret)
@@ -1049,6 +1052,11 @@ out:
 	return ret;
 }
 
+static const struct option long_opts[] = {
+	{ "max-errors", 1, NULL, 'E' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int cmd_receive(int argc, char **argv)
 {
 	int c;
@@ -1056,7 +1064,7 @@ int cmd_receive(int argc, char **argv)
 	char *fromfile = NULL;
 	struct btrfs_receive r;
 	int receive_fd = fileno(stdin);
-
+	u64 max_errors = 1;
 	int ret;
 
 	memset(&r, 0, sizeof(r));
@@ -1064,7 +1072,7 @@ int cmd_receive(int argc, char **argv)
 	r.write_fd = -1;
 	r.dest_dir_fd = -1;
 
-	while ((c = getopt(argc, argv, "evf:")) != -1) {
+	while ((c = getopt_long(argc, argv, "evf:", long_opts, NULL)) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -1075,6 +1083,9 @@ int cmd_receive(int argc, char **argv)
 		case 'e':
 			r.honor_end_cmd = 1;
 			break;
+		case 'E':
+			max_errors = arg_strtou64(optarg);
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: receive args invalid.\n");
@@ -1095,7 +1106,7 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	ret = do_receive(&r, tomnt, receive_fd);
+	ret = do_receive(&r, tomnt, receive_fd, max_errors);
 
 	return !!ret;
 }
@@ -1121,5 +1132,8 @@ const char * const cmd_receive_usage[] = {
 	"                 in the data stream. Without this option,",
 	"                 the receiver terminates only if an error",
 	"                 is recognized or on EOF.",
+	"--max-errors <N> Terminate as soon as N errors happened while",
+	"                 processing commands from the send stream.",
+	"                 Default value is 1. A value of 0 means no limit.",
 	NULL
 };
diff --git a/send-stream.c b/send-stream.c
index 812639f..a9acdf5 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -452,13 +452,21 @@ out:
 	return ret;
 }
 
+/*
+ * If max_errors is 0, then don't stop processing the stream if one of the
+ * callbacks in btrfs_send_ops structure returns an error. If greater than
+ * zero, stop after max_errors errors happened.
+ */
 int btrfs_read_and_process_send_stream(int fd,
 				       struct btrfs_send_ops *ops, void *user,
-				       int honor_end_cmd)
+				       int honor_end_cmd,
+				       u64 max_errors)
 {
 	int ret;
 	struct btrfs_send_stream s;
 	struct btrfs_stream_header hdr;
+	u64 errors = 0;
+	int last_err = 0;
 
 	s.fd = fd;
 	s.ops = ops;
@@ -488,9 +496,12 @@ int btrfs_read_and_process_send_stream(int fd,
 
 	while (1) {
 		ret = read_and_process_cmd(&s);
-		if (ret < 0)
-			goto out;
-		if (ret) {
+		if (ret < 0) {
+			last_err = ret;
+			errors++;
+			if (max_errors > 0 && errors >= max_errors)
+				goto out;
+		} else if (ret > 0) {
 			if (!honor_end_cmd)
 				ret = 0;
 			goto out;
@@ -498,5 +509,8 @@ int btrfs_read_and_process_send_stream(int fd,
 	}
 
 out:
+	if (last_err && !ret)
+		ret = last_err;
+
 	return ret;
 }
diff --git a/send-stream.h b/send-stream.h
index 479e40c..f20314b 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -61,7 +61,8 @@ struct btrfs_send_ops {
 
 int btrfs_read_and_process_send_stream(int fd,
 				       struct btrfs_send_ops *ops, void *user,
-				       int honor_end_cmd);
+				       int honor_end_cmd,
+				       u64 max_errors);
 
 #ifdef __cplusplus
 }
-- 
1.9.1

