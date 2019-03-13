Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B551C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 190D02147C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfCMJBY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:01:24 -0400
Received: from mout.gmx.net ([212.227.15.15]:46605 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfCMJBX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 05:01:23 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MU11l-1hUdQo3Rw1-00QmJV; Wed, 13
 Mar 2019 10:01:16 +0100
Subject: Re: [PATCH 0/6] btrfs: Enhance tree checker and runtime checker to
 handle the new wave of fuzzed image attack
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190313085511.23540-1-wqu@suse.com>
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
Message-ID: <5f3e48b8-3998-409a-2fc7-af2481b52c0f@gmx.com>
Date:   Wed, 13 Mar 2019 17:01:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190313085511.23540-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gCoZAkPPViLykXqNf7yGNQXXVSNiYqNav"
X-Provags-ID: V03:K1:GDL5O+IVAGCFOwuM6EQWp1FKo3loITcUSK2/u2YkG8GolXXiEf2
 n06c5I+0WFjewVdywnmJGvPoFO03hf3M2RsoOqe46NvMPTI23Ev7iNQp33sZGEbClhvE/MG
 oRIJXtq9Yq6gRT4rq4GCP2yZkQWyosBKXJsblMV1RlSaMROv2gEdCpvevEFYFQ4k2Hp7gkb
 QEqDK9foM3+W05z/ymZ6g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SZTH5PVNDgY=:gJAPex1uEpQzogFhWEXeCd
 AHUFPo14jiWdhDHKk7AD7PlYq0oxtQxFSLF/1ahSspEsJGOj1pVYvZgZZntt2DTwmB5XlBeC7
 pfW6jJ9x15EEWR3l37PqvOCM1TgdFDubTMoWipb5ukIxhb4CW24scJKswyGTNkmat/uZDn+l3
 b6BlPrM1HazWQEgrELrbgf1JiDcDfmECZzaitTW0DJO3R9iTzDO8vuNQdXx2ZEfqD4VZYp52a
 rm4OXypyekZgrSJmf5TBao+zVPTM+wcyimfKq0YhpdfnGkUl8XGGs6Jp4H9o/W+DGhzAw5qHp
 bHrTYyhWTX1+Vaxb0swoZmYji/spUe6znrVfK1vFJFQ9z3OZTPbDVvtMurmeRhjmf3zAqfPL1
 hghlnQLg17oZbtxZDPYOLcLDwnAn/OO4hm9ajGdec9AEbOCG2oSWZpjlaoyDgisWJTSu9kDyF
 eyFK+UwdzMAerCGfk0MMQAvDWWF8ieBul3gipsoLdCvsYVeRty8s077qVyuS0rB6iJiZzPnMq
 IWKcLwc4J/sJdTpPSx/1fcZwdnAUYZCpQVZ0GdC0rS/j0iT1XguGXgIVVB5KatRaQxdHdBuzY
 lru/OLL4FqencvlA84wGWfxZTOOzLzeRFId5P5jjSi6llW+j3plTVuLbtfKluY/mWXgV8lb7K
 ketFshlixLFWlpEtmSTCREwINUTabNpxiE/gCWsDpO38kmrwu2/8N10WlU5TlpNOQ2iAAHI9D
 aep/wK8tSyPmcblcCC7tctyBTIFMeG62ZK17P3FC3vCqKH78zMjA2Cs4hH30jO7z5vcAXEuD4
 tJHOzLLF3KPSzXQhgnQYPskag4dL9SpalBU6dXGvxLjMPTuc+wt99n9ic8e5KJSucsWFxENgE
 TZtrDtPd0GpogBxGx0FCRgqyuc8ldbz7SgM+ZzEy1W6R0RjNiTmuPPXDccdpxG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gCoZAkPPViLykXqNf7yGNQXXVSNiYqNav
Content-Type: multipart/mixed; boundary="8EcMbsyefC0tTqeSgpcFnbIpTiN1jbKG1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5f3e48b8-3998-409a-2fc7-af2481b52c0f@gmx.com>
Subject: Re: [PATCH 0/6] btrfs: Enhance tree checker and runtime checker to
 handle the new wave of fuzzed image attack
References: <20190313085511.23540-1-wqu@suse.com>
In-Reply-To: <20190313085511.23540-1-wqu@suse.com>

--8EcMbsyefC0tTqeSgpcFnbIpTiN1jbKG1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Just forgot the repo:

It can be fetched from github:
https://github.com/adam900710/linux/tree/tree_checker_enhancement
Which is based on my previous write time tree checker patchset.

Although the patchset itself can also be applied to v5.0-rc7 tag without
manual modification.

Thanks,
Qu

On 2019/3/13 =E4=B8=8B=E5=8D=884:55, Qu Wenruo wrote:
> Thanks for the report from Yoon Jungyeon <jungyeon@gatech.edu>, we have=

> more fuzzed image to torture btrfs.
>=20
> Those images exposed the following problems:
>=20
> - Chunk check is not comprehensive nor early enough
>   Chunk item check lacks profile bits check (e.g RAID|DUP profile is
>   invalid).
>   And for certain fuzzed image, the other copy can be valid, current
>   check timming is after tree block read, so no way to retry the other
>   copy.
>=20
>   Address the check timing in the 1st patch, while for the profile bits=
,
>   check it in the 4th patch.
>=20
> - Lack of device item check
>   Address it in the 2nd patch.
>=20
> - First key and level check be exploited by cached extent buffer
>   Cached bad extent buffer can avoid first key and level check.
>   This is addressed in the 3rd patch.
>=20
> - Inode type mismatch can lead to NULL dereference in endio function
>   If an inode claims itself as symlink but still has regular file
>   extent, then endio function will cause NULL pointer dereference.
>   Fix it by do extra inode mode and dir item type cross check, at
>   get_extent() time and inode lookup time.
>   Addressed in the 5th and 6th patch.
>=20
> Qu Wenruo (6):
>   btrfs: tree-checker: Verify chunk items
>   btrfs: tree-checker: Verify dev item
>   btrfs: Check the first key and level for cached extent buffer
>   btrfs: tree-checker: Enhance chunk checker to validate chunk profiler=

>   btrfs: tree-checker: Verify inode item
>   btrfs: inode: Verify inode mode to avoid NULL pointer dereference
>=20
>  fs/btrfs/ctree.c             |  10 +
>  fs/btrfs/ctree.h             |   2 +
>  fs/btrfs/disk-io.c           |  10 +-
>  fs/btrfs/disk-io.h           |   3 +
>  fs/btrfs/inode.c             |  38 +++-
>  fs/btrfs/tests/inode-tests.c |   1 +
>  fs/btrfs/tree-checker.c      | 342 +++++++++++++++++++++++++++++++++++=

>  fs/btrfs/tree-checker.h      |   3 +
>  fs/btrfs/volumes.c           | 103 +----------
>  fs/btrfs/volumes.h           |   9 +
>  10 files changed, 406 insertions(+), 115 deletions(-)
>=20


--8EcMbsyefC0tTqeSgpcFnbIpTiN1jbKG1--

--gCoZAkPPViLykXqNf7yGNQXXVSNiYqNav
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyIxtgACgkQwj2R86El
/qhTGwf/VcOvq8N6V36/2f93huCmeEcD3SvfXkybYw1SbOXzYVcGHKB5rm5nI5BJ
YPLfuQKSC/TccdYSXNNBqXt7wRUATKdUUFxHciJGtkipjhbncSCcL/ff/LpYSCEI
3d8tUEFKS2QR+gnBPFJ9CarXvHIHoDqxtu4ya5WJXUoPs5Q8bM0+TJhaa25tp5LA
uxVTEZ6dEOqjCu1E7v/mKstZZrZ9DAny0/+j1rNUC8va423cddaPm5EojSqicHJR
tOuG6MqgeNJQLqvL1yNc3lePLU66CDOWeKmUQfawBNPHtfXJoOVhF6w11mu+ix+m
WDxAqEaPg2E6HaWgxbR+FfWF1nC6aQ==
=7hDT
-----END PGP SIGNATURE-----

--gCoZAkPPViLykXqNf7yGNQXXVSNiYqNav--
