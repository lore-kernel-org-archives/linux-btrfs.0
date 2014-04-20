Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60264 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaDTNLJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 09:11:09 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so1928132wgh.5
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 06:11:07 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/4 v4] Btrfs-progs: send, implement total data size callback and progress report
Date: Sun, 20 Apr 2014 15:10:57 +0100
Message-Id: <1398003057-12224-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-2-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a followup to the kernel patch titled:

    Btrfs: send, implement total data size command to allow for progress estimation

This makes the btrfs send and receive commands aware of the new send flag,
named BTRFS_SEND_C_TOTAL_DATA_SIZE, which tells us the amount of file data
that is new between the parent and send snapshots/roots. As this command
immediately follows the commands to start a snapshot/subvolume, it can be
used to report and compute progress, by keeping a counter that is incremented
with the data length of each write, clone and fallocate command that is received
from the stream.

Example:

    $ btrfs send -s --stream-version 2 /mnt/sdd/snap_base | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/snap_base
    At subvol snap_base
    About to receive 9212392667 bytes
    Subvolume /mnt/sdc//snap_base, 4059722426 / 9212392667 bytes received, 44.07%, 40.32MB/s

    $ btrfs send -s --stream-version 2 -p /mnt/sdd/snap_base /mnt/sdd/snap_incr | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/snap_incr
    At subvol snap_incr
    About to receive 9571342213 bytes
    Subvolume /mnt/sdc//snap_incr, 6557345221 / 9571342213 bytes received, 68.51%, 51.04MB/s

At the moment progress is only reported by btrfs-receive, but it is possible and simple
to do it for btrfs-send too, so that we can get progress report when not piping btrfs-send
output to btrfs-receive (directly to a file).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE. A version 2
    stream is now only produced is the ioctl caller specifies at least one of
    the new send flags (BTRFS_SEND_FLAG_SUPPORT_FALLOCATE or
    BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE).
V3: Renamed option -o to -s, removed some duplicated code (progress reset).
V4: Removed BTRFS_SEND_FLAG_SUPPORT_FALLOCATE flag and -a command line option
    for btrfs-send. Both were replaced with BTRFS_SEND_FLAG_STREAM_V2 and
    --stream-version=<version_number> respectively. Added commands for inode
    set flags and otime too.

 Documentation/btrfs-send.txt |  4 ++
 cmds-receive.c               | 91 ++++++++++++++++++++++++++++++++++++++++++++
 cmds-send.c                  | 23 ++++++++++-
 send-stream.c                |  4 ++
 send-stream.h                |  1 +
 5 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index 067fc27..1b18d32 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -43,6 +43,10 @@ An alternative would be to use pipes.
 --stream-version <version>::
 Ask the kernel to produce a specific send stream version. More recent stream versions provide
 new features and better performance. Default value is 1.
+-s::
+Obtain the total data size for each subvolume or snapshot to send. This demands additional
+processing (mostly IO bound) but is useful for the receive command to report progress. This
+option requires send stream version 2 or higher.
 
 EXIT STATUS
 -----------
diff --git a/cmds-receive.c b/cmds-receive.c
index d6cd3da..bd5255c 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -32,6 +32,7 @@
 #include <ftw.h>
 #include <wait.h>
 #include <assert.h>
+#include <time.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -71,6 +72,14 @@ struct btrfs_receive
 	struct subvol_uuid_search sus;
 
 	int honor_end_cmd;
+
+	/* For the subvolume/snapshot we're currently receiving. */
+	u64 total_data_size;
+	u64 bytes_received;
+	time_t last_progress_update;
+	u64 bytes_received_last_update;
+	float progress;
+	const char *target;
 };
 
 static int finish_subvol(struct btrfs_receive *r)
@@ -143,6 +152,16 @@ out:
 	return ret;
 }
 
+static void reset_progress(struct btrfs_receive *r, const char *dest)
+{
+	r->total_data_size = 0;
+	r->bytes_received = 0;
+	r->progress = 0.0;
+	r->last_progress_update = 0;
+	r->bytes_received_last_update = 0;
+	r->target = dest;
+}
+
 static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 			  void *user)
 {
@@ -156,6 +175,7 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	reset_progress(r, "Subvolume");
 
 	if (strlen(r->dest_dir_path) == 0)
 		r->cur_subvol->path = strdup(path);
@@ -205,6 +225,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	reset_progress(r, "Snapshot");
 
 	if (strlen(r->dest_dir_path) == 0)
 		r->cur_subvol->path = strdup(path);
@@ -287,6 +308,73 @@ out:
 	return ret;
 }
 
