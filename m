Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:22284 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbcLGHzg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 02:55:36 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 446B6AC0189
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2016 16:55:32 +0900 (JST)
Message-Id: <201612070755.AA00022@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 07 Dec 2016 16:55:15 +0900
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: qgroup: add sync option to 'qgroup show'
In-Reply-To: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'qgroup show' command does not synchronize filesystem.
Therefore, 'qgroup show' may not display the correct value unless
synchronized with 'filesystem sync' command etc.

So add the '--sync' and '--no-sync' options so that we can choose
whether or not to synchronize when executing the command.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: use getopt_long with enum instead of single letter (suggested by Qu)
---
 Documentation/btrfs-qgroup.asciidoc |  6 ++++++
 cmds-qgroup.c                       | 33 +++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 438dbc7..9c65795 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -126,6 +126,12 @@ Prefix \'+' means ascending order and \'-' means descending order of <attr>.
 If no prefix is given, use ascending order by default.
 +
 If multiple <attr>s is given, use comma to separate.
++
+--sync::::
+To retrieve information after updating the status of qgroups,
+invoke sync before getting information.
+--no-sync::::
+Do not invoke sync before getting information (default).
 
 EXIT STATUS
 -----------
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index bc15077..b494f6f 100644
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
@@ -288,6 +287,8 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"               list qgroups sorted by specified items",
 	"               you can use '+' or '-' in front of each item.",
 	"               (+:ascending, -:descending, ascending default)",
+	"--sync         invoke sync before getting info",
+	"--no-sync      do not invoke sync before getting info (default)",
 	NULL
 };
 
@@ -301,6 +302,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	u64 qgroupid;
 	int filter_flag = 0;
 	unsigned unit_mode;
+	int sync = 0;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -311,8 +313,15 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	while (1) {
 		int c;
+		enum {
+			GETOPT_VAL_SORT = 256,
+			GETOPT_VAL_SYNC,
+			GETOPT_VAL_NO_SYNC
+		};
 		static const struct option long_options[] = {
-			{"sort", required_argument, NULL, 'S'},
+			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
+			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
+			{"no-sync", no_argument, NULL, GETOPT_VAL_NO_SYNC},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -342,12 +351,18 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case 'f':
 			filter_flag |= 0x2;
 			break;
-		case 'S':
+		case GETOPT_VAL_SORT:
 			ret = btrfs_qgroup_parse_sort_string(optarg,
 							     &comparer_set);
 			if (ret)
 				usage(cmd_qgroup_show_usage);
 			break;
+		case GETOPT_VAL_SYNC:
+			sync = 1;
+			break;
+		case GETOPT_VAL_NO_SYNC:
+			sync = 0;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -365,6 +380,16 @@ static int cmd_qgroup_show(int argc, char **argv)
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
