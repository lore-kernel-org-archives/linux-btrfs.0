Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829DBC32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 14:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CEA12081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 14:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CEA12081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbeKBXww (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 19:52:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:57147 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbeKBXwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 19:52:51 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LpKrt-1feKKw3mrN-00f7j0; Fri, 02
 Nov 2018 15:45:29 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LpKrt-1feKKw3mrN-00f7j0; Fri, 02
 Nov 2018 15:45:29 +0100
Subject: Re: Salvage files from broken btrfs
To:     "M. Klingmann" <m.klingmann@gmx.de>
Cc:     linux-btrfs@vger.kernel.org
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
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
Message-ID: <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
Date:   Fri, 2 Nov 2018 22:45:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pYLbZJdc57FQ96Yvx7mBMuIQLnjnNENzs"
X-Provags-ID: V03:K1:318BmawA7YYMCUPkQRpY0xpK+lXgaRwypmqt74wDaEzyWn/f8MC
 T32/mq94daITPb6DsRaaH+SBu1Gx7MZgAzMwC+vl+xBcW9WF1up0ThTwqn4db0CZCRRR+6x
 IBWncmPL3Ol5QsGdMf8x6L/bQW0N5CdC6OiYZNE7lcjA7+7Kbry6FLww32XXnHOkEIn12CV
 ZhRDOuujzKjoyEGzbLkIw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:A5HnPFEYq6o=:md1OhINLW0DMqM3v1x2ljA
 9Hi1dcFRbUiFyOveop3Oy5WAut2QDmM2M++4Yed+AatkLMC18XhOfn9Gm5xftq7Xlys0m4wT9
 yYPO764/sTb6HLiKmWPtTTjKg9VbBJpB6tBO/7czlBPfqWd6hs9wt31wiVh0LBNrotc0FfdEQ
 dWEJmeSgmADwGMZ9hY7P5YYC9IQ0vFtIugeUo9zonag/WyB/JoNH61Uy5fiOdam5/TEWP45GQ
 VrdEpNXiS0+3nIKrmn6l7tEK0BaTI2+NaVJrhMTNMOyTmQspSuWwySsATsADDPG7UHQrpPbIi
 CXK143N+udrOAGjX5ZXJxQQzg+4Eh5tsOdOZisMTxZ4CJojCZx4+jyiRmOI9mY2jAGrO8bUvI
 xa4bvSZgrLnU6H5FoP4076zAQ/cXVjEf8XnwpFZLN8sAhoJPz9o0Xpp+dlHx5a41a3yxlCGQF
 McOoeSoA1/r9URBjhgHH3gtDLT9jnt0V4VYzadA2Ws9IDfXMQ46Gbtn8UTsufLdGIJpyra0kw
 RlzoL9FHa2pEZHRAIHVcqcuDydHEYaOnRi118eNBACdZMi5IgTRzcE7/2FFV9pFW3dRYe9fJ1
 eSDMzHnpUOLrF6CxXM/+xxWBdzTgpVJKKQm7K0fee8pTIXS1hUo+vjaUnoNrrs3u0jB8ySQ1K
 OVPklK9ZHrnrYzAsew7IZmC9BhN0XeeWRWk354jcidJ+sdyG5MiWrv49y5BhF9MzXM+FQymmD
 qogadTKXNcP4s+TSB1ogG4xzqqSNy2yYI4P8XTYwAngTffN1yEb7Njd1sNJ3bazAQlu7yi8rl
 swAx77LshVQvhfBrKYGm8aZtGDXDQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pYLbZJdc57FQ96Yvx7mBMuIQLnjnNENzs
Content-Type: multipart/mixed; boundary="k49U4yLlHSLMZsS3Ojv4Y4n6EPrlZF58u";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "M. Klingmann" <m.klingmann@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
Subject: Re: Salvage files from broken btrfs
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
In-Reply-To: <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>

--k49U4yLlHSLMZsS3Ojv4Y4n6EPrlZF58u
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/2 =E4=B8=8B=E5=8D=8810:30, M. Klingmann wrote:
>=20
> On 31.10.2018 at 01:03 Qu Wenruo wrote:
>> My plan for such recovery is:
>>
>> 1) btrfs ins dump-super to make sure system chunk array is valid
>> 2) btrfs-find-root to find any valid chunk tree blocks
>> 3) pass that chunk tree bytenr to btrfs-restore
>>    Unfortunately, btrfs-restore doesn't support specifying chunk root
>>    yet. But it's pretty easy to add such support.
>>
>> So, please provide the "btrfs ins dump-super -Ffa" output to start wit=
h.
> Following your plan, I did 1) and 2).
> As 2) failed (see below), is there anything I can do to find the tree
> bytenr to supply btrfs-restore with it?
>=20
> 1) Here's the output given by "btrfs-show-super -Ffa":
>=20
> superblock: bytenr=3D65536, device=3Dsdcard.iso
> ---------------------------------------------------------
> csum=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0xb8e15dd7=
 [match]
