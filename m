Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8837C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5808720B1F
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 13:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ANirg6C0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfDFN2s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 09:28:48 -0400
Received: from mout.gmx.net ([212.227.15.18]:60387 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfDFN2r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 09:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554557322;
        bh=o0c1IbGgfbGiB0zU+W6DmB5maKykmLTKMtd6Hr7TLy4=;
        h=X-UI-Sender-Class:Subject:From:To:References:Date:In-Reply-To;
        b=ANirg6C0iBwb8ZAs/wYanE/DvWYGIL2Xg0S9ynfugclEAScWqCY+s115IUOH4llKa
         GKk8PY3gBh18i520tDR9cc657XnxRX9AcIs47U1Mzmdt8E38Wmv5ZHZa25veab+ojg
         bTylEtr1LVqc84OOGBIkCIBsdfItRfipztdordts=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MeP5b-1hYZNv1oAp-00Q8vh; Sat, 06
 Apr 2019 15:28:42 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
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
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
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
Message-ID: <de37a79c-fe9e-dbd8-d4b7-397fbdd9b563@gmx.com>
Date:   Sat, 6 Apr 2019 21:28:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dDWaCX1eQNy3Yhlco5RhLj6UQH8H4i4iN"
X-Provags-ID: V03:K1:lQzhfOOiFQSIFwF71mR64/AuSbOVVhzmuVXsvKZk2My6jiepe8p
 heJpPBn79FQp//I9/6Y52Nz8W9MtPleXHWUOc0EJDgqFrxZfMJoq53AfkxT8dQS+Obyl584
 qkDCcQCqQZnPIP62IZEbn3HR6u0NeU76VOfZsmOoqECJ+2+9RO/Cz81pLUJ3im0beueWk4T
 bX2yP78c1OhYv5UgkRFJA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KWc2HeuxshQ=:8M/Z6RMJ5SikYkQFbGIgOk
 HdwP4aqY+Sf3J+cssvF7q7Fd9QeoRz5lU3vsPcCKUWxXL0B8UfW8mMFC01WtzOg84BJgDfZma
 6gZImDajAODtlJJ5dZ38Kt5VSS1qNif2/qg6DA7+2EN2GB6iKbPghJoc2dVJMsMe0td0UnxxE
 D0XpobcmDYgtLWXOJQ2HIqCcWtDoclzwUTcsR71n/f02rSmrStkSRU8IZPYa0Rq1ViNHWa0Ws
 uQ2A1WI0ShpCjfYu4V4fC0xBjsrkY3AcVdxKfFyS1HL1325+ggg+i79VSRRfm62YwYUABaxes
 hnnTbE3B+u8KE0Vc5YypwW9TDE9Dj68PXSxKq1VmXldv1IYSmFHbJOaCIQobNvYS+cmjlDVoH
 /V6/MlCkTQ9W7EdZUksmmbkqP07mJ1t81upK5cXfqgqZ9ihyRTf+lhh4Xi7IPIcxmKic85Zdt
 JcebdFzr9VsJHx0wjRFNlXXqnXZO3p5vk8LZJciDllMERnWTQUHfOuVrPdQ93UT6YcnqYQONa
 C1XReLCGrC3B+WPDL53J7U9/dbiCT46fU6ph3zE21yiUKsCEedbnK2MWWcf3W6tGwXKt3bNHC
 5rNKzIBZzSpenMHRHBG56qzeWpLAwZxbNK2fiRdeplV9XzGtbQsRs367I1rkBLINKIrWYwbPP
 ioQmw/yb0+hSPzLItmbVUvTtCPJXyClrpB3I8ihKvFIZlVgA9EDqLqbnPdjZTHnxFoxIbazYY
 qdaP1y7d/By6F45n0FmcYPSslq9Rb4XukASf8M7nYaZZPd60FqBhQR49q3wLvSpu6N7p8d02Q
 spApGjOIwxl4IXLLjwoFOeJGk0ky2WM+0gsf6D3o9vsLEB24GErOjGITkNz6EicaqicNji8Cr
 yryVi9gJ+0UNUeOP3sLTRmX0hmyJ4tXM62cQwaLer0pTk2eXuAJcZ7Tewwiqz8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dDWaCX1eQNy3Yhlco5RhLj6UQH8H4i4iN
Content-Type: multipart/mixed; boundary="R8xN6qgDco2OIsWCurUMRNryRCB7heLl3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <de37a79c-fe9e-dbd8-d4b7-397fbdd9b563@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
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
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
In-Reply-To: <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>

--R8xN6qgDco2OIsWCurUMRNryRCB7heLl3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8B=E5=8D=889:22, Qu Wenruo wrote:
>=20
>=20
> On 2019/4/6 =E4=B8=8B=E5=8D=889:20, Nik. wrote:
>>
>>
>> 2019-04-06 11:06, Qu Wenruo:
>>>>>
>>>>> Please try again, and sorry for the inconvenience. Hopes this is th=
e
>>>>> last try.
>>>>
>>>> #sudo ./btrfs-corrupt-block -X /dev/md0
>>>> old offset=3D131072 len=3D0
>>>> new offset=3D0 len=3D0
>>>
>>> My bad, the first fix is bad, leading the bad result.
>>>
>>> (And that's why we need to review patches)
>>>
>>> Fortunately we have everything we need to manually set the value, no
>>> magic any more.
>>
>> So I gues the next steps were git fetch, make and run again the above
>> two commands:
>>
>> #git fetch
>> From https://github.com/adam900710/btrfs-progs
>> =C2=A0+ c7bfe8cc...a8c26abd dirty_fix_for_nik -> origin/dirty_fix_for_=
nik
>> (forced update)
>=20
> It looks like you haven't checked out to the correct branch.
>=20
> You could use command 'git checkout origin/dirty_fix_for_nik' to change=

> to the latest branch.

BTW, you could combine the fetch + checkout to 'git pull' directly.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>> #make
>> =C2=A0=C2=A0=C2=A0 [PY]=C2=A0=C2=A0=C2=A0=C2=A0 libbtrfsutil
>>
>> #./btrfs-corrupt-block -X /dev/md0
>> old offset=3D0 len=3D0
>> new offset=3D0 len=3D0
>> Successfully repair tree block at 1894009225216
>>
>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0=
,
>> missing codepage or helper program, or other error.
>>
>> # dmesg|tail
>> ...
>> [56146.672395] BTRFS info (device md0): disk space caching is enabled
>> [56146.841632] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0=
,
>> flush 0, corrupt 2181, gen 0
>> [56148.097242] BTRFS critical (device md0): corrupt leaf: root=3D1
>> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect 15=
003
>> [56148.097583] BTRFS error (device md0): failed to read block groups: =
-5
>> [56148.140137] BTRFS error (device md0): open_ctree failed
>>
>> If the above steps were wrong - please, correct!
>>
>>> The only uncertain part is the size.
>>> If mount still fails, dmesg will tell me the size I need.
>>>
>>>
>>>> Successfully repair tree block at 1894009225216
>>>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>>>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/m=
d0,
>>>> missing codepage or helper program, or other error.
>>>> root@bach:~# dmesg|tail
>>>> ...
>>>> [39342.860715] BTRFS info (device md0): disk space caching is enable=
d
>>>> [39342.933380] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd=
 0,
>>>> flush 0, corrupt 2181, gen 0
>>>> [39344.197411] BTRFS critical (device md0): corrupt leaf: root=3D1
>>>> block=3D1894009225216 slot=3D30, unexpected item end, have 0 expect =
15003
>>>> [39344.197915] BTRFS error (device md0): failed to read block groups=
: -5
>>>> [39344.248137] BTRFS error (device md0): open_ctree failed
>>>>
>>>> Sorry, I forgot to tell: this and previous attempt were with kernel
>>>> 4.15.0-47-generic.
>>>
>>> As long as it can output above message, the kernel version doesn't ma=
ke
>>> much difference.
>>>
>>>
>>>> My Ubuntu 18.04 LTS is having enormous problems with
>>>> Kernel 5.0.2 - very long boot; network, login and other services cyc=
ling
>>>> trough "start, timeout, fail, stop" again and again, etc. If kernel =
5 is
>>>> important I will need time to get it right (maybe even assistance fr=
om
>>>> another(?) developer group).
>>>> Actually with 5.0.2 each boot sends me an email about an empty and n=
ot
>>>> automatically mounted btrfs filesystem with raid1 profile, consistin=
g
>>>> from two devices (sdb and sdi):
>>>>
>>>> kernel: [=C2=A0=C2=A0=C2=A0 9.625619] BTRFS: device fsid
>>>> 05bd214a-8961-4165-9205-a5089a65b59b devid 2 transid 832 /dev/sdi
>>>>
>>>> Scrubbing it finishes almost immediately (see below), but during nex=
t
>>>> boot the email comes again:
>>>>
>>>> #btrfs scrub status /mnt/b
>>>> scrub status for 05bd214a-8961-4165-9205-a5089a65b59b
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scrub started at Sa=
t Apr=C2=A0 6 10:42:15 2019 and finished after
>>>> 00:00:00
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total bytes scrubbe=
d: 1.51MiB with 0 errors
>>>>
>>>> Should I be worried about it?
>>>
>>> You could try btrfs check --readonly and see what's going on.
>>> If btrfs check --readonly is OK, then it should be mostly OK.
>>
>> Then it seems to be ok, thank you!
>>
>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>>
>>>> Kind regards,
>>>> Nik.
>>>> --=C2=A0
>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>>
>>>>>> Thank you.
>>>>>> Nik.
>>>>>> --=C2=A0
>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>
>>>>>>>>
>>>>>>>> Actually there was one warning during make, I don't know of it i=
s
>>>>>>>> relevant:
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0=
 check/main.o
>>>>>>>> check/main.c: In function =E2=80=98try_repair_inode=E2=80=99:
>>>>>>>> check/main.c:2688:5: warning: =E2=80=98ret=E2=80=99 may be used =
uninitialized in
>>>>>>>> this
>>>>>>>> function [-Wmaybe-uninitialized]
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (!ret) {
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>>>>>>> check/main.c:2666:6: note: =E2=80=98ret=E2=80=99 was declared he=
re
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
>>>>>>>>
>>>>>>>> The previous steps were as follow (output ommited, since nothing=

>>>>>>>> unexpected happened):
>>>>>>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>>>>>>> https://github.com/adam900710/btrfs-progs.git
>>>>>>>> #cd btrfs-progs/
>>>>>>>> #./autogen.sh
>>>>>>>> #./configure --disable-documentation --disable-convert
>>>>>>>> #make
>>>>>>>>
>>>>>>>> Did I got the right branch? Or miss any step?
>>>>>>>>
>>>>>>>> Kind regards,
>>>>>>>> Nik.
>>>>>>>> --=C2=A0
>>>>>>>>
>>>>>>>>> If everything goes correctly, it should output something like:
>>>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Successfully repaired tree block=
 at 1894009225216
>>>>>>>>> (And please ignore any grammar error in my code)
>>>>>>>>>
>>>>>>>>> After that, please run a "btrfs check --readonly" to ensure no
>>>>>>>>> other
>>>>>>>>> bit
>>>>>>>>> flip in your fs.
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Qu
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Hope this is ok.
>>>>>>>>>>
>>>>>>>>>> Regards,
>>>>>>>>>> Nik.
>>>>>>>>>> -
>>>>>>>>>
>>>>>>>
>>>>>
>>>
>=20


--R8xN6qgDco2OIsWCurUMRNryRCB7heLl3--

--dDWaCX1eQNy3Yhlco5RhLj6UQH8H4i4iN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoqYIACgkQwj2R86El
/qhjygf8CnLZAqforI3faRRf8K8RETPQBJRex5sDlLp8WOz0SQI7g/ykeAxg6WLX
22X4b9AzI9I5Brnp+dtJi2+cvi0bQFTFbS89McisRMNXyRgpx5142ykuiNoi0jsM
l47hpFl6ejedIxloIFlAtVQTKGKsbeUHmi9lXAHF4MDMXbvjfRWxchVFfPEdsEF/
3QExjkUEaQ7A0o2urqLx4UL1OVYzFN02kUqOrwh2NVV4UFqaeLB6eINMHpDfkjLx
2c0XHbY3dAGsjP0J1+Qah7DlBPLQRDnM2am8QudS6tnTx5IUpZMVWsO8K0aPIYAr
La2JsN5fqBbFUKc5J16vVQNLVbK07Q==
=HPOF
-----END PGP SIGNATURE-----

--dDWaCX1eQNy3Yhlco5RhLj6UQH8H4i4iN--
