From: =?utf-8?b?0KTQuNC70LjQvyDQkdGA0YfQuNGb?= <brcha@gna.org>
Subject: [PATCH] (semi)revert compat.h to old version
Date: Fri, 16 Jan 2009 20:06:59 +0100
Message-ID: <200901162007.28447.brcha@gna.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1757371.NjIspM2akI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1757371.NjIspM2akI
Content-Type: multipart/mixed;
  boundary="Boundary-01=_erNcJ7tcrl8+R49"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_erNcJ7tcrl8+R49
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Without this patch btrfs doesn't compile on my system. I have Linux 2.6.27.=
8=20
on x86_64 compiled with gcc 4.1.2.

This is mostly the old compat.h with one typedef removed (typedef unsigned=
=20
__bitwise__ fmode_t;) as it was already defined on my system.

Happy hacking :)
Brcha

=2D-=20
=46ilip Br=C4=8Di=C4=87 <brcha@gna.org>
WWWeb: http://www.brcha.iz.rs
Jabber: brcha@kdetalk.net



--Boundary-01=_erNcJ7tcrl8+R49
Content-Type: text/x-patch;
  charset="utf-8";
  name="btrfs-unstable-standalone-compat.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="btrfs-unstable-standalone-compat.patch"

diff --git a/compat.h b/compat.h
index 7c4503e..204cda7 100644
=2D-- a/compat.h
+++ b/compat.h
@@ -4,4 +4,29 @@
 #define btrfs_drop_nlink(inode) drop_nlink(inode)
 #define btrfs_inc_nlink(inode)	inc_nlink(inode)
=20
+#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2, 6, 27)
+static inline struct dentry *d_obtain_alias(struct inode *inode)
+{
+	struct dentry *d;
+
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	d =3D d_alloc_anon(inode);
+	if (!d)
+		iput(inode);
+	return d;
+}
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
+# define  __pagevec_lru_add_file __pagevec_lru_add
+# define open_bdev_exclusive open_bdev_excl
+# define close_bdev_exclusive(bdev, mode) close_bdev_excl(bdev)
+/* typedef unsigned __bitwise__ fmode_t; */
+#endif
+
+
 #endif /* _COMPAT_H_ */

--Boundary-01=_erNcJ7tcrl8+R49--

--nextPart1757371.NjIspM2akI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklw2vAACgkQeugpoxYs6H+NMACgmcO/SsxrKuQlzoR/x6C1WDkG
AFkAoPevORl4Gsh/aPwo4Wdvpei+1rcX
=dJtZ
-----END PGP SIGNATURE-----

--nextPart1757371.NjIspM2akI--
