Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21839 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2LOLqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 06:46:32 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBFBkV8V020487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:32 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBFBkVEO016563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:31 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBFBkVVq012320
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 05:46:31 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs-progs: Move printing outside of btrfs_list_subvols
Date: Sat, 15 Dec 2012 19:52:06 +0800
Message-Id: <1355572328-32281-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
References: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

its better to have btrfs_list_subvols just return witout printing
so that btrfs_list_subvols can be reused.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |   28 ++++++++++++++++++----------
 btrfs-list.h     |    2 +-
 cmds-subvolume.c |    4 ++--
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 3db5f14..45d8d05 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1463,15 +1463,11 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
 	}
 }
 
-int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
-		       struct btrfs_list_comparer_set *comp_set,
-		       int is_tab_result)
+int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 {
-	struct root_lookup root_lookup;
-	struct root_lookup root_sort;
 	int ret;
 
-	ret = __list_subvol_search(fd, &root_lookup);
+	ret = __list_subvol_search(fd, root_lookup);
 	if (ret) {
 		fprintf(stderr, "ERROR: can't perform the search - %s\n",
 				strerror(errno));
@@ -1482,16 +1478,28 @@ int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
 	 * now we have an rbtree full of root_info objects, but we need to fill
 	 * in their path names within the subvol that is referencing each one.
 	 */
-	ret = __list_subvol_fill_paths(fd, &root_lookup);
-	if (ret < 0)
-		return ret;
+	ret = __list_subvol_fill_paths(fd, root_lookup);
+	return ret;
+}
 
+int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
+		       struct btrfs_list_comparer_set *comp_set,
+		       int is_tab_result)
+{
+	struct root_lookup root_lookup;
+	struct root_lookup root_sort;
+	int ret;
+
+	ret = btrfs_list_subvols(fd, &root_lookup);
+	if (ret)
+		return ret;
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, fd);
 
 	print_all_volume_info(&root_sort, is_tab_result);
 	__free_all_subvolumn(&root_lookup);
-	return ret;
+
+	return 0;
 }
 
 static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
diff --git a/btrfs-list.h b/btrfs-list.h
index a32545f..855e73d 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -99,7 +99,7 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 			      enum btrfs_list_comp_enum comparer,
 			      int is_descending);
 
-int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
+int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
 			int is_tab_result);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 427263a..b481a3b 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -409,7 +409,7 @@ static int cmd_subvol_list(int argc, char **argv)
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
-	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
+	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
 				is_tab_result);
 	if (ret)
 		return 19;
@@ -616,7 +616,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
 				default_id);
 
-	ret = btrfs_list_subvols(fd, filter_set, NULL, 0);
+	ret = btrfs_list_subvols_print(fd, filter_set, NULL, 0);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.1

