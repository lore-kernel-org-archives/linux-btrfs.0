Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B93DC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 01:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185C0217F4
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 01:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfBZB3r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 20:29:47 -0500
Received: from mout.gmx.net ([212.227.15.15]:43575 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbfBZB3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 20:29:46 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Mdr7l-1gdsRr0yxZ-00PeqB; Tue, 26
 Feb 2019 02:29:39 +0100
Subject: Re: [PATCH 0/6] btrfs-progs: Support for BG_TREE feature
To:     Hans van Kranenburg <hans@knorrie.org>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181228083806.3204-1-wqu@suse.com>
 <8a88277e-6a9f-7383-601f-cb6e84451ce5@knorrie.org>
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
Message-ID: <c268ed19-f472-be89-b8e5-68d1b055eecd@gmx.com>
Date:   Tue, 26 Feb 2019 09:29:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <8a88277e-6a9f-7383-601f-cb6e84451ce5@knorrie.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="awklh2UKwWcttxTrTjwbKrC8ds89Q7SpT"
X-Provags-ID: V03:K1:DpwmUKmbj+ilXbfqVSL9ZweiBzXLXmfakYnrO0WWT557ZoUooDK
 7yN46cF9HaO5NDvQN6+Mp/JfGQHDjW3sGGuk2HRc8sxwinVY+PjPNnxly8R6VF3vUOWtsX+
 cINfzzqL+B8MC2RzVwNzFf1rz+6JTudsSqLCDZlQkloz2onx/13v82vFHdkI97prHXznp/i
 bW7nvfgKwfhRFhKJqs7tw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zuV94LQAI9c=:57tCZIT8IuT04aPwhMLJzA
 1NIddadJ212uFQo8TRbxt7rkG2xgd99MUtAyj2JiVUyUq0cTrM0XxMAQ7Me2k91H3tj+q7UTC
 UOZY0YYWS1rRPZ1lV2BIXYpjg4r/CPWqPBvODOu9fZcRLYGE4gmY+W5K1fQN9c4hCulQWJTIW
 tabJ0ku4pgI+PXTWn6usMWwp6uTJEtBLqkbgbGRtIx3RBUSV4IlF7N2EVCvSzIqnqGiJwOBM8
 RFKAcIi/2QcDEPjstdWg5TqXdd1RqS5dENSE88dQkoa/bm8JludCpBjHLpl3Yyjchxb0pSEC5
 ruTLKYTg8J98Xn8uSWfUN0dJOFr+cjI7Sm4N/zRX8japLSwA77fGlUzeodKUfJDdTlU6Ubxzj
 6SyeBGlujRDZHX1HJ8SRtccukueCmWchSxvFe7HTU5h8s/Iyl2TwJrY9Tpc4HeRK95g3qNzhK
 mkoWGYammHfcHKixMtWfYQ69TUjRWznfmje9c6emxVVeaw/8mtP2IKnILBpPsbW+okxFmN/vI
 dteVMmYzJ4sg/RPhUcJXfr2opQrKG4tMU9IgGXpKRPAjg+6m15xtgaYs5XnmuZ8msItrNRO5K
 nqzGUrFRZVKoYEpO7cOo51JgeluG/3J3f6vbKyUDEE9vAi7ZbNi1xmm08JOgSvaDoj9AbpT51
 Xv+4kLElVl65rCi5C8Ak7MhWZUu6kCqDwVOEQ93aFEdonOZBsTmDwMiQ4IKmeU+MhfBotZohg
 CRYItuC1SsZEnvYMpWst535LOAifAex3VG7dwe+R5A1TYfcja3t4SxUXhOTbaCRbwzf8sSWYe
 a0Ux2SFVjbRD4O/qSC5k9/bIf0sMWo/7+cDAqcWOc7myNp/wkIGxrNCNYfYTYHKs9EWEVY7ka
 mfCQmUrydsxzcaoPhxs+ypCi5t4tl9aZrkY1f8LX/n8XcixrdxGvjMCp0nkcGi
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--awklh2UKwWcttxTrTjwbKrC8ds89Q7SpT
Content-Type: multipart/mixed; boundary="dSQz9qrEgLG8FeIiR4RYnaStrjJxwsJrj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans@knorrie.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <c268ed19-f472-be89-b8e5-68d1b055eecd@gmx.com>
Subject: Re: [PATCH 0/6] btrfs-progs: Support for BG_TREE feature
References: <20181228083806.3204-1-wqu@suse.com>
 <8a88277e-6a9f-7383-601f-cb6e84451ce5@knorrie.org>
In-Reply-To: <8a88277e-6a9f-7383-601f-cb6e84451ce5@knorrie.org>

--dSQz9qrEgLG8FeIiR4RYnaStrjJxwsJrj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/26 =E4=B8=8A=E5=8D=8812:36, Hans van Kranenburg wrote:
> Sorry to bother you again...
>=20
> On 12/28/18 9:38 AM, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/btrfs-progs/tree/bg_tree
>> The basis commit is:
>>
>> commit 7d16a2b460182ee98c649533a6975b6e419c3d71
>> Author: Qu Wenruo <wqu@suse.com>
>> Date:   Thu Dec 27 13:49:18 2018 +0800
>>
>>     btrfs-progs: Create uuid tree with proper contents
>>
>> Which is further based on devel branch.
>>
>> This patchset provides the needed user space infrastructure for BG_TRE=
E
>> feature.
>>
>> Since it's an new exclusive feature, unlike SKINNY_METADATA, btrfs-pro=
gs
>> is needed to convert existing fs (unmounted) to new format.
>>
>> Although I have prepared the functionality, convert_to_bg_tree(), and
>> already uses it in mkfs, I haven't decided if I should put it under
>> btrfstune, as btrfstune isn't such offline convert tool.
>=20
> Ok, so, the convert_to_bg_tree still needs wiring up somewhere before
> it's possible to convert an existing fs?

Sorry, I haven't investigate more time for this convert.
It's more or less expected to be something use it or not so far.

>=20
> I want to test with a (iSCSI level clone of a) rather large-ish
> filesystem, so I was searching for how to convert that in place.
>=20
> Do you have an idea for a (quick hack?) way to make this happen?

Btrfs-progs needs extra patch for it, but I haven't implemented it yet.
It shouldn't be super complex, but I'm not confident enough yet.

If nothing goes wrong, I'll update the btrfs-progs patchset this week
with (maybe PoC) offline convert.

Thanks,
Qu
>=20
> Doing the offline conversion itself is also already an interesting
> thing, seeing how it behaves with some tens of thousands of block
> groups... (As the intended audience for it will mostly be people having=

> large filesystems already.)
>=20
>> If anyone has better idea on the new convert tool interface, I'm all
>> ears.
>>
>> For the performance improvement, please check the kernel patchset cove=
r
>> letter or the last patch.
>> (SPOILER ALERT: It's super fast)
>>
>> Qu Wenruo (6):
>>   btrfs-progs: Refactor excluded extent functions to use fs_info
>>   btrfs-progs: Refactor btrfs_read_block_groups()
>>   btrfs-progs: Enable read-write ability for 'bg_tree' feature
>>   btrfs-progs: mkfs: Introduce -O bg-tree
>>   btrfs-progs: dump-tree/dump-super: Introduce support for bg tree
>>   btrfs-progs: check: Introduce support for bg-tree feature
>>
>>  check/main.c              |   7 +-
>>  check/mode-lowmem.c       |   9 +-
>>  cmds-inspect-dump-super.c |   3 +-
>>  cmds-inspect-dump-tree.c  |   5 +
>>  ctree.h                   |  17 +-
>>  disk-io.c                 |  29 +++-
>>  extent-tree.c             | 326 +++++++++++++++++++++++++++----------=
-
>>  fsfeatures.c              |   6 +
>>  mkfs/common.c             |   7 +-
>>  mkfs/common.h             |   1 +
>>  mkfs/main.c               |  57 +++++++
>>  print-tree.c              |   3 +
>>  transaction.c             |   1 +
>>  13 files changed, 365 insertions(+), 106 deletions(-)
>>
>=20


--dSQz9qrEgLG8FeIiR4RYnaStrjJxwsJrj--

--awklh2UKwWcttxTrTjwbKrC8ds89Q7SpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx0ln0ACgkQwj2R86El
/qhNJAgAl/M2x8UIWs4iQWbsLcoo50Vmiq4arQMlHVP22dto356I9uCo2NeWUBmS
ZGDSTuTD1hB3H5IqPyrSdoIalYLpOVL26xoZOHGFMTQpTWk8870LJVP+Gp62iUpf
ppQ9mLPK4lThGAr0ldQrn8qdm9WN+TGWaQlQZajl0bG4VF0HgCTzVwqYwhT0rdQ3
hIidO4Ob+DFAuzOUYnR/lQ0SJNjfE+EE6o8JJGZTQGLqojQqpoUjoBFiHXAbhZ7q
2iz7Fpfi0Oxdk+VXNZqzQhH3gjK79TO6pkUa8h1R9VLEWhIIvEy5TvbiI3n4XamC
vlxJQNRbyZVc17BXIIo+y8+GJPP6/Q==
=oJ9i
-----END PGP SIGNATURE-----

--awklh2UKwWcttxTrTjwbKrC8ds89Q7SpT--
