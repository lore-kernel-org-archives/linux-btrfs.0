Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50570 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KPRJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:16 -0500
Received: by mail-wg0-f48.google.com with SMTP id n12so4606441wgh.3
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:15 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 5/7] recursively btrfs subvolume snapshot
Date: Sat, 16 Nov 2013 18:09:05 +0100
Message-Id: <1384621747-25441-6-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a '-R' switch to btrfs subvolume snapshot to allow a recursively
subvolume snapshotting.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-subvolume.c | 213 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 167 insertions(+), 46 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 422e1fc..eb14ecd 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -567,14 +567,162 @@ out:
 	return !!ret;
 }
 
+static int do_snapshot(char *subvol, char *dstdir, char *newname,
+			int readonly,
+			struct btrfs_qgroup_inherit *inherit)
+{
+
+	int fd = -1, fddst = -1;
+	int res, retval = -1;
+	struct btrfs_ioctl_vol_args_v2	args = {0};
+	DIR *dirstream1 = NULL, *dirstream2 = NULL;
+
+	fddst = open_file_or_dir(dstdir, &dirstream1);
+	if (fddst < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		goto out;
+	}
+
+	fd = open_file_or_dir(subvol, &dirstream2);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		goto out;
+	}
+
+	if (readonly) {
+		args.flags |= BTRFS_SUBVOL_RDONLY;
+		printf("Create a readonly snapshot of '%s' in '%s/%s'\n",
+		       subvol, dstdir, newname);
+	} else {
+		printf("Create a snapshot of '%s' in '%s/%s'\n",
+		       subvol, dstdir, newname);
+	}
+
+	args.fd = fd;
+	if (inherit) {
+		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+		args.size = qgroup_inherit_size(inherit);
+		args.qgroup_inherit = inherit;
+	}
+	strncpy_null(args.name, newname);
+
+	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
+
+	if (res < 0) {
+		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
+			subvol, strerror(errno));
+		goto out;
+	}
+
+	retval = 0;	/* success */
+
+out:
+	close_file_or_dir(fddst, dirstream1);
+	close_file_or_dir(fd, dirstream2);
+
+	return retval;
+}
+
+
+static int cleanup_subvol_dir(char *sv_dst, char *sv_newname)
+{
+	char *path = pathjoin(sv_dst, sv_newname, NULL);
+	int ret;
+
+	if (!path)
+		return -1;
+
+	ret = rmdir(path);
+	free(path);
+
+	return ret;
+}
+
+struct rec_snapshot {
+	char *dstdir;
+	char *src;
+	char *newname;
+	int readonly:1;
+	int first:1;
+	struct btrfs_qgroup_inherit *inherit;
+};
+
+static int recursively_snapshot_func(char *real_root, char *relative_root,
+				     char *path, void *data)
+{
+
+	struct rec_snapshot	*rs = (struct rec_snapshot*)data;
+	char *sv_src = NULL;
+	char *sv_dst = NULL;
+	char *sv_newname = NULL;
+	int  ret=-1;
+
+	sv_src = pathjoin(rs->src, path, NULL);
+	sv_dst = pathjoin(rs->dstdir, rs->newname, path, NULL);
+
+	if (!sv_src || !sv_dst) {
+		free(sv_src);
+		free(sv_dst);
+		fprintf(stderr, "ERROR: not enough memory\n");
+		goto out;
+	}
+
+	sv_newname = strrchr(sv_dst, '/');
+	*sv_newname++ = 0;
+
+	if (!rs->first) {
+		ret = cleanup_subvol_dir(sv_dst, sv_newname);
+		if (ret) {
+			fprintf(stderr, "ERROR: cannot delete %s/%s\n",
+				sv_dst, sv_newname);
+			goto out;
+		}
+	}
+	rs->first = 0;
+
+	ret = do_snapshot(sv_src, sv_dst, sv_newname,
+				rs->readonly, rs->inherit);
+
+out:
+	free(sv_src);
+	free(sv_dst);
+
+	return ret;
+}
+
+static int recursively_snapshot(char *src, char *dstdir, char *newname,
+				int readonly,
+				struct btrfs_qgroup_inherit *inherit)
+{
+
+	struct rec_snapshot rs = {
+		.dstdir  	= dstdir,
+		.src     	= src,
+		.newname 	= newname,
+		.readonly 	= readonly,
+		.inherit 	= inherit,
+		.first 		= 1
+	};
+
+	int ret;
+
+	ret = traverse_list_subvol_rec(src, 0, 0, recursively_snapshot_func,
+				       (void *)&rs);
+
+	return ret;
+
+}
+
 static const char * const cmd_snapshot_usage[] = {
 	"btrfs subvolume snapshot [-r] <source> <dest>|[<dest>/]<name>",
-	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
+	"btrfs subvolume snapshot [-r][-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
+	"btrfs subvolume snapshot [-R][-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
 	"Create a snapshot of the subvolume",
 	"Create a writable/readonly snapshot of the subvolume <source> with",
 	"the name <name> in the <dest> directory.  If only <dest> is given,",
 	"the subvolume will be named the basename of <source>.",
 	"",
+	"-R             create snapshot recursively",
 	"-r             create a readonly snapshot",
 	"-i <qgroupid>  add the newly created snapshot to a qgroup. This",
 	"               option can be given multiple times.",
@@ -585,20 +733,18 @@ static int cmd_snapshot(int argc, char **argv)
 {
 	char	*subvol, *dst;
 	int	res, retval;
-	int	fd = -1, fddst = -1;
-	int	len, readonly = 0;
+	int	len, readonly = 0, rec=0;
 	char	*dupname = NULL;
 	char	*dupdir = NULL;
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
 	struct btrfs_qgroup_inherit *inherit = NULL;
-	DIR *dirstream1 = NULL, *dirstream2 = NULL;
 
 	optind = 1;
 	memset(&args, 0, sizeof(args));
 	while (1) {
-		int c = getopt(argc, argv, "c:i:r");
+		int c = getopt(argc, argv, "c:i:rR");
 		if (c < 0)
 			break;
 
@@ -620,6 +766,9 @@ static int cmd_snapshot(int argc, char **argv)
 		case 'r':
 			readonly = 1;
 			break;
+		case 'R':
+			rec = 1;
+			break;
 		case 'x':
 			res = qgroup_inherit_add_copy(&inherit, optarg, 1);
 			if (res) {
@@ -635,10 +784,17 @@ static int cmd_snapshot(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_snapshot_usage);
 
+	retval = 1;	/* failure */
+
+	if (rec && readonly) {
+		fprintf(stderr, "ERROR: impossible to make a recursively "
+				"readonly snapshot\n");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	dst = argv[optind + 1];
 
-	retval = 1;	/* failure */
 	res = test_issubvolume(subvol);
 	if (res < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
@@ -680,48 +836,13 @@ static int cmd_snapshot(int argc, char **argv)
 		goto out;
 	}
 
-	fddst = open_file_or_dir(dstdir, &dirstream1);
-	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
-		goto out;
-	}
-
-	fd = open_file_or_dir(subvol, &dirstream2);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
-		goto out;
-	}
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
-		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
-			subvol, strerror(errno));
-		goto out;
-	}
-
-	retval = 0;	/* success */
+	if (rec)
+		retval = recursively_snapshot(subvol, dstdir, newname,
+					   readonly, inherit);
+	else
+		retval = do_snapshot(subvol, dstdir, newname, readonly,inherit);
 
 out:
-	close_file_or_dir(fddst, dirstream1);
-	close_file_or_dir(fd, dirstream2);
 	free(inherit);
 	free(dupname);
 	free(dupdir);
-- 
1.8.4.3

