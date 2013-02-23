Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51893 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3BWTxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 14:53:49 -0500
Date: Sat, 23 Feb 2013 19:53:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Kusmierz <wally_tm@wally-tm.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Changing node & leaf size on live partition.
Message-ID: <20130223195344.GJ14283@carfax.org.uk>
References: <5128DCF0.4040209@wally-tm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XigHxYirkHk2Kxsx"
In-Reply-To: <5128DCF0.4040209@wally-tm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XigHxYirkHk2Kxsx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 23, 2013 at 03:14:56PM +0000, Tomasz Kusmierz wrote:
> Hi,
> 
> Question is pretty simple:
> 
> "How to change node size and leaf size on previously created partition?"

   Right now, I'm afraid we don't support it. It's one of the trickier
conversions to do, and I suspect that if it does happen, it'll be
offline only, and may not be implemented in the near future (if at all).

> Now, I know what most people will say: "you should've be smarter
> while typing mkfs.btrfs". Well, I'm intending to convert in place
> ext4 partition but there seems to be no option for leaf and node
> size in this tool. If it's not possible I guess I'll have to create
> "/" from scratch and copy all my content there.

   Yeah, that's probably your best bet for the forseeable future, I'm
afraid. (But given that we recommend having backups anyway, it's not a
big problem to wipe it all and restore from them, right? ;) )

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Q: What goes, "Pieces of seven! Pieces of seven!"? A: ---      
                            A parroty error.                             

--XigHxYirkHk2Kxsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSkeSL9z9OVl50rAAQKa8A/+It0XsCIMCr5ThlEbIF+uH/xLRvZQIfJL
sls1Yk7ZnmdmxM1qKJZZU+KvePQnS0b4UU4l4nA/FqTRp6Kx7J1t2UogEOeziSJk
QsZELEujhxkDIr3ts37NqFo3khPFVxMr08AT0h7mUF3GX5lEWS+KAzE+KfFNYlPa
RWCKSdd6pMnhoPbMuGk+N0mlEDOSOg5fuPL1XLcm6ZOyo/9d8P7MBOGAvz1IxhP5
NNLy6vXQgWkJvIoRn6xF5P7EyubWehgp8vyqCk/UowHQayUNrlf5iN1n1JR6BGfs
A2qEKpepOHmCah4QZa0Gwci3jycxwm6ngDxtkraiBiUBCaYYG25gyTk0Qtxo5SLB
5290GyB7C42dlX9VbqfvSZceXGZJm3goorGfzDw0CLThIcrA/tfPMyFNsxzdzj5k
EB4zzxXE017zuKixbi5xQdKmn6obwiCnZ7jpFG3aWoTOMkuLBGgrJmqKqAcetLCa
6rNHq0tDINWxIiVAVLKNDoCUs/6k/dX9AWgslbZkpXGDoDi8YJjOh5rIabBbQ5RN
ylpdmE74D6t8EHsfakkspPMogCe367875AMj/uzbiFKkjyISJgv81KprGx55Itqc
/kwVpud/WZp8cmhAhDbGYQJU7AkSlsCcGN8dRsjjwkwPlHSEh077YZEldWimmXHA
creN1uUubls=
=X9wV
-----END PGP SIGNATURE-----

--XigHxYirkHk2Kxsx--
