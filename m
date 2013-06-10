Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49989 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3FJOxA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:53:00 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEqxDO002978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:53:00 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqw42007521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:59 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqwXv007504
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9 v2] btrfs-progs: introduce btrfs filesystem show --kernel
Date: Mon, 10 Jun 2013 22:56:30 +0800
Message-Id: <1370876190-16520-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user want to verify their latest operation like,
labeling or device delete or add... etc.

This patch adds --kernel option to the 'filesystem show'
subcli, which will read from the kernel instead of
the disks directly.

This is implemented by adding new ioctl BTRFS_IOC_GET_FSIDS
and BTRFS_IOC_GET_DEVS which is to read filesystem info and
device info from the kernel using the btrfs-control
interface. Which will have advantage of using the the
interface even when the fs is not mounted if in case needed.

This interface finds that there are stale fsid when the
btrfs is unmounted, this will be a new issue to resolve.

This btrfs-progs depends on the kernel patch
btrfs: add framework to read fs info and dev info from the kernel

paramter self_sz:
  For future enhancements. When payload structure changes
  use this to communicate version differences.

ioctl header and payload:
  These ioctl uses header and payload model where
  new payload (a structure) can be easily plugged-in
  to get new information from the kernel.

v1->v2:
	.code optimized to remove redundancy

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   7 +-
 ctree.h           |   1 -
 ioctl.h           |  64 ++++++++++++++
 utils.c           | 244 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |   4 +
 volumes.c         |  20 ++++-
 volumes.h         |   3 +
 7 files changed, 339 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9b7bcf1..c5d2264 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,7 +232,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|--mapper|<uuid>]",
+	"btrfs filesystem show [--all-devices|--mapper|--kernel|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -254,6 +254,9 @@ static int cmd_show(int argc, char **argv)
 	} else if (argc > 1 && !strcmp(argv[1],"--mapper")) {
 		where = BTRFS_SCAN_MAPPER;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1],"--kernel")) {
+		where = BTRFS_SCAN_KERNEL;
+		searchstart += 1;
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
@@ -262,7 +265,7 @@ static int cmd_show(int argc, char **argv)
 	ret = scan_for_btrfs(where, 0);
 
 	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+		fprintf(stderr, "ERROR: %d while scanning\n", ret);
 		return 18;
 	}
 	
diff --git a/ctree.h b/ctree.h
index 0af7477..5e8c610 100644
--- a/ctree.h
+++ b/ctree.h
@@ -350,7 +350,6 @@ struct btrfs_header {
  * room to translate 14 chunks with 3 stripes each.
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
-#define BTRFS_LABEL_SIZE 256
 
 /*
  * just in case we somehow lose the roots and are not able to mount,
diff --git a/ioctl.h b/ioctl.h
index a40a4a1..438c82a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -28,6 +28,7 @@ extern "C" {
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
+#define BTRFS_LABEL_SIZE 256
 
 /* this should be 4k */
 #define BTRFS_PATH_NAME_MAX 4087
@@ -497,6 +498,65 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 	}
 }
 
+
+/* ioctl header */
+struct btrfs_ioctl_header {
+	__u64 sz_self;	/* in/out sz of header*/
+	__u64 sz;	/* in/out sz of payload list*/
+	__u64 count;	/* in/out number of payload units*/
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
+	__u64 total_devices;
+	__u64 missing_devices;
+	__u64 total_rw_bytes;
+	__u64 bytes_used;
+	__u64 flags;
+	__u64 default_mount_subvol_id;
+	char label[BTRFS_LABEL_SIZE];
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
+	__u64 generation;
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
@@ -592,6 +652,10 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_GET_FSIDS _IOWR(BTRFS_IOCTL_MAGIC, 54, \
+				struct btrfs_ioctl_header)
+#define BTRFS_IOC_GET_DEVS _IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				struct btrfs_ioctl_header)
 #ifdef __cplusplus
 }
 #endif
