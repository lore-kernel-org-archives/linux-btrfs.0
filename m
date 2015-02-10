Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62764 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576AbbBJK0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAPwdo000845
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:25:58 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs:set max_rfer and max_excl on creating new subvolume
Date: Tue, 10 Feb 2015 18:23:15 +0800
Message-ID: <1423563803-8996-4-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

add -r and -e options to enable setting max reference size
and max exclusive on creating new subvolumes.

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-subvolume.txt |  8 +++-
 cmds-qgroup.c                     | 42 ------------------
 cmds-subvolume.c                  | 57 +++++++++++++++++++++++-
 ioctl.h                           |  3 ++
 qgroup.c                          | 92 +++++++++++++++++++++++++++++++++++++++
 qgroup.h                          |  3 ++
 6 files changed, 160 insertions(+), 45 deletions(-)

diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index b0ae030..fe13943 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -43,7 +43,7 @@ from normal directories.
 
 SUBCOMMAND
 -----------
-*create* [-i <qgroupid>] [<dest>]<name>::
+*create* [-i <qgroupid>] [-r <max_rfer>] [-e <max_excl>] [<dest>]<name>::
 Create a subvolume <name> in <dest>.
 +
 If <dest> is not given, subvolume <name> will be created in the currently
@@ -54,6 +54,12 @@ directory.
 -i <qgroupid>::::
 Add the newly created subvolume to a qgroup. This option can be given multiple
 times.
++
+-r <max_rfer>::::
+set the newly created subvolume's max reference size
++
+-e <max_excl>::::
+set the newly created subvolume's max exclusive size
 
 *delete* [options] <subvolume> [<subvolume>...]::
 Delete the subvolume(s) from the filesystem.
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 2172944..30f0851 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -106,48 +106,6 @@ static int qgroup_create(int create, int argc, char **argv)
 	return 0;
 }
 
