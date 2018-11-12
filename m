Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF72BC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 02:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC3552084C
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 02:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC3552084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbeKLMDx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 07:03:53 -0500
Received: from mout.gmx.net ([212.227.17.21]:59369 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbeKLMDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 07:03:52 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSp1l-1fwu5F1Vav-00Rm5i; Mon, 12
 Nov 2018 03:12:50 +0100
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
To:     Anand Jain <anand.jain@oracle.com>,
        Pieter Maes <maescool@gmail.com>, linux-btrfs@vger.kernel.org
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
 <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>
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
Message-ID: <738f9c22-0355-ed6c-91cf-366d2c58b11b@gmx.com>
Date:   Mon, 12 Nov 2018 10:12:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SjlfZXMTM0Cj2mOcfXNrIeXVa0UFJwXCC"
X-Provags-ID: V03:K1:gsc7vlIUf8CQ8TDtQxWrjoL1NWsXswG/TxAV4dTAk3jgPc8ljoF
 Q690H8OTnp5fLf9cH2Mfyy85kukPJxSCbm6N22i8oPeW/Q3K7Sb/37ilcINkqh2repUnHd6
 XX5LJZAUapJiyXoYaL7tI/za98sJ52sszEn30oMmvSGYuScesSiQlXRhYJqW6vZfypq5Afb
 xvOiOzBnncFDC6iJ1xdfA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:NHgc7i5MJzI=:/UCNij2x5N697+K8Mvkskt
 VYO+/9piDvWVyrJ1dkBzRKzEbim3uGgDFEC6bJ6TwldeiTiGqUybZKjE+eUZlr4A66nZMm8bu
 /QI73utztrd+VgL05mcX9OjgjGby9C4XQDyq3HK4Urs+a9d89XNwdnzbBc7l3vAiXk/vhUoNW
 af1NWHO7b4fS2SOj5N7tm7rwbjIx6kr/wqoINczrK5jEajALCxP7qYdBoeknFsuFvP7VuVHwO
 LHvFLcA4D4CuVyDCIjZKGka/Pk5P/7FBWSuavTQwpLCNKhdke1GY4uCTNhcL5qtQKJze6zvZT
 /ROR3T6YmznB9TC/UyPhCzI8v/3Vo5bcyzgvH3WfHHxEPq+nftfeqBKSWGlYUATYONdbqoj7G
 Q0PA2WPoikwTLCBN63z5qAY71ICubbws5LnfZp6IwZ5/EbQqXh2RTl1RAwi5GIwr/nhpskQE3
 nI4uWXpYhD6pwlhZjgUCsDgHHe7Z0H5e85TbajBidjCWFXB9rT9IGE829dTOVAJ8aeGFNT1pN
 ziQ44Dwe1pJz+FvDIT80RWyOMXjBwhuam6kBgxEhifVdU4KXN1vgscar0qpfScOV8rSnRYoJ4
 aGWUWiUCWEq3pG6oyx/hxeTmjXt9avvWR2by/IkfrC2/CD/kj39JyoIPF1rCzSTjitbCK51K1
 HrNVBlgGGggAG+xM72tPaTlU0WH11g2SNsNsMpjpiyU58HnxuAvW/QqSpVgv8YPqtidO6z2Qs
 jjKw5zbvmg3Z15Wavta37Wkek9e398ebAwvXYof64DagMTAtNTReKWBhogRfdOaOxdKrIxvPG
 QHb20IkklkX7fxbiQYrggOObrs8ofvE3nO/9bDkBjNfvnJ0Jq+V6D156EbKqJp5joO4CY4jcT
 Y0UFq3643N3kfSfK9+Yz3tPH8au8H86HqWAOYpHmQEvPloMxwbD/XU2Ci2R1oD
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SjlfZXMTM0Cj2mOcfXNrIeXVa0UFJwXCC
Content-Type: multipart/mixed; boundary="3GG7MHgJxyyEG2HyztGhc0tsZE79hCXLR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Pieter Maes <maescool@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <738f9c22-0355-ed6c-91cf-366d2c58b11b@gmx.com>
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
 <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>
In-Reply-To: <cb35cb23-6949-9a25-ccc4-c103b999b3db@oracle.com>

--3GG7MHgJxyyEG2HyztGhc0tsZE79hCXLR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/12 =E4=B8=8A=E5=8D=889:35, Anand Jain wrote:
>=20
>=20
> On 11/09/2018 09:21 AM, Qu Wenruo wrote:
>>
>>
>> On 2018/11/9 =E4=B8=8A=E5=8D=886:40, Pieter Maes wrote:
>>> Hello,
>>>
>>> So, I've had the full disk issue, so when I tried re-balancing,
>>> I got a panic, that pushed filesystem read-only and I'm unable to
>>> balance or grow the filesystem now.
>>>
>>> fs info:
>>> btrfs fi show /
>>> Label: none=C2=A0 uuid: 9b591b6b-6040-437e-9398-6883ca3bf1bb
>>> =C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes used 614.94GiB
>>> =C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 750.00GiB use=
d 750.00GiB path /dev/mapper/vg0-root
>>>
>>> btrfs fi df /
>>> Data, single: total=3D740.94GiB, used=3D610.75GiB
>>> System, DUP: total=3D32.00MiB, used=3D112.00KiB
>>> Metadata, DUP: total=3D4.50GiB, used=3D3.94GiB
>>
>> Metadata usage the the biggest problem.
>> It's already used up.
>>
>>> GlobalReserve, single: total=3D512.00MiB, used=3D255.06MiB
>>
>> And the reserved space is also been used, that's a pretty bad news.
>>
>>>
>>> btrfs sub list -ta /
>>> ID=C2=A0=C2=A0=C2=A0 gen=C2=A0=C2=A0=C2=A0 top level=C2=A0=C2=A0=C2=A0=
 path
>>> --=C2=A0=C2=A0=C2=A0 ---=C2=A0=C2=A0=C2=A0 ---------=C2=A0=C2=A0=C2=A0=
 ----
>>>
>>> btrfs --version
>>> btrfs-progs v4.4
>>>
>>> Log when booting machine now from root:
>>>
>>> ----
>>>
>>> [=C2=A0=C2=A0 54.746700] ------------[ cut here ]------------
>>> [=C2=A0=C2=A0 54.746701] BTRFS: Transaction aborted (error -28)
>>
>> Transaction can't even be done due to lack of space.
>>
>> [snip]
>>>
>>> ----
>>>
>>> When booting to a net/livecd rescue
>>> First I run a check with repair:
>>>
>>> ----
>>>
>>> enabling repair mode
>>> Checking filesystem on /dev/vg0/root
>>> UUID: 9b591b6b-6040-437e-9398-6883ca3bf1bb
>>> checking extents
>>> Fixed 0 roots.
>>> checking free space cache
>>> cache and super generation don't match, space cache will be invalidat=
ed
>>> checking fs roots
>>> reset nbytes for ino 6228034 root 5
>>
>> It's a minor problem.
>> So the fs itself is still pretty health.
>>
>>> checking csums
>>> checking root refs
>>> found 664259596288 bytes used err is 0
>>> total csum bytes: 619404608
>>> total tree bytes: 4237737984
>>> total fs tree bytes: 1692581888
>>> total extent tree bytes: 1461665792
>>> btree space waste bytes: 945044758
>>> file data blocks allocated: 1568329531392
>>> =C2=A0=C2=A0referenced 537131163648
>>> ----
>>>
>>> But then when I try to mount the fs:
>>>
>>> ----
>> [snip]
>>>
>>> rescue kernel: 4.9.120
>>>
>>> ----
>>>
>>> I've grown the blockdevice, but there is no way I can grow the fs,
>>> it doesn't want to mount in my rescue system, and it only mounts
>>> read-only when booting from it, so I can't do it from there either
>>
>> Btrfs-progs could do it with some extra dirty work.
>> (I purposed offline device resize idea, but didn't implement it yet)
>>
>> You could use this branch:
>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>=20
> Qu,
>=20
> =C2=A0The online resize should work here right?

Nope, the user reported unable to mount RW, due to exhausted metadata spa=
ce.

And due to the failure of RW mount, reported can't do online resize,
thus we need to do offline one.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>=20
>> It's a quick and dirty fix to allow "btrfs-corrupt-block -X <device>" =
to
>> extent device size to max.
>>
>> Please try above command to see if it solves your problem.
>>
>> Thanks,
>> Qu
>>
>>>
>>> I hope someone can help me out with this.
>>> Thanks!
>>>
>>


--3GG7MHgJxyyEG2HyztGhc0tsZE79hCXLR--

--SjlfZXMTM0Cj2mOcfXNrIeXVa0UFJwXCC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvo4ZcACgkQwj2R86El
/qjGlggAlNDQJz2fVmEEpWltAxf6epHRT/wyOWtWK1DiGpNIDwFRLOci3x5edbCK
MqK42rQXkmE/3sDRyRddChM3jQ2QJFecDEW3eK799any4VhgirTOY+3wMLiuN2U1
nclb99mf+Nr8h5IslzS3cavEnTxRWcbpiMv/oYl24MbDHZXXfaXxDr9ffoeankeE
aEg45pmbEUAsj20m12Z2ra3ErMU1EKwTsqny0WilBPzG89C5Nrxjkxhi9BDCzbvz
kyA7j2n6gNeRTzUx8A5WW58PRmkvfSecScgizM907hJh4k6IK3H/evwBXouWi1O7
ZrbMObv6I9717zKI/nQtANoKjWK1+g==
=bF0o
-----END PGP SIGNATURE-----

--SjlfZXMTM0Cj2mOcfXNrIeXVa0UFJwXCC--
