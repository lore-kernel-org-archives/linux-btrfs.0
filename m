Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3A1EEg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 23:04:36 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 08/10] Btrfs-progs: make printing subvol extensible to newer layouts
Date: Mon, 28 Jan 2013 12:10:26 +0800
Message-Id: <1359346228-24804-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359346228-24804-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359346228-24804-1-git-send-email-anand.jain@oracle.com>

Currently you can print subvol in a list or table format.
This patch will provide a way to extend this to other formats
like the upcoming raw format.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     | 26 +++++++++++++++-----------
 btrfs-list.h     |  3 +++
 cmds-subvolume.c | 23 ++++++++++++++++++++---
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 9c84ecb..656de10 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -54,12 +54,12 @@ struct {
 	{
 		.name		= "ID",
 		.column_name	= "ID",
-		.need_print	= 1,
+		.need_print	= 0,
 	},
 	{
 		.name		= "gen",
 		.column_name	= "Gen",
-		.need_print	= 1,
+		.need_print	= 0,
 	},
 	{
 		.name		= "cgen",
@@ -74,7 +74,7 @@ struct {
 	{
 		.name		= "top level",
 		.column_name	= "Top Level",
-		.need_print	= 1,
+		.need_print	= 0,
 	},
 	{
 		.name		= "otime",
@@ -94,7 +94,7 @@ struct {
 	{
 		.name		= "path",
 		.column_name	= "Path",
-		.need_print	= 1,
+		.need_print	= 0,
 	},
 	{
 		.name		= NULL,
@@ -1401,21 +1401,25 @@ static void print_all_volume_info_tab_head()
 }
 
 static void print_all_volume_info(struct root_lookup *sorted_tree,
-				  int is_tab_result)
+				  int layout)
 {
 	struct rb_node *n;
 	struct root_info *entry;
 
-	if (is_tab_result)
+	if (layout == BTRFS_LIST_LAYOUT_TABLE)
 		print_all_volume_info_tab_head();
 
 	n = rb_first(&sorted_tree->root);
 	while (n) {
 		entry = rb_entry(n, struct root_info, sort_node);
-		if (is_tab_result)
-			print_single_volume_info_table(entry);
-		else
+		switch (layout) {
+		case BTRFS_LIST_LAYOUT_DEFAULT:
 			print_single_volume_info_default(entry);
+			break;
+		case BTRFS_LIST_LAYOUT_TABLE:
+			print_single_volume_info_table(entry);
+			break;
+		}
 		n = rb_next(n);
 	}
 }
@@ -1441,7 +1445,7 @@ int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-		       int is_tab_result)
+		       int layout)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1453,7 +1457,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, fd);
 
-	print_all_volume_info(&root_sort, is_tab_result);
+	print_all_volume_info(&root_sort, layout);
 	__free_all_subvolumn(&root_lookup);
 
 	return 0;
diff --git a/btrfs-list.h b/btrfs-list.h
index cde7a3f..5b60068 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -18,6 +18,9 @@
 
 #include "kerncompat.h"
 
+#define BTRFS_LIST_LAYOUT_DEFAULT	0
+#define BTRFS_LIST_LAYOUT_TABLE	1
+
 /*
  * one of these for each root we find.
  */
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a1e6893..bb9629f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -410,8 +410,18 @@ static int cmd_subvol_list(int argc, char **argv)
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
-	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
-				is_tab_result);
+	/* by default we shall print the following columns*/
+	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
+	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
+	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+
+	if (is_tab_result)
+		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
+				BTRFS_LIST_LAYOUT_TABLE);
+	else
+		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
+				BTRFS_LIST_LAYOUT_DEFAULT);
 	if (ret)
 		return 19;
 	return 0;
@@ -617,7 +627,14 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
 				default_id);
 
-	ret = btrfs_list_subvols_print(fd, filter_set, NULL, 0);
+	/* by default we shall print the following columns*/
+	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
+	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
+	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+
+	ret = btrfs_list_subvols_print(fd, filter_set, NULL,
+		BTRFS_LIST_LAYOUT_DEFAULT);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.8.1.227.g44fe835

