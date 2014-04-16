Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56341 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077AbaDPNzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 09:55:42 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so11204866wgh.16
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 06:55:41 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/4 v2] Btrfs-progs: send, implement total data size callback and progress report
Date: Wed, 16 Apr 2014 15:56:15 +0100
Message-Id: <1397660175-8005-1-git-send-email-fdmanana@gmail.com>
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

    $ btrfs send -o /mnt/sdd/snap_base | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/snap_base
    At subvol snap_base
    About to receive 9212392667 bytes
    Subvolume /mnt/sdc//snap_base, 4059722426 / 9212392667 bytes received, 44.07%, 40.32MB/s

    $ btrfs send -o -p /mnt/sdd/snap_base /mnt/sdd/snap_incr | btrfs receive /mnt/sdc
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

 Documentation/btrfs-send.txt |  3 ++
 cmds-receive.c               | 91 ++++++++++++++++++++++++++++++++++++++++++++
 cmds-send.c                  | 14 ++++++-
 send-stream.c                |  4 ++
 send-stream.h                |  1 +
 5 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index 18a98fa..38470b0 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -40,6 +40,9 @@ Use this snapshot as a clone source for an incremental send (multiple allowed).
 -f <outfile>::
 Output is normally written to stdout. To write to a file, use this option.
 An alternative would be to use pipes.
+-o::
+Obtain the total data size for each subvolume or snapshot to send. This demands additional
+processing (mostly IO bound) but is useful for the receive command to report progress.
 
 EXIT STATUS
 -----------
diff --git a/cmds-receive.c b/cmds-receive.c
index d6cd3da..19300fc 100644
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
@@ -156,6 +165,12 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->total_data_size = 0;
+	r->bytes_received = 0;
+	r->progress = 0.0;
+	r->last_progress_update = 0;
+	r->bytes_received_last_update = 0;
+	r->target = "Subvolume";
 
 	if (strlen(r->dest_dir_path) == 0)
 		r->cur_subvol->path = strdup(path);
@@ -205,6 +220,12 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->total_data_size = 0;
+	r->bytes_received = 0;
+	r->progress = 0.0;
+	r->last_progress_update = 0;
+	r->bytes_received_last_update = 0;
+	r->target = "Snapshot";
 
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
+		fprintf(stdout, "%s%s", line, "      ");
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
index 1cd457d..69f5ba1 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -45,6 +45,7 @@
 #include "send-utils.h"
 
 static int g_verbose = 0;
+static int g_total_data_size = 0;
 
 struct btrfs_send {
 	int send_fd;
@@ -281,6 +282,8 @@ static int do_send(struct btrfs_send *send, u64 parent_root_id,
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_STREAM_HEADER;
 	if (!is_last_subvol)
 		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
+	if (g_total_data_size)
+		io_send.flags |= BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -424,7 +427,7 @@ int cmd_send(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "vec:f:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "veoc:f:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -511,6 +514,9 @@ int cmd_send(int argc, char **argv)
 				"ERROR: -i was removed, use -c instead\n");
 			ret = 1;
 			goto out;
+		case 'o':
+			g_total_data_size = 1;
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -673,7 +679,7 @@ out:
 }
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"btrfs send [-veo] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
@@ -697,5 +703,9 @@ const char * const cmd_send_usage[] = {
 	"-f <outfile>     Output is normally written to stdout. To write to",
 	"                 a file, use this option. An alternative would be to",
 	"                 use pipes.",
+	"-o               Obtain the total data size for each subvolume or ",
+	"                 snapshot to send. This demands additional processing",
+	"                 (mostly IO bound) but is useful for the receive ",
+	"                 command to report progress.",
 	NULL
 };
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
-- 
1.9.1

