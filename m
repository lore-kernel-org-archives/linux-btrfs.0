Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbeGACHX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 22:07:23 -0400
Subject: Re: btrfs check --readonly crash
To: Lewis Diamond <me@lewisdiamond.com>, linux-btrfs@vger.kernel.org
References: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com>
Date: Sun, 1 Jul 2018 10:07:12 +0800
MIME-Version: 1.0
In-Reply-To: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6diBlttMv8vDoxJ091aCwg4laiYv35hwd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6diBlttMv8vDoxJ091aCwg4laiYv35hwd
Content-Type: multipart/mixed; boundary="wpaNOu9IOLpIPdpSicIdeRvlOLwBqnPx7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lewis Diamond <me@lewisdiamond.com>, linux-btrfs@vger.kernel.org
Message-ID: <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com>
Subject: Re: btrfs check --readonly crash
References: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
In-Reply-To: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>

--wpaNOu9IOLpIPdpSicIdeRvlOLwBqnPx7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8801=E6=97=A5 09:59, Lewis Diamond wrote:
> Hi,
> I've been told to report this issue to this mailing list.
>=20
> sudo btrfs check --readonly /dev/sdc
> Checking filesystem on /dev/sdc
> UUID: 2630aec8-8399-4bd8-9397-8c04953a35d5
> checking extents
> checking free space cache
> there is no free space entry for 1596152365056-1596152381440
> there is no free space entry for 1596152365056-1597220323328
> cache appears valid but isn't 1596146581504
> there is no free space entry for 1613348585472-1613348618240
> there is no free space entry for 1613348585472-1614400192512
> cache appears valid but isn't 1613326450688
> block group 1645538705408 has wrong amount of free space, free space
> cache has 58212352 block group has 58277888
> failed to load free space cache for block group 1645538705408
> block group 1683119669248 has wrong amount of free space, free space
> cache has 52838400 block group has 52953088
> failed to load free space cache for block group 1683119669248
> btrfs: unable to add free space :-17

Your free space cache is corrupted.
And if not handled well, it could (may have already) damaged your fs
further.

You could try "btrfs check --clear-space-cache v1 <dev>" to remove the
free space cache completely and re-try "btrfs check --readonly" to see
if it works.

Thanks,
Qu

> free-space-cache.c:843: btrfs_add_free_space: BUG_ON `ret =3D=3D -EEXIS=
T`
> triggered, value 1
> btrfs(+0x37337)[0x556024d5d337]
> btrfs(btrfs_add_free_space+0x11d)[0x556024d5da2d]
> btrfs(load_free_space_cache+0xde9)[0x556024d5e889]
> btrfs(cmd_check+0x15fe)[0x556024d8b9ee]
> btrfs(main+0x88)[0x556024d38768]
> /usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f9382a9506b]
> btrfs(_start+0x2a)[0x556024d3888a]
> Aborted
>=20
>=20
> This happened on a USB HDD duo in raid 1 which had btrfs issues
> (probably due to a bad controller). One of the hdd was subsequently
> dropped by a 2 year old (causing subsequent checks to crash).
>=20
> -Lewis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--wpaNOu9IOLpIPdpSicIdeRvlOLwBqnPx7--

--6diBlttMv8vDoxJ091aCwg4laiYv35hwd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls4N1EACgkQwj2R86El
/qgxaQf+ICNMwB4sQqCpp+sjllU0GIkcK++RBdbOvUTAVYaqjlGP/5078Omk6ZGF
/BRUQtIDAf49++WXFB/rRps4me3lBWcJLCA2SUI293tUnO5RjaPQ85SFaet4J7zG
VQPZ+QEtUPu07E1DkRFeEZLX2R/YxihhIjN7JtbSiSzByhZlo9Mcv2D+rbX/Fni9
qxqhCRzz28MW5tmZPBYn/7Z+oJJPO8fypWgJhbctsVcAqQrZyLL0DifuTO7Q5jIU
TJVZ2Q3tm/7I6N+E1I2xjPHLCoegSjE6swsm2NrOPm+F5TQBd19x24Ll+cgkHGlw
+0nWvElvjiNRfsnqwrpwF1HcO5lF3A==
=pVZY
-----END PGP SIGNATURE-----

--6diBlttMv8vDoxJ091aCwg4laiYv35hwd--
