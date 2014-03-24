Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaCXX6i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 19:58:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A8A7BACCF
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 23:58:37 +0000 (UTC)
Message-ID: <5330C6AA.7010508@suse.com>
Date: Mon, 24 Mar 2014 19:58:34 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Arvin Schnell <aschnell@suse.de>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: allow use of subvolume id to create snapshots
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch uses the new BTRFS_SUBVOL_CREATE_SUBVOLID flag to create snapshots
by subvolume ID.

usage: btrfs subvolume snapshot [-r] [-q <qgroupid>] -s <subvolid> <dest>/<name>

Since we don't have a name for the source snapshot, the complete path to
the destination must be specified.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-subvolume.c |  101 +++++++++++++++++++++++++++++++++++++++++--------------
 ioctl.h          |    6 ++-
 man/btrfs.8.in   |   31 +++++++++++++++-
 3 files changed, 110 insertions(+), 28 deletions(-)

--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -14,6 +14,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -576,6 +577,7 @@ out:
 static const char * const cmd_snapshot_usage[] = {
 	"btrfs subvolume snapshot [-r] <source> <dest>|[<dest>/]<name>",
 	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
+	"btrfs subvolume snapshot [-r] [-i <qgroupid>] -s <subvolid> <dest>/<name>",
 	"Create a snapshot of the subvolume",
 	"Create a writable/readonly snapshot of the subvolume <source> with",
 	"the name <name> in the <dest> directory.  If only <dest> is given,",
@@ -584,12 +586,27 @@ static const char * const cmd_snapshot_u
 	"-r             create a readonly snapshot",
 	"-i <qgroupid>  add the newly created snapshot to a qgroup. This",
 	"               option can be given multiple times.",
+	"-s <subvolid>  create a snapshot using the subvolume id. This",
+	"               is useful for snapshotting subvolumes outside",
+	"               of the mounted namespace.",
 	NULL
 };
 
