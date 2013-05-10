Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47377 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3EJLAO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 07:00:14 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4AB0DnE017136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:14 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4AB0CE4002128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:12 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4AB0BjX010801
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add framework to read fs info and dev info from the kernel
Date: Fri, 10 May 2013 19:02:44 +0800
Message-Id: <1368183764-7865-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368183764-7865-1-git-send-email-anand.jain@oracle.com>
References: <1368183764-7865-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 As of now btrfs fi show reads the disks directly to report
 the list of fsids and its disks and the output can be
 inconsistent with the kernel dev changes, mainly after the
 dev del / add.

 This patch adds -k|-K option to the btrfs fi show command
 so that it reads from the kernel instead of from the
 disks directly.

 This is done by adding new ioctl BTRFS_IOC_GET_FSIDS and
 BTRFS_IOC_GET_DEVS to read the fs info and dev info from
 the kernel.

 This btrfs-progs changes are inline with the kernel
 changes as in the patch
    btrfs: add framework to read fs info and dev info from the kernel

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |  92 ++++++++++++++++++++++++++++++--
 ioctl.h           |  60 ++++++++++++++++++++-
 utils.c           | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |   2 +
 4 files changed, 303 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..d720ce6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,7 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <getopt.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -232,9 +233,11 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"btrfs filesystem show [-k|K] [--all-devices] [<uuid>|<label>]",
 	"Show the structure of a filesystem",
-	"If no argument is given, structure of all present filesystems is shown.",
+	"\tIf no argument is given, structure of all present filesystems is shown\n"
+	"\t-K would list both mounted and unmounted/stale btrfs as per kernel\n"
+	"\t-k would list mounted only btrfs as known to the kernel.\n",
 	NULL
 };
 
@@ -243,14 +246,97 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
+
 	char *search = 0;
-	int ret;
+	int ret, e;
 	int checklist = 1;
 	int searchstart = 1;
+	int dev_cnt;
+	int fsid_cnt;
+	int i, j, c;
+	int all = 0;
+	int kernel = 0;
+	char uuidparse[37];
+
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
 		checklist = 0;
 		searchstart += 1;
