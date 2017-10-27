Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59201 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932364AbdJ0Auh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 20:50:37 -0400
Subject: Re: [PATCH 2/4] btrfs-progs: fsck: Introduce --fix-dev-size option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, yoasif@gmail.com,
        rrauenza@gmail.com
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
 <20171010075113.10718-3-quwenruo.btrfs@gmx.com>
 <20171010131648.GM3521@twin.jikos.cz>
 <f86fb7cf-5e20-3b04-2ed1-5250df618f24@gmx.com>
 <20171026185838.GH3521@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3b30c9f4-09fb-6322-5d71-9226771581bd@gmx.com>
Date: Fri, 27 Oct 2017 08:50:26 +0800
MIME-Version: 1.0
In-Reply-To: <20171026185838.GH3521@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PWg6wSmeFOWRVevg4EXJ4obsRgmERU7wL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PWg6wSmeFOWRVevg4EXJ4obsRgmERU7wL
Content-Type: multipart/mixed; boundary="5Qv7TAAgLe5LIcQUCsrDVa52uSEIGWfBq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, yoasif@gmail.com,
 rrauenza@gmail.com
Message-ID: <3b30c9f4-09fb-6322-5d71-9226771581bd@gmx.com>
Subject: Re: [PATCH 2/4] btrfs-progs: fsck: Introduce --fix-dev-size option
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
 <20171010075113.10718-3-quwenruo.btrfs@gmx.com>
 <20171010131648.GM3521@twin.jikos.cz>
 <f86fb7cf-5e20-3b04-2ed1-5250df618f24@gmx.com>
 <20171026185838.GH3521@twin.jikos.cz>
In-Reply-To: <20171026185838.GH3521@twin.jikos.cz>

--5Qv7TAAgLe5LIcQUCsrDVa52uSEIGWfBq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8827=E6=97=A5 02:58, David Sterba wrote:
> On Wed, Oct 11, 2017 at 08:43:24AM +0800, Qu Wenruo wrote:
>> On 2017=E5=B9=B410=E6=9C=8810=E6=97=A5 21:16, David Sterba wrote:
>>> On Tue, Oct 10, 2017 at 07:51:11AM +0000, Qu Wenruo wrote:
>>>> Introduce --fix-dev-size option to fix device related problems.
>>>
>>> Please don't add it to 'check', this is not the right place for the
>>> targeted fixes. -> 'btrfs rescue'
>>
>> I'm OK moving the super total_bytes fix to 'btrfs rescue'.
>>
>> But what about the alignment/mismatch detection part?
>> Is it still OK to detect them in 'btrfs check'?
>>
>> And further more, the unaligned device total_bytes problem is not a bi=
g=20
>> problem that fits into 'rescue' territory.
>>
>> I'm not really sure about the difference between rescue and check.
>=20
> Check is supposed to find the problems, and rescue command group is for=

> specific fixes that are not suitable for 'check'. This is to avoid too
> many specific options for 'check' and all the possible combinations.
>=20
> We'll fix the total_bytes bug and don't expect it to be a problem in th=
e
> future again, so we can forget about the subcommand in rescue.
>=20
> What should check report if it detects this kind of inconsistencies,
> that's a good question. It could either fix them automatically (if it's=

> safe) or point to the specific command.

OK, then current behavior, which points to rescue, is good enough.

I don't think it's a good idea to fix it automatically especially when
the default behavior is --readonly.
But fixing it in --repair makes sense, and that's already done in the
patchset.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--5Qv7TAAgLe5LIcQUCsrDVa52uSEIGWfBq--

--PWg6wSmeFOWRVevg4EXJ4obsRgmERU7wL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnygtIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjregf9GPnDFYPcjjQCJ9n5SaBKw9MN
l6Tps4LNl1qrsNgv7wVx+o/yPeVs2NyR1CW4qOJfDPecyXQS1j2FmnIp5FnVX1Xt
uyiXD51RWecj4+IH0VlF9p0n2ECzPQvKWuzR08tg0F63c33vbPRnUcpbJvhxa4jO
osSfmn9zCj3y6ms0BgqziAiaVTJiykybK+DXDRCms/45Bne3k8R/SAIGCm6wrYjD
OH68UefDgM3cLn79cgZ7Ddmqb1ymqJj0GwSvCXbPesraZu6g6ehsaL9ZEQIu2+RD
Y1zn4VGZ/oicMPgh3mjvPsDk3HBY2hl1+GC+RMTTqwG4lOPMCBzNXEUtunkaMA==
=zcr8
-----END PGP SIGNATURE-----

--PWg6wSmeFOWRVevg4EXJ4obsRgmERU7wL--
