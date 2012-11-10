Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45992 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2KJVXU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Nov 2012 16:23:20 -0500
Date: Sat, 10 Nov 2012 21:23:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: High-sensitivity fs checker (not repairer) for btrfs
Message-ID: <20121110212317.GE29581@carfax.org.uk>
References: <509EC4B2.6090706@shiftmail.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
In-Reply-To: <509EC4B2.6090706@shiftmail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 10, 2012 at 10:18:42PM +0100, Bob Marley wrote:
> Hello all
> I would like to know if there exists a tool to check the btrfs
> filesystem very thoroughly.
> It's ok if it needs the FS unmounted to operate. Also mounted is OK.
> It does not need repair capability
> It needs very good checking capability: it has to return Good / Bad
> status with the "Bad" meaning that there is at least ONE
> inconsistency. Good means that it is really really 100% consistent.
> 
> Does something like this exists?
> 
> We need to detect as much ahead of time as possible if the btrfs
> filesystem has become even just a little bit inconsistent

   The closest thing is btrfsck. That's about as picky as we've got to
date.

   What exactly is your use-case for this requirement?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- 2 + 2 = 5,  for sufficiently large values of 2. ---         

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJ7Fxb9z9OVl50rAAQK66Q//VxncPEq41JVJYMuyrqETQIrcUpjg3IZR
vL7GKKypjGSxQMDlakdLCR6Sm6RKcI7q73r07YMeAvoNR37VRVNzOMNBwvg82ruh
ZpbXRiTNw05goIeifIMWqNV3EsbPo2AYZXh5s/yRvoGhk0AidFM9tOq/prS6Zo2U
N3u01ygh3qKcAnlBSSj8Fc946/o1Jpn5h2T6YsVu40JItkp4zlk9Pl9Xr8MRjCxP
lLyxEUQcpjriNHteeoC0EyTEuLEDcJ2jdEQOgKg0/+hO8qipITeqA+t1+fbrTaLZ
WNvLesrQo9cYP0lSOGZGDYhbCuV/l1U8NpIXkePMznyI2cbuljQsUDPlp+dwu2v4
Dn3OgfLQV9fiMRplAcQx+H4B49eLt9+TrvvX6+6fdP6eAFcLIDZeV8sYn7Ih2gww
VEKHmkdLm1E8UBtxRF0oZrlJaIiLdcw7Y/OgnU0BncL6+O1JPseDe4quzxG/gM+G
lpkahuOILw2wt5bL4ofMnv5s+Pyuj8AbKnUWGac3bscoisleUMXOrN2otX3cY9OO
Z7CPP6FEA4KTBEQFmcXGxwqAHHb3TArHqIGtslqyqBWuRg3LBC9uLHhYP3lhIinG
gbPbf9YsOq8uCl3IcYNbpREb7JqLfRxKIg//qILdTaq4ZzXeD5FFq/AUD5nlD2V2
G2oCIEXp6Oo=
=Fnqv
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
