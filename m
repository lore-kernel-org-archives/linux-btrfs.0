Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:24210 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbeDWFJA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 01:09:00 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3DE99AC0108
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:08:54 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 658F546E62F
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 14:08:53 +0900 (JST)
Subject: [RFC PATCH v4 3/6] btrfs-progs: sub list: Pass specified path down to
 btrfs_list_subvols()
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <70590827-0c29-75ea-5e43-2e53264b3d4c@jp.fujitsu.com>
Message-ID: <c1175fba-fd26-7354-303d-00ebd3a10f18@jp.fujitsu.com>
Date: Mon, 23 Apr 2018 14:08:49 +0900
MIME-Version: 1.0
In-Reply-To: <70590827-0c29-75ea-5e43-2e53264b3d4c@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparetion work to allow normal user to call
"subvolume list".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 btrfs-list.c     | 16 +++++++++-------
 btrfs-list.h     |  7 ++++---
 cmds-subvolume.c |  2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 50e5ce5f..833ff912 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1489,7 +1489,8 @@ next:
 	}
 }
 
-static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
+static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup,
+			const char *path)
 {
 	int ret;
 
@@ -1510,7 +1511,7 @@ static int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
 int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 		       struct btrfs_list_comparer_set *comp_set,
 		       enum btrfs_list_layout layout, int full_path,
-		       const char *raw_prefix)
+		       const char *raw_prefix, const char *path)
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
@@ -1522,7 +1523,7 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &root_lookup);
+	ret = btrfs_list_subvols(fd, &root_lookup, path);
 	if (ret) {
 		rb_free_nodes(&root_lookup.root, free_root_info);
 		return ret;
@@ -1543,7 +1544,8 @@ static char *strdup_or_null(const char *s)
 	return strdup(s);
 }
 
-int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri,
+			const char *path)
 {
 	int ret;
 	struct root_lookup rl;
@@ -1555,7 +1557,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &rl);
+	ret = btrfs_list_subvols(fd, &rl, path);
 	if (ret) {
 		rb_free_nodes(&rl.root, free_root_info);
 		return ret;
@@ -1578,7 +1580,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 	return ret;
 }
 
-int btrfs_get_subvol(int fd, struct root_info *the_ri)
+int btrfs_get_subvol(int fd, struct root_info *the_ri, const char *path)
 {
 	int ret, rr;
 	struct root_lookup rl;
@@ -1590,7 +1592,7 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 	if (ret)
 		return ret;
 
-	ret = btrfs_list_subvols(fd, &rl);
+	ret = btrfs_list_subvols(fd, &rl, path);
 	if (ret) {
 		rb_free_nodes(&rl.root, free_root_info);
 		return ret;
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc778..9b6720e6 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -169,12 +169,13 @@ struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void);
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
 
 #endif
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 45363a5a..89d03324 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -594,7 +594,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
-			layout, !is_list_all && !is_only_in_path, NULL);
+			layout, !is_list_all && !is_only_in_path, NULL, subvol);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.14.3

