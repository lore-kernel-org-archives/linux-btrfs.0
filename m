Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51582 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3AJLfI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:08 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0ABZ7O4022165
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:08 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0ABZ7rO015986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:07 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0ABZ79K018592
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 05:35:07 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/11] Btrfs-progs: accommodate different layout for printing subvol list
Date: Thu, 10 Jan 2013 19:41:22 +0800
Message-Id: <1357818083-15531-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>

Currently we have name prefix (default) and table format to print
the output of subvol list. Just these two formats does not cater
to all the needs, for eg. the up coming show sub-command need a
way to display all the known information of the given subvol.
This patch will provide a way to extend the printing to other
formats.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |   26 +++++++++++++++-----------
 btrfs-list.h     |    3 +++
 cmds-subvolume.c |   23 ++++++++++++++++++++---
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 8581762..844788b 100644
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
@@ -1414,21 +1414,25 @@ static void print_all_volume_info_tab_head()
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
@@ -1454,7 +1458,7 @@ int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-		       int is_tab_result)
+		       int layout)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1466,7 +1470,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, fd);
 
-	print_all_volume_info(&root_sort, is_tab_result);
+	print_all_volume_info(&root_sort, layout);
 	__free_all_subvolumn(&root_lookup);
 
 	return 0;
diff --git a/btrfs-list.h b/btrfs-list.h
index d71d2b0..5f3febd 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -18,6 +18,9 @@
 
 #include "kerncompat.h"
 
+#define BTRFS_LIST_LAYOUT_DEFAULT	0
+#define BTRFS_LIST_LAYOUT_TABLE		1
+
 /*
  * one of these for each root we find.
  */
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ee36463..dd677f7 100644
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
1.7.1

