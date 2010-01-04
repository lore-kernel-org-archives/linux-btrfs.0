From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 1/2] [Repost] btrfslabel - user space
Date: Mon, 4 Jan 2010 19:59:21 +0100
Message-ID: <201001041959.21312.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart84178339.XSm2VBbnlU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Morey Roof <moreyroof@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart84178339.XSm2VBbnlU
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

recently I needed to change a label of a btrfs filesystem. After a=20
bit of googling I discovered the Morey patches (dated august 2008).=20

So I update the patches to the latest btrfs source. The patches=20
creates a new command called btrfslabel which is able to change the
 label of a btrfs filesystem.

The command differentiates two cases:
=2D the filesystem is mounted: the change is done by the kernel (see=20
the second patch), btrfslabel uses an ioctl to start the label changing.
=2D the filesystem is unmounted: the change is performed in user space.

The usage is very simple: the command needs the device where is the=20
filesystem and (optionally) the label. If the label is missing, btrfs=20
shows the label, otherwise it changes the label.

$ ./btrfslabel /dev/sdc1
foo
$ ./btrfslabel /dev/sdc1 bar
$ ./btrfslabel /dev/sdc1
bar

Regarding the Morey patches I changed two things:
=2D the ioctl numbers, because the original ones are now used by other ioctl
=2D I removed an optimization in mkfs.c (which in any case is not relevant=
=20
with btrfslabel)


If request I can modify the patch. Comments are welcome.

BR
G.Baroncelli

=2D--

diff --git a/Makefile b/Makefile
index 02f881e..70efe3b 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ bindir =3D $(prefix)/bin
 LIBS=3D-luuid
=20
 progs =3D btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsc=
k \
=2D	btrfs-map-logical
+	btrfs-map-logical btrfslabel
=20
 # make C=3D1 to enable sparse
 ifdef C
@@ -48,6 +48,9 @@ btrfs-show: $(objects) btrfs-show.o
 btrfsck: $(objects) btrfsck.o
 	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
=20
+btrfslabel: $(objects) btrfslabel.o
+	gcc $(CFLAGS) -o btrfslabel btrfslabel.o $(objects) $(LDFLAGS) $(LIBS)
+
 mkfs.btrfs: $(objects) mkfs.o
 	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
