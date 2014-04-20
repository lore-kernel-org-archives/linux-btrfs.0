Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:45105 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaDTNKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 09:10:03 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so2865976wes.26
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 06:10:01 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/4 v3] Btrfs-progs: send, bump stream version
Date: Sun, 20 Apr 2014 15:09:42 +0100
Message-Id: <1398002982-12138-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This increases the send stream version from version 1 to version 2, adding
new commands:

1) total data size - used to tell the receiver how much file data the stream
   will add or update;

2) fallocate - used to pre-allocate space for files and to punch holes in files;

3) inode set flags;

4) set inode otime.

This is preparation work for subsequent changes that implement the new features.

This doesn't break compatibility with older kernels or clients. In order to get
a version 2 send stream, new flags must be passed to the send ioctl.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE. A version 2
    stream is now only produced is the ioctl caller specifies at least one of
    the new send flags (BTRFS_SEND_FLAG_SUPPORT_FALLOCATE or
    BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE).
V3: Removed BTRFS_SEND_FLAG_SUPPORT_FALLOCATE flag and -a command line option
    for btrfs-send. Both were replaced with BTRFS_SEND_FLAG_STREAM_V2 and
    --stream-version=<version_number> respectively. Added commands for inode
    sets flags and otime too.

 Documentation/btrfs-send.txt |  3 +++
 cmds-send.c                  | 57 ++++++++++++++++++++++++++++++++++----------
 ioctl.h                      | 15 ++++++++++++
 send-stream.c                |  2 +-
 send.h                       | 23 +++++++++++++++++-
 5 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index 18a98fa..067fc27 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -40,6 +40,9 @@ Use this snapshot as a clone source for an incremental send (multiple allowed).
 -f <outfile>::
 Output is normally written to stdout. To write to a file, use this option.
 An alternative would be to use pipes.
+--stream-version <version>::
+Ask the kernel to produce a specific send stream version. More recent stream versions provide
+new features and better performance. Default value is 1.
 
 EXIT STATUS
 -----------
diff --git a/cmds-send.c b/cmds-send.c
index 1cd457d..bd575f8 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -32,6 +32,7 @@
 #include <libgen.h>
 #include <mntent.h>
 #include <assert.h>
+#include <getopt.h>
 
 #include <uuid/uuid.h>
 
@@ -45,6 +46,7 @@
 #include "send-utils.h"
 
 static int g_verbose = 0;
+static int g_stream_version = BTRFS_SEND_STREAM_VERSION_1;
 
 struct btrfs_send {
 	int send_fd;
@@ -281,6 +283,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_STREAM_HEADER;
 	if (!is_last_subvol)
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
+	if (g_stream_version == BTRFS_SEND_STREAM_VERSION_2)
+		io_send.flags |= BTRFS_SEND_FLAG_STREAM_V2;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -406,6 +410,11 @@ out:
 	return ret;
 }
 
