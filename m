From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Tue, 21 Feb 2012 01:31:20 +0000
Message-ID: <20120221013120.GF5350@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
 <CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
 <20120221010724.GB5350@carfax.org.uk>
 <CAHH42ivnDS2vOFK8+F6rsOAkM7Fax2Hd0f4PQDm-3k88fJ6Mcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Cc: linux-btrfs@vger.kernel.org
To: Wes <anomaly256@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHH42ivnDS2vOFK8+F6rsOAkM7Fax2Hd0f4PQDm-3k88fJ6Mcw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2012 at 12:27:56PM +1100, Wes wrote:
> @hugo
> 
> iirc that was on ~3.0.8 but it might have been 3.0.0.  I'll revisit
> the raid0 setup on a newer kernel series and test though before making
> any more claims. :)

   There's a repeating pattern of three log messages that comes out in
your syslogs. It's something like two "found n extents" messages, and
then "moving block group yyyyyyyyyyyy". As long as you keep getting
the latter message with different numbers, it's still working OK. The
block group numbers are monotonically decreasing (if they go up again,
there's a problem we need to know about), but aren't necessarily
linearly-spaced, particularly if you've done a balance or partial
balance before. i.e. they're an indication that something's happening,
but not how much more of it there is to go.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'd make a joke about UDP,  but I don't know if ---         
                     anyone's actually listening...                      

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPQvPoIKyzvlFcI40RApuxAJsGgBqKhMxvYuqFKdTkJrnbsvsx4ACgw9QI
3GbkDxJ9iQfnye87LBPbwSI=
=z/+L
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
