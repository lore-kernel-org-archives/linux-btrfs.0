Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8F6C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 06:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C1C92087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 06:43:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C1C92087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbeJHNxg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 09:53:36 -0400
Received: from mout.gmx.net ([212.227.15.15]:42229 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbeJHNxf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 09:53:35 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MexFh-1gKaUS0Ejx-00OWjw; Mon, 08
 Oct 2018 08:43:21 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MexFh-1gKaUS0Ejx-00OWjw; Mon, 08
 Oct 2018 08:43:21 +0200
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
 <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
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
Message-ID: <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
Date:   Mon, 8 Oct 2018 14:43:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="h9Ej0LuDG8K1wcNY0nCoQacXr0XxvkhKD"
X-Provags-ID: V03:K1:tNirmMxqwqkemGoIk4uZL5R9QbSzSiygXPrPApfMdkXzIZJGk7O
 Y/m4D+yOK3lwnqKZ68wx+gGHwsEAWEeGAuFLTaB+jrVTU71VlVURrG9EZ5r1ZfTtbdVXeFn
 le4LrvcBcMgr7kneW5kGMyEZH9tIP0hq2oGQSIA82tDkIefGLu8SskSS/t5OAqJGSjOzzNT
 OrLJwn2CJ6Ph0TNdE2YbA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Bh7nubmmaI0=:fbyFr61bcxzVcsRKlyjX1O
 CK/ODr8rG/S5JjlJ5ZtSgc+jbcfGCRx2Ug4d3vppIOaFScmqafL8+M1DK463fW7snUzEGevEC
 nqZ5p7R3FrFiRE263f6fzVbMCRRnQRSkwTN4rlS6vDAJtEkUeWiEdHPNg1hPgxPVgQt6iYqqQ
 4TFkTJsJ8IfhAzZzgHdd9VZw9p9/JQPl9CNPad5XTKsq2wT8SDpE4Ct+jHM57PrwwHAisvKTI
 hU0XOK/nM+ot3FoLCxm30LkyNMRVFr/xm/XE9dDmIqE8Q3Q0zw87E9SPDbyde0PsCHhc1Cl7i
 vivYXtSP/ma+4uJM7emf2bApqediFUjRSo/WQeD5LFTYl3Ddd/MUlCjK/WB5yUsyNYJQX8uVU
 tUksMpjvZH1UVpGr+tSyF11KZ/MQhKpnJmmUhS2KPP3u2K8cSX6DSWgcThAYnWObI3hiisFl3
 E56RhdKgYXW+Dqph7/s6kcBgrqqcgxN9E36x3J8B11zqpz0b5iW7S3VtzYag4+95Y4I4DgkNa
 8XjIOdJblIqwC5V9QAb8T6Bb4U6lQ7a4prZLzQkigjbsTY3Yc2wkDDwKN2b4gljDd96hu9t+U
 OHx9PTV0k8gygca3WRFIoUszJbrhaGI2w6n/BkJ+9Sgr0Dunh7xo3142swarsFZWWatehxAtA
 9XxO8l/tolqznrETmWPtah7znjlwiPek85b1Hs3flU3HMCSKwCWPb98r69u6tJkEFtvXlvex5
 oBlym0iQJircfwiuepwMFXN4fpNK1BRtTdL+N/14v6/dYkGZVmO5tkuhpdG4BNrAMgEYSimc7
 vfMs6GYtjOahWwb6iTXwDHHvSUOJA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--h9Ej0LuDG8K1wcNY0nCoQacXr0XxvkhKD
Content-Type: multipart/mixed; boundary="L324vlVaFCnB4lLTKErzRXJacdCNnlF56";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <b6bb9348-1cb3-4870-4a6b-8758c1250290@gmx.com>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <10a9b7c4-861d-c6f6-b17b-56fa7a5ba5b8@gmx.com>
 <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>
In-Reply-To: <a75d50c8-fb1a-8dc5-80c8-77acc7c4e4d0@mendix.com>

--L324vlVaFCnB4lLTKErzRXJacdCNnlF56
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/5 =E4=B8=8B=E5=8D=886:58, Hans van Kranenburg wrote:
> On 10/05/2018 09:51 AM, Qu Wenruo wrote:
>>
>>
>> On 2018/10/5 =E4=B8=8A=E5=8D=885:24, Hans van Kranenburg wrote:
>>> This patch set contains an additional fix for a newly exposed bug aft=
er
>>> the previous attempt to fix a chunk allocator bug for new DUP chunks:=

>>>
>>> https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c=
903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374
>>
>> For that bug, did you succeeded in reproducing the bug?
>=20
> Yes, open the above link and scroll to "Steps to reproduce".

That's beyond device boundary one. Also reproduced here.
And hand-crafted a super small image as test case for btrfs-progs.

But I'm a little curious about the dev extent overlapping case.
Have you got one?

Thanks,
Qu

>=20
> o/
>=20
>> I'm adding dev extent overlap checking in btrfs_verify_dev_extents() a=
nd
>> btrfs-progs.
>> I think it could help to detect such problem.
>>
>> Thanks,
>> Qu
>>
>>>
>>> The DUP fix is "fix more DUP stripe size handling". I did that one
>>> before starting to change more things so it can be applied to earlier=

>>> LTS kernels.
>>>
>>> Besides that patch, which is fixing the bug in a way that is least
>>> intrusive, I added a bunch of other patches to help getting the chunk=

>>> allocator code in a state that is a bit less error-prone and
>>> bug-attracting.
>>>
>>> When running this and trying the reproduction scenario, I can now see=

>>> that the created DUP device extent is 827326464 bytes long, which is
>>> good.
>>>
>>> I wrote and tested this on top of linus 4.19-rc5. I still need to cre=
ate
>>> a list of related use cases and test more things to at least walk
>>> through a bunch of obvious use cases to see if there's nothing explod=
ing
>>> too quickly with these changes. However, I'm quite confident about it=
,
>>> so I'm sharing all of it already.
>>>
>>> Any feedback and review is appreciated. Be gentle and keep in mind th=
at
>>> I'm still very much in a learning stage regarding kernel development.=

>>>
>>> The stable patches handling workflow is not 100% clear to me yet. I
>>> guess I have to add a Fixes: in the DUP patch which points to the
>>> previous commit 92e222df7b.
>>>
>>> Moo!,
>>> Knorrie
>>>
>>> Hans van Kranenburg (6):
>>>   btrfs: alloc_chunk: do not refurbish num_bytes
>>>   btrfs: alloc_chunk: improve chunk size variable name
>>>   btrfs: alloc_chunk: fix more DUP stripe size handling
>>>   btrfs: fix ncopies raid_attr for RAID56
>>>   btrfs: introduce nparity raid_attr
>>>   btrfs: alloc_chunk: rework chunk/stripe calculations
>>>
>>>  fs/btrfs/volumes.c | 84 +++++++++++++++++++++++---------------------=
--
>>>  fs/btrfs/volumes.h |  4 ++-
>>>  2 files changed, 45 insertions(+), 43 deletions(-)
>>>
>>
>=20
>=20


--L324vlVaFCnB4lLTKErzRXJacdCNnlF56--

--h9Ej0LuDG8K1wcNY0nCoQacXr0XxvkhKD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu6/IUACgkQwj2R86El
/qj8SAgAqRcOrv1A4V46rLzQdBAZ4NNkMcV55fh9QeymMi2mdffv3aTl1Mbd+Kro
egJ+N7pgWAgGVu+ylTGFBGHAU4bjubBbSimaupZ7rDLBMHGrsadyZEkPAzLqHF3m
4gEBiikm4LlH73q2+z+9MunEeBtpQfNFLbXObyVxn+ppq/qgBFjyOldj5K8+W3qr
CyF1UkyL+24AFzUlsBDuSRX9cwscfIpNeBRcP+/tur46nAz2W3VE7jWFNl37tI6+
S+FyYyMvKfQsgrglUoPSiRxR56ekN6Nti5LMqV+xCpYUSILvPTtrAopc5+Ax+Snv
qulSiTCIuyiSRNDM6SQuibeFEWyS7w==
=OyMC
-----END PGP SIGNATURE-----

--h9Ej0LuDG8K1wcNY0nCoQacXr0XxvkhKD--
