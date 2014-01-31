Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57008 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaAaTxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 14:53:49 -0500
Date: Fri, 31 Jan 2014 19:53:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: KC <impactoria@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Booting with syslinux not possible
Message-ID: <20140131195325.GC18327@carfax.org.uk>
References: <52EBFD82.7080900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
In-Reply-To: <52EBFD82.7080900@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2014 at 08:46:10PM +0100, KC wrote:
> I do not know if people her are aware of it, but just in case I
> thought it is worth mentioning that currently it is not possible to
> boot with Syslinux bootloader, if the boot partition is on BTRFS.
> 
> Perhaps it's worth adding to the wiki.

   Are you certain? I've definitely had it working late last year. You
can't boot from a multi-device filesystem with it, but a single-device
FS worked fine for me.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Great films about cricket:  Batsman Returns ---           

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUuv/NVheFHXiqx3kAQJJ7RAApd3zzSidvYBVsxoT3yIe5TsS4yZjLE3F
SNxYV5KmHrSLRDBjmiRTboTeuI4dLSHEkuVMHvgDu5cVrFM360qvv3tpqBO3lwI5
3dXKjFUK4dLQpXdTbl6QDJk+afAtC1LOboFB2HsEZmzqZJVoQzrX2HNwNIS3z9XX
XHC+urhiTFeCrVVaRL65AE/L/2cb+uqkT3d2zq3JK8jqKmzR7sU6/LooZOU2VQgG
JY1D03BBd2ACeakATeT6GxVj4RKLiCRFzEi/kW9oqTd/bC3FFqFGxMh3jbtDY6b7
tIpEBqw8AwgryGp9xV9iwLvNxm88U6EZVIq6okp+2jSw6x8a2vLTFjfK4AJRJOkS
uEX63eYa8c+o6sFqdSDT2jWoQdtfdNaxeQzvSHgra56an0kVXVmmoJJxCCzBATmh
xto6Z0SAlS2jpH3zgRdKWB7wvY6IAufmkSlHsJiMczyvMEZCgMPmSuq66EVhlkq4
t8Dz9mjDUXpuvsoPWdH+A53v072T8ct9tbPOsNPmWQOtkMmplz8EG4zVxRO/+eGp
QsKYk/tc0tHHhZNc+mj+CwswZsfWptG6ku1JYwRThVgH2ZCqPN+MantewGBa1UXz
VTp37bDRSucsmOff4c+KWRISiFl93gKz4G8U22gMpddjKzDgT91QI+EjiHPkvi9O
ErM+01ST+Vw=
=NiQz
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
