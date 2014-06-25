Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42512 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaFYHr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 03:47:27 -0400
Date: Wed, 25 Jun 2014 08:47:13 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Daniel Landstedt <daniel.landstedt@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs data dup on single device?
Message-ID: <20140625074713.GE31096@carfax.org.uk>
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
In-Reply-To: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 25, 2014 at 09:25:57AM +0200, Daniel Landstedt wrote:
> Will it be possible to use DUP for data as well as for metadata on a
> single device?

   This has variously been possible and not over the last few years. I
think it's finally come down on the side of "not", but by all means try
it (mkfs.btrfs -d dup).

> And if so, am I going to be able to specify more than 1 copy of the data?

   It'll be exactly 2 copies at the moment. Note that performance on
an SSD will at least halve, and performance on a rotational device
will probably suck quite badly. Neither will help you in the case of a
full-device failure. You still need backups, kept on a separate machine.

> Storage is pretty cheap now, and to have multiple copies in btrfs is
> something that I think could be used a lot. I know I will use multiple
> copies of my data if made possible.

   The question is, why? If you have enough disk media errors to make
it worth using multiple copies, then your storage device is basically
broken and needs replacing, and it can't really be relied on for very
much longer.

> Is it something that might be available when RAID1 gets N mirrors
> instead of just 1 mirror?

   The n-copies code will probably support n-copies DUP as well.
There's no reason particularly to restrict it that way.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Do not meddle in the affairs of wizards, for they are subtle, ---  
                           and quick to anger.                           

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU6p+gVheFHXiqx3kAQI7AxAAntxkC15YzRbUWKG0umxTUlTF3lSfAsxF
2LlrEdVAE89WzQxXEu0L3o1BNSc8AfRI8vB373da+UB6S7Dt48NZI3Zoe94cI2dM
lbHY7S7nSC0xwRMBxGDo5EV3bqrlZnn3fLtrpVufcEerO3As69dg4VNiEYqfIYFf
TLpccg0y/uPxCPYlm9jqZlnOukihY4KMtZ3lkicJsDGwas2hO9mwRgWBjdBIT9a+
RJ96LLnCPO6DylKgEJTt65RpnlNKbXIq+0hXAm71F/3a7TDpR+pyk1vuTbKZPvEP
OQdZQjOQ3guJ6EWqQM9xIFQnrsNV/mG/fyujG6XnZoxz5ySinYhT7XTdfhoeDzRy
3C/l9L5asP37k/h5FAdvCphK6r+KH305ZlZ1nV8Klm8kxGNqtd5AyAAF9/Haqzi5
rrkxPVbaAXOTFwrGH6s8bAA0/bHOZs0RKQyb2t3IbUEBuSnuewWjW2eaTq+LhslA
xfYDBgrt6TkB4NraAR76kAdyoCdUgOw+wil8hxtvHGfElBKZM2tLfiArVsEnO7Eb
et+6kvsL24xndb2qW5GgaEl11tN34aOg6QCUAP7Y2yYU0IxSQdo0YYq7di4je5xt
DHwlKx28VyT79DNqfQNonY2ZQyUbWqM/JElnvYpvAP7f5tL1oBaEV9tmNdyAjMo3
7kzI0d+G8Po=
=OAQ3
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
