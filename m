From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Sun, 21 Aug 2011 14:58:34 +0100
Message-ID: <1313935128.4873.2.camel@picard>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	 <1312404713-sup-6548@shiny> <loom.20110818T030824-742@post.gmane.org>
	 <1313700115-sup-2457@shiny>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-MG1+fX4EzI618gUCZa7Y"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313700115-sup-2457@shiny>
List-ID: <linux-btrfs.vger.kernel.org>


--=-MG1+fX4EzI618gUCZa7Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 16:50 -0400, Chris Mason wrote:
> Excerpts from Yalonda Gishtaka's message of 2011-08-17 21:09:37 -0400:
> > Chris Mason <chris.mason <at> oracle.com> writes:
> >=20
> > >=20
> > > Aside from making sure the kernel code is stable, btrfsck is all I'm
> > > working on right now.  I do expect a release in the next two weeks th=
at
> > > can recover your data (and many others).
> > >=20
> > > Thanks,
> > > Chris
> > > --
> >=20
> >=20
> > Chris,
> >=20
> > We're all on the edge of our seats.  Can you provide an updated ETA on =
the=20
> > release of the first functional btrfsck tool?  No pressure or anything =
;)
>=20
> Hi everyone,
>=20
> I've been working non-stop on this.  Currently fsck has four parts:
>=20
> 1) mount -o recovery mode.  I've posted smaller forms of these patches
> in the past that bypass log tree replay.  The new versions have code to
> create stub roots for trees that can't be read (like the extent
> allocation tree) and will allow the mount to proceed.
>=20
> 2) fsck that scans for older roots.  This takes advantage of older
> copies of metadata to look for consistent tree roots on disk.  The
> downside is that it is currently very slow.  I'm trying to speed it up
> by limiting the search to only the metadata block groups and a few other
> tricks.
>=20
> 3) fsck that fixes the extent allocation tree and the chunk tree.  This
> is where I've been spending most of my time.  The problem is that it
> tends to recover some filesystems and badly break others.  While I'm
> fixing up the corner cases that work poorly, I'm adding an undo log to
> the fsck code so that you can get the FS back into its original state if
> you don't like the result of the fsck.
>=20
> 4) The rest of the corruptions can be dealt with fairly well from the
> kernel.  I have a series of patches to make the extent allocation tree
> less strict about reference counts and other rules, basically allowing
> the FS to limp along instead of crash.
>=20
> These four things together are basically my minimal set of features
> required for fedora and our own internal projects at Oracle to start
> treating us as production filesystem.
>=20
> There are always bugs to fix, and I have #1 and #2 mostly ready.  I had
> hoped to get #1 out the door before I left on vacation and I still might
> post it tonight.

Greate to hear that. Given that I get corruption every 2 week I would
like to at least test the tools - are there available anywhere?

I'd like to see #2 (it seems to be able to fix my main crashes).

Best regards


--=-MG1+fX4EzI618gUCZa7Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOUQ8YAAoJEJIdee2Vr4aPMVIP/1VYZHBuGYF34d1pcI1y0m/D
nGdvHplYp+inoSqClS2TvOqKtDT3ml4Dr+Df/MKfvmAhfoPLbwhfyZKkp1uw+E37
2TZ6PmXF9a58XKhYZeOJF5+aJJyK8qONrL5Lo4OVz+CIY4bhJxPNRVtvLOMXIo80
cmYyygZ+8fpWFTAmX+yZn3+eVNhV7AEdpN4IiVdo9ZiVAvSaV5KuOJbkXGoKkB8+
ffTAhyAwBdTMsqj2i3gC31p1v2hd3Q1mK8U/D1TSXRumrVNPDvP+1QUPgvHlTCNm
q1bmBheR0Rigi+U2SDHViXGF2dc9JYiOK4xwVZ07krpgc1tlbJz1pQkgo+Klm4dt
ZR5blg4aAztQXKiRNnmTIdNmP6ja6Rdceql3ZNo1mO9c+pXjo2d0pjlHYPmAVbXb
HR7gjuTYcVC1euhoDTbUYIfWwiAxUrSiS4eZXdxujFFyriIunHnRfArxBIWiTzmZ
SxuHoCuNgQkrOtFuRX/wMdrGEmWhumEVMHL6L7JARCdfK7wNyF0Es8EMKToyeGKe
fbA4OGikcbnzrf1CC5zAjvPQjgUMbe706B3R2gz0DQfF4SbpAkx7LnXQWQw+zhgf
k2hM+j73F6DT0Fkm7JEWw3Bqiar4kSsPyBM/fxKma6G7N88Eyq70QrK+e2EeLHLB
kVPc0TrgpwFgS33H/Aoz
=WNoj
-----END PGP SIGNATURE-----

--=-MG1+fX4EzI618gUCZa7Y--


