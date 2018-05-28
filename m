Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:50952 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753033AbeE1CSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:30 -0400
Received: by mail-it0-f65.google.com with SMTP id p3-v6so13195253itc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:29 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 2/6] Btrfs-progs: send, implement total data size callback and progress report
Date: Sun, 27 May 2018 22:14:37 -0400
Message-Id: <20180528021443.13923-9-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@gmail.com>

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
 cmds-receive.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-send.c    | 23 +++++++++++--
 send-stream.c  |  4 +++
 send-stream.h  |  1 +
 4 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 68123a31..d8ff5194 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -30,6 +30,7 @@
 #include <assert.h>
 #include <getopt.h>
 #include <limits.h>
+#include <time.h>
 
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -79,6 +80,14 @@ struct btrfs_receive
 
 	int honor_end_cmd;
 
+	/* For the subvolume/snapshot we're currently receiving. */
+	u64 total_data_size;
+	u64 bytes_received;
+	time_t last_progress_update;
+	u64 bytes_received_last_update;
+	float progress;
+	const char *target;
+
 	/*
 	 * Buffer to store capabilities from security.capabilities xattr,
 	 * usually 20 bytes, but make same room for potentially larger
@@ -156,6 +165,16 @@ out:
 	return ret;
 }
 
+static void reset_progress(struct btrfs_receive *rctx, const char *dest)
+{
+	rctx->total_data_size = 0;
+	rctx->bytes_received = 0;
+	rctx->progress = 0.0;
+	rctx->last_progress_update = 0;
+	rctx->bytes_received_last_update = 0;
+	rctx->target = dest;
+}
+
 static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 			  void *user)
 {
@@ -180,6 +199,7 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 		ret = -EINVAL;
 		goto out;
 	}
+	reset_progress(rctx, "Subvolume");
 
 	if (*rctx->dest_dir_path == 0) {
 		strncpy_null(rctx->cur_subvol_path, path);
@@ -249,6 +269,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		ret = -EINVAL;
 		goto out;
 	}
+	reset_progress(rctx, "Snapshot");
 
 	if (*rctx->dest_dir_path == 0) {
 		strncpy_null(rctx->cur_subvol_path, path);
@@ -388,6 +409,73 @@ out:
 	return ret;
 }
 
+static int process_total_data_size(u64 size, void *user)
+{
+	struct btrfs_receive *rctx = user;
+
+	rctx->total_data_size = size;
+	fprintf(stdout, "About to receive %llu bytes\n", size);
+
+	return 0;
+}
+
+static void update_progress(struct btrfs_receive *rctx, u64 bytes)
+{
+	float new_progress;
+	time_t now;
+	time_t tdiff;
+
+	if (rctx->total_data_size == 0)
+		return;
+
+	rctx->bytes_received += bytes;
+
+	now = time(NULL);
+	tdiff = now - rctx->last_progress_update;
+	if (tdiff < 1) {
+		if (rctx->bytes_received == rctx->total_data_size)
+			fprintf(stdout, "\n");
+		return;
+	}
+
+	new_progress = ((float)rctx->bytes_received / rctx->total_data_size) * 100.0;
+
+	if ((int)(new_progress * 100) > (int)(rctx->progress * 100) ||
+	    rctx->bytes_received == rctx->total_data_size) {
+		char line[5000];
+		float rate = rctx->bytes_received - rctx->bytes_received_last_update;
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
+			 rctx->target,
+			 rctx->full_subvol_path,
+			 rctx->bytes_received, rctx->total_data_size,
+			 new_progress, rate, rate_units,
+			 (g_verbose ? "\n" : ""));
+		fprintf(stdout, "%s%s", line, (g_verbose ? "" : "        "));
+		fflush(stdout);
+	}
+
+	if (rctx->bytes_received == rctx->total_data_size)
+		fprintf(stdout, "\n");
+	rctx->progress = new_progress;
+	rctx->last_progress_update = now;
+	rctx->bytes_received_last_update = rctx->bytes_received;
+}
+
 static int process_mkfile(const char *path, void *user)
 {
 	int ret;
@@ -722,6 +810,7 @@ static int process_write(const char *path, const void *data, u64 offset,
 		}
 		pos += w;
 	}
+	update_progress(rctx, len);
 
 out:
 	return ret;
@@ -827,6 +916,7 @@ static int process_clone(const char *path, u64 offset, u64 len,
 				path, strerror(-ret));
 		goto out;
 	}
+	update_progress(rctx, len);
 
 out:
 	if (si) {
@@ -1081,6 +1171,7 @@ static struct btrfs_send_ops send_ops = {
 	.chown = process_chown,
 	.utimes = process_utimes,
 	.update_extent = process_update_extent,
+	.total_data_size = process_total_data_size,
 };
 
 static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
diff --git a/cmds-send.c b/cmds-send.c
index 0ec557c7..45e30f53 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -53,6 +53,7 @@
  */
 static int g_verbose = 1;
 static int g_stream_version = BTRFS_SEND_STREAM_VERSION_1;
+static int g_total_data_size = 0;
 
 struct btrfs_send {
 	int send_fd;
@@ -346,6 +347,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
 	if (g_stream_version == BTRFS_SEND_STREAM_VERSION_2)
 		io_send.flags |= BTRFS_SEND_FLAG_STREAM_V2;
+	if (g_total_data_size)
+		io_send.flags |= BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret < 0) {
 		ret = -errno;
@@ -519,7 +522,7 @@ int cmd_send(int argc, char **argv)
 			{ "no-data", no_argument, NULL, GETOPT_VAL_SEND_NO_DATA },
 			{ "stream-version", 1, NULL, 'V' },
 		};
-		int c = getopt_long(argc, argv, "vqec:f:i:p:", long_options, NULL);
+		int c = getopt_long(argc, argv, "vqesc:f:i:p:", long_options, NULL);
 
 		if (c < 0)
 			break;
@@ -619,6 +622,9 @@ int cmd_send(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 's':
+			g_total_data_size = 1;
+			break;
 		case GETOPT_VAL_SEND_NO_DATA:
 			send_flags |= BTRFS_SEND_FLAG_NO_FILE_DATA;
 			break;
@@ -633,6 +639,14 @@ int cmd_send(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_send_usage);
 
+	if (g_total_data_size &&
+	    g_stream_version < BTRFS_SEND_STREAM_VERSION_2) {
+		fprintf(stderr,
+			"ERROR: option total data size (-s) requires use of the send stream version 2 or higher\n");
+		ret = 1;
+		goto out;
+	}
+
 	if (outname[0]) {
 		int tmpfd;
 
@@ -798,7 +812,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [--stream-version <version>] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-ves] [--stream-version <version>] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"<subvol> should be read-only here.",
@@ -831,5 +845,10 @@ const char * const cmd_send_usage[] = {
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
index 86956d28..d30fd5a7 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -453,6 +453,10 @@ static int read_and_process_cmd(struct btrfs_send_stream *sctx)
 		TLV_GET_U64(sctx, BTRFS_SEND_A_SIZE, &tmp);
 		ret = sctx->ops->update_extent(path, offset, tmp, sctx->user);
 		break;
+	case BTRFS_SEND_C_TOTAL_DATA_SIZE:
+		TLV_GET_U64(sctx, BTRFS_SEND_A_SIZE, &tmp);
+		ret = sctx->ops->total_data_size(tmp, sctx->user);
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index 39901f86..5b244ab6 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -66,6 +66,7 @@ struct btrfs_send_ops {
 		      struct timespec *mt, struct timespec *ct,
 		      void *user);
 	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
+	int (*total_data_size)(u64 size, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
-- 
2.17.0

