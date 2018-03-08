Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934884AbeCHClE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51E23AE90
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 09/20] btrfs-progs: subvolume: add quota info to btrfs sub show
Date: Wed,  7 Mar 2018 21:40:36 -0500
Message-Id: <20180308024047.10104-10-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch reports on the first-level qgroup, if any, associated with
a particular subvolume.  It displays the usage and limit, subject
to the usual unit parameters.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-subvolume.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 769d2a76..96fb7b06 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -972,6 +972,7 @@ static const char * const cmd_subvol_show_usage[] = {
 	"Show more information about the subvolume",
 	"-r|--rootid   rootid of the subvolume",
 	"-u|--uuid     uuid of the subvolume",
+	HELPINFO_UNITS_SHORT_LONG,
 	"",
 	"If no option is specified, <subvol-path> will be shown, otherwise",
 	"the rootid or uuid are resolved relative to the <mnt> path.",
@@ -993,6 +994,13 @@ static int cmd_subvol_show(int argc, char **argv)
 	int by_uuid = 0;
 	u64 rootid_arg;
 	u8 uuid_arg[BTRFS_UUID_SIZE];
+	struct btrfs_qgroup_stats stats;
+	unsigned int unit_mode;
+	const char *referenced_size;
+	const char *referenced_limit_size = "-";
+	unsigned int field_width = 0;
+
+	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
 	while (1) {
 		int c;
@@ -1112,6 +1120,48 @@ static int cmd_subvol_show(int argc, char **argv)
 	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
 			1, raw_prefix);
 
+	ret = btrfs_qgroup_query(fd, get_ri.root_id, &stats);
+	if (ret && ret != -ENOTTY && ret != -ENODATA) {
+		fprintf(stderr,
+			"\nERROR: BTRFS_IOC_QUOTA_QUERY failed: %s\n",
+			strerror(-ret));
+		goto out;
+	}
+
+	printf("\tQuota Usage:\t\t");
+	fflush(stdout);
+	if (ret) {
+		if (ret == -ENOTTY)
+			printf("quotas not enabled\n");
+		else
+			printf("quotas not available\n");
+		goto out;
+	}
+
+	referenced_size = pretty_size_mode(stats.info.referenced, unit_mode);
+	if (stats.limit.max_referenced)
+		referenced_limit_size = pretty_size_mode(
+						stats.limit.max_referenced,
+						unit_mode);
+	field_width = max(strlen(referenced_size),
+			  strlen(referenced_limit_size));
+
+	printf("%-*s referenced, %s exclusive\n ", field_width,
+	       referenced_size,
+	       pretty_size_mode(stats.info.exclusive, unit_mode));
+
+	printf("\tQuota Limits:\t\t");
+	if (stats.limit.max_referenced || stats.limit.max_exclusive) {
+		const char *excl = "-";
+
+		if (stats.limit.max_exclusive)
+			excl = pretty_size_mode(stats.limit.max_exclusive,
+						unit_mode);
+		printf("%-*s referenced, %s exclusive\n", field_width,
+		       referenced_limit_size, excl);
+	} else
+		printf("None\n");
+
 out:
 	btrfs_cleanup_root_info(&get_ri);
 	free(filter_set);
-- 
2.12.3