+static const struct option long_options[] = {
+	{ "stream-version", 1, NULL, 'V' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int cmd_send(int argc, char **argv)
 {
 	char *subvol = NULL;
@@ -424,7 +433,8 @@ int cmd_send(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "vec:f:i:p:")) != -1) {
+	while ((c = getopt_long(argc, argv, "vec:f:i:p:",
+				long_options, NULL)) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -511,6 +521,24 @@ int cmd_send(int argc, char **argv)
 				"ERROR: -i was removed, use -c instead\n");
 			ret = 1;
 			goto out;
+		case 'V':
+			if (sscanf(optarg, "%d", &g_stream_version) != 1) {
+				fprintf(stderr,
+					"ERROR: invalid value for stream version: %s\n",
+					optarg);
+				ret = 1;
+				goto out;
+			}
+			if (g_stream_version <= 0 ||
+			    g_stream_version > BTRFS_SEND_STREAM_VERSION_MAX) {
+				fprintf(stderr,
+					"ERROR: unsupported stream version %d, minimum: 1, maximum: %d\n",
+					g_stream_version,
+					BTRFS_SEND_STREAM_VERSION_MAX);
+				ret = 1;
+				goto out;
+			}
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -673,7 +701,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-ve] [--stream-version <version>] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
@@ -686,16 +714,19 @@ const char * const cmd_send_usage[] = {
 	"which case 'btrfs send' will determine a suitable parent among the",
 	"clone sources itself.",
 	"\n",
-	"-v               Enable verbose debug output. Each occurrence of",
-	"                 this option increases the verbose level more.",
-	"-e               If sending multiple subvols at once, use the new",
-	"                 format and omit the end-cmd between the subvols.",
-	"-p <parent>      Send an incremental stream from <parent> to",
-	"                 <subvol>.",
-	"-c <clone-src>   Use this snapshot as a clone source for an ",
-	"                 incremental send (multiple allowed)",
-	"-f <outfile>     Output is normally written to stdout. To write to",
-	"                 a file, use this option. An alternative would be to",
-	"                 use pipes.",
+	"-v                          Enable verbose debug output. Each occurrence of",
+	"                            this option increases the verbose level more.",
+	"-e                          If sending multiple subvols at once, use the new",
+	"                            format and omit the end-cmd between the subvols.",
+	"-p <parent>                 Send an incremental stream from <parent> to",
+	"                            <subvol>.",
+	"-c <clone-src>              Use this snapshot as a clone source for an ",
+	"                            incremental send (multiple allowed)",
+	"-f <outfile>                Output is normally written to stdout. To write to",
+	"                            a file, use this option. An alternative would be to",
+	"                            use pipes.",
+	"--stream-version <version>  Ask the kernel to produce a specific send stream",
+	"                            version. More recent stream versions provide new",
+	"                            features and better performance. Default value is 1.",
 	NULL
 };
diff --git a/ioctl.h b/ioctl.h
index 231660a..933eb01 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -392,6 +392,21 @@ struct btrfs_ioctl_received_subvol_args {
  */
 #define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
 
+/*
+ * The sum of all length fields the receiver will get in write, clone and
+ * fallocate commands.
+ * This can be used by the receiver to compute progress, at the expense of some
+ * initial metadata scan performed by the sender (kernel).
+ *
+ * Added in send stream version 2.
+ */
+#define BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE	0x8
+
+/*
+ * Used by a client to request a version 2 of the send stream.
+ */
+#define BTRFS_SEND_FLAG_STREAM_V2               0x10
+
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
 	__u64 clone_sources_count;	/* in */
diff --git a/send-stream.c b/send-stream.c
index 88e18e2..60c2126 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -462,7 +462,7 @@ int btrfs_read_and_process_send_stream(int fd,
 	}
 
 	s.version = le32_to_cpu(hdr.version);
-	if (s.version > BTRFS_SEND_STREAM_VERSION) {
+	if (s.version > BTRFS_SEND_STREAM_VERSION_MAX) {
 		ret = -EINVAL;
 		fprintf(stderr, "ERROR: Stream version %d not supported. "
 				"Please upgrade btrfs-progs\n", s.version);
diff --git a/send.h b/send.h
index e8da785..ea56965 100644
--- a/send.h
+++ b/send.h
@@ -24,7 +24,10 @@ extern "C" {
 #endif
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
-#define BTRFS_SEND_STREAM_VERSION 1
+#define BTRFS_SEND_STREAM_VERSION_1 1
+#define BTRFS_SEND_STREAM_VERSION_2 2
+/* Max supported stream version. */
+#define BTRFS_SEND_STREAM_VERSION_MAX BTRFS_SEND_STREAM_VERSION_2
 
 #define BTRFS_SEND_BUF_SIZE (1024 * 64)
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
@@ -91,6 +94,15 @@ enum btrfs_send_cmd {
 
 	BTRFS_SEND_C_END,
 	BTRFS_SEND_C_UPDATE_EXTENT,
+
+	/*
+	 * The following commands were added in stream version 2.
+	 */
+	BTRFS_SEND_C_TOTAL_DATA_SIZE,
+	BTRFS_SEND_C_FALLOCATE,
+	BTRFS_SEND_C_INODE_SET_FLAGS,
+	BTRFS_SEND_C_UTIMES2, /* Same as UTIMES, but it includes OTIME too. */
+
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
@@ -129,10 +141,19 @@ enum {
 	BTRFS_SEND_A_CLONE_OFFSET,
 	BTRFS_SEND_A_CLONE_LEN,
 
+	/*
+	 * The following attributes were added in stream version 2.
+	 */
+	BTRFS_SEND_A_FALLOCATE_FLAGS, /* 32 bits */
+	BTRFS_SEND_A_INODE_FLAGS,     /* 32 bits */
+
 	__BTRFS_SEND_A_MAX,
 };
 #define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)
 
+#define BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE   (1 << 0)
+#define BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE  (1 << 1)
+
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
 #endif
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
