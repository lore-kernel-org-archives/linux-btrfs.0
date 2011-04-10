From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: btrfs does not work on usermode linux
Date: Sun, 10 Apr 2011 23:06:22 +0300
Message-ID: <20110410230622.09e965ae@sf>
References: <20110410133710.0ef34cb6@sf>
	<20110410184249.483d8d67@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9p8u0S/ktNppGhdo0t+9ezp"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110410184249.483d8d67@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/9p8u0S/ktNppGhdo0t+9ezp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > According to https://btrfs.wiki.kernel.org/index.php/Debugging_Btrfs_wi=
th_GDB
> > UML did work once.
> >=20
> > Now it corrupts data and triggers BUG_ON once you
> > start to use it. I tried both 2.6.38 and 2.6.39-rc2 (x86_64)
> > I need some help to track it down.
> >=20
> > doing 'touch `seq 1 11`; rm 11' kills the kernel:
>=20
> 2.6.36 works 2.6.37 doesn't. bsecting

Bisected down to:

commit 59daa706fbec745684702741b9f5373142dd9fdc (v2.6.36-rc2-2-g59daa70)
Author: Ma Ling <ling.ma@intel.com>
Date:   Tue Jun 29 03:24:25 2010 +0800

    x86, mem: Optimize memcpy by avoiding memory false dependece

Which means btrfs passes overlapping areas to memcpy. I've added some debug=
 info
and found out rough place:
touching files 1 .. 11
#run> touch 1 2 3 4 5 6 7 8 9 10 11
[    2.270000]  memcpy overlap detected: memcpy(dst=3D0000000070654e8a, src=
=3D0000000070654ea9, size=3D171) [delta=3D31]
[    2.270000] ------------[ cut here ]------------
[    2.270000] WARNING: at /home/slyfox/linux-2.6/fs/btrfs/memcpy_debug.c:1=
8 btrfs_memcpy+0x52/0x68()
[    2.270000] Call Trace:=20
[    2.270000] 7064b748:  [<600eff46>] map_extent_buffer+0x62/0x9e
[    2.270000] 7064b758:  [<60029ad9>] warn_slowpath_common+0x59/0x70
[    2.270000] 7064b798:  [<60029b05>] warn_slowpath_null+0x15/0x17
[    2.270000] 7064b7a8:  [<6011129e>] btrfs_memcpy+0x52/0x68
[    2.270000] 7064b7d8:  [<600efa01>] memcpy_extent_buffer+0x18d/0x1da
[    2.270000] 7064b858:  [<600efae2>] memmove_extent_buffer+0x94/0x208
[    2.270000] 7064b8d8:  [<600bc4b0>] setup_items_for_insert+0x2b8/0x426
[    2.270000] 7064b8e8:  [<600bb25a>] btrfs_leaf_free_space+0x62/0xa6
[    2.270000] 7064b9c8:  [<600c13f3>] btrfs_insert_empty_items+0xa3/0xb5
[    2.270000] 7064ba38:  [<600ce690>] insert_with_overflow+0x33/0xf1
[    2.270000] 7064ba88:  [<600ce7d4>] btrfs_insert_dir_item+0x86/0x268
[    2.270000] 7064bae8:  [<601b498b>] _raw_spin_unlock+0x9/0xb
[    2.270000] 7064bb48:  [<600ddef1>] btrfs_add_link+0x10d/0x170
[    2.270000] 7064bbc8:  [<600ddf7a>] btrfs_add_nondir+0x26/0x52
[    2.270000] 7064bc08:  [<600de73f>] btrfs_create+0xf2/0x1c0
[    2.270000] 7064bc18:  [<6007ccff>] generic_permission+0x57/0x9d
[    2.270000] 7064bc68:  [<6007cf60>] vfs_create+0x6a/0x75

which is in extent_io:copy_pages. I haven't dig further only made sure the =
following
patch below (practically converts copy_pages to move_pages). It certainly d=
oes not
look the right thing, but I don't understand extent_io contents yet to unde=
rstand what
actually happened.

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20ddb28..4cab7db 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3893,14 +3893,17 @@ static void copy_pages(struct page *dst_page, struc=
t page *src_page,
        char *src_kaddr;
=20
        if (dst_page !=3D src_page)
+       {
                src_kaddr =3D kmap_atomic(src_page, KM_USER1);
+               memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
+               kunmap_atomic(src_kaddr, KM_USER1);
+       }
        else
+       {
                src_kaddr =3D dst_kaddr;
-
-       memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
+               memmove(dst_kaddr + dst_off, src_kaddr + src_off, len);
+       }
        kunmap_atomic(dst_kaddr, KM_USER0);
-       if (dst_page !=3D src_page)
-               kunmap_atomic(src_kaddr, KM_USER1);
 }
=20
 void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_off=
set,


--=20

  Sergei

--Sig_/9p8u0S/ktNppGhdo0t+9ezp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2iDb8ACgkQcaHudmEf86qtigCfeZXGiaYt+Twe9BKhkld17Sek
SLMAn1rsgd96q9zg7v85ZUISrXWxlidO
=sIgC
-----END PGP SIGNATURE-----

--Sig_/9p8u0S/ktNppGhdo0t+9ezp--
