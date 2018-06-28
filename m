Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49239 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932320AbeF1CzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 22:55:17 -0400
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Remi Gauvin <remi@georgianit.com>, linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
Date: Thu, 28 Jun 2018 10:55:09 +0800
MIME-Version: 1.0
In-Reply-To: <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fPsvUOz0oP3wUIihyehGJWEhykPZkkY7m"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fPsvUOz0oP3wUIihyehGJWEhykPZkkY7m
Content-Type: multipart/mixed; boundary="CZbH5w9eH9MirXZf7S6znHiXEPMd54FRh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Remi Gauvin <remi@georgianit.com>, linux-btrfs@vger.kernel.org
Message-ID: <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
In-Reply-To: <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>

--CZbH5w9eH9MirXZf7S6znHiXEPMd54FRh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 10:10, Remi Gauvin wrote:
> On 2018-06-27 09:58 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 09:42, Remi Gauvin wrote:
>>> There seems to be a major design flaw with BTRFS that needs to be bet=
ter
>>> documented, to avoid massive data loss.
>>>
>>> Tested with Raid 1 on Ubuntu Kernel 4.15
>>>
>>> The use case being tested was a Virtualbox VDI file created with
>>> NODATACOW attribute, (as is often suggested, due to the painful
>>> performance penalty of COW on these files.)
>>
>> NODATACOW implies NODATASUM.
>>
>=20
> yes yes,, none of which changes the simple fact that if you use this
> option, which is often touted as outright necessary for some types of
> files, BTRFS raid is worse than useless,, not only will it not protect
> your data at all from bitrot, (as expected), it will actively go out of=

> it's way to corrupt it!
>=20
> This is not expected behaviour from 'Raid', and I despair that seems to=

> be something that I have to explain!

Nope, all normal raid1 is the same, if you corrupt one copy, you won't
know which one is correct.
Btrfs csum is already doing much better job than plain raid1.

Please get yourself clear of what other raid1 is doing.

Thanks,
Qu


--CZbH5w9eH9MirXZf7S6znHiXEPMd54FRh--

--fPsvUOz0oP3wUIihyehGJWEhykPZkkY7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0Tg0ACgkQwj2R86El
/qhifgf/VV5K8w+wwMjy0MXyIfv7WKRbDpkslRNlfFJgJbAvoUSFRB1T4xnwesMt
KDRJaMY5xjbIedAfRGHPplqI+7aeJ+7FOzAJb29iGgczVoNvjaXn5x+7XuTZzAsC
6uiGi+R1v/+nwWfW0HvcYMXaSzBl1+VqYlw5QQbe9+fAEf96SWON0FET+ZOgTj95
o43yLvMwzcn5M7wtEvJbjaleFhjq/2QSyulhYE1gKv2UeDB7rIL0hUY8T0vxNXsI
SoR2sX7XEIn0LlBr1oTMD+lKMHr4Y44Z9ghpEsbzloV5w8D51ei6BVLPJYbvN0UU
sQC74SehoRmLzdvEGuqn3KPEdOiL6A==
=Cmcn
-----END PGP SIGNATURE-----

--fPsvUOz0oP3wUIihyehGJWEhykPZkkY7m--
