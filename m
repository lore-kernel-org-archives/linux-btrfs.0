Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:57924 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755402Ab3BYVzQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/17] btrfs-progs: btrfs_list_get_path_rootid error handling
Date: Mon, 25 Feb 2013 16:54:37 -0600
Message-Id: <1361832890-40921-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_list_get_path_rootid() tries to return a negative
number on error, but it's a u64 function.  Callers which test
for a return < 0 will never see an error.

Change the function to fill in the rootid via a pointer,
and then return a simple int as error.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-list.c     |   31 +++++++++++++++++++++++--------
 btrfs-list.h     |    2 +-
 cmds-subvolume.c |   14 +++++++++-----
 3 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index ab9179f..851c059 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1500,8 +1500,13 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 {
 	struct root_lookup root_lookup;
 	struct root_lookup root_sort;
-	int ret;
-	u64 top_id = (full_path ? 0 : btrfs_list_get_path_rootid(fd));
+	int ret = 0;
+	u64 top_id = 0;
+
+	if (full_path)
+		ret = btrfs_list_get_path_rootid(fd, &top_id);
+	if (ret)
+		return ret;
 
 	ret = btrfs_list_subvols(fd, &root_lookup);
 	if (ret)
@@ -1524,13 +1529,18 @@ char *strdup_or_null(const char *s)
 
 int btrfs_get_subvol(int fd, struct root_info *the_ri)
 {
-	int ret = 1, rr;
+	int ret, rr;
 	struct root_lookup rl;
 	struct rb_node *rbn;
 	struct root_info *ri;
-	u64 root_id = btrfs_list_get_path_rootid(fd);
+	u64 root_id;
+
+	ret = btrfs_list_get_path_rootid(fd, &root_id);
+	if (ret)
+		return ret;
 
-	if (btrfs_list_subvols(fd, &rl))
+	ret = btrfs_list_subvols(fd, &rl);
+	if (ret)
 		return ret;
 
 	rbn = rb_first(&rl.root);
@@ -1741,7 +1751,11 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 	struct rb_node *n;
 	char *ret_path = NULL;
 	int ret;
-	u64 top_id = btrfs_list_get_path_rootid(fd);
+	u64 top_id;
+
+	ret = btrfs_list_get_path_rootid(fd, &top_id);
+	if (ret)
+		return ERR_PTR(ret);
 
 	ret = __list_subvol_search(fd, &root_lookup);
 	if (ret < 0)
@@ -1868,7 +1882,7 @@ int btrfs_list_parse_filter_string(char *optarg,
 	return 0;
 }
 
-u64 btrfs_list_get_path_rootid(int fd)
+int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 {
 	int  ret;
 	struct btrfs_ioctl_ino_lookup_args args;
@@ -1883,5 +1897,6 @@ u64 btrfs_list_get_path_rootid(int fd)
 			strerror(errno));
 		return ret;
 	}
-	return args.treeid;
+	*treeid = args.treeid;
+	return 0;
 }
diff --git a/btrfs-list.h b/btrfs-list.h
index 5d87454..2894451 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -156,5 +156,5 @@ int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
 int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int btrfs_list_get_default_subvolume(int fd, u64 *default_id);
 char *btrfs_list_path_for_root(int fd, u64 root);
-u64 btrfs_list_get_path_rootid(int fd);
+int btrfs_list_get_path_rootid(int fd, u64 *treeid);
 int btrfs_get_subvol(int fd, struct root_info *the_ri);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ea128fc..f9258fc 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -433,7 +433,11 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
-	top_id = btrfs_list_get_path_rootid(fd);
+	ret = btrfs_list_get_path_rootid(fd, &top_id);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't get rootid for '%s'\n", subvol);
+		goto out;
+	}
 
 	if (is_list_all)
 		btrfs_list_setup_filter(&filter_set,
@@ -821,8 +825,8 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	sv_id = btrfs_list_get_path_rootid(fd);
-	if (sv_id < 0) {
+	ret = btrfs_list_get_path_rootid(fd, &sv_id);
+	if (ret) {
 		fprintf(stderr, "ERROR: can't get rootid for '%s'\n",
 			fullpath);
 		goto out;
@@ -834,8 +838,8 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	mntid = btrfs_list_get_path_rootid(mntfd);
-	if (mntid < 0) {
+	ret = btrfs_list_get_path_rootid(mntfd, &mntid);
+	if (ret) {
 		fprintf(stderr, "ERROR: can't get rootid for '%s'\n", mnt);
 		goto out;
 	}
-- 
1.7.1

