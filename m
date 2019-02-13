Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF15C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 07:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBEAF222B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 07:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbfBMHZ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 02:25:26 -0500
Received: from mout.gmx.net ([212.227.17.20]:49557 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732278AbfBMHZ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 02:25:26 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MK3bN-1gudr52lUL-001Nmh; Wed, 13
 Feb 2019 08:24:35 +0100
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Filipe Manana <fdmanana@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <5eafad25-6e8d-5aa1-c162-a298baa6af93@gmx.com>
Date:   Wed, 13 Feb 2019 15:24:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190212181328.GB23918@hungrycats.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MjZdcVfvFedzBChxVb305mYvK6WK6U9Ib"
X-Provags-ID: V03:K1:+lIxxf7vDCKgv0TctVZW8Wl3XCJ7GI42LB0ag5/aco3YEw7BbH2
 SslajwRWKMKr+n2AfjZu8SFQ2y7sGcMsysqsfnUDeTmio9nUVp+cW0zhSywXz8dcNu0MBVo
 Z0+AFNcuNfNK92AM+y5TzdgmB2skGJjnPAj7BP0C6++uI2h+iGrMsukO80A8aKVKudRs7Lk
 78JF4+qXqQsDoRKXxvxpQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nrVLsgCgxqg=:h6q2TthyxYZSmZSn4isdgJ
 QwSaEv6COk79QG5K3RSMyj9otQaAtNiP4G+EJ5nYxz/BUcUAbnuHK95ig3wJezvgJpl8c6bP/
 A+Z8HejVo3r4c5/LfN5kWnx5mHB1APAq3vPMze9HCdb6dfMyjcJf2o72CVNRg5GJpalYxRDxk
 UlytujZeWPoL7o4mO7yyK96ngkn1Ots1or6Y+i1wX69UgrRf3oRx9lmGYbyW2RgEuH/ucDPf3
 Jutz4tpK7iupaJg5NZnfkPPdWX0k7mcHGcT2fN7RHU8O6tDR299fMyin+EhbrlR/hr3En6Xlb
 kPBAKKWMMe6B9tzJ/fkIAK7hvm9BAi0srNgk5g+X0LPZIRzprthCrVEdaN1By0GRxGu5CY1Dr
 psOToEHaf6mIh09vjqDerd2XwQVoWEAjRQZjxDCU1kWc4ydoB4B2qtyrKI1uB2+kghh7jnK1E
 TfFSYLxY/SSTiomTcR187HUgXRlY/NNelF81RQAnjDCcE0ZVM+DE4vsBtxMzgJQPrgdosWlXJ
 kIVgFS+2gCu+prjduJstlwPK+J9+SITY2SBnZ5cVHm1xgIHIJHNvqV01i/teQK2JLJGhQ9RES
 C9xNpmb4ftjELpIqpsXY9G9TUh2ywmAEJWYGE5Rs5Gr/eKHMHl3M+xY1xaMH2qpVGH9Zgt5dV
 5/BGDpkwwDw2kNhcDaM8YvqQEt6ixiGryjM2tm6VZ3c0DF9J0yPDoMSHWHdQpKEczL/NW07nG
 0V8KcVTBVIPq6squnti8ME98Egh20LT4dZ0Z6d4t8XUB+7GyQfN242huDDN4fg0WZsnlRIZTr
 QtCJIOa8NeApzNqSQgLPmNB95vDiZlsgMOqoectFGq5SlZ5FpsxOUv595wToXZFiXACGM2chu
 fdqg5iOi0IaQnU63RB7yeR0YKjtvopj5fpWE3k+KaTTynyXkPrUCgCBV4LiSu8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MjZdcVfvFedzBChxVb305mYvK6WK6U9Ib
Content-Type: multipart/mixed; boundary="ZUjqtKH99wUDH23dONWaPV5dKWB5foaLa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
 Filipe Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5eafad25-6e8d-5aa1-c162-a298baa6af93@gmx.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org>
In-Reply-To: <20190212181328.GB23918@hungrycats.org>

--ZUjqtKH99wUDH23dONWaPV5dKWB5foaLa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/13 =E4=B8=8A=E5=8D=882:13, Zygo Blaxell wrote:
> On Tue, Feb 12, 2019 at 05:56:24PM +0000, Filipe Manana wrote:
>> On Tue, Feb 12, 2019 at 5:01 PM Zygo Blaxell
>> <ce3g8jdj@umail.furryterror.org> wrote:
>>>
>>> On Tue, Feb 12, 2019 at 03:35:37PM +0000, Filipe Manana wrote:
>>>> On Tue, Feb 12, 2019 at 3:11 AM Zygo Blaxell
>>>> <ce3g8jdj@umail.furryterror.org> wrote:
>>>>>
>>>>> Still reproducible on 4.20.7.
>>>>
>>>> I tried your reproducer when you first reported it, on different
>>>> machines with different kernel versions.
>>>
>>> That would have been useful to know last August...  :-/
>>>
>>>> Never managed to reproduce it, nor see anything obviously wrong in
>>>> relevant code paths.
>>>
>>> I built a fresh VM running Debian stretch and
>>> reproduced the issue immediately.  Mount options are
>>> "rw,noatime,compress=3Dzlib,space_cache,subvolid=3D5,subvol=3D/".  Ke=
rnel is
>>> Debian's "4.9.0-8-amd64" but the bug is old enough that kernel versio=
n
>>> probably doesn't matter.
>>>
>>> I don't have any configuration that can't reproduce this issue, so I =
don't
>>> know how to help you.  I've tested AMD and Intel CPUs, VM, baremetal,=

>>> hardware ranging in age from 0 to 9 years.  Locally built kernels fro=
m
>>> 4.1 to 4.20 and the stock Debian kernel (4.9).  SSDs and spinning rus=
t.
>>> All of these reproduce the issue immediately--wrong sha1sum appears i=
n
>>> the first 10 loops.
>>>
>>> What is your test environment?  I can try that here.
>>
>> Debian unstable, all qemu vms, 4 cpus 4G to 8G ram iirc.=20
>=20
> I have several environments like that...
>=20
>> Always built from source kernels.
>=20
> ...that could be a relevant difference.  Have you tried a stock
> Debian kernel?

I'm afraid you may need to use upstream vanilla kernel other than kernel
from distro, especially for distros who may have heavy backports.

I also tried my test runs, using Arch stock kernel (pretty vanilla) and
upstream kernel.
Both my host and VM tested.
No reproduce either.

Upstream community is mostly focused on upstream vanilla kernel.
Bugs from distro kernel can sometimes be a good clue of existing
upstream bugs, but when dig deeper, vanilla kernel is always necessary.

Would you mind to reproduce it in a as vanilla as possible environment?
E.g. vanilla kernel and vanilla user space progs?

Thanks,
Qu

>=20
>> I have tested this when you reported it for 1 to 2 weeks in 2 or 3 vms=

>> that kept running the test in an infinite loop during those weeks.
>> Don't recall what were the kernel versions (whatever was the latest at=

>> the time), but that shouldn't matter according to what you say.
>=20
> That's an extremely long time compared to the rate of occurrence
> of this bug.  It should appear in only a few seconds of testing.
> Some data-hole-data patterns reproduce much slower (change the position=

> of "block 0" lines in the setup script), but "slower" is minutes,
> not machine-months.
>=20
> Is your filesystem compressed?  Does compsize show the test
> file 'am' is compressed during the test?  Is the sha1sum you get
> 6926a34e0ab3e0a023e8ea85a650f5b4217acab4?  Does the sha1sum change
> when a second process reads the file while the sha1sum/drop_caches loop=

> is running?
>=20
[snip]


--ZUjqtKH99wUDH23dONWaPV5dKWB5foaLa--

--MjZdcVfvFedzBChxVb305mYvK6WK6U9Ib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxjxi0ACgkQwj2R86El
/qgdaQf/WGvIKj/86OGzeODsxCanBW+4zeTrNl0Um+07Ts9H/lnBFjZhzRsN9AL1
rg8me2u0wTbiGOOn5beABUEjA/V2r3qnNc97vpoOyrsVsDQZ2RXenVHwd1sA2ohv
K9jpmIxK8Fr6BNe0Uz1++Cak212wpAQDm4vUONyrP0aKfsDg3r+tgmXNLh0R+nrV
BUU612gPBgDacXHmUslEI6DTnRwjO66u0Y8MyQDfaFHLa8w6CPTa8I49Ti6/0GNX
7o1YFQdos4ZrgNVjN4Q0MO4s7DPoZoejK12Xa2mBebIKAyqlfucKOs0EEztaOqG2
ZT1y70dAis2yTyOQCXX2zpbYVouQBA==
=OVAw
-----END PGP SIGNATURE-----

--MjZdcVfvFedzBChxVb305mYvK6WK6U9Ib--
