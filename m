Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A011AC282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E57E20880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 08:28:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hz/SmtRk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfDHI2Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:28:16 -0400
Received: from mout.gmx.net ([212.227.17.22]:44365 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbfDHI2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 04:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554712093;
        bh=QG0lpX0J5UIMOiotWTMsg70G1l7ZJ8n9Jf9r7ehDkkM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hz/SmtRkCZU40Lyc1azLFDZc2nfz5U1NUmj2+HPLWjuz8R64Gdz0dWO9CYBJcTL2l
         0IcNPHX/ywNt/5xzTUTpgAM2LDQ7MuxFZR7P94sB7TyLKAF3rDire/xnsQdGMz4CSS
         vTAyiDJGBhfdqPLaO1ahK/LoVnAvOYwpHNuMnSqI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MVsUW-1hOXbQ2b3w-00X7Jr; Mon, 08
 Apr 2019 10:28:13 +0200
Subject: Re: Btrfs tree locker performance analyser v2
To:     Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc:     linux-btrfs@vger.kernel.org
References: <de699f91-11a6-6ce1-31ec-acabcaa814a8@gmx.com>
 <20190408112135.11417f65@fire.localdomain>
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
Message-ID: <010b5468-5755-8f8b-7b6c-58df82566b50@gmx.com>
Date:   Mon, 8 Apr 2019 16:28:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408112135.11417f65@fire.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LJRBdmlLT2yzDX3f4ygcqkAyWeMP0MT1U"
X-Provags-ID: V03:K1:m0A6raK7S2xUD3TWrbDOWQ+dR1QtBZmuZTEkIomakcSXIFk8kXE
 /WvfhrKOJVObwIIBKgsNa4ZsxcuoaTgjm77S/O56hJ7la5O5j1usLJ3XqQFiuLLpXKd4FVz
 L6fNedjs3fdTJVQ+R9n8gVaUHzvbRICEEkCt74LT35NW87Ocn2ciHe5sUhlXcO2/y7s2XSS
 UlNt6C/PC2pVW4SjVnWIg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VjjCk7/9fPM=:JFE8gjiXCLGlnY77YUvK5L
 gJ0WPpJ26xKESNxhUgf+PhGUFW6ieNoZm934Io0v0fMkbvxwYq7ofyLzvhta3ssMWImJEhKfo
 ERwFShkk8izJjT926mFyyJ3NzDIfaHyH4JsiBTr4VVBkPI3PAieklxkEYFPTZ3RyEQ2saS4p2
 ALh9Z7jmUcgSGhNxE70V2vBqOKRge6jiFUa/eYr7d/SwjVIH+Q7SOGK/uB3nLp4kHRKd4j2we
 D9xE06F/yDdgO4zJufh5Jk0DS/jOaSFoXhpJ7//AF9khFE5XJRhT2YE8AFohfFqJqYuaf5SEL
 foXZCnhoaGFkPmBdqMOzvuDZAmUQP2g2EF1go6jTMJMXvm2K7jNEQq2OCpQsXTb6HZbXovitn
 ll0uaqI2t96eXlCqqeBesRkDgl8qw3lEDK09eBKKhKoD3OjGLiaND9idiMtuGU5Mzpd/VK+Wp
 IVODZPTRtWtldTSVdOB39+SJE1JX6IX8SpvsA79C814kCTbANSxXvnzY12hUrAq+E++/aGVuk
 36On0jefP2hkkk0NkzBj1UJo8t08G0O2ToNd0D/bXVkJGrwVKrA7s8LMUf9Y0BAOhl0zoDyl6
 hzK94jI4+Og4tWFUSFIQbwm2/b/J6yZeX+sY039OdijFQMR1xgNllSwrl8rC2kfHKm9/sPOM/
 w+t6yvkkjCaAWe59VDnO1LWHfyHKeVFSERvei35s1sv/eFQsyzp4YcywShQ7tICO+XNRxaP/K
 VlU2Vbmy1wHuCnbGkuwczJXqFTlwlHR7yDuqEIX+SWzFY/ZyTTan7nqFz1CQgsId85xDeG3qn
 RAhpvXiy1zD9RIOJ/3d6xoECwgReLDDmIqWodoSTgXZRSOKiLDn7v7O+Pgnrxe+8aOR3sfdlt
 n5f+kscH9uYlSlU2fyQqnuB5Bi6xfFWd6auy5EeQ5Zm5/N0npFFXrX/nu/Nz6U
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LJRBdmlLT2yzDX3f4ygcqkAyWeMP0MT1U
Content-Type: multipart/mixed; boundary="gKLOm9KihRUkF3iM3F1kLNLHmtkNeh9yP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <010b5468-5755-8f8b-7b6c-58df82566b50@gmx.com>
Subject: Re: Btrfs tree locker performance analyser v2
References: <de699f91-11a6-6ce1-31ec-acabcaa814a8@gmx.com>
 <20190408112135.11417f65@fire.localdomain>
In-Reply-To: <20190408112135.11417f65@fire.localdomain>

--gKLOm9KihRUkF3iM3F1kLNLHmtkNeh9yP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/8 =E4=B8=8B=E5=8D=884:21, Dmitrii Tcvetkov wrote:
> On Mon, 8 Apr 2019 16:06:39 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
>> Hi,
>>
>> There is the second version of btrfs tree locker analyser.
>> https://gist.github.com/adam900710/766767dba5381b86534c9051780ed262
>>
>> The script is also attached to the end of mail.
>>
>> Please note that, it needs a trace event which is not yet merged.
>>
>> That patch can be find here:
>> https://patchwork.kernel.org/patch/10881305/
>>
>> Unlike previous version, this version is based on trace events.
>> As long as we have btrfs_tree_lock() and btrfs_tree_read_lock()
>> events, we can using trace events to get all the needed info.
>>
>> Compared to previous in-kernel version, this one has better
>> resolution. For example, we have an event whose
>> start_ns =3D 100ns end_ns=3D200,000,000ns (200ms) interval=3D100ms.
>>
>> In previous in-kernel version, we will put all that 200ms latency into=

>> the checkpoint 200ms.
>>
>> While in this version, we will put (100ms - 100ns) into checkpoint
>> 100ms, while another 100ms into checkpoint 200ms.
>>
>> Some test result can be found in google doc:
>> https://docs.google.com/spreadsheets/d/1B5ETQNMq2plIcWBgEJZ5ap6NnXcAu2=
A4gTogGltlq4E/edit?usp=3Dsharing
>>
>>
>> The script starts below:
>>
>> #!/usr/bin/python2
>> # @lint-avoid-python-3-compatibility-imports
>>
>> from __future__ import print_function
>> from bcc import BPF
>> from sys import stderr
>>
>> text_bpf =3D '''
>> #include <uapi/linux/ptrace.h>
>> #define FSID_SIZE   16
>>
>> struct data_t {
>>     u8  fsid[FSID_SIZE];
>>     u64 start_ns;
>>     u64 end_ns;
>>     u64 owner;
>> };
>>
>> BPF_PERF_OUTPUT(events);
>>
>> TRACEPOINT_PROBE(btrfs, btrfs_tree_read_lock)
>> {
>>     struct data_t data;
>>
>>     bpf_probe_read(data.fsid, FSID_SIZE, args->fsid);
>>     data.start_ns =3D args->start_ns;
>>     data.end_ns =3D args->end_ns;
>>     data.owner =3D args->owner;
>>     events.perf_submit(args, &data ,sizeof(data));
>>     return 0;
>> }
>>
>> TRACEPOINT_PROBE(btrfs, btrfs_tree_lock)
>> {
>>     struct data_t data;
>>
>>     bpf_probe_read(data.fsid, FSID_SIZE, args->fsid);
>>     data.start_ns =3D args->start_ns;
>>     data.end_ns =3D args->end_ns;
>>     data.owner =3D args->owner;
>>     events.perf_submit(args, &data ,sizeof(data));
>>     return 0;
>> }
>> '''
>>
>> def is_fstree(owner):
>>     if owner =3D=3D 5 or (owner >=3D 256 and owner <=3D (2 ** 64 - 256=
)):
>>         return True
>>     return False
>>
>> # TODO: Don't use such classification while have a good idea to output=

>> # all the needed info
>> def get_owner_str(owner):
>>     if is_fstree(owner):
>>         return 'SUBVOL'
>>     if owner =3D=3D 1:
>>         return 'TREE_ROOT'
>>     if owner =3D=3D 2:
>>         return 'EXTENT_ROOT'
>>     return 'OTHER_ROOTS'
>>
>>
>> '''
>> Sparse dict where access to hole (non-exist) key will return 0
>> other than raise an exception
>> '''
>> class sparse_dict:
>>     data_dict =3D {}
>>     def __init__(self):
>>         self.data_dict =3D {}
>>
>>     def __getitem__(self, key):
>>         if key not in self.data_dict:
>>             return 0
>>         return self.data_dict[key]
>>
>>     def __setitem__(self, key, value):
>>         self.data_dict[key] =3D value;
>>
>>     def __contains__(self, key):
>>         return (key in self.data_dict)
>>
>=20
> You can use the following for the same behaviour:
>=20
> from collections import defaultdict

Thanks!

In fact I have learned so many new things just to craft this python
script (and also hit tons of bugs during the procedure), there will
definitely be a lot of python bugs.

Never know to use factory function in python, this is a good chance for
me to new some more.

Thanks,
Qu

>=20
> <snip>
>> # @results is a 2 dimension dict.
>> # [<aligned_timetamp>][<owner_str>] to access, no need to
>> # worry about non-exist key.
>> results =3D sparse_dict()
>=20
> results =3D defaultdict(int)
>=20


--gKLOm9KihRUkF3iM3F1kLNLHmtkNeh9yP--

--LJRBdmlLT2yzDX3f4ygcqkAyWeMP0MT1U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyrBhgACgkQwj2R86El
/qjHvAgArPiH7pQduIvAQmireN2P5LdCUvl1giMCiKt3REQ+yJtbZmpR084zMZ5F
GHKOHrrkSzXzV6gAnAD1icNaWR7h4inMYJBCftHMZlufuDh7smv04TuzHOzTFhWq
XTJdmOdTAKbqvkkWGTOGRwMjSmD1xxacU1azFqGSmvHe0ODq68k3uu1J62lO2tY7
BNl17csO3/oStDWKkaMPR2eBZyYZBKpC8GUn3fIX5+cPY8Dm05YREQRsGxVD9KZY
dNXg/b2s734CpDbBroq/Xu74mKys5GPNU85hzKUn185W6zns1qp0uX54eQO5wrFR
++QU0C1Zs/Qp9qBQav6Fczd1DffEzQ==
=HLFW
-----END PGP SIGNATURE-----

--LJRBdmlLT2yzDX3f4ygcqkAyWeMP0MT1U--
