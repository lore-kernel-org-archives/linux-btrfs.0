Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0005FC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 06:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 929AB21722
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 06:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 929AB21722
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbeKLQni (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 11:43:38 -0500
Received: from mout.gmx.net ([212.227.17.22]:55871 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731594AbeKLQnh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 11:43:37 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MF9WR-1gFlKc04Xj-00GIRR; Mon, 12
 Nov 2018 07:51:38 +0100
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
To:     Anand Jain <anand.jain@oracle.com>,
        Pieter Maes <maescool@gmail.com>, linux-btrfs@vger.kernel.org
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
 <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>
 <738f9c22-0355-ed6c-91cf-366d2c58b11b@gmx.com>
 <3c224cf5-ae12-2de6-80b4-ed161891f9b5@oracle.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <9baa8e8a-be24-6e4c-35bc-b2dc7ed3f153@gmx.com>
Date:   Mon, 12 Nov 2018 14:51:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <3c224cf5-ae12-2de6-80b4-ed161891f9b5@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m9LDfCMAUAKS4HSageqywAN7TMXwHO2z1"
X-Provags-ID: V03:K1:DpaQVtmXisUMrRtLh0yUY/cuqJn7duQO2RW39noCGzbRUqXxuSi
 ny+8kjldvYQdjEtumWEYuD+xqwJDLtcUK+6LCOFQcxN2ty2D7SAfyMeE21Crd1w3OGcfBDK
 vIocJkTD4k/IOUResEjSS/OjUoK1xjKDawAVEVY3TwTZKRph5Fm54Kow7NBTQFoVN15Wub6
 8GD049BxfKvB1Vs1t7nFQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:/c2KNs/6pgE=:WPovgo7SZOtDMDmNqaRLhA
 e3qD2mHG/UcUw4nEwFs94ie79YXGRkjyRAFX8hT7UBNmH06YaoWKxREfkEQC6/NuShsRaUqG3
 27A7R6qqS77iZTmwAdAfjcXnd73rqDWZRrbnA82Ox2Kcr6bWaHw7kVAG9GtmUsy4p4d57H9H6
 6gcQDJOdsJwhYoX72MX+kGyZBWnuxHWRrEmuKYIlwMHtHTK4LXL0HPbrida8bZB3GUoLKU28Q
 TFxw19ajnkSNHwRldgo5Vk5TM8kIJFh+cQUu7d95AwrFWhUHwMvUyIy1wtV/EgOu1I3GttpHI
 zL8X3vd6ji8Fry+HSEOaQIi6nBQzZKDW9gYWXjXa0y5PNbUfTZfXZ4lgftFShBK91atIvYBX/
 yFYzTm7pWG4wQDxgi7svimVqKW+r0jtx/kpUEY7Ez6tMTtzOYhMB89tQeavI/vdD7LGFE4v3A
 OpdKNu/QW9GLSkNHfQP0kA8msba9IfrMxGPQNbVS/n1WJiE7nyr+bz7aQungeJy/FrKPMNTwV
 f6hngIUtRLTedjD+afWwbBcOM+FSvv5wu5KZMIFfzQGXc9AGs2na/Gn0DSdVA7yb2oYz+eHSm
 0ATd/VG8RikUpsxBXQVkSVJY1u3HJqhiuvfFqXKSXzUf8CZWD0taBzTOnC9EpbaAXa8u08b80
 Xm3lxaP8ATMscENFkd1EsbehB6m7oBZNCu2k3TYrfsH9YGS91djoqKmEOf/mf6vqswXv3FyP3
 TJeDfYMl61XZ1n1DaydJsbbVAm0mXcX3mSN85anV3hgl+n4XTAQBM0iI4Pm682BT5jTpZUfA6
 zqyWcUSgMGioMYxxOoE9DR4eJuSaKR8odpXc5YYWOQDhBb0jNXm5+o2uvNe0/biPe0dYmKdWW
 SFESE9DyMjgSppeSMvlnMNKDY20INTA0zVZZzTdZATutudJ3IWM8oKt7kJj/2E
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m9LDfCMAUAKS4HSageqywAN7TMXwHO2z1
Content-Type: multipart/mixed; boundary="gctfvksOsRTvtPZiLtG48bkdTn9CQ6RyF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Pieter Maes <maescool@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <9baa8e8a-be24-6e4c-35bc-b2dc7ed3f153@gmx.com>
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
 <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>
 <738f9c22-0355-ed6c-91cf-366d2c58b11b@gmx.com>
 <3c224cf5-ae12-2de6-80b4-ed161891f9b5@oracle.com>
In-Reply-To: <3c224cf5-ae12-2de6-80b4-ed161891f9b5@oracle.com>

--gctfvksOsRTvtPZiLtG48bkdTn9CQ6RyF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/12 =E4=B8=8B=E5=8D=881:30, Anand Jain wrote:
[snip]
>>>> Btrfs-progs could do it with some extra dirty work.
>>>> (I purposed offline device resize idea, but didn't implement it yet)=

>>>>
>>>> You could use this branch:
>>>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>>>
>>> Qu,
>>>
>>> =C2=A0=C2=A0The online resize should work here right?
>>
>> Nope, the user reported unable to mount RW, due to exhausted metadata
>> space.
>>
>> And due to the failure of RW mount, reported can't do online resize,
>> thus we need to do offline one.
>=20
> =C2=A0Its nice tool fixed the issue here, but in the long term we need
> =C2=A0a way to free some space IMO.

Totally agree we should fix the problem in a proper way.

>=20
> =C2=A0Source of the problem is unable to mount RW when metadata space i=
s
> =C2=A0full. A serious issue.

In my opinion, it's a problem that we shouldn't allow such relocation,
return ENOSPC earlier, other than allowing such relocation and cause
ENOSPC half way.

It may be related to global reservation, but I'm not completely sure.

Anyway, it's not something we can easily debug on the reporter's fs, so
I went the easier way to help the user.

Thanks,
Qu

>=20
> =C2=A0Adding more disk space was viable workaround at this use case, wh=
ich
> =C2=A0might not be true in all use cases. Like user may just want to mo=
unt
> =C2=A0and free some space.
>=20
> =C2=A0I think we need to fine tune the reserve space usage like disting=
uish
> =C2=A0the reserve space allocation between the new metadata item VS
> =C2=A0modification of the old metadata items. And reserve a space for
> =C2=A0the modification of the metadata, so that mount and freeing of
> =C2=A0some files will work.
>=20
> Thanks, Anand
>=20
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Thanks, Anand
>>>
>>>
>>>> It's a quick and dirty fix to allow "btrfs-corrupt-block -X
>>>> <device>" to
>>>> extent device size to max.
>>>>
>>>> Please try above command to see if it solves your problem.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> I hope someone can help me out with this.
>>>>> Thanks!
>>>>>
>>>>
>>


--gctfvksOsRTvtPZiLtG48bkdTn9CQ6RyF--

--m9LDfCMAUAKS4HSageqywAN7TMXwHO2z1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvpIu0ACgkQwj2R86El
/qh3BQgAllBZuPMicNuhlfaA2lpbcVrxTbfhJkefs0yu1MH1TbguyWQmPbiehxFT
WWrb4EeTcA3iAwnlVMnPYv+2cHlOyD4pK5dkIXHGt6uJ3aGF3YfZUPSxuaYcQkVF
s5D/sgc86p3c3cHq5zkqGjTmVJEik/bnXyMS9KOIfiu52KV7NSDjUZZIItWrKGJN
7XHWURuwTGpwwrcUOetnQnj/Cm5DC66X5aAyiKce7uT3L8EJULPKzuSjLNFeFX3L
PSSkicVW83tY8/rPQ/GswM/HSjkRVAQzs8s680TZqnVI5/qkds/7FVEHckbtNUWL
/ugMqnM0I/nibxsWlWCQJWUsifqcUQ==
=ZXil
-----END PGP SIGNATURE-----

--m9LDfCMAUAKS4HSageqywAN7TMXwHO2z1--
