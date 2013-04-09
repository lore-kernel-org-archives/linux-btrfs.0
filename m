Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:46514 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304Ab3DIRIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:48 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 31.25 OK)
	with ESMTP id X0693dp39Fv1Ry for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Apr 2013 19:08:46 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 17/17] btrfs-progs: Fix the receive code pathing
Date: Tue,  9 Apr 2013 19:08:45 +0200
Message-Id: <22f7243b089c7b280d5b09a9b83eaca9c1c238ef.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>
References: <cover.1365524492.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Alex Lyakas <alex.btrfs@zadarastorage.com>

The receive code was not distinguishing properly between the mount root
and the directory to create the received subvolume in.
Also make sure the find_mount_root reports an error if it cannot find
a match at all.

Reported-by: Robert Buhren <robert@robertbuhren.de>
Reported-by: Rory Campbell-Lange <rory@campbell-lange.net>
Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-receive.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 cmds-send.c    |  7 ++++++
 2 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index e5467d2..04704df 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -55,11 +55,13 @@ static int g_verbose = 0;
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
@@ -153,9 +155,12 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
 
-	r->cur_subvol->path = strdup(path);
+	if (strlen(r->dest_dir_path) == 0)
+		r->cur_subvol->path = strdup(path);
+	else
+		r->cur_subvol->path = path_cat(r->dest_dir_path, path);
 	free(r->full_subvol_path);
-	r->full_subvol_path = path_cat(r->root_path, path);
+	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);
 
 	fprintf(stderr, "At subvol %s\n", path);
 
@@ -171,7 +176,7 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 
 	memset(&args_v1, 0, sizeof(args_v1));
 	strncpy_null(args_v1.name, path);
-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: creating subvolume %s failed. "
@@ -199,9 +204,12 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 
 	r->cur_subvol = calloc(1, sizeof(*r->cur_subvol));
 
-	r->cur_subvol->path = strdup(path);
+	if (strlen(r->dest_dir_path) == 0)
+		r->cur_subvol->path = strdup(path);
+	else
+		r->cur_subvol->path = path_cat(r->dest_dir_path, path);
 	free(r->full_subvol_path);
-	r->full_subvol_path = path_cat(r->root_path, path);
+	r->full_subvol_path = path_cat3(r->root_path, r->dest_dir_path, path);
 
 	fprintf(stderr, "At snapshot %s\n", path);
 
@@ -248,7 +256,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 	}
 
-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
 	close(args_v2.fd);
 	if (ret < 0) {
 		ret = -errno;
@@ -795,17 +803,49 @@ struct btrfs_send_ops send_ops = {
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
+			strerror(-ret));
+		goto out;
+	}
+	r->dest_dir_fd = open(dest_dir_full_path, O_RDONLY | O_NOATIME);
+	if (r->dest_dir_fd < 0) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: failed to open destination directory %s. %s\n",
+			dest_dir_full_path, strerror(-ret));
+		goto out;
+	}
+
+	ret = find_mount_root(dest_dir_full_path, &r->root_path);
+	if (ret < 0) {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: failed to determine mount point "
+			"for %s\n", dest_dir_full_path);
+		goto out;
+	}
+	r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
 	if (r->mnt_fd < 0) {
 		ret = -errno;
-		fprintf(stderr, "ERROR: failed to open %s. %s\n", tomnt,
-				strerror(-ret));
+		fprintf(stderr, "ERROR: failed to open %s. %s\n", r->root_path,
+			strerror(-ret));
 		goto out;
 	}
 
+	/*
+	 * find_mount_root returns a root_path that is a subpath of
+	 * dest_dir_full_path. Now get the other part of root_path,
+	 * which is the destination dir relative to root_path.
+	 */
+	r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
+	while (r->dest_dir_path[0] == '/')
+		r->dest_dir_path++;
+
 	ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
 	if (ret < 0)
 		goto out;
@@ -838,6 +878,8 @@ out:
 	r->write_path = NULL;
 	free(r->full_subvol_path);
 	r->full_subvol_path = NULL;
+	r->dest_dir_path = NULL;
+	free(dest_dir_full_path);
 	if (r->cur_subvol) {
 		free(r->cur_subvol->path);
 		free(r->cur_subvol);
@@ -848,6 +890,10 @@ out:
 		close(r->mnt_fd);
 		r->mnt_fd = -1;
 	}
+	if (r->dest_dir_fd != -1) {
+		close(r->dest_dir_fd);
+		r->dest_dir_fd = -1;
+	}
 	return ret;
 }
 
@@ -864,6 +910,7 @@ static int do_cmd_receive(int argc, char **argv)
 	memset(&r, 0, sizeof(r));
 	r.mnt_fd = -1;
 	r.write_fd = -1;
+	r.dest_dir_fd = -1;
 
 	while ((c = getopt(argc, argv, "evf:")) != -1) {
 		switch (c) {
diff --git a/cmds-send.c b/cmds-send.c
index fcde74c..9bb4206 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -84,6 +84,13 @@ int find_mount_root(const char *path, char **mount_root)
 	}
 	fclose(mnttab);
 
+	if (!longest_match) {
+		fprintf(stderr,
+			"ERROR: Failed to find mount root for path %s.\n",
+			path);
+		return -ENOENT;
+	}
+
 	*mount_root = realpath(longest_match, NULL);
 	free(longest_match);
 
-- 
1.8.2.1