diff --git a/utils.c b/utils.c
index b205005..fe5a6e0 100644
--- a/utils.c
+++ b/utils.c
@@ -1819,6 +1819,247 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
+static struct btrfs_ioctl_header * alloc_ioctl_payload(void **plp,
+		size_t *sz_pl, __u64 mul, __u64 rq_len)
+{
+	struct btrfs_ioctl_header *header;
+	size_t sz;
+	__u64 cnt = 1;
+	size_t sz_payload = *sz_pl;
+
+	if (rq_len)
+		cnt = rq_len/mul + ((rq_len % mul) ? 1 : 0);
+
+	*sz_pl = sz_payload * mul * cnt;
+	sz = sizeof(*header) + *sz_pl;
+	header = malloc(sz);
+	if (!header)
+		return NULL;
+
+	memset(header, 0, sz);
+	header->sz_self = sizeof(*header);
+	header->sz = *sz_pl;
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
+int scan_fsid_kernel(struct btrfs_ioctl_fs_list **out_fslist, int all)
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
+again:
+	pl_sz = sizeof(*fslist);
+	argp = alloc_ioctl_payload((void **)&fslist, &pl_sz,
+					BTRFS_FSIDS_LEN, req_cnt);
+	if (!argp) {
+		close(fd);
+		return -ENOMEM;
+	}
+	fslist->all = all;
+	alloc_cnt = argp->count;
+	res = ioctl(fd, BTRFS_IOC_GET_FSIDS, argp);
+	e = errno;
+	if (res) {
+		printf("ERROR: get_fsid ioctl failed %d - %s\n",
+			res, strerror(e));
+		req_cnt = 0;
+		goto out;
+	}
+	/* ioctl returns fsid count in count parameter*/
+	req_cnt = argp->count;
+	if (req_cnt > alloc_cnt) {
+		/* if kernel has more than initially allocated
+		 * count that means alloc more then call ioctl
+		 * again
+		 */
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
+int get_devs_kernel(struct btrfs_ioctl_dev_list **out_devlist, __u8 *fsid)
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
+again:
+	pl_sz = sizeof(*devlist);
+	argp = alloc_ioctl_payload((void **)&devlist, &pl_sz,
+					BTRFS_DEVS_LEN, req_cnt);
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
+
+
+/* scan kernel for the btrfs dev registered */
+int btrfs_scan_kernel()
+{
+	int e;
+	int dev_cnt;
+	int fsid_cnt;
+	int i, j;
+	int all = 1;
+
+	struct btrfs_ioctl_fsinfo *fsinfo;
+	struct btrfs_ioctl_fs_list *fslist = NULL;
+	struct btrfs_ioctl_devinfo *dev;
+	struct btrfs_ioctl_dev_list *devlist = NULL;
+
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_super_block *disk_super;
+
+	disk_super = (struct btrfs_super_block *)malloc(sizeof(*disk_super));
+	memset(disk_super, '0', sizeof(disk_super));
+
+	fsid_cnt = scan_fsid_kernel(&fslist, all);
+	e = errno;
+	if (fsid_cnt < 0) {
+		printf("ERROR: scan for fs failed %d, - %s\n",
+			fsid_cnt, strerror(e));
+		return 1;
+	}
+
+	if (!fsid_cnt) {
+		BUG_ON(fslist);
+		return 0;
+	}
+	for (i = 0; i < fsid_cnt; i++) {
+		fsinfo = &fslist->fsinfo[i];
+		/* we are not keen in the fsid which are
+		 * not mounted/stale skip them
+		 */
+		if (!(fsinfo->flags & BTRFS_FS_MOUNTED))
+			continue;
+		dev_cnt = get_devs_kernel(&devlist, fsinfo->fsid);
+		e = errno;
+		if (dev_cnt < 0) {
+			free(fslist);
+			printf("Error: get_devs failed %d, - %s\n",
+				dev_cnt, strerror(e));
+			return 1;
+		}
+		if (!dev_cnt)
+			continue;
+
+		device_list_fini(fsinfo->fsid);
+		for (j = 0; j < dev_cnt; j++) {
+			dev = &devlist->dev[j];
+			if (fsinfo->flags & BTRFS_FS_MOUNTED) {
+				memcpy(disk_super->fsid, fsinfo->fsid, BTRFS_FSID_SIZE);
+				memcpy(disk_super->dev_item.uuid, dev->uuid,
+						BTRFS_UUID_SIZE);
+				memcpy(disk_super->label, fsinfo->label, BTRFS_LABEL_SIZE);
+				disk_super->num_devices = dev_cnt;
+				disk_super->generation = dev->generation;
+
+				disk_super->bytes_used = fsinfo->bytes_used;
+				disk_super->dev_item.total_bytes = dev->disk_total_bytes;
+				disk_super->dev_item.bytes_used = dev->bytes_used;
+
+				device_list_add((char *)dev->name, disk_super,
+						dev->devid, &fs_devices);
+				memset(disk_super, '0', sizeof(disk_super));
+			}
+		}
+		if (devlist)
+			free(devlist);
+	}
+
+	if (fslist)
+		free(fslist);
+
+	return 0;
+}
+
 /*
  * scans devs for the btrfs
 */
@@ -1836,6 +2077,9 @@ int scan_for_btrfs(int where, int update_kernel)
 	case BTRFS_SCAN_MAPPER:
 		ret = btrfs_scan_one_dir("/dev/mapper", update_kernel);
 		break;
+	case BTRFS_SCAN_KERNEL:
+		ret = btrfs_scan_kernel();
+		break;
 	}
 	return ret;
 }
