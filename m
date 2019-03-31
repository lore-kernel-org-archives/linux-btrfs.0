Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E417EC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E4620870
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 14:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GibBULJa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfCaOke (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:40:34 -0400
Received: from mout.gmx.net ([212.227.15.19]:53931 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbfCaOke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 10:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554043226;
        bh=XzX9Oh9DB9irDos5PCuinh5AqBKO7u1bpwY8VkcIkTg=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=GibBULJai42mt4aDe/4Xi3Kl875Avq0l6N3QoD0cuZK4MBP/IdeO8qRme+rwyqggb
         ZtxixdH1SMh6psF2XXp/MK6Iy4lSjQQcfE//DrVet8iznrQ0PBBNNIWgA7rBJDhaaT
         IGmYQ3Y7CU7pseOU+PHlDzwAHVQAG0Ae0+fGiOFQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M4002-1gtLxq3pbO-00rUfn; Sun, 31
 Mar 2019 16:40:26 +0200
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Hannes Reinecke <hare@suse.de>,
        Alberto Bursi <alberto.bursi@outlook.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
 <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
 <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>
 <1ab38ef8-93b4-5b2d-4e10-093ba19ede13@gmx.com>
 <e67b8b50-dd2a-2106-5362-913167ea48a8@suse.de>
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
Message-ID: <7472d332-3e94-0452-8f6c-5eb61f499830@gmx.com>
Date:   Sun, 31 Mar 2019 22:40:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <e67b8b50-dd2a-2106-5362-913167ea48a8@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lWNeXNfL455MwJqWGWux402oaNEKuJ2Sz"
X-Provags-ID: V03:K1:l4I3rhCCYgC8FD7JH4eN2ZU7LxnlhumqbIiGlAzEIttWSEoUo5G
 OIGREjC9FMwLtTRWdt75u0vD8pE0k71XKQhhJg/Lv/YZlr0OSZII6E1DMzRY3G8NRwFiLtW
 9kRnswCS7x1Du5z75yn/FyyRnMSceomsHyVCkViRRD1WXFLmRJISHJp1Sw3tj41M+zTAGP0
 RStPeEQ481FShQS0nRgsA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zbpEYYCGOeY=:bidA4FKY0+OUf4tWD4vPRv
 frJbEYzaOMUKpAfRAbaGV3M0Cq3XHExMZAPlew4oLbNDpyc/vha4Xxuy10bpMbbPAUOt1HvXk
 7QgmQmDMaIahMi/k2nCXKHu45KQqYE+s/y3LUemkcxlIV7YBIYsJapm8WtMXGVWfmMETZH12I
 E5sMS5wN04QSwNj/HYCTK6IJq0EnhQJ4tREvIPUUYQ5OT0i936lRcJu0on4YNm/Bqb9mo6GF6
 X/6vEWvKGhMOJ9Wqc4loizQEmIlkW9rlzmNAcljRBz1jdKHVijBScbs31hC40UHLlY2Q9uMA1
 otuUT/PBffOyRPMVu/6D4pg9MKexWFR4EyE0GWFa2pEdEkanyj5zOmT7UT76YFkz9wOl6QL/j
 4JyDIHLffqPusdnfsNUH8IdDYj/ZQPN7cND8rYw/c/HVsGDhu7DUotyOtcHRhxUKIs8o/hJ1H
 IwhrKut1C6uSocYWQt0EJuOYKLtQlzBJlk9YqxNz30dGs1l8J3H9fMgXrxJXG8rlt0D5XOJum
 mR3w6VP9n5FIOAUBxyTqec5BaVl3qMwfDN2irpfxi59Q8uFGtpV6qox9HKtvsAd+CQhT7n27a
 Bhmu7h4cfp1IC0trZcnWOH0NSChuhFpvJhoZAlgtlpkmcw5wJbdjkOl8pc2thL9Yxa7u7/NKo
 VwPr0A389XdgVw+XIwR4NMkoJBkKEIFlPPaKPkTQbpbXBxVj4cWQOEmzwvGL0q+HwJtC8GBss
 Sh+6nOlMp1A6WI39qNli7srfC7TiHqPuHsWhyvDsic0JW/YEbQUu8mlFhA2CpOtKLpfjwO/Hr
 wqMrabOgCTIMA0exB9cBlZioIqlK1Ci7fgjonycc6t9ftyYxE38K+HUgFvld4zH12ycDoZOTk
 s1GuXy6b4PpmKrER9YiXYyEAz0R6qnTLoMwkPspO8WfIR++tsxMCjD3adSEkLS
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lWNeXNfL455MwJqWGWux402oaNEKuJ2Sz
Content-Type: multipart/mixed; boundary="1E7zLsTyT7NDS6VUCntjn7NjwImEOocJQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hannes Reinecke <hare@suse.de>, Alberto Bursi <alberto.bursi@outlook.it>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Message-ID: <7472d332-3e94-0452-8f6c-5eb61f499830@gmx.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
 <371167e3-b1d1-48f5-e8a3-501cc41bddf6@gmx.com>
 <a340c3a4-65e7-a1f1-89a0-6b922dfb8755@suse.de>
 <1ab38ef8-93b4-5b2d-4e10-093ba19ede13@gmx.com>
 <e67b8b50-dd2a-2106-5362-913167ea48a8@suse.de>
In-Reply-To: <e67b8b50-dd2a-2106-5362-913167ea48a8@suse.de>

--1E7zLsTyT7NDS6VUCntjn7NjwImEOocJQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/31 =E4=B8=8B=E5=8D=8810:37, Hannes Reinecke wrote:
> On 3/31/19 4:17 PM, Qu Wenruo wrote:
>>
>>
>> On 2019/3/31 =E4=B8=8B=E5=8D=889:36, Hannes Reinecke wrote:
>>> On 3/31/19 2:00 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2019/3/31 =E4=B8=8B=E5=8D=887:27, Alberto Bursi wrote:
>>>>>
>>>>> On 30/03/19 13:31, Qu Wenruo wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I'm wondering if it's possible that certain physical device doesn'=
t
>>>>>> handle flush correctly.
>>>>>>
>>>>>> E.g. some vendor does some complex logical in their hdd controller=
 to
>>>>>> skip certain flush request (but not all, obviously) to improve
>>>>>> performance?
>>>>>>
>>>>>> Do anyone see such reports?
>>>>>>
>>>>>> And if proves to happened before, how do we users detect such
>>>>>> problem?
>>>>>>
>>>>>> Can we just check the flush time against the write before flush ca=
ll?
>>>>>> E.g. write X random blocks into that device, call fsync() on it,
>>>>>> check
>>>>>> the execution time. Repeat Y times, and compare the avg/std.
>>>>>> And change X to 2X/4X/..., repeat above check.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>
>>>>>
>>>>> Afaik HDDs and SSDs do lie to fsync()
>>>>
>>>> fsync() on block device is interpreted into FLUSH bio.
>>>>
>>>> If all/most consumer level SATA HDD/SSD devices are lying, then
>>>> there is
>>>> no power loss safety at all for any fs. As most fs relies on FLUSH b=
io
>>>> to implement barrier.
>>>>
>>>> And for fs with generation check, they all should report metadata fr=
om
>>>> the future every time a crash happens, or even worse gracefully
>>>> umounting fs would cause corruption.
>>>>
>>> Please, stop making assumptions.
>>
>> I'm not.
>>
>>>
>>> Disks don't 'lie' about anything, they report things according to the=

>>> (SCSI) standard.
>>> And the SCSI standard has two ways of ensuring that things are writte=
n
>>> to disk: the SYNCHRONIZE_CACHE command and the FUA (force unit access=
)
>>> bit in the command.
>>
>> I understand FLUSH and FUA.
>>
>>> The latter provides a way of ensuring that a single command made it t=
o
>>> disk, and the former instructs the driver to:
>>>
>>> "a) perform a write medium operation to the LBA using the logical blo=
ck
>>> data in volatile cache; or
>>> b) write the logical block to the non-volatile cache, if any."
>>>
>>> which means it's perfectly fine to treat the write-cache as a
>>> _non-volative_ cache if the RAID HBA is battery backed, and thus can
>>> make sure that outstanding I/O can be written back even in the case o=
f a
>>> power failure.
>>>
>>> The FUA handling, OTOH, is another matter, and indeed is causing some=

>>> raised eyebrows when comparing it to the spec. But that's another sto=
ry.
>>
>> I don't care FUA as much, since libata still doesn't support FUA by
>> default and interpret it as FLUSH/WRITE/FLUSH, so it doesn't make thin=
gs
>> worse.
>>
>> I'm more interesting in, are all SATA/NVMe disks follows this FLUSH
>> behavior?
>>
> They have to to be spec compliant.
>=20
>> For most case, I believe it is, or whatever the fs is, either CoW base=
d
>> or journal based, we're going to see tons of problems, even gracefully=

>> unmounted fs can have corruption if FLUSH is not implemented well.
>>
>> I'm interested in, is there some device doesn't completely follow
>> regular FLUSH requirement, but do some tricks, for certain tested fs.
>>
> Not that I'm aware of.

That's great to know.

>=20
>> E.g. the disk is only tested for certain fs, and that fs always does
>> something like flush, write flush, fua.
>> In that case, if the controller decides to skip the 2nd flush, but onl=
y
>> do the first flush and fua, if the 2nd write is very small (e.g.
>> journal), the chance of corruption is pretty low due to the small wind=
ow.
>>
> Highly unlikely.
> Tweaking flush handling in this way is IMO far too complicated, and
> would only add to the complexity of adding flush handling in firmware i=
n
> the first place.
> Whereas the whole point of this exercise would be to _reduce_ complexit=
y
> in firmware (no-one really cares about the hardware here; that's alread=
y
> factored in during manufacturing, and reliability is measured in such a=

> broad way that it doesn't make sense for the manufacture to try to
> 'improve' reliability by tweaking the flush algorithm).
> So if someone would be wanting to save money they'd do away with the
> entire flush handling and do not implement a write cache at all.
> That even saves them money on the hardware, too.

If there is no report for consumer level hdd/ssd, then it should be
fine, and matches my understanding.

Thanks,
Qu

>=20
> Cheers,
>=20
> Hannes


--1E7zLsTyT7NDS6VUCntjn7NjwImEOocJQ--

--lWNeXNfL455MwJqWGWux402oaNEKuJ2Sz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyg0VEACgkQwj2R86El
/qgEnQf+J0x+u11FBWfshU5U+gjZ+/k3RuPRnuevV4d/tuEGMGHArURiIcCEYoVL
ZziyUkeUuZwUhwcTbug0lS6N10IG5l9Jlpf3GG+BWlChIm5X//7JJ3EElxBpsWoz
LzuZJ9AhT8DG9MIytdH1badU/j5OMWrN/kEBJJaVhQxDGb0/4AyYWZBk8PGYDI7h
1KjUgCg+ztlKkqTq/WW9FeyT+iIxPFrYb5bGr0tA5lYv6HuOSsjkRF8AAI2cEA7x
rIhJoaBzP/6EtAdqnSkqhdPi1HQg/bZDHuhoE7Zspc9duvc3bV4wRbSgo7gIzHOi
Zic3JfSh41NuR4kHe5zG+1wfam+GNQ==
=zANO
-----END PGP SIGNATURE-----

--lWNeXNfL455MwJqWGWux402oaNEKuJ2Sz--
