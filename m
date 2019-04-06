Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B71CC10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 07:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC972173C
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 07:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CNTXUi3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfDFHpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 03:45:25 -0400
Received: from mout.gmx.net ([212.227.17.20]:60779 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfDFHpY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 03:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554536720;
        bh=aHWZrVg93LcicPhr4lVMaXPNtVLt3SRRh+KmhQgjN/4=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=CNTXUi3ehwpr+R8IHU3MMOJg7pq/qrpEPSQRvOPC3bB+70gVy7ZP5yjWsxkOJOMo5
         vg3kNCpeJWI3p0ljYIFTs0Dtz2zoWM3LgBE00fIiR0rre4YT3po69S5icv476HIcEO
         gU0grwmcdLLJmGw3dQ38Nqg5F2aS0TJA9ZetLnUo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M1BMy-1gswGk0dLM-00tCfR; Sat, 06
 Apr 2019 09:45:19 +0200
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
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
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
Message-ID: <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
Date:   Sat, 6 Apr 2019 15:45:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4CIUvOkfAJ7utomFgrcVP8BzlXqDaynHf"
X-Provags-ID: V03:K1:QbM4g4sCVbQnWZDv8dHg+iKJf0ZuNkkm0rWE9GbnLEr0thvwHNm
 5MwrYrJlVbtO+7Y9EUnHTkUnn1xEt1Q8dv9i3Lp8QPbBOsG+wdiSjGUmebxuA44GyjOkIIw
 Srl52voXZubJycD55ozFIFZWcrzVtvxarmryNdsbWz7P38fhPSrV2aeNUNw8us1Ft+wCtYl
 h8mlU/OEP7bTa7GaWEZgg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:e9R1YpTFLQg=:d5rMZxmMLUOoZjb0en/aML
 vX4ZAEMY1LQpzgtl/csiOSgudjJD0ehHWKUOs7kX02UH8x7Oll6hxNeqYTeR9rq2C8Glgmir9
 ITWEVQFlDsDIiogxnTGhCejjhY1TaBMbFucBGuHC0SJ5hdLfWjMdQ1NBYSc9ZjDB4by9/tw/w
 EACz+1WcYBrYLSjaSL5gg0y2I+4CCUKHgEnlhDXBsPMeq+hoj9y+Kn7GgR5SqWmEAAHwJmM+w
 oHxwEuE97cYARXSjmKyt4NrC7RmaFbpNykO4zEqQj4YbQGyJQNdq420DUZmBUUVwtg6YlbLTL
 lvpBiwKD8gwRcGZjrwEtxQgtPDCunzUPKTEaXsfAuNezdEkcbz3/lEM7QO4ZzQWfoQLp5LkgP
 DKFRdbNrlfb75+K6BbARElswxw1H/+JgjtYEViNdPlVzlx77boqzZ/Muof7iGNv4UXqX2pGOV
 58D0ZD/8eNCizi9DRCfd0MWjsmvOCIxp4o2A2T/Y8ypT3UCSpMJla2a23qGHbGZtOVWdqi1NG
 n9U9vDd5qRHXfO+pK0rrSuM2OQToCdXUO5wwksZXsyeM2eMW6+f7RBt41yZ/AiUoh/nltk+7P
 dFPZIY04mSCIGtnRscZgaNhP1HMDF6Fqk2zJSB4aEWCyxhlikaFFHyNHnuTOWt+ou4nF6007A
 MmRteFisaSH9BRUnefKjDOmxxJaWyMXePiOBPv5+1xA96aTALA2V+CpbvQ14QnNUNwIbqEFOl
 xDvs8eIJIBYT+SWiUCprdHpb8rNgVBcn3N5EVr3LZxL833rNvPKNWbBjlddoyE3g1g+PB7dGN
 t7DYqkbs/Hfv4lkSPPtOFyh0/RPlDNU4WbBS07fx6dNfJTO7ZQQXpN6LZyi6mq/wCpQ6aSMfZ
 ZWI3pcZScQnuFv2rYN7+QqYqzGI7HG8RP3Z6cGR2QT74kkCITIhEbhC0ip+2wu
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4CIUvOkfAJ7utomFgrcVP8BzlXqDaynHf
Content-Type: multipart/mixed; boundary="OKy5i2w6vsAy7xN1Jj5ZLztESbsSkj6kz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
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
In-Reply-To: <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>

--OKy5i2w6vsAy7xN1Jj5ZLztESbsSkj6kz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8B=E5=8D=883:16, Nik. wrote:
>=20
>=20
> 2019-04-06 02:03, Qu Wenruo:
>>
>>
>> On 2019/4/6 =E4=B8=8A=E5=8D=883:38, Nik. wrote:
>>>
>>>
>>> 2019-04-05 10:15, Qu Wenruo:
>>>>
>>>>
>>>> On 2019/4/5 =E4=B8=8B=E5=8D=883:41, Nik. wrote:
>>>>>
>>>>> Below is the stderr of both commands:
>>>>>
>>>>> # btrfs inspect dump-tree -t chunk /dev/md0>DT-chunk.log
>>>>> # btrfs inspect dump-tree -t extent /dev/md0>DT-extent.log
>>>>> ERROR: leaf 1894009225216 slot 30 pointer invalid, offset 146038
>>>>> size 37
>>>>> leaf data limit 16283
>>>>> ERROR: skip remaining slots
>>>>>
>>>>> Since the output on stdout is pretty long even after gzip, I am
>>>>> providing only the output of the first command as attachment. The
>>>>> output
>>>>> of the second command (25 MB after gzip -9) can be downloaded here:=

>>>>>
>>>>> https://cloud.avgustinov.eu/index.php/s/AgbwWyCrbYjenq8
>>>>
>>>> Sorry, I should have use a more specific command to get a smaller
>>>> output.
>>>> But anyway, your output is good enough for me to craft the fix patch=
=2E
>>>>
>>>> Here is the dirty fix branch:
>>>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_nik
>>>>
>>>> Compile the btrfs-progs as usual.
>>>> Just a late hint, you can disable document/btrfs-convert to reduce t=
he
>>>> dependency:
>>>> $ ./configure --disable-documentation --disable-convert
>>>>
>>>> Then, inside btrfs-progs directory, call:
>>>> # ./btrfs-corrupt-block -X /dev/md0
>>> incorrect offsets 15003 146075
>>> Open ctree failed
>>
>> Oh, I forgot it's in extent tree, which may need to be read out at mou=
nt
>> time.
>>
>> Just a new flag can handle it.
>>
>> The branch is updated, please check.
>=20
> New output:
> Successfully repair tree block at 1894009225216
>=20
> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,=

> missing codepage or helper program, or other error.
>=20
> # dmesg|tail
> ...
> [34848.784117] BTRFS info (device md0): disk space caching is enabled
> [34848.954741] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,=

> flush 0, corrupt 2181, gen 0
> [34850.150789] BTRFS critical (device md0): corrupt leaf: root=3D1
> block=3D1894009225216 slot=3D30, unexpected item end, have 131072 expec=
t 15003
> [34850.151209] BTRFS error (device md0): failed to read block groups: -=
5
> [34850.196156] BTRFS error (device md0): open_ctree failed
>=20
> It seems that there is improvement...

Debug info added.

Please try again, and sorry for the inconvenience. Hopes this is the
last try.

Thanks,
Qu
>=20
> Thank you.
> Nik.
> --=20
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Actually there was one warning during make, I don't know of it is
>>> relevant:
>>> =C2=A0=C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0 check/main.o
>>> check/main.c: In function =E2=80=98try_repair_inode=E2=80=99:
>>> check/main.c:2688:5: warning: =E2=80=98ret=E2=80=99 may be used unini=
tialized in this
>>> function [-Wmaybe-uninitialized]
>>> =C2=A0=C2=A0 if (!ret) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>>> check/main.c:2666:6: note: =E2=80=98ret=E2=80=99 was declared here
>>> =C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
>>>
>>> The previous steps were as follow (output ommited, since nothing
>>> unexpected happened):
>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>> https://github.com/adam900710/btrfs-progs.git
>>> #cd btrfs-progs/
>>> #./autogen.sh
>>> #./configure --disable-documentation --disable-convert
>>> #make
>>>
>>> Did I got the right branch? Or miss any step?
>>>
>>> Kind regards,
>>> Nik.
>>> --=C2=A0
>>>
>>>> If everything goes correctly, it should output something like:
>>>> =C2=A0=C2=A0=C2=A0 Successfully repaired tree block at 1894009225216=

>>>> (And please ignore any grammar error in my code)
>>>>
>>>> After that, please run a "btrfs check --readonly" to ensure no other=

>>>> bit
>>>> flip in your fs.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>
>>>>>
>>>>> Hope this is ok.
>>>>>
>>>>> Regards,
>>>>> Nik.
>>>>> -
>>>>
>>


--OKy5i2w6vsAy7xN1Jj5ZLztESbsSkj6kz--

--4CIUvOkfAJ7utomFgrcVP8BzlXqDaynHf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoWQoACgkQwj2R86El
/qh5lQf/Web9oYX8b8KF59Ro2YnHkq2bk+p9f1O5wUFLov2u5B+SKfWHm26Y46uB
+I5iG4vgGrlljKpKZMnaBQCVlcrHf5oYyNHjANZNTGFi3uPw8AS0ugLanMj7MIrx
DybkzQj7lxrkXqEw2RPRhGSzLDAtxvAMR45mmw+kTZeyN/p9L1ssNvhWxtdKmP6A
V2AmhiKM4j/q/NFyZwzzFlNISDRSe0XfIo7D/9FEK7cHN8EU+CrlSSZFUBf3+qPB
3ve9cKRbr/ah9dBMDDMQfy2nFGIePUqEww7Sfznzuaa9zaKPwahgV9edYR9ED2Rt
F7cZBpQCcS279/trjBmegACMayFFFQ==
=DWrW
-----END PGP SIGNATURE-----

--4CIUvOkfAJ7utomFgrcVP8BzlXqDaynHf--
