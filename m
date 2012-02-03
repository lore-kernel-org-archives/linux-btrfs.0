From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 3/3] Btrfs-progs: switch all existing commands to a new parser
Date: Fri,  3 Feb 2012 23:24:00 +0200
Message-ID: <1328304240-26100-4-git-send-email-idryomov@gmail.com>
References: <1328304240-26100-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328304240-26100-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The new infrastructure offloads checking number of arguments passed to a
command to individual command handlers.  Fix them up accordingly.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs.c           |    5 ++
 btrfs_cmds.h      |   41 -------------
 cmds-device.c     |  104 ++++++++++++++++++++++-----------
 cmds-filesystem.c |  170 +++++++++++++++++++++++++++++++++++++++-------------
 cmds-inspect.c    |   61 ++++++++++++++-----
 cmds-scrub.c      |  109 +++++++++++++++++++++++++---------
 cmds-subvolume.c  |  161 ++++++++++++++++++++++++++++++++++++++------------
 commands.h        |   15 +++++
 8 files changed, 466 insertions(+), 200 deletions(-)
 delete mode 100644 btrfs_cmds.h

diff --git a/btrfs.c b/btrfs.c
index 7cff30b..599a3e7 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -238,6 +238,11 @@ static int handle_options(int *argc, char ***argv)
 
 const struct cmd_group btrfs_cmd_group = {
 	btrfs_cmd_group_usage, btrfs_cmd_group_info, {
+		{ "subvolume", cmd_subvolume, NULL, &subvolume_cmd_group, 0 },
+		{ "filesystem", cmd_filesystem, NULL, &filesystem_cmd_group, 0 },
+		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
+		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
+		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
deleted file mode 100644
index efca7c5..0000000
--- a/btrfs_cmds.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-/* btrfs_cmds.c*/
-int do_clone(int nargs, char **argv);
-int do_delete_subvolume(int nargs, char **argv);
-int do_create_subvol(int nargs, char **argv);
-int do_fssync(int nargs, char **argv);
-int do_defrag(int argc, char **argv);
-int do_show_filesystem(int nargs, char **argv);
-int do_add_volume(int nargs, char **args);
-int do_balance(int nargs, char **argv);
-int do_scrub_start(int nargs, char **argv);
-int do_scrub_status(int argc, char **argv);
-int do_scrub_resume(int argc, char **argv);
-int do_scrub_cancel(int nargs, char **argv);
-int do_remove_volume(int nargs, char **args);
-int do_scan(int nargs, char **argv);
-int do_resize(int nargs, char **argv);
-int do_subvol_list(int nargs, char **argv);
-int do_set_default_subvol(int nargs, char **argv);
-int do_get_default_subvol(int nargs, char **argv);
-int do_df_filesystem(int nargs, char **argv);
-int do_find_newer(int argc, char **argv);
-int do_change_label(int argc, char **argv);
-int open_file_or_dir(const char *fname);
-int do_ino_to_path(int nargs, char **argv);
-int do_logical_to_ino(int nargs, char **argv);
diff --git a/cmds-device.c b/cmds-device.c
index 0fc4c7f..51089ba 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -28,7 +28,7 @@
 #include "ioctl.h"
 #include "utils.h"
 
-#include "btrfs_cmds.h"
+#include "commands.h"
 
 /* FIXME - imported cruft, fix sparse errors and warnings */
 #ifdef __CHECKER__
@@ -39,12 +39,24 @@ struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
 static inline int ioctl(int fd, int define, void *arg) { return 0; }
 #endif
 
-int do_add_volume(int nargs, char **args)
-{
+static const char device_cmd_group_usage[] =
+	"btrfs device <command> [<args>]";
+
+static const char * const cmd_add_dev_usage[] = {
+	"btrfs device add <device> [<device>...] <path>",
+	"Add a device to a filesystem",
+	NULL
+};
 
-	char	*mntpnt = args[nargs-1];
+static int cmd_add_dev(int argc, char **argv)
+{
+	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
 
+	if (check_argc_min(argc, 3))
+		usage(cmd_add_dev_usage);
+
+	mntpnt = argv[argc - 1];
 
 	fdmnt = open_file_or_dir(mntpnt);
 	if (fdmnt < 0) {
@@ -52,62 +64,62 @@ int do_add_volume(int nargs, char **args)
 		return 12;
 	}
 
-	for (i = 1; i < (nargs-1); i++ ){
+	for (i = 1; i < argc - 1; i++ ){
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
 		struct stat st;
 		int mixed = 0;
 
-		res = check_mounted(args[i]);
+		res = check_mounted(argv[i]);
 		if (res < 0) {
 			fprintf(stderr, "error checking %s mount status\n",
-				args[i]);
+				argv[i]);
 			ret++;
 			continue;
 		}
 		if (res == 1) {
-			fprintf(stderr, "%s is mounted\n", args[i]);
+			fprintf(stderr, "%s is mounted\n", argv[i]);
 			ret++;
 			continue;
 		}
 
-		devfd = open(args[i], O_RDWR);
+		devfd = open(argv[i], O_RDWR);
 		if (!devfd) {
-			fprintf(stderr, "ERROR: Unable to open device '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: Unable to open device '%s'\n", argv[i]);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		res = fstat(devfd, &st);
 		if (res) {
-			fprintf(stderr, "ERROR: Unable to stat '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: Unable to stat '%s'\n", argv[i]);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "ERROR: '%s' is not a block device\n", args[i]);
+			fprintf(stderr, "ERROR: '%s' is not a block device\n", argv[i]);
 			close(devfd);
 			ret++;
 			continue;
 		}
 
-		res = btrfs_prepare_device(devfd, args[i], 1, &dev_block_count, &mixed);
+		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count, &mixed);
 		if (res) {
-			fprintf(stderr, "ERROR: Unable to init '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: Unable to init '%s'\n", argv[i]);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		close(devfd);
 
-		strncpy(ioctl_args.name, args[i], BTRFS_PATH_NAME_MAX);
+		strncpy(ioctl_args.name, argv[i], BTRFS_PATH_NAME_MAX);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		e = errno;
 		if(res<0){
-			fprintf(stderr, "ERROR: error adding the device '%s' - %s\n", 
-				args[i], strerror(e));
+			fprintf(stderr, "ERROR: error adding the device '%s' - %s\n",
+				argv[i], strerror(e));
 			ret++;
 		}
 
@@ -118,31 +130,40 @@ int do_add_volume(int nargs, char **args)
 		return ret+20;
 	else
 		return 0;
-
 }
 
-int do_remove_volume(int nargs, char **args)
-{
+static const char * const cmd_rm_dev_usage[] = {
+	"btrfs device delete <device> [<device>...] <path>",
+	"Remove a device from a filesystem",
+	NULL
+};
 
-	char	*mntpnt = args[nargs-1];
+static int cmd_rm_dev(int argc, char **argv)
+{
+	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
 
+	if (check_argc_min(argc, 3))
+		usage(cmd_rm_dev_usage);
+
+	mntpnt = argv[argc - 1];
+
 	fdmnt = open_file_or_dir(mntpnt);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
 		return 12;
 	}
 
-	for(i=1 ; i < (nargs-1) ; i++ ){
+	for(i=1 ; i < argc - 1; i++ ){
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
-		strncpy(arg.name, args[i], BTRFS_PATH_NAME_MAX);
+		strncpy(arg.name, argv[i], BTRFS_PATH_NAME_MAX);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
 		if(res<0){
-			fprintf(stderr, "ERROR: error removing the device '%s' - %s\n", 
-				args[i], strerror(e));
+			fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",
+				argv[i], strerror(e));
 			ret++;
 		}
 	}
@@ -154,18 +175,21 @@ int do_remove_volume(int nargs, char **args)
 		return 0;
 }
 
-int do_scan(int argc, char **argv)
+static const char * const cmd_scan_dev_usage[] = {
+	"btrfs device scan [<device>...]",
+	"Scan devices for a btrfs filesystem",
+	NULL
+};
+
+static int cmd_scan_dev(int argc, char **argv)
 {
 	int	i, fd, e;
 	int	checklist = 1;
 	int	devstart = 1;
 
-	if( argc >= 2 && !strcmp(argv[1],"--all-devices")){
-
-		if( argc >2 ){
-			fprintf(stderr, "ERROR: too may arguments\n");
-                        return 22;
-                }
+	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
+		if (check_argc_max(argc, 2))
+			usage(cmd_scan_dev_usage);
 
 		checklist = 0;
 		devstart += 1;
@@ -210,7 +234,7 @@ int do_scan(int argc, char **argv)
 
 		if( ret < 0 ){
 			close(fd);
-			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n", 
+			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
 				argv[i], strerror(e));
 			return 11;
 		}
@@ -218,6 +242,18 @@ int do_scan(int argc, char **argv)
 
 	close(fd);
 	return 0;
-
 }
 
+const struct cmd_group device_cmd_group = {
+	device_cmd_group_usage, NULL, {
+		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
+		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
+		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_device(int argc, char **argv)
+{
+	return handle_command_group(&device_cmd_group, argc, argv);
+}
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2e607d2..828ca0c 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -31,17 +31,31 @@
 
 #include "version.h"
 
-#include "btrfs_cmds.h"
+#include "commands.h"
 #include "btrfslabel.h"
 
-int do_df_filesystem(int nargs, char **argv)
+static const char filesystem_cmd_group_usage[] =
+	"btrfs filesystem [<group>] <command> [<args>]";
+
+static const char * const cmd_df_usage[] = {
+	"btrfs filesystem df <path>",
+	"Show space usage information for a mount point",
+	NULL
+};
+
+static int cmd_df(int argc, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs;
 	u64 count = 0, i;
 	int ret;
 	int fd;
 	int e;
-	char *path = argv[1];
+	char *path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_df_usage);
+
+	path = argv[1];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -195,7 +209,14 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	printf("\n");
 }
 
-int do_show_filesystem(int argc, char **argv)
+static const char * const cmd_show_usage[] = {
+	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"Show the structure of a filesystem",
+	"If no argument is given, structure of all present filesystems is shown.",
+	NULL
+};
+
+static int cmd_show(int argc, char **argv)
 {
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
@@ -205,15 +226,13 @@ int do_show_filesystem(int argc, char **argv)
 	int checklist = 1;
 	int searchstart = 1;
 
-	if( argc >= 2 && !strcmp(argv[1],"--all-devices")){
+	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
 		checklist = 0;
 		searchstart += 1;
 	}
 
-	if( argc > searchstart+1 ){
-		fprintf(stderr, "ERROR: too many arguments\n");
-		return 22;
-	}	
+	if (check_argc_max(argc, searchstart + 1))
+		usage(cmd_show_usage);
 
 	if(checklist)
 		ret = btrfs_scan_block_devices(0);
@@ -240,10 +259,21 @@ int do_show_filesystem(int argc, char **argv)
 	return 0;
 }
 
-int do_fssync(int argc, char **argv)
+static const char * const cmd_sync_usage[] = {
+	"btrfs filesystem sync <path>",
+	"Force a sync on a filesystem",
+	NULL
+};
+
+static int cmd_sync(int argc, char **argv)
 {
 	int 	fd, res, e;
-	char	*path = argv[1];
+	char	*path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_sync_usage);
+
+	path = argv[1];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -302,7 +332,20 @@ static int parse_compress_type(char *s)
 	};
 }
 
-int do_defrag(int ac, char **av)
+static const char * const cmd_defrag_usage[] = {
+	"btrfs filesystem defragment [options] <file>|<dir> [<file>|<dir>...]",
+	"Defragment a file or a directory",
+	"",
+	"-v             be verbose",
+	"-c[zlib,lzo]   compress the file while defragmenting",
+	"-f             flush data to disk immediately after defragmenting",
+	"-s start       defragment only from byte onward",
+	"-l len         defragment only up to len bytes",
+	"-t size        minimal size of file to be considered for defragmenting",
+	NULL
+};
+
+static int cmd_defrag(int argc, char **argv)
 {
 	int fd;
 	int flush = 0;
@@ -320,9 +363,10 @@ int do_defrag(int ac, char **av)
 
 	optind = 1;
 	while(1) {
-		int c = getopt(ac, av, "vc::fs:l:t:");
+		int c = getopt(argc, argv, "vc::fs:l:t:");
 		if (c < 0)
 			break;
+
 		switch(c) {
 		case 'c':
 			compress_type = BTRFS_COMPRESS_ZLIB;
@@ -350,16 +394,12 @@ int do_defrag(int ac, char **av)
 			fancy_ioctl = 1;
 			break;
 		default:
-			fprintf(stderr, "Invalid arguments for defragment\n");
-			free(av);
-			return 1;
+			usage(cmd_defrag_usage);
 		}
 	}
-	if (ac - optind == 0) {
-		fprintf(stderr, "Invalid arguments for defragment\n");
-		free(av);
-		return 1;
-	}
+
+	if (check_argc_min(argc - optind, 1))
+		usage(cmd_defrag_usage);
 
 	memset(&range, 0, sizeof(range));
 	range.start = start;
@@ -372,12 +412,12 @@ int do_defrag(int ac, char **av)
 	if (flush)
 		range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
 
-	for (i = optind; i < ac; i++) {
+	for (i = optind; i < argc; i++) {
 		if (verbose)
-			printf("%s\n", av[i]);
-		fd = open_file_or_dir(av[i]);
+			printf("%s\n", argv[i]);
+		fd = open_file_or_dir(argv[i]);
 		if (fd < 0) {
-			fprintf(stderr, "failed to open %s\n", av[i]);
+			fprintf(stderr, "failed to open %s\n", argv[i]);
 			perror("open:");
 			errors++;
 			continue;
@@ -398,7 +438,7 @@ int do_defrag(int ac, char **av)
 		}
 		if (ret) {
 			fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
-				av[i], strerror(e));
+				argv[i], strerror(e));
 			errors++;
 		}
 		close(fd);
@@ -410,16 +450,25 @@ int do_defrag(int ac, char **av)
 		exit(1);
 	}
 
-	free(av);
 	return errors + 20;
 }
 
-int do_balance(int argc, char **argv)
-{
+static const char * const cmd_balance_usage[] = {
+	"btrfs filesystem balance <path>",
+	"Balance the chunks across the device",
+	NULL
+};
 
+static int cmd_balance(int argc, char **argv)
+{
 	int	fdmnt, ret=0, e;
 	struct btrfs_ioctl_vol_args args;
-	char	*path = argv[1];
+	char	*path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_balance_usage);
+
+	path = argv[1];
 
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
@@ -440,12 +489,25 @@ int do_balance(int argc, char **argv)
 	return 0;
 }
 
-int do_resize(int argc, char **argv)
-{
+static const char * const cmd_resize_usage[] = {
+	"btrfs filesystem resize [+/-]<newsize>[gkm]|max <path>",
+	"Resize a filesystem",
+	"If 'max' is passed, the filesystem will occupy all available space",
+	"on the device.",
+	NULL
+};
 
+static int cmd_resize(int argc, char **argv)
+{
 	struct btrfs_ioctl_vol_args	args;
 	int	fd, res, len, e;
-	char	*amount=argv[1], *path=argv[2];
+	char	*amount, *path;
+
+	if (check_argc_exact(argc, 3))
+		usage(cmd_resize_usage);
+
+	amount = argv[1];
+	path = argv[2];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -472,17 +534,39 @@ int do_resize(int argc, char **argv)
 	return 0;
 }
 
-int do_change_label(int nargs, char **argv)
+static const char * const cmd_label_usage[] = {
+	"btrfs filesystem label <device> [<newlabel>]",
+	"Get or change the label of an unmounted filesystem",
+	"With one argument, get the label of filesystem on <device>.",
+	"If <newlabel> is passed, set the filesystem label to <newlabel>.",
+	NULL
+};
+
+static int cmd_label(int argc, char **argv)
 {
-	/* check the number of argument */
-	if ( nargs > 3 ){
-		fprintf(stderr, "ERROR: '%s' requires maximum 2 args\n",
-			argv[0]);
-		return -2;
-	}else if (nargs == 2){
-		return get_label(argv[1]);
-	} else {	/* nargs == 0 */
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
+		usage(cmd_label_usage);
+
+	if (argc > 2)
 		return set_label(argv[1], argv[2]);
-	}
+	else
+		return get_label(argv[1]);
 }
 
+const struct cmd_group filesystem_cmd_group = {
+	filesystem_cmd_group_usage, NULL, {
+		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
+		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
+		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
+		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
+		{ "balance", cmd_balance, cmd_balance_usage, NULL, 0 },
+		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
+		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 },
+	}
+};
+
+int cmd_filesystem(int argc, char **argv)
+{
+	return handle_command_group(&filesystem_cmd_group, argc, argv);
+}
diff --git a/cmds-inspect.c b/cmds-inspect.c
index ca42d7f..6cf565d 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -23,11 +23,14 @@
 #include "kerncompat.h"
 #include "ioctl.h"
 
-#include "btrfs_cmds.h"
+#include "commands.h"
 
 /* btrfs-list.c */
 char *path_for_root(int fd, u64 root);
 
+static const char inspect_cmd_group_usage[] =
+	"btrfs inspect-internal <command> <args>";
+
 static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 {
 	int ret;
@@ -70,29 +73,34 @@ out:
 	return ret;
 }
 
-int do_ino_to_path(int nargs, char **argv)
+static const char * const cmd_inode_resolve_usage[] = {
+	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
+	"Get file system paths for the given inode",
+	NULL
+};
+
+static int cmd_inode_resolve(int argc, char **argv)
 {
 	int fd;
 	int verbose = 0;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(nargs, argv, "v");
+		int c = getopt(argc, argv, "v");
 		if (c < 0)
 			break;
+
 		switch (c) {
 		case 'v':
 			verbose = 1;
 			break;
 		default:
-			fprintf(stderr, "invalid arguments for ipath\n");
-			return 1;
+			usage(cmd_inode_resolve_usage);
 		}
 	}
-	if (nargs - optind != 2) {
-		fprintf(stderr, "invalid arguments for ipath\n");
-		return 1;
-	}
+
+	if (check_argc_exact(argc - optind, 2))
+		usage(cmd_inode_resolve_usage);
 
 	fd = open_file_or_dir(argv[optind+1]);
 	if (fd < 0) {
@@ -104,7 +112,13 @@ int do_ino_to_path(int nargs, char **argv)
 				argv[optind+1]);
 }
 
-int do_logical_to_ino(int nargs, char **argv)
+static const char * const cmd_logical_resolve_usage[] = {
+	"btrfs inspect-internal logical-resolve [-Pv] <logical> <path>",
+	"Get file system paths for the given logical address",
+	NULL
+};
+
+static int cmd_logical_resolve(int argc, char **argv)
 {
 	int ret;
 	int fd;
@@ -119,9 +133,10 @@ int do_logical_to_ino(int nargs, char **argv)
 
 	optind = 1;
 	while (1) {
-		int c = getopt(nargs, argv, "Pv");
+		int c = getopt(argc, argv, "Pv");
 		if (c < 0)
 			break;
+
 		switch (c) {
 		case 'P':
 			getpath = 0;
@@ -130,14 +145,12 @@ int do_logical_to_ino(int nargs, char **argv)
 			verbose = 1;
 			break;
 		default:
-			fprintf(stderr, "invalid arguments for ipath\n");
-			return 1;
+			usage(cmd_logical_resolve_usage);
 		}
 	}
-	if (nargs - optind != 2) {
-		fprintf(stderr, "invalid arguments for ipath\n");
-		return 1;
-	}
+
+	if (check_argc_exact(argc - optind, 2))
+		usage(cmd_logical_resolve_usage);
 
 	inodes = malloc(4096);
 	if (!inodes)
@@ -212,3 +225,17 @@ out:
 	return ret;
 }
 
+const struct cmd_group inspect_cmd_group = {
+	inspect_cmd_group_usage, NULL, {
+		{ "inode-resolve", cmd_inode_resolve, cmd_inode_resolve_usage,
+			NULL, 0 },
+		{ "logical-resolve", cmd_logical_resolve,
+			cmd_logical_resolve_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_inspect(int argc, char **argv)
+{
+	return handle_command_group(&inspect_cmd_group, argc, argv);
+}
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 9dca5f6..af855ba 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -34,11 +34,15 @@
 
 #include "ctree.h"
 #include "ioctl.h"
-#include "btrfs_cmds.h"
 #include "utils.h"
 #include "volumes.h"
 #include "disk-io.h"
 
+#include "commands.h"
+
+static const char scrub_cmd_group_usage[] =
+	"btrfs scrub <command> [options] <path>|<device>";
+
 #define SCRUB_DATA_FILE "/var/lib/btrfs/scrub.status"
 #define SCRUB_PROGRESS_SOCKET_PATH "/var/lib/btrfs/scrub.progress"
 #define SCRUB_FILE_VERSION_PREFIX "scrub status"
@@ -1047,6 +1051,9 @@ int mkdir_p(char *path)
 	return 0;
 }
 
+static const char * const cmd_scrub_start_usage[];
+static const char * const cmd_scrub_resume_usage[];
+
 static int scrub_start(int argc, char **argv, int resume)
 {
 	int fdmnt;
@@ -1114,21 +1121,16 @@ static int scrub_start(int argc, char **argv, int resume)
 			break;
 		case '?':
 		default:
-			fprintf(stderr, "ERROR: scrub args invalid.\n"
-					" -B  do not background\n"
-					" -d  stats per device (-B only)\n"
-					" -q  quiet\n"
-					" -r  read only mode\n");
-			return 1;
+			usage(resume ? cmd_scrub_resume_usage :
+						cmd_scrub_start_usage);
 		}
 	}
 
 	/* try to catch most error cases before forking */
 
-	if (optind + 1 != argc) {
-		fprintf(stderr, "ERROR: scrub start needs path as last "
-			"argument\n");
-		return 1;
+	if (check_argc_exact(argc - optind, 1)) {
+		usage(resume ? cmd_scrub_resume_usage :
+					cmd_scrub_start_usage);
 	}
 
 	spc.progress = NULL;
@@ -1473,25 +1475,42 @@ out:
 	return 0;
 }
 
-int do_scrub_start(int argc, char **argv)
+static const char * const cmd_scrub_start_usage[] = {
+	"btrfs scrub start [-Bdqr] <path>|<device>",
+	"Start a new scrub",
+	"",
+	"-B     do not background",
+	"-d     stats per device (-B only)",
+	"-q     be quiet",
+	"-r     read only mode",
+	NULL
+};
+
+static int cmd_scrub_start(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 0);
 }
 
-int do_scrub_resume(int argc, char **argv)
-{
-	return scrub_start(argc, argv, 1);
-}
+static const char * const cmd_scrub_cancel_usage[] = {
+	"btrfs scrub cancel <path>|<device>",
+	"Cancel a running scrub",
+	NULL
+};
 
-int do_scrub_cancel(int argc, char **argv)
+static int cmd_scrub_cancel(int argc, char **argv)
 {
-	char *path = argv[1];
+	char *path;
 	int ret;
 	int fdmnt;
 	int err;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 
+	if (check_argc_exact(argc, 2))
+		usage(cmd_scrub_cancel_usage);
+
+	path = argv[1];
+
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: scrub cancel failed\n");
@@ -1528,9 +1547,33 @@ again:
 	return 0;
 }
 
-int do_scrub_status(int argc, char **argv)
+static const char * const cmd_scrub_resume_usage[] = {
+	"btrfs scrub resume [-Bdqr] <path>|<device>",
+	"Resume previously canceled or interrupted scrub",
+	"",
+	"-B     do not background",
+	"-d     stats per device (-B only)",
+	"-q     be quiet",
+	"-r     read only mode",
+	NULL
+};
+
+static int cmd_scrub_resume(int argc, char **argv)
 {
+	return scrub_start(argc, argv, 1);
+}
+
+static const char * const cmd_scrub_status_usage[] = {
+	"btrfs scrub status [-dR] <path>|<device>",
+	"Show status of running or finished scrub",
+	"",
+	"-d     stats per device",
+	"-R     print raw stats",
+	NULL
+};
 
+static int cmd_scrub_status(int argc, char **argv)
+{
 	char *path;
 	struct btrfs_ioctl_fs_info_args fi_args;
 	struct btrfs_ioctl_dev_info_args *di_args = NULL;
@@ -1543,7 +1586,6 @@ int do_scrub_status(int argc, char **argv)
 	int ret;
 	int fdmnt;
 	int i;
-	optind = 1;
 	int print_raw = 0;
 	int do_stats_per_dev = 0;
 	char c;
@@ -1551,6 +1593,7 @@ int do_scrub_status(int argc, char **argv)
 	int fdres = -1;
 	int err = 0;
 
+	optind = 1;
 	while ((c = getopt(argc, argv, "dR")) != -1) {
 		switch (c) {
 		case 'd':
@@ -1561,17 +1604,12 @@ int do_scrub_status(int argc, char **argv)
 			break;
 		case '?':
 		default:
-			fprintf(stderr, "ERROR: scrub status args invalid.\n"
-					" -d  stats per device\n");
-			return 1;
+			usage(cmd_scrub_status_usage);
 		}
 	}
 
-	if (optind + 1 != argc) {
-		fprintf(stderr, "ERROR: scrub status needs path as last "
-			"argument\n");
-		return 1;
-	}
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_scrub_status_usage);
 
 	path = argv[optind];
 
@@ -1664,3 +1702,18 @@ out:
 
 	return err;
 }
