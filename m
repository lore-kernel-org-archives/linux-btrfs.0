Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:58787 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2FIGYf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jun 2012 02:24:35 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] Removing btrfsctl, btrfs-vol, btrfs-show
Date: Sat,  9 Jun 2012 08:24:19 +0200
Message-Id: <1339223060-6256-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1339223060-6256-1-git-send-email-kreijack@inwind.it>
References: <1339223060-6256-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the commit 002d021c (committed October 2011)
btrfsctl, btrfs-vol, btrfs-show were declared deprecated.
The last patches related to these commands are dated December 2010.

These tools are replaced by the "btrfs" tool in all the
functionality.

This commit removes all the related code.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 INSTALL              |    5 -
 Makefile             |   11 +-
 btrfs-show.c         |  156 -----------------------------
 btrfs-vol.c          |  169 -------------------------------
 btrfsctl.c           |  272 --------------------------------------------------
 man/Makefile         |   10 +-
 man/btrfs-image.8.in |    2 +-
 man/btrfs-show.8.in  |   22 ----
 man/btrfsck.8.in     |    1 -
 man/btrfsctl.8.in    |   48 ---------
 10 files changed, 4 insertions(+), 692 deletions(-)
 delete mode 100644 btrfs-show.c
 delete mode 100644 btrfs-vol.c
 delete mode 100644 btrfsctl.c
 delete mode 100644 man/btrfs-show.8.in
 delete mode 100644 man/btrfsctl.8.in

diff --git a/INSTALL b/INSTALL
index 6afbd90..8ead607 100644
--- a/INSTALL
+++ b/INSTALL
@@ -1,10 +1,5 @@
 Install Instructions
 
-Btrfs puts snapshots and subvolumes into the root directory of the FS.  This
-directory can only be changed by btrfsctl right now, and normal filesystem
-operations do not work on it.  The default subvolume is called 'default',
-and you can create files and directories in mount_point/default
-
 Btrfs uses libcrc32c in the kernel for file and metadata checksums.  You need
 to compile the kernel with:
 
diff --git a/Makefile b/Makefile
index 79818e6..fc56227 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,7 @@ bindir = $(prefix)/bin
 LIBS=-luuid
 RESTORE_LIBS=-lz
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
+progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune
 
@@ -52,15 +52,6 @@ btrfs-find-root: $(objects) find-root.o
 btrfs-restore: $(objects) restore.o
 	gcc $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
 
-btrfsctl: $(objects) btrfsctl.o
-	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-vol: $(objects) btrfs-vol.o
-	$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-show: $(objects) btrfs-show.o
-	$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
-
 btrfsck: $(objects) btrfsck.o
 	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
 
