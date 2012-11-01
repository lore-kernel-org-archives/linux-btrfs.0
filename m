Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:22915 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761590Ab2KAPB3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 11:01:29 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: ablock84@googlemail.com, sensille@gmx.net
Subject: [PATCH 1/2] Btrfs-progs: correcting misnamed parameter options for btrfs send
Date: Thu,  1 Nov 2012 16:01:25 +0100
Message-Id: <1351782086-23435-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately, the command line options for btrfs send were misnamed. To
specify a base for an incremental snapshot transfer, the best choice is -i
for "incremental" (was: -p). To optionally add snapshots existing on the
receiver as clone sources, the best choice is -c (was: -i).

Compatibily note: -i option was broken anyway, which makes it less critical
reassigning it. For potential users of the old option style, we emit a fatal
warning if the -p is used.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Reviewed-by: Alexander Block <ablock84@googlemail.com>
---
 cmds-send.c |   97 +++++++++++++++++++++++++++++++---------------------------
 1 files changed, 52 insertions(+), 45 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..9db65e9 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -234,7 +234,7 @@ out:
 	return ERR_PTR(ret);
 }
 
-static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
+static int do_send(struct btrfs_send *send, u64 root_id, u64 base_root_id)
 {
 	int ret;
 	pthread_t t_read;
@@ -286,7 +286,7 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 
 	io_send.clone_sources = (__u64*)send->clone_sources;
 	io_send.clone_sources_count = send->clone_sources_count;
-	io_send.parent_root = parent_root;
+	io_send.parent_root = base_root_id;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -420,19 +420,20 @@ int cmd_send_start(int argc, char **argv)
 	struct btrfs_send send;
 	u32 i;
 	char *mount_root = NULL;
-	char *snapshot_parent = NULL;
+	char *incremental_base = NULL;
 	u64 root_id;
-	u64 parent_root_id = 0;
+	u64 base_root_id = 0;
+	int full_send = 1;
 
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	while ((c = getopt(argc, argv, "vf:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "vf:i:p:r:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
 			break;
-		case 'i': {
+		case 'r':
 			subvol = realpath(optarg, NULL);
 			if (!subvol) {
 				ret = -errno;
@@ -455,19 +456,26 @@ int cmd_send_start(int argc, char **argv)
 			add_clone_source(&send, root_id);
 			free(subvol);
 			break;
-		}
 		case 'f':
 			outname = optarg;
 			break;
-		case 'p':
-			snapshot_parent = realpath(optarg, NULL);
-			if (!snapshot_parent) {
+		case 'i':
+			if (incremental_base) {
+				fprintf(stderr, "ERROR: you cannot have more than one base for incremental send (-i)\n");
+				return 1;
+			}
+			incremental_base = realpath(optarg, NULL);
+			if (!incremental_base) {
 				ret = -errno;
 				fprintf(stderr, "ERROR: realpath %s failed. "
 						"%s\n", optarg, strerror(-ret));
 				goto out;
 			}
+			full_send = 0;
 			break;
+		case 'p':
+			fprintf(stderr, "ERROR: -p option was removed. use -i instead\n");
+			return 1;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -504,17 +512,17 @@ int cmd_send_start(int argc, char **argv)
 	if (ret < 0)
 		goto out;
 
-	if (snapshot_parent != NULL) {
+	if (incremental_base != NULL) {
 		ret = get_root_id(&send,
-				get_subvol_name(&send, snapshot_parent),
-				&parent_root_id);
+				get_subvol_name(&send, incremental_base),
+				&base_root_id);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: could not resolve root_id "
-					"for %s\n", snapshot_parent);
+					"for %s\n", incremental_base);
 			goto out;
 		}
 
-		add_clone_source(&send, parent_root_id);
+		add_clone_source(&send, base_root_id);
 	}
 
 	for (i = optind; i < argc; i++) {
@@ -573,10 +581,13 @@ int cmd_send_start(int argc, char **argv)
 			goto out;
 		}
 
-		if (!parent_root_id) {
-			ret = find_good_parent(&send, root_id, &parent_root_id);
-			if (ret < 0)
-				parent_root_id = 0;
+		if (!full_send && !base_root_id) {
+			ret = find_good_parent(&send, root_id, &base_root_id);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: parent determination failed for %lld\n",
+					root_id);
+				goto out;
+			}
 		}
 
 		ret = is_subvol_ro(&send, subvol);
@@ -589,14 +600,15 @@ int cmd_send_start(int argc, char **argv)
 			goto out;
 		}
 
-		ret = do_send(&send, root_id, parent_root_id);
+		ret = do_send(&send, root_id, base_root_id);
 		if (ret < 0)
 			goto out;
 
 		/* done with this subvol, so add it to the clone sources */
 		add_clone_source(&send, root_id);
 
-		parent_root_id = 0;
+		base_root_id = 0;
+		full_send = 0;
 		free(subvol);
 	}
 
@@ -614,32 +626,27 @@ static const char * const send_cmd_group_usage[] = {
 };
 
 static const char * const cmd_send_usage[] = {
-	"btrfs send [-v] [-i <subvol>] [-p <parent>] <subvol>",
+	"btrfs send [-v] [-i <base>] [-r <snap>] <subvol>",
 	"Send the subvolume to stdout.",
 	"Sends the subvolume specified by <subvol> to stdout.",
-	"By default, this will send the whole subvolume. To do",
-	"an incremental send, one or multiple '-i <clone_source>'",
-	"arguments have to be specified. A 'clone source' is",
-	"a subvolume that is known to exist on the receiving",
-	"side in exactly the same state as on the sending side.\n",
-	"Normally, a good snapshot parent is searched automatically",
-	"in the list of 'clone sources'. To override this, use",
-	"'-p <parent>' to manually specify a snapshot parent.",
-	"A manually specified snapshot parent is also regarded",
-	"as 'clone source'.\n",
-	"-v               Enable verbose debug output. Each",
-	"                 occurrency of this option increases the",
-	"                 verbose level more.",
-	"-i <subvol>      Informs btrfs send that this subvolume,",
-	"                 can be taken as 'clone source'. This can",
-	"                 be used for incremental sends.",
-	"-p <subvol>      Disable automatic snaphot parent",
-	"                 determination and use <subvol> as parent.",
-	"                 This subvolume is also added to the list",
-	"                 of 'clone sources' (see -i).",
-	"-f <outfile>     Output is normally written to stdout.",
-	"                 To write to a file, use this option.",
-	"                 An alternative would be to use pipes.",
+	"By default, this will send the whole subvolume. To do an incremental",
+	"send, use '-i <incremental-base>'. If you know the snapshots"
+	"available on the receiving side, use '-r <snap>' (multiple times",
+	"where applicable). This allows 'btrfs send' to clone from these",
+	"snapshots. You must not specify these unless you guarantee they are",
+	"exactly in the same state on both sides. It is allowed to omit the",
+	"'-i <base>' option when specifying one or more '-r <snap>' options,",
+	"in which case 'btrfs send' will determine the base itself."
+	"\n",
+	"-v               Enable verbose debug output. Each occurrency of",
+	"                 this option increases the verbose level more.",
+	"-i <base>        Send an incremental stream between <incr-base> and",
+	"                 <subvol>.",
+	"-r <snap>        This snapshot exists on the receiver exactly in the ",
+	"                 same state as on the sender. (multiple allowed)",
+	"-f <outfile>     Output is normally written to stdout. To write to",
+	"                 a file, use this option. An alternative would be to",
+	"                 use pipes.",
 	NULL
 };
 
-- 
1.7.1

