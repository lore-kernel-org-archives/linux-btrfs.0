Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44516 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaJBRjh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 13:39:37 -0400
Date: Thu, 2 Oct 2014 18:39:32 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Marc Dietrich <marvin24@gmx.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: FIBMAP unsupported
Message-ID: <20141002173932.GA30783@carfax.org.uk>
References: <6602102.lhBckFYBLs@fb07-iapwap2>
 <20141002172549.GV11436@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <20141002172549.GV11436@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 07:25:49PM +0200, David Sterba wrote:
> On Thu, Oct 02, 2014 at 05:13:22PM +0200, Marc Dietrich wrote:
> > I have a large (25G) virtual disk on a btrfs fs. Yes, I know this is no=
t=20
> > optimial. So I try to defrag it from time to time. However, using "btrf=
s fi=20
> > defrag -c vm.vdi" results in even more fragments than before (reported =
by=20
> > filefrag). So I wrote my own pseudo defragger,
>=20
> Unfortunatelly the default target fragment size is 256k. Try
> 'btrfs filesystem defrag -t 32m ...' or higher numbers and see if it
> helps.

   Note also that a compressed file will have fragments on the scale
of about 128k reported by filefrag, because of the way that the
compression works. The file may actually be contiguous, but filefrag
won't know about it. (At least, that's historically been the case. I
don't know if filefrag has recently grown some extra knowledge of
compressed extents.)

   Hugo.

> > which produces much better results (ok, the file must not be in use).=
=20
> > Somewhere in the 3.17 cycle the resulting image got corrupted using the=
 script=20
> > above.=20
> >=20
> > Running filefrag on it returns "FIBMAP unsupported".
>=20
> This message doe not mean it is a corruption, but filefrag tries to use
> the FIBMAP ioctl that is not implemented on btrfs, instead FIEMAP is
> used.
>=20
> filefrag on a nocow file works for me here (3.16.x kernel), I can see
> that filefrag on a directory prints the FIBMAP message.
>=20
> > Virtualbox returns  "AHCI#0P0: Read at offset 606236672 (49152 bytes le=
ft)=20
> > returned rc=3DVERR_DEV_IO_ERROR". No errors in the kernel log.
> >=20
> > Trying "cp vm.vdi /dev/null" returns: cp: Error reading =E2=80=9Evm.vdi=
=E2=80=9C: IO-Error
>=20
> This could be caused by the virtualization layer. Try to run scrub and
> fsck in the non-destru^Wchecking mode if it finds problems.
>=20
> As you're using compression and autodefrag, a quick skim of the 3.17
> patches points to e9512d72e8e61c750c90efacd720abe3c4569822 "fix
> autodefrag with compression", but that's just "keyword" match.
>=20
> There's another report about nocow corruption and VirtualBox in a 3.16 +
> for-linus version (which is almost 3.17-rc)
> http://article.gmane.org/gmane.comp.file-systems.btrfs/38701/
>=20
> But according to the attached messages, the underlying device is
> unreliable and logs a lot of IO errors.
>=20
> For now it looks like VirutalBox is not writing the data or there is a
> bug introduced post 3.16 killing nocow files.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---         =20
                         darkness bind(2) them.                         =20

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVC2N1FheFHXiqx3kAQJvzxAAsGXr4h/DtVGE4T3mK4SLWam+4kdIHkd+
mJHFkmZD6PFPM13rbIpG0iS9srca6X+bf5feoJvqIIEWH3TRBxn1+BPl6kKJG6tM
NjMlpWtxtJtkuEVC6h0rJcQEKBtZUwXZeba1mlxv/vC2JxVkfhcyuwwdpvzjdJjf
cHqP2KZw3z+mbDeN9NVE8DSgzqmGlCok2tgcpIFgpsz/y8o9/zrZzfqDXY6nVFd4
ZsYD0cAxEfHz+Lvn1NUCu9ab0QMx8zblgvRkipibcRJsP02iHB2l3GuP9skZ7X6/
cJ6o7HO56Trlu0DX025kZ9Xan9XS91A1v4psRWkx4psM5fiy2jxHMYtJPd5dxyW4
pfLnSTUfM7xZvMu/sMui/JXmddvq1F9qdokYxt0rZmTfnMd1AV8sVReTBOOIWouE
kcSetXKdrVwha03hrp481iXsjWsVCUqrNyPB4+m00LZRJ2OrEipfNsi71uqHo1ay
Zn5QKvld8sZipqe3Xnnteba14UshPOBGFwO/MAzBKpNZxKBjjjgvyCCjZuHox2o2
Ym7jHj6OM4j3FVrZCTE9Jws4fozcrRZBo30iwQqkiMV7Q9d1d2uIPvoksWteannR
dRnDAJxI0jDdQ2VENg3hWB5LbLnD8ozxaePRU1irfGCV64PoMD+Ks8wP3RKg9+1x
lMBvUX5YVlY=
=mTE4
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
