Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67DCC10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CD02173C
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Hgz2G3o5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfDFNWh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 09:22:37 -0400
Received: from mout.gmx.net ([212.227.15.18]:40273 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfDFNWg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 09:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554556953;
        bh=aomUiN+FSnxpseeknfAVTkpgtkt1NgBuXyeTMG4v8P8=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Hgz2G3o5QluuAIA+6bN5gg2BPGyM14OnjPO18SbSTMCbU74muq42XeZsrwbfq0xOr
         wWhtDOSOWjWbAZ3uV664SPqoWEcbGW7eDybg2oxAJs/DjblfA8pkcDhO2dcpsIZPRi
         BOmGCh8qjHmVTTmNDcOyTNEChh+/tsnJtnVAjq3w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LaXEN-1gUJip03hv-00mN54; Sat, 06
 Apr 2019 15:22:33 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
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
Message-ID: <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
Date:   Sat, 6 Apr 2019 21:22:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tFMRK2gxcP6VXhJM89632dO6isVwUsmzI"
X-Provags-ID: V03:K1:V7FI/i7MHljWwtZlC7qnDMQQG1DBV4RD3K/mwav0LFb7atW1Obh
 /UPn7CBt8AuurEMjIWnBUdtKkXJizzJuYAORYY+KgxNEAzm0FLuBqvbiKcV1or3wi3ITy8k
 N2F5pqLn03nvaQo0Q1Pv4GJw1RZfHyvXAKq+OL8+kZzy6OBsXGlodwFJ99/o08m0z+C90UA
 WOmVD3hlS9u6gDQue9+tQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:K8zTKkNti8o=:TQAou7gjL2e5RtAuHpkTFK
 BocZvuTy4ty4vDWVM6IYM6p0iufKOjbEalAXUsJ0MeOhlTUcZekJkVFCH8UVT949thrihM2Cf
 VYE2RaPxRMDzlsPK1vNzWaqwUNJiHqpbwna6HenucJ5kXSv6BdK5ViWDEP0xOiR4ep7LpIsJN
 hgR9849SjAb/ZgxQibV+Is+77cnFAENF9RyjUwudvpggiJh/QaFpdHGfFjeDwGs7E85oVV0ER
 dPpwpTv8wSHqtG0HtrRUPKgSJPTwy4F5HTNcDcmNzIXnrkWYlxcz+jJceTMOZrcGGyWCNd4A6
 LH6xevp5jSkY4Gk/lzkG8FKyF082U/yw4KhV93x3765r6NmyW8UidAeyjNoGErlikvQEVXlI4
 6WX7q+JmSmpG4eOKywrdZ2lfMRXGLE+QKzqQ5+c61pgMQapnyrf+yD7Iig3hkT1BRX+GFh/tx
 ufrnGJ0fJ4CbpqB6PwC1eW4FUC5iJUHV2ue5Ux25IUqcti1dnvOlaan7vEenAXAWqzBbfW00F
 qKImRApDhbBM4eDMd1xuvFN2YKFpljQFALctoez6OmyfSYssjLoBPykvcJo3/IpGA7uEKG9lV
 6Rt8/5oXPuAV8tvB6ybJqTLnQuBzHmSSfQ/e7mogW50JPGXPlAFTIchN+vbyNQtnr9FJPDucR
 MmKmC89DC6zU+mKgwQuuuyJoalZD1+ymJCX7hpBxHt7CRSrRqyJZNrbrlLpStSOXLbZc2LFlW
 QV7KLTIpdNX7dbEnppOCrzgqQwhF3xu9dMbtXQtO6Km7GzPTpnnqSqUjHuGm6n881z3fyouws
 gBdzGEhDAXvCHaJqs3IKoGCnV3XHZva+fxbtt63Qt0LcUwuEE4Q4QuTOcVd2k2Cq7ms4fixYQ
 TK2UtDtHQMHPdssymls/s0U783egFJiFMqts1NRBYlctOGaip+yUT0f4j0+9oG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tFMRK2gxcP6VXhJM89632dO6isVwUsmzI
Content-Type: multipart/mixed; boundary="Hnh7zCfjb1VKtRLKlqpn0ZmfQIxI6P7Qo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
In-Reply-To: <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>

--Hnh7zCfjb1VKtRLKlqpn0ZmfQIxI6P7Qo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8B=E5=8D=889:20, Nik. wrote:
>=20
>=20
> 2019-04-06 11:06, Qu Wenruo:
>>>>
>>>> Please try again, and sorry for the inconvenience. Hopes this is the=

>>>> last try.
>>>
>>> #sudo ./btrfs-corrupt-block -X /dev/md0
>>> old offset=3D131072 len=3D0
>>> new offset=3D0 len=3D0
>>
>> My bad, the first fix is bad, leading the bad result.
>>
>> (And that's why we need to review patches)
>>
>> Fortunately we have everything we need to manually set the value, no
>> magic any more.
>=20
> So I gues the next steps were git fetch, make and run again the above
> two commands:
>=20
> #git fetch
> From https://github.com/adam900710/btrfs-progs
> =C2=A0+ c7bfe8cc...a8c26abd dirty_fix_for_nik -> origin/dirty_fix_for_n=
ik
> (forced update)

It looks like you haven't checked out to the correct branch.

You could use command 'git checkout origin/dirty_fix_for_nik' to change
to the latest branch.

Thanks,
Qu

> #make
> =C2=A0=C2=A0=C2=A0 [PY]=C2=A0=C2=A0=C2=A0=C2=A0 libbtrfsutil
>=20
> #./btrfs-corrupt-block -X /dev/md0
> old offset=3D0 len=3D0
> new offset=3D0 len=3D0
> Successfully repair tree block at 1894009225216
>=20
> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,=

> missing codepage or helper program, or other error.
>=20
> # dmesg|tail
> ...
> [56146.672395] BTRFS info (device md0): disk space caching is enabled
> [56146.841632] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,=

> flush 0, corrupt 2181, gen 0
> [56148.097242] BTRFS critical (device md0): corrupt leaf: root=3D1
> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect 150=
03
> [56148.097583] BTRFS error (device md0): failed to read block groups: -=
5
> [56148.140137] BTRFS error (device md0): open_ctree failed
>=20
> If the above steps were wrong - please, correct!
>=20
>> The only uncertain part is the size.
>> If mount still fails, dmesg will tell me the size I need.
>>
>>
>>> Successfully repair tree block at 1894009225216
>>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md=
0,
>>> missing codepage or helper program, or other error.
>>> root@bach:~# dmesg|tail
>>> ...
>>> [39342.860715] BTRFS info (device md0): disk space caching is enabled=

>>> [39342.933380] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd =
0,
>>> flush 0, corrupt 2181, gen 0
>>> [39344.197411] BTRFS critical (device md0): corrupt leaf: root=3D1
>>> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect 1=
5003
>>> [39344.197915] BTRFS error (device md0): failed to read block groups:=
 -5
>>> [39344.248137] BTRFS error (device md0): open_ctree failed
>>>
>>> Sorry, I forgot to tell: this and previous attempt were with kernel
>>> 4.15.0-47-generic.
>>
>> As long as it can output above message, the kernel version doesn't mak=
e
>> much difference.
>>
>>
>>> My Ubuntu 18.04 LTS is having enormous problems with
>>> Kernel 5.0.2 - very long boot; network, login and other services cycl=
ing
>>> trough "start, timeout, fail, stop" again and again, etc. If kernel 5=
 is
>>> important I will need time to get it right (maybe even assistance fro=
m
>>> another(?) developer group).
>>> Actually with 5.0.2 each boot sends me an email about an empty and no=
t
>>> automatically mounted btrfs filesystem with raid1 profile, consisting=

>>> from two devices (sdb and sdi):
>>>
>>> kernel: [=C2=A0=C2=A0=C2=A0 9.625619] BTRFS: device fsid
>>> 05bd214a-8961-4165-9205-a5089a65b59b devid 2 transid 832 /dev/sdi
>>>
>>> Scrubbing it finishes almost immediately (see below), but during next=

>>> boot the email comes again:
>>>
>>> #btrfs scrub status /mnt/b
>>> scrub status for 05bd214a-8961-4165-9205-a5089a65b59b
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scrub started at Sat=
 Apr=C2=A0 6 10:42:15 2019 and finished after
>>> 00:00:00
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total bytes scrubbed=
: 1.51MiB with 0 errors
>>>
>>> Should I be worried about it?
>>
>> You could try btrfs check --readonly and see what's going on.
>> If btrfs check --readonly is OK, then it should be mostly OK.
>=20
> Then it seems to be ok, thank you!
>=20
>=20
>> Thanks,
>> Qu
>>
>>
>>>
>>> Kind regards,
>>> Nik.
>>> --=C2=A0
>>>
>>>> Thanks,
>>>> Qu
>>>>>
>>>>> Thank you.
>>>>> Nik.
>>>>> --=C2=A0
>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Actually there was one warning during make, I don't know of it is=

>>>>>>> relevant:
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0=
 check/main.o
>>>>>>> check/main.c: In function =E2=80=98try_repair_inode=E2=80=99:
>>>>>>> check/main.c:2688:5: warning: =E2=80=98ret=E2=80=99 may be used u=
ninitialized in
>>>>>>> this
>>>>>>> function [-Wmaybe-uninitialized]
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (!ret) {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>>>>>> check/main.c:2666:6: note: =E2=80=98ret=E2=80=99 was declared her=
e
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
>>>>>>>
>>>>>>> The previous steps were as follow (output ommited, since nothing
>>>>>>> unexpected happened):
>>>>>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>>>>>> https://github.com/adam900710/btrfs-progs.git
>>>>>>> #cd btrfs-progs/
>>>>>>> #./autogen.sh
>>>>>>> #./configure --disable-documentation --disable-convert
>>>>>>> #make
>>>>>>>
>>>>>>> Did I got the right branch? Or miss any step?
>>>>>>>
>>>>>>> Kind regards,
>>>>>>> Nik.
>>>>>>> --=C2=A0
>>>>>>>
>>>>>>>> If everything goes correctly, it should output something like:
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Successfully repaired tree block =
at 1894009225216
>>>>>>>> (And please ignore any grammar error in my code)
>>>>>>>>
>>>>>>>> After that, please run a "btrfs check --readonly" to ensure no
>>>>>>>> other
>>>>>>>> bit
>>>>>>>> flip in your fs.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hope this is ok.
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> Nik.
>>>>>>>>> -
>>>>>>>>
>>>>>>
>>>>
>>


--Hnh7zCfjb1VKtRLKlqpn0ZmfQIxI6P7Qo--

--tFMRK2gxcP6VXhJM89632dO6isVwUsmzI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoqBMACgkQwj2R86El
/qgNIgf/fSOWi/CxgBLhfctJzKC1qjzTEFEPA9iRlD/64OwkIyw2SIfdZjoHl8cG
nWw8KXpFDHCHlrmq5doXuqU2o22NwhwAn3biRt20uVQbOwpL/xamURokjT6Bc1Ir
KafjYj/80hTYIQG2nnEa/mK3WNRy5MPLQnX59+DalGsaak3LCo29+tm57k9dIHxw
mpwXOhHXJPM6mSvdrhyENRN5tvy4BPh7aq3ISyRsESLsZ08ciFdYV1JW/1Oif/gg
I5YAmdZwCZZKmYMZsqAzX0tihNRsxnwebqJVmkMMb16y29UHgw9F914An1JbY25o
YxTTSQsGvyQ50cvzBNCGFibR3FmIuQ==
=sQi1
-----END PGP SIGNATURE-----

--tFMRK2gxcP6VXhJM89632dO6isVwUsmzI--