-static int parse_limit(const char *p, unsigned long long *s)
-{
-	char *endptr;
-	unsigned long long size;
-
-	if (strcasecmp(p, "none") == 0) {
-		*s = 0;
-		return 1;
-	}
-	size = strtoull(p, &endptr, 10);
-	switch (*endptr) {
-	case 'T':
-	case 't':
-		size *= 1024;
-		/* fallthrough */
-	case 'G':
-	case 'g':
-		size *= 1024;
-		/* fallthrough */
-	case 'M':
-	case 'm':
-		size *= 1024;
-		/* fallthrough */
-	case 'K':
-	case 'k':
-		size *= 1024;
-		++endptr;
-		break;
-	case 0:
-		break;
-	default:
-		return 0;
-	}
-
-	if (*endptr)
-		return 0;
-
-	*s = size;
-
-	return 1;
-}
-
 static const char * const cmd_qgroup_assign_usage[] = {
 	"btrfs qgroup assign <src> <dst> <path>",
 	"Enable subvolume qgroup support for a filesystem.",
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a31cb1b..f0e22ac 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -42,13 +42,15 @@ static const char * const subvolume_cmd_group_usage[] = {
 };
 
 static const char * const cmd_subvol_create_usage[] = {
-	"btrfs subvolume create [-i <qgroupid>] [<dest>/]<name>",
+	"btrfs subvolume create [-i <qgroupid>] [-r <max_rfer>] [-e <max_excl>] [<dest>/]<name>",
 	"Create a subvolume",
 	"Create a subvolume <name> in <dest>.  If <dest> is not given",
 	"subvolume <name> will be created in the current directory.",
 	"",
 	"-i <qgroupid>  add the newly created subvolume to a qgroup. This",
 	"               option can be given multiple times.",
+	"-r <max_rfer>  set the newly created subvolume's max reference size",
+	"-e <max_excl>  set the newly created subvolume's max exclusive size",
 	NULL
 };
 
@@ -66,7 +68,7 @@ static int cmd_subvol_create(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "c:i:v");
+		int c = getopt(argc, argv, "c:i:r:e:v");
 		if (c < 0)
 			break;
 
@@ -85,6 +87,20 @@ static int cmd_subvol_create(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'r':
+			res = qgroup_inherit_set_maxrfer(&inherit, optarg);
+			if (res) {
+				retval = res;
+				goto out;
+			}
+			break;
+		case 'e':
+			res = qgroup_inherit_set_maxexcl(&inherit, optarg);
+			if (res) {
+				retval = res;
+				goto out;
+			}
+			break;
 		default:
 			usage(cmd_subvol_create_usage);
 		}
@@ -129,6 +145,43 @@ static int cmd_subvol_create(int argc, char **argv)
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 	if (inherit) {
 		struct btrfs_ioctl_vol_args_v2	args;
+		struct btrfs_ioctl_quota_ctl_args sa;
+
+		printf("Set qgroup arguments:\n");
+		if (inherit->num_qgroups > 0) {
+			__u64 index;
+			__u64 qgroupid;
+
+			printf("\tparent qgroup: ");
+			for (index = 0; index < inherit->num_qgroups; index++) {
+				qgroupid = inherit->qgroups[index];
+				printf("%llu/%llu ", qgroupid >> 48,
+					(qgroupid << 16) >> 16);
+			}
+			printf("\n");
+		}
+		if (inherit->lim.flags) {
+			if (inherit->lim.flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
+				printf("\tmax reference: %llu\n",
+					inherit->lim.max_referenced);
+			if (inherit->lim.flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
+				printf("\tmax exclusive: %llu\n",
+					inherit->lim.max_exclusive);
+		}
+
+		sa.cmd = BTRFS_QUOTA_CTL_STATUS;
+		res = ioctl(fddst, BTRFS_IOC_QUOTA_CTL, &sa);
+		if (res < 0) {
+			fprintf(stderr, "ERROR: cannot get quota status - %s\n",
+			       strerror(errno));
+			retval = 1;
+			goto out;
+		}
+		if (!(sa.status & BTRFS_QUOTA_STATUS_QUOTA_ENABLED)) {
+			fprintf(stderr, "ERROR: quota disabled\n");
+			retval = 1;
+			goto out;
+		}
 
 		memset(&args, 0, sizeof(args));
 		strncpy_null(args.name, newname);
diff --git a/ioctl.h b/ioctl.h
index d550ca6..a47eab8 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -450,6 +450,9 @@ struct btrfs_ioctl_get_dev_stats {
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
+#define BTRFS_QUOTA_CTL_STATUS  4
+
+#define BTRFS_QUOTA_STATUS_QUOTA_ENABLED 1
 /* 3 has formerly been reserved for BTRFS_QUOTA_CTL_RESCAN */
 struct btrfs_ioctl_quota_ctl_args {
 	__u64 cmd;
diff --git a/qgroup.c b/qgroup.c
index 5a4e393..620ec7e 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1273,6 +1273,48 @@ err:
 	exit(-1);
 }
 
+int parse_limit(const char *p, unsigned long long *s)
+{
+	char *endptr;
+	unsigned long long size;
+
+	if (strcasecmp(p, "none") == 0) {
+		*s = 0;
+		return 1;
+	}
+	size = strtoull(p, &endptr, 10);
+	switch (*endptr) {
+	case 'T':
+	case 't':
+		size *= 1024;
+		/* fallthrough */
+	case 'G':
+	case 'g':
+		size *= 1024;
+		/* fallthrough */
+	case 'M':
+	case 'm':
+		size *= 1024;
+		/* fallthrough */
+	case 'K':
+	case 'k':
+		size *= 1024;
+		++endptr;
+		break;
+	case 0:
+		break;
+	default:
+		return 0;
+	}
+
+	if (*endptr)
+		return 0;
+
+	*s = size;
+
+	return 1;
+}
+
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p)
 {
 	return sizeof(*p) + sizeof(p->qgroups[0]) *
@@ -1302,6 +1344,8 @@ qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
 		struct btrfs_qgroup_inherit *i = *inherit;
 		int s = sizeof(out->qgroups[0]);
 
+		out->flags = i->flags;
+		out->lim = i->lim;
 		out->num_qgroups = i->num_qgroups;
 		out->num_ref_copies = i->num_ref_copies;
 		out->num_excl_copies = i->num_excl_copies;
@@ -1378,3 +1422,51 @@ bad:
 
 	return 0;
 }
+
+int qgroup_inherit_set_maxrfer(struct btrfs_qgroup_inherit **inherit, char *arg)
+{
+	unsigned long long size;
+
+	if(!parse_limit(arg, &size)) {
+		fprintf(stderr, "Invalid size argument given\n");
+		return 1;
+	}
+
+	if ((*inherit) == NULL) {
+		(*inherit) = malloc(sizeof(struct btrfs_qgroup_inherit));
+		if ((*inherit) == NULL) {
+			fprintf(stderr, "ERROR: Not enough memory\n");
+			return -ENOMEM;
+		}
+		memset((*inherit), 0, sizeof(struct btrfs_qgroup_inherit));
+	}
+
+	(*inherit)->flags |= BTRFS_QGROUP_INHERIT_SET_LIMITS;
+	(*inherit)->lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
+	(*inherit)->lim.max_referenced = size;
+	return 0;
+}
+
+int qgroup_inherit_set_maxexcl(struct btrfs_qgroup_inherit **inherit, char *arg)
+{
+	unsigned long long size;
+
+	if(!parse_limit(arg, &size)) {
+		fprintf(stderr, "Invalid size argument given\n");
+		return 1;
+	}
+
+	if ((*inherit) == NULL) {
+		(*inherit) = malloc(sizeof(struct btrfs_qgroup_inherit));
+		if ((*inherit) == NULL) {
+			fprintf(stderr, "ERROR: Not enough memory\n");
+			return -ENOMEM;
+		}
+		memset((*inherit), 0, sizeof(struct btrfs_qgroup_inherit));
+	}
+
+	(*inherit)->flags |= BTRFS_QGROUP_INHERIT_SET_LIMITS;
+	(*inherit)->lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
+	(*inherit)->lim.max_exclusive = size;
+	return 0;
+}
diff --git a/qgroup.h b/qgroup.h
index 6e65ef7..e5d03ca 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -94,9 +94,12 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
 				enum btrfs_qgroup_comp_enum comparer,
 				int is_descending);
 u64 parse_qgroupid(char *p);
+int parse_limit(const char *p, unsigned long long *s);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
 int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
 			    int type);
+int qgroup_inherit_set_maxrfer(struct btrfs_qgroup_inherit **inherit, char *arg);
+int qgroup_inherit_set_maxexcl(struct btrfs_qgroup_inherit **inherit, char *arg);
 
 #endif
-- 
1.8.4.2

