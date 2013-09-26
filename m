Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33039 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab3IZMcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 08:32:36 -0400
Date: Thu, 26 Sep 2013 13:32:33 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: miaou sami <miaousami@hotmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [raidX vs single/dup]
Message-ID: <20130926123233.GA2865@carfax.org.uk>
References: <DUB116-W69F1EBEC6C7619457E5D82A6280@phx.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
In-Reply-To: <DUB116-W69F1EBEC6C7619457E5D82A6280@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 26, 2013 at 12:22:49PM +0000, miaou sami wrote:
> Hi btrfs guys,
> 
> could someone explain to me the differences in mkfs.btrfs:
> 
> - between -d raid0 and -d single

   In RAID0, data is striped across all the devices, so the first 64k
of a file will go on device 1, the next 64k will go on device 2, and
so on. With single, files are allocated linearly on one device.

   (This is assuming smallish files, a filesystem with lots of space.
Even with single, files can still end up being scattered around over
multiple devices -- but with RAID0, even non-fragmented files are
striped)

> - between -m raid1 and -m dup

   In both cases, there are two copies of each metadata block. With
RAID1, it *requires* the two copies to live on different devices. With
DUP, it allows the two copies to live on the same device (e.g. if
there's only one device).

> - between -m raid0 and -m single

   As for -draid0 and -dsingle, but for metadata instead of data.

> My understanding is that raidX should be used in case of multi
> devices and single/dup should be used in case of single device to
> allow duplication, but it is not 100% clear to me...

> As btrfs raid concepts are quite different from traditionnal raid,
> shouldn't we use the words "stripped" and "mirrored" instead of
> raid0/raid1? or even "single" and "duplicated"?
> Then there would be no difference between single/raid0 and
> duplicated/raid1...

   But there _are_ differences between them, as explained above. :)

   I posted a patch a while ago to change the names to something more
logical and expressive, but it didn't get merged.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- Stick them with the pointy end. ---                 

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUkQpYVheFHXiqx3kAQKAiw/9Eo0MQ5yiK8EPQ7lKxpn9wO4PI74j6gen
ZzhxV9CwHAmPRjM6gWVPzc4kr3jQz3QIe3sFiW+XaI1+CQTeDZmiRWsg01xFNHDO
+qq9jyHom53nap4nHon/1Hs7oH8z5ieCYJ+I8t/UBe/hy3SQg3hUwzoXYvWhhRNp
taasA5qt9ApL9TkZhyQucg9PYHCXgplC5IcIBVIAdI1PmTPsAS3hhIDwuy0fC5FJ
+ThmT89QTT8cdEnjYeD4EPVadG6zZU6i4XgC3G//9dPZXnqM67ThfWfWMwQICm7V
r2vRrFx8Uf4CVA2RuNj1gOLu0x7pvd7XwgfkEUfnbquj1TF00+mOIwtKE4Yobk10
maYJwIEU0BXpRbT0dpbMc/3ZPTm+SkbzLTkZg6MvI0s9DpK7F+IYqkebV6B5E21I
WGsEwddy1PCTJwzGaFjSmn2Fr9hEvNaaD2EgES0Zaf1CeEbaKC6y8lAwHllHaBHO
RwzIQVCYcLytkzd58aq71RtxM8DMspWFg6uV4KbDHshomryJ2mLsH/H6rhHAJ4pP
b5/BWqDwsFBBrgVlk7wS0pA5KLK9Thz1NB5ijvXD/bY9Kmq5wQXfyVjynlii3ucd
XKUHz4G7yfrUBE/Euk8Od3o+ds6Z7vNKBatMPx6BDxUdzgQKMN/pgmUfn9Vjj2jB
tB91pv/S7+U=
=O4Fg
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
