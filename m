From: Jim Meyering <jim@meyering.net>
Subject: [PATCH 3/4] avoid strncpy-induced buffer overrun
Date: Fri, 20 Apr 2012 19:36:47 +0200
Message-ID: <1334943408-6720-4-git-send-email-jim@meyering.net>
References: <1334943408-6720-1-git-send-email-jim@meyering.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334943408-6720-1-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Jim Meyering <meyering@redhat.com>

* restore.c (main): Ensure strncpy-copied dir_name is NUL-terminated.
* btrfsctl.c (main): Likewise, for a command-line argument.
* utils.c (multiple functions): Likewise.
* btrfs-list.c (add_root): Likewise.
* btrfslabel.c (change_label_unmounted): Likewise.
* cmds-device.c (cmd_add_dev, cmd_rm_dev, cmd_scan_dev): Likewise.
* cmds-filesystem.c (cmd_resize): Likewise.
* cmds-subvolume.c (cmd_subvol_create, cmd_subvol_delete, cmd_snapshot):
Likewise.
---
 btrfs-list.c      |    2 ++
 btrfsctl.c        |    5 +++--
 btrfslabel.c      |    1 +
 cmds-device.c     |    3 +++
 cmds-filesystem.c |    1 +
 cmds-subvolume.c  |    3 +++
 restore.c         |    5 +++--
 utils.c           |   13 ++++++++++---
 8 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5f4a9be..35e6139 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -183,6 +183,8 @@ static int add_root(struct root_lookup *root_lookup,
 	ri->root_id = root_id;
 	ri->ref_tree = ref_tree;
 	strncpy(ri->name, name, name_len);
+	if (name_len > 0)
+		ri->name[name_len-1] = 0;

 	ret = tree_insert(&root_lookup->root, root_id, ref_tree, &ri->rb_node);
 	if (ret) {
diff --git a/btrfsctl.c b/btrfsctl.c
index d45e2a7..518684c 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -241,9 +241,10 @@ int main(int ac, char **av)
 		fd = open_file_or_dir(fname);
 	 }

-	if (name)
+	if (name) {
                 strncpy(args.name, name, BTRFS_PATH_NAME_MAX + 1);
-	else
+                args.name[BTRFS_PATH_NAME_MAX] = 0;
+	} else
 		args.name[0] = '\0';

 	if (command == BTRFS_IOC_SNAP_CREATE) {
diff --git a/btrfslabel.c b/btrfslabel.c
index c9f4684..da694e1 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -58,6 +58,7 @@ static void change_label_unmounted(char *dev, char *nLabel)

        trans = btrfs_start_transaction(root, 1);
        strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
        btrfs_commit_transaction(trans, root);

        /* Now we close it since we are done. */
diff --git a/cmds-device.c b/cmds-device.c
index db625a6..771856b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -117,6 +117,7 @@ static int cmd_add_dev(int argc, char **argv)
 		close(devfd);

 		strncpy(ioctl_args.name, argv[i], BTRFS_PATH_NAME_MAX);
+		ioctl_args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		e = errno;
 		if(res<0){
@@ -161,6 +162,7 @@ static int cmd_rm_dev(int argc, char **argv)
 		int	res;

 		strncpy(arg.name, argv[i], BTRFS_PATH_NAME_MAX);
+		arg.name[BTRFS_PATH_NAME_MAX-1] = 0;
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
 		if(res<0){
@@ -226,6 +228,7 @@ static int cmd_scan_dev(int argc, char **argv)
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);

 		strncpy(args.name, argv[i], BTRFS_PATH_NAME_MAX);
+		args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 		/*
 		 * FIXME: which are the error code returned by this ioctl ?
 		 * it seems that is impossible to understand if there no is
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1f53d1c..ea9e788 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -489,6 +489,7 @@ static int cmd_resize(int argc, char **argv)

 	printf("Resize '%s' of '%s'\n", path, amount);
 	strncpy(args.name, amount, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	e = errno;
 	close(fd);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 950fa8f..fc749f1 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -111,6 +111,7 @@ static int cmd_subvol_create(int argc, char **argv)

 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
 	e = errno;

@@ -202,6 +203,7 @@ static int cmd_subvol_delete(int argc, char **argv)

 	printf("Delete subvolume '%s/%s'\n", dname, vname);
 	strncpy(args.name, vname, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	e = errno;

@@ -378,6 +380,7 @@ static int cmd_snapshot(int argc, char **argv)

 	args.fd = fd;
 	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 	e = errno;

diff --git a/restore.c b/restore.c
index f049105..d1ac542 100644
--- a/restore.c
+++ b/restore.c
@@ -846,11 +846,12 @@ int main(int argc, char **argv)

 	memset(path_name, 0, 4096);

-	strncpy(dir_name, argv[optind + 1], 128);
+	strncpy(dir_name, argv[optind + 1], sizeof dir_name);
+	dir_name[sizeof dir_name - 1] = 0;

 	/* Strip the trailing / on the dir name */
 	len = strlen(dir_name);
-	while (len && dir_name[--len] == '/')) {
+	while (len && dir_name[--len] == '/') {
 		dir_name[len] = '\0';
 	}

diff --git a/utils.c b/utils.c
index ee7fa1b..5240c2c 100644
--- a/utils.c
+++ b/utils.c
@@ -657,9 +657,11 @@ int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
 	ret_ioctl = ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
 	close(loop_fd);

-	if (ret_ioctl == 0)
+	if (ret_ioctl == 0) {
 		strncpy(loop_file, loopinfo.lo_name, max_len);
-	else
+		if (max_len > 0)
+			loop_file[max_len-1] = 0;
+	} else
 		return -errno;

 	return 0;
@@ -860,8 +862,10 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 	}

 	/* Did we find an entry in mnt table? */
-	if (mnt && size && where)
+	if (mnt && size && where) {
 		strncpy(where, mnt->mnt_dir, size);
+		where[size-1] = 0;
+	}
 	if (fs_dev_ret)
 		*fs_dev_ret = fs_devices_mnt;

@@ -893,6 +897,8 @@ int get_mountpt(char *dev, char *mntpt, size_t size)
                if (strcmp(dev, mnt->mnt_fsname) == 0)
                {
                        strncpy(mntpt, mnt->mnt_dir, size);
+                       if (size)
+                                mntpt[size-1] = 0;
                        break;
                }
        }
@@ -925,6 +931,7 @@ void btrfs_register_one_device(char *fname)
 		return;
 	}
 	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	e = errno;
 	if(ret<0){
-- 
1.7.10.208.gb4267