diff --git a/utils.h b/utils.h
index 733d13b..116d1e3 100644
--- a/utils.h
+++ b/utils.h
@@ -27,6 +27,7 @@
 #define BTRFS_SCAN_PROC      1
 #define BTRFS_SCAN_DEV       2
 #define BTRFS_SCAN_MAPPER    3
+#define BTRFS_SCAN_KERNEL    4
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -69,4 +70,7 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
+int btrfs_scan_kernel(void);
+int scan_fsid_kernel(struct btrfs_ioctl_fs_list **fslist, int all);
+int get_devs_kernel(struct btrfs_ioctl_dev_list **devlist, __u8 *fsid);
 #endif
diff --git a/volumes.c b/volumes.c
index aa1c3dd..81904c6 100644
--- a/volumes.c
+++ b/volumes.c
@@ -87,7 +87,7 @@ static struct btrfs_fs_devices *find_fsid(u8 *fsid)
 	return NULL;
 }
 
-static int device_list_add(const char *path,
+int device_list_add(const char *path,
 			   struct btrfs_super_block *disk_super,
 			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
 {
@@ -154,6 +154,24 @@ static int device_list_add(const char *path,
 	return 0;
 }
 
+void device_list_fini(u8 *fsid)
+{
+	struct list_head *fsids;
+	struct list_head *cur_fsid;
+	struct btrfs_fs_devices *fs_devices;
+
+	fsids = btrfs_scanned_uuids();
+	list_for_each(cur_fsid, fsids) {
+		fs_devices = list_entry(cur_fsid, struct btrfs_fs_devices,
+				list);
+		if (!memcmp(fs_devices->fsid, fsid, BTRFS_FSID_SIZE)) {
+			list_del(&fs_devices->devices);
+			list_del(&fs_devices->list);
+			break;
+		}
+	}
+}
+
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_devices *seed_devices;
diff --git a/volumes.h b/volumes.h
index 911f788..6286d83 100644
--- a/volumes.h
+++ b/volumes.h
@@ -190,4 +190,7 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
                                                 u64 devid, int instance);
+int device_list_add(const char *path, struct btrfs_super_block *disk_super,
+			   u64 devid, struct btrfs_fs_devices **fs_devices_ret);
+void device_list_fini(u8 *fsid);
 #endif
-- 
1.8.1.227.g44fe835

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
