Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE633C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B01C3206C1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KKOcGyqc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfDYNuj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:50:39 -0400
Received: from mout.gmx.net ([212.227.15.19]:51345 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbfDYNui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 09:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556200232;
        bh=FqkAxw0Hfz8ocgDxsGGEtFOBahSqN3yipL+7+E2hwqM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=KKOcGyqcHbftCHTMrT8qvurDRvxjNvd/997BqOOCn2/kh/Xmy0Tt/XcEJfEguL9Oo
         XJd7bMK8yeUh10NdxH5P8+E6ImaCOa9q1TxIajqg7qgMVCdJo6ebx3qSqKBUwNhAEB
         IRhcFClCALtg4U/UxWQybjZhqPfeixlqskfkoJ2Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MXp5a-1hIZNz1Dki-00YECC; Thu, 25
 Apr 2019 15:50:32 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
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
Message-ID: <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
Date:   Thu, 25 Apr 2019 21:50:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ut93c2CUV5TRYqF7wC7X9Iad5Jcj8nfeH"
X-Provags-ID: V03:K1:97ik0WFcjgHzkjz8wvBbkLz5SEsSGkrNgW7iZPsNjztxqVqRCQX
 58eKPHmvrWlkBqf33bqpOuCRqB7G1xo/XMOTALRXP1htw6D/qIo2BkklM5FPhFm8dWhLCu7
 F8dF3SUp5ifiVFGKkPB/xvw3FTj0oqd2fLc4eqDZyZqMYX7CJznuW7C8kRGFnHeE7D5/sb2
 2ErnV1tXu6WHgfkaXacXw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xq4my2iiiQk=:nHF18iRzIdKL+L+EgXr/Vc
 8gvhXhCfhGYPUvdEgXHqCcp0/1xFi6imHw4hbyN3SsjRty3vNXirdRufQjtstQTQyMUcTTpPj
 DOwcCBKT1bOnUDg2hmD5qPYRgivexPqPq7HTL2WPz55ZyreGrYH1tHtyfkHDkU3+P6dhyymah
 4ZYLG8fMlTVFf4A7MOAUngu1Ue3pz+tdF5TE9DHY/i+2EPppHJSXlNdcodeth2M9aeT7ZWKO7
 VOUV64M32PiYV4V/bUP+rgaWWODRjiBu6jFgniN6Ka/oRxsi5Fk7Ca6DN9NH4hTpC8mHmvl9Z
 bA+g4o9gkw8k+324vqjLl9H3NkViqUvResJFBt/3/0Z5tIQBP6whUDGlgNsF+ZY6ZIc5MW86C
 uTFqvz89bffoQ6aHaSx1BAgWnvk9L4uJABtWvNpdldD8PZjvnAOoth6TFZlmOpgG2JUi1z0G/
 EpSb2kG6fWZ2tbM/2AVvNPmLrVIVkn4hjncE/As0c4wDUuWnebOwHhjMOVCfsyE+FRg3q7tpV
 1vgftJRKABlfGJoNbAUtnAFaMWX67OZM0z9ks4GqCPOIE2uzmsCCN3bh4++z5SjCB1XJJh4B3
 AOXoOl5OQFH1qLlWVV0BN8iEkM/8uFSZ+E2DipHtNiOnXNrRKaVlqn5eCxpp3QgUuF+NZYTrB
 2R66rVWIfOOjcsLnpLi+PsSBnudkytlzR3SQwvDzRziRqwVuhqmRST3Q4pCcY1tJFBYu2k+jF
 tSA+0TSP6FkJPGUGkoGanA4QKLWtVUhvAK9gz0ZwwDMSzQcL0ZGt+9Zf3o+RHvcqeRPoh4N7t
 50lrXtVWgYil+4GglaP+E/zJ8BehMVhwgeCvxNGI3y9C2eB5ZWppo3vVZiv/aiCGkGlyQ62o4
 YP2sv++i7AW4ygLKJKDKK1DEvuuS+LXOvfrSOwCHzfWzhT3KQjfBxM6uWEGiYp
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ut93c2CUV5TRYqF7wC7X9Iad5Jcj8nfeH
Content-Type: multipart/mixed; boundary="X6Abmt3kY5jFQB4R3aqZ1qB0BzzfAMktL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
 <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>

--X6Abmt3kY5jFQB4R3aqZ1qB0BzzfAMktL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/25 =E4=B8=8B=E5=8D=889:25, Josef Bacik wrote:
[snip]
>>>
>>> What if the commit is reverted, if the problem is otherwise hard to f=
ix?
>>> This seems to break the semantics of fallocate so the performance sho=
uld
>>> not the main concern here.
>>
>=20
> Are we sure the ENOSPC is coming from the data reservation?  That chang=
e makes
> us fall back on the old behavior, which means we should still succeed a=
t making
> the data reservation.
>=20
> However it fallocate() _does not_ guarantee you won't fail the metadata=

> reservation, I suspect that may be what you are running into.

For this script, we only needs 4 file extents at most.
Even the initial 8M metadata should be pretty enough, thus I don't think
it's metadata causing the problem.
---
#!/bin/bash

dev=3D/dev/test/test
mnt=3D/mnt/btrfs

mkfs.btrfs -f $dev -b 512M

mount $dev $mnt

fallocate -l 384M $mnt/file1
echo "fallocate success"
sync
dd if=3D/dev/zero bs=3D512K  oflag=3Ddirect conv=3Dnotrunc count=3D768 of=
=3D$mnt/file2

umount $mnt
---

>=20
>> My blur memory of the underflow case is something like below: (failed =
to
>> locate the old thread)
>>
>> - fallocate
>> - pwrite in to the reallocated range
>>   At this timing, we can do nocow, thus no data space is reserved.
>>
>> - Something happened to make that preallocated extent shared, without
>>   writing back dirty pages.
>>   Some possible causes are snapshot and reflink.
>>   However nowadays, snapshots will write all dirty inodes, and reflink=

>>   will write the source range to disk.
>>
>>   Maybe it's a small window inside create_snapshot() between
>>   btrfs_start_delalloc_snapshot() and btrfs_commit_transaction() calls=
?
>>
>> - dirty pages get written back
>>   We created ordered extent, but at this timing, we can't do nocow any=

>>   more, we need to fallback to cow.
>>   However at the buffered write timing, we didn't reserved data space.=

>>   Now we will underflow data space reservation.
>>
>> However nowadays there are some new mechanism to handle this case more=

>> gracefully, like btrfs_root::will_be_snapshotted.
>>
>> I'll double check if reverting that patch in latest kernel still cause=

>> problem.
>> But any idea on the possible problem is welcomed.
>>
>=20
> Reading the code there's two scenarios that happen.  All of our down st=
ream
> stuff assumes that we've updated ->bytes_may_use for our data write.  S=
o if we
> fail our reservation and do the nocow thing of skipping our reservation=
 we can
> overflow if we
>=20
> 1) Need to allocate an extent anyway because of reflink/snapshot.
> btrfs_add_reserved_space() expects that space_info->bytes_may_use has o=
ur region
> in it, so in this case it doesn't and we underflow here.  I think you a=
re right
> in that we do all dirty writeback nowadays so this is less of an issue,=
 buuuut
