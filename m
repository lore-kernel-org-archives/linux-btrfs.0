Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419Ab3HNXRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:24 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHOeA030732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:24 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKT0017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:24 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/15] btrfs-progs: use NULL instead of 0
Date: Wed, 14 Aug 2013 16:16:45 -0700
Message-Id: <1376522205-16992-16-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These were mostly in option structs but there were a few gross string
pointer arguments given as 0.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-map-logical.c |  2 +-
 btrfs.c             |  2 +-
 cmds-balance.c      |  6 +++---
 cmds-check.c        |  2 +-
 cmds-dedup.c        |  4 ++--
 cmds-device.c       |  2 +-
 cmds-filesystem.c   |  4 ++--
 cmds-inspect.c      |  2 +-
 cmds-qgroup.c       | 21 +++++++++++++--------
 cmds-quota.c        |  5 +++--
 cmds-replace.c      |  2 +-
 cmds-restore.c      |  2 +-
 cmds-scrub.c        |  2 +-
 cmds-subvolume.c    |  8 ++++----
 commands.h          |  2 ++
 mkfs.c              |  2 +-
 16 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index ee8407f..ea0a1ba 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -106,7 +106,7 @@ static struct option long_options[] = {
 	{ "copy", 1, NULL, 'c' },
 	{ "output", 1, NULL, 'o' },
 	{ "bytes", 1, NULL, 'b' },
-	{ 0, 0, 0, 0}
+	{ NULL, 0, NULL, 0}
 };
 
 int main(int ac, char **av)
diff --git a/btrfs.c b/btrfs.c
index 050c9c3..fc9429d 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -258,7 +258,7 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "dedup", cmd_dedup, NULL, &dedup_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	},
 };
 
diff --git a/cmds-balance.c b/cmds-balance.c
index c78b726..a512368 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -382,7 +382,7 @@ static int cmd_balance_start(int argc, char **argv)
 			{ "system", optional_argument, NULL, 's' },
 			{ "force", no_argument, NULL, 'f' },
 			{ "verbose", no_argument, NULL, 'v' },
