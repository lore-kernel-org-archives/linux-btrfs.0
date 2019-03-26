Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4CCC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 13:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4DCE2070B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 13:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ln1WQ4Tz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbfCZNhd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:37:33 -0400
Received: from mout.gmx.net ([212.227.17.20]:54403 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbfCZNhc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 09:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553607445;
        bh=05bMfVkN6dLLA+ZjDB1PCo94gUnWFqO1ZGnXchK6VnM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ln1WQ4TzGUV9Fd2tyT634LlVjPQvCeLvsIvjMKF1T1aCRl0No1uDpaiSDD52eOUAY
         6hKfFAvZ+GWyX+xREHu2x4mU90TJLtAOkDbBRWcIjWoq5g22wy489BY2PjACp7NmvL
         wmPmrZv1s/EmEo01pKdEX5HaoTWi6KJ84wjeso3M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M2nfO-1grwCg2yzW-00sbEG; Tue, 26
 Mar 2019 14:37:25 +0100
Subject: =?UTF-8?Q?Re=3a_backup_uuid=5ftree_generation_not_consistent_across?=
 =?UTF-8?Q?_multi_device_=28raid0=29_btrfs_-_won=c2=b4t_mount?=
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <QXHERo-tRpJm0-hY7ZotKSeF7CfsqeoH0XAf-wmRRsbzVuNWv6BTb9Q2xLQ_KgLlJNQJNSjGK9xlYcqv6QP3kKpFsvtyN0CBex5bFTCjiNE=@protonmail.com>
 <cc557b84-602c-8b2e-33f9-3c6d56578631@gmx.com>
 <j90OHVlIntkt3OHfCO0q8JaXXpDB-cDjDHuKXxuu6gQ64-FYSSZ4YuTU5bZnbfre7XWiymFCF9ZgK9RZ-5ljjEoOqZJtYDcjLad4zLF1Axs=@protonmail.com>
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
Message-ID: <0b96fc73-b6ce-f548-a61d-b3092d3534eb@gmx.com>
Date:   Tue, 26 Mar 2019 21:37:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <j90OHVlIntkt3OHfCO0q8JaXXpDB-cDjDHuKXxuu6gQ64-FYSSZ4YuTU5bZnbfre7XWiymFCF9ZgK9RZ-5ljjEoOqZJtYDcjLad4zLF1Axs=@protonmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CdIxFT8xh7XqhUDxWATRu7qNt5eBj7ear"
X-Provags-ID: V03:K1:NXfcWvypW41HbHtSnMycC5WNzFl4Tf8bJkUvV0d0zunyGri9KV8
 5Kwf0zRDgGS0P3fv5xTYTAu1c+9VXgIOQ2f15Od/CvJj7VwtwZVgP38V8ojGNVXK+2MONOc
 64rgoDw4EmBg6hVokASXdeiaUCOA0aCjmbdkun+RPxcBQ3UKEl5jvS/7o4QDg1fMBMzlUyb
 //ghXEUJwmohXxnSgYWkg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:riJGjm4qF1c=:xgGu7ljGbApn+/U2nAe1gK
 mq38U/SfVeXAdFSQLHXM6ZY4EnH6naUXVxnIpNb2r6mB9ZhVSNtk++pvCxfp06607ra43JXBW
 +rB79UrYe4YSKplq2TUfsZqKY/9v0KGCoXfmoP8ExsJI7ZKr2fyhH5zwTBx64xC3k1oreSq3X
 XU6vZ2M02mhw4jAEZJPv1YqgXKlyHaz/R3cA7wQfwsx+4Egi2pzWh/D0AvEofE4vVjX09ut2u
 /O7DmJCzSbok0nkriwubpTP79fTk577FfxsVGBEN5jXZPqj1jyg1M6/XvUU17mNXVIe5Nsp6b
 CSHE5RD5JrvqHIxsewiZqlJBFTYl8N08DXDb8fUTKMgNzQr/CsLi/fpVQC99FArqVCEs3Beka
 LGlQyQQ89B8ScdjfEH05HIFqe3AoN+LwKLOLbPj9xdvC7gdhYPR72pWUtfQv/WkYakAT5+7jk
 xy4RWZA6ILrfbV9DnIah2RmKNz6J7oHmaglt9SI2S/pypDrX1umtfd8ufWKQ1exu4MBNGkD9X
 m24cL0s14t3iBl6ueoGBXBycwUTBDhWCRIPeIEG5L9emzdUVixWPLHyoARJviKFZaUZbKJ4tY
 MlZ4JbjAYwwKmS2wtO2dmqICarlhiasjLVOoiBR15RJEmlgjAMr1mANMRa6oyq21N3oYQYqBx
 +Vvk+m/oSbB3EMp4WaO0WoTv1THKDLRMZxApZOdBmetiP3iBrCqVWYqYr+gi0Tym/lAMDKBbS
 hjoGzjpQTjznMi6Fdxg+gmjL22XSoEwys9IhjHsnYj6gpXjmBAguR6Whlb5GLWA1EIf1VdZtA
 ZMDyuKfViMFBGPuDrza3t2lm6r/TU28EqKjT+tbKuISfJHHTTBUlF1js/Z2ZrgqfFsbW0ojSJ
 JfpRpXqEiRBcL8MK/kBgA5GQkhYA01f8oMjN4FzopIGIxElJTSXtz1OIDwSKY8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CdIxFT8xh7XqhUDxWATRu7qNt5eBj7ear
Content-Type: multipart/mixed; boundary="DWCEYRJAR2ktqy70UdzauVzwW4IbKwiGD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: berodual_xyz <berodual_xyz@protonmail.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <0b96fc73-b6ce-f548-a61d-b3092d3534eb@gmx.com>
Subject: =?UTF-8?Q?Re=3a_backup_uuid=5ftree_generation_not_consistent_across?=
 =?UTF-8?Q?_multi_device_=28raid0=29_btrfs_-_won=c2=b4t_mount?=
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
 <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <QXHERo-tRpJm0-hY7ZotKSeF7CfsqeoH0XAf-wmRRsbzVuNWv6BTb9Q2xLQ_KgLlJNQJNSjGK9xlYcqv6QP3kKpFsvtyN0CBex5bFTCjiNE=@protonmail.com>
 <cc557b84-602c-8b2e-33f9-3c6d56578631@gmx.com>
 <j90OHVlIntkt3OHfCO0q8JaXXpDB-cDjDHuKXxuu6gQ64-FYSSZ4YuTU5bZnbfre7XWiymFCF9ZgK9RZ-5ljjEoOqZJtYDcjLad4zLF1Axs=@protonmail.com>
In-Reply-To: <j90OHVlIntkt3OHfCO0q8JaXXpDB-cDjDHuKXxuu6gQ64-FYSSZ4YuTU5bZnbfre7XWiymFCF9ZgK9RZ-5ljjEoOqZJtYDcjLad4zLF1Axs=@protonmail.com>

--DWCEYRJAR2ktqy70UdzauVzwW4IbKwiGD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/26 =E4=B8=8B=E5=8D=886:24, berodual_xyz wrote:
> Mount messages below.
>=20
> Thanks for your input, Qu!
>=20
> ##
> [42763.884134] BTRFS info (device sdd): disabling free space tree
> [42763.884138] BTRFS info (device sdd): force clearing of disk cache
> [42763.884140] BTRFS info (device sdd): has skinny extents
> [42763.885207] BTRFS error (device sdd): parent transid verify failed o=
n 1048576 wanted 60234 found 60230

So btrfs is using the latest superblock while the good one should be the
old superblock.

Btrfs-progs is able to just ignore the transid mismatch, but kernel
doesn't and shouldn't.

In fact we should allow btrfs rescue super to use super blocks from
other device to replace the old one.

So my patch won't help at all, the failure happens at the very beginning
of the devices list initialization.

BTW, if btrfs restore can't recover certain files, I don't believe any
rescue kernel mount option can do more.

Thanks,
Qu

> [42763.885263] BTRFS error (device sdd): failed to read chunk root
> [42763.900922] BTRFS error (device sdd): open_ctree failed
> ##
>=20
>=20
>=20
>=20
> Sent with ProtonMail Secure Email.
>=20
> =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Origina=
l Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=

> On Tuesday, 26. March 2019 10:21, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>=20
>> On 2019/3/26 =E4=B8=8B=E5=8D=884:52, berodual_xyz wrote:
>>
>>> Thank you both for your input.
>>> see below.
>>>
>>>>> You sda and sdb are at gen 60233 while sdd and sde are at gen 60234=
=2E
>>>>> It's possible to allow kernel to manually assemble its device list =
using
>>>>> "device=3D" mount option.
>>>>> Since you're using RAID6, it's possible to recover using 2 devices =
only,
>>>>> but in that case you need "degraded" mount option.
>>>>
>>>> He has btrfs raid0 profile on top of hardware RAID6 devices.
>>>
>>> Correct, my FS is a "raid0" across four hardware-raid based raid6 dev=
ices. The underlying devices of the raid controller are fine, same as the=
 volumes themselves.
>>
>> Then there is not much we can do.
>>
>> The super blocks shows all your 4 devices are in 2 different states.
>> (older generation with dirt log, newer generation without log).
>>
>> This means some writes didn't reach all devices.
>>
>>> Only corruption seems to be on the btrfs side.
>>
>> Please provide the kernel message when trying to mount the fs.
>>
>>> Does your tip regarding mounting by explicitly specifying the devices=
 still make sense?
>>
>> Not really. For RAID0 case, it doesn't make much sense.
>>
>>> Will this figure out automatically which generation to use?
>>
>> You could try, as all the mount option is making btrfs completely RO (=
no
>> log replay), so it should be pretty safe.
>>
>>> I am at the moment in the process of using "btrfs restore" to pull mo=
re data from the filesystem without making any further changes.
>>> After that I am happy to continue testing, and will happily test your=
 mentioned "skip_bg" patch - but if you think that there is some other wa=
y to mount (just for recovery purpose - read only is fine!) while having =
different gens on the devices, I highly appreciate it.
>>
>> With mounting failure dmesg, it should be pretty easy to determine
>> whether my skip_bg will work.
>>
>> Thanks,
>> Qu
>>
>>> Thanks Qu and Andrei!
>=20


--DWCEYRJAR2ktqy70UdzauVzwW4IbKwiGD--

--CdIxFT8xh7XqhUDxWATRu7qNt5eBj7ear
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyaKxAACgkQwj2R86El
/qgw4Af+PTQRGlZhOpdYOpKcAnWvM5E/V2Fj1WmXj0PHcXllhE89RgC8YHoyPNw9
8SC0cFjoECIuDSfI03u81TrqAO5b0TEDswDeXHKPPQ7PzX2SXwiZk4SNL6RF7lRF
+843HToiwR804tccMMGXw9qqCYz1pVnq3cCgf1Y89xSGTu1HGMH/G8MeKCpgmanZ
GBVGbjATR/YDO7vcCFhZrb+NapGxy0p4WBw7CZ30GDlQmWmba4/Xvg/wrSREQyYj
VcZudZt552nXl7yIP1iAlOVEAPnMVu/LAqc3I+SK1k3dOyFNuKuwqmYabriap3GD
7Y3M5RhFEni89q61hMK2wBcD+mBaLQ==
=A3ll
-----END PGP SIGNATURE-----

--CdIxFT8xh7XqhUDxWATRu7qNt5eBj7ear--
