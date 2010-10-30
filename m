From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 1/2] Balance progress monitoring.
Date: Sat, 30 Oct 2010 01:10:23 +0100
Message-ID: <20101030001042.578795639@carfax.org.uk>
References: <20101030001022.247934404@carfax.org.uk>
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add support to the btrfs tool for monitoring a balance operation on a
filesystem.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>

---
 btrfs.c      |    4 ++++
 btrfs_cmds.c |   40 ++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    1 +
 ioctl.h      |    7 +++++++
 4 files changed, 52 insertions(+)

Index: btrfs-progs-unstable/btrfs.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs.c	2010-10-28 22:58:54.805035975 +0100
+++ btrfs-progs-unstable/btrfs.c	2010-10-30 00:19:59.968416575 +0100
@@ -95,6 +95,10 @@
 	  "filesystem balance", "<path>\n"
 		"Balance the chunks across the device."
 	},
+	{ do_balance_progress, 1,
+	  "balance progress", "<path>\n"
+		"Show progress of the balance operation running on <path>."
+	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-28 22:58:54.855033936 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-30 00:04:48.335524683 +0100
@@ -808,6 +808,46 @@
 	}
 	return 0;
 }
+
+int do_balance_progress(int argc, char **argv)
+{
+	char *path = argv[1];
+	int fdmnt;
+	int ret = 0;
+	int err = 0;
+	struct btrfs_ioctl_balance_progress bal;
+
+	fdmnt = open_file_or_dir(path);
+	if(fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_PROGRESS, &bal);
+	if(!ret)
+		err = errno;
+	close(fdmnt);
+
+	switch(err) {
+	case 0:
+		break;
+	case -EINVAL:
+		fprintf(stderr, "No balance operation running on '%s'.\n",
+			path);
+		return 20;
+	default:
+		fprintf(stderr, "ERROR: ioctl returned error %d.", err);
+		return 21;
+	}
+
+	printf("%llu/%llu block groups moved, %0.2f%% complete.\n",
+	       bal.completed,
+	       bal.expected,
+	       (float)bal.completed/bal.expected*100.0);
+
+	return 0;
+}
+
 int do_remove_volume(int nargs, char **args)
 {
 
Index: btrfs-progs-unstable/btrfs_cmds.h
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.h	2010-10-28 22:58:54.895032304 +0100
+++ btrfs-progs-unstable/btrfs_cmds.h	2010-10-30 00:04:48.335524683 +0100
@@ -23,6 +23,7 @@
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
+int do_balance_progress(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
Index: btrfs-progs-unstable/ioctl.h
===================================================================
--- btrfs-progs-unstable.orig/ioctl.h	2010-10-28 23:14:16.937413446 +0100
+++ btrfs-progs-unstable/ioctl.h	2010-10-30 00:04:48.325525089 +0100
@@ -132,6 +132,11 @@
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_balance_progress {
+	__u64 expected;
+	__u64 completed;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -169,4 +174,6 @@
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 21, \
+					struct btrfs_ioctl_balance_progress)
 #endif


