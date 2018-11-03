Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7F0C32789
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 01:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25BA20831
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 01:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A25BA20831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbeKCKOh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 06:14:37 -0400
Received: from mout.gmx.net ([212.227.15.19]:34573 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbeKCKOh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Nov 2018 06:14:37 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MZTw5-1fy3lH2JP3-00LHW1; Sat, 03
 Nov 2018 02:05:07 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MZTw5-1fy3lH2JP3-00LHW1; Sat, 03
 Nov 2018 02:05:07 +0100
Subject: Re: Salvage files from broken btrfs
To:     "M. Klingmann" <m.klingmann@gmx.de>
Cc:     linux-btrfs@vger.kernel.org
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
 <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
 <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <230db828-b752-9167-fbc1-5c603ce7c138@gmx.com>
Date:   Sat, 3 Nov 2018 09:05:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4b1wuAxyeTcBWzJSMcVkNiZJhdiB7ox16"
X-Provags-ID: V03:K1:vAlL9Ykn0na5mq7SNal2up2B0BOIQmFHHBX8jRJDrvtR3DYf+SM
 hCtBTjwlcqkH9GaMmLez9JTuqyuNfQPU2UlZYbN4FS9UjppMhwWkz35lq8BjNqUl0cpgnK3
 XGtYlnLvwcwyKBcI0xZIan+q0756LdLTsFeXhPO2D83O2v3H9GZmuBSXfJXcVWVZoD96Pvk
 u+0dBkN1Yk5V/+OH7aBzw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:PMxWU0T6K5A=:Kk83YKm3+4qz30U9m/SVZC
 u1/2b2HMXXziTO6vGWWF20Quvx75G4kt8a+y/dPU2jdQk0+zX1auYXHrI+sBWknETf7iqGZRL
 jD+G+Fjhg19xs7jNkyji5GmmcfjpRcQqk1KfE4rMRvg9SrNvtsuCuQ+9aO0lMQbpXNUgpADg4
 muKeRagdMAWIiml8d2Ty6xF30h5KJwXMhdVv2lSJw3p1ZRsSb+obg6plqiuc7dRuNIO91B/ye
 TmKkED/b+WzbIDC4OBLXOJTeqnkSuoXux0c//wBCjQDxGCzGMNUz59F4xo5Pmssur8nbhQHbL
 LmzRc/6qOY1CDUV7sNjz3Ct5D8Mw0HJ9or0F1dPn6wnaVOW5fqIS/XAruHMUVGLqYiigNcC4T
 53Rgxc1YNIUazACFqgWqDM5da94IHgZ/Ngfo/pEsGXPd0NV1x1r881DO0U7XqEoIAeV0LoNXC
 hwFpfVkNrD/jc8w9T8K6Ra2ZCEWkNyWl96hsqySXaUKO9pXE2YW19HCAYknXu6ZK+VcJF5hcQ
 7f7xQKPicr7IRDMJwCZWQiznTHq8Hv1eb5WYgoV2hV1/Fw507TSihFVxq6Rq7qSLmXJxZXMtT
 TseJIlSRbUUxvt/WyHJkLwruH9lTadzd7uo2N7V1oNw/fjHGiq/LW50aA4dDmiqbmY0ceF9Aa
 608fv4Ml0Q9URAHoPatTUKwqfNnWqN10zFmDfPVst9HpmwFChOTQVMhNrqMhODnoJoyc22WGi
 D0XAUgbyPAZYJ8mWnndQGXnqZl2p0mBkGKCLp+1HYPN3Btk4AHqq0LTp6pZukZeEVT+hGlkcL
 Ypn/4b4tCY/biKT7O3OQh1h9j6RVQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4b1wuAxyeTcBWzJSMcVkNiZJhdiB7ox16
Content-Type: multipart/mixed; boundary="ggOkifb6OI0c94hmmAvZijya2TCr6ePlH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "M. Klingmann" <m.klingmann@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <230db828-b752-9167-fbc1-5c603ce7c138@gmx.com>
Subject: Re: Salvage files from broken btrfs
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
 <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
 <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>
In-Reply-To: <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>

--ggOkifb6OI0c94hmmAvZijya2TCr6ePlH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/3 =E4=B8=8A=E5=8D=881:18, M. Klingmann wrote:
> On 02.11.2018 at 15:45 Qu Wenruo wrote:
>> On 2018/11/2 =E4=B8=8B=E5=8D=8810:30, M. Klingmann wrote:
>>> On 31.10.2018 at 01:03 Qu Wenruo wrote:
>>>> My plan for such recovery is:
>>>>
>>>> 1) btrfs ins dump-super to make sure system chunk array is valid
>>>> 2) btrfs-find-root to find any valid chunk tree blocks
>>>> 3) pass that chunk tree bytenr to btrfs-restore
>>>>    Unfortunately, btrfs-restore doesn't support specifying chunk roo=
t
>>>>    yet. But it's pretty easy to add such support.
>>>>
>>>> So, please provide the "btrfs ins dump-super -Ffa" output to start w=
ith.
>>> Following your plan, I did 1) and 2).
>>> As 2) failed (see below), is there anything I can do to find the tree=