> bytenr=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 65536
> flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ( WRITTEN )
> magic=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 _BHRfS_M =
[match]
> fsid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4235aa4f-7=
721-4e73-97f0-7fe0e9a3ce9c
> label=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0
> generation=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1757933
> root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 889143296
> sys_array_size=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 226
> chunk_root_generation=C2=A0=C2=A0=C2=A0 932006
> root_level=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> chunk_root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 20987904
> chunk_root_level=C2=A0=C2=A0=C2=A0 0
> log_root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 890109952
> log_root_transid=C2=A0=C2=A0=C2=A0 0
> log_root_level=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> total_bytes=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 30666653696
> bytes_used=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 16937803776
> sectorsize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4096
> nodesize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 16384
> leafsize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 16384
> stripesize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4096
> root_dir=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 6
> num_devices=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1
> compat_flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x0
> compat_ro_flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x0
> incompat_flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x61
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ( MIXED_BACKRE=
F |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 BIG_MET=
ADATA |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 EXTENDE=
D_IREF )
> csum_type=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> csum_size=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4
> cache_generation=C2=A0=C2=A0=C2=A0 1757933
> uuid_tree_generation=C2=A0=C2=A0=C2=A0 149
> dev_item.uuid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 90185cf6-b937-49bb-b=
191-91d08677ee22
> dev_item.fsid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4235aa4f-7721-4e73-9=
7f0-7fe0e9a3ce9c [match]
> dev_item.type=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 30666653696
> dev_item.bytes_used=C2=A0=C2=A0=C2=A0 30666653696
> dev_item.io_align=C2=A0=C2=A0=C2=A0 4096
> dev_item.io_width=C2=A0=C2=A0=C2=A0 4096
> dev_item.sector_size=C2=A0=C2=A0=C2=A0 4096
> dev_item.devid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1
> dev_item.dev_group=C2=A0=C2=A0=C2=A0 0
> dev_item.seek_speed=C2=A0=C2=A0=C2=A0 0
> dev_item.bandwidth=C2=A0=C2=A0=C2=A0 0
> dev_item.generation=C2=A0=C2=A0=C2=A0 0
> sys_chunk_array[2048]:
> =C2=A0=C2=A0=C2=A0 item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 chunk length 4194304 owner 2 stri=
pe_len 65536
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 type SYSTEM num_stripes 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 stripe 0 devid=
 1 offset 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev uuid: 9018=
5cf6-b937-49bb-b191-91d08677ee22
> =C2=A0=C2=A0=C2=A0 item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 chunk length 8388608 owner 2 stri=
pe_len 65536
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 type SYSTEM|DUP num_stripes 2

This chunk looks pretty OK.
And it's DUP, so it improves the possibility to recover.

> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 stripe 0 devid=
 1 offset 20971520
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev uuid: 9018=
5cf6-b937-49bb-b191-91d08677ee22
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 stripe 1 devid=
 1 offset 29360128
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev uuid: 9018=
5cf6-b937-49bb-b191-91d08677ee22
> backup_roots[4]:
> =C2=A0=C2=A0=C2=A0 backup 0:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 889143296=C2=A0=C2=A0=C2=A0 gen: 1757933=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 20987904=C2=A0=C2=A0=C2=A0 gen: 932006=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 888881152=C2=A0=C2=A0=C2=A0 gen: 1757933=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 889716736=C2=A0=C2=A0=C2=A0 gen: 1757934=C2=A0=C2=A0=C2=
=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 307560448=C2=A0=C2=A0=C2=A0 gen: 1673227=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 887898112=C2=A0=C2=A0=C2=A0 gen: 1757934=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 30666653696
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 16937803776
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
> =C2=A0=C2=A0=C2=A0 backup 1:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 882311168=C2=A0=C2=A0=C2=A0 gen: 1757930=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 20987904=C2=A0=C2=A0=C2=A0 gen: 932006=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 879738880=C2=A0=C2=A0=C2=A0 gen: 1757931=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 883097600=C2=A0=C2=A0=C2=A0 gen: 1757931=C2=A0=C2=A0=C2=
=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 307560448=C2=A0=C2=A0=C2=A0 gen: 1673227=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 883212288=C2=A0=C2=A0=C2=A0 gen: 1757931=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 30666653696
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 16943640576
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
> =C2=A0=C2=A0=C2=A0 backup 2:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 881082368=C2=A0=C2=A0=C2=A0 gen: 1757931=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 20987904=C2=A0=C2=A0=C2=A0 gen: 932006=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 879738880=C2=A0=C2=A0=C2=A0 gen: 1757931=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 883654656=C2=A0=C2=A0=C2=A0 gen: 1757932=C2=A0=C2=A0=C2=
=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 307560448=C2=A0=C2=A0=C2=A0 gen: 1673227=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 883703808=C2=A0=C2=A0=C2=A0 gen: 1757932=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 30666653696
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 16943722496
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
> =C2=A0=C2=A0=C2=A0 backup 3:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 887865344=C2=A0=C2=A0=C2=A0 gen: 1757932=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 20987904=C2=A0=C2=A0=C2=A0 gen: 932006=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 888881152=C2=A0=C2=A0=C2=A0 gen: 1757933=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 888750080=C2=A0=C2=A0=C2=A0 gen: 1757933=C2=A0=C2=A0=C2=
=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 307560448=C2=A0=C2=A0=C2=A0 gen: 1673227=C2=A0=C2=A0=C2=A0 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 888832000=C2=A0=C2=A0=C2=A0 gen: 1757933=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 30666653696
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 16937803776
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
[snip]
> 2) "btrfs-find-root" yields "Couldn't read chunk root; Open ctree faile=
d".

It's not plain "btrfs-find-root" but "btrfs-find-root -o 5".

And you should use btrfs-progs v4.17.1, not the old v4.4.
The ability to continue search even if chunk tree get corrupted is added
in v4.5, and I strongly recommend to use latest (v4.17.1) for a lot of
fixes and extra debug output.

If you can't find any handy way to update btrfs-progs, you could use
Archlinux iso as a rescue OS to use the latest btrfs-progs.

For 3), I could easily add such feature btrfs-restore, or just use
manually patching your superblock to continue.
So as soon as your "btrfs-find-root -o 5" gets some valid output, I
could continue the work.

Thanks,
Qu

>=20
>> Thanks,
>> Qu
>=20
> Thank you for your quick response and help.
>=20


--k49U4yLlHSLMZsS3Ojv4Y4n6EPrlZF58u--

--pYLbZJdc57FQ96Yvx7mBMuIQLnjnNENzs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvcYwIACgkQwj2R86El
/qjpbAgAhCZHz4CCReJmL/3+4588wVl/A4FTwedEvqcABWYulTyECV5K1NCcRvMu
4pHu8N4qgFpPmlJW2f44tnz0DeE3KN3n6kjEmRG1qlhLjcFWnTupn8RaK8RbR/KK
5dxUo5g49zlw597f/ZJepU9y8LgfQsFfj2SAn0jJZRRj5sXAe+Uhs3xFiMJqVfZU
8UvasmY/tuhTTn3gF1uTpbpDpB7tM1YzXOR3bTS87Ziq0LQ16U5VSCCoPpMYkURi
0ZqUR/fVgx+NDc7qhi3Zol5h1ensNzfyiQRI+S2thuU074xMz/Rl6d0ereaR7MNv
fEu6kVlVQ5rWQvjBUMIa5SKylwNnxw==
=Jl/9
-----END PGP SIGNATURE-----

--pYLbZJdc57FQ96Yvx7mBMuIQLnjnNENzs--
