From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH] Re: btrfs does not work on usermode linux
Date: Sun, 10 Apr 2011 23:24:03 +0300
Message-ID: <20110410232403.617c3b7f@sf>
References: <20110410133710.0ef34cb6@sf>
	<20110410184249.483d8d67@sf>
	<20110410230622.09e965ae@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.FA=KEdj6//244_tlV_6XRK"; protocol="application/pgp-signature"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110410230622.09e965ae@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.FA=KEdj6//244_tlV_6XRK
Content-Type: multipart/mixed; boundary="MP_/y_kzw7c68tfaYVjulLFh83j"

--MP_/y_kzw7c68tfaYVjulLFh83j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, 10 Apr 2011 23:06:22 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> > > According to https://btrfs.wiki.kernel.org/index.php/Debugging_Btrfs_=
with_GDB
> > > UML did work once.
> > >=20
> > > Now it corrupts data and triggers BUG_ON once you
> > > start to use it. I tried both 2.6.38 and 2.6.39-rc2 (x86_64)
> > > I need some help to track it down.
> > >=20
> > > doing 'touch `seq 1 11`; rm 11' kills the kernel:
> >=20
> > 2.6.36 works 2.6.37 doesn't. bsecting
>=20
> Bisected down to:
>=20
> commit 59daa706fbec745684702741b9f5373142dd9fdc (v2.6.36-rc2-2-g59daa70)
> Author: Ma Ling <ling.ma@intel.com>
> Date:   Tue Jun 29 03:24:25 2010 +0800
>=20
>     x86, mem: Optimize memcpy by avoiding memory false dependece
>=20
> Which means btrfs passes overlapping areas to memcpy. I've added some deb=
ug info
> and found out rough place:
> touching files 1 .. 11
> #run> touch 1 2 3 4 5 6 7 8 9 10 11
> [    2.270000]  memcpy overlap detected: memcpy(dst=3D0000000070654e8a, s=
rc=3D0000000070654ea9, size=3D171) [delta=3D31]
> [    2.270000] ------------[ cut here ]------------
> [    2.270000] WARNING: at /home/slyfox/linux-2.6/fs/btrfs/memcpy_debug.c=
:18 btrfs_memcpy+0x52/0x68()
> [    2.270000] Call Trace:=20
> [    2.270000] 7064b748:  [<600eff46>] map_extent_buffer+0x62/0x9e
> [    2.270000] 7064b758:  [<60029ad9>] warn_slowpath_common+0x59/0x70
> [    2.270000] 7064b798:  [<60029b05>] warn_slowpath_null+0x15/0x17
> [    2.270000] 7064b7a8:  [<6011129e>] btrfs_memcpy+0x52/0x68
> [    2.270000] 7064b7d8:  [<600efa01>] memcpy_extent_buffer+0x18d/0x1da
> [    2.270000] 7064b858:  [<600efae2>] memmove_extent_buffer+0x94/0x208
> [    2.270000] 7064b8d8:  [<600bc4b0>] setup_items_for_insert+0x2b8/0x426
> [    2.270000] 7064b8e8:  [<600bb25a>] btrfs_leaf_free_space+0x62/0xa6
> [    2.270000] 7064b9c8:  [<600c13f3>] btrfs_insert_empty_items+0xa3/0xb5
> [    2.270000] 7064ba38:  [<600ce690>] insert_with_overflow+0x33/0xf1
> [    2.270000] 7064ba88:  [<600ce7d4>] btrfs_insert_dir_item+0x86/0x268
> [    2.270000] 7064bae8:  [<601b498b>] _raw_spin_unlock+0x9/0xb
> [    2.270000] 7064bb48:  [<600ddef1>] btrfs_add_link+0x10d/0x170
> [    2.270000] 7064bbc8:  [<600ddf7a>] btrfs_add_nondir+0x26/0x52
> [    2.270000] 7064bc08:  [<600de73f>] btrfs_create+0xf2/0x1c0
> [    2.270000] 7064bc18:  [<6007ccff>] generic_permission+0x57/0x9d
> [    2.270000] 7064bc68:  [<6007cf60>] vfs_create+0x6a/0x75
>=20
> which is in extent_io:copy_pages. I haven't dig further only made sure th=
e following
> patch below (practically converts copy_pages to move_pages). It certainly=
 does not
> look the right thing, but I don't understand extent_io contents yet to un=
derstand what
> actually happened.
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 20ddb28..4cab7db 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3893,14 +3893,17 @@ static void copy_pages(struct page *dst_page, str=
uct page *src_page,
>         char *src_kaddr;
> =20
>         if (dst_page !=3D src_page)
> +       {
>                 src_kaddr =3D kmap_atomic(src_page, KM_USER1);
> +               memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
> +               kunmap_atomic(src_kaddr, KM_USER1);
> +       }
>         else
> +       {
>                 src_kaddr =3D dst_kaddr;
> -
> -       memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
> +               memmove(dst_kaddr + dst_off, src_kaddr + src_off, len);
> +       }
>         kunmap_atomic(dst_kaddr, KM_USER0);
> -       if (dst_page !=3D src_page)
> -               kunmap_atomic(src_kaddr, KM_USER1);
>  }
> =20
>  void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_o=
ffset,

Attached nicer patch. Looks like original logic expected ceritain memcpy co=
py direction,
but there isn't one!

--=20

  Sergei

--MP_/y_kzw7c68tfaYVjulLFh83j
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-btrfs-properly-handle-overlapping-areas-in-memmove_e.patch

=46rom 0eaf33265f8a2e0d76ee6db1ad74ee4422efb122 Mon Sep 17 00:00:00 2001
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
 fs/btrfs/extent_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..3bbda41 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3897,6 +3897,7 @@ static void copy_pages(struct page *dst_page, struct =
page *src_page,
 	else
 		src_kaddr =3D dst_kaddr;
=20
+	BUG_ON(abs(src_off - dst_off) < len);
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
 	kunmap_atomic(dst_kaddr, KM_USER0);
 	if (dst_page !=3D src_page)
@@ -3970,7 +3971,7 @@ void memmove_extent_buffer(struct extent_buffer *dst,=
 unsigned long dst_offset,
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
-	if (dst_offset < src_offset) {
+	if (abs(dst_offset - src_offset) >=3D len) {
 		memcpy_extent_buffer(dst, dst_offset, src_offset, len);
 		return;
 	}
--=20
1.7.3.4


--MP_/y_kzw7c68tfaYVjulLFh83j--

--Sig_/.FA=KEdj6//244_tlV_6XRK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2iEecACgkQcaHudmEf86rc2QCfV5fIrHplxValBJSjOewcSQ53
JpIAn3wSTjpuJJyyajZCMO2nR7hyX5Q9
=t8RP
-----END PGP SIGNATURE-----

--Sig_/.FA=KEdj6//244_tlV_6XRK--
