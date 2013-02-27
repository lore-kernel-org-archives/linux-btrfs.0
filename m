Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51373 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3B0NIu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:08:50 -0500
Date: Wed, 27 Feb 2013 13:08:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: penn43@gmx.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Writing a wtapper for BTRFS
Message-ID: <20130227130846.GM14283@carfax.org.uk>
References: <512E01BD.2040302@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TdMwOTenGjBWB1uY"
In-Reply-To: <512E01BD.2040302@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TdMwOTenGjBWB1uY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 27, 2013 at 01:53:17PM +0100, penn43@gmx.com wrote:
> where can I find some documentation that will help me
> in writing language bindings for BTRFS?

   You may want to look at the btrfs-progs libify patches (posted to
this list in the last couple of months), which try to pull out the
more useful bits of btrfs-progs as a userspace C API.

   You may also want to look at the bits I implemented in python[2]
for a subset of the btrfs ioctls and data structures in btrfs-gui.

   Other than that, it's down to the data structures documentation on
the wiki[1], and reading through ioctl.h.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Data_Structures
[2] http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-gui.git;a=blob;f=btrfsgui/btrfs.py;h=0941de1efeadb81576edf1c7c84da28805310a92;hb=aba25f9efe7bcdb99e8cfa38e703c4b0739c6af9

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                  --- Be pure. Be vigilant. Behave. ---                  

--TdMwOTenGjBWB1uY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUS4FXr9z9OVl50rAAQI3LQ/9GzpNrbvPd/ezVFflnB2WuM92X0HlQTpH
1oEk5/Tf7hSFG3cVEG/5YbMFiRh++dd/cgq+6ZEhL8gbDpXyg5fSn7AOaED39IaZ
N6bLRnXvWyDCxQ3Ts/Ypp90tEzDpfRa6UKkQBCMb7XCL4zaCct4sN0R82n+N18eZ
EYd5t1CtfYaZDJhOf8rWsb/NW0/4IZJ96Gu3S6XZLdT5yJZWF5yZYL9Vl110QmUl
3Blf53XsqSgV9Fo44SlFNNgSxre7+Ebc8w3rvuaUMEGmr7DFziE07oS677RnVXvn
BHFjITrgY2r8mfSDn9B0a+41I0xGVjpjHwC7p4z9ysLH27r4Wn2oU/YOG/YK+JAM
bunnlxFGV/24TUSbnXjdLjx3twTHfA62ecAGI6SpZIOj+N7iLqJrM1rk/hCVKmwU
pV/X4SvxfIla4M8IirjevlwR9c3XryWvve755yhdOrMemDvXX0Q9evPDcK3/ofmH
RaQBBeKpvN3kmOw43flJknbV2XmrVQ6+bbgq6PEKB+DDy267i8oiLp88o+waaPhd
pxhDc5wW4rEqYfIs3rrkkukZiBzr9vPQmQjo/iaHrbrzRE9ylDni7q2NrBlsgMkO
raQhY1dyXBgB57Hz6WHk9XWtb4OgrB35u1/Qiowp72GXsYlW5TLIJReg+EVzEw5V
sHIQpreNnYM=
=hig0
-----END PGP SIGNATURE-----

--TdMwOTenGjBWB1uY--
