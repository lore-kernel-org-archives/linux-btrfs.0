Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36736 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeAZSlm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:42 -0500
Received: by mail-pf0-f196.google.com with SMTP id 23so821869pfp.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:41 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 19/26] btrfs-progs: use libbtrfsutil for subvol create and snapshot
Date: Fri, 26 Jan 2018 10:41:07 -0800
Message-Id: <ab09ba595157b7fb6606814730508cae4da48caf.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

These become trivial calls to the libbtrfsutil helpers, and we can get
rid of the qgroup inherit code in progs.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 225 ++++++++++++++-----------------------------------------
 qgroup.c         |  64 ----------------
 qgroup.h         |   2 -
 3 files changed, 58 insertions(+), 233 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 557108c1..6b474fe4 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -103,6 +103,35 @@ static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 	return 0;
 }
 
+static int qgroup_inherit_add_group(struct btrfs_util_qgroup_inherit **inherit,
+				    const char *arg)
+{
+	enum btrfs_util_error err;
+	u64 qgroupid;
+
+	if (!*inherit) {
+		err = btrfs_util_create_qgroup_inherit(0, inherit);
+		if (err) {
+			error_btrfs_util(err);
+			return -1;
+		}
+	}
+
+	qgroupid = parse_qgroupid(optarg);
+	if (qgroupid == 0) {
+		error("invalid qgroup specification, qgroupid must not be 0");
+		return -1;
+	}
+
+	err = btrfs_util_qgroup_inherit_add_group(inherit, qgroupid);
+	if (err) {
+		error_btrfs_util(err);
+		return -1;
+	}
+
+	return 0;
+}
+
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
 	NULL