>=20
> 2) In run_delalloc_nocow we do EXTENT_CLEAR_DATA_RESV unconditionally i=
f we did
> manage to do a nocow.  If we fell back on the no reserve case then this=
 would
> underflow our ->bytes_may_use counter here.

Right, I missed this case. Thanks for pointing this out.

>=20
> Off the top of my head I say we just add our write_bytes to ->bytes_may=
_use if
> we use the nocow path.  If we're already failing to reserve data space =
as it is
> then there's no harm in making it appear like we have less space by inf=
lating
> ->bytes_may_use.  This is the straightforward fix for the underflow, an=
d we
> could come up with something more crafty later, like setting the range =
with
> EXTENT_NO_DATA_RESERVE and doing magic later with ->bytes_may_use.  Tha=
nks,

Sounds pretty valid to me.

Thanks for the idea,
Qu

>=20
> Josef
>=20


--X6Abmt3kY5jFQB4R3aqZ1qB0BzzfAMktL--

--Ut93c2CUV5TRYqF7wC7X9Iad5Jcj8nfeH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzBuyEACgkQwj2R86El
/qj9Mgf/R6FOfprBgm2sTQtjwKtFF7YblkY2faaBRN0GNCyp2zRN7OfpFdsKCUtU
EtrkC+1/3TmU1YDsBG39JiuohQTBuAB6jgjXaxROhr6Db82tbHsJNeMQJ9KoUMk5
pNq1Ge9pnpL2P0LwYUvf9TRj9R1eiWKoXHJ2knwRYfthZQCEPhYRIN/Z0JB0eJZ1
K+ddYdQaCko1T3CpOon9FIXEJRVpDtLmPCOTZPRarA3ttUio0uSXAE1D/OjxUKqM
sQuZaofLwa5jQmd0NK/LJhkbhB4XvsYo4IBSHXWEYRsFMBSxxNTZftLXZVPLdaXZ
ogU2bYenTvMXHVwks4AFwYyRH/V1DQ==
=lEsW
-----END PGP SIGNATURE-----

--Ut93c2CUV5TRYqF7wC7X9Iad5Jcj8nfeH--
