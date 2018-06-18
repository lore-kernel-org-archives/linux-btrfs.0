Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:18248 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968212AbeFRIiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:18 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2AA0BAC0195
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:11 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 4A9E8BD670B
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 15/20] btrfs-progs: sub list: Update help message of -d option
Date: Mon, 18 Jun 2018 17:41:03 +0900
Message-ID: <113c9e55f4eb4fab5fb991be0fe1288f64f66316.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Explicitly states that -d requires root privileges.
Also, update some option handling with regard to -d option.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc | 3 ++-
 cmds-subvolume.c                       | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index 0381c92c..2db1d479 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -149,7 +149,8 @@ only snapshot subvolumes in the filesystem will be listed.
 -r::::
 only readonly subvolumes in the filesystem will be listed.
 -d::::
-list deleted subvolumes that are not yet cleaned.
+list deleted subvolumes that are not yet cleaned
+(require root privileges).
 
 Other;;
 -t::::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 552c6dea..ef39789a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1569,6 +1569,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-s           list only snapshots",
 	"-r           list readonly subvolumes (including snapshots)",
 	"-d           list deleted subvolumes that are not yet cleaned",
+	"             (require root privileges)",
 	"",
 	"Other:",
 	"-t           print the result as a table",
@@ -1744,6 +1745,13 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (filter_set->only_deleted &&
+			(is_list_all || absolute_path || follow_mount)) {
+		ret = -1;
+		error("cannot use -d with -a/f/A option");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
-- 
2.14.4