+
+const struct cmd_group scrub_cmd_group = {
+	scrub_cmd_group_usage, NULL, {
+		{ "start", cmd_scrub_start, cmd_scrub_start_usage, NULL, 0 },
+		{ "cancel", cmd_scrub_cancel, cmd_scrub_cancel_usage, NULL, 0 },
+		{ "resume", cmd_scrub_resume, cmd_scrub_resume_usage, NULL, 0 },
+		{ "status", cmd_scrub_status, cmd_scrub_status_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_scrub(int argc, char **argv)
+{
+	return handle_command_group(&scrub_cmd_group, argc, argv);
+}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 931506c..68ebd40 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -27,12 +27,15 @@
 #include "kerncompat.h"
 #include "ioctl.h"
 
-#include "btrfs_cmds.h"
+#include "commands.h"
 
 /* btrfs-list.c */
 int list_subvols(int fd, int print_parent, int get_default);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 
+static const char subvolume_cmd_group_usage[] =
+	"btrfs subvolume <command> <args>";
+
 /*
  * test if path is a directory
  * this function return
@@ -52,13 +55,26 @@ static int test_isdir(char *path)
 	return S_ISDIR(st.st_mode);
 }
 
-int do_create_subvol(int argc, char **argv)
+static const char * const cmd_subvol_create_usage[] = {
+	"btrfs subvolume create [<dest>/]<name>",
+	"Create a subvolume",
+	"Create a subvolume <name> in <dest>.  If <dest> is not given",
+	"subvolume <name> will be created in the current directory.",
+	NULL
+};
+
+static int cmd_subvol_create(int argc, char **argv)
 {
 	int	res, fddst, len, e;
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args	args;
-	char	*dst = argv[1];
+	char	*dst;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_subvol_create_usage);
+
+	dst = argv[1];
 
 	res = test_isdir(dst);
 	if(res >= 0 ){
@@ -105,7 +121,6 @@ int do_create_subvol(int argc, char **argv)
 	}
 
 	return 0;
-
 }
 
 /*
@@ -127,12 +142,23 @@ static int test_issubvolume(char *path)
 	return (st.st_ino == 256) && S_ISDIR(st.st_mode);
 }
 
-int do_delete_subvolume(int argc, char **argv)
+static const char * const cmd_subvol_delete_usage[] = {
+	"btrfs subvolume delete <name>",
+	"Delete a subvolume",
+	NULL
+};
+
+static int cmd_subvol_delete(int argc, char **argv)
 {
 	int	res, fd, len, e;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
-	char	*path = argv[1];
+	char	*path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_subvol_delete_usage);
+
+	path = argv[1];
 
 	res = test_issubvolume(path);
 	if(res<0){
@@ -186,32 +212,40 @@ int do_delete_subvolume(int argc, char **argv)
 	}
 
 	return 0;
-
 }
 
-int do_subvol_list(int argc, char **argv)
+static const char * const cmd_subvol_list_usage[] = {
+	"btrfs subvolume list [-p] <path>",
+	"List subvolumes (and snapshots)",
+	"",
+	"-p     print parent ID",
+	NULL
+};
+
+static int cmd_subvol_list(int argc, char **argv)
 {
 	int fd;
 	int ret;
 	int print_parent = 0;
 	char *subvol;
-        int optind = 1;
 
+	optind = 1;
 	while(1) {
 		int c = getopt(argc, argv, "p");
-		if (c < 0) break;
+		if (c < 0)
+			break;
+
 		switch(c) {
 		case 'p':
 			print_parent = 1;
-			optind++;
 			break;
+		default:
+			usage(cmd_subvol_list_usage);
 		}
 	}
-	
-	if (argc - optind != 1) {
-		fprintf(stderr, "ERROR: invalid arguments for subvolume list\n");
-		return 1;
-	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_subvol_list_usage);
 
 	subvol = argv[optind];
 
@@ -236,41 +270,46 @@ int do_subvol_list(int argc, char **argv)
 	return 0;
 }
 
-int do_clone(int argc, char **argv)
+static const char * const cmd_snapshot_usage[] = {
+	"btrfs subvolume snapshot [-r] <source> [<dest>/]<name>",
+	"Create a snapshot of the subvolume",
+	"Create a writable/readonly snapshot of the subvolume <source> with",
+	"the name <name> in the <dest> directory",
+	"",
+	"-r     create a readonly snapshot",
+	NULL
+};
+
+static int cmd_snapshot(int argc, char **argv)
 {
 	char	*subvol, *dst;
-	int	res, fd, fddst, len, e, optind = 0, readonly = 0;
+	int	res, fd, fddst, len, e, readonly = 0;
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
 
 	memset(&args, 0, sizeof(args));
 
+	optind = 1;
 	while (1) {
 		int c = getopt(argc, argv, "r");
-
 		if (c < 0)
 			break;
+
 		switch (c) {
 		case 'r':
-			optind++;
 			readonly = 1;
 			break;
 		default:
-			fprintf(stderr,
-				"Invalid arguments for subvolume snapshot\n");
-			free(argv);
-			return 1;
+			usage(cmd_snapshot_usage);
 		}
 	}
-	if (argc - optind != 3) {
-		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
-		free(argv);
-		return 1;
-	}
 
-	subvol = argv[optind+1];
-	dst = argv[optind+2];
+	if (check_argc_exact(argc - optind, 2))
+		usage(cmd_snapshot_usage);
+
+	subvol = argv[optind];
+	dst = argv[optind + 1];
 
 	res = test_issubvolume(subvol);
 	if(res<0){
@@ -350,15 +389,23 @@ int do_clone(int argc, char **argv)
 	}
 
 	return 0;
-
 }
 
-int do_get_default_subvol(int nargs, char **argv)
+static const char * const cmd_subvol_get_default_usage[] = {
+	"btrfs subvolume get-dafault <path>",
+	"Get the default subvolume of a filesystem",
+	NULL
+};
+
+static int cmd_subvol_get_default(int argc, char **argv)
 {
 	int fd;
 	int ret;
 	char *subvol;
 
+	if (check_argc_exact(argc, 2))
+		usage(cmd_subvol_get_default_usage);
+
 	subvol = argv[1];
 
 	ret = test_issubvolume(subvol);
@@ -382,12 +429,24 @@ int do_get_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
-int do_set_default_subvol(int nargs, char **argv)
+static const char * const cmd_subvol_set_default_usage[] = {
+	"btrfs subvolume set-dafault <subvolid> <path>",
+	"Set the default subvolume of a filesystem",
+	NULL
+};
+
+static int cmd_subvol_set_default(int argc, char **argv)
 {
 	int	ret=0, fd, e;
 	u64	objectid;
-	char	*path = argv[2];
-	char	*subvolid = argv[1];
+	char	*path;
+	char	*subvolid;
+
+	if (check_argc_exact(argc, 3))
+		usage(cmd_subvol_set_default_usage);
+
+	subvolid = argv[1];
+	path = argv[2];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -411,13 +470,22 @@ int do_set_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
-int do_find_newer(int argc, char **argv)
+static const char * const cmd_find_new_usage[] = {
+	"btrfs subvolume find-new <path> <lastgen>",
+	"List the recently modified files in a filesystem",
+	NULL
+};
+
+static int cmd_find_new(int argc, char **argv)
 {
 	int fd;
 	int ret;
 	char *subvol;
 	u64 last_gen;
 
+	if (check_argc_exact(argc, 3))
+		usage(cmd_find_new_usage);
+
 	subvol = argv[1];
 	last_gen = atoll(argv[2]);
 
@@ -442,3 +510,22 @@ int do_find_newer(int argc, char **argv)
 	return 0;
 }
 
+const struct cmd_group subvolume_cmd_group = {
+	subvolume_cmd_group_usage, NULL, {
+		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
+		{ "delete", cmd_subvol_delete, cmd_subvol_delete_usage, NULL, 0 },
+		{ "list", cmd_subvol_list, cmd_subvol_list_usage, NULL, 0 },
+		{ "snapshot", cmd_snapshot, cmd_snapshot_usage, NULL, 0 },
+		{ "get-default", cmd_subvol_get_default,
+			cmd_subvol_get_default_usage, NULL, 0 },
+		{ "set-default", cmd_subvol_set_default,
+			cmd_subvol_set_default_usage, NULL, 0 },
+		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_subvolume(int argc, char **argv)
+{
+	return handle_command_group(&subvolume_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 092b368..5d024c2 100644
--- a/commands.h
+++ b/commands.h
@@ -78,3 +78,18 @@ void help_unknown_token(const char *arg, const struct cmd_group *grp);
 void help_ambiguous_token(const char *arg, const struct cmd_group *grp);
 
 void help_command_group(const struct cmd_group *grp, int argc, char **argv);
+
+/* common.c */
+int open_file_or_dir(const char *fname);
+
+extern const struct cmd_group subvolume_cmd_group;
+extern const struct cmd_group filesystem_cmd_group;
+extern const struct cmd_group device_cmd_group;
+extern const struct cmd_group scrub_cmd_group;
+extern const struct cmd_group inspect_cmd_group;
+
+int cmd_subvolume(int argc, char **argv);
+int cmd_filesystem(int argc, char **argv);
+int cmd_device(int argc, char **argv);
+int cmd_scrub(int argc, char **argv);
+int cmd_inspect(int argc, char **argv);
-- 
1.7.6.3

