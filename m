Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:64421 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077AbaDPN5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 09:57:05 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so11029729wes.32
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 06:57:04 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/4 v2] Btrfs-progs: send, implement fallocate command callback
Date: Wed, 16 Apr 2014 15:57:43 +0100
Message-Id: <1397660263-8098-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-3-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-3-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fallocate send stream command, added in stream version 2, is used to
pre-allocate space for files and punch file holes. This change implements
the callback for that new command, using the fallocate function from the
standard C library to carry out the specified action (allocate file space
or punch a file hole).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Use the new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE if the user
    asks for it (-a command line option), which will make the kernel generate
    a version 2 send stream, so that old clients aren't affected.

 Documentation/btrfs-send.txt |  3 +++
 cmds-receive.c               | 38 ++++++++++++++++++++++++++++++++++++++
 cmds-send.c                  | 12 ++++++++++--
 send-stream.c                | 13 +++++++++++++
 send-stream.h                |  2 ++
 5 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index 38470b0..e96be07 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -43,6 +43,9 @@ An alternative would be to use pipes.
 -o::
 Obtain the total data size for each subvolume or snapshot to send. This demands additional
 processing (mostly IO bound) but is useful for the receive command to report progress.
+-a::
+Use fallocate to pre-allocate file extents and to punch file holes, instead of writing zeroes
+to files.
 
 EXIT STATUS
 -----------
diff --git a/cmds-receive.c b/cmds-receive.c
index 19300fc..3f30066 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -41,6 +41,7 @@
 #include <sys/types.h>
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
+#include <linux/falloc.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -887,6 +888,42 @@ out:
 	return ret;
 }
 
+static int process_fallocate(const char *path, u32 flags, u64 offset,
+			     u64 len, void *user)
+{
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+	int mode = 0;
+	int ret;
+
+	if (flags & BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE)
+		mode |= FALLOC_FL_KEEP_SIZE;
+	if (flags & BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE)
+		mode |= FALLOC_FL_PUNCH_HOLE;
+
+	if (g_verbose >= 2)
+		fprintf(stderr,
+			"fallocate %s - flags %u, offset %llu, len %llu\n",
+			path, flags, offset, len);
+
+	ret = open_inode_for_write(r, full_path);
+	if (ret < 0)
+		goto out;
+
+	ret = fallocate(r->write_fd, mode, offset, len);
+	if (ret) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: fallocate against %s failed. %s\n",
+			path, strerror(-ret));
+		goto out;
+	}
+	update_progress(r, len);
+
+out:
+	free(full_path);
+	return ret;
+}
 
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
@@ -910,6 +947,7 @@ static struct btrfs_send_ops send_ops = {
 	.chown = process_chown,
 	.utimes = process_utimes,
 	.total_data_size = process_total_data_size,
+	.fallocate = process_fallocate,
 };
 
 static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
diff --git a/cmds-send.c b/cmds-send.c
index 69f5ba1..2a62e68 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -46,6 +46,7 @@
 
 static int g_verbose = 0;
 static int g_total_data_size = 0;
+static int g_fallocate = 0;
 
 struct btrfs_send {
 	int send_fd;
@@ -284,6 +285,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
 	if (g_total_data_size)
 		io_send.flags |= BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE;
+	if (g_fallocate)
+		io_send.flags |= BTRFS_SEND_FLAG_SUPPORT_FALLOCATE;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -427,7 +430,7 @@ int cmd_send(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "veoc:f:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "veoac:f:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -517,6 +520,9 @@ int cmd_send(int argc, char **argv)
 		case 'o':
 			g_total_data_size = 1;
 			break;
+		case 'a':
+			g_fallocate = 1;
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -679,7 +685,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-veo] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-veoa] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
@@ -707,5 +713,7 @@ const char * const cmd_send_usage[] = {
 	"                 snapshot to send. This demands additional processing",
 	"                 (mostly IO bound) but is useful for the receive ",
 	"                 command to report progress.",
+	"-a               Use fallocate to pre-allocate file extents and to",
+	"                 punch file holes, instead of writing zeroes to files.",
 	NULL
 };
diff --git a/send-stream.c b/send-stream.c
index 474d012..f117533 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -425,6 +425,19 @@ static int read_and_process_cmd(struct btrfs_send_stream *s)
 		TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &tmp);
 		ret = s->ops->total_data_size(tmp, s->user);
 		break;
+	case BTRFS_SEND_C_FALLOCATE:
+		{
+			u32 flags;
+			u64 len;
+
+			TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+			TLV_GET_U32(s, BTRFS_SEND_A_FALLOCATE_FLAGS, &flags);
+			TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
+			TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &len);
+			ret = s->ops->fallocate(path, flags, offset, len,
+						s->user);
+		}
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index 3a653a9..479e40c 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -55,6 +55,8 @@ struct btrfs_send_ops {
 		      void *user);
 	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
 	int (*total_data_size)(u64 size, void *user);
+	int (*fallocate)(const char *path, u32 flags, u64 offset,
+			 u64 len, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
-- 
1.9.1