+	} else {
+		while (1) {
+			c = getopt(argc, argv, "kK");
+			if (c < 0)
+				break;
+			switch(c) {
+			case 'k':
+				kernel = 1;
+				all = 0;
+				break;
+			case 'K':
+				kernel = 1;
+				all = 1;
+				break;
+			default:
+				usage(cmd_show_usage);
+			}
+		}
+	}
+
+	if (kernel) {
+		struct btrfs_ioctl_devinfo *dev;
+		struct btrfs_ioctl_fs_list *fslist = NULL;
+		struct btrfs_ioctl_fsinfo *fsinfo;
+		struct btrfs_ioctl_dev_list *devlist = NULL;
+
+		fsid_cnt = scan_fsid(&fslist, all);
+		e = errno;
+		if (fsid_cnt < 0) {
+			printf("ERROR: scan for fs failed %d, - %s\n",
+				fsid_cnt, strerror(e));
+			exit(1);
+		}
+
+		if (!fsid_cnt) {
+			BUG_ON(fslist);
+			return 0;
+		}
+		for (i = 0; i < fsid_cnt; i++) {
+			fsinfo = &fslist->fsinfo[i];
+			dev_cnt = get_devs(&devlist, fsinfo->fsid);
+			e = errno;
+			if (dev_cnt < 0) {
+				free(fslist);
+				printf("Error: get_devs failed %d, - %s\n",
+					dev_cnt, strerror(e));
+				exit(1);
+			}
+			if (!dev_cnt)
+				continue;
+
+			uuid_unparse(fsinfo->fsid, uuidparse);
+			printf("\nfsid: %s ", uuidparse);
+			if (fsinfo->flags & BTRFS_FS_MOUNTED)
+				printf("(mounted)\n");
+			else
+				printf("(unmounted/stale)\n");
+
+			for (j = 0; j < dev_cnt; j++) {
+				dev = &devlist->dev[j];
+				uuid_unparse(dev->uuid, uuidparse);
+				printf("\t%llu %s %s", dev->devid, uuidparse, dev->name);
+				if (dev->flags & BTRFS_DEV_MISSING)
+					printf(" (missing)\n");
+				else
+					printf("\n");
+			}
+			if (devlist)
+				free(devlist);
+		}
+
+		if (fslist)
+			free(fslist);
+
+		return 0;
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
diff --git a/ioctl.h b/ioctl.h
index 1ee631a..3908dac 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -441,6 +441,61 @@ struct btrfs_ioctl_qgroup_create_args {
 	__u64 create;
 	__u64 qgroupid;
 };
+
+/* ioctl header */
+struct btrfs_ioctl_header {
+	__u64 sz_self;	/* in/out */
+	__u64 sz;	/* in/out */
+	__u64 count;	/* in/out */
+} __attribute__ ((__packed__));
+
+/* ioctl payloads */
+#define BTRFS_FSIDS_LEN	16
+#define BTRFS_FS_MOUNTED	(1LLU << 0)
+
+struct btrfs_ioctl_fsinfo {
+	__u64 sz_self;
+	__u8 fsid[BTRFS_FSID_SIZE]; /* out */
+	__u64 num_devices;
+	__u64 missing_devices;
+	__u64 total_rw_bytes;
+	__u64 total_devices;
+	__u64 flags;
+} __attribute__ ((__packed__));
+
+struct btrfs_ioctl_fs_list {
+	__u64 all; /* in */
+	struct btrfs_ioctl_fsinfo fsinfo[BTRFS_FSIDS_LEN]; /* out */
+} __attribute__ ((__packed__));
+
+/* flags below */
+#define BTRFS_DEVS_LEN	16
+#define BTRFS_DEV_WRITEABLE	(1LLU << 0)
+#define BTRFS_DEV_IN_FS_MD	(1LLU << 1)
+#define BTRFS_DEV_MISSING	(1LLU << 2)
+#define BTRFS_DEV_CAN_DISCARD	(1LLU << 3)
+#define BTRFS_DEV_SUBSTITUTED	(1LLU << 4)
+
+struct btrfs_ioctl_devinfo {
+	__u64 sz_self;
+	__u64 flags;
+	__u64 devid;
+	__u64 total_bytes;
+	__u64 disk_total_bytes;
+	__u64 bytes_used;
+	__u64 type;
+	__u32 io_align;
+	__u32 io_width;
+	__u32 sector_size;
+	__u8 uuid[BTRFS_UUID_SIZE];
+	__u8 name[BTRFS_PATH_NAME_MAX + 1];
+} __attribute__ ((__packed__));
+
+struct btrfs_ioctl_dev_list {
+	__u8 fsid[BTRFS_FSID_SIZE]; /* in */
+	struct btrfs_ioctl_devinfo dev[BTRFS_DEVS_LEN]; /* out */
+} __attribute__ ((__packed__));
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -536,7 +591,10 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
-
+#define BTRFS_IOC_GET_FSIDS _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+				     struct btrfs_ioctl_header)
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				     struct btrfs_ioctl_header)
 #ifdef __cplusplus
 }
 #endif
diff --git a/utils.c b/utils.c
index 7b4cd74..aaebc60 100644
--- a/utils.c
+++ b/utils.c
@@ -1807,3 +1807,156 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	close(fd);
 	return 0;
 }
