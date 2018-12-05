Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9899C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B7D32054F
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7D32054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbeLENDS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:03:18 -0500
Received: from mout.gmx.net ([212.227.15.15]:40733 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbeLENDS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 08:03:18 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MaqqY-1gnhc32iJG-00KMCl; Wed, 05
 Dec 2018 14:03:14 +0100
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
References: <20181205122835.19290-1-rgoldwyn@suse.de>
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
Message-ID: <1d687042-774f-e27b-7341-e5cd7a6be3d2@gmx.com>
Date:   Wed, 5 Dec 2018 21:03:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n3MPJSSrjfFRbz1EtrxbjAT6ST1PCrQe1"
X-Provags-ID: V03:K1:MWQ75I5QKW+i0U2QooPl278xAi/NEP+plxoQ4RYVeSOe7uzPH5n
 9l6BcveRXMOcYRAQjaynKrQ+uXNi/i0/jILXGqsEzNnuJmCbl2iwdC93CDlJtqrdK7jR84o
 bDhxAK4OCRzFN8xFEGUqtB3zZjRr27y2VAreHFpAhXAPp3wj+DBrU0cKQPSkt/nOPFIOVPs
 zzjYj0eCtLnpNKwzdTz4A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:M5+C8a/DZDg=:l+XjpOR74JgvTz2YcdYrnz
 +DyWnNmtfRfBwuh2xzUDo0DQH9jUQHZGsMH7AKYh8zzbLTg+nZ60aCC/4EhRuEI2ChxXjb5HY
 Gh34jArhNA+62lYz8xPTCUXacl8vQFmHzhZaZs/48/vsJ6I8cCnk4bJys1gSCLvRoBe4R7DDO
 fTw2PQrk/U1nzUsRVH2234ZlmWSNGf+wR0r5iZNtM/NNI11s/MVTVjqEub1xa25VwV5ym3ZF4
 tVnrJE4imTE+L9+flQt4cvbApGNNnCxLdvld/71SScOKqYi+pD9DLUwgG/evKkx9em7h4qJLP
 AmL5j4V1yKc4wBw1/j327Q0Ql+hLHcx1KdYWvOQItI4IDErNbsjuUZIEduAKwuidLVEy9y6Ei
 I6luip2QSdlyCIc1Gtj8I//PKyQYIMXgCKt8LUa5o4sCiBRtF7o5AFCHuaz06MnLJ3c5PC9Na
 y6SCf1ls1PRNs1W8vhVA8ZvcwJK65PwPGrJUZ20GDGg5bZNFOKl5aGanwUcynm8R/Q4zh+Zk6
 cUxkqjbqyrJHp14W6GY69s2si34SaHmts8BKQBqmPas1uv8JljFDQCm2EYMlr92WLdTgBJGDp
 RrDRmSVhDtSWyBczBO4ey/UG0hSritlRroS5nvCscejdAWPj1DdW9jPL3Ms3TB810uOi7CUms
 jb93VeyV5qP9GEuIB+FgOWjZFTCUv9QfW5Wk/JDfrgZhezQztOmZfbMqznDoAozQ311/FkVhc
 TS4mmOSjMeWeome5/HikQ69Hh/Be7TFN3JEZP6Ls460xNx4sjv8xPC0gKQ0TmkV+u7Mo2l5Om
 NisXDZ8/jxFzcXdMzQkwutO5rGgQQq3yjArOFaknfjn1hkseUkH7nQ+13oJgBJxzofju7gPaR
 oP/IM3IrynkjzGzKGql0L3h4QqlueWR/vkva2OsWEZd1QwCWkX7XEwa81LN4OI
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n3MPJSSrjfFRbz1EtrxbjAT6ST1PCrQe1
Content-Type: multipart/mixed; boundary="DelTrRZ7lyAyLoLjHqeUfDVdku3AgSwkH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
Message-ID: <1d687042-774f-e27b-7341-e5cd7a6be3d2@gmx.com>
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
References: <20181205122835.19290-1-rgoldwyn@suse.de>
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>

--DelTrRZ7lyAyLoLjHqeUfDVdku3AgSwkH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/5 =E4=B8=8B=E5=8D=888:28, Goldwyn Rodrigues wrote:
> This is a support for DAX in btrfs. I understand there have been
> previous attempts at it. However, I wanted to make sure copy-on-write
> (COW) works on dax as well.
>=20
> Before I present this to the FS folks I wanted to run this through the
> btrfs. Even though I wish, I cannot get it correct the first time
> around :/.. Here are some questions for which I need suggestions:
>=20
> Questions:
> 1. I have been unable to do checksumming for DAX devices. While
> checksumming can be done for reads and writes, it is a problem when mma=
p
> is involved because btrfs kernel module does not get back control after=

> an mmap() writes. Any ideas are appreciated, or we would have to set
> nodatasum when dax is enabled.

I'm not familar with DAX, so it's completely possible I'm talking like
an idiot.

If btrfs_page_mkwrite() can't provide enough control, then I have a
crazy idea.

Forcing page fault for every mmap() read/write (completely disable page
cache like DIO).
So that we could get some control since we're informed to read the page
and do some hacks there.

Thanks,
Qu
>=20
> 2. Currently, a user can continue writing on "old" extents of an mmaped=
 file
> after a snapshot has been created. How can we enforce writes to be dire=
cted
> to new extents after snapshots have been created? Do we keep a list of
> all mmap()s, and re-mmap them after a snapshot?
>=20
> Tested by creating a pmem device in RAM with "memmap=3D2G!4G" kernel
> command line parameter.
>=20
>=20
> [PATCH 01/10] btrfs: create a mount option for dax
> [PATCH 02/10] btrfs: basic dax read
> [PATCH 03/10] btrfs: dax: read zeros from holes
> [PATCH 04/10] Rename __endio_write_update_ordered() to
> [PATCH 05/10] btrfs: Carve out btrfs_get_extent_map_write() out of
> [PATCH 06/10] btrfs: dax write support
> [PATCH 07/10] dax: export functions for use with btrfs
> [PATCH 08/10] btrfs: dax add read mmap path
> [PATCH 09/10] btrfs: dax support for cow_page/mmap_private and shared
> [PATCH 10/10] btrfs: dax mmap write
>=20
>  fs/btrfs/Makefile   |    1=20
>  fs/btrfs/ctree.h    |   17 ++
>  fs/btrfs/dax.c      |  303 +++++++++++++++++++++++++++++++++++++++++++=
+++++++--
>  fs/btrfs/file.c     |   29 ++++
>  fs/btrfs/inode.c    |   54 +++++----
>  fs/btrfs/ioctl.c    |    5=20
>  fs/btrfs/super.c    |   15 ++
>  fs/dax.c            |   35 ++++--
>  include/linux/dax.h |   16 ++
>  9 files changed, 430 insertions(+), 45 deletions(-)
>=20
>=20


--DelTrRZ7lyAyLoLjHqeUfDVdku3AgSwkH--

--n3MPJSSrjfFRbz1EtrxbjAT6ST1PCrQe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwHzIwACgkQwj2R86El
/qhF0Af/c99800r4EXzR2TSDgUhjho8+537aLX4LOiNL92hsaT9c1rr+UTz2SNzH
a1mR3GIZRj5RloZv+hg0TdhZX0n41LFM5IdBzdy+zX8rkbIrLQ/g+/QlGNBAU730
PPMkmLinhnb1nDbkpFBBVtSRq4ls/F6LgtY3dXQ5dEw/Q3uJrqSQkgXO6TCezH+a
uDCGClDZz9e04/4A1p7VV8fgkYP40RU0TdyemR3IRhPt7nC2z2oUTk7C+i8arNFO
PDI2C+bY5ckI3NpGwuHCrqU0pe/jBHYGwPBS2CL9wr9ayL4KW+zUp8qvxNW0i5Tu
KBRNgZ7eP6+H3pFwWL2WG61/vhIrCw==
=f0K5
-----END PGP SIGNATURE-----

--n3MPJSSrjfFRbz1EtrxbjAT6ST1PCrQe1--
