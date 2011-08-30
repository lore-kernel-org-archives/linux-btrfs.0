From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Wed, 31 Aug 2011 00:17:24 +0300
Message-ID: <20110831001724.1f6225c5@sf>
References: <20110817185619.4660.78543.stgit@localhost6>
	<20110829063416.00f4652c@sf>
	<20110830195309.4882f478@sf>
	<4E5D25BD.3020901@redhat.com>
	<20110830223116.5fc21074@sf>
	<4E5D3CC1.2090505@redhat.com>
	<4E5D3DDD.2090401@redhat.com>
	<20110830234600.27db6565@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wQGGX/hnf6642IshwfU4Exl"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110830234600.27db6565@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/wQGGX/hnf6642IshwfU4Exl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> About the second one:
>=20
> > =3D=3DThe Second Issue (aka "The Busy Looping sync()" case) =3D=3D
> > The box is different from first, so conditions are a bit different.
> > - /dev/root on / type btrfs (rw,noatime,autodefrag)
> >   (note autodefrag!)
> > - 15% full 594GB filesystem (usual nonmixed mode)
> >=20
> >    $ liferea
> >    <wait it to calm down. it does a lot of SQLite reads/writes>
> >    $ sync
> >    Got CPU is 100% loaded <hung>
>=20
> Still reproducible with 2 patches above + $SUBJ one. strace says it hangs=
 in
> strace() syscall. Stack trace is odd:
> # cat /proc/`pidof sync`/stack
> [<ffffffffffffffff>] 0xffffffffffffffff

"got" stack of the looper with such hack:
    $ while :; do sudo echo "-"; cat /proc/2304/stack | fgrep -v '[<fffffff=
fffffffff>] 0xffffffffffffffff'; done | uniq

[<ffffffff8109d39d>] find_get_pages_tag+0x14d/0x1a0
[<ffffffff81076981>] __lock_acquire+0x5a1/0xbd0
[<ffffffff8109e7bd>] filemap_fdatawait_range+0x9d/0x1b0
[<ffffffff8109e8f2>] filemap_fdatawait+0x22/0x30
[<ffffffff81106a04>] sync_inodes_sb+0x1c4/0x250
[<ffffffff8110b398>] __sync_filesystem+0x78/0x80
[<ffffffff8110b3b7>] sync_one_sb+0x17/0x20
[<ffffffff810e3fbe>] iterate_supers+0x7e/0xe0
[<ffffffff8110b400>] sys_sync+0x40/0x60
[<ffffffff81456afb>] system_call_fastpath+0x16/0x1b
-
[<ffffffff811069f1>] sync_inodes_sb+0x1b1/0x250
[<ffffffff8110b398>] __sync_filesystem+0x78/0x80
[<ffffffff8110b3b7>] sync_one_sb+0x17/0x20
[<ffffffff810e3fbe>] iterate_supers+0x7e/0xe0
[<ffffffff8110b400>] sys_sync+0x40/0x60
[<ffffffff81456afb>] system_call_fastpath+0x16/0x1b
-
[<ffffffff811069f1>] sync_inodes_sb+0x1b1/0x250
[<ffffffff8110b398>] __sync_filesystem+0x78/0x80
[<ffffffff8110b3b7>] sync_one_sb+0x17/0x20
[<ffffffff810e3fbe>] iterate_supers+0x7e/0xe0
[<ffffffff8110b400>] sys_sync+0x40/0x60
[<ffffffff81456afb>] system_call_fastpath+0x16/0x1b
-
[<ffffffff814564b6>] retint_kernel+0x26/0x30
[<ffffffff8109d398>] find_get_pages_tag+0x148/0x1a0
[<ffffffff810a7a60>] pagevec_lookup_tag+0x20/0x30
[<ffffffff8109e7bd>] filemap_fdatawait_range+0x9d/0x1b0
[<ffffffff8109e8f2>] filemap_fdatawait+0x22/0x30
[<ffffffff81106a04>] sync_inodes_sb+0x1c4/0x250
[<ffffffff8110b398>] __sync_filesystem+0x78/0x80
[<ffffffff8110b3b7>] sync_one_sb+0x17/0x20
[<ffffffff810e3fbe>] iterate_supers+0x7e/0xe0
[<ffffffff8110b400>] sys_sync+0x40/0x60
[<ffffffff81456afb>] system_call_fastpath+0x16/0x1b

Looks like dirty inode count (or dirty page count) is affected by
the $SUBJ patch.

--=20

  Sergei

--Sig_/wQGGX/hnf6642IshwfU4Exl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5dU2QACgkQcaHudmEf86rDmgCeKNS3y3nf3eXvCCtcwSBfnwQ1
YPMAn3VxD7l8EwBFFaT3FuAazX9D3gXv
=QNnC
-----END PGP SIGNATURE-----

--Sig_/wQGGX/hnf6642IshwfU4Exl--
