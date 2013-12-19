Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32581 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSIa0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 03:30:26 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v6] btrfs-progs: fs show should handle if subvol(s) mounted
Date: Thu, 19 Dec 2013 16:38:41 +0800
Message-Id: <1387442321-19019-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as of now with out this patch user would see
fsinfo per btrfs mount path but which mean multiple
entry if more than one subvol is mounted of the same
fsid. so this patch will handle that nicely.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
v6:

 This patch depends on the kernel new ioctl BTRFS_IOC_GET_FSLIST
 That means configurations running old kernel new btrfs-progs
 would end-up with ENOTTY which when would fail to show btrfs which
 are mounted. As Chris Patch 5aff090a3951e7d787b32bb5c49adfec65091385
 introduced a cool way to get around the issue without kernel dependencies,
 now the V6 - will check if there is ENOTTY error if so will 
 fall back to Chris logic. However it will
 still print the ENOTTY error so that user will upgrade the kernel.

v5: fixup missed mem free, thanks David
v4: rebase on integration-20131114
v3: accepts Josef suggested
v2: accepts Zach suggested

 cmds-filesystem.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 utils.c           |   60 ++++++++++++++++++++++++++++++++++++++
 utils.h           |    1 +
 3 files changed, 143 insertions(+), 1 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 46c6eaa..c50a65f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -397,6 +397,29 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	return 0;
 }
 
+static void handle_print(char *mnt, char *label)
+{
+	int fd;
+	struct btrfs_ioctl_fs_info_args fs_info_arg;
+	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
+	struct btrfs_ioctl_space_args *space_info_arg;
+
+	if (get_fs_info(mnt, &fs_info_arg, &dev_info_arg)) {
+		fprintf(stdout, "ERROR: get_fs_info failed\n");
+		return;
+	}
+
+	fd = open(mnt, O_RDONLY);
+	if (fd != -1 && !get_df(fd, &space_info_arg)) {
+		print_one_fs(&fs_info_arg, dev_info_arg,
+				space_info_arg, label, mnt);
+		kfree(space_info_arg);
+	}
+	if (fd != -1)
+		close(fd);
+	kfree(dev_info_arg);
+}
+
 /* This function checks if the given input parameter is
  * an uuid or a path
  * return -1: some error in the given input
@@ -429,6 +452,56 @@ static int check_arg_type(char *input)
 	return BTRFS_ARG_UNKNOWN;
 }
 
+static int btrfs_scan_kernel_v2(void *search)
+{
+	int ret = 0;
+	char label[BTRFS_LABEL_SIZE];
+	char mnt[BTRFS_PATH_NAME_MAX + 1];
+	struct btrfs_ioctl_fslist *fslist;
+	struct btrfs_ioctl_fslist *fslist_saved;
+	u64 cnt_fs;
+	int cnt_mnt;
+	__u8 *fsid;
+	__u64 flags;
+	int found = 0;
+
+	ret = get_fslist(&fslist, &cnt_fs);
+	if (ret)
+		return ret;
+	fslist_saved = fslist;
+	while (cnt_fs--) {
+		fsid = fslist->fsid;
+		flags = fslist->flags;
+		fslist++;
+		if (!(flags & BTRFS_FS_MOUNTED))
+			continue;
+		memset(mnt, 0, BTRFS_PATH_NAME_MAX + 1);
+		memset(label, 0, sizeof(label));
+		ret = fsid_to_mntpt(fsid, mnt, &cnt_mnt);
+		if (ret)
+			break;
+
+		if (get_label_mounted(mnt, label)) {
+			ret = 1;
+			break;
+		}
+
+		if (search && !match_search_item_kernel(fsid,
+					mnt, label, search))
+			continue;
+
+		handle_print(mnt, label);
+		if (search) {
+			found = 1;
+			break;
+		}
+	}
+	kfree(fslist_saved);
+	if (search && !found)
+		return 1;
+	return ret;
+}
+
 static int btrfs_scan_kernel(void *search)
 {
 	int ret = 0, fd;
@@ -605,6 +678,12 @@ static int cmd_show(int argc, char **argv)
 					goto devs_only;
 				}
 			}
+		} else if (type == BTRFS_ARG_MNTPOINT) {
+			char label[BTRFS_LABEL_SIZE];
+			if (get_label_mounted(search, label))
+				return 1;
+			handle_print(search, label);
+			return 0;
 		}
 	}
 
@@ -612,7 +691,9 @@ static int cmd_show(int argc, char **argv)
 		goto devs_only;
 
 	/* show mounted btrfs */
-	ret = btrfs_scan_kernel(search);
+	ret = btrfs_scan_kernel_v2(search);
+	if (ret == -ENOTTY)
+		ret = btrfs_scan_kernel(search);
 	if (search && !ret)
 		return 0;
 
diff --git a/utils.c b/utils.c
index 136ec0e..d505184 100644
--- a/utils.c
+++ b/utils.c
@@ -2202,3 +2202,63 @@ out:
 	close(fd);
 	return ret;
 }
+
+/* This finds the mount point for a given fsid,
+ *  subvols of the same fs/fsid can be mounted
+ *  so here this picks and lowest subvol id
+ *  and returns the mount point
+*/
+int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt)
+{
+	int fd = -1, ret = 0;
+	DIR *dirstream = NULL;
+	FILE *f;
+	struct btrfs_ioctl_fs_info_args fi_args;
+	u64 svid, saved_svid = (u64)-1;
+	struct mntent *mnt;
+	int mcnt = 0;
+
+	*mnt_cnt = 0;
+	f = setmntent("/proc/self/mounts", "r");
+	if (f == NULL)
+		return 1;
+
+	while ((mnt = getmntent(f)) != NULL) {
+		if (strcmp(mnt->mnt_type, "btrfs"))
+			continue;
+		fd = open_file_or_dir(mnt->mnt_dir, &dirstream);
+		if (fd < 0) {
+			ret = -errno;
+			return ret;
+		}
+		ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
+		if (ret < 0) {
+			ret = -errno;
+			close_file_or_dir(fd, dirstream);
+			break;
+		}
+		if (uuid_compare(fsid, fi_args.fsid)) {
+			close_file_or_dir(fd, dirstream);
+			continue;
+		}
+
+		/* found */
+		mcnt++;
+		ret = btrfs_list_get_path_rootid(fd, &svid);
+		if (ret) {
+			/* error so just copy and return*/
+			strcpy(mntpt, mnt->mnt_dir);
+			close_file_or_dir(fd, dirstream);
+			break;
+		}
+		if (svid < saved_svid) {
+			strcpy(mntpt, mnt->mnt_dir);
+			saved_svid = svid;
+		}
+	}
+	endmntent(f);
+	if (mcnt)
+		*mnt_cnt = mcnt;
+
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 2fc230b..00f1c18 100644
--- a/utils.h
+++ b/utils.h
@@ -97,5 +97,6 @@ int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count);
+int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt);
 
 #endif
-- 
1.7.1

