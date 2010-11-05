From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v2 3/3] User-space tool for cancelling balance operations.
Date: Fri, 5 Nov 2010 23:34:02 +0000
Message-ID: <43c88d2b49066e32a19d90cc6060615653f104eb.1289521433.git.hugo@carfax.org.uk>
References: <cover.1289521433.git.hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1289521433.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Add an option to the btrfs tool to use the ioctl for cancelling
balance operations.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c      |    4 ++++
 btrfs_cmds.c |   41 +++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    1 +
 ioctl.h      |    1 +
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 0b6186c..93f7886 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -103,6 +103,10 @@ static struct Command commands[] = {
 	  "balance progress", "[-m|--monitor] <path>\n"
 		"Show progress of the balance operation running on <path>."
 	},
+	{ do_balance_cancel, 1,
+	  "balance cancel", "<path>\n"
+		"Cancel the balance operation running on <path>."
+	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index c681b5a..d246a8b 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -922,6 +922,47 @@ int do_balance_progress(int argc, char **argv)
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
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 47b0a27..5cb0d9c 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -24,6 +24,7 @@ int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
 int do_balance_progress(int nargs, char **argv);
+int do_balance_cancel(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
diff --git a/ioctl.h b/ioctl.h
index 888ceb9..1fc665b 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -176,4 +176,5 @@ struct btrfs_ioctl_balance_progress {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_BALANCE_PROGRESS _IOR(BTRFS_IOCTL_MAGIC, 25, \
 					struct btrfs_ioctl_balance_progress)
+#define BTRFS_IOC_BALANCE_CANCEL _IO(BTRFS_IOCTL_MAGIC, 26)
 #endif
-- 
1.7.1

