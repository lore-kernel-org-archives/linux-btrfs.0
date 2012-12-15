Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab2LOLqe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 06:46:34 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBFBkX1i020490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:33 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBFBkW7v016576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:33 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBFBkW97009349
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 05:46:32 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs-progs: make provision to print subvol list tree format
Date: Sat, 15 Dec 2012 19:52:07 +0800
Message-Id: <1355572328-32281-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
References: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Currently we have default (name <value>) and table format to
list the subvol. This patch will help to accommodate the
enhancement to provide the tree display for the subvol-snapshot
list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |   34 ++++++++++++++++++++++------------
 cmds-subvolume.c |    6 +++---
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 45d8d05..571efd0 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1444,22 +1444,32 @@ static void print_all_volume_info_tab_head()
 }
 
 static void print_all_volume_info(struct root_lookup *sorted_tree,
-				  int is_tab_result)
+				int layout)
 {
 	struct rb_node *n;
 	struct root_info *entry;
 
-	if (is_tab_result)
+	switch (layout) {
+	case 0: // default: name <value>
+		n = rb_first(&sorted_tree->root);
+		while (n) {
+			entry = rb_entry(n, struct root_info, sort_node);
+			print_single_volume_info_default(entry);
+			n = rb_next(n);
+		}
+		break;
+	case 1: // table
 		print_all_volume_info_tab_head();
-
-	n = rb_first(&sorted_tree->root);
-	while (n) {
-		entry = rb_entry(n, struct root_info, sort_node);
-		if (is_tab_result)
+		n = rb_first(&sorted_tree->root);
+		while (n) {
+			entry = rb_entry(n, struct root_info, sort_node);
 			print_single_volume_info_table(entry);
-		else
-			print_single_volume_info_default(entry);
-		n = rb_next(n);
+			n = rb_next(n);
+		}
+		break;
+	default:
+		printf("ERROR: default switch print_all_volume_info\n");
+		return;
 	}
 }
 
@@ -1484,7 +1494,7 @@ int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-		       int is_tab_result)
+		       int layout)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1496,7 +1506,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, fd);
 
-	print_all_volume_info(&root_sort, is_tab_result);
+	print_all_volume_info(&root_sort, layout);
 	__free_all_subvolumn(&root_lookup);
 
 	return 0;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index b481a3b..411a5de 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -306,7 +306,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int ret;
 	int c;
 	char *subvol;
-	int is_tab_result = 0;
+	int layout = 0;
 	int is_list_all = 0;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
@@ -331,7 +331,7 @@ static int cmd_subvol_list(int argc, char **argv)
 			is_list_all = 1;
 			break;
 		case 't':
-			is_tab_result = 1;
+			layout = 1;
 			break;
 		case 's':
 			btrfs_list_setup_filter(&filter_set,
@@ -410,7 +410,7 @@ static int cmd_subvol_list(int argc, char **argv)
 					top_id);
 
 	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
-				is_tab_result);
+				layout);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.1

