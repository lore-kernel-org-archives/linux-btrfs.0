Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:16511 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLGDJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 22:09:08 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id AADE1AC005E
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2016 12:08:11 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3050.s.css.fujitsu.com (Postfix) with SMTP id 997652C3
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Dec 2016 12:08:11 +0900 (JST)
Message-Id: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 07 Dec 2016 12:07:55 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: qgroup: add sync option to 'qgroup show'
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
 Documentation/btrfs-qgroup.asciidoc |  5 +++++
 cmds-qgroup.c                       | 24 ++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 438dbc7..dd133ec 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -126,6 +126,11 @@ Prefix \'+' means ascending order and \'-' means descending order of <attr>.
 If no prefix is given, use ascending order by default.
 +
 If multiple <attr>s is given, use comma to separate.
++
+--sync::::
+invoke sync before getting info.
+--no-sync::::
+do not invoke sync before getting info (default).
 
 EXIT STATUS
 -----------
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index bc15077..ac339f3 100644
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
@@ -313,6 +315,8 @@ static int cmd_qgroup_show(int argc, char **argv)
 		int c;
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, 'S'},
+			{"sync", no_argument, NULL, 'Y'},
+			{"no-sync", no_argument, NULL, 'N'},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -348,6 +352,12 @@ static int cmd_qgroup_show(int argc, char **argv)
 			if (ret)
 				usage(cmd_qgroup_show_usage);
 			break;
+		case 'Y':
+			sync = 1;
+			break;
+		case 'N':
+			sync = 0;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -365,6 +375,16 @@ static int cmd_qgroup_show(int argc, char **argv)
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
