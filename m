Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0763FC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 00:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE9802171F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 00:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="RhAd7xzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfDEAru (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 20:47:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:53679 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfDEAru (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 20:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554425265;
        bh=zF4gGWWuHX9lcVl/KGiRPYVqxpXkTx91++NRGe5mtHA=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=RhAd7xzzxclo4ejr9A9IB7hKR2gpp+NYrB3j3U8s3Cd1qDQFl6wnrIoCzI4xTZEwL
         xiAiPkhWWo9Ye+DTv7wZaa8LPQa22LStafe3Fcws59tbaUArWFZOCNlpjjudlYiv7u
         J4m/TjlnJids21d7f4edMA6YEh5xwjM/TZvcKl4Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MJFBe-1hDryX3wwk-002mY8; Fri, 05
 Apr 2019 02:47:45 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
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
Message-ID: <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
Date:   Fri, 5 Apr 2019 08:47:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LCogoLyjpIwapQGpA6N8f0LZUJ17DyOrI"
X-Provags-ID: V03:K1:b5d4etLfjYsKswpNO2b9jP55USgpBLxHW/KUfAOivN34FHELiQJ
 eRXA+s6mT/0Y2ixVlWMQCza6L5IjD8oiSc1KgZxvpGtGEFpwDoNQvTtVn2A6QE8xh5iQ9kB
 cChb0zKq8PQ+kjlDvUVWMWEp6f4BP+Eea3m05J+zQzKyp8R1YcexrPNv1l7FpuVSGnqqmcg
 wtJ78cBfMOGa0YYtfOgnw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:a7FytHquR/I=:urZ4j8eG3ZHPYPZfO7lTjt
 ioHZ/64kWhW/NV1JZLyslpzsf1f0OYqPlSPA9tt/+OpEt+bFHVPc/yMby8DQsGFqVqGAiIQG2
 nEMaVkokM2QA7b8sBz0tRVW7M1knHjA/HU7YcaOeTHOB+9YKExDI5n1+TtRK96yRWzOclxOt2
 0D3YwfFepxBCbBX+0DTPh60I047NtRquzil8aHbu66hBz0coAPZMlZrj0sQHPYVyMlL2Ftz4x
 n6T3oTH080FbY236dsG+IYCcTNtd6grRJjfyAmx2RyaFHsU7vpuLz512g8ttof/2/OZYvA79t
 zm5Jwx6xaXcHg2Y8Kz+Zcp6hdJi8l4kMgBf4MAe6RGfvlrjtfuAK5VnHR1nfhPmlMmUq1zYBd
 CchHdUjHVv2frdBvNBuPcw49URy+/PE7IUWLto4avAcq7efKZOPh3WDu7heSfI4AFug4ygeKx
 LWECIn8bRffeZNpHl9e/4kKD1V/jTcgDZT8V1lVyixqT8+V0fwoOeut4hPqttvSPwm3OYcLao
 q9y7eW85cbUbmLu3lmCay3wJTHS7w8yt6bOZohkcMs2Rgx09iii15VjJ0y67c7u6yRL58X4J2
 UfmGunR6fc/e2HOMG5/Df7HLmgdS7e0ADXIn8v8HI5BaxiD4lUinw++QVSp+A5wSdYsdOfkbc
 fOua7pz2k09apCxcDDIFbVPkUeeonUIeNz1i+Xz8Psn+H5x7OSaj4y3CghJarXOZPBOn0r/gm
 A9PivwUwVQ/nqBUf3DA5ILHp2t6nKLPvBDVjTn+JwzGpZEB576vZVMQ0CtsVHDuFgHGGzqNTH
 57UH72X8HH9eBf3JZ2NgwzoGo5x8OmAkzF5OXa4bpePSSAg9ltSLUq3IZkti/+D0n+MOsNDfF
 SCD/nv41XzN7jrV3Lfe9s2Sul5e1q8GAK9qGwa59nQftaWF3pRnOv5XKiKRIbG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LCogoLyjpIwapQGpA6N8f0LZUJ17DyOrI
