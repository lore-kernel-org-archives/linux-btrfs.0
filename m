From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Btrfs progs git repo on kernel.org
Date: Thu, 27 Oct 2011 16:58:54 +0100
Message-ID: <20111027155854.GK29548@carfax.org.uk>
References: <20111027152707.GA11028@shiny.Mikenopa.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nywXBoy70X0GaB8B"
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027152707.GA11028@shiny.Mikenopa.local>
List-ID: <linux-btrfs.vger.kernel.org>


--nywXBoy70X0GaB8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2011 at 11:27:07AM -0400, Chris Mason wrote:
> I've pulled in Hugo's integration tree, minus the features that were not
> yet in the kernel.  This also has a few small commits that I had queued
> up outside of the fsck work.
>=20
> Hugo, many thanks for keeping up the integration tree!  Taking out the
> features not in the kernel meant I had to rebase it the commits, I'm
> sorry about that.

   OK, I'm sure I can cope with that. I'll just drop the patches from
my stack that you've already brought in, and generate a new
integration branch based on your master. I've got 4-5 other patches to
add in as well, gleaned from the mailing list and, via David Sterba,
=66rom SuSE's local patches.

   I've also got the basis of a set of regression tests for -progs,
which I'll send out patches for in the next couple of days. At the
moment, it only tests building and snapshots, but should be relatively
easily extensible to the other bits of ./btrfs (although I'm not sure
how we can easily and repeatably test the recovery tools).

   One other thing that's *really* needed is a new version tag, which
I was going to do this weekend, but it looks like you're back at the
helm of -progs, so I'll just whine in your general direction instead.

   I'll try to keep up with the integration branch still, and feed
public patches I pull off the mailing list through to you, if that's
going to continue to be useful. At the moment, though, I'm doing very
little in the way of active review on these patches, so the fact that
a patch is in integration-* doesn't necessarily mean that it's passed
any kind of quality check from me.

> The code from the integration tree is here:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>=20
> My next step is to push out a branch with Josef's recovery tool
> integrated in.  I'm spending some time adding my metadata scanning code
> with his, and trying to clean up things for a real beta fsck release.

   Looking forward to it. :)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 4: Future Perfect ---      =20

--nywXBoy70X0GaB8B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOqX++IKyzvlFcI40RAi5TAJ0dx7nwp43hxuHC5DSX9CY4C18EXwCgqvG+
UW+hCLwLWEFclLDOEgkKY8g=
=+hvi
-----END PGP SIGNATURE-----

--nywXBoy70X0GaB8B--
