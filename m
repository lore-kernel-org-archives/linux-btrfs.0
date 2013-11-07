Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3KGJyS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 04:54:18 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, zab@redhat.com, dsterba@suse.cz
Subject: [PATCH 1/3] btrfs-progs: mechanism to fetch fsinfo from btrfs-control v3
Date: Thu,  7 Nov 2013 18:01:41 +0800
Message-Id: <1383818503-29607-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

need fsinfo from btrfs-control that is when mount path is
not known.
current method of going through each mount points isn't
efficient, and multiple subvol of a fsid could be mounted
means extra logic to handle that. Further this will help
to revamp check_mounted() (planned)

check_mounted is heavily used in the btrfs-progs, it
does full scan of all the disks in the system to confirm
if a multi-disk btrfs is mounted it doesn't scalable well
with few hundreds luns, check_mounted for sure needs a
revamp. using this it can be done easily. which is planned.

v3: accepts Josef suggested and fix git screwup
v2: commit reword

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 ioctl.h |   19 +++++++++++++++
 utils.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |    1 +
 3 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index d21413f..29575d8 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -506,6 +506,23 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 	}
 }
 
+/* fs flags */
+#define BTRFS_FS_MOUNTED	(1LLU << 0)
+
+struct btrfs_ioctl_fslist {
+	__u64 self_sz;			/* in/out */
+	__u8 fsid[BTRFS_FSID_SIZE];	/* out */
+	__u64 num_devices;
+	__u64 missing_devices;
+	__u64 total_devices;
+	__u64 flags;
+};
+
+struct btrfs_ioctl_fslist_args {
+	__u64 self_sz;		/* in/out */
+	__u64 count;		/* out */
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -604,6 +621,8 @@ struct btrfs_ioctl_clone_range_args {
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_DEDUP_CTL _IOWR(BTRFS_IOCTL_MAGIC, 55, \
 				  struct btrfs_ioctl_dedup_args)
+#define BTRFS_IOC_GET_FSLIST _IOWR(BTRFS_IOCTL_MAGIC, 56, \
+					struct btrfs_ioctl_fslist_args)
 #ifdef __cplusplus
 }
 #endif
diff --git a/utils.c b/utils.c
index 60d2c3a..4b90026 100644
--- a/utils.c
+++ b/utils.c
@@ -47,6 +47,7 @@
 #include "utils.h"
 #include "volumes.h"
 #include "ioctl.h"
+#include "btrfs-list.h"
 
 #ifndef BLKDISCARD
 #define BLKDISCARD	_IO(0x12,119)
@@ -2087,3 +2088,78 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 
 	return 0;
 }
+
+/* scans for fsid(s) in the kernel using the btrfs-control
+ * interface.
+ */
+int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count)
+{
+	int ret, fd, e;
+	struct btrfs_ioctl_fslist_args *fsargs;
+	struct btrfs_ioctl_fslist_args *fsargs_saved = NULL;
+	struct btrfs_ioctl_fslist *fslist;
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
+	sz = sizeof(*fsargs) + sizeof(*fslist) * count;
+
+	fsargs = malloc(sz);
+	if (!fsargs) {
+		close(fd);
+		return -ENOMEM;
+	}
+
+	memset(fsargs, 0, sz);
+	fsargs->count = count;
+
+	ret = ioctl(fd, BTRFS_IOC_GET_FSLIST, fsargs);
+	e = errno;
+	if (ret == 1) {
+		/* out of size so reallocate */
+		count = fsargs->count;
+		free(fsargs);
+		goto again;
+	} else if (ret < 0) {
+		printf("ERROR: scan_fsid ioctl failed - %s\n",
+			strerror(e));
+		ret = -e;
+		goto out;
+	}
+
+	/* ioctl returns fsid count in count parameter*/
+
+	*out_count = fsargs->count;
+	if (*out_count == 0) {
+		*out_fslist = NULL;
+		ret = 0;
+		goto out;
+	}
+
+	fsargs_saved = fsargs;
+	fslist = (struct btrfs_ioctl_fslist *) (++fsargs);
+
+	sz = sizeof(*fslist) * *out_count;
+	*out_fslist = malloc(sz);
+	if (*out_fslist == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(*out_fslist, fslist, sz);
+	ret = 0;
+out:
+	free(fsargs_saved);
+	close(fd);
+	return 0;
+}
diff --git a/utils.h b/utils.h
index 6f4b10c..a14a887 100644
--- a/utils.h
+++ b/utils.h
@@ -94,5 +94,6 @@ int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
+int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count);
 
 #endif
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