+static int get_subvolid(const char *str, u64 *subvolid)
+{
+	char *p;
+	errno = 0;
+	*subvolid = strtoull(optarg, &p, 10);
+	if (errno || *p != '\0') {
+		fprintf(stderr, "ERROR: invalid subvolume id '%s'\n", optarg);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int cmd_snapshot(int argc, char **argv)
 {
-	char	*subvol, *dst;
+	char	*subvol = NULL, *dst;
 	int	res, retval;
 	int	fd = -1, fddst = -1;
 	int	len, readonly = 0;
@@ -597,6 +614,9 @@ static int cmd_snapshot(int argc, char *
 	char	*dupdir = NULL;
 	char	*newname;
 	char	*dstdir;
+	u64	subvolid = 0;
+	char	*subvol_descr = NULL;
+	int	nargs = 2;
 	struct btrfs_ioctl_vol_args_v2	args;
 	struct btrfs_qgroup_inherit *inherit = NULL;
 	DIR *dirstream1 = NULL, *dirstream2 = NULL;
@@ -604,7 +624,7 @@ static int cmd_snapshot(int argc, char *
 	optind = 1;
 	memset(&args, 0, sizeof(args));
 	while (1) {
-		int c = getopt(argc, argv, "c:i:r");
+		int c = getopt(argc, argv, "c:i:rs:");
 		if (c < 0)
 			break;
 
@@ -633,27 +653,39 @@ static int cmd_snapshot(int argc, char *
 				goto out;
 			}
 			break;
+		case 's':
+			res = get_subvolid(optarg, &subvolid);
+			if (res) {
+				retval = res;
+				goto out;
+			}
+			nargs = 1;
+			break;
 		default:
 			usage(cmd_snapshot_usage);
 		}
 	}
 
-	if (check_argc_exact(argc - optind, 2))
+	if (check_argc_exact(argc - optind, nargs))
 		usage(cmd_snapshot_usage);
 
-	subvol = argv[optind];
-	dst = argv[optind + 1];
+	if (nargs == 2) {
+		subvol = argv[optind];
+		dst = argv[optind + 1];
 
-	retval = 1;	/* failure */
-	res = test_issubvolume(subvol);
-	if (res < 0) {
-		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		goto out;
-	}
-	if (!res) {
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		goto out;
-	}
+		retval = 1;	/* failure */
+		res = test_issubvolume(subvol);
+		if (res < 0) {
+			fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+			goto out;
+		}
+		if (!res) {
+			fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
+				subvol);
+			goto out;
+		}
+	} else
+		dst = argv[optind];
 
 	res = test_isdir(dst);
 	if (res == 0) {
@@ -662,6 +694,13 @@ static int cmd_snapshot(int argc, char *
 	}
 
 	if (res > 0) {
+		if (!subvol) {
+			retval = 1;
+			fprintf(stderr,
+				"ERROR: '%s' exists and must not when snapshotting by specifying subvolid.\n",
+				dst);
+			goto out;
+		}
 		dupname = strdup(subvol);
 		newname = basename(dupname);
 		dstdir = dst;
@@ -692,22 +731,34 @@ static int cmd_snapshot(int argc, char *
 		goto out;
 	}
 
-	fd = open_file_or_dir(subvol, &dirstream2);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
+	if (subvol) {
+		fd = open_file_or_dir(subvol, &dirstream2);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
+			goto out;
+		}
+		args.fd = fd;
+		res = asprintf(&subvol_descr, "'%s'", subvol);
+	} else {
+		args.subvolid = subvolid;
+		args.flags |= BTRFS_SUBVOL_CREATE_SUBVOLID;
+		res = asprintf(&subvol_descr, "subvolume id %llu", subvolid);
+	}
+	if (res < 0) {
+		fprintf(stderr, "ERROR: can't allocate memory\n");
+		retval = 1;
 		goto out;
 	}
 
 	if (readonly) {
 		args.flags |= BTRFS_SUBVOL_RDONLY;
-		printf("Create a readonly snapshot of '%s' in '%s/%s'\n",
-		       subvol, dstdir, newname);
+		printf("Create a readonly snapshot of %s in '%s/%s'\n",
+		       subvol_descr, dstdir, newname);
 	} else {
-		printf("Create a snapshot of '%s' in '%s/%s'\n",
-		       subvol, dstdir, newname);
+		printf("Create a snapshot of %s in '%s/%s'\n",
+		       subvol_descr, dstdir, newname);
 	}
 
-	args.fd = fd;
 	if (inherit) {
 		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
 		args.size = qgroup_inherit_size(inherit);
@@ -727,7 +778,9 @@ static int cmd_snapshot(int argc, char *
 
 out:
 	close_file_or_dir(fddst, dirstream1);
-	close_file_or_dir(fd, dirstream2);
+	if (subvol)
+		close_file_or_dir(fd, dirstream2);
+	free(subvol_descr);
 	free(inherit);
 	free(dupname);
 	free(dupdir);
--- a/ioctl.h
+++ b/ioctl.h
@@ -41,6 +41,7 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+#define BTRFS_SUBVOL_CREATE_SUBVOLID	(1ULL << 3)
 
 #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
 
@@ -69,7 +70,10 @@ struct btrfs_ioctl_qgroup_limit_args {
 #define BTRFS_SUBVOL_NAME_MAX 4039
 
 struct btrfs_ioctl_vol_args_v2 {
-	__s64 fd;
+	union {
+		__s64 fd;
+		__u64 subvolid;
+	};
 	__u64 transid;
 	__u64 flags;
 	union {
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -12,7 +12,9 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
+\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI-s <subvolid>\fP \fI<dest>/<name>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
@@ -242,12 +244,35 @@ for \fB--sort\fP you can combine some it
 .RE
 .TP
 
-\fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
+\fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
 Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
 name \fI<name>\fR in the \fI<dest>\fR directory.
 If only \fI<dest>\fR is given, the subvolume will be named the basename of \fI<source>\fR.
 If \fI<source>\fR is not a subvolume, \fBbtrfs\fR returns an error.
-If \fI-r\fR is given, the snapshot will be readonly.
+.RS
+
+\fIOptions\fP
+.IP \fB-r\fP 5
+The newly created snapshot will be readonly.
+.IP "\fB-i\fP \fI<qgroupid>\fR" 5
+Add the newly created subvolume to a qgroup. This option can be given multiple
+times.
+.RE
+.TP
+
+\fBsubvolume snapshot\fP [-r] [-i qgroupid] \fI-s <subvolid>\fP \fI<dest>\fP/\fI<name>\fP
+Create a writable/readonly snapshot of the subvolume \fI<subvolid>\fR with the
+name \fI<name>\fR in the \fI<dest>\fR directory.
+If \fI<subvolid>\fR does not refer to a subvolume, \fBbtrfs\fR returns an error.
+.RS
+
+\fIOptions\fP
+.IP \fB-r\fP 5
+The newly created snapshot will be readonly.
+.IP "\fB-i\fP \fI<qgroupid>\fR" 5
+Add the newly created subvolume to a qgroup. This option can be given multiple
+times.
+.RE
 .TP
 
 \fBsubvolume get-default\fR\fI <path>\fR

-- 
Jeff Mahoney
SUSE Labs