Content-Type: multipart/mixed; boundary="tL4b1CCotrEAZj9L5E5aKMh0JT0uCis3d";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
In-Reply-To: <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>

--tL4b1CCotrEAZj9L5E5aKMh0JT0uCis3d
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/4 =E4=B8=8B=E5=8D=8811:27, Nik. wrote:
>=20
>=20
> 2019-04-03 03:04, Qu Wenruo:
>>
>=20
> [snip]
> ...
>=20
>>>> In your case, you just need latest btrfs-progs and re-run "btrfs che=
ck
>>>> --readonly" on it.
>>>
>>> Will try this, but have no time before tomorrow evening.
>>>
>>>
>>>> If it just shows the same result, meaning I can't get the info about=

>>>> which tree block is corrupted, then you could try to mount it with
>>>> -o ro
>>>> using *LATEST* kernel.
>>>
>>> I tried this before with the 4.15.0-46 kernel, it was impossible. Wil=
l
>>> try again with newer one as soon as possible (in best case tomorrow
>>> evening); I will post the results.
>=20
> Sorry for the delay, compiling the btrfs-progs took much more time than=

> expected (had to install new packages again and again). Finally had to
> give up the conversion ("make" could not find reiserfs/misc.h, although=

> both libreiserfscore and reiser4fs are installed).
> Output of the commands:
> # uname -r
> 5.0.6-050006-generic
> #btrfs --version
> btrfs-progs v4.20.2
> # btrfs check --readonly /dev/md0
> Opening filesystem to check...
> incorrect offsets 15003 146075
> ERROR: cannot open file system
>=20
> It seems that I will wait until 5.2 is out...
> (the answer to Jeff Mahoney is coming with separate e-mail!)

OK, then you can try mount it with 5.0 with -o ro.
The objective is not to make it work, but to get the dmesg, which should
contain the tree block bytenr, so that we can try to fix that offending
tree block manually.

Thanks,
Qu

>=20
>>>> Latest kernel will report anything wrong pretty vocally, in that cas=
e,
>>>> dmesg would include the bytenr of corrupted tree block.
>>>>
>>>> Then I could craft needed commands to further debug the fs.
>>>
>>> Ok, I will try to post more info tomorrow about this time.
>>>
>>> Nik.
>>> --=C2=A0
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Thank you for trying to improve btrfs!
>>>>>
>>>>> Nik.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>
>>>>> You are not from the 007 - lab, are you? ;-)
>>>>>
>>>>>>>
>>>>>>> Kind regards,
>>>>>>>
>>>>>>> Nik.
>>>>>>
>>>>
>>


--tL4b1CCotrEAZj9L5E5aKMh0JT0uCis3d--

--LCogoLyjpIwapQGpA6N8f0LZUJ17DyOrI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlympagACgkQwj2R86El
/qh5Lgf9HsD1aEVPmVwuyt6Seldyn1LC4Bi3jut2bhaNOO1aRu/44p/Ii3DOB0zY
a5dtXkLXwLgYqn2k5MtKhI+Qf0MaBWyD1ilm+5+H+gQhzzxbWWMquQMafKDxQ0RE
lueOoFYaJVCdu9Ww2gq7KswgCWF2y61AcKbktwMge4IyrO0KM4uNStw0OJEbms9Y
It5ib7PKfPJaIIJs6JaTchcXHpe+elscpo7VjYRZopL27gLImIkxAuDoSIdYmfN1
eOExCNPTDUR9zzf2b/alpLnTYy7Nz8h0qKVbeO1PkOqrytf5lJn/na+vis9QBSry
WXp9eCOk3xo4iFloxAwArI5xdaW5gg==
=Epmw
-----END PGP SIGNATURE-----

--LCogoLyjpIwapQGpA6N8f0LZUJ17DyOrI--
