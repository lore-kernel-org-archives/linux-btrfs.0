Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:47704 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbcGNLyl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 07:54:41 -0400
Received: from [10.1.1.102] (WOPR.lan.crc.id.au [10.1.1.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 3220F3A00DA
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2016 21:54:35 +1000 (AEST)
Subject: Re: btrfs replace performance with missing drive
To: linux-btrfs@vger.kernel.org
References: <1468495129.19617.127.camel@seblu.net>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <95575d97-d909-27fa-bb99-0ae8a247ae02@crc.id.au>
Date: Thu, 14 Jul 2016 21:54:32 +1000
MIME-Version: 1.0
In-Reply-To: <1468495129.19617.127.camel@seblu.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="55dToA2t8vInOgwP0m1BJfGLPlt6aoMGi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--55dToA2t8vInOgwP0m1BJfGLPlt6aoMGi
Content-Type: multipart/mixed; boundary="S7C8gcKmnsES8VSm8vlDF6UH7wJCM0AKi"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <95575d97-d909-27fa-bb99-0ae8a247ae02@crc.id.au>
Subject: Re: btrfs replace performance with missing drive
References: <1468495129.19617.127.camel@seblu.net>
In-Reply-To: <1468495129.19617.127.camel@seblu.net>

--S7C8gcKmnsES8VSm8vlDF6UH7wJCM0AKi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pray that you have no issue with anything in the short term and that you
don't lose power to the system while it is going on.

I did exactly as you are now and ended up with a corrupted filesystem
due to what you are seeing.

DO NOT interrupt it, or you may have big problems with filesystem
integrity afterwards.

See my previous posts to this list for details on what happened to me.

On 14/07/2016 9:18 PM, S=C3=A9bastien Luttringer wrote:
> Hello,
>=20
> I have a performance issue with =C2=ABbtrfs replace=C2=BB with raid5 an=
d a _missing_
> device. My btrfs rely on 6x4TB HDD and the operating system is an Archl=
inux.
>=20
> In a nutshell, I will need 23 to 46 days to replace on missing disk.
>=20
> # btrfs fi sh /home
> Label: 'raptor.home'  uuid: 8739c8b2-110b-44ac-8b4d-285ad06ee446
>         Total devices 7 FS bytes used 14.60TiB
>         devid    0 size 3.64TiB used 2.80TiB path /dev/sdf
>         devid    3 size 3.64TiB used 2.97TiB path /dev/sdh
>         devid    5 size 3.64TiB used 2.97TiB path /dev/sdc
>         devid    6 size 3.64TiB used 2.97TiB path /dev/sdd
>         devid    7 size 3.64TiB used 2.97TiB path /dev/sde
>         devid    8 size 3.64TiB used 2.97TiB path /dev/sdg
>         *** Some devices missing
>=20
>=20
> At a disk full speed (100 MB/s) replacing the missing disk (4 TB) shoul=
d take
> around 8 hours. With the same disk model and same HBA card in another c=
omputer
> with a mdadm/raid5, I could verify this duration could be reach.
>=20
> I also tested a =C2=ABbtrfs replace=C2=BB without a missing disk and th=
e speed was not so
> bad. Somewhere around half disk speed (50-60MB/s). Performances are und=
er
> mdadm.
>=20
> But, in my case, the drive is pass away, I can't use it as source of th=
e
> replace, so I have a replace speed of 1-2MB/s ! Which mean between 23-4=
6 days
> with bad usage performance and security risk.
>=20
> I tried to upgrade the kernel to the latest (4.7-rc6) but it's not bett=
er in
> performance. I got some crash during replace with 4.6.0 which vanish wi=
th the
> last rc.
>=20
> # iostat -md =20
> Linux 4.7.0-rc6-seblu
> (raptor.seblu.net)        14/07/2016      _x86_64_        (4 CPU)
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sdc             356,75        22,51         0,14    9132054      58427
> sdd             356,27        22,51         0,14    9131612      57094
> sde             361,53        22,52         0,14    9132207      57245
> sdf             362,78         0,00         1,81          4     735786
> sdg             357,82        22,51         0,14    9131763      58323
> sdh             325,25        22,52         0,14    9132715      58355
>=20
>=20
> So I have a really poor performance in rebuilding a raid5 mostly when t=
he
> replaced device is missing.
> Is there a parameter to tweak of something I can do to improve the repl=
ace ?=20
>=20
> Regards,
>=20

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--S7C8gcKmnsES8VSm8vlDF6UH7wJCM0AKi--

--55dToA2t8vInOgwP0m1BJfGLPlt6aoMGi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXh314AAoJEEGvNdV6fTHcNnkP/3TLl5utesKz4sMPbccJGNQ8
GJb/6ku9ylIqkWdNGDNM93KaPhfACBQ438c1cAFZtOKrdvVIjqF2Lyrv6XiZ8492
grUDA0+sRI4613UYc/18SzSt2buGRuEYA2MJNgGLvMyPvFG3OofSbuKcZ7IZycJt
33YV1bg6BZ1v/y058lF19YRNfV4IiQfyXUxQ08yXvFlrw2AtlARfMEjo8jbOHyK0
XwW3GKTjRzBFgK+y8ndViGlfMQsDkuWbxcqGsu2GFd3hbYht2RJmv4DexCd8ZJZ2
nM/7lvAZVLs4/G9IUXrBiGfjJUAJL4mD/9lC/Q4/F0AxPeU7ejc9ODaGHurRWrze
aBu4ErsW0qghrdX7j3yq1VuL77QYj/MQuwX79Oy6X3UayMfDreTQR6veqKfNpEZg
OxloINn1gj1uSWUxv9D1IYoaXJafve4vbRkemps6+euCiUx1Pyc3LOMKwT9I9h00
Ys10SIJr843FytjF4QLX6KcxTMsFNeijCyaNWIx/XLRZSe4sfuSTQo+pLVP52h22
TeEgXMX1hlkt1EXTvBmS7bfg4MeLxqiyfJZxY6kUAiZNFcHEpovI4jhbGZWtsp6U
NRtKA49z8+BPOWTYATKIojKu85+rM4qCLq7WuoFL07JxldXw50YbNnqgQGSYR4Nd
s/oVyAmnqfq9hdK9MOxz
=uE+e
-----END PGP SIGNATURE-----

--55dToA2t8vInOgwP0m1BJfGLPlt6aoMGi--