=20
diff --git a/btrfslabel.c b/btrfslabel.c
new file mode 100644
index 0000000..305dfae
=2D-- /dev/null
+++ b/btrfslabel.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright (C) 2008 Morey Roof.   All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define _GNU_SOURCE
+
+#ifndef __CHECKER__
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include "ioctl.h"
+#endif /* __CHECKER__ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <linux/limits.h>
+#include <ctype.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "utils.h"
+#include "version.h"
+#include "disk-io.h"
+#include "transaction.h"
+
+#define MOUNTED                        1
+#define UNMOUNTED                      2
+#define GET_LABEL                      3
+#define SET_LABEL                      4
+
+#ifdef __CHECKER__
+#define BTRFS_IOC_SET_LABEL            0
+#define BTRFS_IOC_GET_LABEL            0
+struct btrfs_ioctl_label_args { char name[BTRFS_LABEL_SIZE]; };
+static inline int ioctl(int fd, int define, void *arg) { return 0; }
+#endif /*__CHECKER__*/
+
+static void print_usage(void)
+{
+       fprintf(stderr, "usage: btrfslabel dev [newlabel]\n");
+       fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+       exit(1);
+}
+
+static void change_label_unmounted(char *dev, char *nLabel)
+{
+       struct btrfs_root *root;
+       struct btrfs_trans_handle *trans;
+
+       /* Open the super_block at the default location
+        * and as read-write.
+        */
+       root =3D open_ctree(dev, 0, 1);
+
+       trans =3D btrfs_start_transaction(root, 1);
+       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+       btrfs_commit_transaction(trans, root);
+
+       /* Now we close it since we are done. */
+       close_ctree(root);
+}
+
+static void get_label_unmounted(char *dev)
+{
+       struct btrfs_root *root;
+
+       /* Open the super_block at the default location
+        * and as read-only.
+        */
+       root =3D open_ctree(dev, 0, 0);
+
+       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+
+       /* Now we close it since we are done. */
+       close_ctree(root);
+}
+
+static void mount_label_op(char *dev, char *nLabel, int cmd)
+{
+       struct btrfs_ioctl_label_args label_args;      =20
+       int ret =3D 0;
+       DIR *dirstream;
+       int fd;
+       char *mount_point;
+
+       mount_point =3D malloc(PATH_MAX);
+       if (mount_point =3D=3D NULL)
+       {
+               fprintf(stderr, "FATAL: Unable to allocate memory\n");
+               exit(1);
+       }
+
+       if (get_mountpt(dev, mount_point, PATH_MAX) !=3D 0)
+       {
+               fprintf(stderr, "FATAL: Unable to determine mount point\n");
+               exit(1);
+       }
+
+       dirstream =3D opendir(mount_point);
+       if (!dirstream)
+       {
+               fprintf(stderr, "FATAL: Unable to access mount point %s\n",=
 mount_point);
+               exit(1);
+       }
+
+       fd =3D dirfd(dirstream);
+       if (!fd)
+       {
+               fprintf(stderr, "FATAL: Unable to access btrfs on %s\n", de=
v);
+               exit(1);
+       }
+      =20
+       switch(cmd)
+       {
+               case GET_LABEL:
+                       ret =3D ioctl(fd, BTRFS_IOC_GET_LABEL, &label_args);
+                       if (ret =3D=3D 0)
+                       {
+                               fprintf(stdout, "%s\n", label_args.name);
+                       } else
+                       {
+                               fprintf(stderr, "FATAL: Unable to get label=
 for %s\n", dev);
+                               exit(1);
+                       }
+                       break;
+               case SET_LABEL:
+                       strncpy(label_args.name, nLabel, BTRFS_LABEL_SIZE);
+
+                       ret =3D ioctl(fd, BTRFS_IOC_SET_LABEL, &label_args);
+                       if (ret !=3D 0)
+                       {
+                               fprintf(stderr, "FATAL: Unable to set label=
 for %s\n", dev);
+                               exit(1);
+                       }
+                       break;
+               default:
+                       fprintf(stderr, "FATAL: Unknown mounted label opera=
tion\n");
+                       exit(1);
+                       break;
+       }
+
+       /* Release the memory we used */
+       free(mount_point);
+}
+
+int main(int argc, char **argv)
+{
+       char *btrfs_dev;
+       char *nLabel;
+       int ret =3D 0;
+       int workas =3D 0;
+       int check_val =3D 0;
+
+       if (argc <=3D 1)
+       {
+               print_usage();
+       }
+
+       btrfs_dev =3D argv[1];
+       ret =3D check_mounted(btrfs_dev);
+       if (ret < 0)
+       {
+               fprintf(stderr, "FATAL: error checking %s mount status\n", =
btrfs_dev);
+               exit(1);
+       }
+
+       switch(ret)
+       {
+               case 0:
+                       workas =3D UNMOUNTED;
+                       break;
+               case 1:
+                       workas =3D MOUNTED;
+                       break;
+               default:
+                       fprintf(stderr, "BUG: unknown return code from chec=
k_mounted()\n");
+                       exit(1);
+                       break;
+       }
+
+       if (argc =3D=3D 2)
+       {
+               /* They just want to know what the current label is */
+               if (workas =3D=3D MOUNTED)
+               {
+                       mount_label_op(btrfs_dev, NULL, GET_LABEL);
+               } else
+               {
+                       /* Get the label from an unmouted filesystem */
+                       get_label_unmounted(btrfs_dev);
+               }
+       } else if (argc =3D=3D 3)
+       {
+               /* They have requested we change the label */
+               nLabel =3D argv[2];
+               check_val =3D check_label(nLabel);
+
+               if (check_val =3D=3D -1)
+               {
+                       fprintf(stderr, "Label %s is too long (max %d)\n", =
nLabel,
+                               BTRFS_LABEL_SIZE);
+                       exit(1);
+               }
+
+               if (check_val =3D=3D -2)
+               {
+                       fprintf(stderr, "invalid label %s\n", nLabel);
+                       exit(1);
+               }
+
+               if (workas =3D=3D MOUNTED)
+               {
+                       mount_label_op(btrfs_dev, nLabel, SET_LABEL);
+               } else
+               {
+                       /* We are going to change the label on an unmounted=
 filesystem */
+                       change_label_unmounted(btrfs_dev, nLabel);
+               }
+       } else
+       {
+               fprintf(stderr, "FATAL: too many arguements\n\n");
+               print_usage();
+       }
+
+       return ret;
+}
diff --git a/ioctl.h b/ioctl.h
index 4410ac0..d3253bf 100644
=2D-- a/ioctl.h
+++ b/ioctl.h
@@ -20,6 +20,7 @@
 #define __IOCTL_
 #include <asm/types.h>
 #include <linux/ioctl.h>
+#include "ctree.h"
=20
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
@@ -30,6 +31,10 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
=20
+struct btrfs_ioctl_label_args {
+	char name[BTRFS_LABEL_SIZE + 1];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -59,4 +64,11 @@ struct btrfs_ioctl_vol_args {
=20
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				   struct btrfs_ioctl_vol_args)
+
+/* Used to set and get the current volume label */
+#define BTRFS_IOC_SET_LABEL    _IOW(BTRFS_IOCTL_MAGIC, 16, \
+				   struct btrfs_ioctl_label_args)
+#define BTRFS_IOC_GET_LABEL    _IOW(BTRFS_IOCTL_MAGIC, 17, \
+				   struct btrfs_ioctl_label_args)
+
 #endif
diff --git a/utils.c b/utils.c
index 2f4c6e1..51cff4a 100644
=2D-- a/utils.c
+++ b/utils.c
@@ -587,7 +587,7 @@ error:
 }
=20
 /*
=2D * returns 1 if the device was mounted, < 0 on error or 0 if everything
+ * returns 1 if the device is mounted, < 0 on error or 0 if everything
  * is safe to continue.  TODO, this should also scan multi-device filesyst=
ems
  */
 int check_mounted(char *file)
@@ -638,6 +638,39 @@ int check_mounted(char *file)
 	return ret;
 }
=20
+/* Gets the mount point of btrfs filesystem that is using the specified de=
vice.
+ * Returns 0 is everything is good, <0 if we have an error.
+ * TODO: Fix this fucntion and check_mounted to work with multiple drive B=
TRFS
+ * setups.
+ */
+int get_mountpt(char *dev, char *mntpt, size_t size)
+{
+	struct mntent *mnt;
+	FILE *f;
+	int ret =3D 0;
+
+	f =3D setmntent("/proc/mounts", "r");
+	if (f =3D=3D NULL)
+	 	return -errno;
+
+	while ((mnt =3D getmntent(f)) !=3D NULL )
+	{
+		if (strcmp(dev, mnt->mnt_fsname) =3D=3D 0)
+		{
+			strncpy(mntpt, mnt->mnt_dir, size);
+			break;
+		}
+	}
+
+	if (mnt =3D=3D NULL)
+	{
+		/* We didn't find an entry so lets report an error */
+		ret =3D -1;
+	}
+
+	return ret;
+}
+
 struct pending_dir {
 	struct list_head list;
 	char name[256];
@@ -820,3 +853,27 @@ char *pretty_sizes(u64 size)
 	return pretty;
 }
=20
+/*
+ * Checks to make sure that the label matches our requirements.
+ * Returns:
+       0    if everything is safe and usable
+      -1    if the label is too long
+      -2    if the label contains an invalid character
+ */
+int check_label(char *input)
+{
+       int i;
+       int len =3D strlen(input);
+
+       if (len > BTRFS_LABEL_SIZE) {
+               return -1;
+       }
+
+       for (i =3D 0; i < len; i++) {
+               if (input[i] =3D=3D '/' || input[i] =3D=3D '\\') {
+                       return -2;
+               }
+       }
+
+       return 0;
+}
diff --git a/utils.h b/utils.h
index 7ff542b..838b65e 100644
=2D-- a/utils.h
+++ b/utils.h
@@ -40,4 +40,6 @@ int check_mounted(char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+int check_label(char *input);
+int get_mountpt(char *dev, char *mntpt, size_t size);
 #endif

=2D---

=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart84178339.XSm2VBbnlU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLQjqJvwTxYT3FBRIRAgIkAJ9xNsTs42Z0PfkMxVbXtVKDvThqWwCfT8kR
OFELSPNbrJI9kE9jT/Yf4v8=
=5OvQ
-----END PGP SIGNATURE-----

--nextPart84178339.XSm2VBbnlU--
