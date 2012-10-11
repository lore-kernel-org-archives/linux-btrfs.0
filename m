Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51530 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2JKJKJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 05:10:09 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1119121lbo.19
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2012 02:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010221107.GA19266@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
	<50733D66.5020600@gmx.net>
	<20121009111830.GC31743@campbell-lange.net>
	<CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
	<20121010221107.GA19266@campbell-lange.net>
Date: Thu, 11 Oct 2012 11:10:07 +0200
Message-ID: <CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
Subject: Re: btrfs receive to subdirectory
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Rory,
thanks for letting me know.
I am using the latest code from Chris's repo (
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git),
which has been updated recently (latest commit
91d9eec1ff044394f2b98ee7fcb76713dd33b994).
Do you think you can try the following patch on top of this commit? (I
made another small fix).

Basically, the idea is that the path that you give to "btrfs receive"
should be the destination directory, in which the received subvolume
will be created. And this directory should be somewhere under a mount
point, where destination btrfs is mounted (it can also be the same as
the mount point, but not above it). Does this make sense?
Also it should not matter where the sent subvolume resided in the
source fs, and, if this is a diff-send, where you have received the
parent snapshot to (as long as it is on/under the same mount point).

Thanks,
Alex.

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
diff --git a/send-utils.h b/send-utils.h
index da407eb..a3e038b 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -65,5 +65,6 @@ void subvol_uuid_search_add(struct subvol_uuid_search *s,
 char *path_cat(const char *p1, const char *p2);
 char *path_cat3(const char *p1, const char *p2, const char *p3);

+int find_mount_root(const char *path, char **mount_root);

 #endif /* SEND_UTILS_H_ */




On Thu, Oct 11, 2012 at 12:11 AM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:
> On 09/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
>> Hi Rory, Arne,
>> I think the problem is that currently mnt_fd in struct btrfs_receive
>> is used both as "mount root" and "directory in which the
>> subvolume/snapshot needs to be created".
>> Arne, does the following patch make sense? It uses Jan's
>> find_mount_root function. With this patch both Rory's tests seem to
>> work for me.
>
> Hi Alex
>
> I haven't had a chance to test this. I'm also on 89fe5b5f of progs
> recommended to my by Chris for send/receive testing and your patch
> doesn't apply for me. Are you using another revision?
>
> Regards
> Rory
>
> --
> Rory Campbell-Lange
> rory@campbell-lange.net
