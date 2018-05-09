Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:46227 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbeEICLt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 22:11:49 -0400
Received: by mail-io0-f195.google.com with SMTP id f21-v6so40881662iob.13
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 19:11:49 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        Filipe Manana <fdmanana@gmail.com>
Subject: [RFC PATCH 1/6] Btrfs-progs: send, bump stream version
Date: Tue,  8 May 2018 22:11:32 -0400
Message-Id: <20180509021137.8342-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@gmail.com>

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
 cmds-send.c   | 61 ++++++++++++++++++++++++++++++++++++---------------
 ioctl.h       | 15 +++++++++++++
 send-stream.c |  2 +-
 send.h        | 23 ++++++++++++++++++-
 4 files changed, 81 insertions(+), 20 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index c5ecdaa1..0ec557c7 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -52,6 +52,7 @@
  * the 'At subvol' message.
  */
 static int g_verbose = 1;
+static int g_stream_version = BTRFS_SEND_STREAM_VERSION_1;
 
 struct btrfs_send {
 	int send_fd;
@@ -343,6 +344,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_STREAM_HEADER;
 	if (!is_last_subvol)
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
+	if (g_stream_version == BTRFS_SEND_STREAM_VERSION_2)
+		io_send.flags |= BTRFS_SEND_FLAG_STREAM_V2;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret < 0) {
 		ret = -errno;
@@ -513,7 +516,8 @@ int cmd_send(int argc, char **argv)
 		static const struct option long_options[] = {
 			{ "verbose", no_argument, NULL, 'v' },
 			{ "quiet", no_argument, NULL, 'q' },
-			{ "no-data", no_argument, NULL, GETOPT_VAL_SEND_NO_DATA }
+			{ "no-data", no_argument, NULL, GETOPT_VAL_SEND_NO_DATA },
+			{ "stream-version", 1, NULL, 'V' },
 		};
 		int c = getopt_long(argc, argv, "vqec:f:i:p:", long_options, NULL);
 
@@ -597,6 +601,24 @@ int cmd_send(int argc, char **argv)
 			error("option -i was removed, use -c instead");
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
 		case GETOPT_VAL_SEND_NO_DATA:
 			send_flags |= BTRFS_SEND_FLAG_NO_FILE_DATA;
 			break;
@@ -776,7 +798,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-ve] [--stream-version <version>] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"<subvol> should be read-only here.",
@@ -790,21 +812,24 @@ const char * const cmd_send_usage[] = {
 	"which case 'btrfs send' will determine a suitable parent among the",
 	"clone sources itself.",
 	"\n",
-	"-e               If sending multiple subvols at once, use the new",
-	"                 format and omit the end-cmd between the subvols.",
-	"-p <parent>      Send an incremental stream from <parent> to",
-	"                 <subvol>.",
-	"-c <clone-src>   Use this snapshot as a clone source for an ",
-	"                 incremental send (multiple allowed)",
-	"-f <outfile>     Output is normally written to stdout. To write to",
-	"                 a file, use this option. An alternative would be to",
-	"                 use pipes.",
-	"--no-data        send in NO_FILE_DATA mode, Note: the output stream",
-	"                 does not contain any file data and thus cannot be used",
-	"                 to transfer changes. This mode is faster and useful to",
-	"                 show the differences in metadata.",
-	"-v|--verbose     enable verbose output to stderr, each occurrence of",
-	"                 this option increases verbosity",
-	"-q|--quiet       suppress all messages, except errors",
+	"-e                          If sending multiple subvols at once, use the new",
+	"                            format and omit the end-cmd between the subvols.",
+	"-p <parent>                 Send an incremental stream from <parent> to",
+	"                            <subvol>.",
+	"-c <clone-src>              Use this snapshot as a clone source for an ",
+	"                            incremental send (multiple allowed)",
+	"-f <outfile>                Output is normally written to stdout. To write to",
+	"                            a file, use this option. An alternative would be to",
+	"                            use pipes.",
+	"--no-data                   send in NO_FILE_DATA mode, Note: the output stream",
+	"                            does not contain any file data and thus cannot be used",
+	"                            to transfer changes. This mode is faster and useful to",
+	"                            show the differences in metadata.",
+	"-v|--verbose                enable verbose output to stderr, each occurrence of",
+	"                            this option increases verbosity",
+	"-q|--quiet       	     suppress all messages, except errors",
+	"--stream-version <version>  Ask the kernel to produce a specific send stream",
+	"                            version. More recent stream versions provide new",
+	"                            features and better performance. Default value is 1.",
 	NULL
 };
diff --git a/ioctl.h b/ioctl.h
index 709e996f..9d490aca 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -632,6 +632,21 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_received_subvol_args_32) == 192);
 	 BTRFS_SEND_FLAG_OMIT_STREAM_HEADER | \
 	 BTRFS_SEND_FLAG_OMIT_END_CMD)
 
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
index 78f2571a..86956d28 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -503,7 +503,7 @@ int btrfs_read_and_process_send_stream(int fd,
 	}
 
 	sctx.version = le32_to_cpu(hdr.version);
-	if (sctx.version > BTRFS_SEND_STREAM_VERSION) {
+	if (sctx.version > BTRFS_SEND_STREAM_VERSION_MAX) {
 		ret = -EINVAL;
 		error("stream version %d not supported, please use newer version",
 				sctx.version);
diff --git a/send.h b/send.h
index fe613cbb..eb14fba3 100644
--- a/send.h
+++ b/send.h
@@ -27,7 +27,10 @@ extern "C" {
 #endif
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
-#define BTRFS_SEND_STREAM_VERSION 1
+#define BTRFS_SEND_STREAM_VERSION_1 1
+#define BTRFS_SEND_STREAM_VERSION_2 2
+/* Max supported stream version. */
+#define BTRFS_SEND_STREAM_VERSION_MAX BTRFS_SEND_STREAM_VERSION_2
 
 #define BTRFS_SEND_BUF_SIZE SZ_64K
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
@@ -94,6 +97,15 @@ enum btrfs_send_cmd {
 
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
@@ -132,10 +144,19 @@ enum {
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
2.17.0

