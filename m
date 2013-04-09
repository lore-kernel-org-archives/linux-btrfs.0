Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:46278 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.24 OK)
	with ESMTP id X0628ep39FGDUb for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/17] Btrfs-progs: btrfs-receive optionally honors the end-cmd
Date: Tue,  9 Apr 2013 19:08:40 +0200
Message-Id: <3162a1e1331be720ad85c5a2ad63dbe0d6242d65.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new option is added to btrfs-receive to change the behavior when
an <end cmd> is received in the Btrfs send stream.

The traditional behavior (which still is the default) is to continue
to read the stream until an EOF condition is encountered. If an
<end cmd> is received, afterwards either an EOF or a new
<stream header> is expected.

The new behavior (if the -e option is set on the command line) is
to terminate after an <end cmd> is read without the need for an EOF.
This allows the stream (e.g. a single TCP stream) to carry additional
data or even multiple Btrfs send streams.

Old btrfs-send tools used to encode multiple snapshots like this
(with 2 snapshots in this example):
<stream header> + <sequence of commands> + <end cmd> +
<stream header> + <sequence of commands> + <end cmd> + EOF

If the new -e option is set, the expected format is like this:
<stream header> + <sequence of commands> +
                  <sequence of commands> + <end cmd>

The btrfs-send tool is changed in a seperate commit to always use
the new format, i.e. to send an <end cmd> only at the end.

Note that the currently existing receivers treat <end cmd> only as
an indication that a new <stream header> is following. This means,
you can just skip the sequence <end cmd> <stream header> without
loosing compatibility. As long as an EOF is following, the currently
existing receivers handle the new format (if the two new flags are
used) exactly as the old one.

The goal of changing the semantic of <end cmd> is to be able to use
a single stream (one TCP connection) to multiplex a request/response
handshake plus Btrfs send streams, all in the same stream. In this
case you cannot evaluate an EOF condition as an end of the Btrfs send
stream. You need something else, and the <end cmd> is just perfect
for this purpose.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 16 +++++++++++++---
 send-stream.c  |  6 ++++--
 send-stream.h  |  3 ++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 081665f..50c1b97 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -65,6 +65,8 @@ struct btrfs_receive
 	struct subvol_info *cur_subvol;
 
 	struct subvol_uuid_search sus;
+
+	int honor_end_cmd;
 };
 
 static int finish_subvol(struct btrfs_receive *r)
@@ -809,7 +811,8 @@ int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 		goto out;
 
 	while (!end) {
-		ret = btrfs_read_and_process_send_stream(r_fd, &send_ops, r);
+		ret = btrfs_read_and_process_send_stream(r_fd, &send_ops, r,
+							 r->honor_end_cmd);
 		if (ret < 0)
 			goto out;
 		if (ret)
@@ -862,7 +865,7 @@ static int do_cmd_receive(int argc, char **argv)
 	r.mnt_fd = -1;
 	r.write_fd = -1;
 
-	while ((c = getopt(argc, argv, "vf:")) != -1) {
+	while ((c = getopt(argc, argv, "evf:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
@@ -870,6 +873,9 @@ static int do_cmd_receive(int argc, char **argv)
 		case 'f':
 			fromfile = optarg;
 			break;
+		case 'e':
+			r.honor_end_cmd = 1;
+			break;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: receive args invalid.\n");
@@ -903,7 +909,7 @@ static const char * const receive_cmd_group_usage[] = {
 };
 
 const char * const cmd_receive_usage[] = {
-	"btrfs receive [-v] [-f <infile>] <mount>",
+	"btrfs receive [-ve] [-f <infile>] <mount>",
 	"Receive subvolumes from stdin.",
 	"Receives one or more subvolumes that were previously ",
 	"sent with btrfs send. The received subvolumes are stored",
@@ -919,6 +925,10 @@ const char * const cmd_receive_usage[] = {
 	"-f <infile>      By default, btrfs receive uses stdin",
 	"                 to receive the subvolumes. Use this",
 	"                 option to specify a file to use instead.",
+	"-e               Terminate after receiving an <end cmd>",
+	"                 in the data stream. Without this option,",
+	"                 the receiver terminates only if an error",
+	"                 is recognized or on EOF.",
 	NULL
 };
 
diff --git a/send-stream.c b/send-stream.c
index a3628e4..1a498f3 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -439,7 +439,8 @@ out:
 }
 
 int btrfs_read_and_process_send_stream(int fd,
-				       struct btrfs_send_ops *ops, void *user)
+				       struct btrfs_send_ops *ops, void *user,
+				       int honor_end_cmd)
 {
 	int ret;
 	struct btrfs_send_stream s;
@@ -476,7 +477,8 @@ int btrfs_read_and_process_send_stream(int fd,
 		if (ret < 0)
 			goto out;
 		if (ret) {
-			ret = 0;
+			if (!honor_end_cmd)
+				ret = 0;
 			goto out;
 		}
 	}
diff --git a/send-stream.h b/send-stream.h
index 9223018..17bc669 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -57,7 +57,8 @@ struct btrfs_send_ops {
 };
 
 int btrfs_read_and_process_send_stream(int fd,
-				       struct btrfs_send_ops *ops, void *user);
+				       struct btrfs_send_ops *ops, void *user,
+				       int honor_end_cmd);
 
 #ifdef __cplusplus
 }
-- 
1.8.2.1

