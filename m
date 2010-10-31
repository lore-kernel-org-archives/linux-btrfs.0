From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Horrible btrfs performance due to fragmentation
Date: Sun, 31 Oct 2010 22:47:57 +0000
Message-ID: <20101031224757.GA2430@selene>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
 <AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
 <AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Cc: cwillu <cwillu@cwillu.com>,
	Calvin Walton <calvin.walton@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 01, 2010 at 12:36:58AM +0200, Felipe Contreras wrote:
> On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
> > btrfs fi defrag isn't recursive. =A0"btrfs filesystem defrag /home" will
> > defragment the space used to store the folder, without touching the
> > space used to store files in that folder.
>=20
> Yes, that came up on the IRC, but:
>=20
> 1) It doesn't make sense: "btrfs filesystem" doesn't allow a fileystem
> as argument? Why would anyone want it to be _non_ recursive?

   You missed the subsequent discussion on IRC about the interaction
of COW with defrag. Essentially, if you've got two files that are COW
copies of each other, and one has had something written to it since,
it's *impossible* for both files to be defragmented, without making a
full copy of both:

Start with a file (A, etc are data blocks on the disk):

file1 =3D ABCDEF

Cow copy it:

file1 =3D ABCDEF
file2 =3D ABCDEF

Now write to one of them:

file1 =3D ABCDEF
file2 =3D ABCDxF

   So, either file1 is contiguous, and file2 is fragmented (with the
block x somewhere else on disk), or file2 is contiguous, and file1 is
fragmented (with E somewhere else on disk). In fact, we've determined
by experiment that when you defrag a file that's sharing blocks with
another one, the file gets copied in its entirety, thus separating the
blocks of the file and its COW duplicate.

> 2) The filesystem should not degrade performance so horribly no matter
> how long the it has been used. Even git has automatic garbage
> collection.

   Since, I believe, btrfs uses COW very heavily internally for
ensuring consistency, you can end up with fragmenting files and
directories very easily. You probably need some kind of scrubber that
goes looking for non-COW files that are fragmented, and defrags them
in the background.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---  =20

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMzfIcIKyzvlFcI40RAjomAKC7h8axNIS0H47H2uYyIDBvFngUYwCfRUkH
TPgHcU2xv8BDUzNjRJ4iaCw=
=iX+7
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
