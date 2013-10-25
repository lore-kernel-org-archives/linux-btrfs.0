Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39125 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3JYRCC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 13:02:02 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9PH21JT017050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:02:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9PH20BV005027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:02:01 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9PH20PF007414
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 17:02:00 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2]     btrfs-progs: mechanism to fetch fsinfo from btrfs-control
Date: Sat, 26 Oct 2013 01:10:06 +0800
Message-Id: <1382721007-5531-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1382721007-5531-1-git-send-email-anand.jain@oracle.com>
References: <1382721007-5531-1-git-send-email-anand.jain@oracle.com>
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

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 ioctl.h |   19 +++++++++++++++
 utils.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |    1 +
 3 files changed, 100 insertions(+), 0 deletions(-)

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
index 5bedd97..1798a7c 100644
--- a/utils.c
+++ b/utils.c
@@ -2087,3 +2087,83 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 
 	return 0;
 }
+
+/* scans for fsid(s) in the kernel using the btrfs-control
+ * interface.
+ */
+int get_fslist(struct btrfs_ioctl_fslist **out_fslist, int *out_count)
+{
+	int ret, fd, e;
+	struct btrfs_ioctl_fslist_args *fsargs;
+	struct btrfs_ioctl_fslist *fslist;
+	struct btrfs_ioctl_fslist *fslist_tmp;
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
+	fsargs = (struct btrfs_ioctl_fslist_args *) malloc(sz);
+	memset(fsargs, 0, sz);
+
+	if (!fsargs) {
+		close(fd);
+		return -ENOMEM;
+	}
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
+	*out_count = count = fsargs->count;
+	if (count == 0) {
+		*out_fslist = NULL;
+		ret = 0;
+		goto out;
+	}
+
+	fslist = (struct btrfs_ioctl_fslist *) (fsargs +
+						sizeof(*fsargs));
+
+	fslist_tmp = *out_fslist = (struct btrfs_ioctl_fslist *)
+				malloc(sizeof(*fslist) * count);
+	if (!fslist_tmp) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	while (count--) {
+		memcpy(fslist_tmp, fslist, sizeof(*fslist));
+		fslist_tmp = fslist_tmp + sizeof(*fslist_tmp);
+		fslist = fslist + sizeof(*fslist);
+	}
+	ret = 0;
+out:
+	free(fsargs);
+	close(fd);
+	return 0;
+}
diff --git a/utils.h b/utils.h
index 6f4b10c..e20ad74 100644
--- a/utils.h
+++ b/utils.h
@@ -94,5 +94,6 @@ int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
+int get_fslist(struct btrfs_ioctl_fslist **out_fslist, int *out_count);
 
 #endif
-- 
1.7.1

