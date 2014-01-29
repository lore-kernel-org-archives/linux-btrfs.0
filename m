Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42454 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaA2M2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 07:28:33 -0500
Date: Wed, 29 Jan 2014 12:28:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: KC <impactoria@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Deleting subvolumes - there be dragons
Message-ID: <20140129122809.GS3314@carfax.org.uk>
References: <52E8E905.8030105@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZgGN478A9hzzvyZc"
In-Reply-To: <52E8E905.8030105@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZgGN478A9hzzvyZc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 12:41:57PM +0100, KC wrote:
> I just read this article here: https://lwn.net/Articles/579009/
> which states:
> 
> ---------------------------------
> btrfs subvolume delete path
> 
>  For ordinary subvolumes (as opposed to snapshots, described below),
> the subvolume indicated by path must be empty before it can be
> deleted.
> ---------------------------------

   As you have found, that's not correct. In fact, there's a couple of
potentially misleading things in that article, just from skimming the
first few paragraphs...

> So I gave it a try:
> 
> $ sudo btrfs subvolume create /home2
> $ sudo mkdir /home2/lalala
> < copy a random pdf file into /home2/lalala) >
> $ sudo btrfs subvolume delete /home2
> 
> And boom! It's all gone!
> Even though subvolume was not empty.
> 
> So apart from the fact that it looks like the article is wrong here,
> it seems very dangerous to me that one simple command can nuke an
> entire volume, even if it's full of files and folders.

   You can do the same thing with rm -rf on any filesystem. So yes,
it's a dangerous command, and you need to be sure you want to run it.

> Of course I'm new to btrfs so maybe I'm reading something wrong. If
> so, then please do set me straight.

   No, I think the author of the article is just mistaken.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- You can't expect a boy to be depraved until he's gone to ---     
                             a good school.                              

--ZgGN478A9hzzvyZc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUujz2VheFHXiqx3kAQI4Mw//US4IbJ/shOaK12F6OdDQDbPx90ZET8w2
h2Rqlyq1wapOepMoY6ibIOcFAzWuDJ3oXyGb+EpVJSvM+TrDVdkzIgaOiYJPNodS
64eULCtCRVaz/wfFjevnxEFerve80jCM90u3K+rdxLUfBlwnlR6liNXKDcHPf2PU
FG9Piui9QvNcUMuzEzbo22US3oWGopui0PZzDn8yrUuJDe4aFaPU3E+LKlF7UfAz
5+uXA2dHVApJwYu06OWNqxEgGO3eBQD8ZDV5O9jn0ND0kmty2EXjoKlowCHm2RbQ
CMoYRXg3z+XOGPQMWZk8usehQFM4OEQJoviQnjwq8nALvv0m8HzuGr1kSqUphfcl
9EZvB7e0qendlXwzbjtCqj1cX2hOTheON+ZySEbSMhKcePKjoHLXxidFna3oBd+5
SR/9JF2MWrvWiwPoSb8y1x9/ZurWTVwUQmwrOGjIKtd8fCOjhL5OSaMG3EH8lgel
9T5/cw+/a5e1Z9Obnjgp+kmvxlIiqZr0XDqpSWhZXMVLOYACC9+Me2InbIOpmq5O
xmty7AoZe18hWlrwxTg9iPraers9Ji+Dv2RuUo8JOkpW7Q1SF7ZR5o25k/P9K9+d
4n/Ggsn+j9XmXGRNvM280zBsNBxNP8cNGm8sr1CgNDyEcSPthVuzO+koPx6rtW2o
OE3xEuBnn8Y=
=rFuT
-----END PGP SIGNATURE-----

--ZgGN478A9hzzvyZc--
