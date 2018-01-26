Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37977 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbeAZSlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:44 -0500
Received: by mail-pg0-f66.google.com with SMTP id y27so790344pgc.5
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:43 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 21/26] btrfs-progs: use libbtrfsutil for subvol show
Date: Fri, 26 Jan 2018 10:41:09 -0800
Message-Id: <537f3ffac3eac01c6a36f613817f9c3f206ee568.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now implemented with btrfs_util_subvolume_path(),
btrfs_util_subvolume_info(), and subvolume iterators.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 150 ++++++++++++++++++++++++++++++++++++-------------------
 utils.c          | 118 -------------------------------------------
 utils.h          |   5 --
 3 files changed, 99 insertions(+), 174 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c5e03011..b969fc88 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -825,19 +825,20 @@ static const char * const cmd_subvol_show_usage[] = {
 
 static int cmd_subvol_show(int argc, char **argv)
 {
-	struct root_info get_ri;
-	struct btrfs_list_filter_set *filter_set = NULL;
 	char tstr[256];
 	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 	char *fullpath = NULL;
-	char raw_prefix[] = "\t\t\t\t";
 	int fd = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL;
 	int by_rootid = 0;
 	int by_uuid = 0;
-	u64 rootid_arg;
+	u64 rootid_arg = 0;
 	u8 uuid_arg[BTRFS_UUID_SIZE];
+	struct btrfs_util_subvolume_iterator *iter;
+	struct btrfs_util_subvolume_info subvol;
+	char *subvol_path = NULL;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c;
@@ -874,7 +875,6 @@ static int cmd_subvol_show(int argc, char **argv)
 		usage(cmd_subvol_show_usage);
 	}
 
-	memset(&get_ri, 0, sizeof(get_ri));
 	fullpath = realpath(argv[optind], NULL);
 	if (!fullpath) {
 		error("cannot find real path for '%s': %s",
@@ -882,89 +882,137 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	if (by_rootid) {
-		ret = get_subvol_info_by_rootid(fullpath, &get_ri, rootid_arg);
-	} else if (by_uuid) {
-		ret = get_subvol_info_by_uuid(fullpath, &get_ri, uuid_arg);
-	} else {
-		ret = get_subvol_info(fullpath, &get_ri);
+	fd = open_file_or_dir(fullpath, &dirstream1);
+	if (fd < 0) {
+		error("can't access '%s'", fullpath);
+		goto out;
 	}
 
-	if (ret) {
-		if (ret < 0) {
-			error("Failed to get subvol info %s: %s",
-					fullpath, strerror(-ret));
-		} else {
-			error("Failed to get subvol info %s: %d",
-					fullpath, ret);
+	if (by_uuid) {
+		err = btrfs_util_f_create_subvolume_iterator(fd,
+							     BTRFS_FS_TREE_OBJECTID,
+							     0, &iter);
+		if (err) {
+			error_btrfs_util(err);
+			goto out;
+		}
+
+		for (;;) {
+			err = btrfs_util_subvolume_iterator_next_info(iter,
+								      &subvol_path,
+								      &subvol);
+			if (err == BTRFS_UTIL_ERROR_STOP_ITERATION) {
+				uuid_unparse(uuid_arg, uuidparse);
+				error("can't find uuid '%s' on '%s'", uuidparse,
+				      fullpath);
+				btrfs_util_destroy_subvolume_iterator(iter);
+				goto out;
+			} else if (err) {
+				error_btrfs_util(err);
+				btrfs_util_destroy_subvolume_iterator(iter);
+				goto out;
+			}
+
+			if (uuid_compare(subvol.uuid, uuid_arg) == 0)
+				break;
+
+			free(subvol_path);
+		}
+		btrfs_util_destroy_subvolume_iterator(iter);
+	} else {
+		/*
+		 * If !by_rootid, rootid_arg = 0, which means find the
+		 * subvolume ID of the fd and use that.
+		 */
+		err = btrfs_util_f_subvolume_info(fd, rootid_arg,
+						  &subvol);
+		if (err) {
+			error_btrfs_util(err);
+			goto out;
+		}
+
+		err = btrfs_util_f_subvolume_path(fd, subvol.id, &subvol_path);
+		if (err) {
+			error_btrfs_util(err);
+			goto out;
 		}
-		return ret;
+
 	}
 
 	/* print the info */
-	printf("%s\n", get_ri.full_path);
-	printf("\tName: \t\t\t%s\n", get_ri.name);
+	printf("%s\n", subvol.id == BTRFS_FS_TREE_OBJECTID ? "/" : subvol_path);
+	printf("\tName: \t\t\t%s\n",
+	       (subvol.id == BTRFS_FS_TREE_OBJECTID ? "<FS_TREE>" :
+		basename(subvol_path)));
 
-	if (uuid_is_null(get_ri.uuid))
+	if (uuid_is_null(subvol.uuid))
 		strcpy(uuidparse, "-");
 	else
-		uuid_unparse(get_ri.uuid, uuidparse);
+		uuid_unparse(subvol.uuid, uuidparse);
 	printf("\tUUID: \t\t\t%s\n", uuidparse);
 
-	if (uuid_is_null(get_ri.puuid))
+	if (uuid_is_null(subvol.parent_uuid))
 		strcpy(uuidparse, "-");
 	else
-		uuid_unparse(get_ri.puuid, uuidparse);
+		uuid_unparse(subvol.parent_uuid, uuidparse);
 	printf("\tParent UUID: \t\t%s\n", uuidparse);
 
-	if (uuid_is_null(get_ri.ruuid))
+	if (uuid_is_null(subvol.received_uuid))
 		strcpy(uuidparse, "-");
 	else
-		uuid_unparse(get_ri.ruuid, uuidparse);
+		uuid_unparse(subvol.received_uuid, uuidparse);
 	printf("\tReceived UUID: \t\t%s\n", uuidparse);
 
-	if (get_ri.otime) {
+	if (subvol.otime.tv_sec) {
 		struct tm tm;
 
-		localtime_r(&get_ri.otime, &tm);
+		localtime_r(&subvol.otime.tv_sec, &tm);
 		strftime(tstr, 256, "%Y-%m-%d %X %z", &tm);
 	} else
 		strcpy(tstr, "-");
 	printf("\tCreation time: \t\t%s\n", tstr);
 
-	printf("\tSubvolume ID: \t\t%llu\n", get_ri.root_id);
-	printf("\tGeneration: \t\t%llu\n", get_ri.gen);
-	printf("\tGen at creation: \t%llu\n", get_ri.ogen);
-	printf("\tParent ID: \t\t%llu\n", get_ri.ref_tree);
-	printf("\tTop level ID: \t\t%llu\n", get_ri.top_id);
+	printf("\tSubvolume ID: \t\t%" PRIu64 "\n", subvol.id);
+	printf("\tGeneration: \t\t%" PRIu64 "\n", subvol.generation);
+	printf("\tGen at creation: \t%" PRIu64 "\n", subvol.otransid);
+	printf("\tParent ID: \t\t%" PRIu64 "\n", subvol.parent_id);
+	printf("\tTop level ID: \t\t%" PRIu64 "\n", subvol.parent_id);
 
-	if (get_ri.flags & BTRFS_ROOT_SUBVOL_RDONLY)
+	if (subvol.flags & BTRFS_ROOT_SUBVOL_RDONLY)
 		printf("\tFlags: \t\t\treadonly\n");
 	else
 		printf("\tFlags: \t\t\t-\n");
 
 	/* print the snapshots of the given subvol if any*/
 	printf("\tSnapshot(s):\n");
-	filter_set = btrfs_list_alloc_filter_set();
-	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_BY_PARENT,
-				(u64)(unsigned long)get_ri.uuid);
-	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
 
-	fd = open_file_or_dir(fullpath, &dirstream1);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
-		goto out;
+	err = btrfs_util_f_create_subvolume_iterator(fd,
+						     BTRFS_FS_TREE_OBJECTID,
+						     0, &iter);
+
+	for (;;) {
+		struct btrfs_util_subvolume_info subvol2;
+		char *path;
+
+		err = btrfs_util_subvolume_iterator_next_info(iter, &path, &subvol2);
+		if (err == BTRFS_UTIL_ERROR_STOP_ITERATION) {
+			break;
+		} else if (err) {
+			error_btrfs_util(err);
+			btrfs_util_destroy_subvolume_iterator(iter);
+			goto out;
+		}
+
+		if (uuid_compare(subvol2.parent_uuid, subvol.uuid) == 0)
+			printf("\t\t\t\t%s\n", path);
+
+		free(path);
 	}
-	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
-			1, raw_prefix);
+	btrfs_util_destroy_subvolume_iterator(iter);
 
+	ret = 0;
 out:
-	/* clean up */
-	free(get_ri.path);
-	free(get_ri.name);
-	free(get_ri.full_path);
-	free(filter_set);
-
+	free(subvol_path);
 	close_file_or_dir(fd, dirstream1);
 	free(fullpath);
 	return !!ret;
diff --git a/utils.c b/utils.c
index 524f463d..6a667907 100644
--- a/utils.c
+++ b/utils.c
@@ -2482,124 +2482,6 @@ const char *subvol_strip_mountpoint(const char *mnt, const char *full_path)
 	return full_path + len;
 }
 
-/*
- * Returns
- * <0: Std error
- * 0: All fine
- * 1: Error; and error info printed to the terminal. Fixme.
- * 2: If the fullpath is root tree instead of subvol tree
- */
-int get_subvol_info(const char *fullpath, struct root_info *get_ri)
-{
-	u64 sv_id;
-	int ret = 1;
-	int fd = -1;
-	int mntfd = -1;
-	char *mnt = NULL;
-	const char *svpath = NULL;
-	DIR *dirstream1 = NULL;
-	DIR *dirstream2 = NULL;
-
-	ret = test_issubvolume(fullpath);
-	if (ret < 0)
-		return ret;
-	if (!ret) {
-		error("not a subvolume: %s", fullpath);
-		return 1;
-	}
-
-	ret = find_mount_root(fullpath, &mnt);
-	if (ret < 0)
-		return ret;
-	if (ret > 0) {
-		error("%s doesn't belong to btrfs mount point", fullpath);
-		return 1;
-	}
-	ret = 1;
-	svpath = subvol_strip_mountpoint(mnt, fullpath);
-
-	fd = btrfs_open_dir(fullpath, &dirstream1, 1);
-	if (fd < 0)
-		goto out;
-
-	ret = btrfs_list_get_path_rootid(fd, &sv_id);
-	if (ret)
-		goto out;
-
-	mntfd = btrfs_open_dir(mnt, &dirstream2, 1);
-	if (mntfd < 0)
-		goto out;
-
-	memset(get_ri, 0, sizeof(*get_ri));
-	get_ri->root_id = sv_id;
-
-	if (sv_id == BTRFS_FS_TREE_OBJECTID)
-		ret = btrfs_get_toplevel_subvol(mntfd, get_ri);
-	else
-		ret = btrfs_get_subvol(mntfd, get_ri);
-	if (ret)
-		error("can't find '%s': %d", svpath, ret);
-
-out:
-	close_file_or_dir(mntfd, dirstream2);
-	close_file_or_dir(fd, dirstream1);
-	free(mnt);
-
-	return ret;
-}
-
-int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri, u64 r_id)
-{
-	int fd;
-	int ret;
-	DIR *dirstream = NULL;
-
-	fd = btrfs_open_dir(mnt, &dirstream, 1);
-	if (fd < 0)
-		return -EINVAL;
-
-	memset(get_ri, 0, sizeof(*get_ri));
-	get_ri->root_id = r_id;
-
-	if (r_id == BTRFS_FS_TREE_OBJECTID)
-		ret = btrfs_get_toplevel_subvol(fd, get_ri);
-	else
-		ret = btrfs_get_subvol(fd, get_ri);
-
-	if (ret)
-		error("can't find rootid '%llu' on '%s': %d", r_id, mnt, ret);
-
-	close_file_or_dir(fd, dirstream);
-
-	return ret;
-}
-
-int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri, u8 *uuid_arg)
-{
-	int fd;
-	int ret;
-	DIR *dirstream = NULL;
-
-	fd = btrfs_open_dir(mnt, &dirstream, 1);
-	if (fd < 0)
-		return -EINVAL;
-
-	memset(get_ri, 0, sizeof(*get_ri));
-	uuid_copy(get_ri->uuid, uuid_arg);
-
-	ret = btrfs_get_subvol(fd, get_ri);
-	if (ret) {
-		char uuid_parsed[BTRFS_UUID_UNPARSED_SIZE];
-		uuid_unparse(uuid_arg, uuid_parsed);
-		error("can't find uuid '%s' on '%s': %d",
-					uuid_parsed, mnt, ret);
-	}
-
-	close_file_or_dir(fd, dirstream);
-
-	return ret;
-}
-
 /* Set the seed manually */
 void init_rand_seed(u64 seed)
 {
diff --git a/utils.h b/utils.h
index a82d46f6..4a95bfb5 100644
--- a/utils.h
+++ b/utils.h
@@ -151,11 +151,6 @@ int test_issubvolume(const char *path);
 int test_isdir(const char *path);
 
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
-int get_subvol_info(const char *fullpath, struct root_info *get_ri);
-int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri,
-							u64 rootid_arg);
-int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri,
-							u8 *uuid_arg);
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 const char* btrfs_group_type_str(u64 flag);
 const char* btrfs_group_profile_str(u64 flag);
-- 
2.16.1

