From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH v2] Re: btrfs does not work on usermode linux
Date: Sun, 10 Apr 2011 23:58:46 +0300
Message-ID: <20110410235846.135e801e@sf>
References: <20110410133710.0ef34cb6@sf>
	<20110410184249.483d8d67@sf>
	<20110410230622.09e965ae@sf>
	<20110410232403.617c3b7f@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FX.hsUBz0bUr_NIm8b1sge0"; protocol="application/pgp-signature"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110410232403.617c3b7f@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/FX.hsUBz0bUr_NIm8b1sge0
Content-Type: multipart/mixed; boundary="MP_/EcofZ+/MF18ur18f/66Fd3E"

--MP_/EcofZ+/MF18ur18f/66Fd3E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, 10 Apr 2011 23:24:03 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> Fix data corruption caused by memcpy() usage on overlapping data.
> I've observed it first when found out usermode linux crash on btrfs.

Changes since v1:

>  	else
>  		src_kaddr =3D dst_kaddr;
> =20
> +	BUG_ON(abs(src_off - dst_off) < len);
>  	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);

Too eager BUG_ON. Now used only for src_page =3D=3D dst_page.

> -	if (dst_offset < src_offset) {
> +	if (abs(dst_offset - src_offset) >=3D len) {

abs() is not a good thing to use un unsigned values. aded helper overlappin=
g_areas.

--=20

  Sergei

--MP_/EcofZ+/MF18ur18f/66Fd3E
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-btrfs-properly-handle-overlapping-areas-in-memmove_e.patch

=46rom 2ac9dd9cc54cee51c5c5219e35cca18a9f3f3a3f Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <slyfox@gentoo.org>
Date: Sun, 10 Apr 2011 23:19:53 +0300
Subject: [PATCH] btrfs: properly handle overlapping areas in memmove_extent=
_buffer
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Fix data corruption caused by memcpy() usage on overlapping data.
I've observed it first when found out usermode linux crash on btrfs.

=D0=A1all chain is the following:
------------[ cut here ]------------
WARNING: at /home/slyfox/linux-2.6/fs/btrfs/extent_io.c:3900 memcpy_extent_=
buffer+0x1a5/0x219()
Call Trace:
6fa39a58:  [<601b495e>] _raw_spin_unlock_irqrestore+0x18/0x1c
6fa39a68:  [<60029ad9>] warn_slowpath_common+0x59/0x70
6fa39aa8:  [<60029b05>] warn_slowpath_null+0x15/0x17
6fa39ab8:  [<600efc97>] memcpy_extent_buffer+0x1a5/0x219
6fa39b48:  [<600efd9f>] memmove_extent_buffer+0x94/0x208
6fa39bc8:  [<600becbf>] btrfs_del_items+0x214/0x473
6fa39c78:  [<600ce1b0>] btrfs_delete_one_dir_name+0x7c/0xda
6fa39cc8:  [<600dad6b>] __btrfs_unlink_inode+0xad/0x25d
6fa39d08:  [<600d7864>] btrfs_start_transaction+0xe/0x10
6fa39d48:  [<600dc9ff>] btrfs_unlink_inode+0x1b/0x3b
6fa39d78:  [<600e04bc>] btrfs_unlink+0x70/0xef
6fa39dc8:  [<6007f0d0>] vfs_unlink+0x58/0xa3
6fa39df8:  [<60080278>] do_unlinkat+0xd4/0x162
6fa39e48:  [<600517db>] call_rcu_sched+0xe/0x10
6fa39e58:  [<600452a8>] __put_cred+0x58/0x5a
6fa39e78:  [<6007446c>] sys_faccessat+0x154/0x166
6fa39ed8:  [<60080317>] sys_unlink+0x11/0x13
6fa39ee8:  [<60016b80>] handle_syscall+0x58/0x70
6fa39f08:  [<60021377>] userspace+0x2d4/0x381
6fa39fc8:  [<60014507>] fork_handler+0x62/0x69
---[ end trace 70b0ca2ef0266b93 ]---

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09302.html

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/extent_io.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..786a0f7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3878,31 +3878,40 @@ static void move_pages(struct page *dst_page, struc=
t page *src_page,
 		char *s =3D src_kaddr + src_off + len;
=20
 		while (len--)
 			*--p =3D *--s;
=20
 		kunmap_atomic(src_kaddr, KM_USER1);
 	}
 	kunmap_atomic(dst_kaddr, KM_USER0);
 }
=20
+static inline bool areas_overlap(unsigned long src, unsigned long dst, uns=
igned long len)
+{
+	unsigned long distance =3D (src > dst) ? src - dst : dst - src;
+	return distance < len;
+}
+
 static void copy_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long dst_off, unsigned long src_off,
 		       unsigned long len)
 {
 	char *dst_kaddr =3D kmap_atomic(dst_page, KM_USER0);
 	char *src_kaddr;
=20
 	if (dst_page !=3D src_page)
 		src_kaddr =3D kmap_atomic(src_page, KM_USER1);
 	else
+	{
 		src_kaddr =3D dst_kaddr;
+		BUG_ON(areas_overlap(src_off, dst_off, len));
+	}
=20
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
 	kunmap_atomic(dst_kaddr, KM_USER0);
 	if (dst_page !=3D src_page)
 		kunmap_atomic(src_kaddr, KM_USER1);
 }
=20
 void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_off=
set,
 			   unsigned long src_offset, unsigned long len)
 {
@@ -3963,21 +3972,21 @@ void memmove_extent_buffer(struct extent_buffer *ds=
t, unsigned long dst_offset,
 	if (src_offset + len > dst->len) {
 		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
 		       "len %lu len %lu\n", src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
 		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
-	if (dst_offset < src_offset) {
+	if (!areas_overlap(src_offset, dst_offset, len)) {
 		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
 		return;
 	}
 	while (len > 0) {
 		dst_i =3D (start_offset + dst_end) >> PAGE_CACHE_SHIFT;
 		src_i =3D (start_offset + src_end) >> PAGE_CACHE_SHIFT;
=20
 		dst_off_in_page =3D (start_offset + dst_end) &
 			((unsigned long)PAGE_CACHE_SIZE - 1);
 		src_off_in_page =3D (start_offset + src_end) &
--=20
1.7.3.4


--MP_/EcofZ+/MF18ur18f/66Fd3E--

--Sig_/FX.hsUBz0bUr_NIm8b1sge0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2iGgkACgkQcaHudmEf86o/aACbBSV4L0OfSmOBd7gki3LUV5dD
7gYAn2hrV77jI/nXlJmBarVTqyqqXWk2
=fx8q
-----END PGP SIGNATURE-----

--Sig_/FX.hsUBz0bUr_NIm8b1sge0--
