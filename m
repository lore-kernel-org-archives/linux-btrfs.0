From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 2/2] User-space tool for cancelling balance operations.
Date: Sat, 30 Oct 2010 01:10:24 +0100
Message-ID: <20101030001042.809576287@carfax.org.uk>
References: <20101030001022.247934404@carfax.org.uk>
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add an option to the btrfs tool to use the ioctl for cancelling
balance operations.

SIgned-off-by: Hugo Mills <hugo@carfax.org.uk>

---
 btrfs.c      |    4 ++++
 btrfs_cmds.c |   41 +++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    1 +
 ioctl.h      |    1 +
 4 files changed, 47 insertions(+)

Index: btrfs-progs-unstable/btrfs.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs.c	2010-10-30 00:19:59.968416575 +0100
+++ btrfs-progs-unstable/btrfs.c	2010-10-30 00:20:38.446849736 +0100
@@ -99,6 +99,10 @@
 	  "balance progress", "<path>\n"
 		"Show progress of the balance operation running on <path>."
 	},
+	{ do_balance_cancel, 1,
+	  "balance cancel", "<path>\n"
+		"Cancel the balance operation running on <path>."
+	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-30 00:04:48.335524683 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-30 00:20:22.267508562 +0100
@@ -848,6 +848,47 @@
 	return 0;
 }
 
+int do_balance_cancel(int nargs, char **argv)
+{
+	char *path = argv[1];
+	int fdmnt;
+	int ret = 0;
+	int err = 0;
+
+	fdmnt = open_file_or_dir(path);
+	if(fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_CANCEL, NULL);
+	err = errno;
+
+	if(ret) {
+		switch(err) {
+		case 0:
+			break;
+		case EINVAL:
+			fprintf(stderr, "ERROR: no balance in progress.\n");
+			err = 20;
+			break;
+		case ECANCELED:
+			fprintf(stderr, "ERROR: operation already cancelled.\n");
+			err = 21;
+			break;
+		default:
+			fprintf(stderr, "ERROR: ioctl returned error '%d'.\n",
+				err);
+			err = 22;
+			break;
+		}
+	}
+
+	close(fdmnt);
+
+	return err;
+}
+
 int do_remove_volume(int nargs, char **args)
 {
 
Index: btrfs-progs-unstable/btrfs_cmds.h
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.h	2010-10-30 00:04:48.335524683 +0100
+++ btrfs-progs-unstable/btrfs_cmds.h	2010-10-30 00:20:22.307506934 +0100
@@ -24,6 +24,7 @@
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
 int do_balance_progress(int nargs, char **argv);
+int do_balance_cancel(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
Index: btrfs-progs-unstable/ioctl.h
===================================================================
--- btrfs-progs-unstable.orig/ioctl.h	2010-10-30 00:04:48.325525089 +0100
+++ btrfs-progs-unstable/ioctl.h	2010-10-30 00:20:22.357504895 +0100
@@ -176,4 +176,5 @@
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 21, \
 					struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 22)
 #endif


