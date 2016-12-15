Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:27751 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754956AbcLOEaH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 23:30:07 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9AE17AC0153
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 13:29:52 +0900 (JST)
Message-Id: <201612150429.AA00024@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 15 Dec 2016 13:29:28 +0900
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 1/2] btrfs-progs: qgroup: add sync option to 'qgroup show'
In-Reply-To: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'qgroup show' command does not synchronize filesystem.
Therefore, 'qgroup show' may not display the correct value unless
synchronized with 'filesystem sync' command etc.

So add the '--sync' option so that we can choose whether or not
to synchronize when executing the command.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: use getopt_long with enum instead of single letter (suggested by Qu)
v3: dropped the --no-sync option and separated the patch of sort
    option (suggested by David)
---
 Documentation/btrfs-qgroup.asciidoc |  4 ++++
 cmds-qgroup.c                       | 22 ++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 438dbc7..3053f2e 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -126,6 +126,10 @@ Prefix \'+' means ascending order and \'-' means descending order of <attr>.
 If no prefix is given, use ascending order by default.
 +
 If multiple <attr>s is given, use comma to separate.
++
+--sync::::
+To retrieve information after updating the state of qgroups,
+force sync of the filesystem identified by <path> before getting information.
 
 EXIT STATUS
 -----------
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index bc15077..2a10c97 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -272,8 +272,7 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 }
 
 static const char * const cmd_qgroup_show_usage[] = {
-	"btrfs qgroup show -pcreFf "
-	"[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
+	"btrfs qgroup show [options] <path>",
 	"Show subvolume quota groups.",
 	"-p             print parent qgroup id",
 	"-c             print child qgroup id",
@@ -288,6 +287,7 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"               list qgroups sorted by specified items",
 	"               you can use '+' or '-' in front of each item.",
 	"               (+:ascending, -:descending, ascending default)",
+	"--sync         force sync of the filesystem before getting info",
 	NULL
 };
 
@@ -301,6 +301,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	u64 qgroupid;
 	int filter_flag = 0;
 	unsigned unit_mode;
+	int sync = 0;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -311,8 +312,12 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	while (1) {
 		int c;
+		enum {
+			GETOPT_VAL_SYNC = 256
+		};
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, 'S'},
+			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -348,6 +353,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 			if (ret)
 				usage(cmd_qgroup_show_usage);
 			break;
+		case GETOPT_VAL_SYNC:
+			sync = 1;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -365,6 +373,16 @@ static int cmd_qgroup_show(int argc, char **argv)
 		return 1;
 	}
 
+	if (sync) {
+		ret = ioctl(fd, BTRFS_IOC_SYNC);
+		if (ret < 0) {
+			error("sync ioctl failed on '%s': %s", path,
+			      strerror(errno));
+			close_file_or_dir(fd, dirstream);
+			goto out;
+		}
+	}
+
 	if (filter_flag) {
 		ret = lookup_path_rootid(fd, &qgroupid);
 		if (ret < 0) {
-- 
2.9.3
