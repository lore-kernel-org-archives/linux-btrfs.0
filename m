From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Find RAID level, Change RAID level.
Date: Sat, 29 Oct 2011 15:44:19 +0100
Message-ID: <20111029144419.GP29548@carfax.org.uk>
References: <CACCfv7q4HkRDnCa3bXEj+fAJA1kikLQ+3G46VH-2unPgT=1DFA@mail.gmail.com>
 <20111029141303.GN29548@carfax.org.uk>
 <CACCfv7rRw6NsxAbosbdTVXpcWvc1XO=goSTQoQ5txQPnX=eSyw@mail.gmail.com>
 <20111029143410.GO29548@carfax.org.uk>
 <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr6hGnsCY8KeifOY"
Cc: linux-btrfs@vger.kernel.org
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--Sr6hGnsCY8KeifOY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 30, 2011 at 01:06:49AM +1030, Jordan Windsor wrote:
> On Sun, Oct 30, 2011 at 1:04 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Oct 30, 2011 at 12:55:33AM +1030, Jordan Windsor wrote:
> >> On Sun, Oct 30, 2011 at 12:43 AM, Hugo Mills <hugo@carfax.org.uk> wrot=
e:
> >> > On Sun, Oct 30, 2011 at 12:28:39AM +1030, Jordan Windsor wrote:
> >> >> Hello,
> >> >> I was wondering is it possible to find the RAID level currently in =
use
> >> >> by a btrfs volume, also can I change the data & metadata (or either)
> >> >> RAID levels after creation.
> >> >
> >> > =A0 To see the RAID levels, use
> >> >
> >> > btrfs fi df /path/to/filesystem
> >> >
> >> > =A0 To change RAID levels, you will need Ilya Dryomov's restriper
> >> > patches, which were posted to this list back in August.
> >>
> >> Thanks, so If it mentions "DUP" on the metadata & system line I'm usin=
g RAID1?
> >
> > =A0 No, DUP is two copies of the data (or metadata), but kept on the
> > same block device.
> >
> If the word RAID isn't mentioned, I'm in single mode for both metadata & =
data?

   If there's nothing at all, then it's "single". If it says DUP, then
you have two redundant copies, but they could both be on the same
block device, so it'll protect you from a bad block or out-of-band
data corruption, but not from the loss of the whole disk.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Ceci est un travail pour l'Australien. ---             =20

--Sr6hGnsCY8KeifOY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOrBFDIKyzvlFcI40RAkU/AKCtLQO1JOJmsL59weOhqXD2mO+B2wCfZTsv
5VAArSLF50jo3eXkchRWii4=
=0KuJ
-----END PGP SIGNATURE-----

--Sr6hGnsCY8KeifOY--
