From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] btrfs-progs: Avoid buffer overflow for device name
Date: Fri,  3 Jun 2011 19:33:44 +0200
Message-ID: <1307122424-25026-1-git-send-email-mbroz@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs overwrites memory for too long device paramater

try
btrfs device scan $(awk 'BEGIN{$5090=OFS="x";print}')
...

** buffer overflow detected ***: btrfs terminated
======= Backtrace: =========
/lib64/libc.so.6(__fortify_fail+0x37)[0x7f0ef2ea0607]
/lib64/libc.so.6(+0xf6580)[0x7f0ef2e9e580]
btrfs[0x402ec4]
btrfs[0x401b48]
/lib64/libc.so.6(__libc_start_main+0xed)[0x7f0ef2dc943d]
btrfs[0x401df1]

Patch just add obvious strncpy() checks to several users
osf this paramater, probably still some path length check
is needed to properly report error.

See https://bugzilla.redhat.com/show_bug.cgi?id=710534

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 btrfs-vol.c  |    2 +-
 btrfs_cmds.c |   14 +++++++-------
 btrfsctl.c   |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/btrfs-vol.c b/btrfs-vol.c
index 4ed799d..e06a54e 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -151,7 +151,7 @@ int main(int ac, char **av)
 	}
 	fd = dirfd(dirstream);
 	if (device)
-		strcpy(args.name, device);
+		strncpy(args.name, device, sizeof(args.name));
 	else
 		args.name[0] = '\0';
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..6f5c634 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -375,7 +375,7 @@ int do_clone(int argc, char **argv)
 	printf("Create a snapshot of '%s' in '%s/%s'\n",
 	       subvol, dstdir, newname);
 	args.fd = fd;
-	strcpy(args.name, newname);
+	strncpy(args.name, newname, sizeof(args.name));
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
 
 	close(fd);
@@ -436,7 +436,7 @@ int do_delete_subvolume(int argc, char **argv)
 	}
 
 	printf("Delete subvolume '%s/%s'\n", dname, vname);
-	strcpy(args.name, vname);
+	strncpy(args.name, vname, sizeof(args.name));
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 
 	close(fd);
@@ -490,7 +490,7 @@ int do_create_subvol(int argc, char **argv)
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
-	strcpy(args.name, newname);
+	strncpy(args.name, newname, sizeof(args.name));
 	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
 
 	close(fddst);
@@ -553,7 +553,7 @@ int do_scan(int argc, char **argv)
 
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
 
-		strcpy(args.name, argv[i]);
+		strncpy(args.name, argv[i], sizeof(args.name));
 		/*
 		 * FIXME: which are the error code returned by this ioctl ?
 		 * it seems that is impossible to understand if there no is
@@ -593,7 +593,7 @@ int do_resize(int argc, char **argv)
 	}
 
 	printf("Resize '%s' of '%s'\n", path, amount);
-	strcpy(args.name, amount);
+	strncpy(args.name, amount, sizeof(args.name));
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	close(fd);
 	if( res < 0 ){
@@ -736,7 +736,7 @@ int do_add_volume(int nargs, char **args)
 		}
 		close(devfd);
 
-		strcpy(ioctl_args.name, args[i]);
+		strncpy(ioctl_args.name, args[i], sizeof(ioctl_args.name));
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		if(res<0){
 			fprintf(stderr, "ERROR: error adding the device '%s'\n", args[i]);
@@ -792,7 +792,7 @@ int do_remove_volume(int nargs, char **args)
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
-		strcpy(arg.name, args[i]);
+		strncpy(arg.name, args[i], sizeof(arg.name));
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		if(res<0){
 			fprintf(stderr, "ERROR: error removing the device '%s'\n", args[i]);
diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..29210f5 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -237,7 +237,7 @@ int main(int ac, char **av)
 	 }
 
 	if (name)
-		strcpy(args.name, name);
+		strncpy(args.name, name, sizeof(args.name));
 	else
 		args.name[0] = '\0';
 
-- 
1.7.5.3

