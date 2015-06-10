Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43768 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbbFJTFy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 15:05:54 -0400
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t5AJ5epF001542
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 12:05:53 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1uxsurr5nm-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 12:05:53 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: make receive work inside of subvolumes
Date: Wed, 10 Jun 2015 15:05:51 -0400
Message-ID: <1433963151-18488-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kind of a big feature of btrfs is being able to have a default subvol.  However
the receive code generates the paths to the subvols from the root of the fs,
even in the case of a default subvol.  So instead figure out if we're inside of
a subvol, either because we have a different default or we've chroot'ed and are
using -m.  Then strip this extra path off of the subvol we find so we can look
up our parent properly.  Thanks

Reported-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-receive.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 2 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 28ae8e9..9925b47 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -61,6 +61,7 @@ struct btrfs_receive
 	char *root_path;
 	char *dest_dir_path; /* relative to root_path */
 	char *full_subvol_path;
+	char *full_root_path;
 	int dest_dir_chroot;
 
 	struct subvol_info *cur_subvol;
@@ -240,6 +241,45 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		goto out;
 	}
 
+	/*
+	 * The path is resolved from the root subvol, but we could be in some
+	 * subvolume under the root subvolume, so try and adjust the path to be
+	 * relative to our root path.
+	 */
+	if (r->full_root_path) {
+		size_t root_len, sub_len;
+
+		root_len = strlen(r->full_root_path);
+		sub_len = strlen(parent_subvol->path);
+
+		/* First make sure the parent subvol is actually in our path */
+		if (sub_len < root_len ||
+		    strstr(parent_subvol->path, r->full_root_path) == NULL) {
+			fprintf(stderr, "ERROR: parent subvol is not reachable"
+				" from inside the root subvol.\n");
+			ret = -ENOENT;
+			goto out;
+		}
+
+		if (sub_len == root_len) {
+			parent_subvol->path[0] = '/';
+			parent_subvol->path[1] = '\0';
+		} else {
+			/*
+			 * root path is foo/bar
+			 * subvol path is foo/bar/baz
+			 *
+			 * we need to have baz be the path, so we need to move
+			 * the bit after foo/bar/, so path + root_len + 1, and
+			 * move the part we care about, so sub_len - root_len -
+			 * 1.
+			 */
+			memmove(parent_subvol->path,
+				parent_subvol->path + root_len + 1,
+				sub_len - root_len - 1);
+			parent_subvol->path[sub_len - root_len - 1] = '\0';
+		}
+	}
 	/*if (rs_args.ctransid > rs_args.rtransid) {
 		if (!r->force) {
 			ret = -EINVAL;
@@ -250,8 +290,11 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		}
 	}*/
 
-	args_v2.fd = openat(r->mnt_fd, parent_subvol->path,
-			O_RDONLY | O_NOATIME);
+	if (strlen(parent_subvol->path) == 0)
+		args_v2.fd = dup(r->mnt_fd);
+	else
+		args_v2.fd = openat(r->mnt_fd, parent_subvol->path,
+				O_RDONLY | O_NOATIME);
 	if (args_v2.fd < 0) {
 		ret = -errno;
 		if (errno != ENOENT)
@@ -816,8 +859,10 @@ static struct btrfs_send_ops send_ops = {
 static int do_receive(struct btrfs_receive *r, const char *tomnt,
 		      char *realmnt, int r_fd, u64 max_errors)
 {
+	u64 subvol_id;
 	int ret;
 	char *dest_dir_full_path;
+	char *root_subvol_path;
 	int end = 0;
 
 	dest_dir_full_path = realpath(tomnt, NULL);
@@ -863,6 +908,42 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt,
 		goto out;
 	}
 
+	/*
+	 * If we use -m or a default subvol we want to resolve the path to the
+	 * subvolume we're sitting in so that we can adjust the paths of any
+	 * subvols we want to receive in.
+	 */
+	ret = btrfs_list_get_path_rootid(r->mnt_fd, &subvol_id);
+	if (ret) {
+		fprintf(stderr, "ERROR: couldn't resolve our subvolid %d\n",
+			ret);
+		goto out;
+	}
+
+	root_subvol_path = malloc(BTRFS_PATH_NAME_MAX);
+	if (!root_subvol_path) {
+		ret = -ENOMEM;
+		fprintf(stderr, "ERROR: couldn't allocate buffer for the root "
+			"subvol path\n");
+		goto out;
+	}
+
+	ret = btrfs_subvolid_resolve(r->mnt_fd, root_subvol_path,
+				     BTRFS_PATH_NAME_MAX, subvol_id);
+	if (ret) {
+		fprintf(stderr, "ERROR: couldn't resolve our subvol path\n");
+		goto out;
+	}
+
+	/*
+	 * Ok we're inside of a subvol off of the root subvol, we need to
+	 * actually set full_root_path.
+	 */
+	if (strlen(root_subvol_path))
+		r->full_root_path = root_subvol_path;
+	else
+		free(root_subvol_path);
+
 	if (r->dest_dir_chroot) {
 		if (chroot(dest_dir_full_path)) {
 			ret = -errno;
@@ -940,6 +1021,10 @@ out:
 		close(r->dest_dir_fd);
 		r->dest_dir_fd = -1;
 	}
+	if (r->full_root_path) {
+		free(r->full_root_path);
+		r->full_root_path = NULL;
+	}
 	return ret;
 }
 
-- 
1.8.3.1

