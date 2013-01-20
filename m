Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:44286 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3AUAAI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 19:00:08 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130121000008.KJXJ6475.eastrmfepo202.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 19:00:08 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs-progs: correcting misnamed parameter options for btrfs send
Date: Sun, 20 Jan 2013 18:59:29 -0500
Message-Id: <1358726369-9782-1-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-8-git-send-email-gene@czarc.net>
References: <1358715858-4469-8-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a hand refit of the patch but otherwise the same.

Unfortunately, the command line options for btrfs send were misnamed. The
-i option should not be used to give "clone sources", we'll be using -c
instead.

Compatibily note: -i option was broken anyway, which makes it less critical
renaming it. For potential users of the old option style, we emit a fatal
warning if the -i option is used.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-send.c | 74 +++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 5607f2a..d2f7691 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -236,7 +236,7 @@ out:
 	return ERR_PTR(ret);
 }
 
-static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
+static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root_id)
 {
 	int ret;
 	pthread_t t_read;
@@ -289,7 +289,7 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 
 	io_send.clone_sources = (__u64*)send->clone_sources;
 	io_send.clone_sources_count = send->clone_sources_count;
-	io_send.parent_root = parent_root;
+	io_send.parent_root = parent_root_id;
 	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
 	if (ret) {
 		ret = -errno;
@@ -426,6 +426,7 @@ int cmd_send_start(int argc, char **argv)
 	char *snapshot_parent = NULL;
 	u64 root_id;
 	u64 parent_root_id = 0;
+	int full_send = 1;
 
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
@@ -435,12 +436,12 @@ int cmd_send_start(int argc, char **argv)
 		return 1;
 	}
 
-	while ((c = getopt(argc, argv, "vf:i:p:")) != -1) {
+	while ((c = getopt(argc, argv, "vc:f:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
 			g_verbose++;
 			break;
-		case 'i': {
+		case 'c':
 			subvol = realpath(optarg, NULL);
 			if (!subvol) {
 				ret = -errno;
@@ -462,12 +463,16 @@ int cmd_send_start(int argc, char **argv)
 			}
 			add_clone_source(&send, root_id);
 			free(subvol);
+			full_send = 0;
 			break;
-		}
 		case 'f':
 			outname = optarg;
 			break;
 		case 'p':
+			if (snapshot_parent) {
+				fprintf(stderr, "ERROR: you cannot have more than one parent (-p)\n");
+				return 1;
+			}
 			snapshot_parent = realpath(optarg, NULL);
 			if (!snapshot_parent) {
 				ret = -errno;
@@ -475,7 +480,12 @@ int cmd_send_start(int argc, char **argv)
 						"%s\n", optarg, strerror(-ret));
 				goto out;
 			}
+			full_send = 0;
 			break;
+		case 'i':
+			fprintf(stderr,
+				"ERROR: -i was removed, use -c instead\n");
+			return 1;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
@@ -581,10 +591,13 @@ int cmd_send_start(int argc, char **argv)
 			goto out;
 		}
 
-		if (!parent_root_id) {
+		if (!full_send && !parent_root_id) {
 			ret = find_good_parent(&send, root_id, &parent_root_id);
-			if (ret < 0)
-				parent_root_id = 0;
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: parent determination failed for %lld\n",
+					root_id);
+				goto out;
+			}
 		}
 
 		ret = is_subvol_ro(&send, subvol);
@@ -605,6 +618,7 @@ int cmd_send_start(int argc, char **argv)
 		add_clone_source(&send, root_id);
 
 		parent_root_id = 0;
+		full_send = 0;
 		free(subvol);
 	}
 
@@ -622,32 +636,28 @@ static const char * const send_cmd_group_usage[] = {
 };
 
 static const char * const cmd_send_usage[] = {
-	"btrfs send [-v] [-i <subvol>] [-p <parent>] <subvol>",
+	"btrfs send [-v] [-p <parent>] [-c <clone-src>] <subvol>",
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
+	"send, use '-p <parent>'. If you want to allow btrfs to clone from",
+	"any additional local snapshots, use -c <clone-src> (multiple times",
+	"where applicable). You must not specify clone sources unless you",
+	"guarantee that these snapshots are exactly in the same state on both",
+	"sides, the sender and the receiver. It is allowed to omit the",
+	"'-p <parent>' option when '-c <clone-src>' options are given, in",
+	"which case 'btrfs send' will determine a suitable parent among the",
+	"clone sources itself.",
+	"\n",
+	"-v               Enable verbose debug output. Each occurrency of",
+	"                 this option increases the verbose level more.",
+	"-p <parent>      Send an incremental stream from <parent> to",
+	"                 <subvol>.",
+	"-c <clone-src>   Use this snapshot as a clone source for an ",
+	"                 incremental send (multiple allowed)",
+	"-f <outfile>     Output is normally written to stdout. To write to",
+	"                 a file, use this option. An alternative would be to",
+	"                 use pipes.",
 	NULL
 };
 
-- 
1.8.1

