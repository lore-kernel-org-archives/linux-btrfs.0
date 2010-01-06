From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: snapshot/subvolume removal
Date: Wed, 6 Jan 2010 07:54:12 +0100
Message-ID: <201001060754.18256@fortytwo.ch>
References: <4B43AC9B.5030109@cs.bgu.ac.il> <4B43D9AB.1090606@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2261016.2nDFC23W8y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B43D9AB.1090606@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2261016.2nDFC23W8y
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 06 January 2010 01.30:35 TARUISI Hiroaki wrote:
> In creating snapshots, the last argument implies the directory
> where subvolume is to be created, but in taking snapshots,
> the last argument implies subvolume we take snapshot of, and
> snapshots are created under current directory.
>=20

This was a bit confusing to me at first, too.  (But obviously '-s' needs th=
e=20
input which volume to take the snapshot from.)

Would it be a good idea to make btrfsctl -s fail if the last argument is no=
t=20
the root of a subvolume?  That way, the directory given to "btrfsctl -s"=20
would always match what ends up in a snapshot.  (It is a bit strange for=20
people who are not familiar with btrfs to do "btrfsctl -s snap=20
some/directory/somewhere" and then realize that the snapshot is created fro=
m=20
"some" and not from "somewhere" because "some" is the subvolume root.)

cheers
=2D- vbi

=2D-=20
Pushing 40 is exercise enough.

--nextPart2261016.2nDFC23W8y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktEM5VgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6MkIAn1sEHjkAGLMxgjK1p0IOPvHB
aHEwAJ44fWlmbWzq36RaLZ8oEv+OnUcz0w==
=t0w0
-----END PGP SIGNATURE-----

--nextPart2261016.2nDFC23W8y--
