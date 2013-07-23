Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3GWCmm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 22:42:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6N2gdvG026444
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 10:42:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 1/2] btrfs-progs: Update the usage strings of some cmds
Date: Tue, 23 Jul 2013 10:43:21 +0800
Message-Id: <1374547402-14890-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update the usage strings of some cmds to keep the them consistent with
the source.

Also some minor changes are done to fit the man page syntax.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs.c           |  2 +-
 cmds-chunk.c      |  2 +-
 cmds-filesystem.c |  2 +-
 cmds-inspect.c    |  2 ++
 cmds-replace.c    | 22 +++++++++++-----------
 cmds-restore.c    |  4 +++-
 cmds-scrub.c      |  5 +++--
 cmds-send.c       |  4 ++--
 cmds-subvolume.c  | 11 ++++++-----
 9 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 4e93e13..c580103 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -188,7 +188,7 @@ const struct cmd_group btrfs_cmd_group;
 
 static const char * const cmd_help_usage[] = {
 	"btrfs help [--full]",
-	"Dislay help information",
+	"Display help information",
 	"",
 	"--full     display detailed help on every command",
 	NULL
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..73276b6 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1780,7 +1780,7 @@ fail_rc:
 
 const char * const cmd_chunk_recover_usage[] = {
 	"btrfs chunk-recover [options] <device>",
-	"Recover the chunk tree by scaning the devices one by one.",
+	"Recover the chunk tree by scanning the devices one by one.",
 	"",
 	"-y	Assume an answer of `yes' to all questions",
 	"-v	Verbose mode",
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..6e8a920 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -497,7 +497,7 @@ static int cmd_resize(int argc, char **argv)
 }
 
 static const char * const cmd_label_usage[] = {
-	"btrfs filesystem label [<device>|<mountpoint>] [<newlabel>]",
+	"btrfs filesystem label [<device>|<mount_point>] [<newlabel>]",
 	"Get or change the label of a filesystem",
 	"With one argument, get the label of filesystem on <device>.",
 	"If <newlabel> is passed, set the filesystem label to <newlabel>.",
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 30b41fc..00dc32a 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -84,6 +84,8 @@ out:
 static const char * const cmd_inode_resolve_usage[] = {
 	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
 	"Get file system paths for the given inode",
+	"",
+	"-v   verbose mode",
 	NULL
 };
 
diff --git a/cmds-replace.c b/cmds-replace.c
index 6397bb5..6b2d91a 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -97,27 +97,27 @@ static int dev_replace_handle_sigint(int fd)
 }
 
 static const char *const cmd_start_replace_usage[] = {
-	"btrfs replace start srcdev|devid targetdev [-Bfr] mount_point",
+	"btrfs replace start [-Bfr] <srcdev>|<devid> <targetdev> <mount_point>",
 	"Replace device of a btrfs filesystem.",
 	"On a live filesystem, duplicate the data to the target device which",
 	"is currently stored on the source device. If the source device is not",
 	"available anymore, or if the -r option is set, the data is built",
 	"only using the RAID redundancy mechanisms. After completion of the",
 	"operation, the source device is removed from the filesystem.",
-	"If the srcdev is a numerical value, it is assumed to be the device id",
-	"of the filesystem which is mounted at mount_point, otherwise it is",
+	"If the <srcdev> is a numerical value, it is assumed to be the device id",
+	"of the filesystem which is mounted at <mount_point>, otherwise it is",
 	"the path to the source device. If the source device is disconnected,",
-	"from the system, you have to use the devid parameter format.",
-	"The targetdev needs to be same size or larger than the srcdev.",
+	"from the system, you have to use the <devid> parameter format.",
+	"The <targetdev> needs to be same size or larger than the <srcdev>.",
 	"",
-	"-r     only read from srcdev if no other zero-defect mirror exists",
+	"-r     only read from <srcdev> if no other zero-defect mirror exists",
 	"       (enable this if your drive has lots of read errors, the access",
 	"       would be very slow)",
-	"-f     force using and overwriting targetdev even if it looks like",
+	"-f     force using and overwriting <targetdev> even if it looks like",
 	"       containing a valid btrfs filesystem. A valid filesystem is",
 	"       assumed if a btrfs superblock is found which contains a",
 	"       correct checksum. Devices which are currently mounted are",
-	"       never allowed to be used as the targetdev",
+	"       never allowed to be used as the <targetdev>",
 	"-B     do not background",
 	NULL
 };
@@ -350,11 +350,11 @@ leave_with_error:
 }
 
 static const char *const cmd_status_replace_usage[] = {
-	"btrfs replace status mount_point [-1]",
+	"btrfs replace status [-1] <mount_point>",
 	"Print status and progress information of a running device replace",
 	"operation",
 	"",
-	"-1     print once instead of print continously until the replace",
+	"-1     print once instead of print continuously until the replace",
 	"       operation finishes (or is canceled)",
 	NULL
 };
