Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79A8C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 07:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779C621850
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 07:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="FVwb2K8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfDEHVv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 03:21:51 -0400
Received: from mout.gmx.net ([212.227.15.18]:55185 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfDEHVv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 03:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554448908;
        bh=xfhX6WJbikuaihRqeHw9um5LXjsK3uW1Gpw/bPn/GAo=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=FVwb2K8eCFKs+GQRXCL3V2xRz9MGP3aWzPw2VxNuRy36iyl7UhpIagOsxTDLaeb9N
         ptgj/vlh4iRuzWhj5HoaTQJaqfXLdTrYm8dwqVgGRGCJWjuaQVvVDO+b0FeQWUUL1q
         NFb9SWAGOwqVKQfrHA7+SpHdbKkQzhq0mYYbqp3k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LuOYx-1gkHiN0k4t-011hoX; Fri, 05
 Apr 2019 09:08:37 +0200
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
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
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
Message-ID: <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
Date:   Fri, 5 Apr 2019 15:08:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JBVmCHumyiauNFzbMcEI1Hu1jKg30BCR0"
X-Provags-ID: V03:K1:Pfk+JwUcpJzqnY22Mo3SGoTsqcvJO+gccgJqdzDjG73dat+Q0TG
 F3iZi6pMXePCl0/3p3x/yk0ofBphS2wsVoPB/IA8S3ec1vi94pjCLk6UoY6qutZ43rHaQrG
 2vdjlg4bcr6uQt3VJZ3lnO4QGnLXPQ5aLkhBbEKTxZ7he6pKwt1KJB5cJuXwY4D/3gRXcdE
 61GDk1PhuiG3OLco2uOWw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:odrIk5QZDpw=:16iwBuk19n3LrOXtccByS2
 E/IIrkBQMV8n4uLw3YwlRkLB3b4xnqBaSgOkAGpRT9e4WmqvlSnhZ2FhgbgwGQ1yT1ndTx1dC
 dYbFj4sxxxbDsOdvHGSKE53GkOsjmfjt+l5vr/0y6cIt91NVlkzrJAs7acmY+W2Y6oQtGcFAs
 pe0GvVZLtPJ2z6H9vx1uLAUhPGGjKTTXqTkUsIr2afxNKMDshE1nqbjiGZ+2VIwBYgR2PC31I
 YwY6cJB1F3/4vaew1RTDTaBVNLTlvWDxDou01APl+6OQLF+CvaINzuSF68AprBODXFyUbr4VV
 pLUrqnGe+lNcDkWKxjaNl2AYzPcocViOARn2lPXbrwwM6pdVjeWI7omC9R77/JhSfoZuVdeM5
 PuOHkjR8KwDNDa/bShjtWeETCZ1oj23V7w0wt2ZpmzdX0SnkV1lwU7wGuiE/PWt/GGdr946LO
 OWpCEjULcr+QyHYOpYqA0CLYv03JSD7BvxrX5eVXioy2ZYKji0rQYCL/pnWMsyXHGRG/eqAAv
 HfToMNZIOLa3VwLHa/N6mdcFULoa76kYfs5IdUfDZl4YcbjtW4JQ9iiizBMgblHUGRwzoVB7j
 Vwz1GZIipB01dA6BK/ftEk2K2EVODOseoIn9B8YlP9YyWihHIQjSjVUVO1+4MUpaZ56jw4sAU
 /wgNtffdhTZiyPHfYukt5n9lkeflsJlw04iZYodGtkb+OS9f2O96dgB8yqvafP51oW3hdpnue
 uYURUFEC/r/eZT5BQkkZVJmDZoRx06g8L6unwxZBmqWKPPA5tSXeUiEgGC0Zc/x7hLc2PHlrS
 B2tJHPRQLEr1CUseGPUEAtg6amuGCBNs7AQysCBPoeeCIBbNOiT3RiCFqEktA8+UNpTpCENV3
 6H9/J/VA6k3vRx0NKWbN1U4ZYEhCh7514PeNjbWFJ4eLpspBPgUSl922bEuuyN
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JBVmCHumyiauNFzbMcEI1Hu1jKg30BCR0
Content-Type: multipart/mixed; boundary="95HPht4MQnTVwmdqV5HzzDe8IZ2G0pzaa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
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
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
In-Reply-To: <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>

--95HPht4MQnTVwmdqV5HzzDe8IZ2G0pzaa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

[snip]
> [73429.172707] BTRFS critical (device md0): corrupt leaf: root=3D2
> block=3D1894009225216 slot=3D30, unexpected item end, have 146075 expec=
t 15003

Exact what we need.

Then please provide the following output:

# btrfs inspect dump-tree -t chunk /dev/md0
# btrfs inspect dump-tree -t extent /dev/dm0

The 2nd command would fail half way, but it should provide enough data
for me to craft the manual fix for you.

Thanks,
Qu

> [73429.176628] BTRFS critical (device md0): corrupt leaf: root=3D2
> block=3D1894009225216 slot=3D30, unexpected item end, have 146075 expec=
t 15003
> [73429.177153] BTRFS error (device md0): failed to read block groups: -=
5
> [73429.197019] BTRFS error (device md0): open_ctree failed
>=20
>=20
>> contain the tree block bytenr, so that we can try to fix that offendin=
g
>> tree block manually.
>>
>> Thanks,
>> Qu
>=20
> Should I try something alse?
> Thank you!
> Nik.
> --=20
>>
>>>
>>>>>> Latest kernel will report anything wrong pretty vocally, in that
>>>>>> case,
>>>>>> dmesg would include the bytenr of corrupted tree block.
>>>>>>
>>>>>> Then I could craft needed commands to further debug the fs.
>>>>>
>>>>> Ok, I will try to post more info tomorrow about this time.
>>>>>
>>>>> Nik.
>>>>> --=C2=A0
>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Thank you for trying to improve btrfs!
>>>>>>>
>>>>>>> Nik.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>
>>>>>>> You are not from the 007 - lab, are you? ;-)
>>>>>>>
>>>>>>>>>
>>>>>>>>> Kind regards,
>>>>>>>>>
>>>>>>>>> Nik.
>>>>>>>>
>>>>>>
>>>>
>>


--95HPht4MQnTVwmdqV5HzzDe8IZ2G0pzaa--

--JBVmCHumyiauNFzbMcEI1Hu1jKg30BCR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlym/vEACgkQwj2R86El
/qhFtgf9ED5eER0E4EdVz4LSkeZswnpedrQc+KHIof9uI7JpxikGA3J0nbYKXh9B
vbtP/puBibLzdCKQg78+4n3/UbQB9noXZqpl2RxXn6K8XdmYQ3f16jhu7YY6roK5
ouvuPcur9c6jUH13qJ8nhLLn/rrCdzBTWhbUl7SfiU3xwa4XgWJBwC7RGwEQ4+AL
2VWdxxHgMbT9DeXg7VKzIKgpTumIqp0mJvMyS2Nv+uNohUwhP8I+XndjNjv+xnKq
kPPLGCICsX/EE5mHTZoL94NVo7+zm8n3eBLlfhCH1K9sBsUnB0gKCISltuSWiCzp
6V8m08Ay0wGEtIiTD2r0fx3ZomgttQ==
=oCXo
-----END PGP SIGNATURE-----

--JBVmCHumyiauNFzbMcEI1Hu1jKg30BCR0--
