Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2LKOZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 09:25:21 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, cwillu@cwillu.com,
        Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] Btrfs-progs: List all subvolumes by default
Date: Tue, 11 Dec 2012 15:25:00 +0100
Message-Id: <1355235900-10252-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1355235900-10252-1-git-send-email-lczerner@redhat.com>
References: <1355235900-10252-1-git-send-email-lczerner@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit a1e89891eb6af5381539d9875b85c196150171b6 changed subvolume list
command so that we list only subvolumes under the specified directory.
However this is confusing and unnecessary obstacle, because one usually
want to see all subvolumes in the file system. It was introduced with
the notion the full_path may be invalid which is not exactly true as the
full_path is always relative to the root subvolume which makes perfect
sense.

Simply making option '-a' default is not enough since it introduces the
relative/absolute path distinction effectively obfuscating the subvolume
nesting.

This commit returns the subvolume list command behaviour before commit
a1e89891eb6af5381539d9875b85c196150171b6 where we list all subvolumes in
the filesystem with path naming from root subovolume. IMO this is the
best default as it is well understood and gives all the important
information about file system subvolumes including subvolume nesting
without the need to parse additional information.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 btrfs-list.c     |    8 ++++----
 btrfs-list.h     |    2 +-
 cmds-subvolume.c |    7 ++++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 77d99f8..ac6e1f0 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1283,12 +1283,11 @@ static void __filter_and_sort_subvol(struct root_lookup *all_subvols,
 				    struct root_lookup *sort_tree,
 				    struct btrfs_list_filter_set *filter_set,
 				    struct btrfs_list_comparer_set *comp_set,
-				    int fd)
+				    u64 top_id)
 {
 	struct rb_node *n;
 	struct root_info *entry;
 	int ret;
-	u64 top_id = btrfs_list_get_path_rootid(fd);
 
 	root_lookup_init(sort_tree);
 
@@ -1457,11 +1456,12 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
 
 int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-		       int is_tab_result)
+		       int is_tab_result, int full_path)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
 	int ret;
+	u64 top_id = (full_path ? 0 : btrfs_list_get_path_rootid(fd));
 
 	ret = __list_subvol_search(fd, &root_lookup);
 	if (ret) {
@@ -1479,7 +1479,7 @@ int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
 		return ret;
 
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
-				 comp_set, fd);
+				 comp_set, top_id);
 
 	print_all_volume_info(&root_sort, is_tab_result);
 	__free_all_subvolumn(&root_lookup);
diff --git a/btrfs-list.h b/btrfs-list.h
index f7fbea6..658e1ad 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -101,7 +101,7 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
 
 int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
-			int is_tab_result);
+		       int is_tab_result, int full_path);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0aa7467..88158f0 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -310,7 +310,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	char *subvol;
 	int is_tab_result = 0;
 	int is_list_all = 0;
-	int is_only_in_path = 1;
+	int is_only_in_path = 0;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
 		{0, 0, 0, 0}
@@ -418,7 +418,8 @@ static int cmd_subvol_list(int argc, char **argv)
 					top_id);
 
 	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
-				is_tab_result);
+				is_tab_result,
+				!is_list_all && !is_only_in_path);
 	if (ret)
 		return 19;
 	return 0;
@@ -624,7 +625,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
 				default_id);
 
-	ret = btrfs_list_subvols(fd, filter_set, NULL, 0);
+	ret = btrfs_list_subvols(fd, filter_set, NULL, 0, 1);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.7.6

