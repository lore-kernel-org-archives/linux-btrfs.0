From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs csum failed
Date: Wed, 4 May 2011 12:47:57 +0100
Message-ID: <20110504114757.GA24990@carfax.org.uk>
References: <4DC07A10.7070200@mur.at>
 <20110504002815.GA27861@dhcp231-156.rdu.redhat.com>
 <4DC0A153.3080806@mur.at>
 <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>
 <4DC13B02.9030604@mur.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC13B02.9030604@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 04, 2011 at 01:39:46PM +0200, Martin Schitter wrote:
> and the 'nodatasum' option should also ignore csum issues.-- isn't it?

   No, "nodatasum" will prevent newly-written data from being
checksummed.  However, if a checksum already exists (because the data
was written to a filesystem mounted without the "nodatasum" option),
btrfs will still verify the checksum, regardless of the current
setting of nodatasum.

   There is currently no way of preventing btrfs from verifying
checksums if they exist; I don't believe that there's any way of
removing an existing checksum, either.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Charting the inexorable advance of Western syphilisation... ---   

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNwTzsIKyzvlFcI40RAjVQAJ9qKEMtSISHN6JgCSQeWPLx/obdEQCgzAjR
PFaQdD61Z7YvEENV0gTEKqo=
=Xqjy
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
