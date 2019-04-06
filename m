Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04318C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 09:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9706821855
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 09:06:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ep3fBrzJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfDFJGX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 05:06:23 -0400
Received: from mout.gmx.net ([212.227.17.21]:33023 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfDFJGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 05:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554541579;
        bh=pz0Q3DYZGzrPYbWEem9lp6PidqBFg1o7Rna4LTWszbY=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=ep3fBrzJ4dk2P2imz1tjUWP+SMhw31q8/s84ShrwOy3DqfEZi1ToT1HpB7wr5iL6K
         3BzYcC5LJ5ReV4ttdctUqS7kIvSsnNhMzBEk/29hui8rgEwViHCWM2Wka3m8r+yzWX
         nI310W9D27Pn/KYVxCBKlJOIrdQ6sX6ADME+LVsU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MHXd2-1hBaHW0Hz2-003QEK; Sat, 06
 Apr 2019 11:06:19 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
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
Message-ID: <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
Date:   Sat, 6 Apr 2019 17:06:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YROfgPN4bARmzvig0TIpVqR4yepN9ZPeV"
X-Provags-ID: V03:K1:f5TN7eO9R8DVlFswDfWffYTp7s2gng0Kmnhxtg/DRcV219hFKOv
 yhuaSKnEpY/mCnAUB/teI29Z3qrS50F7gR746k1j6Y3IJGLr1gozMmYkH7luFr8LF6OFvzg
 KXAumtnAdtYrBzb/fT4TzLmy5kwv3iUiOlp9vlFfv9SxbQE9A2xISXjCsm7yEBP23gQ0GPJ
 B1BJ6vk1R5rA9m3GPmDtA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qaaS6OONfC0=:fcdIzBvMUSm/7toA2upN2c
 K3FE84koY+bngoq3LH29oj3BJT94uMfMH9Ne98rt0AKzKSyhIDdt/D8YAvyTO86FTk9hL3/zQ
 My4AdsIbQvl14HrKa3j+nxmn5lfh0sEoN68OZDIpHGWf9GfMnAL4DuqNWM10RwCmwUiDGkNXS
 v/TNu+XzKddwrIzXBmUzYEOmkf3kxtiFZf2lvgTgLywrTZJO7uJQOzlqhE0j1AawQFQWpD9ft
 FY4QVQarXVvBHQgsbxOBpW+bFYaPYSsNxWtEY+X3CE7ND7Huep8cARF9b928mClN9vAqASSWg
 5eegmjjDqI/1bJDkfVnN9Sr6TZE8BxDVYLy2ZgOoJYHzJf1/Spwzv0JjQAdxrUBL4b9vjn4Ys
 KPung1zwIwuRZLPQ+cMYSS555A7FH1cg57aQZb39/yWPRDhcg5xkjyPxHHqElOK8eDn41DBD6
 sWLBqvvwMUvwjYrGgEMNjvWzBJtdpFyFyy8t2FtwZA+GsNKZ3AL+D5iRYEMpEpgx7kFSC0vvX
 jituxfTM7NYM2Xkht69lk3h7b4byOsQKM9JvEYA7Ck+z42Fo/jKau7lk+vpQQ9kyNCKBO7ZMN
 TnZZpijSo3nhhyxSiyPfcuRfbTpaaxGhasMVLMV3eFOxR8DCO+dxHvVEsyehJILn677AvX2Oq
 miZ2tdwlmrnMkIHd+gIBYz20g3NEJ2TJimolfCM+++azAhUhat9P0+2eM9ejcHd2LjJp3ehnx
 qljwC7HokdsO8PsaVgpoO4Drk3/DzdSExwYSfJiB/5krsQGMm4vhbNb+E68GX2BoOt8kHD+OJ
 xhqgERNQjE91skv1WnFW628LEXFM4ExXxgK+cWwOnn01MfDG8GSjILuIUZB0zoRurL6+zu4/k
 vfALitHYXJeslrtzXi2HPDYS9pCsyrBCxERKoShs0aXWuVOyE459houNAL8hX4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YROfgPN4bARmzvig0TIpVqR4yepN9ZPeV
Content-Type: multipart/mixed; boundary="h6PrTgXw7nc8NiOYg18jTjTI3x6QmNx0R";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
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
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
In-Reply-To: <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>

--h6PrTgXw7nc8NiOYg18jTjTI3x6QmNx0R
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

>>
>> Please try again, and sorry for the inconvenience. Hopes this is the
>> last try.
>=20
> #sudo ./btrfs-corrupt-block -X /dev/md0
> old offset=3D131072 len=3D0
> new offset=3D0 len=3D0

My bad, the first fix is bad, leading the bad result.

(And that's why we need to review patches)

Fortunately we have everything we need to manually set the value, no
magic any more.

The only uncertain part is the size.
If mount still fails, dmesg will tell me the size I need.


> Successfully repair tree block at 1894009225216
> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,=

> missing codepage or helper program, or other error.
> root@bach:~# dmesg|tail
> ...
> [39342.860715] BTRFS info (device md0): disk space caching is enabled
> [39342.933380] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,=

> flush 0, corrupt 2181, gen 0
> [39344.197411] BTRFS critical (device md0): corrupt leaf: root=3D1
> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect 150=
03
> [39344.197915] BTRFS error (device md0): failed to read block groups: -=
5
> [39344.248137] BTRFS error (device md0): open_ctree failed
>=20
> Sorry, I forgot to tell: this and previous attempt were with kernel
> 4.15.0-47-generic.

As long as it can output above message, the kernel version doesn't make
much difference.


> My Ubuntu 18.04 LTS is having enormous problems with
> Kernel 5.0.2 - very long boot; network, login and other services cyclin=
g
> trough "start, timeout, fail, stop" again and again, etc. If kernel 5 i=
s
> important I will need time to get it right (maybe even assistance from
> another(?) developer group).
> Actually with 5.0.2 each boot sends me an email about an empty and not
> automatically mounted btrfs filesystem with raid1 profile, consisting
> from two devices (sdb and sdi):
>=20
> kernel: [=C2=A0=C2=A0=C2=A0 9.625619] BTRFS: device fsid
> 05bd214a-8961-4165-9205-a5089a65b59b devid 2 transid 832 /dev/sdi
>=20
> Scrubbing it finishes almost immediately (see below), but during next
> boot the email comes again:
>=20
> #btrfs scrub status /mnt/b
> scrub status for 05bd214a-8961-4165-9205-a5089a65b59b
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scrub started at Sat Apr=C2=A0=
 6 10:42:15 2019 and finished after
> 00:00:00
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total bytes scrubbed: 1.51Mi=
B with 0 errors
>=20
> Should I be worried about it?

You could try btrfs check --readonly and see what's going on.
If btrfs check --readonly is OK, then it should be mostly OK.

Thanks,
Qu


>=20
> Kind regards,
> Nik.
> --=20
>=20
>> Thanks,
>> Qu
>>>
>>> Thank you.
>>> Nik.
>>> --=C2=A0
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Actually there was one warning during make, I don't know of it is
>>>>> relevant:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0 check/m=
ain.o
>>>>> check/main.c: In function =E2=80=98try_repair_inode=E2=80=99:
>>>>> check/main.c:2688:5: warning: =E2=80=98ret=E2=80=99 may be used uni=
nitialized in this
>>>>> function [-Wmaybe-uninitialized]
>>>>> =C2=A0=C2=A0=C2=A0 if (!ret) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>>>> check/main.c:2666:6: note: =E2=80=98ret=E2=80=99 was declared here
>>>>> =C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
>>>>>
>>>>> The previous steps were as follow (output ommited, since nothing
>>>>> unexpected happened):
>>>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>>>> https://github.com/adam900710/btrfs-progs.git
>>>>> #cd btrfs-progs/
>>>>> #./autogen.sh
>>>>> #./configure --disable-documentation --disable-convert
>>>>> #make
>>>>>
>>>>> Did I got the right branch? Or miss any step?
>>>>>
>>>>> Kind regards,
>>>>> Nik.
>>>>> --=C2=A0
>>>>>
>>>>>> If everything goes correctly, it should output something like:
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 Successfully repaired tree block at 18940=
09225216
>>>>>> (And please ignore any grammar error in my code)
>>>>>>
>>>>>> After that, please run a "btrfs check --readonly" to ensure no oth=
er
>>>>>> bit
>>>>>> flip in your fs.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Hope this is ok.
>>>>>>>
>>>>>>> Regards,
>>>>>>> Nik.
>>>>>>> -
>>>>>>
>>>>
>>


--h6PrTgXw7nc8NiOYg18jTjTI3x6QmNx0R--

--YROfgPN4bARmzvig0TIpVqR4yepN9ZPeV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyobAUACgkQwj2R86El
/qi/5gf+JJB3Zb85TbX1zydEu8tV7oBDvbTR5rhx35a2Itj9wK4drTGYWQr/R0Ol
ZFgvQGPq7bLeXuiIQuUMOBtr6hbn7doH37Ek3HLIzltvPcrajM2NF2/56NBY8BP2
YMlITlOMrOwUa97CUC+JB0LWFa6yAlzPVmP4J3YcW/XMv9N7JWOwW+FWRFaTwryk
UgAJNmtAds+CauY9EpLhXlwsbC+JlEVXLPNuRwxoBhfA5QPiFxzYOjjppqjttGnW
F3YN4DxhSxneEOvp0iyNH0yFIjOAxHQajPhqlVI7G1XV+5HtMCX1uA34VBUdgkMZ
0jgxXuWn5cd2U7hzItgGJRwf5lqCJg==
=/M/0
-----END PGP SIGNATURE-----

--YROfgPN4bARmzvig0TIpVqR4yepN9ZPeV--
