From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 2/2] [Repost] btrfslabel - kernel space
Date: Mon, 4 Jan 2010 19:59:09 +0100
Message-ID: <201001041959.16910.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart57395245.2QGtYfJttG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Morey Roof <moreyroof@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart57395245.2QGtYfJttG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is the second patch, the one kernel related. This patch introduces two=
 new
ioctls to read and change the label of a btrfs filesystem.

This patch is a repost of a previous patch of Morey Roof.

If request I can modify the patch. Comments are welcome.

BR
G.Baroncelli

=2D--
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 645a179..18f3ada 100644
=2D-- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1301,6 +1301,53 @@ long btrfs_ioctl_trans_end(struct file *file)
 	return 0;
 }
=20
+long btrfs_ioctl_set_label(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_ioctl_label_args *label_args;
+	int ret =3D 0;
+
+	label_args =3D kmalloc(sizeof(*label_args), GFP_NOFS);
+
+	if (!label_args)
+		return -ENOMEM;
+
+	if (copy_from_user(label_args, arg, sizeof(*label_args)))
+	{
+		ret =3D -EFAULT;
+	} else
+	{
+		/* Everything looks good, so lets do a label change */
+		label_args->name[BTRFS_LABEL_SIZE] =3D 0x00;
+		trans =3D btrfs_start_transaction(root, 1);
+		strncpy(root->fs_info->super_copy.label, label_args->name, BTRFS_LABEL_S=
IZE);
+		btrfs_commit_transaction(trans, root);
+	}
+
+	kfree(label_args);
+	return ret;
+}
+
+long btrfs_ioctl_get_label(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_label_args *label_args;
+	int ret =3D 0;
+
+	label_args =3D kmalloc(sizeof(*label_args), GFP_NOFS);
+
+	if (!label_args)
+		return -ENOMEM;
+
+	strncpy(label_args->name, root->fs_info->super_copy.label, BTRFS_LABEL_SI=
ZE);
+	if (copy_to_user(arg, label_args, sizeof(*label_args)))
+	{
+		ret =3D -EFAULT;
+	}
+
+	kfree(label_args);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -1338,6 +1385,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_SET_LABEL:
+		return btrfs_ioctl_set_label(root, (void __user *)arg);
+	case BTRFS_IOC_GET_LABEL:
+		return btrfs_ioctl_get_label(root, (void __user *)arg);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index bc49914..995756d 100644
=2D-- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -19,6 +19,7 @@
 #ifndef __IOCTL_
 #define __IOCTL_
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
 struct btrfs_ioctl_clone_range_args {
   __s64 src_fd;
   __u64 src_offset, src_length;
@@ -67,4 +72,11 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
 				struct btrfs_ioctl_vol_args)
+
+/* Used to set and get the current volume label */
+#define BTRFS_IOC_SET_LABEL    _IOW(BTRFS_IOCTL_MAGIC, 16, \
+				struct btrfs_ioctl_label_args)
+#define BTRFS_IOC_GET_LABEL    _IOW(BTRFS_IOCTL_MAGIC, 17, \
+				struct btrfs_ioctl_label_args)
+
 #endif

=2D--

=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart57395245.2QGtYfJttG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLQjp+vwTxYT3FBRIRAjGHAJ9f8v/OGqjswMbN9RLI5VioW+w89QCeP9Lm
9HtIV7VFigPMydrPRJ7Z19M=
=Hya3
-----END PGP SIGNATURE-----

--nextPart57395245.2QGtYfJttG--