>>> bytenr to supply btrfs-restore with it?
>>>
>>> 1) Here's the output given by "btrfs-show-super -Ffa":
>>>
>>> superblock: bytenr=3D65536, device=3Dsdcard.iso
>>> ---------------------------------------------------------
>>> csum=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0xb8e15d=
d7 [match]
> [snip]
>>> 2) "btrfs-find-root" yields "Couldn't read chunk root; Open ctree fai=
led".
>> It's not plain "btrfs-find-root" but "btrfs-find-root -o 5".
>>
>> And you should use btrfs-progs v4.17.1, not the old v4.4.
>> The ability to continue search even if chunk tree get corrupted is add=
ed
>> in v4.5, and I strongly recommend to use latest (v4.17.1) for a lot of=

>> fixes and extra debug output.
>>
>> If you can't find any handy way to update btrfs-progs, you could use
>> Archlinux iso as a rescue OS to use the latest btrfs-progs.
>=20
> Using Archlinux in fact is the easiest way to use version 4.17.1
> (Archlinux for 2018-11-01).
>=20
> Here's the output from "btrfs-find-root sdcard.iso":
>=20
> WARNING: cannot read chunk root, continue anyway
> Superblock thinks the generation is 1757933
> Superblock thinks the level is 0
>=20
> Here's the output using "btrfs-find-root -o 5 sdcard.iso":
>=20
> WARNING: cannot read chunk root, continue anyway
> Superblock doesn't contain generation info for root 5
> Superblock doesn't contain the level info for root 5

No other output at all?

That means the whole 8M range of system chunk get corrupted.
Thus really no way to get any meaningful data out of the filesystem,
unfortunately.

Thanks,
Qu

>=20
>> For 3), I could easily add such feature btrfs-restore, or just use
>> manually patching your superblock to continue.
>> So as soon as your "btrfs-find-root -o 5" gets some valid output, I
>> could continue the work.
>>
> Thank you.
>=20


--ggOkifb6OI0c94hmmAvZijya2TCr6ePlH--

--4b1wuAxyeTcBWzJSMcVkNiZJhdiB7ox16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvc9D8ACgkQwj2R86El
/qgeMgf+Kzj7+xs5i8tfu13eMhDcl+skMTa3dhOsdltLk/P5CZeeoZEAIr5cBrGm
NCsrKrtZQkOA8NE+GG4wFX6E1QxgQ54Kfdz3qmgeeGkazjc7W4TKO1lDe/wHyLOF
5PtKugxtaqkZI4T86EQFa/RVHarac8W4Jx+8jTiIgrOqBb2OjL3J8HQ+H/mdqVWF
chaEUCT/8WUFUGJElnI2IWmo8iT9VYg/WHJo1UNwwTiMhtJYteaC28TCVFpUb4d3
VAGgRJlUAacV58wtrZ1P7pAbyhlvBBXMlB+qpJ2ZW4iW4iToxqF6jjXheIT1063y
W/Gz0hBK/54oVPKAZ14gU5LDM/ZDEQ==
=n/u8
-----END PGP SIGNATURE-----

--4b1wuAxyeTcBWzJSMcVkNiZJhdiB7ox16--
