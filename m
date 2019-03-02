Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84451C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 04:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F4020838
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 04:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfCBEO6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 23:14:58 -0500
Received: from mout.gmx.net ([212.227.17.21]:44439 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbfCBEO6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Mar 2019 23:14:58 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lj61K-1hXdEe3WsI-00dEuS; Sat, 02
 Mar 2019 05:14:55 +0100
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
 <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com>
 <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
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
Message-ID: <afe23216-7d73-4d33-d80c-15d29f24c64f@gmx.com>
Date:   Sat, 2 Mar 2019 12:14:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nbPXGFyXgqvG3E9FHcP6dGRALgRdZEK4l"
X-Provags-ID: V03:K1:Q2z/TEFvH6T2RHDRgUfBKZBW0nsf74rh9oQU2lufGPdye1GDKYr
 M8/zmHfvqR5SKru/vEfZFHGFuXxzbE/HD4JyjTAPEij5BLKbi3f6Ac7IBb7NIItT2OYwpff
 uanAx7/PRLGKv3nKjllZ7k5T+BQ7IbcyW0ZVEwyPtaIB1fS7pOSqqrSXNy1b4HeIMmAUJtd
 8nFRGSRq2+SpuVR1wXLvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7HNptnB7gYo=:mvGq0dyN2mkcprZnMbbkoT
 fiQjxQKpDZhNXFeLKRA+ZO7zpyiqzl0SJOjtFBF8f2yf5SrUd99fBdsL3zTvaUjJfMFZwO8SR
 SMb4kB84C3vG/NYoMrTxGwCh938neFYIjAPz7kV1ZccmgM9X7WJP6Y6JvMbC7jYzFGv8c47JS
 v6jF2o3xahOjNn/oyeGBe6l2W5DzDwqO8LSR9g5gIqo6scNNb+dmWP6xrTVA7a0p8liCBO5e9
 b6hDB3Hvj7Yv5MURFLvbf6ClTRsA2lUoV6CRoE4k5+VLC+HNi6UE/IrSCiSxd+E2x5PbCvKa3
 DaUuDQUfQWMw997s/a7UH5tyou5e+7DI7oNrcFELYZT0Pbs0YqgYM6dfP+xAvkLn9l/rdDLTz
 CriA5mzlzJISllKjXg5cwqlq2lGxI2W8Am4OYtLoI2NuEYVvu29ULHo/CM3nzE5CH8HbXFELs
 /3ID6KqecKcfkTLAql4dApHaPWfdTlDKlzqchsFi9c7GSVJqUaoGqTCinKK7Nwu5xSTC+MB3j
 EYxpJlhqjL9x2ZZ8+a6RpE57MOzUU1gfR+r7coBu86T1YqmCIz4QNUSfZaWOENtvqKH9oB7eX
 q58OeE+RoHwUZhHSXWHIHK3BEvj0ZqE5JaMUM4XJPireeHLoMLYbgXohxUPMJk0fBVMEQGAUv
 8TgT/uEajkOxQZ8GijK8U+z+/O9dNKVySlJI9cRo3jPgJj1Dse/ogCN0Btee3H2rSOL5SmiM/
 YrKTrzAxacUxoT5nVuK7247SypTBw24SoChGX6uD6kQrofVYUmmhqo4nQpus6l/ogKs2rb8yZ
 DZQ6Ujl8zpZgmm1l+mRnBEE/WWrb2bivpIHQLHEG8uiutH2pn/Bkf+xy4ZmzsoU/nSM5qbA2W
 8hN4fK6uXeBJhcZrI3k40tZf/PAEPG1229RdMTQ0NrlAsySOvccQQuB4YFusob
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nbPXGFyXgqvG3E9FHcP6dGRALgRdZEK4l
Content-Type: multipart/mixed; boundary="J0dVKwVxyADnOFqLLmQ57FQXM3WLwEhIL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <afe23216-7d73-4d33-d80c-15d29f24c64f@gmx.com>
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
 <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com>
 <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
In-Reply-To: <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>

--J0dVKwVxyADnOFqLLmQ57FQXM3WLwEhIL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/2 =E4=B8=8A=E5=8D=8810:29, Chris Murphy wrote:
> On Fri, Mar 1, 2019 at 6:05 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>
>>
>>
>> On 2019/3/2 =E4=B8=8A=E5=8D=888:20, Chris Murphy wrote:
>>> Problem happens with btrfsprogs 4.19.1
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D202717
>>>
>>> That bug report includes the trace in user space; but I've also
>>> processed the resulting coredump file with gdb and attached that to
>>> the bug report.
>>>
>>> Before using --clear-space-cache v1, btrfs scrub and btrfs check came=

>>> up clean no errors. Following the crash, I compiled brfsprogs 4.20.2
>>> and ran 'btrfs check' which finds corruption.
>>>
>>> I've taken no further action, and the btrfs check output gives me no
>>> useful plain language information what the next steps are. So I'm jus=
t
>>> gonna leave it alone since it's a backup volume anyway.
>>
>> Is the backup volume binary dump of the original fs?
>=20
> No. Only btrfs send/receive.
>=20
>=20
>>
>> I'm interesting why clear space cache v1 doesn't work, to find out tha=
t,
>> we need tree dump of the original fs.
>=20
> btrfs insp dump-t -t 2 ? Or the whole thing?

extent tree and root tree.
As those are the only trees modified in clear extent tree.

Thanks,
Qu

>=20
>>
>> And is the original check done by latest btrfs-progs or v4.19.1?
>=20
> The original check is 4.19.1
> The clear cache is 4.19.1
> The subsequent check showing corruption is 4.20.2 but I've found that
> it's the same output for 4.19.1 as well.
>


--J0dVKwVxyADnOFqLLmQ57FQXM3WLwEhIL--

--nbPXGFyXgqvG3E9FHcP6dGRALgRdZEK4l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx6AzsACgkQwj2R86El
/qigBgf/a8V5UJTwlUE/V4NKkULk7GddXarH9TfNuSmGuAyF5vnk2wdMZbbdHr2L
11pjTQBPyfbrxAwJ+wh2VrFqYYAeIDEPkuisJHFg0o4fa+oiGSg9e37Bq7uSR4Ac
PA+tr/XEKghlXCAQwyv3uvHhgqJg1sCD2cDzKI8BP8wRLTK5toNiFzzBq8IZ7r8v
BFasodNBIXr4XBiFIdtZHSwR5N5DtH61nRpzZoRZC14lUyNySGTcJnNnyXcirC5D
71Cezl7qBagOuZHNHQ2BuiY9wpktD+6fqduqK5Tk7Z3hU3wYftvdfwm/3Ue4K4Yh
nw/9LspHq3kwjGaprXctWXTYMQI13A==
=bI8k
-----END PGP SIGNATURE-----

--nbPXGFyXgqvG3E9FHcP6dGRALgRdZEK4l--
