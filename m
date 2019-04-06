Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8F3C282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 01:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0652186A
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 01:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kdod/h86"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfDFB6K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 21:58:10 -0400
Received: from mout.gmx.net ([212.227.15.15]:55687 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfDFB6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 21:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554515861;
        bh=NeGvQedoqCgZBN77Yj5uoHUin9yVqkYL4noFu3J+hW0=;
        h=X-UI-Sender-Class:Subject:From:To:References:Date:In-Reply-To;
        b=kdod/h866s5+5K78lCm4f3h7PpGYYdF219wU8Dw7NtpCdzrSP9jdZMs9RQWRuX+nb
         UQVTw+z2/Akud0WLWQBnS+eMTwYMA3TiGmpyi2SseLgTu0Q3EOrVEvY/8YVwVA19NF
         5dTTEvDnyYKrTmxcgcMGoWAZh30bQv/UoAppe8d4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M54fe-1gz46k2VYs-00zDLq; Sat, 06
 Apr 2019 03:57:41 +0200
Subject: Re: [PATCH 0/2] Fixup and optimization for write time tree checker
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404034708.3399-1-wqu@suse.com>
 <20190405154945.GX29086@twin.jikos.cz>
 <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>
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
Message-ID: <76400324-5d49-2519-b005-b1a85f886750@gmx.com>
Date:   Sat, 6 Apr 2019 09:57:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="b9hv9C96swBthcEN3Y5ly9tsM4numPtHw"
X-Provags-ID: V03:K1:97rxQV0qID/9nfB1o5hgeFORxee5fgQcMrTIHdGYJah4GPam2HG
 yBq4i7jPkivwckpjweHgFJBGpz3TEg5MdG9fQfunZxxYNuaiOgRzh4h4X+XQaM/Mwuneqkm
 LxDju4AYUZWZaplmk6mHeYpVqQawl5th/DRj26MW2uwq6s+d/3LImgOZNLFCZ/3HxGaxcZH
 X3xWnbsewy7Ixbzd1VDpw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zukgtCsdX6o=:BzO0v4g23In/LDqdAF7hYR
 gZsjk0fYKm1X6M4WHG5djLkjJgtrZrI5R9gpJtlcFGs/ARIe28yPHHm7abrruSEHt9KtA1bcM
 /AKt3lv0H+BcKbp4j2uQKuE4u4lDg3SW7NAAfDqZHxAzsaG4G5HBgv8QFbZoUYrYpe38OBxMa
 nc8ar3KDWdYxZdBceiU5I3D1zaiaM7jHbNZQtmuumsqY8DEq0VYGD2ScDdzhLgVmQUI76AoM2
 enG0Xje6mJj3BxU6qR9QE0DXxjz20oKRDy9HLkMmqKnKhzkX/icapsDsq/z0u+2/mf/MEw9dZ
 G8nXS4UVbN/cHb/r40MVkMgG0GD5ucHilEWPZXts0RO7IOdEbmo8HHl5pzuN8irjqbqANa2cp
 c92x+ahPK+HeL6owSyWCBNtNnERza6zWRlPvOK7fRcbc5X0L1hMSKt46QC0fU2UcLM5cOMMnu
 d4KpPWV39RgyT/nnvtx2xVIKDAr/jpxPC/j28Lk8ftEIBNLwrqcIMI6N5fCC1oVjatmZHTy7+
 Ungbd6JKTNvNzaPBQYRBxikGXWHdN26XzqKrsG85PfaOXOU/FyN+L3Q/f5+f9ZKYN9B7T584i
 XjpEc0CtClmfq0JSS0PYkXZQ7iM0Hyk3kSY/ZsrAQAAtxKxljKRVe09/XArBvQtmy4rM9RhRs
 PhPL5U/1nnI3gR6vGe7aDtjDnbdhGnEWnWvXiugCvb4ZxrtWrbn1s2q+BWHfC9pv6banyLe1e
 tkN6J9G0Ygt5yr4BWVHjmFTLGpyglLFHPpKebCIk+nIFNBN62i1CIZE0qdGBm5AmeJKg1Q205
 55x2rCGvH8S52AeEtpqR7PsoB3pA1+ZzZ33Vfolb0d5ILHbPzgLMhzLjAy8Lh6CLcxgzPnYZR
 5f25rkra5ln0fpDuI1LmZ3DtuY7xRQTJbgisJzpGcl5C65ypmnvGaraXpmTXNk
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--b9hv9C96swBthcEN3Y5ly9tsM4numPtHw
Content-Type: multipart/mixed; boundary="uu6DC13kAbIJ4cgqbLvg83FB8ny5uLV4O";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <76400324-5d49-2519-b005-b1a85f886750@gmx.com>
Subject: Re: [PATCH 0/2] Fixup and optimization for write time tree checker
References: <20190404034708.3399-1-wqu@suse.com>
 <20190405154945.GX29086@twin.jikos.cz>
 <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>
In-Reply-To: <d17bb3bb-456f-0940-d95e-9cedc2ce4406@gmx.com>

--uu6DC13kAbIJ4cgqbLvg83FB8ny5uLV4O
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8A=E5=8D=888:22, Qu Wenruo wrote:
>=20
>=20
> On 2019/4/5 =E4=B8=8B=E5=8D=8811:49, David Sterba wrote:
>> On Thu, Apr 04, 2019 at 11:47:06AM +0800, Qu Wenruo wrote:
>>> This patchset can be fetched from github:
>>> https://github.com/adam900710/linux/tree/tree_checker_testing
>>>
>>> Which is based on misc-next, with the following commit as HEAD:
>>> commit 56d46f96de92ec69963acb7b1d9aed83d2a56a7b (david/misc-next-with=
-write-checks, david/misc-next)
>>> Author: Nikolay Borisov <nborisov@suse.com>
>>> Date:   Wed Mar 27 14:24:18 2019 +0200
>>>
>>>     btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_=
bit
>>>
>>> These two patches changes the behavior of write time tree-checker, wh=
ere
>>> the initial patches didn't check the content of the leaf, leaving mem=
ory
>>> bit flipping possible to sneak in.
>>>
>>> This patchset also introduces a new optimization, where original empt=
y
>>> leaf owner check can be pretty expensive and cause false alerts for
>>> write time tree checker.
>>> With this new optimization, write time tree checker can reuse the
>>> existing btrfs_check_leaf_full().
>>
>> This on top of misc-next throws 6 'write time' errors:
>>
>> btrfs/101               [14:00:24][ 3963.736352] run fstests btrfs/101=
 at 2019-04-05 14:00:24
>> [ 3970.417649] BTRFS error (device vdc): block=3D2446344192 write time=
 tree block corruption detected
>=20
> In my case, these tests just pass, so I haven't checked the dmesg.

Oh, those tests passes because of a bug in mainline.

6dc4f100c175 ("block: allow bio_for_each_segment_all() to iterate over
multi-page bvec") prevents us from breaking bio_for_each_segment_all()
loop, thus not triggering transaction abort.

A nice finding digging into the report.

Thanks,
Qu

>=20
> But indeed I can reproduce the same dmesg line.
>=20
> Before removing the device, btrfs will use btrfs_shrink_device(new_size=

> =3D 0) to remove all data from that device.
>=20
> And that will cause on-disk total_bytes to be 0, triggering the bug.
>=20
> So indeed the behavior is different between read and write time.
>=20
> I'll check how to do it correctly.
>=20
> Thanks,
> Qu
>=20
>>
>> btrfs/151               [14:06:52][ 4351.133395] run fstests btrfs/151=
 at 2019-04-05 14:06:52
>> [ 4351.659771] BTRFS error (device vdb): block=3D570572800 write time =
tree block corruption detected
>>
>> btrfs/164               [14:07:19][ 4378.349990] run fstests btrfs/164=
 at 2019-04-05 14:07:19
>> [ 4380.645918] BTRFS error (device vdb): block=3D2479882240 write time=
 tree block corruption detected
>>
>> btrfs/176               [14:07:39][ 4398.493736] run fstests btrfs/176=
 at 2019-04-05 14:07:39
>> [ 4399.186203] BTRFS error (device vdb): block=3D22036480 write time t=
ree block corruption detected
>> [ 4399.302700] BTRFS error (device vdb): block=3D1372585984 write time=
 tree block corruption detected
>>
>> btrfs/184               [14:10:13][ 4552.496289] run fstests btrfs/184=
 at 2019-04-05 14:10:13
>> [ 4553.292780] BTRFS error (device vdb): block=3D4602216448 write time=
 tree block corruption detected
>>
>> Have you seen the errors during your testing?
>>
>=20


--uu6DC13kAbIJ4cgqbLvg83FB8ny5uLV4O--

--b9hv9C96swBthcEN3Y5ly9tsM4numPtHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyoB5AACgkQwj2R86El
/qhmIgf/QYi7alFcp2zJw4om+fgsCb7WXoLI03RP/G+Drq5IDyl/rBbQD+ls2FPg
qYPA4Ndt8/n6JCvCRbmjmIVEuig2qDPK8U55dTSZMW4sCvc6IaYQGDIXm13NzHMy
ik7Po+qRM00+79q//DUVtWB7GU0dD1Mwh7rHvY+WS8GTt6fwHpMZQQj120jbRjAj
LufJCWMQfUNzB7SR9OxmUEt9/JPVJaF4W8SgJ4CbvnHbl9Ceo74LfXupfMrUvEYx
qKxfBENvTmpx5HhVRQ7uQc9K9PbrR0LJYWqDUDKjYewIXYSZgj8xomg1DxdY6DH2
lmrPSUp0wTLFGEB6lBl4KwTTep7/gg==
=WoZq
-----END PGP SIGNATURE-----

--b9hv9C96swBthcEN3Y5ly9tsM4numPtHw--
