Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23636 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760278AbaGYMab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 08:30:31 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PCUUgn010894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:31 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PCUT7F008708
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:30 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PCUTTR000076
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs-progs: introduce btrfs-devlist
Date: Fri, 25 Jul 2014 20:33:52 +0800
Message-Id: <1406291632-29582-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
References: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a small (debug) program to dump the device list
in the raw format from the btrfs kernel.
here I use ioctl which was introduced in the below kernel
patch

btrfs: introduce BTRFS_IOC_GET_DEVS

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 .gitignore      |   1 +
 Makefile        |   4 +-
 btrfs-devlist.c | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h         |  52 +++++++++++
 4 files changed, 323 insertions(+), 2 deletions(-)
 create mode 100644 btrfs-devlist.c

diff --git a/.gitignore b/.gitignore
index fc8c07a..760eaeb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -35,3 +35,4 @@ libbtrfs.a
 libbtrfs.so
 libbtrfs.so.0
 libbtrfs.so.0.1
+btrfs-devlist
diff --git a/Makefile b/Makefile
index 9f805ac..ec6011c 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)
 
 progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfstune btrfs-show-super
+	btrfs-find-root btrfstune btrfs-show-super btrfs-devlist
 
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
@@ -229,7 +229,7 @@ clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
-	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
+	      btrfs.static mkfs.btrfs.static btrfs-calc-size btrfs-devlist\
 	      version.h $(check_defs) \
 	      $(libs) $(lib_links)
 
