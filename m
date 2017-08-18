Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moh1-ve3.go2.pl ([193.17.41.134]:42971 "EHLO moh1-ve3.go2.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbdHRIiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 04:38:12 -0400
Received: from moh1-ve3.go2.pl (unknown [10.0.0.134])
        by moh1-ve3.go2.pl (Postfix) with ESMTP id 6D0FC66446F
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 10:38:08 +0200 (CEST)
Received: from unknown (unknown [10.0.0.142])
        by moh1-ve3.go2.pl (Postfix) with SMTP
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 10:38:08 +0200 (CEST)
Date: Fri, 18 Aug 2017 10:38:05 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
Message-ID: <20170818083804.GB20160@pontus.sran>
References: <20170814225740.GK19638@pontus.sran>
 <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
 <CAJCQCtTU9EGhjeug-AzS0TDfySwTQi=dPrFLRDE1Go71E7+W+g@mail.gmail.com>
 <9d24b092-6b03-8d97-b4bd-feb36e00b9e0@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <9d24b092-6b03-8d97-b4bd-feb36e00b9e0@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2017 at 10:59:33PM +0200, Goffredo Baroncelli wrote:
> Patches will follow shortly

With your patches applied:

~ # btrfs fi du -s /mnt/red/\@backup/ /mnt/red/\@backup/.snapshot/monthly_2=
017-08-01_05\:30\:01/ /mnt/red/\@svn/ /mnt/red/\@svn/.snapshot/weekly_2017-=
08-05_04\:20\:02/
     Total   Exclusive  Set shared  Filename
   1.86TiB    75.73MiB   312.77GiB  /mnt/red/@backup/
 320.29GiB       0.00B   312.19GiB  /mnt/red/@backup/.snapshot/monthly_2017=
-08-01_05:30:01/
  52.24GiB    10.19MiB     4.13GiB  /mnt/red/@svn/
   4.35GiB     1.05MiB     4.12GiB  /mnt/red/@svn/.snapshot/weekly_2017-08-=
05_04:20:02/


Best regards,
Piotr Szymaniak.
--=20
Mysle,  ze gdyby  diabel  nie istnial i mialby go stworzyc czlowiek, to
stworzylby go na swoj obraz i podobienstwo.
  -- Fiodor Dostojewski

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEFSphDYLXjiCg60ZUQykCi/VzD2UFAlmWp2sACgkQQykCi/Vz
D2WJwxAAuPSlX2rOuFSQWKVy1Lbvp+qyZ4ss+LMDDPuisNdwGJm/QqJXkr3oLcdl
zk+CDexMYp/mAuv/tvb1rb3fWGUMWwN1v/lEwmG8QP4jh4xdjfa/S9Wi1xIEMAAr
SurCGjKmdXvwwnXLcf4cqNe9WMHBTTGOM8EP8dnN3sJb0Xnfgq7a3ZTIdgRTD8Bz
erL3ypjgguzIxEjrQvEk4n9DQF9JYEa3Y/msLZ8+ZzDnK4+1RSZgWWcbSUp9W6ma
qsRU7UoYojIJmBMJN2dgK560olxE+K7nm9InP1TVswVN4dcKC/4A7lTOnSLm4zIm
KkTRNTD1mly7pyPE8IeMZ8cwgyfZV6kTi2BeXUUNB7u1XSRQFwo+DGMK1y5fKMlo
8pTQ4TBmYlYbkjHOQECCWJSRpboRd+sRsDxzp5NODVKkNV96qj4RLSqHzHC8OnG0
tA7P6YoF8TanhBP0Jc7NB9DWX5k3GsaWNsvN4nJ2PiGZ4ehmfbJ2KkAANe9mTfSM
u7fmN96I2vVW2tfzYnejDUi/atY4lqIbdXPOHqS4zxKbAjPh7CDrdLn4oVkvROtU
iE2jxbgilIHK35LtUCkBwpVY2P4UairMpWJOBBOOBrlfhgHrmryHyvLK7/FJwdiJ
fHJAYaOiGkr0eG/zqE69HchjRIqVkxi/8TpStVDC8PRrunSnlx8=
=DVyU
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
