Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38422 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbKMVNn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 16:13:43 -0500
Date: Fri, 13 Nov 2015 21:13:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: illegal snapshot, cannot be deleted
Message-ID: <20151113211341.GH24333@carfax.org.uk>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
 <564486F3.5020804@gmail.com>
 <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
 <56461034.3070209@gmail.com>
 <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
 <56462784.2060601@gmail.com>
 <20151113184227.GF24333@carfax.org.uk>
 <56463CBC.70808@gmail.com>
 <20151113195520.GG24333@carfax.org.uk>
 <pan$38813$161f71be$a3fa4155$7377d9e9@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
In-Reply-To: <pan$38813$161f71be$a3fa4155$7377d9e9@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 13, 2015 at 09:11:46PM +0000, Duncan wrote:
> Hugo Mills posted on Fri, 13 Nov 2015 19:55:20 +0000 as excerpted:
> 
> > receive is implemented almost exclusively in userspace, with only a
> > couple of ioctls for mucking around with the UUIDs at the end.
> 
> I wasn't aware of that and had assumed kernel space.  Apart from the 
> topic of discussion here, that has implications for the old "how old is 
> too old" versioning question regarding userspace, so thanks, Hugo. =:^)

   Note that send is still heavily kernel-side. It's only receive
that's all in userspace.

   Hugo.

-- 
Hugo Mills             |
hugo@... carfax.org.uk | __(_'>
http://carfax.org.uk/  | Squeak!
PGP: E2AB1DE4          |

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWRlKFAAoJEFheFHXiqx3k8RQQALx1DzoCZ+gX4pTe8D+ogW01
K3QKvmYyvpuhNp7VN3wY6oNYw3zvJNWNVthXLDnNPaho63k4HbFb7sORiZALtS91
QWs+lej60DVJ5UT9Oqm69dloUX1fwZgExnjIktf2ys1aZqbJ8budxLEqNlT6m637
Qr2+vzGJQaHtw68J81VD2876+eFuwsQX+ufwHueZ4j3pFYdByk9Jnn613rXNSCIw
Hqi6S6qlT67uMDf85PLBAJcTQNp5E+aaqgr6k6W9SOJdNLLJFUGU2ZMjGNoWQ9lh
hhxZrhlTS8vY3z0wlQHSqPSFQ4J1y8RbaObDqJL+GmlmXA/QIu6iasmmY2fIeX01
h2M7octvWrwumrVdeTpXr6mIDBB1zHVDJecJ/yOGQT3oHZzyw8U+JxNp1wwHRmd2
nQmvYsPvXQiVAUxY3PaclGO4Zs+Hh8HTVeBFJf6n2HJtV2YRYcAjRrlirSSaEwzz
kd0Uf3vpeqk//KZhu5wWw7/kYZjaYdFzTQclXPwIgl3lpdixs0SVNPiPCYir9Abs
itjlGz4BixxeEtNtGhE2rTlXMMEfqfQijg8PhmTEKp7U51gh8AZq2NienvevWLZj
fbLZbxQuSCbJTRpeJe6g4oekujXd81GEgmFdbObhTNqTsQOF0Ks5fSdtqRTzorOd
sr+gGb1s+Dl0Ay8wgKZB
=DJkb
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--
