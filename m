From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: btrfs reads only 4k blocks -- how to improve?
Date: Fri, 17 Dec 2010 01:32:24 +0100
Message-ID: <20101217003224.GA6615@alea.gnuu.de>
References: <20101216123116.GA5073@alea.gnuu.de>
 <4D0A0E2E.5010204@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Cc: linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D0A0E2E.5010204@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Andreas Philipp hat am Thu 16. Dec, 14:03 (+0100) geschrieben:
> On 16.12.2010 13:31, J=C3=B6rg Sommer wrote:
> > When running rm -r to remove an old backup or running rsync I see the
> > average size of a read or a write request ist 4k. This leads to a very
> > bad throughput of fewer than 2MByte/s. I'm using atop to watch these
> > numbers.

> Just one probably easy question. Are you sure your partition(s) are
> aligned correctly with respect to the 4k blocks of your drive?

Good idea, but I don't use partitions on this drive.

# file -s /dev/sdb
/dev/sdb: BTRFS Filesystem (label "Backup", sectorsize 4096, nodesize 4096,=
 leafsize 4096)

Bye, J=C3=B6rg.
--=20
Je planm=C3=A4=C3=9Figer ein Mensch vorgeht,
desto st=C3=A4rker mag ihn der Zufall treffen.
		    Erich Krunau =E2=80=9ADie Physiker=E2=80=98

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0Kr5gACgkQwe0mZwH1VICm/wCdH4pnTcpVw4iOdXFxgDiQZYx5
Y60An0jyvMcRJKevm+RprEk61oTffb/H
=DF+S
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
