From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mkfs.btrfs fails on ARM
Date: Fri, 17 Feb 2012 00:51:26 +0600
Message-ID: <20120217005126.7beebd82@natsu>
References: <20120216220811.534cbf02@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fFu0OSkpKNojsQfEvKCNHHv"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120216220811.534cbf02@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fFu0OSkpKNojsQfEvKCNHHv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Feb 2012 22:08:11 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> # mkfs.btrfs /dev/loop7=20
>=20
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>=20
> mkfs.btrfs: volumes.c:1575: btrfs_read_chunk_tree: Assertion `!(ret)' fai=
led.
> Aborted

I reran the command on a 1GB loop device (with the same result), and here is
its gzipped image: http://media.romanrm.ru/tmp/btrfs-made-on-arm.img.gz (1M=
B)

This can't be opened by btrfsck with the same error message, and on amd64 t=
oo.

btrfsck: volumes.c:1575: btrfs_read_chunk_tree: Assertion `!(ret)' failed.

So the problem is clearly with mkfs on ARM, creating an invalid FS.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/fFu0OSkpKNojsQfEvKCNHHv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk89UC4ACgkQTLKSvz+PZwggSwCbBH3rqh4FD8HSW2/nhYkGUfUR
6TUAmwUVI6QNMM/TgwPftgU3ysYgrNpf
=fHrV
-----END PGP SIGNATURE-----

--Sig_/fFu0OSkpKNojsQfEvKCNHHv--
