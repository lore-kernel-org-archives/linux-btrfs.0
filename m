Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51512 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3GBH3S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 03:29:18 -0400
Date: Tue, 2 Jul 2013 08:29:15 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Chant <pete@petezilla.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Hardware failure or btrfs issue?
Message-ID: <20130702072915.GA8170@carfax.org.uk>
References: <51D2091E.9010800@petezilla.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
In-Reply-To: <51D2091E.9010800@petezilla.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 01, 2013 at 11:56:30PM +0100, Peter Chant wrote:
> Sirs,
> 
> my recently slowing file system is now going read only after trying
> a defrag or other operation.  I'm wondering whether this is the
> result of a hardware failure or a btrfs or some other issue.  Output
> of dmesg:

[snip]
> [  127.862825] btrfs: corrupt leaf, bad key order:
> block=2837196627968,root=1, slot=121
[snip]

   This is usually an indication that you have bad hardware -- I'd
suggest testing RAM, PSU, CPU in that order. I'm not sure what, if
anything, can be done to fix the error on the disk right now.

> Not that I've done anything other than a cursory check but it looks
> like the read only data is fine.

   Might be a good idea to use that to refresh your backups, just in
case my prediction about the fixability is correct.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---   
                    the bottom if we don't stop her."                    

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUdKBS1heFHXiqx3kAQIyBhAAq3V24Ar+kqqzziM2oal+OFwDk83sn4vG
9lecrJNHzp9DzJ2WAE5Rax2dVg8EkIbTnGDM7bmVTdBT7T3fFDtzrTDbvm31mEGQ
/n4kWq9gbjlYZ1vtkCZ6fgW3OSbMVOxMTNkJIPaS4iG8cIBVkU36nbxwMnUbklgT
SgoEFVdxT5oll7B593ebHrv0Ro4KDObN4AWzMgrwWct1rE8YzqntHeTcplu86n8c
v1bEUE5bfBXptvhJncLdGYIUCirRWxUcxW0KJZKjqNpygQ0aD0h8bKnFKn0I5cih
3Zur7Lmiz7W6DmIR39ofuMxph9IJIgKhRsZiEF+bF5V+ZYOx/H3IaQ+hOJ6A7Z4h
BKY7W46AkDWwgYlPNgSvOV6rDY9QS9Gudc+1I+F+/PQn7k7cat6JzXzULxl2Mlmp
UqCr9y9Lt5+Sk7PyB1nnZhvplwtOe24OKsKpGKP8K7Ac6BCRilozvIkkLqT+ErFk
x8RtgY88iqU4CUgJJtYM+oz6em1f6iA4vxvYzqq3vHb+uo3jpTHFK/xEDrL2yBWO
AwgcrcxQPzfWu4muJ0C1sB5wNuMUxnYS7g51HLJnz13BoNtbk/kYFBLgw/BtZL7z
F0Q6PtCCv8QxNnZnaUu4Ti+SSyn4otRA8V1vTZHRie9Uq2oYXDrBZjdfSdDbi4MR
c89Quu9XmWY=
=P9Na
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
