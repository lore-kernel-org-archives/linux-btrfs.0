From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 07:54:22 +0000
Message-ID: <20120221075422.GG5350@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
 <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
 <CAHH42isod-cyEqG1rfq6m1ki2EV_FqU6TnX9WzH+BJ7s6OF1aQ@mail.gmail.com>
 <CA+Huu1FF9-wFXyG4NvvNLwJv5eqHUcVK_UHeENSY9A=9ssXSEQ@mail.gmail.com>
 <CA+WRLO9BgqE+CwCUNgjwjVFyjDDp94SBX_EbdVciHUd0jpUqWQ@mail.gmail.com>
 <CA+Huu1H3q-eztZ8W3BK=y4TR7ero1tc=QdzAkiFewQw8jA-7-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oXNgvKVxGWJ0RPMJ"
Cc: Gareth Pye <gareth@cerberos.id.au>, linux-btrfs@vger.kernel.org
To: tom@drdabbles.us
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+Huu1H3q-eztZ8W3BK=y4TR7ero1tc=QdzAkiFewQw8jA-7-g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--oXNgvKVxGWJ0RPMJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2012 at 08:59:05PM -0500, Tom Cameron wrote:
> Gareth,
>=20
> I would completely agree. I only use the RAID vernacular here because,
> well, it's the unfortunate defacto standard way to talk about data
> protection.
>=20
> I'd go a step beyond saying dupe or dupe + stripe, because future
> modifications could conceivably see the addition of multiple
> duplicated sets. The case of 4 disks in a BTRFS filesystem with dupe
> running across all of them would be a clear extension I could see. So
> that would be something like 4D. I'm not real sure what you'd use for
> the terminology, but something completely different than RAID-like
> terms is almost certainly best. Just look at the ZFS documentation to
> see how carefully they have to spell out what RAID-Z, Z2, and Z3 do
> because they used the RAID acronym.

   /me opens a plate to put the can of worms on.

   Some time ago, I proposed the following scheme:

<n>C<m>S<p>P

   where n is the number of copies (suffixed by C), m is the number of
stripes for that data (suffixed by S), and p is the number of parity
blocks (suffixed by P). Values of zero are omitted.

   So btrfs's RAID-1 would be 2C, RAID-0 would be 1CnS, RAID-5 would
be 1CnS1P, and RAID-6 would be 1CnS2P. DUP would need a special
indicator to show that it wasn't redundant in the face of a whole-disk
failure: 2CN

   Hugo.

> On Mon, Feb 20, 2012 at 8:47 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> > On Tue, Feb 21, 2012 at 12:07 PM, Tom Cameron <tomc603@gmail.com> wrote:
> >>
> >> It seems from the BTRFS documentation that the RAID1 profile is
> >> actually "mirror", or store 2 copies of the object. Perhaps when
> >> Oracle makes BTRFS a production option they should more clearly spell
> >> that out.
> >
> >
> > I'd really like BTRFS to not use RAID level terminology anywhere (other=
 than
> > maybe in=A0parenthesis=A0along the lines of: "this is similar to RAIDX"=
) and use
> > less ambigious options as the recommended way to talk about things. As =
there
> > is good reason to talk about Dup and RAID1 differently as they aren't t=
he
> > same on more than 2 drives. Doing it that way will make people understa=
nd
> > what is going on more often, which should be good.
> >
> > It also makes things much easier to remember. Like how much data can yo=
u fit
> > on a 6 drive RAID10? I dunno, but I can more intuitively answer that sa=
me
> > question when it is phrased as just simply 'dup', or maybe 'dup + strip=
e'.
> >
> > Is there a difference in BTRFS between dup and raid10?
> >

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 4: Future Perfect ---      =20

--oXNgvKVxGWJ0RPMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQ02uIKyzvlFcI40RAkviAJkB6rfGPS/sj6wh+NMQul10ZrwjogCfcE3u
ZnYVuDKDjMDbxfQt8HVCkpA=
=Sdys
-----END PGP SIGNATURE-----

--oXNgvKVxGWJ0RPMJ--
