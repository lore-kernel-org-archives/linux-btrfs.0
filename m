Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27943 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755066AbbBJK1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:44 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQvEr000951
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:57 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: specify qgroup type when creating subvolume
Date: Tue, 10 Feb 2015 18:24:14 +0800
Message-ID: <1423563862-9151-4-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

add --qgroup-type option to specify qgroup type. Type
can be metadata, data or all.

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-subvolume.txt |  4 ++++
 cmds-subvolume.c                  | 50 +++++++++++++++++++++++++++++++++------
 qgroup.c                          | 15 ++++++++++++
 qgroup.h                          |  1 +
 4 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index fe13943..4ac8cf5 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -60,6 +60,10 @@ set the newly created subvolume's max reference size
 +
 -e <max_excl>::::
 set the newly created subvolume's max exclusive size
+--qgroup-type=<type>::::
+specify the <type> of qgroup to set qgroup limit.
++
+<attr> can be one of metadata, data, mixed.
 
 *delete* [options] <subvolume> [<subvolume>...]::
 Delete the subvolume(s) from the filesystem.
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f0e22ac..871f749 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -51,6 +51,8 @@ static const char * const cmd_subvol_create_usage[] = {
 	"               option can be given multiple times.",
 	"-r <max_rfer>  set the newly created subvolume's max reference size",
 	"-e <max_excl>  set the newly created subvolume's max exclusive size",
+	"--qgroup-type=metadata,data,mixed",
+	"               specify which qgroup type to set qgroup limit",
 	NULL
 };
 
@@ -65,10 +67,19 @@ static int cmd_subvol_create(int argc, char **argv)
 	char	*dst;
 	struct btrfs_qgroup_inherit *inherit = NULL;
 	DIR	*dirstream = NULL;
+	__u8	qgroup_type = 0;
+	int	set_qgroup_type = 0;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "c:i:r:e:v");
+		int c;
+		static const struct option long_options[] = {
+			{"qgroup-type", required_argument, NULL, 'q'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "c:i:r:e:v",
+			long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -101,6 +112,14 @@ static int cmd_subvol_create(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'q':
+			set_qgroup_type = 1;
+			res = btrfs_qgroup_set_qgroup_type(&qgroup_type, optarg);
+			if (res) {
+				retval = res;
+				goto out;
+			}
+			break;
 		default:
 			usage(cmd_subvol_create_usage);
 		}
@@ -143,11 +162,21 @@ static int cmd_subvol_create(int argc, char **argv)
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
-	if (inherit) {
-		struct btrfs_ioctl_vol_args_v2	args;
-		struct btrfs_ioctl_quota_ctl_args sa;
 
+	if (set_qgroup_type || inherit)
 		printf("Set qgroup arguments:\n");
+
+	if (set_qgroup_type) {
+		if (qgroup_type != 0) {
+			printf("\tqgroup type: ");
+			if (qgroup_type & BTRFS_QGROUP_TYPE_METADATA)
+				printf("metadata ");
+			if (qgroup_type & BTRFS_QGROUP_TYPE_DATA)
+				printf("data");
+			printf("\n");
+		}
+	}
+	if (inherit) {
 		if (inherit->num_qgroups > 0) {
 			__u64 index;
 			__u64 qgroupid;
@@ -168,7 +197,11 @@ static int cmd_subvol_create(int argc, char **argv)
 				printf("\tmax exclusive: %llu\n",
 					inherit->lim.max_exclusive);
 		}
+	}
 
+	if (inherit || set_qgroup_type) {
+		struct btrfs_ioctl_vol_args_v2	args;
+		struct btrfs_ioctl_quota_ctl_args sa;
 		sa.cmd = BTRFS_QUOTA_CTL_STATUS;
 		res = ioctl(fddst, BTRFS_IOC_QUOTA_CTL, &sa);
 		if (res < 0) {
@@ -185,9 +218,12 @@ static int cmd_subvol_create(int argc, char **argv)
 
 		memset(&args, 0, sizeof(args));
 		strncpy_null(args.name, newname);
-		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
-		args.size = qgroup_inherit_size(inherit);
-		args.qgroup_inherit = inherit;
+		if (inherit != NULL) {
+			args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+			args.size = qgroup_inherit_size(inherit);
+			args.qgroup_inherit = inherit;
+		}
+		args.qgroup_type = qgroup_type;
 
 		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE_V2, &args);
 	} else {
diff --git a/qgroup.c b/qgroup.c
index 8a7c20f..a647925 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1483,3 +1483,18 @@ int qgroup_inherit_set_maxexcl(struct btrfs_qgroup_inherit **inherit, char *arg)
 	(*inherit)->lim.max_exclusive = size;
 	return 0;
 }
+
+int btrfs_qgroup_set_qgroup_type(__u8 *qgroup_type, char *arg)
+{
+	if (strcmp(arg, "metadata") == 0)
+		*qgroup_type = BTRFS_QGROUP_TYPE_METADATA;
+	else if (strcmp(arg, "data") == 0)
+		*qgroup_type = BTRFS_QGROUP_TYPE_DATA;
+	else if (strcmp(arg, "mixed") == 0) {
+		*qgroup_type = BTRFS_QGROUP_TYPE_MIXED;
+	} else {
+		fprintf(stderr, "ERROR: Invalid qgroup type arguments given\n");
+		return -EINVAL;
+	}
+	return 0;
+}
diff --git a/qgroup.h b/qgroup.h
index 421eb42..8423fdf 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -109,6 +109,7 @@ void btrfs_qgroup_free_comparer_set(struct btrfs_qgroup_comparer_set *comp_set);
 int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
 				enum btrfs_qgroup_comp_enum comparer,
 				int is_descending);
+int btrfs_qgroup_set_qgroup_type(__u8 *qgroup_type, char *arg);
 u64 parse_qgroupid(char *p);
 int parse_limit(const char *p, unsigned long long *s);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
-- 
1.8.4.2