@@ -121,15 +150,9 @@ static const char * const cmd_subvol_create_usage[] = {
 
 static int cmd_subvol_create(int argc, char **argv)
 {
-	int	retval, res, len;
-	int	fddst = -1;
-	char	*dupname = NULL;
-	char	*dupdir = NULL;
-	char	*newname;
-	char	*dstdir;
-	char	*dst;
-	struct btrfs_qgroup_inherit *inherit = NULL;
-	DIR	*dirstream = NULL;
+	struct btrfs_util_qgroup_inherit *inherit = NULL;
+	enum btrfs_util_error err;
+	int retval = 1;
 
 	while (1) {
 		int c = getopt(argc, argv, "i:");
@@ -138,11 +161,8 @@ static int cmd_subvol_create(int argc, char **argv)
 
 		switch (c) {
 		case 'i':
-			res = qgroup_inherit_add_group(&inherit, optarg);
-			if (res) {
-				retval = res;
+			if (qgroup_inherit_add_group(&inherit, optarg) == -1)
 				goto out;
-			}
 			break;
 		default:
 			usage(cmd_subvol_create_usage);
@@ -152,70 +172,18 @@ static int cmd_subvol_create(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_create_usage);
 
-	dst = argv[optind];
-
-	retval = 1;	/* failure */
-	res = test_isdir(dst);
-	if (res < 0 && res != -ENOENT) {
-		error("cannot access %s: %s", dst, strerror(-res));
-		goto out;
-	}
-	if (res >= 0) {
-		error("target path already exists: %s", dst);
-		goto out;
-	}
-
-	dupname = strdup(dst);
-	newname = basename(dupname);
-	dupdir = strdup(dst);
-	dstdir = dirname(dupdir);
-
-	if (!test_issubvolname(newname)) {
-		error("invalid subvolume name: %s", newname);
-		goto out;
-	}
-
-	len = strlen(newname);
-	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		error("subvolume name too long: %s", newname);
-		goto out;
-	}
-
-	fddst = btrfs_open_dir(dstdir, &dirstream, 1);
-	if (fddst < 0)
-		goto out;
-
-	printf("Create subvolume '%s/%s'\n", dstdir, newname);
-	if (inherit) {
-		struct btrfs_ioctl_vol_args_v2	args;
-
-		memset(&args, 0, sizeof(args));
-		strncpy_null(args.name, newname);
-		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
-		args.size = qgroup_inherit_size(inherit);
-		args.qgroup_inherit = inherit;
-
-		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE_V2, &args);
-	} else {
-		struct btrfs_ioctl_vol_args	args;
-
-		memset(&args, 0, sizeof(args));
-		strncpy_null(args.name, newname);
-
-		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
-	}
+	printf("Create subvolume '%s'\n", argv[optind]);
 
-	if (res < 0) {
-		error("cannot create subvolume: %s", strerror(errno));
+	err = btrfs_util_create_subvolume(argv[optind], 0, NULL, inherit);
+	if (err) {
+		error_btrfs_util(err);
 		goto out;
 	}
 
-	retval = 0;	/* success */
+	retval = 0;
 out:
-	close_file_or_dir(fddst, dirstream);
-	free(inherit);
-	free(dupname);
-	free(dupdir);
+	if (inherit)
+		btrfs_util_destroy_qgroup_inherit(inherit);
 
 	return retval;
 }
@@ -653,19 +621,11 @@ static const char * const cmd_subvol_snapshot_usage[] = {
 
 static int cmd_subvol_snapshot(int argc, char **argv)
 {
-	char	*subvol, *dst;
-	int	res, retval;
-	int	fd = -1, fddst = -1;
-	int	len, readonly = 0;
-	char	*dupname = NULL;
-	char	*dupdir = NULL;
-	char	*newname;
-	char	*dstdir;
-	struct btrfs_ioctl_vol_args_v2	args;
-	struct btrfs_qgroup_inherit *inherit = NULL;
-	DIR *dirstream1 = NULL, *dirstream2 = NULL;
+	struct btrfs_util_qgroup_inherit *inherit = NULL;
+	enum btrfs_util_error err;
+	int flags = 0;
+	int retval = 1;
 
-	memset(&args, 0, sizeof(args));
 	while (1) {
 		int c = getopt(argc, argv, "i:r");
 		if (c < 0)
@@ -673,14 +633,11 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 
 		switch (c) {
 		case 'i':
-			res = qgroup_inherit_add_group(&inherit, optarg);
-			if (res) {
-				retval = res;
+			if (qgroup_inherit_add_group(&inherit, optarg) == -1)
 				goto out;
-			}
 			break;
 		case 'r':
-			readonly = 1;
+			flags |= BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY;
 			break;
 		default:
 			usage(cmd_subvol_snapshot_usage);
@@ -690,92 +647,26 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_subvol_snapshot_usage);
 
-	subvol = argv[optind];
-	dst = argv[optind + 1];
-
-	retval = 1;	/* failure */
-	res = test_issubvolume(subvol);
-	if (res < 0) {
-		error("cannot access subvolume %s: %s", subvol, strerror(-res));
-		goto out;
-	}
-	if (!res) {
-		error("not a subvolume: %s", subvol);
-		goto out;
-	}
-
-	res = test_isdir(dst);
-	if (res < 0 && res != -ENOENT) {
-		error("cannot access %s: %s", dst, strerror(-res));
-		goto out;
-	}
-	if (res == 0) {
-		error("'%s' exists and it is not a directory", dst);
-		goto out;
-	}
-
-	if (res > 0) {
-		dupname = strdup(subvol);
-		newname = basename(dupname);
-		dstdir = dst;
+	if (flags & BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY) {
+		printf("Create a readonly snapshot of '%s' in '%s'\n",
+		       argv[optind], argv[optind + 1]);
 	} else {
-		dupname = strdup(dst);
-		newname = basename(dupname);
-		dupdir = strdup(dst);
-		dstdir = dirname(dupdir);
+		printf("Create a snapshot of '%s' in '%s'\n", argv[optind],
+		       argv[optind + 1]);
 	}
 
-	if (!test_issubvolname(newname)) {
-		error("invalid snapshot name '%s'", newname);
-		goto out;
-	}
-
-	len = strlen(newname);
-	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		error("snapshot name too long '%s'", newname);
-		goto out;
-	}
-
-	fddst = btrfs_open_dir(dstdir, &dirstream1, 1);
-	if (fddst < 0)
-		goto out;
-
-	fd = btrfs_open_dir(subvol, &dirstream2, 1);
-	if (fd < 0)
-		goto out;
-
-	if (readonly) {
-		args.flags |= BTRFS_SUBVOL_RDONLY;
-		printf("Create a readonly snapshot of '%s' in '%s/%s'\n",
-		       subvol, dstdir, newname);
-	} else {
-		printf("Create a snapshot of '%s' in '%s/%s'\n",
-		       subvol, dstdir, newname);
-	}
-
-	args.fd = fd;
-	if (inherit) {
-		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
-		args.size = qgroup_inherit_size(inherit);
-		args.qgroup_inherit = inherit;
-	}
-	strncpy_null(args.name, newname);
-
-	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
-
-	if (res < 0) {
-		error("cannot snapshot '%s': %s", subvol, strerror(errno));
+	err = btrfs_util_create_snapshot(argv[optind], argv[optind + 1], flags,
+					 NULL, inherit);
+	if (err) {
+		error_btrfs_util(err);
 		goto out;
 	}
 
-	retval = 0;	/* success */
 
+	retval = 0;
 out:
-	close_file_or_dir(fddst, dirstream1);
-	close_file_or_dir(fd, dirstream2);
-	free(inherit);
-	free(dupname);
-	free(dupdir);
+	if (inherit)
+		btrfs_util_destroy_qgroup_inherit(inherit);
 
 	return retval;
 }
diff --git a/qgroup.c b/qgroup.c
index e9158a26..6e5fdb01 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1246,67 +1246,3 @@ out:
 	free(opt_tmp);
 	return ret;
 }
-
-int qgroup_inherit_size(struct btrfs_qgroup_inherit *p)
-{
-	return sizeof(*p) + sizeof(p->qgroups[0]) *
-			    (p->num_qgroups + 2 * p->num_ref_copies +
-			     2 * p->num_excl_copies);
-}
-
-static int
-qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
-{
-	struct btrfs_qgroup_inherit *out;
-	int nitems = 0;
-
-	if (*inherit) {
-		nitems = (*inherit)->num_qgroups +
-			 (*inherit)->num_ref_copies +
-			 (*inherit)->num_excl_copies;
-	}
-
-	out = calloc(sizeof(*out) + sizeof(out->qgroups[0]) * (nitems + n), 1);
-	if (out == NULL) {
-		error("not enough memory");
-		return -ENOMEM;
-	}
-
-	if (*inherit) {
-		struct btrfs_qgroup_inherit *i = *inherit;
-		int s = sizeof(out->qgroups[0]);
-
-		out->num_qgroups = i->num_qgroups;
-		out->num_ref_copies = i->num_ref_copies;
-		out->num_excl_copies = i->num_excl_copies;
-		memcpy(out->qgroups, i->qgroups, pos * s);
-		memcpy(out->qgroups + pos + n, i->qgroups + pos,
-		       (nitems - pos) * s);
-	}
-	free(*inherit);
-	*inherit = out;
-
-	return 0;
-}
-
-int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
-{
-	int ret;
-	u64 qgroupid = parse_qgroupid(arg);
-	int pos = 0;
-
-	if (qgroupid == 0) {
-		error("invalid qgroup specification, qgroupid must not 0");
-		return -EINVAL;
-	}
-
-	if (*inherit)
-		pos = (*inherit)->num_qgroups;
-	ret = qgroup_inherit_realloc(inherit, 1, pos);
-	if (ret)
-		return ret;
-
-	(*inherit)->qgroups[(*inherit)->num_qgroups++] = qgroupid;
-
-	return 0;
-}
diff --git a/qgroup.h b/qgroup.h
index bb6610d7..97c6cd9e 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -90,7 +90,5 @@ struct btrfs_qgroup_comparer_set *btrfs_qgroup_alloc_comparer_set(void);
 int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
 				enum btrfs_qgroup_comp_enum comparer,
 				int is_descending);
-int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
-int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
 
 #endif
-- 
2.16.1