+static int process_total_data_size(u64 size, void *user)
+{
+	struct btrfs_receive *r = user;
+
+	r->total_data_size = size;
+	fprintf(stdout, "About to receive %llu bytes\n", size);
+
+	return 0;
+}
+
+static void update_progress(struct btrfs_receive *r, u64 bytes)
+{
+	float new_progress;
+	time_t now;
+	time_t tdiff;
+
+	if (r->total_data_size == 0)
+		return;
+
+	r->bytes_received += bytes;
+
+	now = time(NULL);
+	tdiff = now - r->last_progress_update;
+	if (tdiff < 1) {
+		if (r->bytes_received == r->total_data_size)
+			fprintf(stdout, "\n");
+		return;
+	}
+
+	new_progress = ((float)r->bytes_received / r->total_data_size) * 100.0;
+
+	if ((int)(new_progress * 100) > (int)(r->progress * 100) ||
+	    r->bytes_received == r->total_data_size) {
+		char line[512];
+		float rate = r->bytes_received - r->bytes_received_last_update;
+		const char *rate_units;
+
+		rate /= tdiff;
+		if (rate > (1024 * 1024)) {
+			rate_units = "MB/s";
+			rate /= 1024 * 1024;
+		} else if (rate > 1024) {
+			rate_units = "KB/s";
+			rate /= 1024;
+		} else {
+			rate_units = "B/s";
+		}
+
+		snprintf(line, sizeof(line),
+			 "%s%s %s, %llu / %llu bytes received, %5.2f%%, %5.2f%s%s",
+			 (g_verbose ? "" : "\r"),
+			 r->target,
+			 r->full_subvol_path,
+			 r->bytes_received, r->total_data_size,
+			 new_progress, rate, rate_units,
+			 (g_verbose ? "\n" : ""));
+		fprintf(stdout, "%s%s", line, (g_verbose ? "" : "        "));
+		fflush(stdout);
+	}
+
+	if (r->bytes_received == r->total_data_size)
+		fprintf(stdout, "\n");
+	r->progress = new_progress;
+	r->last_progress_update = now;
+	r->bytes_received_last_update = r->bytes_received;
+}
+
 static int process_mkfile(const char *path, void *user)
 {
 	int ret;
@@ -562,6 +650,7 @@ static int process_write(const char *path, const void *data, u64 offset,
 		}
 		pos += w;
 	}
+	update_progress(r, len);
 
 out:
 	free(full_path);
@@ -638,6 +727,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 				path, strerror(-ret));
 		goto out;
 	}
+	update_progress(r, len);
 
 out:
 	if (si) {
@@ -819,6 +909,7 @@ static struct btrfs_send_ops send_ops = {
 	.chmod = process_chmod,
 	.chown = process_chown,
 	.utimes = process_utimes,
+	.total_data_size = process_total_data_size,
 };
 
 static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
diff --git a/cmds-send.c b/cmds-send.c
index bd575f8..ff17092 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -47,6 +47,7 @@
 
 static int g_verbose = 0;
 static int g_stream_version = BTRFS_SEND_STREAM_VERSION_1;
+static int g_total_data_size = 0;
 
 struct btrfs_send {
 	int send_fd;
@@ -285,6 +286,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
 	if (g_stream_version == BTRFS_SEND_STREAM_VERSION_2)
 		io_send.flags |= BTRFS_SEND_FLAG_STREAM_V2;
+	if (g_total_data_size)
+		io_send.flags |= BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -433,7 +436,7 @@ int cmd_send(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt_long(argc, argv, "vec:f:i:p:",
+	while ((c = getopt_long(argc, argv, "vesc:f:i:p:",
 				long_options, NULL)) != -1) {
 		switch (c) {
 		case 'v':
@@ -539,6 +542,9 @@ int cmd_send(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 's':
+			g_total_data_size = 1;
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -550,6 +556,14 @@ int cmd_send(int argc, char **argv)
 	if (optind == argc)
 		usage(cmd_send_usage);
 
+	if (g_total_data_size &&
+	    g_stream_version < BTRFS_SEND_STREAM_VERSION_2) {
+		fprintf(stderr,
+			"ERROR: option total data size (-s) requires use of the send stream version 2 or higher\n");
+		ret = 1;
+		goto out;
+	}
+
 	if (outname != NULL) {
 		send.dump_fd = creat(outname, 0600);
 		if (send.dump_fd == -1) {
@@ -701,7 +715,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [--stream-version <version>] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-ves] [--stream-version <version>] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
@@ -728,5 +742,10 @@ const char * const cmd_send_usage[] = {
 	"--stream-version <version>  Ask the kernel to produce a specific send stream",
 	"                            version. More recent stream versions provide new",
 	"                            features and better performance. Default value is 1.",
+	"-s                          Obtain the total data size for each subvolume or ",
+	"                            snapshot to send. This demands additional processing",
+	"                            (mostly IO bound) but is useful for the receive ",
+	"                            command to report progress. This option requires use",
+	"                            of the send stream version 2 or higher.",
 	NULL
 };
diff --git a/send-stream.c b/send-stream.c
index 60c2126..e1bd4ce 100644
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
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
