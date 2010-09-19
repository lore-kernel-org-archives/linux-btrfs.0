From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Question of stability
Date: Sun, 19 Sep 2010 10:51:15 +0100
Message-ID: <20100919095115.GA2356@selene>
References: <AANLkTi=2yBAg=w88irVvd0rZP05vDFRQwjMxTZsXvYU4@mail.gmail.com>
 <4391908.129.1284854134163.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Cc: Hendrik Fabelje <hendrik@fabelje.de>, linux-btrfs@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4391908.129.1284854134163.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2010 at 01:55:34AM +0200, Roy Sigurd Karlsbakk wrote:
> ----- Original Message -----
> > On Sat, Sep 18, 2010 at 11:37 PM, Roy Sigurd Karlsbakk
> > <roy@karlsbakk.net> wrote:
> > > Hi all
> > >
> > > I've been on this list for a year or so, and I have been following
> > > progress for some more. Are there any chances of btrfs >stabilizing,
> > > as in terms of usability in production? If so, how far are we from
> > > this?
> > Hi,
> >=20
> > I am using btrfs as my root filesystem on my Debian squeeze machine
> > for a few month now and so far I haven't experienced any problems.
> > It seems quite stable for me. I am not using raid functions, but am
> > also very interested in the progress in raid5/6.
>=20
> I was more interested in large setups than a general install.
>=20
> Question remains, when is btrfs supposed to be stable, as in usable for l=
arge server setups?

   As has been pointed out by Anthony, there's no means of determining
when something is "stable" -- not just for filesystems, but for any
piece of software. All you can do is take a Bayesian approach: sum up
the number (and type) of failures, and compare it to the number of
user-hours that the software has been in use for, across all
installations. When that failure rate (and recovery rate) reaches the
point at which you're happy to use it in your situation -- whether
that's on your bleeding-edge desktop test box, or for running your
robotic heart surgeon -- you can call it stable. However, that point
has to be your decision for your particular use case.

   If you're now thinking, "but where do I get that information
=66rom?", congratulations -- you now know nearly as much about the user
base as the btrfs developers. :) Your best bet is to keep an eye on
this mailing list, and take a look at the number and type of reported
failures. When that drops to the point that you feel safe, go ahead
and use it.

   An alternative approach is to install a btrfs set-up on your
internal development or test machines (you *do* have a test
infrastructure for your mission critical systems, right?), and hammer
it with the closest you can get to a real workload, and see what
happens. Again, this is a statistical approach. It's the best we've
got.

   At some point, we(*) hope, btrfs will have millions upon millions
of users, doing all kinds of bad things to it, and tiny fractions of
them will have problems. When that happens, someone will probably
start calling it stable, and the name will stick. Until then, many
people are happy with it for their uses, but nobody can (or will)
magically stick a label on a piece of code of this complexity and say
"it's stable now!"

   Hugo.

(*) Speaking as an interested nobody, rather than a developer.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                  --- Be pure. Be vigilant. Behave. ---                 =20

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMld0TIKyzvlFcI40RAqb1AJ91tOdE5AE5Wg11wgacASbcoQy2kACgqZFj
fbiedPmTzwbR1AbTYqSZDBY=
=P8LC
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
