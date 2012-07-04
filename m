Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2GDNkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:40:18 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2633951bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:40:17 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCH 6/6] Btrfs-progs: add btrfs send/receive commands
Date: Wed,  4 Jul 2012 15:39:34 +0200
Message-Id: <1341409174-13619-7-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add user space commands for btrfs send/receive.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 Makefile       |    7 +-
 btrfs.c        |    2 +
 cmds-receive.c |  910 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-send.c    |  677 +++++++++++++++++++++++++++++++++++++++++
 commands.h     |    4 +
 send-stream.c  |  480 ++++++++++++++++++++++++++++++
 send-stream.h  |   58 ++++
 send-utils.c   |  337 +++++++++++++++++++++
 send-utils.h   |   69 +++++
 send.h         |  132 ++++++++
 10 files changed, 2673 insertions(+), 3 deletions(-)
 create mode 100644 cmds-receive.c
 create mode 100644 cmds-send.c
 create mode 100644 send-stream.c
 create mode 100644 send-stream.h
 create mode 100644 send-utils.c
 create mode 100644 send-utils.h
 create mode 100644 send.h

diff --git a/Makefile b/Makefile
index 9694444..cd1203c 100644
--- a/Makefile
+++ b/Makefile
@@ -4,9 +4,10 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
+	  send-stream.o send-utils.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o cmds-balance.o
+	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
@@ -15,7 +16,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid
+LIBS=-luuid -lm
 RESTORE_LIBS=-lz
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
diff --git a/btrfs.c b/btrfs.c
index 88238d6..19a6961 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -246,6 +246,8 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
+		{ "send", cmd_send, NULL, &send_cmd_group, 0 },
+		{ "receive", cmd_receive, NULL, &receive_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-receive.c b/cmds-receive.c
new file mode 100644
index 0000000..024dc2a
--- /dev/null
+++ b/cmds-receive.c
@@ -0,0 +1,910 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
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
+#define _GNU_SOURCE
+#define _POSIX_C_SOURCE 200809
+#define _XOPEN_SOURCE 700
+#define _BSD_SOURCE
+
+#include <unistd.h>
+#include <stdint.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <math.h>
+#include <ftw.h>
+#include <wait.h>
+
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/xattr.h>
+#include <uuid/uuid.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+#include "commands.h"
+#include "list.h"
+
+#include "send.h"
+#include "send-stream.h"
+#include "send-utils.h"
+
+static int g_verbose = 0;
+
+struct btrfs_receive
+{
+	int mnt_fd;
+
+	int write_fd;
+	char *write_path;
+
+	char *root_path;
+	char *full_subvol_path;
+
+	struct subvol_info *cur_subvol;
+	struct subvol_info *parent_subvol;
+
+	struct subvol_uuid_search sus;
+};
+
+static int finish_subvol(struct btrfs_receive *r)
+{
+	int ret;
+	int subvol_fd = -1;
+	int info_fd = -1;
+	struct btrfs_ioctl_received_subvol_args rs_args;
+	char uuid_str[128];
+	u64 flags;
+
+	if (r->cur_subvol == NULL)
+		return 0;
+
+	subvol_fd = openat(r->mnt_fd, r->cur_subvol->path,
+			O_RDONLY | O_NOATIME);
+	if (subvol_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+				r->cur_subvol->path, strerror(-ret));
+		goto out;
+	}
+
+	memset(&rs_args, 0, sizeof(rs_args));
+	memcpy(rs_args.uuid, r->cur_subvol->received_uuid, BTRFS_UUID_SIZE);
+	rs_args.stransid = r->cur_subvol->stransid;
+
+	if (g_verbose >= 1) {
+		uuid_unparse((u8*)rs_args.uuid, uuid_str);
+		fprintf(stderr, "BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=%s, "
+				"stransid=%llu\n", uuid_str, rs_args.stransid);
+	}
+
+	ret = ioctl(subvol_fd, BTRFS_IOC_SET_RECEIVED_SUBVOL, &rs_args);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: BTRFS_IOC_SET_RECEIVED_SUBVOL failed. %s\n",
+				strerror(-ret));
+		goto out;
+	}
+	r->cur_subvol->rtransid = rs_args.rtransid;
+
+	ret = ioctl(subvol_fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: BTRFS_IOC_SUBVOL_GETFLAGS failed. %s\n",
+				strerror(-ret));
+		goto out;
+	}
+
+	flags |= BTRFS_SUBVOL_RDONLY;
+
+	ret = ioctl(subvol_fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to make subvolume read only. "
+				"%s\n", strerror(-ret));
+		goto out;
+	}
+
+	subvol_uuid_search_add(&r->sus, r->cur_subvol);
+	r->cur_subvol = NULL;
+	ret = 0;
+
+out:
+	if (subvol_fd != -1)
+		close(subvol_fd);
+	if (info_fd != -1)
+		close(info_fd);
+	return ret;
+}
+
+static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
+			  void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	struct btrfs_ioctl_vol_args args_v1;
+	char uuid_str[128];
+
+	ret = finish_subvol(r);
+	if (ret < 0)
+		goto out;
+
+	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->parent_subvol = NULL;
+
+	r->cur_subvol->path = strdup(path);
+	r->full_subvol_path = path_cat(r->root_path, path);
+
+	fprintf(stderr, "At subvol %s\n", path);
+
+	memcpy(r->cur_subvol->received_uuid, uuid, BTRFS_UUID_SIZE);
+	r->cur_subvol->stransid = ctransid;
+
+	if (g_verbose) {
+		uuid_unparse((u8*)r->cur_subvol->received_uuid, uuid_str);
+		fprintf(stderr, "receiving subvol %s uuid=%s, stransid=%llu\n",
+				path, uuid_str,
+				r->cur_subvol->stransid);
+	}
+
+	memset(&args_v1, 0, sizeof(args_v1));
+	strcpy(args_v1.name, path);
+	ret = ioctl(r->mnt_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: creating subvolume %s failed. "
+				"%s\n", path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
+			    const u8 *parent_uuid, u64 parent_ctransid,
+			    void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char uuid_str[128];
+	struct btrfs_ioctl_vol_args_v2 args_v2;
+
+	ret = finish_subvol(r);
+	if (ret < 0)
+		goto out;
+
+	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
+	r->parent_subvol = NULL;
+
+	r->cur_subvol->path = strdup(path);
+	r->full_subvol_path = path_cat(r->root_path, path);
+
+	fprintf(stderr, "At snapshot %s\n", path);
+
+	memcpy(r->cur_subvol->received_uuid, uuid, BTRFS_UUID_SIZE);
+	r->cur_subvol->stransid = ctransid;
+
+	if (g_verbose) {
+		uuid_unparse((u8*)r->cur_subvol->received_uuid, uuid_str);
+		fprintf(stderr, "receiving snapshot %s uuid=%s, "
+				"ctransid=%llu ", path, uuid_str,
+				r->cur_subvol->stransid);
+		uuid_unparse(parent_uuid, uuid_str);
+		fprintf(stderr, "parent_uuid=%s, parent_ctransid=%llu\n",
+				uuid_str, parent_ctransid);
+	}
+
+	memset(&args_v2, 0, sizeof(args_v2));
+	strcpy(args_v2.name, path);
+
+	r->parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
+			parent_ctransid, NULL, subvol_search_by_received_uuid);
+	if (!r->parent_subvol) {
+		ret = -ENOENT;
+		fprintf(stderr, "ERROR: could not find parent subvolume\n");
+		goto out;
+	}
+
+	/*if (rs_args.ctransid > rs_args.rtransid) {
+		if (!r->force) {
+			ret = -EINVAL;
+			fprintf(stderr, "ERROR: subvolume %s was modified after it was received.\n", r->subvol_parent_name);
+			goto out;
+		} else {
+			fprintf(stderr, "WARNING: subvolume %s was modified after it was received.\n", r->subvol_parent_name);
+		}
+	}*/
+
+	args_v2.fd = openat(r->mnt_fd, r->parent_subvol->path,
+			O_RDONLY | O_NOATIME);
+	if (args_v2.fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+				r->parent_subvol->path, strerror(-ret));
+		goto out;
+	}
+
+	ret = ioctl(r->mnt_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
+	close(args_v2.fd);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: creating snapshot %s -> %s "
+				"failed. %s\n", r->parent_subvol->path,
+				path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static int process_mkfile(const char *path, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "mkfile %s\n", path);
+
+	ret = creat(full_path, 0600);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: mkfile %s failed. %s\n", path,
+				strerror(-ret));
+		goto out;
+	}
+	close(ret);
+	ret = 0;
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_mkdir(const char *path, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "mkdir %s\n", path);
+
+	ret = mkdir(full_path, 0700);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: mkdir %s failed. %s\n", path,
+				strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+static int process_mknod(const char *path, u64 mode, u64 dev, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "mknod %s mode=%llu, dev=%llu\n",
+				path, mode, dev);
+
+	ret = mknod(full_path, mode & S_IFMT, dev);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: mknod %s failed. %s\n", path,
+				strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+static int process_mkfifo(const char *path, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "mkfifo %s\n", path);
+
+	ret = mkfifo(full_path, 0600);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: mkfifo %s failed. %s\n", path,
+				strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+static int process_mksock(const char *path, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "mksock %s\n", path);
+
+	ret = mknod(full_path, 0600 | S_IFSOCK, 0);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: mknod %s failed. %s\n", path,
+				strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+static int process_symlink(const char *path, const char *lnk, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "symlink %s -> %s\n", path, lnk);
+
+	ret = symlink(lnk, full_path);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: symlink %s -> %s failed. %s\n", path,
+				lnk, strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+static int process_rename(const char *from, const char *to, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_from = path_cat(r->full_subvol_path, from);
+	char *full_to = path_cat(r->full_subvol_path, to);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "rename %s -> %s\n", from, to);
+
+	ret = rename(full_from, full_to);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: rename %s -> %s failed. %s\n", from,
+				to, strerror(-ret));
+	}
+
+	free(full_from);
+	free(full_to);
+	return ret;
+}
+
+static int process_link(const char *path, const char *lnk, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "link %s -> %s\n", path, lnk);
+
+	ret = link(lnk, full_path);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: link %s -> %s failed. %s\n", path,
+				lnk, strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+
+static int process_unlink(const char *path, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "unlink %s\n", path);
+
+	ret = unlink(full_path);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: unlink %s failed. %s\n", path,
+				strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+static int process_rmdir(const char *path, void *user)
+{
+	int ret;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "rmdir %s\n", path);
+
+	ret = rmdir(full_path);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: rmdir %s failed. %s\n", path,
+				strerror(-ret));
+	}
+
+	free(full_path);
+	return ret;
+}
+
+
+static int open_inode_for_write(struct btrfs_receive *r, const char *path)
+{
+	int ret = 0;
+
+	if (r->write_fd != -1) {
+		if (strcmp(r->write_path, path) == 0)
+			goto out;
+		close(r->write_fd);
+		r->write_fd = -1;
+	}
+
+	r->write_fd = open(path, O_RDWR);
+	if (r->write_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n", path,
+				strerror(-ret));
+		goto out;
+	}
+	free(r->write_path);
+	r->write_path = strdup(path);
+
+out:
+	return ret;
+}
+
+static int close_inode_for_write(struct btrfs_receive *r)
+{
+	int ret = 0;
+
+	if(r->write_fd == -1)
+		goto out;
+
+	close(r->write_fd);
+	r->write_fd = -1;
+	r->write_path[0] = 0;
+
+out:
+	return ret;
+}
+
+static int process_write(const char *path, const void *data, u64 offset,
+			 u64 len, void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+	u64 pos = 0;
+	int w;
+
+	ret = open_inode_for_write(r, full_path);
+	if (ret < 0)
+		goto out;
+
+	while (pos < len) {
+		w = pwrite(r->write_fd, (char*)data + pos, len - pos,
+				offset + pos);
+		if (w < 0) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: writing to %s failed. %s\n",
+					path, strerror(-ret));
+			goto out;
+		}
+		pos += w;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_clone(const char *path, u64 offset, u64 len,
+			 const u8 *clone_uuid, u64 clone_ctransid,
+			 const char *clone_path, u64 clone_offset,
+			 void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	struct btrfs_ioctl_clone_range_args clone_args;
+	struct subvol_info *si = NULL;
+	char *full_path = path_cat(r->full_subvol_path, path);
+	char *subvol_path = NULL;
+	char *full_clone_path = NULL;
+	int clone_fd = -1;
+
+	ret = open_inode_for_write(r, full_path);
+	if (ret < 0)
+		goto out;
+
+	si = subvol_uuid_search(&r->sus, 0, clone_uuid, clone_ctransid, NULL,
+			subvol_search_by_received_uuid);
+	if (!si) {
+		if (memcmp(clone_uuid, r->cur_subvol->received_uuid,
+				BTRFS_FSID_SIZE) == 0) {
+			/* TODO check generation of extent */
+			subvol_path = strdup(r->cur_subvol->path);
+		} else {
+			ret = -ENOENT;
+			fprintf(stderr, "ERROR: did not find source subvol.\n");
+			goto out;
+		}
+	} else {
+		/*if (rs_args.ctransid > rs_args.rtransid) {
+			if (!r->force) {
+				ret = -EINVAL;
+				fprintf(stderr, "ERROR: subvolume %s was "
+						"modified after it was "
+						"received.\n",
+						r->subvol_parent_name);
+				goto out;
+			} else {
+				fprintf(stderr, "WARNING: subvolume %s was "
+						"modified after it was "
+						"received.\n",
+						r->subvol_parent_name);
+			}
+		}*/
+		subvol_path = strdup(si->path);
+	}
+
+	full_clone_path = path_cat3(r->root_path, subvol_path, clone_path);
+
+	clone_fd = open(full_clone_path, O_RDONLY | O_NOATIME);
+	if (clone_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to open %s. %s\n",
+				full_clone_path, strerror(-ret));
+		goto out;
+	}
+
+	clone_args.src_fd = clone_fd;
+	clone_args.src_offset = clone_offset;
+	clone_args.src_length = len;
+	clone_args.dest_offset = offset;
+	ret = ioctl(r->write_fd, BTRFS_IOC_CLONE_RANGE, &clone_args);
+	if (ret) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to clone extents to %s\n%s\n",
+				path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	free(full_clone_path);
+	free(subvol_path);
+	if (clone_fd != -1)
+		close(clone_fd);
+	return ret;
+}
+
+
+static int process_set_xattr(const char *path, const char *name,
+			     const void *data, int len, void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1) {
+		fprintf(stderr, "set_xattr %s - name=%s data_len=%d "
+				"data=%.*s\n", path, name, len,
+				len, (char*)data);
+	}
+
+	ret = lsetxattr(full_path, name, data, len, 0);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: lsetxattr %s %s=%.*s failed. %s\n",
+				path, name, len, (char*)data, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_remove_xattr(const char *path, const char *name, void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1) {
+		fprintf(stderr, "remove_xattr %s - name=%s\n",
+				path, name);
+	}
+
+	ret = lremovexattr(full_path, name);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: lremovexattr %s %s failed. %s\n",
+				path, name, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_truncate(const char *path, u64 size, void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "truncate %s size=%llu\n", path, size);
+
+	ret = truncate(full_path, size);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: truncate %s failed. %s\n",
+				path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_chmod(const char *path, u64 mode, void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "chmod %s - mode=0%o\n", path, (int)mode);
+
+	ret = chmod(full_path, mode);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: chmod %s failed. %s\n",
+				path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_chown(const char *path, u64 uid, u64 gid, void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "chown %s - uid=%llu, gid=%llu\n", path,
+				uid, gid);
+
+	ret = chown(full_path, uid, gid);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: chown %s failed. %s\n",
+				path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+static int process_utimes(const char *path, struct timespec *at,
+			  struct timespec *mt, struct timespec *ct,
+			  void *user)
+{
+	int ret = 0;
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+	struct timespec tv[2];
+
+	if (g_verbose >= 1)
+		fprintf(stderr, "utimes %s\n", path);
+
+	tv[0] = *at;
+	tv[1] = *mt;
+	ret = utimensat(-1, full_path, tv, AT_SYMLINK_NOFOLLOW);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: utimes %s failed. %s\n",
+				path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	free(full_path);
+	return ret;
+}
+
+
+struct btrfs_send_ops send_ops = {
+	.subvol = process_subvol,
+	.snapshot = process_snapshot,
+	.mkfile = process_mkfile,
+	.mkdir = process_mkdir,
+	.mknod = process_mknod,
+	.mkfifo = process_mkfifo,
+	.mksock = process_mksock,
+	.symlink = process_symlink,
+	.rename = process_rename,
+	.link = process_link,
+	.unlink = process_unlink,
+	.rmdir = process_rmdir,
+	.write = process_write,
+	.clone = process_clone,
+	.set_xattr = process_set_xattr,
+	.remove_xattr = process_remove_xattr,
+	.truncate = process_truncate,
+	.chmod = process_chmod,
+	.chown = process_chown,
+	.utimes = process_utimes,
+};
+
+int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
+{
+	int ret;
+	int end = 0;
+
+	r->root_path = strdup(tomnt);
+	r->mnt_fd = open(tomnt, O_RDONLY | O_NOATIME);
+	if (r->mnt_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to open %s. %s\n", tomnt,
+				strerror(-ret));
+		goto out;
+	}
+
+	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
+	if (ret < 0)
+		return ret;
+
+	r->write_fd = -1;
+
+	while (!end) {
+		ret = btrfs_read_and_process_send_stream(r_fd, &send_ops, r);
+		if (ret < 0)
+			goto out;
+		if (ret)
+			end = 1;
+
+		ret = close_inode_for_write(r);
+		if (ret < 0)
+			goto out;
+		ret = finish_subvol(r);
+		if (ret < 0)
+			goto out;
+	}
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static int do_cmd_receive(int argc, char **argv)
+{
+	int c;
+	char *tomnt = NULL;
+	char *fromfile = NULL;
+	struct btrfs_receive r;
+	int receive_fd = fileno(stdin);
+
+	int ret;
+
+	memset(&r, 0, sizeof(r));
+
+	while ((c = getopt(argc, argv, "vf:")) != -1) {
+		switch (c) {
+		case 'v':
+			g_verbose++;
+			break;
+		case 'f':
+			fromfile = optarg;
+			break;
+		case '?':
+		default:
+			fprintf(stderr, "ERROR: receive args invalid.\n");
+			return 1;
+		}
+	}
+
+	if (optind + 1 != argc) {
+		fprintf(stderr, "ERROR: receive needs path to subvolume\n");
+		return 1;
+	}
+
+	tomnt = argv[optind];
+
+	if (fromfile) {
+		receive_fd = open(fromfile, O_RDONLY | O_NOATIME);
+		if (receive_fd < 0) {
+			fprintf(stderr, "ERROR: failed to open %s\n", fromfile);
+			return -errno;
+		}
+	}
+
+	ret = do_receive(&r, tomnt, receive_fd);
+
+	return ret;
+}
+
+static const char * const receive_cmd_group_usage[] = {
+	"btrfs receive <command> <args>",
+	NULL
+};
+
+static const char * const cmd_receive_usage[] = {
+	"btrfs receive [-v] [-i <infile>] <mount>",
+	"Receive subvolumes from stdin.",
+	"Receives one or more subvolumes that were previously ",
+	"sent with btrfs send. The received subvolumes are stored",
+	"into <mount>.",
+	"btrfs receive will fail in case a receiving subvolume",
+	"already exists. It will also fail in case a previously",
+	"received subvolume was changed after it was received.",
+	"After receiving a subvolume, it is immediately set to",
+	"read only.\n",
+	"-v               Enable verbose debug output. Each",
+	"                 occurrency of this option increases the",
+	"                 verbose level more.",
+	"-f <infile>      By default, btrfs receive uses stdin",
+	"                 to receive the subvolumes. Use this",
+	"                 option to specify a file to use instead.",
+	NULL
+};
+
+const struct cmd_group receive_cmd_group = {
+	receive_cmd_group_usage, NULL, {
+		{ "receive", do_cmd_receive, cmd_receive_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 },
+        },
+};
+
+int cmd_receive(int argc, char **argv)
+{
+	return do_cmd_receive(argc, argv);
+}
diff --git a/cmds-send.c b/cmds-send.c
new file mode 100644
index 0000000..539964c
--- /dev/null
+++ b/cmds-send.c
@@ -0,0 +1,677 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
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
+#define _GNU_SOURCE
+
+#include <unistd.h>
+#include <stdint.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <math.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+
+#include <uuid/uuid.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+#include "commands.h"
+#include "list.h"
+
+#include "send.h"
+#include "send-utils.h"
+
+static int g_verbose = 0;
+
+struct btrfs_send {
+	int send_fd;
+	int dump_fd;
+	int mnt_fd;
+
+	u64 *clone_sources;
+	u64 clone_sources_count;
+
+	char *root_path;
+	struct subvol_uuid_search sus;
+};
+
+int find_mount_root(const char *path, char **mount_root)
+{
+	int ret;
+	char cur[BTRFS_PATH_NAME_MAX];
+	char fsid[BTRFS_FSID_SIZE];
+	int fd;
+	struct stat st;
+	int pos;
+	char *tmp;
+
+	struct btrfs_ioctl_fs_info_args args;
+
+	fd = open(path, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	ret = fstat(fd, &st);
+	if (fd < 0) {
+		ret = -errno;
+		goto out;
+	}
+	if (!S_ISDIR(st.st_mode)) {
+		ret = -ENOTDIR;
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
+	if (fd < 0) {
+		ret = -errno;
+		goto out;
+	}
+	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
+	close(fd);
+	fd = -1;
+
+	strcpy(cur, path);
+	while (1) {
+		tmp = strrchr(cur, '/');
+		if (!tmp)
+			break;
+		if (tmp == cur)
+			break;
+		pos = tmp - cur;
+		cur[pos] = 0;
+
+		fd = open(cur, O_RDONLY | O_NOATIME);
+		if (fd < 0) {
+			ret = -errno;
+			goto out;
+		}
+
+		ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
+		close(fd);
+		fd = -1;
+		if (ret < 0) {
+			cur[pos] = '/';
+			break;
+		}
+		if (memcmp(fsid, args.fsid, BTRFS_FSID_SIZE) != 0) {
+			cur[pos] = '/';
+			break;
+		}
+	}
+
+	ret = 0;
+	*mount_root = realpath(cur, NULL);
+
+out:
+	if (fd != -1)
+		close(fd);
+	return ret;
+}
+
+static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
+{
+	struct subvol_info *si;
+
+	si = subvol_uuid_search(&s->sus, 0, NULL, 0, path,
+			subvol_search_by_path);
+	if (!si)
+		return -ENOENT;
+	*root_id = si->root_id;
+	return 0;
+}
+
+static struct subvol_info *get_parent(struct btrfs_send *s, u64 root_id)
+{
+	struct subvol_info *si;
+
+	si = subvol_uuid_search(&s->sus, root_id, NULL, 0, NULL,
+			subvol_search_by_root_id);
+	if (!si)
+		return NULL;
+
+	si = subvol_uuid_search(&s->sus, 0, si->parent_uuid, 0, NULL,
+			subvol_search_by_uuid);
+	if (!si)
+		return NULL;
+	return si;
+}
+
+static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
+{
+	int ret;
+	struct subvol_info *parent;
+	struct subvol_info *parent2;
+	struct subvol_info *best_parent = NULL;
+	__s64 tmp;
+	u64 best_diff = (u64)-1;
+	int i;
+
+	parent = get_parent(s, root_id);
+	if (!parent) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	for (i = 0; i < s->clone_sources_count; i++) {
+		if (s->clone_sources[i] == parent->root_id) {
+			best_parent = parent;
+			goto out_found;
+		}
+	}
+
+	for (i = 0; i < s->clone_sources_count; i++) {
+		parent2 = get_parent(s, s->clone_sources[i]);
+		if (parent2 != parent)
+			continue;
+
+		parent2 = subvol_uuid_search(&s->sus, s->clone_sources[i], NULL,
+				0, NULL, subvol_search_by_root_id);
+
+		tmp = parent2->ctransid - parent->ctransid;
+		if (tmp < 0)
+			tmp *= -1;
+		if (tmp < best_diff) {
+			best_parent = parent;
+			best_diff = tmp;
+		}
+	}
+
+	if (!best_parent) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+out_found:
+	*found = best_parent->root_id;
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static void add_clone_source(struct btrfs_send *s, u64 root_id)
+{
+	s->clone_sources = realloc(s->clone_sources,
+		sizeof(*s->clone_sources) * (s->clone_sources_count + 1));
+	s->clone_sources[s->clone_sources_count++] = root_id;
+}
+
+static int write_buf(int fd, const void *buf, int size)
+{
+	int ret;
+	int pos = 0;
+
+	while (pos < size) {
+		ret = write(fd, (char*)buf + pos, size - pos);
+		if (ret < 0) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: failed to dump stream. %s",
+					strerror(-ret));
+			goto out;
+		}
+		if (!ret) {
+			ret = -EIO;
+			fprintf(stderr, "ERROR: failed to dump stream. %s",
+					strerror(-ret));
+			goto out;
+		}
+		pos += ret;
+	}
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static void *dump_thread(void *arg_)
+{
+	int ret;
+	struct btrfs_send *s = (struct btrfs_send*)arg_;
+	char buf[4096];
+	int readed;
+
+	while (1) {
+		readed = read(s->send_fd, buf, sizeof(buf));
+		if (readed < 0) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: failed to read stream from "
+					"kernel. %s\n", strerror(-ret));
+			goto out;
+		}
+		if (!readed) {
+			ret = 0;
+			goto out;
+		}
+		ret = write_buf(s->dump_fd, buf, readed);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	if (ret < 0) {
+		exit(-ret);
+	}
+
+	return ERR_PTR(ret);
+}
+
+static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
+{
+	int ret;
+	pthread_t t_read;
+	pthread_attr_t t_attr;
+	struct btrfs_ioctl_send_args io_send;
+	struct subvol_info *si;
+	void *t_err = NULL;
+	int subvol_fd = -1;
+	int pipefd[2];
+
+	si = subvol_uuid_search(&send->sus, root_id, NULL, 0, NULL,
+			subvol_search_by_root_id);
+	if (!si) {
+		ret = -ENOENT;
+		fprintf(stderr, "ERROR: could not find subvol info for %llu",
+				root_id);
+		goto out;
+	}
+
+	subvol_fd = openat(send->mnt_fd, si->path, O_RDONLY | O_NOATIME);
+	if (subvol_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n", si->path,
+				strerror(-ret));
+		goto out;
+	}
+
+	ret = pthread_attr_init(&t_attr);
+
+	ret = pipe(pipefd);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: pipe failed. %s\n", strerror(-ret));
+		goto out;
+	}
+
+	io_send.send_fd = pipefd[1];
+	send->send_fd = pipefd[0];
+
+	if (!ret)
+		ret = pthread_create(&t_read, &t_attr, dump_thread,
+					send);
+	if (ret) {
+		ret = -ret;
+		fprintf(stderr, "ERROR: thread setup failed: %s\n",
+			strerror(-ret));
+		goto out;
+	}
+
+	io_send.clone_sources = (__u64*)send->clone_sources;
+	io_send.clone_sources_count = send->clone_sources_count;
+	io_send.parent_root = parent_root;
+	ret = ioctl(subvol_fd, BTRFS_IOC_SEND, &io_send);
+	if (ret) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: send ioctl failed with %d: %s\n", ret,
+			strerror(-ret));
+		goto out;
+	}
+	if (g_verbose > 0)
+		fprintf(stderr, "BTRFS_IOC_SEND returned %d\n", ret);
+
+	if (g_verbose > 0)
+		fprintf(stderr, "joining genl thread\n");
+
+	close(pipefd[1]);
+	pipefd[1] = 0;
+
+	ret = pthread_join(t_read, &t_err);
+	if (ret) {
+		ret = -ret;
+		fprintf(stderr, "ERROR: pthread_join failed: %s\n",
+			strerror(-ret));
+		goto out;
+	}
+	if (t_err) {
+		ret = (long int)t_err;
+		fprintf(stderr, "ERROR: failed to process send stream, ret=%ld "
+			"(%s)\n", (long int)t_err, strerror(-ret));
+		goto out;
+	}
+
+	pthread_attr_destroy(&t_attr);
+
+	ret = 0;
+
+out:
+	if (subvol_fd != -1)
+		close(subvol_fd);
+	if (pipefd[0])
+		close(pipefd[0]);
+	if (pipefd[1])
+		close(pipefd[1]);
+	return ret;
+}
+
+static const char *get_subvol_name(struct btrfs_send *s, const char *full_path)
+{
+	return full_path + strlen(s->root_path) + 1;
+}
+
+static int init_root_path(struct btrfs_send *s, const char *subvol)
+{
+	int ret = 0;
+
+	if (s->root_path)
+		goto out;
+
+	ret = find_mount_root(subvol, &s->root_path);
+	if (ret < 0) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: failed to determine mount point "
+				"for %s\n", subvol);
+		goto out;
+	}
+
+	s->mnt_fd = open(s->root_path, O_RDONLY | O_NOATIME);
+	if (s->mnt_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: can't open '%s': %s\n", s->root_path,
+			strerror(-ret));
+		goto out;
+	}
+
+	ret = subvol_uuid_search_init(s->mnt_fd, &s->sus);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: failed to initialize subvol search. "
+				"%s\n", strerror(-ret));
+		goto out;
+	}
+
+out:
+	return ret;
+
+}
+
+static int is_subvol_ro(struct btrfs_send *s, char *subvol)
+{
+	int ret;
+	u64 flags;
+	int fd = -1;
+
+	fd = openat(s->mnt_fd, subvol, O_RDONLY | O_NOATIME);
+	if (fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to open %s. %s\n",
+				subvol, strerror(-ret));
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to get flags for subvolume. "
+				"%s\n", strerror(-ret));
+		goto out;
+	}
+
+	if (flags & BTRFS_SUBVOL_RDONLY)
+		ret = 1;
+	else
+		ret = 0;
+
+out:
+	if (fd != -1)
+		close(fd);
+
+	return ret;
+}
+
+int cmd_send_start(int argc, char **argv)
+{
+	char *subvol = NULL;
+	char c;
+	int ret;
+	char *outname = NULL;
+	struct btrfs_send send;
+	u32 i;
+	char *mount_root = NULL;
+	char *snapshot_parent = NULL;
+	u64 root_id;
+	u64 parent_root_id = 0;
+
+	memset(&send, 0, sizeof(send));
+	send.dump_fd = fileno(stdout);
+
+	while ((c = getopt(argc, argv, "vf:i:p:")) != -1) {
+		switch (c) {
+		case 'v':
+			g_verbose++;
+			break;
+		case 'i': {
+			subvol = realpath(optarg, NULL);
+			if (!subvol) {
+				ret = -errno;
+				fprintf(stderr, "ERROR: realpath %s failed. "
+						"%s\n", optarg, strerror(-ret));
+				goto out;
+			}
+
+			ret = init_root_path(&send, subvol);
+			if (ret < 0)
+				goto out;
+
+			ret = get_root_id(&send, get_subvol_name(&send, subvol),
+					&root_id);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: could not resolve "
+						"root_id for %s\n", subvol);
+				goto out;
+			}
+			add_clone_source(&send, root_id);
+			free(subvol);
+			break;
+		}
+		case 'f':
+			outname = optarg;
+			break;
+		case 'p':
+			snapshot_parent = realpath(optarg, NULL);
+			if (!snapshot_parent) {
+				ret = -errno;
+				fprintf(stderr, "ERROR: realpath %s failed. "
+						"%s\n", optarg, strerror(-ret));
+				goto out;
+			}
+			break;
+		case '?':
+		default:
+			fprintf(stderr, "ERROR: send args invalid.\n");
+			return 1;
+		}
+	}
+
+	if (optind == argc) {
+		fprintf(stderr, "ERROR: send needs path to snapshot\n");
+		return 1;
+	}
+
+	if (outname != NULL) {
+		send.dump_fd = creat(outname, 0600);
+		if (send.dump_fd == -1) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: can't create '%s': %s\n",
+					outname, strerror(-ret));
+			goto out;
+		}
+	}
+
+	/* use first send subvol to determine mount_root */
+	subvol = argv[optind];
+
+	ret = init_root_path(&send, subvol);
+	if (ret < 0)
+		goto out;
+
+	if (snapshot_parent != NULL) {
+		ret = get_root_id(&send,
+				get_subvol_name(&send, snapshot_parent),
+				&parent_root_id);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: could not resolve root_id "
+					"for %s\n", snapshot_parent);
+			goto out;
+		}
+
+		add_clone_source(&send, parent_root_id);
+	}
+
+	for (i = optind; i < argc; i++) {
+		subvol = argv[i];
+
+		ret = find_mount_root(subvol, &mount_root);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+					"%s\n", subvol,
+				strerror(-ret));
+			goto out;
+		}
+		if (strcmp(send.root_path, mount_root) != 0) {
+			ret = -EINVAL;
+			fprintf(stderr, "ERROR: all subvols must be from the "
+					"same fs.\n");
+			goto out;
+		}
+		free(mount_root);
+
+		ret = is_subvol_ro(&send, subvol);
+		if (ret < 0)
+			goto out;
+		if (!ret) {
+			ret = -EINVAL;
+			fprintf(stderr, "ERROR: %s is not read-only.\n",
+					subvol);
+			goto out;
+		}
+	}
+
+	for (i = optind; i < argc; i++) {
+		subvol = argv[i];
+
+		fprintf(stderr, "At subvol %s\n", subvol);
+
+		subvol = realpath(subvol, NULL);
+		if (!subvol) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: realpath %s failed. "
+					"%s\n", argv[i], strerror(-ret));
+			goto out;
+		}
+
+		ret = get_root_id(&send, get_subvol_name(&send, subvol),
+				&root_id);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: could not resolve root_id "
+					"for %s\n", subvol);
+			goto out;
+		}
+		free(subvol);
+
+		if (!parent_root_id) {
+			ret = find_good_parent(&send, root_id, &parent_root_id);
+			if (ret < 0)
+				parent_root_id = 0;
+		}
+
+		ret = is_subvol_ro(&send, subvol);
+		if (ret < 0)
+			goto out;
+		if (!ret) {
+			ret = -EINVAL;
+			fprintf(stderr, "ERROR: %s is not read-only.\n",
+					subvol);
+			goto out;
+		}
+
+		ret = do_send(&send, root_id, parent_root_id);
+		if (ret < 0)
+			goto out;
+
+		/* done with this subvol, so add it to the clone sources */
+		add_clone_source(&send, root_id);
+
+		parent_root_id = 0;
+	}
+
+	ret = 0;
+
+out:
+	if (send.mnt_fd >= 0)
+		close(send.mnt_fd);
+	return ret;
+}
+
+static const char * const send_cmd_group_usage[] = {
+	"btrfs send <command> <args>",
+	NULL
+};
+
+static const char * const cmd_send_usage[] = {
+	"btrfs send [-v] [-i <subvol>] [-p <parent>] <subvol>",
+	"Send the subvolume to stdout.",
+	"Sends the subvolume specified by <subvol> to stdout.",
+	"By default, this will send the whole subvolume. To do",
+	"an incremental send, one or multiple '-i <clone_source>'",
+	"arguments have to be specified. A 'clone source' is",
+	"a subvolume that is known to exist on the receiving",
+	"side in exactly the same state as on the sending side.\n",
+	"Normally, a good snapshot parent is searched automatically",
+	"in the list of 'clone sources'. To override this, use",
+	"'-p <parent>' to manually specify a snapshot parent.",
+	"A manually specified snapshot parent is also regarded",
+	"as 'clone source'.\n",
+	"-v               Enable verbose debug output. Each",
+	"                 occurrency of this option increases the",
+	"                 verbose level more.",
+	"-i <subvol>      Informs btrfs send that this subvolume,",
+	"                 can be taken as 'clone source'. This can",
+	"                 be used for incremental sends.",
+	"-p <subvol>      Disable automatic snaphot parent",
+	"                 determination and use <subvol> as parent.",
+	"                 This subvolume is also added to the list",
+	"                 of 'clone sources' (see -i).",
+	"-f <outfile>     Output is normally written to stdout.",
+	"                 To write to a file, use this option.",
+	"                 An alternative would be to use pipes.",
+	NULL
+};
+
+const struct cmd_group send_cmd_group = {
+	send_cmd_group_usage, NULL, {
+		{ "send", cmd_send_start, cmd_send_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 },
+        },
+};
+
+int cmd_send(int argc, char **argv)
+{
+	return cmd_send_start(argc, argv);
+}
diff --git a/commands.h b/commands.h
index a303a50..1ece87a 100644
--- a/commands.h
+++ b/commands.h
@@ -88,6 +88,8 @@ extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
+extern const struct cmd_group send_cmd_group;
+extern const struct cmd_group receive_cmd_group;
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -95,3 +97,5 @@ int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
+int cmd_send(int argc, char **argv);
+int cmd_receive(int argc, char **argv);
diff --git a/send-stream.c b/send-stream.c
new file mode 100644
index 0000000..55fa728
--- /dev/null
+++ b/send-stream.c
@@ -0,0 +1,480 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
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
+#include <uuid/uuid.h>
+#include <unistd.h>
+
+#include "send.h"
+#include "send-stream.h"
+#include "crc32c.h"
+
+struct btrfs_send_stream {
+	int fd;
+	char read_buf[BTRFS_SEND_BUF_SIZE];
+
+	int cmd;
+	struct btrfs_cmd_header *cmd_hdr;
+	struct btrfs_tlv_header *cmd_attrs[BTRFS_SEND_A_MAX + 1];
+	u32 version;
+
+	struct btrfs_send_ops *ops;
+	void *user;
+};
+
+static int read_buf(struct btrfs_send_stream *s, void *buf, int len)
+{
+	int ret;
+	int pos = 0;
+
+	while (pos < len) {
+		ret = read(s->fd, (char*)buf + pos, len - pos);
+		if (ret < 0) {
+			ret = -errno;
+			fprintf(stderr, "ERROR: read from stream failed. %s\n",
+					strerror(-ret));
+			goto out;
+		}
+		if (ret == 0) {
+			ret = 1;
+			goto out;
+		}
+		pos += ret;
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+/*
+ * Reads a single command from kernel space and decodes the TLV's into
+ * s->cmd_attrs
+ */
+static int read_cmd(struct btrfs_send_stream *s)
+{
+	int ret;
+	int cmd;
+	int cmd_len;
+	int tlv_type;
+	int tlv_len;
+	char *data;
+	int pos;
+	struct btrfs_tlv_header *tlv_hdr;
+	u32 crc;
+	u32 crc2;
+
+	memset(s->cmd_attrs, 0, sizeof(s->cmd_attrs));
+
+	ret = read_buf(s, s->read_buf, sizeof(*s->cmd_hdr));
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: unexpected EOF in stream.\n");
+		goto out;
+	}
+
+	s->cmd_hdr = (struct btrfs_cmd_header *)s->read_buf;
+	cmd = le16_to_cpu(s->cmd_hdr->cmd);
+	cmd_len = le32_to_cpu(s->cmd_hdr->len);
+
+	data = s->read_buf + sizeof(*s->cmd_hdr);
+	ret = read_buf(s, data, cmd_len);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: unexpected EOF in stream.\n");
+		goto out;
+	}
+
+	crc = le32_to_cpu(s->cmd_hdr->crc);
+	s->cmd_hdr->crc = 0;
+
+	crc2 = crc32c(0, (unsigned char*)s->read_buf,
+			sizeof(*s->cmd_hdr) + cmd_len);
+
+	if (crc != crc2) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: crc32 mismatch in command.\n");
+		goto out;
+	}
+
+	pos = 0;
+	while (pos < cmd_len) {
+		tlv_hdr = (struct btrfs_tlv_header *)data;
+		tlv_type = le16_to_cpu(tlv_hdr->tlv_type);
+		tlv_len = le16_to_cpu(tlv_hdr->tlv_len);
+
+		if (tlv_type <= 0 || tlv_type > BTRFS_SEND_A_MAX ||
+		    tlv_len < 0 || tlv_len > BTRFS_SEND_BUF_SIZE) {
+			fprintf(stderr, "ERROR: invalid tlv in cmd. "
+					"tlv_type = %d, tlv_len = %d\n",
+					tlv_type, tlv_len);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		s->cmd_attrs[tlv_type] = tlv_hdr;
+
+		data += sizeof(*tlv_hdr) + tlv_len;
+		pos += sizeof(*tlv_hdr) + tlv_len;
+	}
+
+	s->cmd = cmd;
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static int tlv_get(struct btrfs_send_stream *s, int attr, void **data, int *len)
+{
+	int ret;
+	struct btrfs_tlv_header *h;
+
+	if (attr <= 0 || attr > BTRFS_SEND_A_MAX) {
+		fprintf(stderr, "ERROR: invalid attribute requested. "
+				"attr = %d\n",
+				attr);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	h = s->cmd_attrs[attr];
+	if (!h) {
+		fprintf(stderr, "ERROR: attribute %d requested "
+				"but not present.\n", attr);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	*len = le16_to_cpu(h->tlv_len);
+	*data = h + 1;
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+#define __TLV_GOTO_FAIL(expr) \
+	if ((ret = expr) < 0) \
+		goto tlv_get_failed;
+
+#define __TLV_DO_WHILE_GOTO_FAIL(expr) \
+	do { \
+		__TLV_GOTO_FAIL(expr) \
+	} while (0)
+
+
+#define TLV_GET(s, attr, data, len) \
+	__TLV_DO_WHILE_GOTO_FAIL(tlv_get(s, attr, data, len))
+
+#define TLV_CHECK_LEN(expected, got) \
+	do { \
+		if (expected != got) { \
+			fprintf(stderr, "ERROR: invalid size for attribute. " \
+					"expected = %d, got = %d\n", \
+					(int)expected, (int)got); \
+			ret = -EINVAL; \
+			goto tlv_get_failed; \
+		} \
+	} while (0)
+
+#define TLV_GET_INT(s, attr, bits, v) \
+	do { \
+		__le##bits *__tmp; \
+		int __len; \
+		TLV_GET(s, attr, (void**)&__tmp, &__len); \
+		TLV_CHECK_LEN(sizeof(*__tmp), __len); \
+		*v = le##bits##_to_cpu(*__tmp); \
+	} while (0)
+
+#define TLV_GET_U8(s, attr, v) TLV_GET_INT(s, attr, 8, v)
+#define TLV_GET_U16(s, attr, v) TLV_GET_INT(s, attr, 16, v)
+#define TLV_GET_U32(s, attr, v) TLV_GET_INT(s, attr, 32, v)
+#define TLV_GET_U64(s, attr, v) TLV_GET_INT(s, attr, 64, v)
+
+static int tlv_get_string(struct btrfs_send_stream *s, int attr, char **str)
+{
+	int ret;
+	void *data;
+	int len;
+
+	TLV_GET(s, attr, &data, &len);
+
+	*str = malloc(len + 1);
+	if (!*str)
+		return -ENOMEM;
+
+	memcpy(*str, data, len);
+	(*str)[len] = 0;
+	ret = 0;
+
+tlv_get_failed:
+	return ret;
+}
+#define TLV_GET_STRING(s, attr, str) \
+	__TLV_DO_WHILE_GOTO_FAIL(tlv_get_string(s, attr, str))
+
+static int tlv_get_timespec(struct btrfs_send_stream *s,
+			    int attr, struct timespec *ts)
+{
+	int ret;
+	int len;
+	struct btrfs_timespec *bts;
+
+	TLV_GET(s, attr, (void**)&bts, &len);
+	TLV_CHECK_LEN(sizeof(*bts), len);
+
+	ts->tv_sec = le64_to_cpu(bts->sec);
+	ts->tv_nsec = le32_to_cpu(bts->nsec);
+	ret = 0;
+
+tlv_get_failed:
+	return ret;
+}
+#define TLV_GET_TIMESPEC(s, attr, ts) \
+	__TLV_DO_WHILE_GOTO_FAIL(tlv_get_timespec(s, attr, ts))
+
+static int tlv_get_uuid(struct btrfs_send_stream *s, int attr, u8 *uuid)
+{
+	int ret;
+	int len;
+	void *data;
+
+	TLV_GET(s, attr, &data, &len);
+	TLV_CHECK_LEN(BTRFS_UUID_SIZE, len);
+	memcpy(uuid, data, BTRFS_UUID_SIZE);
+
+	ret = 0;
+
+tlv_get_failed:
+	return ret;
+}
+#define TLV_GET_UUID(s, attr, uuid) \
+	__TLV_DO_WHILE_GOTO_FAIL(tlv_get_uuid(s, attr, uuid))
+
+static int read_and_process_cmd(struct btrfs_send_stream *s)
+{
+	int ret;
+	char *path = NULL;
+	char *path_to = NULL;
+	char *clone_path = NULL;
+	char *xattr_name = NULL;
+	void *xattr_data = NULL;
+	void *data = NULL;
+	struct timespec at;
+	struct timespec ct;
+	struct timespec mt;
+	u8 uuid[BTRFS_UUID_SIZE];
+	u8 clone_uuid[BTRFS_UUID_SIZE];
+	u64 tmp;
+	u64 tmp2;
+	u64 ctransid;
+	u64 clone_ctransid;
+	u64 mode;
+	u64 dev;
+	u64 clone_offset;
+	u64 offset;
+	int len;
+	int xattr_len;
+
+	ret = read_cmd(s);
+	if (ret)
+		goto out;
+
+	switch (s->cmd) {
+	case BTRFS_SEND_C_SUBVOL:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_UUID(s, BTRFS_SEND_A_UUID, uuid);
+		TLV_GET_U64(s, BTRFS_SEND_A_CTRANSID, &ctransid);
+		ret = s->ops->subvol(path, uuid, ctransid, s->user);
+		break;
+	case BTRFS_SEND_C_SNAPSHOT:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_UUID(s, BTRFS_SEND_A_UUID, uuid);
+		TLV_GET_U64(s, BTRFS_SEND_A_CTRANSID, &ctransid);
+		TLV_GET_UUID(s, BTRFS_SEND_A_CLONE_UUID, clone_uuid);
+		TLV_GET_U64(s, BTRFS_SEND_A_CLONE_CTRANSID, &clone_ctransid);
+		ret = s->ops->snapshot(path, uuid, ctransid, clone_uuid,
+				clone_ctransid, s->user);
+		break;
+	case BTRFS_SEND_C_MKFILE:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		ret = s->ops->mkfile(path, s->user);
+		break;
+	case BTRFS_SEND_C_MKDIR:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		ret = s->ops->mkdir(path, s->user);
+		break;
+	case BTRFS_SEND_C_MKNOD:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_MODE, &mode);
+		TLV_GET_U64(s, BTRFS_SEND_A_RDEV, &dev);
+		ret = s->ops->mknod(path, mode, dev, s->user);
+		break;
+	case BTRFS_SEND_C_MKFIFO:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		ret = s->ops->mkfifo(path, s->user);
+		break;
+	case BTRFS_SEND_C_MKSOCK:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		ret = s->ops->mksock(path, s->user);
+		break;
+	case BTRFS_SEND_C_SYMLINK:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH_LINK, &path_to);
+		ret = s->ops->symlink(path, path_to, s->user);
+		break;
+	case BTRFS_SEND_C_RENAME:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH_TO, &path_to);
+		ret = s->ops->rename(path, path_to, s->user);
+		break;
+	case BTRFS_SEND_C_LINK:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH_LINK, &path_to);
+		ret = s->ops->link(path, path_to, s->user);
+		break;
+	case BTRFS_SEND_C_UNLINK:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		ret = s->ops->unlink(path, s->user);
+		break;
+	case BTRFS_SEND_C_RMDIR:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		ret = s->ops->rmdir(path, s->user);
+		break;
+	case BTRFS_SEND_C_WRITE:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
+		TLV_GET(s, BTRFS_SEND_A_DATA, &data, &len);
+		ret = s->ops->write(path, data, offset, len, s->user);
+		break;
+	case BTRFS_SEND_C_CLONE:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
+		TLV_GET_U64(s, BTRFS_SEND_A_CLONE_LEN, &len);
+		TLV_GET_UUID(s, BTRFS_SEND_A_CLONE_UUID, clone_uuid);
+		TLV_GET_U64(s, BTRFS_SEND_A_CLONE_CTRANSID, &clone_ctransid);
+		TLV_GET_STRING(s, BTRFS_SEND_A_CLONE_PATH, &clone_path);
+		TLV_GET_U64(s, BTRFS_SEND_A_CLONE_OFFSET, &clone_offset);
+		ret = s->ops->clone(path, offset, len, clone_uuid,
+				clone_ctransid, clone_path, clone_offset,
+				s->user);
+		break;
+	case BTRFS_SEND_C_SET_XATTR:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_STRING(s, BTRFS_SEND_A_XATTR_NAME, &xattr_name);
+		TLV_GET(s, BTRFS_SEND_A_XATTR_DATA, &xattr_data, &xattr_len);
+		ret = s->ops->set_xattr(path, xattr_name, xattr_data,
+				xattr_len, s->user);
+		break;
+	case BTRFS_SEND_C_REMOVE_XATTR:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_STRING(s, BTRFS_SEND_A_XATTR_NAME, &xattr_name);
+		ret = s->ops->remove_xattr(path, xattr_name, s->user);
+		break;
+	case BTRFS_SEND_C_TRUNCATE:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &tmp);
+		ret = s->ops->truncate(path, tmp, s->user);
+		break;
+	case BTRFS_SEND_C_CHMOD:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_MODE, &tmp);
+		ret = s->ops->chmod(path, tmp, s->user);
+		break;
+	case BTRFS_SEND_C_CHOWN:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_UID, &tmp);
+		TLV_GET_U64(s, BTRFS_SEND_A_GID, &tmp2);
+		ret = s->ops->chown(path, tmp, tmp2, s->user);
+		break;
+	case BTRFS_SEND_C_UTIMES:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		if (strstr(path, ".bak_1.log")) {
+			ret = 0;
+		}
+		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_ATIME, &at);
+		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_MTIME, &mt);
+		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_CTIME, &ct);
+		ret = s->ops->utimes(path, &at, &mt, &ct, s->user);
+		break;
+	case BTRFS_SEND_C_END:
+		ret = 1;
+		break;
+	}
+
+tlv_get_failed:
+out:
+	free(path);
+	free(path_to);
+	free(clone_path);
+	free(xattr_name);
+	return ret;
+}
+
+int btrfs_read_and_process_send_stream(int fd,
+				       struct btrfs_send_ops *ops, void *user)
+{
+	int ret;
+	struct btrfs_send_stream s;
+	struct btrfs_stream_header hdr;
+
+	s.fd = fd;
+	s.ops = ops;
+	s.user = user;
+
+	ret = read_buf(&s, &hdr, sizeof(hdr));
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		ret = 1;
+		goto out;
+	}
+
+	if (strcmp(hdr.magic, BTRFS_SEND_STREAM_MAGIC)) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: Unexpected header\n");
+		goto out;
+	}
+
+	s.version = le32_to_cpu(hdr.version);
+	if (s.version > BTRFS_SEND_STREAM_VERSION) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: Stream version %d not supported. "
+				"Please upgrade btrfs-progs\n", s.version);
+		goto out;
+	}
+
+	while (1) {
+		ret = read_and_process_cmd(&s);
+		if (ret < 0)
+			goto out;
+		if (ret) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
diff --git a/send-stream.h b/send-stream.h
new file mode 100644
index 0000000..b69b7f1
--- /dev/null
+++ b/send-stream.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
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
+#ifndef SEND_STREAM_H_
+#define SEND_STREAM_H_
+
+struct btrfs_send_ops {
+	int (*subvol)(const char *path, const u8 *uuid, u64 ctransid,
+		      void *user);
+	int (*snapshot)(const char *path, const u8 *uuid, u64 ctransid,
+			const u8 *parent_uuid, u64 parent_ctransid,
+			void *user);
+	int (*mkfile)(const char *path, void *user);
+	int (*mkdir)(const char *path, void *user);
+	int (*mknod)(const char *path, u64 mode, u64 dev, void *user);
+	int (*mkfifo)(const char *path, void *user);
+	int (*mksock)(const char *path, void *user);
+	int (*symlink)(const char *path, const char *lnk, void *user);
+	int (*rename)(const char *from, const char *to, void *user);
+	int (*link)(const char *path, const char *lnk, void *user);
+	int (*unlink)(const char *path, void *user);
+	int (*rmdir)(const char *path, void *user);
+	int (*write)(const char *path, const void *data, u64 offset, u64 len,
+		     void *user);
+	int (*clone)(const char *path, u64 offset, u64 len,
+		     const u8 *clone_uuid, u64 clone_ctransid,
+		     const char *clone_path, u64 clone_offset,
+		     void *user);
+	int (*set_xattr)(const char *path, const char *name, const void *data,
+			 int len, void *user);
+	int (*remove_xattr)(const char *path, const char *name, void *user);
+	int (*truncate)(const char *path, u64 size, void *user);
+	int (*chmod)(const char *path, u64 mode, void *user);
+	int (*chown)(const char *path, u64 uid, u64 gid, void *user);
+	int (*utimes)(const char *path, struct timespec *at,
+		      struct timespec *mt, struct timespec *ct,
+		      void *user);
+};
+
+int btrfs_read_and_process_send_stream(int fd,
+				       struct btrfs_send_ops *ops, void *user);
+
+
+#endif /* SEND_STREAM_H_ */
diff --git a/send-utils.c b/send-utils.c
new file mode 100644
index 0000000..059efd3
--- /dev/null
+++ b/send-utils.c
@@ -0,0 +1,337 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
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
+#include <sys/ioctl.h>
+
+#include "ctree.h"
+#include "send-utils.h"
+#include "ioctl.h"
+
+/* btrfs-list.c */
+char *path_for_root(int fd, u64 root);
+
+static struct rb_node *tree_insert(struct rb_root *root,
+				   struct subvol_info *si,
+				   enum subvol_search_type type)
+{
+	struct rb_node ** p = &root->rb_node;
+	struct rb_node * parent = NULL;
+	struct subvol_info *entry;
+	__s64 comp;
+
+	while(*p) {
+		parent = *p;
+		if (type == subvol_search_by_received_uuid) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_received_node);
+
+			comp = memcmp(entry->received_uuid, si->received_uuid,
+					BTRFS_UUID_SIZE);
+			if (!comp) {
+				if (entry->stransid < si->stransid)
+					comp = -1;
+				else if (entry->stransid > si->stransid)
+					comp = 1;
+				else
+					comp = 0;
+			}
+		} else if (type == subvol_search_by_uuid) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_local_node);
+			comp = memcmp(entry->uuid, si->uuid, BTRFS_UUID_SIZE);
+		} else if (type == subvol_search_by_root_id) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_root_id_node);
+			comp = entry->root_id - si->root_id;
+		} else if (type == subvol_search_by_path) {
+			entry = rb_entry(parent, struct subvol_info,
+					rb_path_node);
+			comp = strcmp(entry->path, si->path);
+		}
+
+		if (comp < 0)
+			p = &(*p)->rb_left;
+		else if (comp > 0)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	if (type == subvol_search_by_received_uuid) {
+		rb_link_node(&si->rb_received_node, parent, p);
+		rb_insert_color(&si->rb_received_node, root);
+	} else if (type == subvol_search_by_uuid) {
+		rb_link_node(&si->rb_local_node, parent, p);
+		rb_insert_color(&si->rb_local_node, root);
+	} else if (type == subvol_search_by_root_id) {
+		rb_link_node(&si->rb_root_id_node, parent, p);
+		rb_insert_color(&si->rb_root_id_node, root);
+	} else if (type == subvol_search_by_path) {
+		rb_link_node(&si->rb_path_node, parent, p);
+		rb_insert_color(&si->rb_path_node, root);
+	}
+	return NULL;
+}
+
+static struct subvol_info *tree_search(struct rb_root *root,
+				       u64 root_id, const u8 *uuid,
+				       u64 stransid, const char *path,
+				       enum subvol_search_type type)
+{
+	struct rb_node * n = root->rb_node;
+	struct subvol_info *entry;
+	__s64 comp;
+
+	while(n) {
+		if (type == subvol_search_by_received_uuid) {
+			entry = rb_entry(n, struct subvol_info,
+					rb_received_node);
+			comp = memcmp(entry->received_uuid, uuid,
+					BTRFS_UUID_SIZE);
+			if (!comp) {
+				if (entry->stransid < stransid)
+					comp = -1;
+				else if (entry->stransid > stransid)
+					comp = 1;
+				else
+					comp = 0;
+			}
+		} else if (type == subvol_search_by_uuid) {
+			entry = rb_entry(n, struct subvol_info, rb_local_node);
+			comp = memcmp(entry->uuid, uuid, BTRFS_UUID_SIZE);
+		} else if (type == subvol_search_by_root_id) {
+			entry = rb_entry(n, struct subvol_info, rb_root_id_node);
+			comp = entry->root_id - root_id;
+		} else if (type == subvol_search_by_path) {
+			entry = rb_entry(n, struct subvol_info, rb_path_node);
+			comp = strcmp(entry->path, path);
+		}
+		if (comp < 0)
+			n = n->rb_left;
+		else if (comp > 0)
+			n = n->rb_right;
+		else
+			return entry;
+	}
+	return NULL;
+}
+
+static int count_bytes(void *buf, int len, char b)
+{
+	int cnt = 0;
+	int i;
+	for (i = 0; i < len; i++) {
+		if (((char*)buf)[i] == b)
+			cnt++;
+	}
+	return cnt;
+}
+
+void subvol_uuid_search_add(struct subvol_uuid_search *s,
+			    struct subvol_info *si)
+{
+	int cnt;
+
+	tree_insert(&s->root_id_subvols, si, subvol_search_by_root_id);
+	tree_insert(&s->path_subvols, si, subvol_search_by_path);
+
+	cnt = count_bytes(si->uuid, BTRFS_UUID_SIZE, 0);
+	if (cnt != BTRFS_UUID_SIZE)
+		tree_insert(&s->local_subvols, si, subvol_search_by_uuid);
+	cnt = count_bytes(si->received_uuid, BTRFS_UUID_SIZE, 0);
+	if (cnt != BTRFS_UUID_SIZE)
+		tree_insert(&s->received_subvols, si,
+				subvol_search_by_received_uuid);
+}
+
+struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
+				       u64 root_id, const u8 *uuid, u64 transid,
+				       const char *path,
+				       enum subvol_search_type type)
+{
+	struct rb_root *root;
+	if (type == subvol_search_by_received_uuid)
+		root = &s->received_subvols;
+	else if (type == subvol_search_by_uuid)
+		root = &s->local_subvols;
+	else if (type == subvol_search_by_root_id)
+		root = &s->root_id_subvols;
+	else if (type == subvol_search_by_path)
+		root = &s->path_subvols;
+	else
+		return NULL;
+	return tree_search(root, root_id, uuid, transid, path, type);
+}
+
+int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	struct btrfs_root_item *root_item_ptr;
+	struct btrfs_root_item root_item;
+	struct subvol_info *si = NULL;
+	int root_item_valid = 0;
+	unsigned long off = 0;
+	int i;
+	int e;
+	char *path;
+
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = BTRFS_ROOT_TREE_OBJECTID;
+
+	sk->max_objectid = (u64)-1;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->max_type = BTRFS_ROOT_BACKREF_KEY;
+	sk->nr_items = 4096;
+
+	while(1) {
+		ret = ioctl(mnt_fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: can't perform the search- %s\n",
+				strerror(e));
+			return ret;
+		}
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+
+			if ((sh->objectid != 5 &&
+			    sh->objectid < BTRFS_FIRST_FREE_OBJECTID) ||
+			    sh->objectid == BTRFS_FREE_INO_OBJECTID)
+				goto skip;
+
+			if (sh->type == BTRFS_ROOT_ITEM_KEY) {
+				/* older kernels don't have uuids+times */
+				if (sh->len < sizeof(root_item)) {
+					root_item_valid = 0;
+					goto skip;
+				}
+				root_item_ptr = (struct btrfs_root_item *)
+						(args.buf + off);
+				memcpy(&root_item, root_item_ptr,
+						sizeof(root_item));
+				root_item_valid = 1;
+			} else if (sh->type == BTRFS_ROOT_BACKREF_KEY) {
+				if (!root_item_valid)
+					goto skip;
+
+				path = path_for_root(mnt_fd, sh->objectid);
+				if (!path)
+					path = strdup("");
+				if (IS_ERR(path)) {
+					ret = PTR_ERR(path);
+					fprintf(stderr, "ERROR: unable to "
+							"resolve path "
+							"for root %llu\n",
+							sh->objectid);
+					goto out;
+				}
+
+				si = calloc(1, sizeof(*si));
+				si->root_id = sh->objectid;
+				memcpy(si->uuid, root_item.uuid,
+						BTRFS_UUID_SIZE);
+				memcpy(si->parent_uuid, root_item.parent_uuid,
+						BTRFS_UUID_SIZE);
+				memcpy(si->received_uuid,
+						root_item.received_uuid,
+						BTRFS_UUID_SIZE);
+				si->ctransid = btrfs_root_ctransid(&root_item);
+				si->otransid = btrfs_root_otransid(&root_item);
+				si->stransid = btrfs_root_stransid(&root_item);
+				si->rtransid = btrfs_root_rtransid(&root_item);
+				si->path = path;
+
+				subvol_uuid_search_add(s, si);
+				root_item_valid = 0;
+			} else {
+				root_item_valid = 0;
+				goto skip;
+			}
+
+skip:
+			off += sh->len;
+
+			/*
+			 * record the mins in sk so we can make sure the
+			 * next search doesn't repeat this root
+			 */
+			sk->min_objectid = sh->objectid;
+			sk->min_offset = sh->offset;
+			sk->min_type = sh->type;
+		}
+		sk->nr_items = 4096;
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else if (sk->min_objectid < (u64)-1) {
+			sk->min_objectid++;
+			sk->min_offset = 0;
+			sk->min_type = 0;
+		} else
+			break;
+	}
+
+out:
+	return ret;
+}
+
+
+char *path_cat(const char *p1, const char *p2)
+{
+	int p1_len = strlen(p1);
+	int p2_len = strlen(p2);
+	char *new = malloc(p1_len + p2_len + 3);
+
+	if (p1_len && p1[p1_len - 1] == '/')
+		p1_len--;
+	if (p2_len && p2[p2_len - 1] == '/')
+		p2_len--;
+	sprintf(new, "%.*s/%.*s", p1_len, p1, p2_len, p2);
+	return new;
+}
+
+
+char *path_cat3(const char *p1, const char *p2, const char *p3)
+{
+	int p1_len = strlen(p1);
+	int p2_len = strlen(p2);
+	int p3_len = strlen(p3);
+	char *new = malloc(p1_len + p2_len + p3_len + 4);
+
+	if (p1_len && p1[p1_len - 1] == '/')
+		p1_len--;
+	if (p2_len && p2[p2_len - 1] == '/')
+		p2_len--;
+	if (p3_len && p3[p3_len - 1] == '/')
+		p3_len--;
+	sprintf(new, "%.*s/%.*s/%.*s", p1_len, p1, p2_len, p2, p3_len, p3);
+	return new;
+}
+
diff --git a/send-utils.h b/send-utils.h
new file mode 100644
index 0000000..da407eb
--- /dev/null
+++ b/send-utils.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
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
+#ifndef SEND_UTILS_H_
+#define SEND_UTILS_H_
+
+#include "ctree.h"
+#include "rbtree.h"
+
+enum subvol_search_type {
+	subvol_search_by_root_id,
+	subvol_search_by_uuid,
+	subvol_search_by_received_uuid,
+	subvol_search_by_path,
+};
+
+struct subvol_info {
+	struct rb_node rb_root_id_node;
+	struct rb_node rb_local_node;
+	struct rb_node rb_received_node;
+	struct rb_node rb_path_node;
+	u64 root_id;
+	u8 uuid[BTRFS_UUID_SIZE];
+	u8 parent_uuid[BTRFS_UUID_SIZE];
+	u8 received_uuid[BTRFS_UUID_SIZE];
+	u64 ctransid;
+	u64 otransid;
+	u64 stransid;
+	u64 rtransid;
+
+	char *path;
+};
+
+struct subvol_uuid_search {
+	struct rb_root root_id_subvols;
+	struct rb_root local_subvols;
+	struct rb_root received_subvols;
+	struct rb_root path_subvols;
+};
+
+int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s);
+struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
+				       u64 root_id, const u8 *uuid, u64 transid,
+				       const char *path,
+				       enum subvol_search_type type);
+void subvol_uuid_search_add(struct subvol_uuid_search *s,
+			    struct subvol_info *si);
+
+
+
+char *path_cat(const char *p1, const char *p2);
+char *path_cat3(const char *p1, const char *p2, const char *p3);
+
+
+#endif /* SEND_UTILS_H_ */
diff --git a/send.h b/send.h
new file mode 100644
index 0000000..b028c01
--- /dev/null
+++ b/send.h
@@ -0,0 +1,132 @@
+/*
+ * Copyright (C) 2012 Alexander Block.  All rights reserved.
+ * Copyright (C) 2012 STRATO.  All rights reserved.
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
+#include "ctree.h"
+
+#define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
+#define BTRFS_SEND_STREAM_VERSION 1
+
+#define BTRFS_SEND_BUF_SIZE (1024 * 64)
+#define BTRFS_SEND_READ_SIZE (1024 * 48)
+
+enum btrfs_tlv_type {
+	BTRFS_TLV_U8,
+	BTRFS_TLV_U16,
+	BTRFS_TLV_U32,
+	BTRFS_TLV_U64,
+	BTRFS_TLV_BINARY,
+	BTRFS_TLV_STRING,
+	BTRFS_TLV_UUID,
+	BTRFS_TLV_TIMESPEC,
+};
+
+struct btrfs_stream_header {
+	char magic[sizeof(BTRFS_SEND_STREAM_MAGIC)];
+	__le32 version;
+} __attribute__ ((__packed__));
+
+struct btrfs_cmd_header {
+	__le32 len;
+	__le16 cmd;
+	__le32 crc;
+} __attribute__ ((__packed__));
+
+struct btrfs_tlv_header {
+	__le16 tlv_type;
+	__le16 tlv_len;
+} __attribute__ ((__packed__));
+
+/* commands */
+enum btrfs_send_cmd {
+	BTRFS_SEND_C_UNSPEC,
+
+	BTRFS_SEND_C_SUBVOL,
+	BTRFS_SEND_C_SNAPSHOT,
+
+	BTRFS_SEND_C_MKFILE,
+	BTRFS_SEND_C_MKDIR,
+	BTRFS_SEND_C_MKNOD,
+	BTRFS_SEND_C_MKFIFO,
+	BTRFS_SEND_C_MKSOCK,
+	BTRFS_SEND_C_SYMLINK,
+
+	BTRFS_SEND_C_RENAME,
+	BTRFS_SEND_C_LINK,
+	BTRFS_SEND_C_UNLINK,
+	BTRFS_SEND_C_RMDIR,
+
+	BTRFS_SEND_C_SET_XATTR,
+	BTRFS_SEND_C_REMOVE_XATTR,
+
+	BTRFS_SEND_C_WRITE,
+	BTRFS_SEND_C_CLONE,
+
+	BTRFS_SEND_C_TRUNCATE,
+	BTRFS_SEND_C_CHMOD,
+	BTRFS_SEND_C_CHOWN,
+	BTRFS_SEND_C_UTIMES,
+
+	BTRFS_SEND_C_END,
+	__BTRFS_SEND_C_MAX,
+};
+#define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
+
+/* NL attributes */
+enum {
+	BTRFS_SEND_A_UNSPEC,
+
+	BTRFS_SEND_A_UUID,
+	BTRFS_SEND_A_CTRANSID,
+
+	BTRFS_SEND_A_INO,
+	BTRFS_SEND_A_SIZE,
+	BTRFS_SEND_A_MODE,
+	BTRFS_SEND_A_UID,
+	BTRFS_SEND_A_GID,
+	BTRFS_SEND_A_RDEV,
+	BTRFS_SEND_A_CTIME,
+	BTRFS_SEND_A_MTIME,
+	BTRFS_SEND_A_ATIME,
+	BTRFS_SEND_A_OTIME,
+
+	BTRFS_SEND_A_XATTR_NAME,
+	BTRFS_SEND_A_XATTR_DATA,
+
+	BTRFS_SEND_A_PATH,
+	BTRFS_SEND_A_PATH_TO,
+	BTRFS_SEND_A_PATH_LINK,
+
+	BTRFS_SEND_A_FILE_OFFSET,
+	BTRFS_SEND_A_DATA,
+
+	BTRFS_SEND_A_CLONE_UUID,
+	BTRFS_SEND_A_CLONE_CTRANSID,
+	BTRFS_SEND_A_CLONE_PATH,
+	BTRFS_SEND_A_CLONE_OFFSET,
+	BTRFS_SEND_A_CLONE_LEN,
+
+	__BTRFS_SEND_A_MAX,
+};
+#define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)
+
+#define BTRFS_SEND_SUBVOL_HAS_PARENT (1 << 0)
+
+#ifdef __KERNEL__
+long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
+#endif
-- 
1.7.10