diff --git a/btrfs-devlist.c b/btrfs-devlist.c
new file mode 100644
index 0000000..740957a
--- /dev/null
+++ b/btrfs-devlist.c
@@ -0,0 +1,268 @@
+/*
+ * Copyright (C) 2014 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <unistd.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <uuid/uuid.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+#include "commands.h"
+#include "utils.h"
+
+void print_header(void)
+{
+	printf(
+		"fs_address dev_address dev_root_addr root_fsid\n"\
+		"fsid "\
+		"name "\
+		"uuid "\
+		"(seed_fsid@seed_addr "\
+		"sprout_fsid@sprout_addr) \n"\
+		"\t(fs_num_devices "\
+		"fs_open_devices "\
+		"fs_rw_devices "\
+		"fs_missing_devices "\
+		"fs_total_devices) "\
+		"fs_total_rw_bytes "\
+		"fs_num_can_discard\n"\
+		"\tdevid "\
+		"gen "\
+		"total_bytes "\
+		"disk_total_bytes "\
+		"bytes_used "\
+		"type "\
+		"io_align "\
+		"io_width "\
+		"sector_size "\
+		"fmode \n"\
+		"\tfs_flags\n"\
+		"\tdev_flags\n");
+}
+
+void print_dev(struct btrfs_ioctl_devlist *dev)
+{
+	char uuid[BTRFS_UUID_UNPARSED_SIZE];
+	char fsid[BTRFS_UUID_UNPARSED_SIZE];
+	char seed_fsid[BTRFS_UUID_UNPARSED_SIZE];
+	char sprout_fsid[BTRFS_UUID_UNPARSED_SIZE];
+	char root_fsid[BTRFS_UUID_UNPARSED_SIZE];
+
+	memset(seed_fsid, '0', BTRFS_UUID_UNPARSED_SIZE);
+	strcpy(seed_fsid, "null");
+	memset(sprout_fsid, '0', BTRFS_UUID_UNPARSED_SIZE);
+	strcpy(sprout_fsid, "null");
+	memset(root_fsid, '0', BTRFS_UUID_UNPARSED_SIZE);
+	strcpy(root_fsid, "null");
+
+	uuid_unparse(dev->uuid, uuid);
+	uuid_unparse(dev->fsid, fsid);
+	if (! uuid_is_null(dev->seed_fsid))
+		uuid_unparse(dev->seed_fsid, seed_fsid);
+	if (! uuid_is_null(dev->sprout_fsid))
+		uuid_unparse(dev->sprout_fsid, sprout_fsid);
+	if (! uuid_is_null(dev->root_fsid))
+		uuid_unparse(dev->root_fsid, root_fsid);
+
+	printf("\n%llX %llX %llX %s\n"\
+		"%s %s %s (%s@%llX %s@%llX)\n"\
+		"\t(%llu %llu %llu %llu %llu) %llu %llu\n"\
+		"\t%llu %llu %llu %llu %llu %llu %u %u %u 0x%llX\n"\
+		"\t%s|%s|%s\n"\
+		"\t%s|%s|%s|%s|%s|%s|%s|%s|%s\n",
+		dev->fs_addr,
+		dev->dev_addr,
+		dev->dev_root_addr,
+		root_fsid,
+		fsid,
+		dev->name,
+		uuid,
+		seed_fsid, dev->seed_fs_addr,
+		sprout_fsid, dev->sprout_fs_addr,
+		dev->fs_num_devices,
+		dev->fs_open_devices,
+		dev->fs_rw_devices,
+		dev->fs_missing_devices,
+		dev->fs_total_devices,
+		dev->fs_total_rw_bytes,
+		dev->fs_num_can_discard,
+		dev->devid,
+		dev->gen,
+		dev->total_bytes,
+		dev->disk_total_bytes,
+		dev->bytes_used,
+		dev->type,
+		dev->io_align,
+		dev->io_width,
+		dev->sector_size,
+		dev->fmode,
+		dev->flags & BTRFS_FS_MOUNTED ? "fs_Mounted":"not_fs_Mounted",
+		dev->flags & BTRFS_FS_SEEDING ? "fs_Seeding":"not_fs_Seeding",
+		dev->flags & BTRFS_FS_ROTATING ? "fs_Rotating":"not_fs_Rotating",
+		dev->flags & BTRFS_DEV_WRITEABLE ? "Writable":"not_Writable",
+		dev->flags & BTRFS_DEV_IN_FS_MD ? "MD":"not_MD",
+		dev->flags & BTRFS_DEV_MISSING ? "Missing":"not_Missing",
+		dev->flags & BTRFS_DEV_CAN_DISCARD ? "Discard":"not_Discard",
+		dev->flags & BTRFS_DEV_REPLACE_TGT ? "Replace_tgt":"not_Replace_tgt",
+		dev->flags & BTRFS_DEV_RUN_PENDING ? "Run_pending":"not_Run_pending",
+		dev->flags & BTRFS_DEV_NOBARRIERS ? "Nobarriers":"not_Nobarriers",
+		dev->flags & BTRFS_DEV_STATS_VALID ? "Stat_valid":"not_Stat_valid",
+		dev->flags & BTRFS_DEV_BDEV ? "Bdev":"not_Bdev");
+}
+
+int get_devlist(struct btrfs_ioctl_devlist **out_devlist, u64 *out_count)
+{
+	int ret, fd, e;
+	struct btrfs_ioctl_devlist_args *devargs;
+	struct btrfs_ioctl_devlist_args *devargs_saved = NULL;
+	struct btrfs_ioctl_devlist *devlist;
+	u64 sz;
+	int count;
+
+	fd = open("/dev/btrfs-control", O_RDWR);
+	e = errno;
+	if (fd < 0) {
+		perror("failed to open /dev/btrfs-control");
+		return -e;
+	}
+
+	/* space to hold 512 fsids, doesn't matter if small
+	 * it would fail and return count so then we try again
+	 */
+	count = 512;
+again:
+	sz = sizeof(*devargs) + sizeof(*devlist) * count;
+
+	devargs_saved = devargs = malloc(sz);
+	if (!devargs) {
+		close(fd);
+		return -ENOMEM;
+	}
+
+	memset(devargs, 0, sz);
+	devlist = (struct btrfs_ioctl_devlist *) (++devargs);
+	devargs = devargs_saved;
+
+	devargs->count = count;
+	devargs->sz_self = (u64) sizeof(*devargs);
+	devlist->sz_self = (u64) sizeof(*devlist);
+
+	ret = ioctl(fd, BTRFS_IOC_GET_DEVS, devargs);
+	e = errno;
+	if (ret == 1) {
+		/* out of size so reallocate */
+		count = devargs->count;
+		free(devargs);
+		goto again;
+	} else if (ret < 0) {
+		printf("ERROR: scan_fsid ioctl failed - %s\n",
+			strerror(e));
+		ret = -e;
+		goto out;
+	}
+
+	/* Check if the kernel has the same struct as this */
+	if (devargs->sz_self != sizeof(*devargs) ||
+		devlist->sz_self != sizeof(*devlist)) {
+		fprintf(stderr,
+		"ERROR: version mismatch udevarg %lu udevlist %lu kdevarg %llu kdevlist %llu\n",
+			sizeof(*devargs), sizeof(*devlist), devargs->sz_self, devlist->sz_self);
+		goto out;
+	}
+
+	/* ioctl returns devs count in count parameter*/
+
+	*out_count = devargs->count;
+	if (*out_count == 0) {
+		*out_devlist = NULL;
+		ret = 0;
+		goto out;
+	}
+
+
+	sz = sizeof(*devlist) * *out_count;
+	*out_devlist = malloc(sz);
+	if (*out_devlist == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(*out_devlist, devlist, sz);
+	ret = 0;
+
+out:
+	free(devargs_saved);
+	close(fd);
+	return ret;
+}
+
+static void local_usage(void)
+{
+	printf("btrfs_devlist [options]\n"\
+	"	Dumps the device list from the btrfs kernel "\
+	"without altering at the user level\n"\
+	"	options:\n"\
+	"		-h|--help prints this usage\n");
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	u64 cnt;
+	struct btrfs_ioctl_devlist *devlist;
+	struct btrfs_ioctl_devlist *tmp_devlist;
+
+	while(1) {
+		int long_index;
+		static struct option long_options[] = {
+			{"help", no_argument, NULL, 'h'},
+			{ NULL, no_argument, NULL, 0 }
+		};
+
+		int c = getopt_long(argc, argv, "h", long_options,
+			&long_index);
+
+		if(c < 0)
+			break;
+
+		switch(c) {
+		case 'h':
+		default:
+			local_usage();
+		}
+	}
+
+	ret = get_devlist(&devlist, &cnt);
+	if (ret) {
+		fprintf(stderr, "get devlist failed %d\n", ret);
+		return 1;
+	}
+
+	tmp_devlist = devlist;
+
+	print_header();
+	while (cnt--) {
+		print_dev(devlist);
+		devlist++;
+	}
+	kfree(tmp_devlist);
+	return ret;
+}
diff --git a/ioctl.h b/ioctl.h
index 4ea74ba..b8a1348 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -533,6 +533,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 
 /* fs flags */
 #define BTRFS_FS_MOUNTED	(1LLU << 0)
