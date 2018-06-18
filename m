Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:18259 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968209AbeFRIiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:18 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E4EE8AC0199
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 273C03286F9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 14/20] btrfs-progs: sub list: Update help message of -o option
Date: Mon, 18 Jun 2018 17:41:02 +0900
Message-ID: <fa6523a8e47fb225a0d21d73558843bc01914606.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently "sub list -o" lists only child subvolumes of the specified
path. So, update help message and variable name more appropriately.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |  2 +-
 cmds-subvolume.c                       | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index 20fae1e1..0381c92c 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -116,7 +116,7 @@ or at mount time via the subvolid= option.
 +
 Path filtering;;
 -o::::
-print only subvolumes below specified <path>.
+print only subvolumes which the subvolume of <path> contains.
 -a::::
 print all the subvolumes in the filesystem, including subvolumes
 which cannot be accessed from current mount point.
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index dab266aa..552c6dea 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1550,7 +1550,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"It is possible to specify non-subvolume directory as <path>.",
 	"",
 	"Path filtering:",
-	"-o           print only subvolumes below specified path",
+	"-o           print only subvolumes which the subvolume of <path> contains",
 	"-a           print all the subvolumes in the filesystem.",
 	"             path to be shown is relative to the top-level",
 	"             subvolume (require root privileges)",
@@ -1605,7 +1605,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int follow_mount = 0;
 	int sort = 0;
 	int no_sort = 0;
-	int is_only_in_path = 0;
+	int is_only_child = 0;
 	int absolute_path = 0;
 	DIR *dirstream = NULL;
 	enum btrfs_list_layout layout = BTRFS_LIST_LAYOUT_DEFAULT;
@@ -1651,7 +1651,7 @@ static int cmd_subvol_list(int argc, char **argv)
 			btrfs_list_setup_print_column_v2(BTRFS_LIST_GENERATION);
 			break;
 		case 'o':
-			is_only_in_path = 1;
+			is_only_child = 1;
 			break;
 		case 't':
 			layout = BTRFS_LIST_LAYOUT_TABLE;
@@ -1732,7 +1732,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
-	if (follow_mount && (is_list_all || is_only_in_path)) {
+	if (follow_mount && (is_list_all || is_only_child)) {
 		ret = -1;
 		error("cannot use -f with -a or -o option");
 		goto out;
@@ -1760,7 +1760,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	if (ret)
 		goto out;
 
-	if (is_only_in_path)
+	if (is_only_child)
 		btrfs_list_setup_filter_v2(&filter_set,
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
-- 
2.14.4


