From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 01:21:48 +0000
Message-ID: <20120221012148.GD5350@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
 <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
 <20120221010724.GB5350@carfax.org.uk>
 <CA+Huu1E2cg5a4PWtCkN4a4qou4T++VENsLjC8=TiRPJw5tzAUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Cc: Wes <anomaly256@gmail.com>, linux-btrfs@vger.kernel.org
To: tom@drdabbles.us
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+Huu1E2cg5a4PWtCkN4a4qou4T++VENsLjC8=TiRPJw5tzAUA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2012 at 08:13:43PM -0500, Tom Cameron wrote:
> On Mon, Feb 20, 2012 at 8:07 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> > =A0 However, you can remove any one drive, and your data is fine, which
> > is what btrfs's RAID-1 guarantee is. I understand that there will be
> > additional features coming along Real Soon Now (possibly at the same
> > time that RAID-5 and -6 are integrated) which will allow the selection
> > of larger numbers of copies.
> >
>=20
> Is there a projected timeframe for RAID5/6? I understand it's
> currently not the development focus of the BTRFS team, and most
> organizations want performance over capacity making RAID10 the clear
> choice. But, there are still some situations where RAID6 is better
> suited (large pools of archive storage).

   Rumour has it that it's the next major thing after btrfsck is out
of the door. I don't know how accurate that is. I'm just some bloke on
the Internet. :)

> Also, do we know if the RAID5/6 implementation will simply break data
> into two data objects and one or two parity objects, or will it work
> with an arbitrary number of devices? Meaning, if I have a RAID6 pool
> of 12 drives, will I get 10 data objects and two parity objects?

   AFAIK, the original implementation looked something like the RAID-0
code, so if you have n drives with space for the next block group,
it'll take all n drives to use for the block group. Parity is then
allocated out of those n (with the distribution of the parity blocks
across different drives, as RAID-5 and -6 should do).

   So, allocating a RAID-6 block group of width 1G on your example
12-drive machine, you will indeed end up with 10G of space in that
block group, and 2G of parity data spread across all 12 drives.

   I don't know if the code that will be delivered will allow you to
set a smaller fixed-size stripe width (e.g. 4 data + 2 parity over 8
drives). If the 3-copies RAID-1 code rumour is also true, I would hope
so. Again, I'm just some bloke on the Internet...

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'd make a joke about UDP,  but I don't know if ---        =20
                     anyone's actually listening...                     =20

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQvGsIKyzvlFcI40RAjPCAKCiDTvatL+OwNmhkAQJILu0AatYygCghpqr
eYRXm7QLDhJ/g0ULe/qLjhA=
=3E23
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
