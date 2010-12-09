From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: What to do about subvolumes?
Date: Thu, 9 Dec 2010 20:53:29 +0100
Message-ID: <201012092053.40494.Martin@lichtvoll.de>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <1291219269-sup-8392@think> <20101201163157.GB30236@glandium.org> (sfid-20101201_182451_942865_0E7E9AAE)
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2226717.64kRsN8YSO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>,
	C Anthony Risinger <anthony@extof.me>,
	Josef Bacik <josef@redhat.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, ssorce <ssorce@redhat.com>
To: Mike Hommey <mh@glandium.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201163157.GB30236@glandium.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2226717.64kRsN8YSO
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 01 Dezember 2010 schrieb Mike Hommey:
> On Wed, Dec 01, 2010 at 11:01:37AM -0500, Chris Mason wrote:
> > Excerpts from C Anthony Risinger's message of 2010-12-01 09:51:55=20
=2D0500:
> > > On Wed, Dec 1, 2010 at 8:21 AM, Josef Bacik <josef@redhat.com>=20
wrote:
> > > > =3D=3D=3D How do we want subvolumes to work from a user perspective?
> > > > =3D=3D=3D
> > > >=20
> > > > 1) Users need to be able to create their own subvolumes. =C2 The
> > > > permission semantics will be absolutely the same as creating
> > > > directories, so I don't think this is too tricky. =C2 We want this
> > > > because you can only take snapshots of subvolumes, and so it is
> > > > important that users be able to create their own discrete
> > > > snapshottable targets.
> > > >=20
> > > > 2) Users need to be able to snapshot their subvolumes. =C2 This is
> > > > basically the same as #1, but it bears repeating.
> > >=20
> > > could it be possible to convert a directory into a volume?  or at
> > > least base a snapshot off it?
> >=20
> > I'm afraid this turns into the same complexity as creating a new
> > volume and copying all the files/dirs in by hand.
>=20
> Except you wouldn't have to copy data, only metadata.

And it could probably be race-free. If I'd  cp -reflink or rsync stuff from=
=20
a real directory to a subvolume and then rename the old directory to an=20
other name and the subvolume to the directory name then I might be missing=
=20
files that have been created during the copy process and missing changes to=
=20
files that have been already copied.

What I would like is an easy way to make ~/.kde or whatever a subvolume to=
=20
be able to snapshot it independently while KDE applications or whatever is=
=20
using and writing to it, *without* any userland even noticing it and=20
without - except for metadata for managing the subvolume - any additional=20
space consumption.

So

deepdance:/#12> btrfs subvolume create /home/martin/.kde
ERROR: '/home/martin/.kde' exists

would just make a subvolume out of ~/.kde even if it needs splitting out=20
the tree or even copying the tree data into a new tree.

There are other filesystem operations like btrfs filesystem balance that ca=
n=20
be expensive as well.

All that said from a user point of view. Maybe technical its not feasible.=
=20
But it would be nice if it can be made feasible without loosing existing=20
advantages.

And maybe

deepdance:/> btrfs subvolume create .  =20
ERROR: '.' exists

should really remain this way ;).

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2226717.64kRsN8YSO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk0BM7oACgkQmRvqrKWZhMcL3ACfS/uMzC3cYkmoRhzLhgrt8FJD
TqwAoLYbKLXuzsY/8FQhXQ3t4TJom5y2
=3G5w
-----END PGP SIGNATURE-----

--nextPart2226717.64kRsN8YSO--
