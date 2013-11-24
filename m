Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52822 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3KXNue (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 08:50:34 -0500
Date: Sun, 24 Nov 2013 13:50:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hans-Kristian Bakke <hkbakke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: The state of btrfs RAID6 as of kernel 3.13-rc1
Message-ID: <20131124135032.GE28883@carfax.org.uk>
References: <CAD_cGvHFg11+RhqYDcu=zcUWpRAi85WqW7Wm5K040J_+h_mcGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8BnQc91gJZX4vDc"
In-Reply-To: <CAD_cGvHFg11+RhqYDcu=zcUWpRAi85WqW7Wm5K040J_+h_mcGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Q8BnQc91gJZX4vDc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 24, 2013 at 02:47:56PM +0100, Hans-Kristian Bakke wrote:
> Hi
> 
> What is the general state of btrfs RAID6 as of kernel 3.13-rc1 and the
> latest btrfs tools?
> 
> More specifically:
> - Is it able to correct errors during scrubs?

   Not yet, I believe.

> - Is it able to transparently handle disk failures without downtime?

   Not yet.

> - Is it possible to convert btrfs RAID10 to RAID6 without recreating the fs?

   Yes.

> - Is it possible to add/remove drives to a RAID6 array?

   Yes.

   HTH,
   Hugo.

> Regards,
> 
> Hans-Kristian

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Normaliser unix c'est comme pasteuriser le Camembert ---       

--Q8BnQc91gJZX4vDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUpIEKFheFHXiqx3kAQKvWA//eH+oAn/IZyLBu2zFTuS2R8ft+1J+8wex
YfC6ibcr1n9oBFEvmMupzrcxfSUyzF2RnCfB9jYo1NS2EbGfDXdsjV4v7S5A3E7x
B+DD8ThOj34uFqR3pOm+lzzuspq6pN6cS0XmaiCsR9xnZ95MOselqQBwLPGDpXYl
kVQpgd0SiSKTijZmzM0dvDvp/s+wrvyGxLliaOTH6gGee1mDWOV7cds2sODWqBf3
3ffmtkvz+R17B6SkDHFojuBIKHH8A/YTWXKSg4wapW0mKrwT/yQ/kRl7gOpoOqEL
cvpacmO5bqTZRSSDXKYpmzIfDK6WSRX+YX9VbgHTb7RWV14Sbwl4J2b5IkuptOCo
s05J+6vtSON+mdCuKjXVu8pdx4OLhPp4PH92zljJTUfAvRsgpwBehQJ6T/vc1N4p
zNju8zwV98FLpyxelNfhxkCDFdmfaLFtiUlnMmypAf3qcHapi7lz3xO8DPfeRqnn
JEMnMpnS9rO8VAeVe3GV8/mrjbuz937IyHolWf5b5hLylH5BVdsKfpDJaK8gy9+u
Q2TsfU5YLgY6xBAHXBnG74Kogdi8tKCkBaNHh7hihK83M4z5qhvazdiLOrjAdR+7
1cP5nkg/A/aDDh1eNyxM1OkyO1u4NxVbncY/+o9+yDlojan3L8l9gsLD6s0OP6b1
EmwvBKZB3cg=
=iOGh
-----END PGP SIGNATURE-----

--Q8BnQc91gJZX4vDc--
