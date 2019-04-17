Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455A3C282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 12:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0ABE206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 12:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Twc2dWmW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfDQMmy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 08:42:54 -0400
Received: from mout.gmx.net ([212.227.17.21]:60405 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbfDQMmy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 08:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555504971;
        bh=0lXAW2GNde8DgZIMCGvdo8nVqQj2DG/KIBXICkHKbzk=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Twc2dWmWzcqxd1wC8ZB1T9vBNiJ0pv0Xf2pYgLvqkezTDRuNnUNyMCgvJ4ara4cdx
         vGP2aF0m0i/kALq9d3I+1nCl0jzjOWz91BG/FW/PiIbf/KqGHLB+j7R5aCDBHjtThw
         TBW/t7CrQj1HpEF9aVwOQaUzWdB6HBSqj4u1XOrc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MdnN3-1hUni801xF-00PezA; Wed, 17
 Apr 2019 14:42:51 +0200
Subject: Re: Corrupted files support needed
To:     Daniel Brunner <daniel@brunner.ninja>, linux-btrfs@vger.kernel.org
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
 <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
 <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
 <20190416130029.6cd174d2@natsu>
 <CAD7Y51g4KFvA1LSFOorarxOce9vhLvX+832Djij-Eq7vA4S+Dg@mail.gmail.com>
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
Message-ID: <4fc3bcca-69b9-dd58-d595-720171c6cd1d@gmx.com>
Date:   Wed, 17 Apr 2019 20:42:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAD7Y51g4KFvA1LSFOorarxOce9vhLvX+832Djij-Eq7vA4S+Dg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZI2WwnYoMqySqX3WZG8fr5cpc4JBIB8ns"
X-Provags-ID: V03:K1:8FZWDe9aasHO4bkQ4y80mGWaB4ofgaQziLFDpvb1FIsHi/N4KEg
 GrBYP9N6OMn4aB9pGkR8ufPA6+l624VeSpZslbO7nldL2p+sobmj+VB3mRASMqXMYZVaiE+
 vuWPazvmZa7uB0xOyqsHaolhvBuq9/daO7gMsGhjD+o1TaR0Z40YujhY0+KpXvkTVD82KyV
 CdDIS0SZQLUIi3/KH1h3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9R9T3I9O8SE=:2M1cLVLLLNMZ/L/FalN1dL
 nRUkf282tAzSodMhlNQZWwUbVdDtp0LOnsza83Lji+ueHxGV6sZIhn8VpvHrmB2tKUSMftpcb
 ELk6IIl8ZtKoW/hFhCQwJZzR1lSo7Jtc360AkuiGxoHEPlH8TpscRyVBqbRi4hUew8ntBc7MT
 00qEdeIb3EjgyWbTaBkirMdA2tmOrdLbAunsogZGwMuDt6j529TTUIimtXZyziko2FTMuEF2Q
 cnm/YpSvumN/chSyBi/QH4uGRBZDMB5DK2NEKupiDG9aWIFAdmlH3/z2JysV5ak7GnZB0hUfr
 6Z3c8B5MExQD+/ERLe6hXNijLeLSxhxSGWfhCcwtt+kxoiCFhZx1liVk6bE75DfoNZ2HxIw5U
 UMc6VxSl+SEUdmTKo9M2AuKPzBvyeV+2+yrWVCCjACUntS/pZYcAedUMjM9Sxdoo3cfbfdtbp
 s81ImmhRwI/bU0TMNQ+LcCoE6sL7Y052LFyovuR1pkctqQhu4+FV5n5T8vp/B3nq1LDCewQDC
 tmF96UHeDo12OdZjILjP9pL679f3mJ5E0i2DePb+8n0N5Z+lPKJxrIZgM/LcZm2hnB4nfJNyi
 jzzLLYxVD4RQF8UvJHx+ngFkmtmxKHyoL5flCT1xZM3pxJ5nhcs59druxFb9glULmj71EZswF
 vMibSE5vRMwYwjmI5T9QYH4WQBPOAqUMSjNq4uBj3tx6t4dPWlIMFtdg+MZv+4n8FvLY+DCIx
 SIOvywVKD2KaArOuj0ZKrNp/CgYd6qypEUctWafFZplvJgIHBHSw11hMfNsZUY7jTkpbfNf+s
 gwfilZNcdTPWhRpP0k+6QtA8ap46fUOqEd5mxr6obYZ/0djKI07apXqmPVnoUoJgrTfMSoROv
 f3d74gDph3jXzXchILPuHjmw5dMd4hrQefiatUf1/RjZJDd/ODvadJJtMW3gV4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZI2WwnYoMqySqX3WZG8fr5cpc4JBIB8ns
Content-Type: multipart/mixed; boundary="pPpvt6lfEPRvYMP1iP8KA0P2PH5uEBohT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Daniel Brunner <daniel@brunner.ninja>, linux-btrfs@vger.kernel.org
Message-ID: <4fc3bcca-69b9-dd58-d595-720171c6cd1d@gmx.com>
Subject: Re: Corrupted files support needed
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
 <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com>
 <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
 <20190416130029.6cd174d2@natsu>
 <CAD7Y51g4KFvA1LSFOorarxOce9vhLvX+832Djij-Eq7vA4S+Dg@mail.gmail.com>
In-Reply-To: <CAD7Y51g4KFvA1LSFOorarxOce9vhLvX+832Djij-Eq7vA4S+Dg@mail.gmail.com>

--pPpvt6lfEPRvYMP1iP8KA0P2PH5uEBohT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/17 =E4=B8=8B=E5=8D=887:16, Daniel Brunner wrote:
> Hi again,
>=20
> the check went through,
> and no errors were reported...
>=20
> I tried mounting the fs again,
> and suddenly all read errors disappeared!

Then there should be something wrong with the disc connection (but why
block layer doesn't complain?)

>=20
> A full copy is already running,
> and after that i will nuke it from orbit.
>=20
> Thank you all for the quick answers,
> I do not completely understand what exactly was going wrong,
> but I am confident that the files are not corrupted anymore (I checked
> a few random ones).

As long as btrfs doesn't report checksum error and your memory is not
faulty, btrfs should ensure all your data is correct.

Glad your problem just disappeared.

Thanks,
Qu

>=20
> -- Daniel
>=20
> (output of the check)
> # btrfs check --readonly /dev/mapper/sde-open
> Opening filesystem to check...
> Checking filesystem on /dev/mapper/sde-open
> UUID: 26a3ef79-15ba-4041-951b-284fbbe08074
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> [5/7] checking only csums items (without verifying data)
> [6/7] checking root refs
> [7/7] checking quota groups skipped (not enabled on this FS)
> found 50094867738635 bytes used, no error found
> total csum bytes: 48133927932
> total tree bytes: 60644540416
> total fs tree bytes: 4307402752
> total extent tree bytes: 1874182144
> btree space waste bytes: 6642842911
> file data blocks allocated: 50464303362048
>  referenced 49273323020288
>=20
> Am Di., 16. Apr. 2019 um 10:00 Uhr schrieb Roman Mamedov <rm@romanrm.ne=
t>:
>>
>> On Tue, 16 Apr 2019 09:46:39 +0200
>> Daniel Brunner <daniel@brunner.ninja> wrote:
>>
>>> Hi,
>>>
>>> thanks for the quick response.
>>>
>>> The filesystem went read-only on its own right at the first read erro=
r.
>>> I unmounted all mounts and rebooted (just to be sure).
>>>
>>> I ran the command you suggested with --progress
>>> All output is flushed away with thousands of lines like those at the
>>> end of the log paste.
>>>
>>> Does it make sense to let it run until the end or can I assume that 2=

>>> drives are bad?
>>> Also I checked SMART values but they seem to be ok.
>>>
>>> https://0x0.st/zNg6.log
>>
>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDA=
TED  WHEN_FAILED RAW_VALUE
>> 190 Airflow_Temperature_Cel 0x0022   047   031   040    Old_age   Alwa=
ys   In_the_past 53 (Min/Max 47/53 #5115)
>>
>> This seems to be normalized as VALUE=3D100-RAW_VALUE by the SMART firm=
ware, and
>> looking at the reading in WORST, indicates that some of your drives ea=
rlier
>> have seen temperatures of as high as 69 C.
>>
>> This is insanely hot to run your drives at, I'd say to the point of "s=
hut off
>> everything ASAP via the mains breaker to avoid immediate permanent dam=
age";
>>
>> Not sure if it's related to the csum errors at hand, but it very well =
might be.
>>
>> Even the current temps of 55-60 are about 15-20 degrees higher than id=
eal.
>>
>> --
>> With respect,
>> Roman


--pPpvt6lfEPRvYMP1iP8KA0P2PH5uEBohT--

--ZI2WwnYoMqySqX3WZG8fr5cpc4JBIB8ns
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly3H0MACgkQwj2R86El
/qigQgf/R+pGlXyPbXGpgoZMZM6Cwjbo89VWcFsjqWflXghwQUcXuE19cPnKXXZU
by4vmsVGaeTPceAAkaPmYnA2Be/mTVU5MhhzTaIFv5oInRHpiZ4Ztgzz0Yv3E93D
7gEsQHm2p52w1AQEwAx3nlfpGrtIwJSAGSq+eR5yLW2RhthX5MArpqlA/g2W/55l
1uTaNIhDcpBFS/UpHZr7QRvvsawqxO5Inq4dUnIMtWE/2xjdj1Kxxctgx2VIFPjW
vnOhSL/ACFjGndk0iJHqU8/+Ou+a2OCLK/CVjgo9YVFtIsWSq8TDIqbqKa9lkqWt
bdKKC+MxmYtO3imNn6A6EuLih/SYJQ==
=s+vW
-----END PGP SIGNATURE-----

--ZI2WwnYoMqySqX3WZG8fr5cpc4JBIB8ns--
