Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:37562 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbeCOIOX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 04:14:23 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 27549AC01B8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:14:21 +0900 (JST)
Received: from G01JPEXCHYT16.g01.fujitsu.local (G01JPEXCHYT16.g01.fujitsu.local [10.128.194.55])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 528DB584371
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:14:20 +0900 (JST)
Subject: [RFC PATCH v2 4/8] btrfs-progs: sub list: Pass specified path down to
 btrfs_list_subvols()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Message-ID: <57ae04d6-c101-ed3f-b451-57fd42e03fe2@jp.fujitsu.com>
Date: Thu, 15 Mar 2018 17:14:17 +0900
MIME-Version: 1.0
In-Reply-To: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparetion work to allow normal user to call
"subvolume list/show".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c     | 16 +++++++++-------
 btrfs-list.h     |  7 ++++---
 cmds-subvolume.c |  6 +++---
 utils.c          | 10 +++++-----
 4 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 88689a9d..2e82dc5c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1522,7 +1522,8 @@ next:
 	}
 }
 
-static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
+static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
+			const char *path)
 {
 	int ret;
 
@@ -1543,7 +1544,7 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
 		       enum btrfs_list_layout layout, int full_path,
-		       const char *raw_prefix)
+		       const char *raw_prefix, const char *path)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1555,7 +1556,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &root_lookup);
+	ret = btrfs_list_subvols(fd, &root_lookup, path);
 	if (ret) {
 		rb_free_nodes(&root_lookup.root, free_root_info);
 		return ret;
@@ -1576,7 +1577,8 @@ static char *strdup_or_null(const char *s)
 	return strdup(s);
 }
 
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri,
+			const char *path)
 {
 	int ret;
 	struct root_lookup rl;
@@ -1588,7 +1590,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &rl);
+	ret = btrfs_list_subvols(fd, &rl, path);
 	if (ret) {
 		rb_free_nodes(&rl.root, free_root_info);
 		return ret;
@@ -1611,7 +1613,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 	return ret;
 }
 
-int btrfs_get_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
 {
 	int ret, rr;
 	struct root_lookup rl;
@@ -1623,7 +1625,7 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &rl);
+	ret = btrfs_list_subvols(fd, &rl, path);
 	if (ret) {
 		rb_free_nodes(&rl.root, free_root_info);
 		return ret;
diff --git a/btrfs-list.h b/btrfs-list.h
index 6225311d..eb21bebe 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -169,13 +169,14 @@ struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void);
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
 		       enum btrfs_list_layout layot, int full_path,
-		       const char *raw_prefix);
+		       const char *raw_prefix, const char *path);
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
 int btrfs_list_get_path_rootid(int fd, u64 *treeid);
-int btrfs_get_subvol(int fd, struct root_info *the_ri);
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri);
+int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path);
+int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri,
+			const char *path);
 int check_perm_for_tree_search(int fd);
 
 #endif
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8a473f7a..faa10c5a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -620,7 +620,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
-			layout, !is_list_all && !is_only_in_path, NULL);
+			layout, !is_list_all && !is_only_in_path, NULL, subvol);
 
 out:
 	close_file_or_dir(fd, dirstream);
@@ -844,7 +844,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print(fd, filter_set, NULL,
-		BTRFS_LIST_LAYOUT_DEFAULT, 1, NULL);
+		BTRFS_LIST_LAYOUT_DEFAULT, 1, NULL, subvol);
 
 	if (filter_set)
 		free(filter_set);
@@ -1110,7 +1110,7 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
-			1, raw_prefix);
+			1, raw_prefix, fullpath);
 
 out:
 	/* clean up */
diff --git a/utils.c b/utils.c
index e9cb3a82..81c54faa 100644
--- a/utils.c
+++ b/utils.c
@@ -2542,9 +2542,9 @@ int get_subvol_info(const char *fullpath, struct root_info *get_ri)
 	get_ri->root_id = sv_id;
 
 	if (sv_id == BTRFS_FS_TREE_OBJECTID)
-		ret = btrfs_get_toplevel_subvol(mntfd, get_ri);
+		ret = btrfs_get_toplevel_subvol(mntfd, get_ri, mnt);
 	else
-		ret = btrfs_get_subvol(mntfd, get_ri);
+		ret = btrfs_get_subvol(mntfd, get_ri, mnt);
 	if (ret)
 		error("can't find '%s': %d", svpath, ret);
 
@@ -2570,9 +2570,9 @@ int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri, u64 r_i
 	get_ri->root_id = r_id;
 
 	if (r_id == BTRFS_FS_TREE_OBJECTID)
-		ret = btrfs_get_toplevel_subvol(fd, get_ri);
+		ret = btrfs_get_toplevel_subvol(fd, get_ri, mnt);
 	else
-		ret = btrfs_get_subvol(fd, get_ri);
+		ret = btrfs_get_subvol(fd, get_ri, mnt);
 
 	if (ret)
 		error("can't find rootid '%llu' on '%s': %d", r_id, mnt, ret);
@@ -2595,7 +2595,7 @@ int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri, u8 *uuid_
 	memset(get_ri, 0, sizeof(*get_ri));
 	uuid_copy(get_ri->uuid, uuid_arg);
 
-	ret = btrfs_get_subvol(fd, get_ri);
+	ret = btrfs_get_subvol(fd, get_ri, mnt);
 	if (ret) {
 		char uuid_parsed[BTRFS_UUID_UNPARSED_SIZE];
 		uuid_unparse(uuid_arg, uuid_parsed);
-- 
2.14.3

