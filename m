From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Announcing btrfs-gui
Date: Fri, 3 Jun 2011 22:48:53 +0100
Message-ID: <20110603214853.GA25614@carfax.org.uk>
References: <20110601232058.GA22619@carfax.org.uk>
 <BANLkTin_2u0VmmAJXVKnA_s3LuCkoKt29Q@mail.gmail.com>
 <20110602084108.GB8002@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
To: "Fajar A. Nugraha" <list@fajar.net>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110602084108.GB8002@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2011 at 09:41:08AM +0100, Hugo Mills wrote:
> On Thu, Jun 02, 2011 at 03:31:16PM +0700, Fajar A. Nugraha wrote:
> > On Thu, Jun 2, 2011 at 6:20 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > > =A0 Over the last few weeks, I've been playing with a foolish idea,
> > > mostly triggered by a cluster of people being confused by btrfs's free
> > > space reporting (df vs btrfs fi df vs btrfs fi show). I also wanted an
> > > excuse, and some code, to mess around in the depths of the FS data
> > > structures.
> > >
> > > =A0 Like all silly ideas, this one got a bit out of hand, and seems to
> > > have turned into something vaguely useful. I'm therefore pleased to
> > > announce the first major public release of btrfs-gui[1]: a point-and-
> > > click tool for managing btrfs filesystems.
> > >
> > > =A0 The tool currently can scan for and list btrfs filesystems and the
> > > volumes they live on. It can show the allocation and usage of data in
> > > a selected filesystem, categorised by use, replication, and device. It
> > > can show and manipulate subvolumes and snapshots: creation, deletion,
> > > and setting the default.
> >=20
> >=20
> > Some comments:
> > (1) Currently it needs to be run from the directory where it's
> > downloaded, even after a "python3 setup.py install". When run from
> > other directory, it bails with
[snip]
> > OSError: [Errno 2] No such file or directory: './btrfs-gui-helper'
> >=20
> > Is this intentional?
>=20
>    No, and will be fixed later today. I forsee an emergency 0.2.1
> coming shortly. :)

   OK, it's fixed in git in the stable-v0.2 branch. Unless anyone else
reports something that needs fixing over the weekend, I'll tag it as
0.2.1 on Sunday and roll another release tarball.

   (The fix is actually pretty ugly, and has some poor UX in it for
one case, but I've run out of brain this evening, and can't face the
shell hackery necessary to do it nicely right now.)

> > (2) When showing space usage for a single-device FS, selecting "Show
> > unallocated space as raw space", why is the top and bottom graph
> > different? Shouldn't it be the same, since there's only one device?
>=20
>    Good question. I shall investigate what's going on.

   OK, on investigation and reflection, it shouldn't be identical,
because metadata is DUP. The per-disk displays show actual physical
disk usage; the filesystem display at the top shows unique
data. Therefore, the top display will show half the amount of metadata
than the bottom.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Comic Sans goes into a bar,  and the barman says, "We don't ---  =20
                         serve your type here."                         =20

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN6VbFIKyzvlFcI40RAr7cAJ9XeG1AkKJD6U1X6l5D7GYhClVoKQCeNj9P
z1jRRU1qwLDdFW/TUdpvcT0=
=Co4p
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
