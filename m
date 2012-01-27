From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs filesystem df command oddly named?
Date: Fri, 27 Jan 2012 07:03:01 +0000
Message-ID: <20120127070301.GD5531@carfax.org.uk>
References: <CAHH42ivUik8NeT=h-AHQ9WwTZmpuN7BqyeN=ZNHM8RpjKu+-mg@mail.gmail.com>
 <CAAE6i0jy1wHV-7CZinK7qsCOxuLZXW7dcVRuBgdvkHQKsWEMsg@mail.gmail.com>
 <CAHH42iuWHH-ezUdLSzHpcqr9G69a1NdY_m4GGOmjn2jxoQwxdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Cc: linux-btrfs@vger.kernel.org, Chester <somethingsome2000@gmail.com>
To: Wes <anomaly256@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHH42iuWHH-ezUdLSzHpcqr9G69a1NdY_m4GGOmjn2jxoQwxdQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 27, 2012 at 01:06:38PM +1100, Wes wrote:
> > I don't know much of what goes on inside BtrFS, but I like to point
> > out that btrfs fi df doesn't actually report total space on the disk,
> > only the total space currently allocated.
> 
> 
> Good point, and this also supports the notion that it's more of a 'du'
> work-alike than a 'df' one

   On the other hand, "df" reports global figures, whereas "du"
reports values for a file or set of files. "btrfs fi df" also reports
(one set of) global figures, and a hypothetical "btrfs fi du" (which
will probably surface once Arne finishes the qgroups stuff) will
report on subvolumes and/or sets of files.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- UNIX: British manufacturer of modular shelving units. ---      

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPIkwkIKyzvlFcI40RAkAOAKCbamTYK2ttTdCvHM15oJUN/s3wNgCgruez
THNfEkFpBssmN9RG261Y69o=
=usI1
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
