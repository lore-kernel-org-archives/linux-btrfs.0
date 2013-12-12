Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab3LLSLf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 13:11:35 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com, wangsl.fnst@cn.fujitsu.com,
        miaox@cn.fujitsu.com, Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: [PATCH v2] btrfs-progs: add options to set commit mode after subvol delete
Date: Thu, 12 Dec 2013 19:11:26 +0100
Message-Id: <1386871887-2020-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subvolume deletion does not do a full transaction commit. This can lead
to an unexpected result when the system crashes between deletion and
commit, the subvolume directory will appear again. Add options to request
filesystem sync after each deleted subvolume or after the last one.

If the command with --commit option finishes succesfully, the
subvolume(s) deletion status is safely stored on the media.

Userspace approach is more flexible than in-kernel. Related discussions:
http://www.spinics.net/lists/linux-btrfs/msg22088.html
http://www.spinics.net/lists/linux-btrfs/msg27240.html

CC: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

V2:
* rename --sync options to --commit, rename -s -S to -c -C
* use START_SYNC / WAIT_SYNC ioctls (Miao, Anand)

 cmds-subvolume.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 ioctl.h          |  2 ++
 man/btrfs.8.in   | 23 ++++++++++++---
 3 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c6a5284a02a4..916b864c96d7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -201,25 +201,78 @@ int test_issubvolume(char *path)
 	return (st.st_ino == 256) && S_ISDIR(st.st_mode);
 }
 
+static int wait_for_commit(int fd)
+{
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
+	if (ret < 0)
+		return ret;
+	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
+}
+
 static const char * const cmd_subvol_delete_usage[] = {
-	"btrfs subvolume delete <subvolume> [<subvolume>...]",
+	"btrfs subvolume delete [options] <subvolume> [<subvolume>...]",
 	"Delete subvolume(s)",
+	"Delete subvolumes from the filesystem. The corresponding directory",
+	"is removed instantly but the data blocks are removed later.",
+	"The deletion does not involve full commit by default due to",
+	"performance reasons (as a consequence, the subvolume may appear again",
+	"after a crash). Use one of the --commit options to wait until the",
+	"operation is safely stored on the media.",
+	"",
+	"-c|--commit-after      wait for transaction commit at the end of the operation",
+	"-C|--commit-each       wait for transaction commit after deleting each subvolume",
 	NULL
 };
 
 static int cmd_subvol_delete(int argc, char **argv)
 {
-	int	res, fd, len, e, cnt = 1, ret = 0;
+	int	res, len, e, ret = 0;
+	int cnt;
+	int fd = -1;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*dupdname = NULL;
 	char	*dupvname = NULL;
 	char	*path;
 	DIR	*dirstream = NULL;
+	int sync_mode = 0;
+	struct option long_options[] = {
+		{"commit-after", no_argument, NULL, 'c'},  /* sync mode 1 */
+		{"commit-each", no_argument, NULL, 'C'},  /* sync mode 2 */
+		{NULL, 0, NULL, 0}
+	};
+
+	optind = 1;
+	while (1) {
+		int c;
+
+		c = getopt_long(argc, argv, "cC", long_options, NULL);
+		if (c < 0)
+			break;
+
+		switch(c) {
+		case 'c':
+			sync_mode = 1;
+			break;
+		case 'C':
+			sync_mode = 2;
+			break;
+		default:
+			usage(cmd_subvol_delete_usage);
+		}
+	}
 
-	if (argc < 2)
+	if (check_argc_min(argc - optind, 1))
 		usage(cmd_subvol_delete_usage);
 
+	printf("Transaction commit: %s\n",
+		!sync_mode ? "none (default)" :
+		sync_mode == 1 ? "at the end" : "after each");
+
+	cnt = optind;
+
 again:
 	path = argv[cnt];
 
@@ -276,8 +329,6 @@ again:
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	e = errno;
 
-	close_file_or_dir(fd, dirstream);
-
 	if(res < 0 ){
 		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
 			dname, vname, strerror(e));
@@ -285,14 +336,37 @@ again:
 		goto out;
 	}
 
+	if (sync_mode == 1) {
+		res = wait_for_commit(fd);
+		if (res < 0) {
+			fprintf(stderr,
+				"ERROR: unable to wait for commit after '%s': %s\n",
+				path, strerror(errno));
+			ret = 1;
+		}
+	}
+
 out:
 	free(dupdname);
 	free(dupvname);
 	dupdname = NULL;
 	dupvname = NULL;
 	cnt++;
-	if (cnt < argc)
+	if (cnt < argc) {
+		close_file_or_dir(fd, dirstream);
 		goto again;
+	}
+
+	if (sync_mode == 2 && fd != -1) {
+		res = wait_for_commit(fd);
+		if (res < 0) {
+			fprintf(stderr,
+				"ERROR: unable to do final sync: %s\n",
+				strerror(errno));
+			ret = 1;
+		}
+	}
+	close_file_or_dir(fd, dirstream);
 
 	return ret;
 }
diff --git a/ioctl.h b/ioctl.h
index a589cd772fad..de486911717e 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -542,6 +542,8 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
+#define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 24, \
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index d5515e0af977..389de3d79881 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -8,7 +8,7 @@ btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
 \fBbtrfs\fP \fBsubvolume create\fP [-i \fI<qgroupid>\fP] [\fI<dest>\fP/]\fI<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume delete\fP \fI<subvolume>\fP [\fI<subvolume>...\fP]
+\fBbtrfs\fP \fBsubvolume delete\fP [\fIoptions\fP] \fI<subvolume>\fP [\fI<subvolume>...\fP]
 .PP
 \fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
 .PP
@@ -168,9 +168,24 @@ times.
 .RE
 .TP
 
-\fBsubvolume delete\fR\fI <subvolume> \fP[\fI<subvolume>...\fP]\fR
-Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
+\fBsubvolume delete\fR [\fIoptions\fP] \fI<subvolume>\fP [\fI<subvolume>...\fP]\fR
+Delete the subvolume(s) from the filesystem. If \fI<subvolume>\fR is not a
+subvolume, \fBbtrfs\fR returns an error but continues if there are more arguments
+to process.
+
+The corresponding directory is removed instantly but the data blocks are
+removed later.  The deletion does not involve full commit by default due to
+performance reasons (as a consequence, the subvolume may appear again after a
+crash).  Use one of the --commit options to wait until the operation is safely
+stored on the media.
+.RS
+
+\fIOptions\fP
+.IP "\fB-c|--commit-after\fP" 5
+wait for transaction commit at the end of the operation
+.IP "\fB-C|--commit-each\fP" 5
+wait for transaction commit after deleting each subvolume
+.RE
 .TP
 
 \fBsubvolume list\fR [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fR
-- 
1.8.5

