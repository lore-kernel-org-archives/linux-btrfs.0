Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38395 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaDDOV1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 10:21:27 -0400
Received: by mail-wi0-f181.google.com with SMTP id hm4so1364172wib.2
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 07:21:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [RFC PATCH] Btrfs-progs: send, calculate and report progress based on the new flag
Date: Fri,  4 Apr 2014 16:21:01 +0100
Message-Id: <1396624861-1408-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a followup to the kernel patch titled:

    Btrfs: send, add calculate data size flag to allow for progress estimation

This makes the btrfs send and receive commands aware of the new send flag,
named BTRFS_SEND_C_TOTAL_DATA_SIZE, which tells us the amount of file data
that is new between the parent and send snapshots/roots. As this command
immediately follows the commands to start a snapshot/subvolume, it can be
used to report and compute progress, by keeping a counter that is incremented
with the data length of each write or clone command that is received from
the stream.

Example:

    $ btrfs send -o /mnt/sdd/base | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/base
    At subvol base
    About to receive 9211507211 bytes
    Subvolume/snapshot /mnt/sdc//base, progress  24.73%, 2278015008 bytes received (9211507211 total bytes)

    $ btrfs send -o -p /mnt/sdd/base /mnt/sdd/incr | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/incr
    At snapshot incr
    About to receive 9211747739 bytes
    Subvolume/snapshot /mnt/sdc//incr, progress  63.42%, 5843024211 bytes received (9211747739 total bytes)

At the moment progress is only reported by btrfs-receive, but it is possible and simple
to do it for btrfs-send too, so that we can get progress report when not piping btrfs-send
output to btrfs-receive (directly to a file).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-receive.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-send.c    | 14 ++++++++++++--
 ioctl.h        |  7 +++++++
 send-stream.c  |  4 ++++
 send-stream.h  |  1 +
 send.h         |  1 +
 6 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index d6cd3da..5de24c3 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -71,6 +71,11 @@ struct btrfs_receive
 	struct subvol_uuid_search sus;
 
 	int honor_end_cmd;
+
+	/* For the subvolume/snapshot we're currently receiving. */
+	u64 total_data_size;
+	u64 bytes_received;
+	float progress;
 };
 
 static int finish_subvol(struct btrfs_receive *r)
@@ -156,6 +161,9 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->total_data_size = 0;
+	r->bytes_received = 0;
+	r->progress = 0.0;
 
 	if (strlen(r->dest_dir_path) == 0)
 		r->cur_subvol->path = strdup(path);
@@ -205,6 +213,9 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->total_data_size = 0;
+	r->bytes_received = 0;
+	r->progress = 0.0;
 
 	if (strlen(r->dest_dir_path) == 0)
 		r->cur_subvol->path = strdup(path);
@@ -287,6 +298,41 @@ out:
 	return ret;
 }
 
+static int process_total_data_size(u64 size, void *user)
+{
+	struct btrfs_receive *r = user;
+
+	r->total_data_size = size;
+
+	fprintf(stdout, "About to receive %llu bytes\n", size);
+
+	return 0;
+}
+
+static void update_progress(struct btrfs_receive *r, u64 bytes)
+{
+	float new_progress;
+
+	if (r->total_data_size == 0)
+		return;
+
+	r->bytes_received += bytes;
+	new_progress = ((float)r->bytes_received / r->total_data_size) * 100.0;
+
+	if ((int)(new_progress * 100) > (int)(r->progress * 100) ||
+	    r->bytes_received == r->total_data_size)
+		fprintf(stdout,
+			"%sSubvolume/snapshot %s, progress %6.2f%%, %llu bytes received (%llu total bytes)%s",
+			(g_verbose ? "" : "\r"),
+			r->full_subvol_path, new_progress,
+			r->bytes_received, r->total_data_size,
+			(g_verbose ? "\n" : ""));
+	if (r->bytes_received == r->total_data_size)
+		fprintf(stdout, "\n");
+
+	r->progress = new_progress;
+}
+
 static int process_mkfile(const char *path, void *user)
 {
 	int ret;
@@ -562,6 +608,7 @@ static int process_write(const char *path, const void *data, u64 offset,
 		}
 		pos += w;
 	}
+	update_progress(r, len);
 
 out:
 	free(full_path);
@@ -638,6 +685,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 				path, strerror(-ret));
 		goto out;
 	}
+	update_progress(r, len);
 
 out:
 	if (si) {
@@ -819,6 +867,7 @@ static struct btrfs_send_ops send_ops = {
 	.chmod = process_chmod,
 	.chown = process_chown,
 	.utimes = process_utimes,
+	.total_data_size = process_total_data_size
 };
 
 static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
diff --git a/cmds-send.c b/cmds-send.c
index dcb6607..e207ed3 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -45,6 +45,7 @@
 #include "send-utils.h"
 
 static int g_verbose = 0;
+static int get_total_data_size = 0;
 
 struct btrfs_send {
 	int send_fd;
@@ -284,6 +285,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_STREAM_HEADER;
 	if (!is_last_subvol)
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
+	if (get_total_data_size)
+		io_send.flags |= BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -429,7 +432,7 @@ int cmd_send(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "vec:f:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "veoc:f:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -516,6 +519,9 @@ int cmd_send(int argc, char **argv)
 				"ERROR: -i was removed, use -c instead\n");
 			ret = 1;
 			goto out;
+		case 'o':
+			get_total_data_size = 1;
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -678,7 +684,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-veo] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
@@ -702,5 +708,9 @@ const char * const cmd_send_usage[] = {
 	"-f <outfile>     Output is normally written to stdout. To write to",
 	"                 a file, use this option. An alternative would be to",
 	"                 use pipes.",
+	"-o               Obtain the total data size for each subvolume or ",
+	"                 snapshot to send. This demands additional processing",
+	"                 (mostly IO bound) but is useful for the receive ",
+	"                 command to report progress.",
 	NULL
 };
diff --git a/ioctl.h b/ioctl.h
index 402317f..cc36661 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -388,6 +388,13 @@ struct btrfs_ioctl_received_subvol_args {
  */
 #define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
 
+/*
+ * The total amount of data the receiver will get in write and clone commands.
+ * This can be used by the receiver to compute progress, at the expense of some
+ * initial metadata scan performed by the sender (kernel).
+ */
+#define BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE	0x8
+
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
 	__u64 clone_sources_count;	/* in */
diff --git a/send-stream.c b/send-stream.c
index 88e18e2..474d012 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -421,6 +421,10 @@ static int read_and_process_cmd(struct btrfs_send_stream *s)
 		TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &tmp);
 		ret = s->ops->update_extent(path, offset, tmp, s->user);
 		break;
+	case BTRFS_SEND_C_TOTAL_DATA_SIZE:
+		TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &tmp);
+		ret = s->ops->total_data_size(tmp, s->user);
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index 17bc669..3a653a9 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -54,6 +54,7 @@ struct btrfs_send_ops {
 		      struct timespec *mt, struct timespec *ct,
 		      void *user);
 	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
+	int (*total_data_size)(u64 size, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
diff --git a/send.h b/send.h
index e8da785..943b0b6 100644
--- a/send.h
+++ b/send.h
@@ -91,6 +91,7 @@ enum btrfs_send_cmd {
 
 	BTRFS_SEND_C_END,
 	BTRFS_SEND_C_UPDATE_EXTENT,
+	BTRFS_SEND_C_TOTAL_DATA_SIZE,
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
-- 
1.9.1

