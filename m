From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH v3] Re: btrfs does not work on usermode linux
Date: Mon, 11 Apr 2011 22:44:52 +0300
Message-ID: <20110411224452.4a5149da@sf>
References: <20110410133710.0ef34cb6@sf>
	<20110410184249.483d8d67@sf>
	<20110410230622.09e965ae@sf>
	<20110410232403.617c3b7f@sf>
	<20110410235846.135e801e@sf>
	<4DA32055.2030104@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lV_seQNuRb.0VNtfDBHm17e"; protocol="application/pgp-signature"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	cwillu <cwillu@cwillu.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA32055.2030104@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/lV_seQNuRb.0VNtfDBHm17e
Content-Type: multipart/mixed; boundary="MP_//ppKimAvLPQwLibM5q0rHR/"

--MP_//ppKimAvLPQwLibM5q0rHR/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Fix data corruption caused by memcpy() usage on overlapping data.
> I've observed it first when found out usermode linux crash on btrfs. =20

Changes since v2:
- Code style cleanup
- 2 versions of patch: BUG_ON and WARN_ON variants,
  _but_ see below why I prefer BUG_ON

Changes since v1:

>  	else
>  		src_kaddr =3D dst_kaddr;
> =20
> +	BUG_ON(abs(src_off - dst_off) < len);
>  	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len); =20

Too eager BUG_ON. Now used only for src_page =3D=3D dst_page.

> -	if (dst_offset < src_offset) {
> +	if (abs(dst_offset - src_offset) >=3D len) { =20

abs() is not a good thing to use un unsigned values. aded helper overlappin=
g_areas.

On Mon, 11 Apr 2011 11:37:57 -0400
Josef Bacik <josef@redhat.com> wrote:

> +	{
> you will want to turn that into
>=20
> if (dst_page !=3D src_page) {

done

> Also maybe BUG_ON() is a little strong, since the kernel will do this=20
> right, it just screws up UML.  So maybe just do a WARN_ON() so we notice=
=20
> it.  Thanks,

I'm afaid I didn't understand this part. The commit I've found a deviation
was linux's implementation of memcpy (UML uses it as kernel does). Why the
kernel differs to UML in that respect? Seems I don't know/understand someth=
ing
fundamental here.
So, if data overlaps - it's a moment before data corruption, thus BUG_ON.

Another thought is (if memcpy semantics differ from standard C's function):
does linux's memcpy guarantee copying direction behaviour?
If it does, then it's really a weird memmove and x86/memcpy_64.S is a bit b=
roken.

Attached both patches, I personally like BUG_ON variant.
Pick the one you like more :]

Thanks for the feedback!

--=20

  Sergei

--MP_//ppKimAvLPQwLibM5q0rHR/
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=BUG_ON-0001-btrfs-properly-handle-overlapping-areas-in-memmove_e.patch

=46rom aaaf03ebcdee3f65e898016b14bc81c66bfdd31c Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <slyfox@gentoo.org>
Date: Sun, 10 Apr 2011 23:19:53 +0300
Subject: [PATCH 1/2] btrfs: properly handle overlapping areas in memmove_ex=
tent_buffer
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
 fs/btrfs/extent_io.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..10db989 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3885,6 +3885,12 @@ static void move_pages(struct page *dst_page, struct=
 page *src_page,
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
@@ -3892,10 +3898,12 @@ static void copy_pages(struct page *dst_page, struc=
t page *src_page,
 	char *dst_kaddr =3D kmap_atomic(dst_page, KM_USER0);
 	char *src_kaddr;
=20
-	if (dst_page !=3D src_page)
+	if (dst_page !=3D src_page) {
 		src_kaddr =3D kmap_atomic(src_page, KM_USER1);
-	else
+	} else {
 		src_kaddr =3D dst_kaddr;
+		BUG_ON(areas_overlap(src_off, dst_off, len));
+	}
=20
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
 	kunmap_atomic(dst_kaddr, KM_USER0);
@@ -3970,7 +3978,7 @@ void memmove_extent_buffer(struct extent_buffer *dst,=
 unsigned long dst_offset,
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
-	if (dst_offset < src_offset) {
+	if (!areas_overlap(src_offset, dst_offset, len)) {
 		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
 		return;
 	}
--=20
1.7.3.4


--MP_//ppKimAvLPQwLibM5q0rHR/
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=WARN_ON-0001-btrfs-properly-handle-overlapping-areas-in-memmove_e.patch

=46rom 51602c049c4583fc7b1ef454f630138f12dba70e Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <slyfox@gentoo.org>
Date: Sun, 10 Apr 2011 23:19:53 +0300
Subject: [PATCH 1/2] btrfs: properly handle overlapping areas in memmove_ex=
tent_buffer
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
 fs/btrfs/extent_io.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..2655aef 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3885,6 +3885,12 @@ static void move_pages(struct page *dst_page, struct=
 page *src_page,
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
@@ -3892,10 +3898,12 @@ static void copy_pages(struct page *dst_page, struc=
t page *src_page,
 	char *dst_kaddr =3D kmap_atomic(dst_page, KM_USER0);
 	char *src_kaddr;
=20
-	if (dst_page !=3D src_page)
+	if (dst_page !=3D src_page) {
 		src_kaddr =3D kmap_atomic(src_page, KM_USER1);
-	else
+	} else {
 		src_kaddr =3D dst_kaddr;
+		WARN_ON(areas_overlap(src_off, dst_off, len));
+	}
=20
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
 	kunmap_atomic(dst_kaddr, KM_USER0);
@@ -3970,7 +3978,7 @@ void memmove_extent_buffer(struct extent_buffer *dst,=
 unsigned long dst_offset,
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
-	if (dst_offset < src_offset) {
+	if (!areas_overlap(src_offset, dst_offset, len)) {
 		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
 		return;
 	}
--=20
1.7.3.4


--MP_//ppKimAvLPQwLibM5q0rHR/--

--Sig_/lV_seQNuRb.0VNtfDBHm17e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2jWj4ACgkQcaHudmEf86pwUACcCMjuMzXC2geNc+3e/aKjafPM
S2wAn24xUlTLa6Iu5npH5lm8kvtyE/VE
=ZgCZ
-----END PGP SIGNATURE-----

--Sig_/lV_seQNuRb.0VNtfDBHm17e--
