Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59840 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2LLWwA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 17:52:00 -0500
Date: Wed, 12 Dec 2012 22:51:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: no activity in kernel.org btrfs-progs git repo?
Message-ID: <20121212225157.GD19051@carfax.org.uk>
References: <20121212224214.GA9195@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
In-Reply-To: <20121212224214.GA9195@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 12, 2012 at 02:42:14PM -0800, Zach Brown wrote:
> It looks like it's been a bit more than two months since
> 
>   http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=summary
> 
> saw patches from the list.
> 
> Am I looking in the wrong place for the btrfs-progs upstream?

   Two things:

1) That tree is generally only ever updated for pull requests to Linus
   during the merge window. Would that it were otherwise, but I
   suspect that...

2) ... you may want to know about josef's btrfs-next tree:

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Integration_repository_.28btrfs-next.29

   It's regarded as fairly unstable, so only run it on systems for
testing purposes (or if josef tells you it's OK and will fix one of
your problems).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Do not meddle in the affairs of wizards, for they are subtle, ---  
                           and quick to anger.                           

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUMkKjb9z9OVl50rAAQKNug//XNvGGiwH/ag/KZ23m3KWEMB1ICqg4nUB
kCqXz5QI98MYJiPeXVS1iR5Acf/BnGGm9uH0nLLEggSBnMXa/1nZXbumsY6z3RTk
HwDY/rbp412Fhu3RoDALzxy9BlTeG8fG5bt5leOZtZHezbfZALqQ/6KGJAPNqrOR
25XwO0mNRZ+SNbxlNrHEF690ZPGG7STW2YE67aS11YSe7OR/Uw500PrWuhz2ZxrK
jV/Yv4mxUtl/tHCtjHUfMYihR5nXhDrT3Srvl2CU8Nzx4NVe1aWmsBpkSkOqYi9I
B8rte4pKxmuYbCZPmOArsEu9GzV/c8Ifjwl9SHOsTzbp4BUsezmDEMeiVAcqnza9
Y4FC2w4Hs5K5quoN0BfvmsfLOgcBQCDmhbQ+TGNDNTec9hjnTePWTkdmXy4d5Vsh
6RKZEQelTR5nKGqQHoMdH5LemHpH3OeFHZL1jJUpnw0PVjtVj1/GUOoy76s+r73z
DEBlQmD7UtpogJe4pz7TherE11A4y57Uf2/ueObVsvLG8WZS01MbQjNwJEA1wDhG
AnotjQ5SaZlArU93M6p2kZQkEXTl0hNzCVm4cgEUmqglPTXoTVJJIscNpSN1ikgI
QTcofJoI/bUEJcv2gEMKR8aj50Jm1kI7awQDOZ7XM7CMr8FvSg82uDhOMdb//leJ
7fT+m6ruL9o=
=nbZg
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
