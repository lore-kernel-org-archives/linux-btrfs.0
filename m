Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51415 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbeEGMQO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 08:16:14 -0400
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
 <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
 <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>
 <9c7668bf-e5e1-44df-183f-e12b0d990422@gmx.com>
 <20180507114021.GA32018@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3436cbac-41cb-74b8-c0fe-5f9b74bc62e1@gmx.com>
Date: Mon, 7 May 2018 20:16:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180507114021.GA32018@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LV4atocTqEEpXHDjx6iWfrxnyJtIsETQM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LV4atocTqEEpXHDjx6iWfrxnyJtIsETQM
Content-Type: multipart/mixed; boundary="NImx4i8UN5wnN3o0rDKZfp4h4YzT2YbHV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <3436cbac-41cb-74b8-c0fe-5f9b74bc62e1@gmx.com>
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
 <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
 <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>
 <9c7668bf-e5e1-44df-183f-e12b0d990422@gmx.com>
 <20180507114021.GA32018@suse.cz>
In-Reply-To: <20180507114021.GA32018@suse.cz>

--NImx4i8UN5wnN3o0rDKZfp4h4YzT2YbHV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8807=E6=97=A5 19:40, David Sterba wrote:
> On Mon, May 07, 2018 at 10:20:57AM +0800, Qu Wenruo wrote:
>>>>> +++ b/undelete-subvol.c
>>>>> @@ -0,0 +1,53 @@
>>>>> +/*
>>>>> + * Copyright (C) 2018 Fujitsu.=C2=A0 All rights reserved.
>>>>
>>>> IIRC David will remove all such copy right line.
>>>> Is there some principle about this, David?
>>>
>>> Are you referring to this patchset that replace GPL boilerplate by SP=
DX?
>>> https://patchwork.kernel.org/patch/10321621/
>>>
>>> However, I haven't seen a similar patch in btrfs-progs.
>>>
>>
>> Nope, I mean David will remove the Copyright (C) line when applying.
>> Although I'm not completely sure.
>=20
> Removing copyright notices should not be done without an ack from all
> parties and I don't remove the copyright notices from patches if
> present.
>=20
> I personally do not understand and see the point of the explicit
> mentions if we have the signed-off by in git history. Also, when the
> file is touched by many different people over time, the line 'copyright=

> by Evil Company' looks like all the credit goes to the single entitiy.

That seems to be the point. :)

>=20
> There's a point if the code is copied from another source, like the
> test/sha* code that's from an RFC.
>=20
> So, I decided to not care too much about the copyright line as long as
> there's a signed-off and authorship is GPL compatible.

Glad that the policy is now clear.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--NImx4i8UN5wnN3o0rDKZfp4h4YzT2YbHV--

--LV4atocTqEEpXHDjx6iWfrxnyJtIsETQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrwQ4MACgkQwj2R86El
/qjzBAf/e15NiyF3oPNwezKXFG6lo6T1SNRjX0KHYnjERHRjlEfdgCsG/is64WCq
pp2pt+DiPMQ6ZZWJ0zbKhOTP75UW0jnd4PyFdeUzFV3xBKQ6k4ts3vv/YuIWh1Ii
latdAABBtras/Ui5d01lTWQK5a3WyvZBYoMM/5Ro5SNgUiJcWYO0jDceu0kAv1EC
UrsvAS5j7Cd65DhOEVzxIpSUcMcNdx+nMvsOjBte5EDWZI7PS89SkCrqEO89R3V+
UbWgzBUylve7G7z+er05rsbv0vbKyh4aME73cpA5UKKubNiYEYia8F+aY61+vIQb
ZS/qN3P+kDvQkz3pBbxaaW1orQ173w==
=J33q
-----END PGP SIGNATURE-----

--LV4atocTqEEpXHDjx6iWfrxnyJtIsETQM--
