Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F98AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EDE32229F
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbfBNMkA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:40:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:37317 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbfBNMj7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 07:39:59 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MWk7n-1gaf7j1kqp-00XuQs; Thu, 14
 Feb 2019 13:39:53 +0100
Subject: Re: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
To:     Hugo Mills <hugo@carfax.org.uk>,
        Jesper Utoft <jesper.utoft@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
 <717fd0a7-68ff-da60-b7e5-4223d16d0b54@gmx.com>
 <20190214123547.GH31308@carfax.org.uk>
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
Message-ID: <24441f08-626d-c44d-74dd-35f9a8de1aff@gmx.com>
Date:   Thu, 14 Feb 2019 20:39:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190214123547.GH31308@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x00nzJZKmZ4cllqo6yaoqbbdDwQKfmp4Q"
X-Provags-ID: V03:K1:E0h6HkgGVdx7CIqyjbW5pBX+L+oMy5w6EFc7NdGtUgXw5srrU8U
 BcZgVACy62ui9A2818DiDI17AH+wDv1Lz5D360WbmVXmgaTiD7lB7P0D693N1uAqLubhvtP
 269572g8Y+YsPhjjbia70ShfrzvRl5CX3KXaXntq225Mx7ewglz90DVOH4oRAixzkqm0u6V
 JF1tdYpltyVIZcwwUHF9g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QqW/CY+6VME=:l5lrOAJfyXcdHeyx510WQ6
 SylJq7brgzGJwE4sY4NvvehUxShMq2DNaSJ+InOVZPaY/cJ+OH7hZ0obXFMz9rZ3VLVeUQVdL
 cVHxWrtCyISUUl4GmnpxELK9F/Vv70KCuiS0A/dni3UpodEDY0iJ142c03cic/s3ebeqrBuRj
 iAd4WaErZhl57X3/b6S7D5h5EHQSM7NjYOhdq7QHbFlDwYXpPZxgzcTVWOIyPuSiqAlqS9Hmz
 8xKKnvin2dULr8LNW/98TkvnjCHklMLZ2N0GkDrTacMwq7PIMcMYBdYiDQ6aAUGIYlm9HQAYf
 5vAOtdtLyv8zVHLkgKJkgxIdhNy9AzULgjr46SLdeEXNbeph/SEGtjO9H6TC7DSmgo4migS9B
 50DKHAKFv73bioG+6pMpwHs5CBOwl/rNSiqT/lNUaFGhD4wOCjkwS8kzWrbb4IqqwPEnqUjho
 WcxXRUj3uo+ramV1XfVa/zNPxkd3m04iIFCPL0engtQIIkoa9sg77EmisI3jlzpph9yrgtmiF
 lKOBwDKXpKPgGBRjxPnpcx1RwloEf9Tm6G3RpKwIwOpKoz4KT91jZDOCZrdrCXdd3mG6D1Dra
 4moTmXA3pd7jnjTs9M34SsNzG/cm7hk+jwejShX1IarvR5DXdE91jk1V3EqCqdARIyJ7V/t5t
 IwQcCELb64gKURcXoWj6UkF4YnIhlZ4YDM1ZR1iY+KsZXJoTdnqoBxpP5FVkNn7qGMN0VBm8T
 EOcZva8rtwo0Y9KX9bR55hGdsTC5+X+yC9KgxBl066dKMXdqIYNNw9d126JCzOJLtRXv/wYaR
 7H3+uPAhVzVyozs2SQE7vheBHzvhkndgbChDJrsgNtRgSS7VCcfSNUQx5FYx1LAqZL91mLJlv
 ZLgoYDfrbgZ3290IOVVdGVrlHTnXGqYMyU0tH0Oht24zBTaPXhdPGsRzOoKZhX
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x00nzJZKmZ4cllqo6yaoqbbdDwQKfmp4Q
Content-Type: multipart/mixed; boundary="lXYRvcjlxJ9dMBgUAmtDAlr0AYvL48V53";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hugo Mills <hugo@carfax.org.uk>, Jesper Utoft <jesper.utoft@gmail.com>,
 linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Message-ID: <24441f08-626d-c44d-74dd-35f9a8de1aff@gmx.com>
