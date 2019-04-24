Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EB6C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 09:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 358752148D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 09:50:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="gxUlNDzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfDXJuy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 05:50:54 -0400
Received: from mout.gmx.net ([212.227.17.20]:47111 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfDXJux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 05:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556099446;
        bh=JR74nShSvO2ED8dR9PAsSo70OSSloqwQNRd105Qsqxo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gxUlNDzzN1peB/Maiti34fjGijkN+El6otgkysZKliS+ePSojiLTHIK/H7PBXjuzi
         T1uWzTiF0eUSlSXH8ymG9B8e34FCcHp5qndRdREuG26pIJlIu7z4MCzDMUDuaVQRoi
         2PkTt0DbNfRAGnvN6rhnZBAhkOgK3oc+VQsaXnK4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MZD0K-1h513I2OfE-00KtjK; Wed, 24
 Apr 2019 11:50:45 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     fdmanana@gmail.com
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
 <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
 <8a3b5e64-1df7-447d-3b07-e276b8d65b40@gmx.com>
 <CAL3q7H4cjWJgoNg5C4+KsKFHg66KFmj7CDJiTMM9yBGU-fnjzA@mail.gmail.com>
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
Message-ID: <a5519a4b-be00-95b1-0371-8a62f9c19ca9@gmx.com>
Date:   Wed, 24 Apr 2019 17:50:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4cjWJgoNg5C4+KsKFHg66KFmj7CDJiTMM9yBGU-fnjzA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fkWA7HQ6dwBN4vAkj9n6JV3HdQYtzxq0R"
X-Provags-ID: V03:K1:npu0ZmgiQ1ORwC6INDqKnliWSByMvLw1qPtkfRsFJ6/a0ufmjOd
 o4MH9GYMn4FhkLRef7Zj37c7MdijUluP1QsFbveSkNsG2frqL0zdZhecCPMINn8Z7VfECf+
 HRjXbGsd8lMzC+3UJ3lYKjf5rhadkKLHTjysSTH30FmvVH+g+5DSs2gmID3i4JrZHfC+5MB
 jgNXUOvjkiiXzBTErh+mA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XDorXxs6tQ4=:IDowGMmgpGVtm4sfSZ+FVP
 UXzDbjdP5UsWNWKWz4gaBfKXFzUNRF1himrmx3KTDiLtesKRtsHKRIvj725k8S78yZIAVe2qk
 uJecSNeNkPh9f3wLa60ks4rx+Z4ELNVC4ICydUbdjT7DOfE8CNQWAbkSe12LMIxaIYfms15Eb
 /r84QuN1+gpOrPV1mAFOqzeMJ3Q7iUnQFFN0RthfdKPoeV87OutWH4SXC27juEj8aYX0Kdb5a
 2DgqXM0lG1iubkBYrZbw4vSm9gjc9jxy/JPPBUkqx+pXHmFBGSzzmv7kv1U0yIOqoz7gbI7qE
 HL9fONnLCZPxDRqbh3wUChxiGkzpS6dReg+B1LeP22NnEZs4Ei9OWNApafzfJyWl5fHQlXkbm
 OPooJ5SpIX6S3SVOg+BfwTgDLN1lv052PAbFTIvhIzvYjdDrlGxn2I2xy6uHKtks94sjd/ttY
 cw/4T49owjixxsS/Amv4R4RjgReoERBgs9o/Y0VKxpT6O/XeorUsvG3XwS65+CiV6FSrf+8gF
 lQMWf3yFiBVMZ1JbSQfqTrd2slxzYQy92S5rkb4qJtFScFiVN/vWrx93ayDcR/GR6cfQ57x05
 2oJ+XoFzdhEKyowmp6guqGUTbcYh8Aq3HLBBrRrWZeYNfrAea5GWK3kExLvh+YTd5Ildi7B1w
 3DfyTJK3dxl2HTKG9mvAEixaGGYbiIZTfYuy8ALVSEzvrDAihwXGCmcRTcLijzm9yAAGmIO+s
 VmJQkXQT/C4PQcmyq3lpgFP5hWpz/zjHiVQZMxY4vOJfkGiDT7yeJrbnst1/uDZF0qLv6plxT
 DFMrW6zgUS2pJjAYauzBpafTw1lpLfv5Wd2oIc3wRB66DdJdjWpX6wHlJ6WPFHk+XQrhxAbQ1
 q7y8cWnG+hQxKwFUpDxqDVKlsBzsy0j5y3n6ttXOiE9o6KtkS8sav8Zm2EIKOe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fkWA7HQ6dwBN4vAkj9n6JV3HdQYtzxq0R
Content-Type: multipart/mixed; boundary="RdyJWhGdn7aicPAT96OUF3K9YYZf6bKnc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com
Cc: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a5519a4b-be00-95b1-0371-8a62f9c19ca9@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
 <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
 <8a3b5e64-1df7-447d-3b07-e276b8d65b40@gmx.com>
 <CAL3q7H4cjWJgoNg5C4+KsKFHg66KFmj7CDJiTMM9yBGU-fnjzA@mail.gmail.com>
In-Reply-To: <CAL3q7H4cjWJgoNg5C4+KsKFHg66KFmj7CDJiTMM9yBGU-fnjzA@mail.gmail.com>

--RdyJWhGdn7aicPAT96OUF3K9YYZf6bKnc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/24 =E4=B8=8B=E5=8D=885:28, Filipe Manana wrote:
[snip]
>>> So what's wrong with it? And how does it cause the ENOSPC?
>>
>> E.g.
>>
>> We have a 128Mb preallocated file extent.
>> And assume the fs only have 128M free data space, meaning 0 remaining
>> space at all.
>=20
> That's a contradicting sentence...
>=20
>>
>> Then we try to buffer write, which means buffered will just fail as it=

>> will need data space.
>>
>> The idea is always here for fallocate/pwrite, just the timing where th=
e
>> ENOSPC happens.
>=20
> Can't make sense of that sentence as well.

My bad, that change is already in buffered_write(), so that sentence
makes no sense.
>=20
> So I suppose what you are trying to say is that a write into an
> unwritten extent causes space allocation,
> and that can prevent some other write (which is not into an unwritten
> extent) from being able to allocate space and therefore fail.

That's one case.

>=20
> That's a valid problem that should be temporary.

I just tried a basic script:
---
#!/bin/bash

dev=3D/dev/test/test
mnt=3D/mnt/btrfs

mkfs.btrfs -f $dev -b 512M

mount $dev $mnt

fallocate -l 384M $mnt/file1
echo "fallocate success"
dd if=3D/dev/zero bs=3D512K  conv=3Dnotrunc count=3D768 of=3D$mnt/file2

umount $mnt
---

This fails just like the error report.


At least in current form, if we're writing into the preallocated space,
it indeed skips the data space reservation so it shouldn't cause problem
at that buffered write in theory.


However we have other locations which can reserve data space:
- btrfs_page_mkwrite()
- btrfs_truncate_block()
- btrfs_direct_IO()

Haven't looked into why above script fails, but it should have something
to do with any of the data space reservation.

Thanks,
Qu
>=20
> However when allocating space for a write into an unwritten extent (or
> any nodatacow write) we increment the data space info's bytes_may_use
> counter,
> but then if when writeback starts if we don't need to fallback into
> CoW, we end up never decrementing the bytes_may_use counter (even
> after writeback completes), leaking it.
> Not sure if this is the problem you were mentioning or just causing
> other writes to temporarily fail.
>=20
> thanks
>=20
>=20
>>
>>
>> We have btrfs/153 for the same reason to fail for a long time, althoug=
h
>> it's from quota, but the reason the completely the same.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Trying the reproducer, at least on a 5.0 kernel, does never fail on a=

>>> pwrite for me, but always on fallocate:
>>>
>>> $ mkfs.btrfs -f -b $((4 * 1024 * 1024 * 1024)) /dev/sdi
>>> $ mount /dev/sdi /mnt/sdi
>>> $ cd /mnt/sdi
>>> $ /path/to/reproducer
>>> reading from /dev/urandom
>>> writing to ./blob.IIa6tH
>>> writing blocks of 132096 bytes each
>>> total    125 MiB,  65.52 MiB/s
>>> total    251 MiB,  44.59 MiB/s
>>> total    377 MiB,  55.23 MiB/s
>>> total    503 MiB,  66.21 MiB/s
>>> total    629 MiB,  59.97 MiB/s
>>> total    755 MiB,   3.70 MiB/s
>>> total    881 MiB,  50.24 MiB/s
>>> total   1007 MiB,  64.51 MiB/s
>>> total   1133 MiB,  50.70 MiB/s
>>> total   1259 MiB,  49.29 MiB/s
>>> total   1385 MiB,  47.93 MiB/s
>>> total   1511 MiB,   4.00 MiB/s
>>> total   1637 MiB,  49.85 MiB/s
>>> total   1763 MiB,  48.11 MiB/s
>>> total   1889 MiB,  66.62 MiB/s
>>> total   2015 MiB,   5.60 MiB/s
>>> total   2141 MiB,  19.58 MiB/s
>>> total   2267 MiB,  64.80 MiB/s
>>> total   2393 MiB,  13.23 MiB/s
>>> total   2519 MiB,  14.95 MiB/s
>>> fallocate failed: No space left on device
>>>
>>> So either that was tested on a rather old kernel or:
>>>
>>> 1) we had snapshotting happening between a fallocate and a pwrite (or=

>>> at the same time as the pwrite)
>>> 2) before the pwrite (or during) the unwritten/prealloc extent was
>>> reflinked (cp --reflink, clone or dedupe ioctls)
>>>
>>> What did I miss here?
>>>
>>> Thanks.
>>>
>>>>
>>>> E.g. reserved space underflow.
>>>>
>>>> I'll find the old thread and retry again.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> This seems to break the semantics of fallocate so the performance s=
hould
>>>>> not the main concern here.
>>>>>
>>>>
>>>
>>>
>>
>=20
>=20


--RdyJWhGdn7aicPAT96OUF3K9YYZf6bKnc--

--fkWA7HQ6dwBN4vAkj9n6JV3HdQYtzxq0R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzAMWoACgkQwj2R86El
/qh2YQf/X0W+PQI8Xae53EUhDrdFxPJ2kOWX/rgY4f/Z8712n9/9G9QqmeLCCWvW
PljyCA93b88s2opOFqgO/r27khz2dRLu4UG2cfWYm96MxuXmDBMPCV9YbYWRM6RW
exr0ez0NoEUSRl95E4roXDe7Vu0I7iOZIoDB8MwhTyC4/wOHY5swhiJ+sSRDfd+H
G18UYY2KF895Dcc9wi4o6SYmqlMJtiy4Alx9wyuuuPakh5DlI1+BOwicz+F76OlC
UdaYN4y4lpICX7kFQX5riLJKiCE3vV51lVw+qdCIglKHGfzzTA5S9R1lPYrBRz5S
XosXCR+LT+MtM1CfcCcpMbnAvElapQ==
=kHDg
-----END PGP SIGNATURE-----

--fkWA7HQ6dwBN4vAkj9n6JV3HdQYtzxq0R--
