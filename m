Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33297 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab2JQJGP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 05:06:15 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so4911392lbo.19
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 02:06:13 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Oct 2012 11:06:13 +0200
Message-ID: <CAOcd+r28dfR4OXtpgyivYmk5OMUxkb_O-5V94twjpSqGvez1+w@mail.gmail.com>
Subject: [PATCH] btrfs-progs: Fix the receive code pathing
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>
Cc: robert@robertbuhren.de, Rory Campbell-Lange <rory@campbell-lange.net>,
        priebe@profihost.ag
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The receive code was not distinguishing properly between the mount root
and the directory to create the received subvolume in.
Also make sure the find_mount_root reports an error if it cannot find
a match at all.

Reported-by: Robert Buhren <robert@robertbuhren.de>
Reported-by: Rory Campbell-Lange <rory@campbell-lange.net>
Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>

diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..6b7cf12 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -52,11 +52,13 @@ static int g_verbose = 0;
 struct btrfs_receive
 {
 	int mnt_fd;
+	int dest_dir_fd;

 	int write_fd;
 	char *write_path;

 	char *root_path;
+	char *dest_dir_path; /* relative to root_path */
 	char *full_subvol_path;

 	struct subvol_info *cur_subvol;
@@ -150,8 +152,11 @@ static int process_subvol(const char *path, const
u8 *uuid, u64 ctransid,
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
 	r->parent_subvol = NULL;

-	r->cur_subvol->path = strdup(path);
-	r->full_subvol_path = path_cat(r->root_path, path);
+	if (strlen(r->dest_dir_path) == 0)
+		r->cur_subvol->path = strdup(path);
+	else
+		r->cur_subvol->path = path_cat(r->dest_dir_path, path);
+	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);

 	fprintf(stderr, "At subvol %s\n", path);

@@ -167,7 +172,7 @@ static int process_subvol(const char *path, const
u8 *uuid, u64 ctransid,

 	memset(&args_v1, 0, sizeof(args_v1));
 	strcpy(args_v1.name, path);
-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: creating subvolume %s failed. "
@@ -195,8 +200,11 @@ static int process_snapshot(const char *path,
const u8 *uuid, u64 ctransid,
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
 	r->parent_subvol = NULL;

-	r->cur_subvol->path = strdup(path);
-	r->full_subvol_path = path_cat(r->root_path, path);
+	if (strlen(r->dest_dir_path) == 0)
+		r->cur_subvol->path = strdup(path);
+	else
+		r->cur_subvol->path = path_cat(r->dest_dir_path, path);
+	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);

 	fprintf(stderr, "At snapshot %s\n", path);

@@ -243,7 +251,7 @@ static int process_snapshot(const char *path,
const u8 *uuid, u64 ctransid,
 		goto out;
 	}

-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
 	close(args_v2.fd);
 	if (ret < 0) {
 		ret = -errno;
@@ -790,17 +798,48 @@ struct btrfs_send_ops send_ops = {
 int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 {
 	int ret;
+	char *dest_dir_full_path;
 	int end = 0;

-	r->root_path = strdup(tomnt);
-	r->mnt_fd = open(tomnt, O_RDONLY | O_NOATIME);
+	dest_dir_full_path = realpath(tomnt, NULL);
+	if (!dest_dir_full_path) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: realpath(%s) failed. %s\n", tomnt,
+				strerror(-ret));
+		goto out;
+	}
+	r->dest_dir_fd = open(dest_dir_full_path, O_RDONLY | O_NOATIME);
+	if (r->dest_dir_fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to open destination directory %s. %s\n",
+			    dest_dir_full_path, strerror(-ret));
+		goto out;
+	}
+
+	ret = find_mount_root(dest_dir_full_path, &r->root_path);
+	if (ret < 0) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: failed to determine mount point "
+				"for %s\n", dest_dir_full_path);
+		goto out;
+	}
+	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
 	if (r->mnt_fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: failed to open %s. %s\n", tomnt,
+		fprintf(stderr, "ERROR: failed to open %s. %s\n", r->root_path,
 				strerror(-ret));
 		goto out;
 	}

+	/*
+	 * find_mount_root returns a root_path that is a subpath of
+	 * dest_dir_full_path. Now get the other part of root_path,
+	 * which is the destination dir relative to root_path.
+	 */
+	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
+	if (r->dest_dir_path[0] == '/')
+		r->dest_dir_path++;
+
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
 		return ret;
diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..c408bc7 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -81,6 +81,14 @@ int find_mount_root(const char *path, char **mount_root)
 		}
 	}

+	if (!longest_match) {
+		fprintf(stderr, "ERROR: Failed to find mount root for path %s.\n",
+			    path);
+		fprintf(stderr, "Please make sure that you have a valid \
+			/etc/mtab file.\n");
+		return -ENOENT;
+	}
+
 	*mount_root = realpath(longest_match, NULL);
 	free(longest_match);

diff --git a/send-utils.h b/send-utils.h
index da407eb..a3e038b 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -65,5 +65,6 @@ void subvol_uuid_search_add(struct subvol_uuid_search *s,
 char *path_cat(const char *p1, const char *p2);
 char *path_cat3(const char *p1, const char *p2, const char *p3);

+int find_mount_root(const char *path, char **mount_root);

 #endif /* SEND_UTILS_H_ */