-			{ 0, 0, 0, 0 }
+			{ NULL, no_argument, NULL, 0 },
 		};
 
 		int opt = getopt_long(argc, argv, "d::s::m::fv", longopts,
@@ -641,7 +641,7 @@ static int cmd_balance_status(int argc, char **argv)
 		int longindex;
 		static struct option longopts[] = {
 			{ "verbose", no_argument, NULL, 'v' },
-			{ 0, 0, 0, 0}
+			{ NULL, no_argument, NULL, 0}
 		};
 
 		int opt = getopt_long(argc, argv, "v", longopts, &longindex);
@@ -713,7 +713,7 @@ const struct cmd_group balance_cmd_group = {
 		{ "cancel", cmd_balance_cancel, cmd_balance_cancel_usage, NULL, 0 },
 		{ "resume", cmd_balance_resume, cmd_balance_resume_usage, NULL, 0 },
 		{ "status", cmd_balance_status, cmd_balance_status_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-check.c b/cmds-check.c
index 2d5162c..df18c43 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5739,7 +5739,7 @@ static struct option long_options[] = {
 	{ "repair", 0, NULL, 0 },
 	{ "init-csum-tree", 0, NULL, 0 },
 	{ "init-extent-tree", 0, NULL, 0 },
-	{ 0, 0, 0, 0}
+	{ NULL, 0, NULL, 0}
 };
 
 const char * const cmd_check_usage[] = {
diff --git a/cmds-dedup.c b/cmds-dedup.c
index a22b5c9..7d96673 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -91,8 +91,8 @@ static int cmd_dedup_unreg(int argc, char **argv)
 const struct cmd_group dedup_cmd_group = {
 	dedup_cmd_group_usage, NULL, {
 		{ "register", cmd_dedup_reg, cmd_dedup_reg_usage, NULL, 0 },
-		{ "unregister", cmd_dedup_unreg, cmd_dedup_unreg_usage, 0, 0 },
-		{ 0, 0, 0, 0, 0 }
+		{ "unregister", cmd_dedup_unreg, cmd_dedup_unreg_usage, NULL, 0 },
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-device.c b/cmds-device.c
index 06df864..764e5ab 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -396,7 +396,7 @@ const struct cmd_group device_cmd_group = {
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
 		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
 		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a4e30ea..f545eb2 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -231,7 +231,7 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
-	char *search = 0;
+	char *search = NULL;
 	int ret;
 	int where = BTRFS_SCAN_PROC;
 	int searchstart = 1;
@@ -512,7 +512,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 },
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 8417e66..341ebd3 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -309,7 +309,7 @@ const struct cmd_group inspect_cmd_group = {
 			cmd_logical_resolve_usage, NULL, 0 },
 		{ "subvolid-resolve", cmd_subvolid_resolve,
 			cmd_subvolid_resolve_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 891d46c..8da18eb 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -428,14 +428,19 @@ static int cmd_qgroup_limit(int argc, char **argv)
 
 const struct cmd_group qgroup_cmd_group = {
 	qgroup_cmd_group_usage, NULL, {
-		{ "assign", cmd_qgroup_assign, cmd_qgroup_assign_usage, 0, 0 },
-		{ "remove", cmd_qgroup_remove, cmd_qgroup_remove_usage, 0, 0 },
-		{ "create", cmd_qgroup_create, cmd_qgroup_create_usage, 0, 0 },
-		{ "destroy", cmd_qgroup_destroy,
-		  cmd_qgroup_destroy_usage, 0, 0 },
-		{ "show", cmd_qgroup_show, cmd_qgroup_show_usage, 0, 0 },
-		{ "limit", cmd_qgroup_limit, cmd_qgroup_limit_usage, 0, 0 },
-		{ 0, 0, 0, 0, 0 }
+		{ "assign", cmd_qgroup_assign, cmd_qgroup_assign_usage,
+		   NULL, 0 },
+		{ "remove", cmd_qgroup_remove, cmd_qgroup_remove_usage,
+		   NULL, 0 },
+		{ "create", cmd_qgroup_create, cmd_qgroup_create_usage,
+		   NULL, 0 },
+		{ "destroy", cmd_qgroup_destroy, cmd_qgroup_destroy_usage,
+		   NULL, 0 },
+		{ "show", cmd_qgroup_show, cmd_qgroup_show_usage,
+		   NULL, 0 },
+		{ "limit", cmd_qgroup_limit, cmd_qgroup_limit_usage,
+		   NULL, 0 },
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-quota.c b/cmds-quota.c
index 3bdd5f6..5317f72 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -179,9 +179,10 @@ static int cmd_quota_rescan(int argc, char **argv)
 const struct cmd_group quota_cmd_group = {
 	quota_cmd_group_usage, NULL, {
 		{ "enable", cmd_quota_enable, cmd_quota_enable_usage, NULL, 0 },
-		{ "disable", cmd_quota_disable, cmd_quota_disable_usage, 0, 0 },
+		{ "disable", cmd_quota_disable, cmd_quota_disable_usage,
+		   NULL, 0 },
 		{ "rescan", cmd_quota_rescan, cmd_quota_rescan_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-replace.c b/cmds-replace.c
index 8ed92c4..b28bd3d 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -555,7 +555,7 @@ const struct cmd_group replace_cmd_group = {
 		  0 },
 		{ "cancel", cmd_cancel_replace, cmd_cancel_replace_usage, NULL,
 		  0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-restore.c b/cmds-restore.c
index 1e965a6..4c87483 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1086,7 +1086,7 @@ out:
 
 static struct option long_options[] = {
 	{ "path-regex", 1, NULL, 256},
-	{ 0, 0, 0, 0}
+	{ NULL, 0, NULL, 0}
 };
 
 const char * const cmd_restore_usage[] = {
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 08810b6..56f269f 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1736,7 +1736,7 @@ const struct cmd_group scrub_cmd_group = {
 		{ "cancel", cmd_scrub_cancel, cmd_scrub_cancel_usage, NULL, 0 },
 		{ "resume", cmd_scrub_resume, cmd_scrub_resume_usage, NULL, 0 },
 		{ "status", cmd_scrub_status, cmd_scrub_status_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index b1e5361..c62930c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -229,7 +229,7 @@ again:
 		goto out;
 	}
 
-	cpath = realpath(path, 0);
+	cpath = realpath(path, NULL);
 	dname = strdup(cpath);
 	dname = dirname(dname);
 	vname = strdup(cpath);
@@ -331,7 +331,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int is_only_in_path = 0;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
-		{0, 0, 0, 0}
+		{NULL, 0, NULL, 0}
 	};
 	DIR *dirstream = NULL;
 
@@ -806,7 +806,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_show_usage);
 
-	fullpath = realpath(argv[1], 0);
+	fullpath = realpath(argv[1], NULL);
 	if (!fullpath) {
 		fprintf(stderr, "ERROR: finding real path for '%s', %s\n",
 			argv[1], strerror(errno));
@@ -951,7 +951,7 @@ const struct cmd_group subvolume_cmd_group = {
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
 		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
-		{ 0, 0, 0, 0, 0 }
+		NULL_CMD_STRUCT,
 	}
 };
 
diff --git a/commands.h b/commands.h
index ac7dd23..65d5fea 100644
--- a/commands.h
+++ b/commands.h
@@ -50,6 +50,8 @@ struct cmd_struct {
 	int hidden;
 };
 
+#define NULL_CMD_STRUCT {NULL, NULL, NULL, NULL, 0}
+
 struct cmd_group {
 	const char * const *usagestr;
 	const char *infostr;
diff --git a/mkfs.c b/mkfs.c
index 8e38db7..cac3a84 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -326,7 +326,7 @@ static struct option long_options[] = {
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
 	{ "features", 0, NULL, 'O' },
-	{ 0, 0, 0, 0}
+	{ NULL, 0, NULL, 0}
 };
 
 static int add_directory_items(struct btrfs_trans_handle *trans,
-- 
1.7.11.7

