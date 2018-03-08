Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935168AbeCHClE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6A3E0AEA8
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 11/20] btrfs-progs: reorder placement of help declarations for send/receive
Date: Wed,  7 Mar 2018 21:40:38 -0500
Message-Id: <20180308024047.10104-12-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The usage definitions for send and receive follow the command
definitions, which use them.  This works because we declare them
in commands.h.  When we move to using cmd_struct as the entry point,
these declarations will be removed, breaking the commands.  Since
that would be an otherwise unrelated change, this patch reorders
them separately.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-receive.c | 62 ++++++++++++++++++++++++++--------------------------
 cmds-send.c    | 69 +++++++++++++++++++++++++++++-----------------------------
 2 files changed, 66 insertions(+), 65 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 68123a31..b3709f36 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1248,6 +1248,37 @@ out:
 	return ret;
 }
 
+const char * const cmd_receive_usage[] = {
+	"btrfs receive [options] <mount>\n"
+	"btrfs receive --dump [options]",
+	"Receive subvolumes from a stream",
+	"Receives one or more subvolumes that were previously",
+	"sent with btrfs send. The received subvolumes are stored",
+	"into MOUNT.",
+	"The receive will fail in case the receiving subvolume",
+	"already exists. It will also fail in case a previously",
+	"received subvolume has been changed after it was received.",
+	"After receiving a subvolume, it is immediately set to",
+	"read-only.",
+	"",
+	"-v               increase verbosity about performed actions",
+	"-f FILE          read the stream from FILE instead of stdin",
+	"-e               terminate after receiving an <end cmd> marker in the stream.",
+	"                 Without this option the receiver side terminates only in case",
+	"                 of an error on end of file.",
+	"-C|--chroot      confine the process to <mount> using chroot",
+	"-E|--max-errors NERR",
+	"                 terminate as soon as NERR errors occur while",
+	"                 stream processing commands from the stream.",
+	"                 Default value is 1. A value of 0 means no limit.",
+	"-m ROOTMOUNT     the root mount point of the destination filesystem.",
+	"                 If /proc is not accessible, use this to tell us where",
+	"                 this file system is mounted.",
+	"--dump           dump stream metadata, one line per operation,",
+	"                 does not require the MOUNT parameter",
+	NULL
+};
+
 int cmd_receive(int argc, char **argv)
 {
 	char *tomnt = NULL;
@@ -1357,34 +1388,3 @@ out:
 
 	return !!ret;
 }
-
-const char * const cmd_receive_usage[] = {
-	"btrfs receive [options] <mount>\n"
-	"btrfs receive --dump [options]",
-	"Receive subvolumes from a stream",
-	"Receives one or more subvolumes that were previously",
-	"sent with btrfs send. The received subvolumes are stored",
-	"into MOUNT.",
-	"The receive will fail in case the receiving subvolume",
-	"already exists. It will also fail in case a previously",
-	"received subvolume has been changed after it was received.",
-	"After receiving a subvolume, it is immediately set to",
-	"read-only.",
-	"",
-	"-v               increase verbosity about performed actions",
-	"-f FILE          read the stream from FILE instead of stdin",
-	"-e               terminate after receiving an <end cmd> marker in the stream.",
-	"                 Without this option the receiver side terminates only in case",
-	"                 of an error on end of file.",
-	"-C|--chroot      confine the process to <mount> using chroot",
-	"-E|--max-errors NERR",
-	"                 terminate as soon as NERR errors occur while",
-	"                 stream processing commands from the stream.",
-	"                 Default value is 1. A value of 0 means no limit.",
-	"-m ROOTMOUNT     the root mount point of the destination filesystem.",
-	"                 If /proc is not accessible, use this to tell us where",
-	"                 this file system is mounted.",
-	"--dump           dump stream metadata, one line per operation,",
-	"                 does not require the MOUNT parameter",
-	NULL
-};
diff --git a/cmds-send.c b/cmds-send.c
index c5ecdaa1..8365e9c9 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -489,6 +489,41 @@ static void free_send_info(struct btrfs_send *sctx)
 	subvol_uuid_search_finit(&sctx->sus);
 }
 
+
+const char * const cmd_send_usage[] = {
+	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
+	"Send the subvolume(s) to stdout.",
+	"Sends the subvolume(s) specified by <subvol> to stdout.",
+	"<subvol> should be read-only here.",
+	"By default, this will send the whole subvolume. To do an incremental",
+	"send, use '-p <parent>'. If you want to allow btrfs to clone from",
+	"any additional local snapshots, use '-c <clone-src>' (multiple times",
+	"where applicable). You must not specify clone sources unless you",
+	"guarantee that these snapshots are exactly in the same state on both",
+	"sides, the sender and the receiver. It is allowed to omit the",
+	"'-p <parent>' option when '-c <clone-src>' options are given, in",
+	"which case 'btrfs send' will determine a suitable parent among the",
+	"clone sources itself.",
+	"\n",
+	"-e               If sending multiple subvols at once, use the new",
+	"                 format and omit the end-cmd between the subvols.",
+	"-p <parent>      Send an incremental stream from <parent> to",
+	"                 <subvol>.",
+	"-c <clone-src>   Use this snapshot as a clone source for an ",
+	"                 incremental send (multiple allowed)",
+	"-f <outfile>     Output is normally written to stdout. To write to",
+	"                 a file, use this option. An alternative would be to",
+	"                 use pipes.",
+	"--no-data        send in NO_FILE_DATA mode, Note: the output stream",
+	"                 does not contain any file data and thus cannot be used",
+	"                 to transfer changes. This mode is faster and useful to",
+	"                 show the differences in metadata.",
+	"-v|--verbose     enable verbose output to stderr, each occurrence of",
+	"                 this option increases verbosity",
+	"-q|--quiet       suppress all messages, except errors",
+	NULL
+};
+
 int cmd_send(int argc, char **argv)
 {
 	char *subvol = NULL;
@@ -774,37 +809,3 @@ out:
 	free_send_info(&send);
 	return !!ret;
 }
-
-const char * const cmd_send_usage[] = {
-	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
-	"Send the subvolume(s) to stdout.",
-	"Sends the subvolume(s) specified by <subvol> to stdout.",
-	"<subvol> should be read-only here.",
-	"By default, this will send the whole subvolume. To do an incremental",
-	"send, use '-p <parent>'. If you want to allow btrfs to clone from",
-	"any additional local snapshots, use '-c <clone-src>' (multiple times",
-	"where applicable). You must not specify clone sources unless you",
-	"guarantee that these snapshots are exactly in the same state on both",
-	"sides, the sender and the receiver. It is allowed to omit the",
-	"'-p <parent>' option when '-c <clone-src>' options are given, in",
-	"which case 'btrfs send' will determine a suitable parent among the",
-	"clone sources itself.",
-	"\n",
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
-	NULL
-};
-- 
2.12.3

