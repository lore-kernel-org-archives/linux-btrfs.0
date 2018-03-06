Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:11401 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeCFIe7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:34:59 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 57082AC008E
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:34:56 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 8126D3286EB
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:34:55 +0900 (JST)
Subject: [PATCH 3/7] btrfs-progs: sub list: Pass specified path down to
 btrfs_list_subvols()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Message-ID: <85474f42-c4c5-ff32-65cf-fda8b4327bf9@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:34:52 +0900
MIME-Version: 1.0
In-Reply-To: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparetion work to allow normal user to call "subvolume list".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c     | 16 +++++++++-------
 btrfs-list.h     |  7 ++++---
 cmds-subvolume.c |  6 +++---
 utils.c          | 10 +++++-----
 4 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index aea917c5..1b49f4a1 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1519,7 +1519,8 @@ next:
 	}
 }
 
-static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
+static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
+			const char *path)
 {
 	int ret;
 
@@ -1540,7 +1541,7 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
 		       enum btrfs_list_layout layout, int full_path,
-		       const char *raw_prefix)
+		       const char *raw_prefix, const char *path)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1552,7 +1553,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &root_lookup);
+	ret = btrfs_list_subvols(fd, &root_lookup, path);
 	if (ret)
 		return ret;
 	filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
@@ -1571,7 +1572,8 @@ static char *strdup_or_null(const char *s)
 	return strdup(s);
 }
 
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri,
+			const char *path)
 {
 	int ret;
 	struct root_lookup rl;
@@ -1583,7 +1585,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &rl);
+	ret = btrfs_list_subvols(fd, &rl, path);
 	if (ret)
 		return ret;
 
@@ -1602,7 +1604,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 	return ret;
 }
 
-int btrfs_get_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
 {
 	int ret, rr;
 	struct root_lookup rl;
@@ -1614,7 +1616,7 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &rl);
+	ret = btrfs_list_subvols(fd, &rl, path);
 	if (ret)
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

