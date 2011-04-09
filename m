From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: switching "balance" into background
Date: Sat, 9 Apr 2011 09:44:45 +0100
Message-ID: <20110409084445.GD5301@carfax.org.uk>
References: <BjW+ECVD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BjW+ECVD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 09, 2011 at 07:57:00AM +0200, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> I can't switch a running "btrfs filesystem balance ..." via
> 
>         ctrl z
>         bg
> 
> into the background, with other jobs this way works.
> 
> The stopping command "ctrl z" doesn't work.
> 
> (may be on other keyboards it's "ctrl y")
> 
> What goes wrong?

   A balance is a single long-lived ioctl call, so the userspace
process is living in D state (uninterruptible sleep) until the kernel
finishes.

   I've got a patch that forks the process, and runs the ioctl in the
background, returning immediately. I should be able to get it to the
list this weekend as part of the userspace side of the balance
management patches.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- There are three things you should never see being made: laws, ---  
                        standards,  and sausages.                        

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNoBx9IKyzvlFcI40RApVDAKDEFa9ZqVhEMgqmS9HI+mnL2eIxGACeMXVP
+41jQmL7BoWoYlEWZHDF5Yw=
=q6wQ
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
