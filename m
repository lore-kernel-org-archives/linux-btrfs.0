From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: version (was: btrfs, broken design?)
Date: Fri, 21 Jan 2011 12:21:19 +0000
Message-ID: <20110121122119.GA811@carfax.org.uk>
References: <1295558324-sup-1046@think>
 <BeHcMN1T1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BeHcMN1T1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 21, 2011 at 10:54:00AM +0100, Helmut Hullen wrote:
> Hallo, Chris,
>=20
> Du meintest am 20.01.11:
>=20
> >> Is there a planned date for the final release of btrfs?
>=20
> > A final release?  We'll keep improving things for a long time.  The
> > biggest missing feature today is btrfsck, which I'm working on full
> > time right now.
>=20
> Could it be possible to tell somewhere the actual version?
>=20
> Sometimes I download via git,
>=20
>  <git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstabl=
e.git>

> and I never have found which version that is; "version.sh" tells =20
> something wrong.

$ git log

   then look at the revision ID of the top commit -- that's the
closest thing to a version number we've got. When you build from the
git repository, the version number that the tools report will be
something like 0.19-36-g70c6c10. This means that it's 36 commits on
=66rom the version tagged as 0.19, and the last commit was g70c6c10.

   (This is for the userspace tools, of course -- the kernel has a
similar numbering scheme, if you're not building from Linus's tagged
versions).

> And I never have seen somethin like "Changelog" - that would be fine =20
> too.

$ git log

   :)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---      =20

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOXo/IKyzvlFcI40RAr/QAKCBaZcvVoqP9mgztJ7ZxzCW0lba0wCeK8vU
dJw18K4IBuyj7FKnhRjP1LM=
=u/6l
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
