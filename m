From: Sage Weil <sage@newdream.net>
Subject: [PATCH v2] btrfs-progs: btrfs: implement async option for snapshot command
Date: Mon,  1 Nov 2010 09:34:22 -0700
Message-ID: <1288629262-5405-3-git-send-email-sage@newdream.net>
References: <1288629262-5405-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288629262-5405-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add an 'async' option to the snapshot creating command, that will let you
avoid waiting for a new snapshot to commit to disk.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 btrfs.c        |    9 ++++++---
 btrfs_cmds.c   |   31 +++++++++++++++++++++++++------
 btrfs_cmds.h   |    2 +-
 man/btrfs.8.in |   15 ++++++++++-----
 4 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index c871f4a..657bb6f 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -44,10 +44,13 @@ static struct Command commands[] = {
 	/*
 		avoid short commands different for the case only
 	*/
-	{ do_clone, 2,
-	  "subvolume snapshot", "<source> [<dest>/]<name>\n"
+	{ do_create_snap, -2,
+	  "subvolume snapshot", "<source> [<dest>/]<name> [async]\n"
 		"Create a writable snapshot of the subvolume <source> with\n"
-		"the name <name> in the <dest> directory."
+		"the name <name> in the <dest> directory.  If [async] is\n"
+	        "specified, we will not wait for the snapshot to be committed\n"
+	        "to disk, and a transid will be printed that can be fed to\n"
+	        "'filesystem wait-sync <transid>'."
 	},
 	{ do_delete_subvolume, 1,
 	  "subvolume delete", "<subvolume>\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 736437d..276b8fa 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -307,16 +307,22 @@ int do_subvol_list(int argc, char **argv)
 	return 0;
 }
 
-int do_clone(int argc, char **argv)
+int do_create_snap(int argc, char **argv)
 {
 	char	*subvol, *dst;
-	int	res, fd, fddst, len;
+	int	res, fd, fddst, len, async;
 	char	*newname;
 	char	*dstdir;
 
 	subvol = argv[1];
 	dst = argv[2];
-	struct btrfs_ioctl_vol_args	args;
+	if (argc > 3) {
+		if (strstr(argv[3], "async")) {
+			async = 1;
+		} else {
+			fprintf(stderr, "ERROR: 'async' expected for third arg\n");
+		}
+	}
 
 	res = test_issubvolume(subvol);
 	if(res<0){
@@ -374,9 +380,22 @@ int do_clone(int argc, char **argv)
 
 	printf("Create a snapshot of '%s' in '%s/%s'\n",
 	       subvol, dstdir, newname);
-	args.fd = fd;
-	strcpy(args.name, newname);
-	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
+	if (async) {
+		struct btrfs_ioctl_async_vol_args	async_args;
+		async_args.fd = fd;
+		async_args.transid = 0;
+		strcpy(async_args.name, newname);
+		res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_ASYNC, &async_args);
+		if (res == 0)
+			printf("transid %llu\n",
+			       (unsigned long long)async_args.transid);
+	} else {
+		struct btrfs_ioctl_vol_args	args;
+
+		args.fd = fd;
+		strcpy(args.name, newname);
+		res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
+	}
 
 	close(fd);
 	close(fddst);
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 84c489f..bf566ae 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -15,7 +15,7 @@
  */
 
 /* btrfs_cmds.c*/
-int do_clone(int nargs, char **argv);
+int do_create_snap(int nargs, char **argv);
 int do_delete_subvolume(int nargs, char **argv);
 int do_create_subvol(int nargs, char **argv);
 int do_fssync(int nargs, char **argv);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index e87b5fe..504fe5f 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -5,7 +5,7 @@
 .SH NAME
 btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
-\fBbtrfs\fP \fBsubvolume snapshot\fP\fI <source> [<dest>/]<name>\fP
+\fBbtrfs\fP \fBsubvolume snapshot\fP\fI <source> [<dest>/]<name> [async]\fP
 .PP
 \fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume>\fP
 .PP
@@ -74,10 +74,15 @@ command.
 .SH COMMANDS
 .TP
 
-\fBsubvolume snapshot\fR\fI <source> [<dest>/]<name>\fR
-Create a writable snapshot of the subvolume \fI<source>\fR with the name
-\fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
+\fBsubvolume snapshot\fR\fI <source> [<dest>/]<name> [async]\fR 
+Create a writable snapshot of the subvolume \fI<source>\fR with the
+name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is
+not a subvolume, \fBbtrfs\fR returns an error.  If \fI[async]\fR is
+specified, we will not wait for the snapshot creation to commit to
+disk before returning, and a transaction id is printed that can be
+waited on1 using the \fBfilesystem wait-sync\fR command.
+.TP
+
 .TP
 
 \fBsubvolume delete\fR\fI <subvolume>\fR
-- 
1.7.0

