Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54220 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2JOURU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 16:17:20 -0400
Date: Mon, 15 Oct 2012 21:17:17 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Shawn Dakin <dakinsh00@staff.nctschools.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can not Mount btrfs No Space left
Message-ID: <20121015201717.GR25498@carfax.org.uk>
References: <CAAuL=cqf2yU0ofXpZc-N1y9FtL2h7OmRU8S03hyzs=MsyFFj7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/DkgDsqJFFamjKX0"
In-Reply-To: <CAAuL=cqf2yU0ofXpZc-N1y9FtL2h7OmRU8S03hyzs=MsyFFj7w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/DkgDsqJFFamjKX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 15, 2012 at 03:52:15PM -0400, Shawn Dakin wrote:
> I have a btrfs volume that will not mount due to "No space on device"
> I would gladly free up some space if I could only mount the volume.
> Does anyone have a trick to getting this volume back up and running?
> Any help would be great!!

   Start with a 3.6 kernel (which has lots of ENOSPC fixes in it). Try
mounting with -o ro, which won't allow you to modify anything but may
show you if the FS is at least mountable in that state (and will give
you the capability to copy the data elsewhere in extremis). If you're
lucky, that mount may then allow you to mount it again without the -o
ro.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--/DkgDsqJFFamjKX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUHxvTb9z9OVl50rAAQJ4tg//al9gUeuYcnDn4Ry1b6M1DwqIntbHiLjJ
Pvk1EChVAWvosuevjHBxmXbG8EolqTVpSxO33GA5QZ/EbL4vFsph7cV9txsBF/vj
AdZxGr6MhU/Nt8AujnISQAfQwXPpiPMNZ6vMPhuKGQ6s0KCxh56Uan/cwm/xsJG0
ToM5+L/HPfbikihHbWUpRBl4KFj1I5Cn0O/45/M9Tv3JfujeLKgGMiJdSyUlpmJt
Jj+vtrDCK8NkdimXV74WXZaDA/Js+Q/5ViIIO8tLPWt2t3/+a44giT/KEYmQct2Q
owixrwqpDKBTDql9PwTGHcgro4JXp9o2hvUz7t3sGjON/C7YOgyJpjYTh6pVCK+8
DQGUCW4KRTSGBEcMJJ0OUz0NRD0+qguYZn+RQmkZMdpAKJpiDzUa5hMEKbNkzWw2
4dAN9YVI1IzpUvENYuK82dAdPeojlSoSiHoNTs99ez4SZS20adtEnuMTpMlCz8UP
RA55aWJgph7swL6Jj0nqLfEEetDlpQq5y6jrdOVgDPA9vcGZzR4d9zGxTBShOT5P
2qhAyuuiwN3Er3J0EeBgrz/fneoumC0V+9Fp7Mxv5quKzkQQN3Qu/S+5zXqpoV7D
cyKN2YOlNJQJREZiGKXjlNilCc1Lg+K4O7Rpi7aiqYEgQiWU1uJHxvMWliztA5DA
fAWNsrEe0nU=
=3RpD
-----END PGP SIGNATURE-----

--/DkgDsqJFFamjKX0--