+
+static struct btrfs_ioctl_header * alloc_ioctl_payload(void **plp,
+		size_t *sz_pl, __u64 mul, __u64 rq_len)
+{
+	struct btrfs_ioctl_header *header;
+	size_t sz;
+	__u64 cnt = 1;
+
+	if (rq_len)
+		cnt = rq_len/mul + ((rq_len % mul) ? 1 : 0);
+
+	*sz_pl = *sz_pl * cnt;
+	sz = sizeof(*header) + *sz_pl;
+	header = malloc(sz);
+	if (!header)
+		return NULL;
+
+	memset(header, 0, sz);
+	header->count = mul * cnt;
+	*plp = ((__u8 *)header) + sizeof(*header);
+
+	return header;
+}
+
+/* scans for fsid(s) in the kernel using the btrfs-control
+ * interface.
+ * returns:
+ * > 0 : Success, and number indicates number of fsid(s) found,
+ *       out_fslist points to the fsid(s)
+ *       the caller must free out_fslist when it is not null
+ * 0   : when no fsid is found, but successful
+ * < 0 : upon error
+ */
+int scan_fsid(struct btrfs_ioctl_fs_list **out_fslist, int all)
+{
+	int res, fd, e;
+	struct btrfs_ioctl_header *argp;
+	struct btrfs_ioctl_fs_list *fslist;
+	__u64 alloc_cnt;
+	size_t pl_sz;
+	__u64 req_cnt = 1;
+
+	*out_fslist = NULL;
+	fd = open("/dev/btrfs-control", O_RDWR);
+	e = errno;
+	if (fd < 0) {
+		perror("failed to open /dev/btrfs-control");
+		return -e;
+	}
+
+	pl_sz = sizeof(*fslist);
+again:
+	argp = alloc_ioctl_payload((void **)&fslist, &pl_sz, BTRFS_FSIDS_LEN, req_cnt);
+	if (!argp) {
+		close(fd);
+		return -ENOMEM;
+	}
+	fslist->all = all;
+	alloc_cnt = argp->count;
+	res = ioctl(fd, BTRFS_IOC_GET_FSIDS, argp);
+	e = errno;
+	if (res) {
+		printf("ERROR: scan_fsid ioctl failed %d - %s\n",
+			res, strerror(e));
+		goto out;
+	}
+	/* ioctl returns fsid count in count parameter*/
+	req_cnt = argp->count;
+	if (req_cnt > alloc_cnt) {
+		/* if kernel has more than initially alloc-ed count
+		 * then alloc more chunk then call ioctl again
+		*/
+		free(argp);
+		goto again;
+	}
+	if (!req_cnt)
+		goto out;
+	*out_fslist = malloc(pl_sz);
+	if (!*out_fslist) {
+		res = -ENOMEM;
+		goto out;
+	}
+	memcpy(*out_fslist, fslist, pl_sz);
+out:
+	free(argp);
+	close(fd);
+	return req_cnt;
+}
+
+/* scans for devs for a given fsid in the kernel using the
+ * btrfs-control interface.
+ * returns:
+ * > 0 : for success, and number indicates number of devs found,
+ *       out_devlist points to the devs
+ *       the caller must free out_devlist when it is not null
+ * 0   : when no dev is found, but successful
+ * < 0 : upon error
+ */
+int get_devs(struct btrfs_ioctl_dev_list **out_devlist, __u8 *fsid)
+{
+	int res, fd, e;
+	struct btrfs_ioctl_header *argp;
+	struct btrfs_ioctl_dev_list *devlist;
+	__u64 alloc_cnt;
+	size_t pl_sz = 0;
+	__u64 req_cnt = 1;
+
+	*out_devlist = NULL;
+	fd = open("/dev/btrfs-control", O_RDWR);
+	e = errno;
+	if (fd < 0) {
+		perror("failed to open /dev/btrfs-control");
+		return -e;
+	}
+
+	pl_sz = sizeof(*devlist);
+again:
+	argp = alloc_ioctl_payload((void **)&devlist, &pl_sz, BTRFS_DEVS_LEN, req_cnt);
+	if (!argp) {
+		close(fd);
+		return -ENOMEM;
+	}
+	memcpy(&devlist->fsid, fsid, BTRFS_FSID_SIZE);
+	alloc_cnt = argp->count;
+	res = ioctl(fd, BTRFS_IOC_GET_DEVS, argp);
+	e = errno;
+	if (res) {
+		printf("ERROR: scan_fsid ioctl failed %d - %s\n",
+			res, strerror(e));
+		goto out;
+	}
+	/* ioctl returns fsid count in count parameter*/
+	req_cnt = argp->count;
+	if (req_cnt > alloc_cnt) {
+		/* if kernel has more than initially alloc-ed count
+		 * then alloc more chunk then call ioctl again
+		*/
+		free(argp);
+		goto again;
+	}
+	if (!req_cnt)
+		goto out;
+	*out_devlist = malloc(pl_sz);
+	if (!*out_devlist) {
+		res = -ENOMEM;
+		goto out;
+	}
+	memcpy(*out_devlist, devlist, pl_sz);
+out:
+	free(argp);
+	close(fd);
+	return req_cnt;
+}
diff --git a/utils.h b/utils.h
index 3c17e14..6cb1acf 100644
--- a/utils.h
+++ b/utils.h
@@ -65,5 +65,7 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
+int scan_fsid(struct btrfs_ioctl_fs_list **fslist, int all);
+int get_devs(struct btrfs_ioctl_dev_list **devlist, __u8 *fsid);
 
 #endif
-- 
1.8.1.227.g44fe835

