Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29581 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3A1FQZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 00:16:25 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 02/10] Btrfs-progs: move printing subvol list outside of btrfs_list_subvols
Date: Mon, 28 Jan 2013 13:22:31 +0800
Message-Id: <1359350559-25671-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359350559-25671-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359350559-25671-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To improve the code reuse its better to have btrfs_list_subvols
just return list of subvols witout printing

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     | 28 ++++++++++++++++++----------
 btrfs-list.h     |  2 +-
 cmds-subvolume.c |  4 ++--
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index cb42fbc..b404e1d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1439,15 +1439,11 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
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
@@ -1458,16 +1454,28 @@ int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
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
index cde4b3c..71fe0f3 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -98,7 +98,7 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 			      enum btrfs_list_comp_enum comparer,
 			      int is_descending);
 
-int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
+int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
 			int is_tab_result);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e3cdb1e..c35dff7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -406,7 +406,7 @@ static int cmd_subvol_list(int argc, char **argv)
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
-	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
+	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
 				is_tab_result);
 	if (ret)
 		return 19;
@@ -613,7 +613,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
 				default_id);
 
-	ret = btrfs_list_subvols(fd, filter_set, NULL, 0);
+	ret = btrfs_list_subvols_print(fd, filter_set, NULL, 0);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.8.1.227.g44fe835