Subject: Re: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
References: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
 <717fd0a7-68ff-da60-b7e5-4223d16d0b54@gmx.com>
 <20190214123547.GH31308@carfax.org.uk>
In-Reply-To: <20190214123547.GH31308@carfax.org.uk>

--lXYRvcjlxJ9dMBgUAmtDAlr0AYvL48V53
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/14 =E4=B8=8B=E5=8D=888:35, Hugo Mills wrote:
> On Thu, Feb 14, 2019 at 08:25:26PM +0800, Qu Wenruo wrote:
>> On 2019/2/14 =E4=B8=8B=E5=8D=887:58, Jesper Utoft wrote:
>>> Hello Fellow BTRFS users.
>>>
>>> I have run into the bad key order issue.
>>> corrupt leaf: root=3D1 block=3D57567265079296 slot=3D83, bad key orde=
r, prev
>>> (18446744073709551605 0 57707594776576) current (18446726481523507189=

>>> 0 57709742260224)
>>> The lines repeats over and over..
>>>
>>> I read a thread between Hugo Mills and Eric Wolf about a similar issu=
e
>>> and i have gathered the same info.=20
>> Now we have all the needed info.
>>
>>>
>>> I understand that it probably is hardware related, i have been runnin=
g
>>> memtest for 60h+ to see if i could reproduce it.
>>> I also tried to run btrfs check --recover but it did not help.
>>>
>>> My questions is if it can be fixed?
>>
>> Yes, but only manual patching is possible yet.
>=20
>    David: What needs to be done to get the bitflip-in-key patches
> added to btrfs check? They've been lurking in some patch stack for
> literally years, and would have dealt with this one easily.

It's not David's fault, it's all my fault.

I just forgot I still need to update that patchset (a big vacation just
ended on my side).
There are still valid comment on that patchset.

I'll update that patchset in recent days.

>=20
> [snip]
>> Thankfully, all keys around give us a pretty good idea what the origin=
al
>> value should be: (FREE_SPACE UNTYPED 57709742260224).
>>
>> And for the raw value:
>> bad:  0xffffeffffffffff5
>> good: 0xfffffffffffffff5
>>             ^
>> e->f, one bit get flipped.
>> (UNTYPED is the same value for UNKNOWN.0, so don't worry about that).
>>
>> I have created a special branch for you:
>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>>
>> Just compile that btrfs-progs, no need to install, then excute the
>> following command inside btrfs-progs directory:
>>
>> # ./btrfs-corrupt-block -X <device>
>=20
>    BUT, don't do it until you've found and replaced the bad RAM that
> broke it in the first place.

Sure.

>=20
>> And your report just remind me to update the write time tree block
>> checker....
>=20
>    Looking forward to dealing with a whole new type of "btrfs is
> broken!" complaints on IRC (followed by "can't I just let it carry on
> regardless?"). ;)

Definitely :-P.

Thanks,
Qu

>=20
>    Hugo.
>=20


--lXYRvcjlxJ9dMBgUAmtDAlr0AYvL48V53--

--x00nzJZKmZ4cllqo6yaoqbbdDwQKfmp4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxlYZAACgkQwj2R86El
/qg6Dwf/YskBDW5YytLHsNZRX+0DKhad747hYxJsHMo6y0EOpYEYNq69PkO7mGv1
IuNtptW6B2fv6bP3sK6zVvn4Qb4CZXbzbR7sh46GldaqMcNbG4dYUnQH8pB7miqq
6F3Mvb0BBNexhMUPlIAZhTUY81wE9+TsPMJKwgj9fjPI7b1vj5fUmN6GU4yzYrdu
/bdZOT0QDIRp2jQw77mRIVgtLu16iAnU9bJmFeRYXmSSvIoMyPhoaqjCmWnSj1FF
bCsHEI/aEoTRow39uwPq++CR89cLh6SWv9N/YNjUhiFBPmJEikNDt1dWrKA8Sy9x
ORWgSg+W9n/BhvW59E8Dd6nknRQjbA==
=H0A3
-----END PGP SIGNATURE-----

--x00nzJZKmZ4cllqo6yaoqbbdDwQKfmp4Q--
