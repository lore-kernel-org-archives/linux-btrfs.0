From: Sage Weil <sage@newdream.net>
Subject: [PATCH 2/3] btrfs: implement 'async-snapshot' command
Date: Sat, 30 Oct 2010 10:56:05 -0700
Message-ID: <1288461366-26914-2-git-send-email-sage@newdream.net>
References: <1288461366-26914-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288461366-26914-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

This is identical to 'snapshot', but uses the new async snapshot creation
ioctl, and prints out the transid the new snapshot will be committed
with.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 btrfs.c      |    8 +++++++-
 btrfs_cmds.c |   32 +++++++++++++++++++++++++++-----
 btrfs_cmds.h |    3 ++-
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..c4b9a31 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -44,11 +44,17 @@ static struct Command commands[] = {
 	/*
 		avoid short commands different for the case only
 	*/
-	{ do_clone, 2,
+	{ do_create_snap, 2,
 	  "subvolume snapshot", "<source> [<dest>/]<name>\n"
 		"Create a writable snapshot of the subvolume <source> with\n"
 		"the name <name> in the <dest> directory."
 	},
+	{ do_create_snap_async, 2,
+	  "subvolume async-snapshot", "<source> [<dest>/]<name>\n"
+		"Create a writable snapshot of the subvolume <source> with\n"
+		"the name <name> in the <dest> directory.  Do not wait for\n"
+	        "the snapshot creation to commit to disk before returning."
+	},
 	{ do_delete_subvolume, 1,
 	  "subvolume delete", "<subvolume>\n"
 		"Delete the subvolume <subvolume>."
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..6da5862 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -307,7 +307,7 @@ int do_subvol_list(int argc, char **argv)
 	return 0;
 }
 
-int do_clone(int argc, char **argv)
+static int create_snap(int argc, char **argv, int async)
 {
 	char	*subvol, *dst;
 	int	res, fd, fddst, len;
@@ -316,7 +316,6 @@ int do_clone(int argc, char **argv)
 
 	subvol = argv[1];
 	dst = argv[2];
-	struct btrfs_ioctl_vol_args	args;
 
 	res = test_issubvolume(subvol);
 	if(res<0){
@@ -374,9 +373,22 @@ int do_clone(int argc, char **argv)
 
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
@@ -390,6 +402,16 @@ int do_clone(int argc, char **argv)
 
 }
 
+int do_create_snap_async(int argc, char **argv)
+{
+	return create_snap(argc, argv, 1);
+}
+
+int do_create_snap(int argc, char **argv)
+{
+	return create_snap(argc, argv, 0);
+}
+
 int do_delete_subvolume(int argc, char **argv)
 {
 	int	res, fd, len;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..c44dc79 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -15,7 +15,8 @@
  */
 
 /* btrfs_cmds.c*/
-int do_clone(int nargs, char **argv);
+int do_create_snap(int nargs, char **argv);
+int do_create_snap_async(int nargs, char **argv);
 int do_delete_subvolume(int nargs, char **argv);
 int do_create_subvol(int nargs, char **argv);
 int do_fssync(int nargs, char **argv);
-- 
1.7.1

