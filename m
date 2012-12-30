Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outgoing.tormail.org ([82.221.96.22]:44876 "EHLO
	outgoing.tormail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2L3Gjv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Dec 2012 01:39:51 -0500
Date: Sun, 30 Dec 2012 06:40:08 +0000
From: junlion@tormail.org
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Incremental btrfs receive in opposite direction fails
References: <1ToibV-0001fD-SN@internal.tormail.org>
 <CAOcd+r3OjBAGbRN-cSbL7tQP=tTRYakZO3fm9gA_oqSz6KXuYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="V0207lvV8h4k8FAm"
In-Reply-To: <CAOcd+r3OjBAGbRN-cSbL7tQP=tTRYakZO3fm9gA_oqSz6KXuYw@mail.gmail.com>
Message-Id: <1TpCWu-000Fz2-6t@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2012-12-29 15:00 +0200, Alex Lyakas wrote:
> There is no special repo, but you may want, in addition to the patch
> you mentioned, apply this one as well:
> https://patchwork.kernel.org/patch/1604391/

Very useful! Somehow a few lines got wrapped though.

> > Is there a way for me to directly change the received_uuid of
> > /mnt/bak/.snap to make it identical to the UUID of /.snap? This looks
> > like the easiest way if I only need to do it once.
> There is no implemented way, but since you debugged this far, you can
> put up some code that sends BTRFS_IOC_SET_RECEIVED_SUBVOL, which is
> the one setting the received_uuid (and some other small stuff, please
> check the kernel code for it).

Ah, BTRFS_IOC_SET_RECEIVED_SUBVOL. Thanks for pointing me in the right
direction. After some hacking, it worked without eating my data... These
are the two commands to run before the failing one:

btrfs subvolume snapshot /mnt/bak/.snap /mnt/bak/.snap-mangled
uu / .snap /mnt/bak/.snap-mangled

... where uu is my crude little received_uuid and stransid display and
adjustment tool. I've attached its source.

Would be cool if someone modified btrfs send/receive to handle this use
case automatically, but it's too difficult for me.

--V0207lvV8h4k8FAm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="unwrapped__btrfs-progs-Fix-the-receive-code-pathing.patch"

diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..40d2e48 100644
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
@@ -150,8 +152,11 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
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
 
@@ -167,7 +172,7 @@ static int process_subvol(const char *path, const u8 *uuid, u64 ctransid,
 
 	memset(&args_v1, 0, sizeof(args_v1));
 	strcpy(args_v1.name, path);
-	ret = ioctl(r->mnt_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
+	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SUBVOL_CREATE, &args_v1);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: creating subvolume %s failed. "
@@ -195,8 +200,11 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
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
 
@@ -243,7 +251,7 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
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

--V0207lvV8h4k8FAm
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="uu.c"

/*
git clone https://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
cd btrfs-progs
make
gcc -O2 -luuid -o uu send-utils.o rbtree.o btrfs-list.o /path/to/this/file/uu.c
*/

#define _GNU_SOURCE

#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <uuid/uuid.h>
#include <sys/ioctl.h>

#include "ctree.h"
#include "ioctl.h"
#include "send-utils.h"

#define CLEAR(var) memset(&var, 0, sizeof(var))


int main(int argc, char **argv) {
	int ret, fd;
	struct subvol_uuid_search sus;
	struct btrfs_ioctl_received_subvol_args rs_args;
	struct subvol_info *si;
	char uuidbuf[37], parent_uuidbuf[37], received_uuidbuf[37];


	if (argc != 3 && argc != 4) {
		printf("usage: uu srcmnt srcsub_reltosrcmnt [dstsub_abs]\n");
		exit(1);
	}

	printf("opening srcmnt %s\n", argv[1]);
	fd = open(argv[1], O_RDONLY | O_NOATIME);
	if (fd < 0) {
		printf("failed to open srcmnt %s! %s\n", argv[1], strerror(errno));
		exit(2);
	}

	puts("initializing sub search");
	CLEAR(sus);
	ret = subvol_uuid_search_init(fd, &sus);
	if (ret < 0) {
		printf("failed to initialize sub search! %s\n", strerror(-ret));
		exit(3);
	}
	
	printf("searching srcsub %s\n", argv[2]);
	si = subvol_uuid_search(&sus, 0, NULL, 0, argv[2], subvol_search_by_path);
	if (!si) {
		puts("srcsub not found!");
		exit(4);
	}

	uuid_unparse(si->uuid,                   uuidbuf);
	uuid_unparse(si->parent_uuid,     parent_uuidbuf);
	uuid_unparse(si->received_uuid, received_uuidbuf);

	printf("\nsrcsub found:\n"
	       "         uuid=%s\n"
	       "  parent_uuid=%s\n"
	       "received_uuid=%s\n"
	       "ctransid=%Lu otransid=%Lu stransid=%Lu rtransid=%Lu\n\n",
	       uuidbuf, parent_uuidbuf, received_uuidbuf,
	       (unsigned long long)(si->ctransid),
	       (unsigned long long)(si->otransid),
	       (unsigned long long)(si->stransid),
	       (unsigned long long)(si->rtransid));

	if (argc == 3)
		goto done;

	printf("opening dst subvol %s\n", argv[3]);
	fd = open(argv[3], O_RDONLY | O_NOATIME);
	if (fd < 0) {
		printf("failed to open dst subvol %s. %s\n", argv[3], strerror(errno));
		exit(5);
	}

	printf("\nhere we go with BTRFS_IOC_SET_RECEIVED_SUBVOL:\n"
	       "dstsub.received_uuid = srcsub.uuid == %s\n"
	       "dstsub.stransid = srcsub.ctransid == %Lu\n\n",
	       uuidbuf, (unsigned long long)(si->ctransid));

	CLEAR(rs_args);
	memcpy(rs_args.uuid, si->uuid, BTRFS_UUID_SIZE);
	rs_args.stransid = si->ctransid;

	ret = ioctl(fd, BTRFS_IOC_SET_RECEIVED_SUBVOL, &rs_args);
	if (ret < 0) {
		printf("BTRFS_IOC_SET_RECEIVED_SUBVOL failed: %s", strerror(-ret));
		exit(6);
	}

done:
	printf("done.\n");
	exit(0);
}

--V0207lvV8h4k8FAm--