diff --git a/btrfs-show.c b/btrfs-show.c
deleted file mode 100644
index 8210fd2..0000000
--- a/btrfs-show.c
+++ /dev/null
@@ -1,156 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
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
-#define _GNU_SOURCE
-#ifndef __CHECKER__
-#include <sys/ioctl.h>
-#include <sys/mount.h>
-#include "ioctl.h"
-#endif
-#include <stdio.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <dirent.h>
-#include <uuid/uuid.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "transaction.h"
-#include "utils.h"
-#include "volumes.h"
-#include "version.h"
-
-static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
-{
-	struct list_head *cur;
-	struct btrfs_device *device;
-
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
-		if ((device->label && strcmp(device->label, search) == 0) ||
-		    strcmp(device->name, search) == 0)
-			return 1;
-	}
-	return 0;
-}
-
-static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
-{
-	char uuidbuf[37];
-	struct list_head *cur;
-	struct btrfs_device *device;
-	char *super_bytes_used;
-	u64 devs_found = 0;
-	u64 total;
-
-	uuid_unparse(fs_devices->fsid, uuidbuf);
-	device = list_entry(fs_devices->devices.next, struct btrfs_device,
-			    dev_list);
-	if (device->label && device->label[0])
-		printf("Label: %s ", device->label);
-	else
-		printf("Label: none ");
-
-	super_bytes_used = pretty_sizes(device->super_bytes_used);
-
-	total = device->total_devs;
-	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
-	       (unsigned long long)total, super_bytes_used);
-
-	free(super_bytes_used);
-
-	list_for_each(cur, &fs_devices->devices) {
-		char *total_bytes;
-		char *bytes_used;
-		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes);
-		bytes_used = pretty_sizes(device->bytes_used);
-		printf("\tdevid %4llu size %s used %s path %s\n",
-		       (unsigned long long)device->devid,
-		       total_bytes, bytes_used, device->name);
-		free(total_bytes);
-		free(bytes_used);
-		devs_found++;
-	}
-	if (devs_found < total) {
-		printf("\t*** Some devices missing\n");
-	}
-	printf("\n");
-}
-
-static void print_usage(void)
-{
-	fprintf(stderr, "usage: btrfs-show [search label or device]\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
-	exit(1);
-}
-
-static struct option long_options[] = {
-	/* { "byte-count", 1, NULL, 'b' }, */
-	{ 0, 0, 0, 0}
-};
-
-int main(int ac, char **av)
-{
-	struct list_head *all_uuids;
-	struct btrfs_fs_devices *fs_devices;
-	struct list_head *cur_uuid;
-	char *search = NULL;
-	int ret;
-	int option_index = 0;
-
-	printf( "**\n"
-		"** WARNING: this program is considered deprecated\n"
-		"** Please consider to switch to the btrfs utility\n"
-		"**\n");
-
-	while(1) {
-		int c;
-		c = getopt_long(ac, av, "", long_options,
-				&option_index);
-		if (c < 0)
-			break;
-		switch(c) {
-			default:
-				print_usage();
-		}
-	}
-	ac = ac - optind;
-	if (ac != 0) {
-		search = av[optind];
-	}
-
-	ret = btrfs_scan_one_dir("/dev", 0);
-	if (ret)
-		fprintf(stderr, "error %d while scanning\n", ret);
-
-	all_uuids = btrfs_scanned_uuids();
-	list_for_each(cur_uuid, all_uuids) {
-		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
-					list);
-		if (search && uuid_search(fs_devices, search) == 0)
-			continue;
-		print_one_uuid(fs_devices);
-	}
-	printf("%s\n", BTRFS_BUILD_VERSION);
-	return 0;
-}
-
diff --git a/btrfs-vol.c b/btrfs-vol.c
deleted file mode 100644
index 0efdbc1..0000000
--- a/btrfs-vol.c
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
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
-#define _GNU_SOURCE
-#ifndef __CHECKER__
-#include <sys/ioctl.h>
-#include <sys/mount.h>
-#include "ioctl.h"
-#endif
-#include <stdio.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <dirent.h>
-#include <uuid/uuid.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "transaction.h"
-#include "utils.h"
-#include "volumes.h"
-
-#ifdef __CHECKER__
-#define BLKGETSIZE64 0
-#define BTRFS_IOC_SNAP_CREATE 0
-#define BTRFS_IOC_ADD_DEV 0
-#define BTRFS_IOC_RM_DEV 0
-#define BTRFS_VOL_NAME_MAX 255
-struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
-static inline int ioctl(int fd, int define, void *arg) { return 0; }
-#endif
-
-static void print_usage(void)
-{
-	fprintf(stderr, "usage: btrfs-vol [options] mount_point\n");
-	fprintf(stderr, "\t-a device add one device\n");
-	fprintf(stderr, "\t-b balance chunks across all devices\n");
-	fprintf(stderr, "\t-r device remove one device\n");
-	exit(1);
-}
-
-static struct option long_options[] = {
-	/* { "byte-count", 1, NULL, 'b' }, */
-	{ "add", 1, NULL, 'a' },
-	{ "balance", 0, NULL, 'b' },
-	{ "remove", 1, NULL, 'r' },
-	{ 0, 0, 0, 0}
-};
-
-int main(int ac, char **av)
-{
-	struct stat st;
-	char *device = NULL;
-	char *mnt = NULL;
-	int ret;
-	int option_index = 0;
-	int cmd = 0;
-	int fd;
-	int devfd = 0;
-	DIR *dirstream;
-	struct btrfs_ioctl_vol_args args;
-	u64 dev_block_count = 0;
-
-	printf( "**\n"
-		"** WARNING: this program is considered deprecated\n"
-		"** Please consider to switch to the btrfs utility\n"
-		"**\n");
-
-	while(1) {
-		int c;
-		c = getopt_long(ac, av, "a:br:", long_options,
-				&option_index);
-		if (c < 0)
-			break;
-		switch(c) {
-			case 'a':
-				device = strdup(optarg);
-				cmd = BTRFS_IOC_ADD_DEV;
-				break;
-			case 'b':
-				cmd = BTRFS_IOC_BALANCE;
-				break;
-			case 'r':
-				device = strdup(optarg);
-				cmd = BTRFS_IOC_RM_DEV;
-				break;
-			default:
-				print_usage();
-		}
-	}
-	ac = ac - optind;
-	if (ac == 0)
-		print_usage();
-	mnt = av[optind];
-
-	if (device && strcmp(device, "missing") == 0 &&
-	    cmd == BTRFS_IOC_RM_DEV) {
-		fprintf(stderr, "removing missing devices from %s\n", mnt);
-	} else if (cmd != BTRFS_IOC_BALANCE) {
-		if (cmd == BTRFS_IOC_ADD_DEV) {
-			ret = check_mounted(device);
-			if (ret < 0) {
-				fprintf(stderr,
-					"error checking %s mount status\n",
-					device);
-				exit(1);
-			}
-			if (ret == 1) {
-				fprintf(stderr, "%s is mounted\n", device);
-				exit(1);
-			}
-		}
-		devfd = open(device, O_RDWR);
-		if (devfd < 0) {
-			fprintf(stderr, "Unable to open device %s\n", device);
-			exit(1);
-		}
-		ret = fstat(devfd, &st);
-		if (ret) {
-			fprintf(stderr, "Unable to stat %s\n", device);
-			exit(1);
-		}
-		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "%s is not a block device\n", device);
-			exit(1);
-		}
-	}
-	dirstream = opendir(mnt);
-	if (!dirstream) {
-		fprintf(stderr, "Unable to open directory %s\n", mnt);
-		exit(1);
-	}
-	if (cmd == BTRFS_IOC_ADD_DEV) {
-		int mixed = 0;
-
-		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count, &mixed);
-		if (ret) {
-			fprintf(stderr, "Unable to init %s\n", device);
-			exit(1);
-		}
-	}
-	fd = dirfd(dirstream);
-	if (device)
-		strcpy(args.name, device);
-	else
-		args.name[0] = '\0';
-
-	ret = ioctl(fd, cmd, &args);
-	printf("ioctl returns %d\n", ret);
-	return 0;
-}
-
diff --git a/btrfsctl.c b/btrfsctl.c
deleted file mode 100644
index d45e2a7..0000000
--- a/btrfsctl.c
+++ /dev/null
@@ -1,272 +0,0 @@
-/*
- * Copyright (C) 2007 Oracle.  All rights reserved.
- *
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
-#ifndef __CHECKER__
-#include <sys/ioctl.h>
-#include <sys/mount.h>
-#include "ioctl.h"
-#endif
-#include <stdio.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <dirent.h>
-#include <libgen.h>
-#include <stdlib.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "transaction.h"
-#include "utils.h"
-#include "version.h"
-
-#ifdef __CHECKER__
-#define BLKGETSIZE64 0
-#define BTRFS_IOC_SNAP_CREATE 0
-#define BTRFS_VOL_NAME_MAX 255
-struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
-static inline int ioctl(int fd, int define, void *arg) { return 0; }
-#endif
-
-static void print_usage(void)
-{
-	printf("usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]\n");
-	printf("                [-r size] [-A device] [-a] [-c] [-D dir .]\n");
-	printf("\t-d filename: defragments one file\n");
-	printf("\t-d directory: defragments the entire Btree\n");
-	printf("\t-s snap_name dir: creates a new snapshot of dir\n");
-	printf("\t-S subvol_name dir: creates a new subvolume\n");
-	printf("\t-r [+-]size[gkm]: resize the FS by size amount\n");
-	printf("\t-A device: scans the device file for a Btrfs filesystem\n");
-	printf("\t-a: scans all devices for Btrfs filesystems\n");
-	printf("\t-c: forces a single FS sync\n");
-	printf("\t-D: delete snapshot\n");
-	printf("\t-m [tree id] directory: set the default mounted subvolume"
-	       " to the [tree id] or the directory\n");
-	printf("%s\n", BTRFS_BUILD_VERSION);
-	exit(1);
-}
-
-static int open_file_or_dir(const char *fname)
-{
-	int ret;
-	struct stat st;
-	DIR *dirstream;
-	int fd;
-
-	ret = stat(fname, &st);
-	if (ret < 0) {
-		perror("stat:");
-		exit(1);
-	}
-	if (S_ISDIR(st.st_mode)) {
-		dirstream = opendir(fname);
-		if (!dirstream) {
-			perror("opendir");
-			exit(1);
-		}
-		fd = dirfd(dirstream);
-	} else {
-		fd = open(fname, O_RDWR);
-	}
-	if (fd < 0) {
-		perror("open");
-		exit(1);
-	}
-	return fd;
-}
-int main(int ac, char **av)
-{
-	char *fname = NULL;
-	char *snap_location = NULL;
-	int snap_fd = 0;
-	int fd;
-	int ret;
-	struct btrfs_ioctl_vol_args args;
-	char *name = NULL;
-	int i;
-	unsigned long command = 0;
-	int len;
-	char *pos;
-	char *fullpath;
-	u64 objectid = 0;
-
-	printf( "**\n"
-		"** WARNING: this program is considered deprecated\n"
-		"** Please consider to switch to the btrfs utility\n"
-		"**\n");
-	
-	if (ac == 2 && strcmp(av[1], "-a") == 0) {
-		fprintf(stderr, "Scanning for Btrfs filesystems\n");
-		btrfs_scan_one_dir("/dev", 1);
-		exit(0);
-	}
-	for (i = 1; i < ac; i++) {
-		if (strcmp(av[i], "-s") == 0) {
-			if (i + 1 >= ac - 1) {
-				fprintf(stderr, "-s requires an arg");
-				print_usage();
-			}
-			fullpath = av[i + 1];
-
-			snap_location = strdup(fullpath);
-			snap_location = dirname(snap_location);
-
-			snap_fd = open_file_or_dir(snap_location);
-
-			name = strdup(fullpath);
-			name = basename(name);
-			len = strlen(name);
-
-			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-				fprintf(stderr,
-				     "snapshot name zero length or too long\n");
-				exit(1);
-			}
-			if (strchr(name, '/')) {
-				fprintf(stderr,
-					"error: / not allowed in names\n");
-				exit(1);
-			}
-			command = BTRFS_IOC_SNAP_CREATE;
-		} else if (strcmp(av[i], "-S") == 0) {
-			if (i + 1 >= ac - 1) {
-				fprintf(stderr, "-S requires an arg");
-				print_usage();
-			}
-			name = av[i + 1];
-			len = strlen(name);
-			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-				fprintf(stderr,
-				     "snapshot name zero length or too long\n");
-				exit(1);
-			}
-			if (strchr(name, '/')) {
-				fprintf(stderr,
-					"error: / not allowed in names\n");
-				exit(1);
-			}
-			command = BTRFS_IOC_SUBVOL_CREATE;
-		} else if (strcmp(av[i], "-d") == 0) {
-			if (i >= ac - 1) {
-				fprintf(stderr, "-d requires an arg\n");
-				print_usage();
-			}
-			command = BTRFS_IOC_DEFRAG;
-		} else if (strcmp(av[i], "-D") == 0) {
-			if (i >= ac - 1) {
-				fprintf(stderr, "-D requires an arg\n");
-				print_usage();
-			}
-			command = BTRFS_IOC_SNAP_DESTROY;
-			name = av[i + 1];
-			len = strlen(name);
-			pos = strchr(name, '/');
-			if (pos) {
-				if (*(pos + 1) == '\0')
-					*(pos) = '\0';
-				else {
-					fprintf(stderr,
-						"error: / not allowed in names\n");
-					exit(1);
-				}
-			}
-			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-				fprintf(stderr, "-D size too long\n");
-				exit(1);
-			}
-		} else if (strcmp(av[i], "-A") == 0) {
-			if (i >= ac - 1) {
-				fprintf(stderr, "-A requires an arg\n");
-				print_usage();
-			}
-			command = BTRFS_IOC_SCAN_DEV;
-		} else if (strcmp(av[i], "-r") == 0) {
-			if (i >= ac - 1) {
-				fprintf(stderr, "-r requires an arg\n");
-				print_usage();
-			}
-			name = av[i + 1];
-			len = strlen(name);
-			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-				fprintf(stderr, "-r size too long\n");
-				exit(1);
-			}
-			command = BTRFS_IOC_RESIZE;
-		} else if (strcmp(av[i], "-c") == 0) {
-			command = BTRFS_IOC_SYNC;
-		} else if (strcmp(av[i], "-m") == 0) {
-			command = BTRFS_IOC_DEFAULT_SUBVOL;
-			if (i == ac - 3) {
-				objectid = (unsigned long long)
-					    strtoll(av[i + 1], NULL, 0);
-				if (errno == ERANGE) {
-					fprintf(stderr, "invalid tree id\n");
-					exit(1);
-				}
-			}
-		}
-	}
-	if (command == 0) {
-		fprintf(stderr, "no valid commands given\n");
-		print_usage();
-		exit(1);
-	}
-	fname = av[ac - 1];
-
-	if (command == BTRFS_IOC_SCAN_DEV) {
-		fd = open("/dev/btrfs-control", O_RDWR);
-		if (fd < 0) {
-			perror("failed to open /dev/btrfs-control");
-			exit(1);
-		}
-		name = fname;
-	 } else {
-		fd = open_file_or_dir(fname);
-	 }
-
-	if (name)
-                strncpy(args.name, name, BTRFS_PATH_NAME_MAX + 1);
-	else
-		args.name[0] = '\0';
-
-	if (command == BTRFS_IOC_SNAP_CREATE) {
-		args.fd = fd;
-		ret = ioctl(snap_fd, command, &args);
-	} else if (command == BTRFS_IOC_DEFAULT_SUBVOL) {
-		printf("objectid is %llu\n", (unsigned long long)objectid);
-		ret = ioctl(fd, command, &objectid);
-	} else
-		ret = ioctl(fd, command, &args);
-	if (ret < 0) {
-		perror("ioctl:");
-		exit(1);
-	}
-	if (ret == 0) {
-		printf("operation complete\n");
-	} else {
-		printf("ioctl failed with error %d\n", ret);
-	}
-	printf("%s\n", BTRFS_BUILD_VERSION);
-	if (ret)
-		exit(1);
-
-	return 0;
-}
-
diff --git a/man/Makefile b/man/Makefile
index 4a90b75..40e0439 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -6,8 +6,8 @@ bindir = $(prefix)/bin
 mandir = $(prefix)/man
 man8dir = $(mandir)/man8
 
-MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz \
-	   btrfs-show.8.gz btrfs.8.gz
+MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz \
+	   btrfs.8.gz
 
 all: $(MANPAGES)
 
@@ -17,18 +17,12 @@ mkfs.btrfs.8.gz: mkfs.btrfs.8.in
 btrfs.8.gz: btrfs.8.in
 	$(GZIP) -n -c btrfs.8.in > btrfs.8.gz
 
-btrfsctl.8.gz: btrfsctl.8.in
-	$(GZIP) -n -c btrfsctl.8.in > btrfsctl.8.gz
-
 btrfsck.8.gz: btrfsck.8.in
 	$(GZIP) -n -c btrfsck.8.in > btrfsck.8.gz
 
 btrfs-image.8.gz: btrfs-image.8.in
 	$(GZIP) -n -c btrfs-image.8.in > btrfs-image.8.gz
 
-btrfs-show.8.gz: btrfs-show.8.in
-	$(GZIP) -n -c btrfs-show.8.in > btrfs-show.8.gz
-
 clean :
 	rm -f $(MANPAGES)
 
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
index 7a348f8..f095cbd 100644
--- a/man/btrfs-image.8.in
+++ b/man/btrfs-image.8.in
@@ -31,4 +31,4 @@ and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki
 http://btrfs.wiki.kernel.org for further details.
 .SH SEE ALSO
-.BR btrfsck (8), btrfsctl (8), mkfs.btrfs (8)
+.BR btrfsck (8), mkfs.btrfs (8)
diff --git a/man/btrfs-show.8.in b/man/btrfs-show.8.in
deleted file mode 100644
index cb98b68..0000000
--- a/man/btrfs-show.8.in
+++ /dev/null
@@ -1,22 +0,0 @@
-.TH BTRFS-SHOW 8
-.SH NAME
-btrfs-show \- scan the /dev directory for btrfs partitions and print results.
-.SH SYNOPSIS
-.B btrfs-show
-.SH NOTE
-.B btrfs-show
-is deprecated. Please consider to switch to the btrfs utility.	
-.SH DESCRIPTION
-.B btrfs-show
-is used to scan the /dev directory for btrfs partitions and display brief
-information such as lable, uuid, etc of each btrfs partition.
-.SH OPTIONS
-none
-.SH AVAILABILITY
-.B btrfs-show
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki
-http://btrfs.wiki.kernel.org for further details.
-.SH SEE ALSO
-.BR btrfsck (8), btrfsctl (8), mkfs.btrfs (8), btrfs-image (8)
diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
index 4bf1cff..5004ba0 100644
--- a/man/btrfsck.8.in
+++ b/man/btrfsck.8.in
@@ -14,4 +14,3 @@ Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 .SH SEE ALSO
 .BR mkfs.btrfs (8)
-.BR btrfsctl (8)
diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
deleted file mode 100644
index 8705fa6..0000000
--- a/man/btrfsctl.8.in
+++ /dev/null
@@ -1,48 +0,0 @@
-.TH BTRFSCTL 8
-.SH NAME
-btrfsctl \- control a btrfs filesystem
-.SH SYNOPSIS
-.B btrfsctl
-[ \fB\-d\fP\fI file|directory \fP ]
-[ \fB\-s\fP\fI snapshot-name directory\fP ]
-[ \fB \-S\fP\fI subvolume-name directory\fP ]
-[ \fB \-r\fP\fI [+-]size\fP ]
-[ \fB \-A\fP\fI device\fP ]
-[ \fB \-a\fP ]
-[ \fB \-c\fP ]
-.SH NOTE
-B btrfsctl
-is deprecated. Please consider to switch to the btrfs utility.
-.SH DESCRIPTION
-.B btrfsctl
-is used to control the filesystem and the files and directories stored. It is the tool to create a new snapshot for the filesystem.
-.SH OPTIONS
-.TP
-\fB\-d\fR \fIfile|directory\fR
-Defragment a file or a directory. If the argument is a directory, the entire b-tree under the directory is defragged.
-.TP
-\fB\-s\fR \fIsnapshot-name directory\fR
-Creates a new \fIsnapshot\fP of the \fIdirectory\fP specified.
-.TP
-\fB\-S\fR \fIsubvolume-name directory\fR
-Creates a new subvolume.
-.TP
-\fB\-r\fR \fI[+|-]size\fR
-Resizes the filesystem with the \fIsize\fP specified. If the value is preceded with a signed symbol, the filesystem is resized with respect to the current filesystem size. \fIsize\fP can be suffixed by k,m or g to represent kilobytes, megabytes, or gigabytes respectively.
-.TP
-\fB\-A\fR \fIdevice\fR
-Scans the \fIdevice\fR for btrfs filesystem.
-.TP
-\fB\-a\fR
-Scans all devices present in the system for btrfs filesystem.
-.TP
-\fB\-c\fR
-Forces a filesystem sync.
-.SH AVAILABILITY
-.B btrfsctl
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-further details.
-.SH SEE ALSO
-.BR mkfs.btrfs (8)
-- 
1.7.10

