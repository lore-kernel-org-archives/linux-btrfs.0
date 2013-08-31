Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36802 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3HaWUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 18:20:48 -0400
Date: Sat, 31 Aug 2013 23:20:41 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Steven Post <redalert.commander@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Device delete returns "unable to go below four devices on
 raid10" on 5 drive setup
Message-ID: <20130831222041.GZ3115@carfax.org.uk>
References: <1377943975.5426.17.camel@pc-steven.LAN>
 <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7fVM7fn5T1d7Fqim"
In-Reply-To: <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7fVM7fn5T1d7Fqim
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 31, 2013 at 11:42:28AM -0600, Chris Murphy wrote:
> 
> On Aug 31, 2013, at 4:12 AM, Steven Post <redalert.commander@gmail.com> wrote:
> > 
> > The system is running Debian Wheezy (kernel 3.2.0-4-amd64 #1 SMP Debian
> > 3.2.46-1 x86_64).
> > 
> > Is this something known (and possibly resolved in a later version), or
> > should I open a bug report about it?
> 
> Try 3.10 or 3.11 before filing a bug on it.

   If you want a debian-packaged kernel, they're available from the
experimental distribution.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no.  5: Manifesto Promise ---     

--7fVM7fn5T1d7Fqim
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUiJsOVheFHXiqx3kAQI2Iw/+O2NOZNreMkghQo9XkNMeihj2ByRQAVNc
I7Qux/c6lV3uNzr3lc/wwIy50QFVwNI46FallCH2387ty49TgCZJCz1Qo+0ioFlJ
w0fcQNaiRHPykmf5Diq1I2k+v+FFj2VxuYWrawaim4iCjcus0RkNvKwQPtk7v4Fu
kqhdUHtS4cSbZyj3dKqUvH8pOAMUBU6Uos/TekdTSXnR03gWV/zlXPcVBsQOm9nQ
eOPxzY3KSiaCDILCovynxFlpUjO2vwmE7T0dqFsLkCoynYca6+cle8VuXoYpobzd
qttsXAs1Tmm5FF7ifGGmiR0hG7VV1L92P8Ne/pMtK+72PSAE0ddHiyx3FbHK0eaw
lUyOnHl6undvFJMlwvGoPhpY5QvrDlgF23fNw7Hb053uFBXK4kAYBjn5so6jV4gB
Fn7r/mlZGMA4+39fvHdZHsdXkUNicRPoCTXjGy6o/my54gnAZUIrpy/eggpK1TZ7
m0+z7KA+k9EbodIYOoYTj+Drw8QiL1lnr5FultiOt0ddWDbQdiLGQ1XxIuKCyGyg
Pu7iwqMqFTVjBwKO/LBfUI6GxpvgocKdGawuaXISU+NUzFGH3/XWQdouk/MY3tlc
b3Y96Lnxo6M324ANK7BUhA08DahLAq7wxuAIwaqmtVwuTMMy94RUvPH8CPWfwLnN
YgJzwFWPfYM=
=eNVt
-----END PGP SIGNATURE-----

--7fVM7fn5T1d7Fqim--
