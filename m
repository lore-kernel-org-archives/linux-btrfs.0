From: "Morey Roof" <moreyroof@gmail.com>
Subject: Btrfslabel
Date: Thu, 7 Aug 2008 17:05:23 -0600
Message-ID: <91a37e890808071605s25b71aa9xb8f3ec44b571192d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

This patch contains all the parts for the brtfslabel program.  It
needs the two ioctl that are added in the other patch I posted earlier
today. Let me know if anything needs to be changes.

Thanks,

Morey


diff -r da35ab2b0b54 Makefile
--- a/Makefile	Wed Aug 06 12:17:01 2008 -0400
+++ b/Makefile	Thu Aug 07 17:02:41 2008 -0600
@@ -15,7 +15,7 @@
 bindir = $(prefix)/bin
 LIBS=-luuid

-progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol
+progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol btrfslabel

 # make C=1 to enable sparse
 ifdef C
@@ -45,6 +45,9 @@

 btrfsck: $(objects) btrfsck.o bit-radix.o
 	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) bit-radix.o $(LDFLAGS) $(LIBS)
+
+btrfslabel: $(objects) btrfslabel.o
+	gcc $(CFLAGS) -o btrfslabel btrfslabel.o $(objects) $(LDFLAGS) $(LIBS)

 mkfs.btrfs: $(objects) mkfs.o
 	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
diff -r da35ab2b0b54 ioctl.h
--- a/ioctl.h	Wed Aug 06 12:17:01 2008 -0400
+++ b/ioctl.h	Thu Aug 07 17:02:41 2008 -0600
@@ -19,6 +19,7 @@
 #ifndef __IOCTL_
 #define __IOCTL_
 #include <linux/ioctl.h>
+#include "ctree.h"

 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
@@ -26,6 +27,10 @@

 struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
+struct btrfs_ioctl_label_args {
+	char name[BTRFS_LABEL_SIZE + 1];
 };

 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
@@ -52,4 +57,10 @@
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)

+/* Used to set and get the current volume label */
+#define BTRFS_IOC_SET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 13, \
+					struct btrfs_ioctl_label_args)
+#define BTRFS_IOC_GET_LABEL	_IOW(BTRFS_IOCTL_MAGIC, 14, \
+					struct btrfs_ioctl_label_args)
+
 #endif
diff -r da35ab2b0b54 mkfs.c
--- a/mkfs.c	Wed Aug 06 12:17:01 2008 -0400
+++ b/mkfs.c	Thu Aug 07 17:02:41 2008 -0600
@@ -246,6 +246,7 @@
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
+	fprintf(stderr, "\t -L --label of the filesystem\n");
 	fprintf(stderr, "\t -n --nodesize size of btree leaves\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
@@ -271,20 +272,19 @@

 static char *parse_label(char *input)
 {
-	int i;
-	int len = strlen(input);
+	int check_val = check_label(input);

-	if (len > BTRFS_LABEL_SIZE) {
+	if (check_val == -1) {
 		fprintf(stderr, "Label %s is too long (max %d)\n", input,
 			BTRFS_LABEL_SIZE);
 		exit(1);
 	}
-	for (i = 0; i < len; i++) {
-		if (input[i] == '/' || input[i] == '\\') {
-			fprintf(stderr, "invalid label %s\n", input);
-			exit(1);
-		}
+
+	if (check_val == -2) {
+		fprintf(stderr, "invalid label %s\n", input);
+		exit(1);
 	}
+
 	return strdup(input);
 }

diff -r da35ab2b0b54 utils.c
--- a/utils.c	Wed Aug 06 12:17:01 2008 -0400
+++ b/utils.c	Thu Aug 07 17:02:41 2008 -0600
@@ -572,7 +572,7 @@
 }

 /*
- * returns 1 if the device was mounted, < 0 on error or 0 if everything
+ * returns 1 if the device is mounted, < 0 on error or 0 if everything
  * is safe to continue.  TODO, this should also scan multi-device filesystems
  */
 int check_mounted(char *file)
@@ -620,6 +620,39 @@
 	}

 	endmntent (f);
+	return ret;
+}
+
+/* Gets the mount point of btrfs filesystem that is using the specified device.
+ * Returns 0 is everything is good, <0 if we have an error.
+ * TODO: Fix this fucntion and check_mounted to work with multiple drive BTRFS
+ * setups.
+ */
+int get_mountpt(char *dev, char *mntpt, size_t size)
+{
+	struct mntent *mnt;
+	FILE *f;
+	int ret = 0;
+
+	f = setmntent("/proc/mounts", "r");
+	if (f == NULL)
+		return -errno;
+
+	while ((mnt = getmntent(f)) != NULL )
+	{
+		if (strcmp(dev, mnt->mnt_fsname) == 0)
+		{
+			strncpy(mntpt, mnt->mnt_dir, size);
+			break;
+		}
+	}
+
+	if (mnt == NULL)
+	{
+		/* We didn't find an entry so lets report an error */
+		ret = -1;
+	}
+
 	return ret;
 }

@@ -803,3 +836,27 @@
 	return pretty;
 }

+/*
+ * Checks to make sure that the label matches our requirements.
+ * Returns:
+       0    if everything is safe and usable
+      -1    if the label is too long
+      -2    if the label contains an invalid character
+ */
+int check_label(char *input)
+{
+	int i;
+	int len = strlen(input);
+
+	if (len > BTRFS_LABEL_SIZE) {
+		return -1;
+	}
+
+	for (i = 0; i < len; i++) {
+		if (input[i] == '/' || input[i] == '\\') {
+			return -2;
+		}
+	}
+
+	return 0;
+}
diff -r da35ab2b0b54 utils.h
--- a/utils.h	Wed Aug 06 12:17:01 2008 -0400
+++ b/utils.h	Thu Aug 07 17:02:41 2008 -0600
@@ -40,4 +40,6 @@
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+int check_label(char *input);
+int get_mountpt(char *dev, char *mntpt, size_t size);
 #endif
