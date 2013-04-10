Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:53353 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935405Ab3DJRK5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 13:10:57 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.26 OK)
	with ESMTP id p01069p3AEDd3J for <linux-btrfs@vger.kernel.org>;
	Wed, 10 Apr 2013 19:10:56 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add send option for using new end-cmd semantic
Date: Wed, 10 Apr 2013 19:10:56 +0200
Message-Id: <1365613856-12430-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds a command line option to enable sending streams
which make use of the new end-cmd semantic if multiple snapshots are
sent back-to-back. The goal is to use the <end cmd> as an indication
to stop reading the input stream. So far, the receiver could only
use EOF to recognize the end.

If the new command line option '-e' is set, this commit requires a
kernel which is able to support the new flags in the send ioctl. New
bits in the flags of the send ioctl will be set which cause EINVAL
on old kernels. However, if the option '-e' is not set, it works
with old and new kernels without any errors or any changed behavior.

This used to be the encoding (with 2 snapshots in this example):
<stream header> + <sequence of commands> + <end cmd> +
<stream header> + <sequence of commands> + <end cmd> + EOF

The new format (if the two new flags are used) is this one:
<stream header> + <sequence of commands> +
                  <sequence of commands> + <end cmd>

Note that the currently existing receivers treat <end cmd> only as
an indication that a new <stream header> is following. This means,
you can just skip the sequence <end cmd> <stream header> without
loosing compatibility. As long as an EOF is following, the currently
existing receivers handle the new format (if the two new flags are
used) exactly as the old one.

Also note that the kernel interface was changed in a way that is
backward compatible to old btrfs-progs tools. You set one or two bits
in the flags field of the ioctl to enable the new behavior. Old tools
set these flags to zero, thus getting exactly the same as they got
with older kernels. And this is exactly what happens if the new '-e'
option is not set, the new bits in the flags are not set and thus
old kernels and new kernels are both supported.

So what is the benefit of this change? The goal is to be able to use
a single stream (one TCP connection) to multiplex a request/response
handshake plus Btrfs send streams, all in the same stream. In this
case you cannot evaluate an EOF condition as an end of the Btrfs send
stream. You need something else, and the <end cmd> is just perfect
for this purpose.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-send.c | 35 +++++++++++++++++++++++++++++++----
 ioctl.h     | 15 ++++++++++++++-
 2 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 9bb4206..adfb67d 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -244,7 +244,8 @@ out:
 	return ERR_PTR(ret);
 }
 
-static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id)
+static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id,
+		   int is_first_subvol, int is_last_subvol)
 {
 	int ret;
 	pthread_t t_read;
@@ -298,11 +299,18 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id)
 	io_send.clone_sources = (__u64*)send->clone_sources;
 	io_send.clone_sources_count = send->clone_sources_count;
 	io_send.parent_root = parent_root_id;
+	if (!is_first_subvol)
+		io_send.flags |= BTRFS_SEND_FLAG_OMIT_STREAM_HEADER;
+	if (!is_last_subvol)
+		io_send.flags |= BTRFS_SEND_FLAG_OMIT_END_CMD;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: send ioctl failed with %d: %s\n", ret,
 			strerror(-ret));
+		if (ret == -EINVAL && (!is_first_subvol || !is_last_subvol))
+			fprintf(stderr,
+				"Try upgrading your kernel or don't use -e.\n");
 		goto out;
 	}
 	if (g_verbose > 0)
@@ -435,15 +443,19 @@ int cmd_send_start(int argc, char **argv)
 	u64 root_id;
 	u64 parent_root_id = 0;
 	int full_send = 1;
+	int new_end_cmd_semantic = 0;
 
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "vc:f:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "vec:f:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
 			break;
+		case 'e':
+			new_end_cmd_semantic = 1;
+			break;
 		case 'c':
 			subvol = realpath(optarg, NULL);
 			if (!subvol) {
@@ -582,6 +594,9 @@ int cmd_send_start(int argc, char **argv)
 	}
 
 	for (i = optind; i < argc; i++) {
+		int is_first_subvol;
+		int is_last_subvol;
+
 		subvol = argv[i];
 
 		fprintf(stderr, "At subvol %s\n", subvol);
@@ -621,7 +636,17 @@ int cmd_send_start(int argc, char **argv)
 			goto out;
 		}
 
-		ret = do_send(&send, root_id, parent_root_id);
+		if (new_end_cmd_semantic) {
+			/* require new kernel */
+			is_first_subvol = (i == optind);
+			is_last_subvol = (i == argc - 1);
+		} else {
+			/* be compatible to old and new kernel */
+			is_first_subvol = 1;
+			is_last_subvol = 1;
+		}
+		ret = do_send(&send, root_id, parent_root_id,
+			      is_first_subvol, is_last_subvol);
 		if (ret < 0)
 			goto out;
 
@@ -648,7 +673,7 @@ static const char * const send_cmd_group_usage[] = {
 };
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-v] [-p <parent>] [-c <clone-src>] <subvol>",
+	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] <subvol>",
 	"Send the subvolume to stdout.",
 	"Sends the subvolume specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
@@ -663,6 +688,8 @@ const char * const cmd_send_usage[] = {
 	"\n",
 	"-v               Enable verbose debug output. Each occurrence of",
 	"                 this option increases the verbose level more.",
+	"-e               If sending multiple subvols at once, use the new",
+	"                 format and omit the end-cmd between the subvols.",
 	"-p <parent>      Send an incremental stream from <parent> to",
 	"                 <subvol>.",
 	"-c <clone-src>   Use this snapshot as a clone source for an ",
diff --git a/ioctl.h b/ioctl.h
index e841913..f8b9f07 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -373,7 +373,20 @@ struct btrfs_ioctl_received_subvol_args {
  * search of clone sources doesn't find an extent. UPDATE_EXTENT
  * commands will be sent instead of WRITE commands.
  */
-#define	BTRFS_SEND_FLAG_NO_FILE_DATA	0x1
+#define BTRFS_SEND_FLAG_NO_FILE_DATA		0x1
+
+/*
+ * Do not add the leading stream header. Used when multiple snapshots
+ * are sent back to back.
+ */
+#define BTRFS_SEND_FLAG_OMIT_STREAM_HEADER	0x2
+
+/*
+ * Omit the command at the end of the stream that indicated the end
+ * of the stream. This option is used when multiple snapshots are
+ * sent back to back.
+ */
+#define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
 
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
-- 
1.8.2.1

