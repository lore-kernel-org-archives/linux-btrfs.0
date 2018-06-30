Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:43485 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbeF3Oo7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 10:44:59 -0400
Subject: Re: btrfs suddenly think's it's raid6
To: marble <marble@hamburg.ccc.de>, linux-btrfs@vger.kernel.org
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
 <4f7902e3-d176-5395-55f1-72bdffab7d47@gmx.com>
 <f120f53c-5bb5-5ba9-fd72-a5cedf3baca1@hamburg.ccc.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c3ab4d25-4642-f208-26de-1696d45615d9@gmx.com>
Date: Sat, 30 Jun 2018 22:44:51 +0800
MIME-Version: 1.0
In-Reply-To: <f120f53c-5bb5-5ba9-fd72-a5cedf3baca1@hamburg.ccc.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8kc3FsVzbHo5PZSkqH6CUyBasJ2sdOPGi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8kc3FsVzbHo5PZSkqH6CUyBasJ2sdOPGi
Content-Type: multipart/mixed; boundary="2Kj4fgkp0AwzpEDoRoyZxfVVbAUqbFmnS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: marble <marble@hamburg.ccc.de>, linux-btrfs@vger.kernel.org
Message-ID: <c3ab4d25-4642-f208-26de-1696d45615d9@gmx.com>
Subject: Re: btrfs suddenly think's it's raid6
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
 <4f7902e3-d176-5395-55f1-72bdffab7d47@gmx.com>
 <f120f53c-5bb5-5ba9-fd72-a5cedf3baca1@hamburg.ccc.de>
In-Reply-To: <f120f53c-5bb5-5ba9-fd72-a5cedf3baca1@hamburg.ccc.de>

--2Kj4fgkp0AwzpEDoRoyZxfVVbAUqbFmnS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8830=E6=97=A5 06:11, marble wrote:
> Hey,
> Thanks for the quick reply :-)
>=20
>> Is there anything like unexpected power loss happens?
> Power loss may have happened.
>> And would you provide the following data for debugging?
>>
>> # btrfs ins dump-super -fFa /dev/mapper/black
> I attached it.

Looks pretty good.
Then we could go through normal salvage routine.

Please try the following commands and especially keep an eye on the
stderr output:

(The follow option is added in recent btrfs-progs releases, so please
ensure your btrfs-progs is up to date)
# btrfs ins dump-tree -b 1084653568 --follow /dev/mapper/black
# btrfs ins dump-tree -b 1083604992 --follow /dev/mapper/black
# btrfs ins dump-tree -b 1083981824 --follow /dev/mapper/black
# btrfs ins dump-tree -b 1084325888 --follow /dev/mapper/black

Or just use old roots and let btrfs check to judge:
# btrfs check --tree-root 1084751872 /dev/mapper/black
# btrfs check --tree-root 1083801600 /dev/mapper/black
# btrfs check --tree-root 1084145664 /dev/mapper/black
# btrfs check --tree-root 1084473344 /dev/mapper/black


>> And further more, what's the device mapper setup for /dev/mapper/black=
?
>> Is there anything like RAID here?
> I think this is the result of luks. "black" is the name I passed to
> cryptsetup open.

Maybe some powerloss screwed up encryption?
I'm not pretty sure how things will happen when power loss happens.

Anyway, let's see how above btrfs check and dump-tree ends.

Thanks,
Qu

>> Thanks,
>> Qu
> Cheers,
> marble
>=20


--2Kj4fgkp0AwzpEDoRoyZxfVVbAUqbFmnS--

--8kc3FsVzbHo5PZSkqH6CUyBasJ2sdOPGi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls3l2MACgkQwj2R86El
/qgNsAf+IbbVgfXhGyb/LfyzYyKlDbqb82XDyivDxcSlVEGLi3ISDu9vHP3WBYKG
QGBk5EDvEdVRuhw74qw/fdYmy7nRKdXBFOIgvA1UahXlyIF+B/9p08Epzx0LWECH
yAIZCsCx0kS/oKOwV0GpLkUcyCkCDzuHHjYPyF++hStd6LAuSv/AuIc0CBdwiDpD
MEKwcM9pI6zEqB/sx7qrjFMKzGsMA27nfo6WZykKjHutNjUegPqabl5PmVDIf20p
jqS3KJooZ7Ms8njgdKFGiCWlRy7lXgtLJPOQYL6UVYxXZmiFy2Y5GJEvafRkw3XW
8nGxdoW9TYh71qmXOzlbDK1DQyScPg==
=AmRs
-----END PGP SIGNATURE-----

--8kc3FsVzbHo5PZSkqH6CUyBasJ2sdOPGi--