@@ -520,7 +520,7 @@ progress2string(char *buf, size_t s, int progress_1000)
 }
 
 static const char *const cmd_cancel_replace_usage[] = {
-	"btrfs replace cancel mount_point",
+	"btrfs replace cancel <mount_point>",
 	"Cancel a running device replace operation.",
 	NULL
 };
diff --git a/cmds-restore.c b/cmds-restore.c
index e48df40..a21a4a4 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -969,10 +969,12 @@ const char * const cmd_restore_usage[] = {
 	"-v              verbose",
 	"-i              ignore errors",
 	"-o              overwrite",
-	"-t              tree location",
+	"-t <location>   tree location",
 	"-f <offset>     filesystem location",
 	"-u <block>      super mirror",
+	"-r <rootid>	 root objectid",
 	"-d              find dir",
+	"-l              list tree roots",
 	NULL
 };
 
diff --git a/cmds-scrub.c b/cmds-scrub.c
index c0dc584..20b0882 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1465,13 +1465,14 @@ out:
 }
 
 static const char * const cmd_scrub_start_usage[] = {
-	"btrfs scrub start [-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
+	"btrfs scrub start [-BdqrR] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
 	"Start a new scrub",
 	"",
 	"-B     do not background",
 	"-d     stats per device (-B only)",
 	"-q     be quiet",
 	"-r     read only mode",
+	"-R     raw print mode, print full data instead of summary"
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
 	NULL
@@ -1526,7 +1527,7 @@ out:
 }
 
 static const char * const cmd_scrub_resume_usage[] = {
-	"btrfs scrub resume [-Bdqr] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
+	"btrfs scrub resume [-BdqrR] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
 	"Resume previously canceled or interrupted scrub",
 	"",
 	"-B     do not background",
diff --git a/cmds-send.c b/cmds-send.c
index 0057e6b..6d275be 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -664,12 +664,12 @@ static const char * const send_cmd_group_usage[] = {
 };
 
 const char * const cmd_send_usage[] = {
-	"btrfs send [-v] [-p <parent>] [-c <clone-src>] <subvol>",
+	"btrfs send [-v] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol>",
 	"Send the subvolume to stdout.",
 	"Sends the subvolume specified by <subvol> to stdout.",
 	"By default, this will send the whole subvolume. To do an incremental",
 	"send, use '-p <parent>'. If you want to allow btrfs to clone from",
-	"any additional local snapshots, use -c <clone-src> (multiple times",
+	"any additional local snapshots, use '-c <clone-src>' (multiple times",
 	"where applicable). You must not specify clone sources unless you",
 	"guarantee that these snapshots are exactly in the same state on both",
 	"sides, the sender and the receiver. It is allowed to omit the",
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ccb4762..9097cd9 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -82,7 +82,7 @@ static int cmd_subvol_create(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "c:i:r");
+		int c = getopt(argc, argv, "c:i:");
 		if (c < 0)
 			break;
 
@@ -282,7 +282,7 @@ out:
  * - lowercase for enabling specific items in the output
  */
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-agopurts] [-G [+|-]value] [-C [+|-]value] "
+	"btrfs subvolume list [options] [-G [+|-]value] [-C [+|-]value] "
 	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
@@ -483,11 +483,12 @@ out:
 }
 
 static const char * const cmd_snapshot_usage[] = {
-	"btrfs subvolume snapshot [-r] <source> [<dest>/]<name>",
-	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> [<dest>/]<name>",
+	"btrfs subvolume snapshot [-r] <source> <dest>|[<dest>/]<name>",
+	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
 	"Create a snapshot of the subvolume",
 	"Create a writable/readonly snapshot of the subvolume <source> with",
-	"the name <name> in the <dest> directory",
+	"the name <name> in the <dest> directory.  If only <dest> is given,",
+	"the subvolume will be named the basename of <source>.",
 	"",
 	"-r             create a readonly snapshot",
 	"-i <qgroupid>  add the newly created snapshot to a qgroup. This",
-- 
1.8.3.3

