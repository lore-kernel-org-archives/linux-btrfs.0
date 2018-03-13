Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752718AbeCMNUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 09:20:41 -0400
Subject: Re: FS unmountable after RAID/LVM problems
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
Date: Tue, 13 Mar 2018 21:20:19 +0800
MIME-Version: 1.0
In-Reply-To: <ghwoygxh77.fsf@lena.gouders.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3cl1IGrg2IjjtR1CQ3oWLtXqrzozY3T6n"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3cl1IGrg2IjjtR1CQ3oWLtXqrzozY3T6n
Content-Type: multipart/mixed; boundary="Ju67NV3yvljgbXR57xxlYOFCYUlmH4RZd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <b0637390-1dfb-940b-ce11-503faef4ff3d@gmx.com>
Subject: Re: FS unmountable after RAID/LVM problems
References: <ghlgew5pbq.fsf@lena.gouders.net>
 <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
 <ghwoygxh77.fsf@lena.gouders.net>
In-Reply-To: <ghwoygxh77.fsf@lena.gouders.net>

--Ju67NV3yvljgbXR57xxlYOFCYUlmH4RZd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 21:01, Dirk Gouders wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>=20
>> On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 16:53, Dirk Gouders wrote:
>=20
> <SNIP>
>=20
>>> find-root:
>>>
>>> # btrfs-find-root /dev/loop0p1
>>> Superblock thinks the generation is 9858294
>>> Superblock thinks the level is 1
>>> Found tree root at 848773120 gen 9858294 level 1
>>
>> Tree root is found, find-root won't help much here.
>> And if it's really tree root corruption, we should have some kernel
>> message for it.
>>
>>> Well block 832045056(gen: 9858272 level: 1) seems good, but generatio=
n/level doesn't match, want gen: 9858294 level: 1
>>
>> Especially when the next tree block is 22 generation older.
>>
>> Would you please try to call "btrfs inspect dump-tree <device>" and
>> paste the result with *stderr*?
>>
>> At least we could know which tree block is corrupted.
>=20
> Here is the result of inspect:
>=20
> # btrfs inspect dump-tree /dev/loop0p1
> btrfs-progs v4.15
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> ERROR: unable to open /dev/loop0p1

OK, one tree block in some important tree is corrupted.

Would you please dump the super block by "btrfs inspect dump-super
<device>" so that we could have some clue about where the corrupted tree
block belongs?

Thanks,
Qu

>=20
> Thanks,
>=20
> Dirk
>=20


--Ju67NV3yvljgbXR57xxlYOFCYUlmH4RZd--

--3cl1IGrg2IjjtR1CQ3oWLtXqrzozY3T6n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqn0BMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhZVgf/fxbRQ8n/TAqjSXMgTp7HGhui
cK3WaoRWpC3E9AcJjnMITLij0mL1DbpWUfb3b8XV3Xg6eNfc/ewidnRWlGrmUDE9
tuR4OjZv7NWFQ5IPMQa0o7QlyWLGl2Sg3K8iHCsAhnblEK+bctwupoZfR0HziTnJ
Qj38ADeQMZ8Dh8VmMWn94hgtqUoze4jNTQO1FiSr5BQqmBX4gB1O4jBP7U/mOURE
OHBQielJhlLBRX86teRooMUc23FnIuT8ZcgBtbqYQvMmyDYYUnFiOG/RkEEwunlN
A/7dO1EN2ZWMnRGHSrftAajtbogoQw2uU5CiQ+u/Ey9MoIX7BxWAFlX1tNI65w==
=izTu
-----END PGP SIGNATURE-----

--3cl1IGrg2IjjtR1CQ3oWLtXqrzozY3T6n--
