From: Peter Stuge <peter@stuge.se>
Subject: Re: Damaged super block / fs root
Date: Mon, 30 May 2011 21:23:31 +0200
Message-ID: <20110530192331.6147.qmail@stuge.se>
References: <4DE3BEFA.7080106@ftml.net> <20110530161216.GA8002@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Cc: Hugo Mills <hugo@carfax.org.uk>,
	Dennis Bergmann <d.bergmann@ftml.net>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110530161216.GA8002@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hugo Mills wrote:
>    You can check whether it's likely to be of use by running "btrfsck
> -s 1" on your filesystem. If it passes OK, then btrfs-select-super
> should be useful.

Inspired by this I cloned latest btrfs-progs-unstable and tried it on
my broken 60-something GB btrfs, but no luck:

$ btrfsck -s 0 /dev/sdb2
using SB copy 0, bytenr 65536
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' fail=
ed.
Aborted
$ btrfsck -s 1 /dev/sdb2
using SB copy 1, bytenr 67108864
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' fail=
ed.
Aborted
$ btrfsck -s 2 /dev/sdb2
using SB copy 2, bytenr 274877906944
No valid Btrfs found on /dev/sdb2
$=20


I created an empty 384 MB btrfs:

$ dd if=3D/dev/zero of=3D/tmp/test_fs bs=3D1024k count=3D384
$ mkfs.btrfs /tmp/test_fs
$=20

And then I compare output from btrfs-debug-tree between test_fs and
my broken one:

$ strace -e pread64 btrfs-debug-tree /tmp/test_fs 2>&1 | sed 's-,"\(.\{5\}\=
).*"-, "\1"-'
pread64(3, "\351\"..., 2859, 65536) =3D 2859
pread64(3, "I\227"..., 2859, 67108864) =3D 2859
pread64(3, ""..., 2859, 274877906944)   =3D 0
pread64(5, "\351\"..., 2859, 65536) =3D 2859
pread64(5, "I\227"..., 2859, 67108864) =3D 2859
pread64(5, ""..., 2859, 274877906944)   =3D 0
pread64(5, "\37\2"..., 4096, 20971520) =3D 4096
pread64(5, "\311\"..., 4096, 37752832) =3D 4096
pread64(5, "\247C"..., 4096, 37756928) =3D 4096
pread64(5, "\225\"..., 4096, 37761024) =3D 4096
pread64(5, "\210z"..., 4096, 37765120) =3D 4096
pread64(5, "\3\34"..., 4096, 37748736) =3D 4096
root tree
leaf 29364224 items 9 free space 2349 generation 7 owner 1
fs uuid d29c2f7a-0a4e-4a1d-8458-2d241f6f29de
chunk uuid fb34ff75-1cb6-4974-af37-e0a464135216
        item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 3756 itemsize 239
                root data bytenr 29368320 level 0 dirid 0 refs 1
        item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 3517 itemsize 239
                root data bytenr 29372416 level 0 dirid 0 refs 1
=2E..

$ strace -e pread64 btrfs-debug-tree /dev/sdb2 2>&1 | sed 's-, "\(.\{5\}\).=
*"-, "\1"-'
pread64(3, "p\23{"..., 2859, 65536) =3D 2859
pread64(3, "\320r"..., 2859, 67108864) =3D 2859
pread64(3, ""..., 2859, 274877906944)   =3D 0
pread64(5, "p\23{"..., 2859, 65536) =3D 2859
pread64(5, "\320r"..., 2859, 67108864) =3D 2859
pread64(5, ""..., 2859, 274877906944)   =3D 0
pread64(5, "\353$"..., 4096, 20971520) =3D 4096
pread64(5, "\275\"..., 4096, 20987904) =3D 4096
pread64(5, "\253\"..., 4096, 20983808) =3D 4096
pread64(5, "\0\0\"..., 4096, 36675878912) =3D 4096
pread64(5, "\0\0\"..., 4096, 36675878912) =3D 4096
pread64(5, "\0\0\"..., 4096, 36944314368) =3D 4096
btrfs-debug-tree: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->no=
de)' failed.
--- SIGABRT (Aborted) @ 0 (0) ---
+++ killed by SIGABRT +++

I also tried the btrfsck again:

$ strace -e pread64 btrfsck -s 0 /dev/sdb2 2>&1 | sed 's-, "\(.\?.\?.\?\).*=
"-, "\1"-'
pread64(3, "p\2"..., 2859, 65536) =3D 2859
pread64(3, "\32"..., 2859, 67108864) =3D 2859
pread64(3, ""..., 2859, 274877906944)   =3D 0
pread64(3, "p\2"..., 2859, 65536) =3D 2859
pread64(3, "\32"..., 2859, 67108864) =3D 2859
pread64(3, ""..., 2859, 274877906944)   =3D 0
pread64(5, "p\2"..., 2859, 65536) =3D 2859
pread64(5, "\32"..., 2859, 67108864) =3D 2859
pread64(5, ""..., 2859, 274877906944)   =3D 0
pread64(5, "\35"..., 4096, 20971520) =3D 4096
pread64(5, "\27"..., 4096, 20987904) =3D 4096
pread64(5, "\25"..., 4096, 20983808) =3D 4096
pread64(5, "\0\"..., 4096, 36675878912) =3D 4096
pread64(5, "\0\"..., 4096, 36675878912) =3D 4096
pread64(5, "\0\"..., 4096, 36944314368) =3D 4096
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' fail=
ed.
using SB copy 0, bytenr 65536
--- SIGABRT (Aborted) @ 0 (0) ---
+++ killed by SIGABRT +++
$ strace -e pread64 btrfsck -s 1 /dev/sdb2 2>&1 | sed 's-, "\(.\?.\?.\?\).*=
"-, "\1"-'
pread64(3, "p\2"..., 2859, 65536) =3D 2859
pread64(3, "\32"..., 2859, 67108864) =3D 2859
pread64(3, ""..., 2859, 274877906944)   =3D 0
pread64(3, "\32"..., 2859, 67108864) =3D 2859
pread64(5, "\32"..., 2859, 67108864) =3D 2859
pread64(5, "\35"..., 4096, 20971520) =3D 4096
pread64(5, "\27"..., 4096, 20987904) =3D 4096
pread64(5, "\25"..., 4096, 20983808) =3D 4096
pread64(5, "\0\"..., 4096, 36675878912) =3D 4096
pread64(5, "\0\"..., 4096, 36675878912) =3D 4096
pread64(5, "\0\"..., 4096, 36944314368) =3D 4096
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' fail=
ed.
using SB copy 1, bytenr 67108864
--- SIGABRT (Aborted) @ 0 (0) ---
+++ killed by SIGABRT +++
$ strace -e pread64 btrfsck -s 2 /dev/sdb2 2>&1 | sed 's-, "\(.\?.\?.\?\).*=
"-, "\1"-'
pread64(3, "p\2"..., 2859, 65536) =3D 2859
pread64(3, "\32"..., 2859, 67108864) =3D 2859
pread64(3, ""..., 2859, 274877906944)   =3D 0
pread64(3, ""..., 2859, 274877906944)   =3D 0
No valid Btrfs found on /dev/sdb2
using SB copy 2, bytenr 274877906944
$=20


Does this give any hint about how the tree has been broken?


//Peter

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN4+6zhR3Q0dhIfEgRAqJxAJsEWNkoCc2PrncY13G9Zx83cgJd4ACghenr
v5qPmzJiYtL7fWPqqrocPLA=
=ZafW
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