+#define BTRFS_FS_SEEDING	(1LLU << 1)
+#define BTRFS_FS_ROTATING	(1LLU << 2)
 
 struct btrfs_ioctl_fslist {
 	__u64 self_sz;			/* in/out */
@@ -548,6 +550,54 @@ struct btrfs_ioctl_fslist_args {
 	__u64 count;		/* out */
 };
 
+#define BTRFS_DEV_WRITEABLE	(1LLU << 8)
+#define BTRFS_DEV_IN_FS_MD	(1LLU << 9)
+#define BTRFS_DEV_MISSING	(1LLU << 10)
+#define BTRFS_DEV_CAN_DISCARD	(1LLU << 11)
+#define BTRFS_DEV_REPLACE_TGT	(1LLU << 12)
+#define BTRFS_DEV_RUN_PENDING   (1LLU << 13)
+#define BTRFS_DEV_NOBARRIERS	(1LLU << 14)
+#define BTRFS_DEV_STATS_VALID	(1LLU << 15)
+#define BTRFS_DEV_BDEV		(1LLU << 16)
+
+struct btrfs_ioctl_devlist {
+	__u64 sz_self;
+	__u64 dev_root_addr;
+	__u64 fs_addr;
+	__u64 dev_addr;
+	__u64 seed_fs_addr;
+	__u64 sprout_fs_addr;
+	__u64 fs_num_devices;
+	__u64 fs_open_devices;
+	__u64 fs_rw_devices;
+	__u64 fs_missing_devices;
+	__u64 fs_total_rw_bytes;
+	__u64 fs_num_can_discard;
+	__u64 fs_total_devices;
+	__u64 gen;
+	__u64 flags;
+	__u64 devid;
+	__u64 total_bytes;
+	__u64 disk_total_bytes;
+	__u64 bytes_used;
+	__u64 type;
+	__u64 fmode;
+	__u32 io_align;
+	__u32 io_width;
+	__u32 sector_size;
+	__u8 fsid[BTRFS_FSID_SIZE];
+	__u8 uuid[BTRFS_UUID_SIZE];
+	__u8 seed_fsid[BTRFS_FSID_SIZE];
+	__u8 sprout_fsid[BTRFS_UUID_SIZE];
+	__u8 root_fsid[BTRFS_FSID_SIZE];
+	__u8 name[BTRFS_PATH_NAME_MAX];
+}__attribute__ ((__packed__));
+
+struct btrfs_ioctl_devlist_args {
+	__u64 sz_self;		/* in/out */
+	__u64 count;		/* in/out */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -657,6 +707,8 @@ struct btrfs_ioctl_clone_range_args {
                                   struct btrfs_ioctl_feature_flags[2])
 #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags[3])
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 59, \
+				     struct btrfs_ioctl_devlist_args)
 #ifdef __cplusplus
 }
 #endif
-- 
2.0.0.153.g79dcccc

