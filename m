Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE07C46475
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 00:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B8A920848
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 00:09:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B8A920848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbeJZIod (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 04:44:33 -0400
Received: from mout.gmx.net ([212.227.17.21]:34923 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbeJZIod (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 04:44:33 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEo4s-1gLtBL37oQ-00Fyx7; Fri, 26
 Oct 2018 02:09:46 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEo4s-1gLtBL37oQ-00Fyx7; Fri, 26
 Oct 2018 02:09:46 +0200
Subject: Re: Kernel crash related to LZO compression
To:     Dmitry Katsubo <dma_k@mail.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
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
Message-ID: <1bd8d0f1-76e1-1bda-867e-3fadc35c30a2@gmx.com>
Date:   Fri, 26 Oct 2018 08:09:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x7S2tlB6bsNu0CHJf6SZO2f4Vvif2FSTF"
X-Provags-ID: V03:K1:m9Uv8Eu65OT9KxHWCiVFOSfqmbeu7patCSlv4TUM1PQ6NJlM17P
 looLJ+KHrdasZ2CND3QN079f1QJKrgonIOUxNBG1HSG1n8NefLxLJbsNxWGINhVJizGgfYx
 nzUOSpZIoK6gBuVx8SeGpLwAjRo7ohuWQ73URmyh7MJ8IN4XZTr9+H8evEHxGqIHI88gtPB
 i5dKykbKh52FyG0P7clDQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:fNPIiy/iB/0=:AS6hCZu98NRtLDM2g3nb9F
 eHCm8k+ZeJW790fBg7n9XafLrncRpGz8AJokSUM02frnczj9mOoOl83UFXA5yxstc8b3i/rr/
 VD6tzjZyFffPPQ48k1QvYtjVukQclJwtoDtopkVJcEJgWiPx3sLIvJwSeOECWeYdxEjAqDxcH
 cXI8vqy6vRMfqODZ1wp4akv5PWuWQ0jgnhyMsZwtvCCcyGAyCALVHhBbLljJla55Y7gzhnbLP
 Z8dXL762SipIgBaE2jUuUENybxrdkAhgEZqregyYKnJ7kquri6fOMQK/STNFRL2ocD0UjE+JJ
 vuY2RkukZN/QplY9MWys1Pp6duNKdppypEhmfJIXS6ELu0s3t+ZVOJlV82oKYX+QW5T7WMcrg
 Vy7OtlvEqBXGj1j3/u95KYD6upbxv5R/ODDML88IyzlG3rm5/GrPG/3CwLzI4a9W3cE56SROW
 4E3pPaURmEGnLALCMp6TZboAKIjupzI1Plb/9wjD8tbOxMLHWc90G+P9pX8paCR3UH1Yu3cfb
 baMBbBYzdz0Gdl+vijDULUq04iEp8xSFGI0TftjEmy2mTMOnHq54t+Y4O0adNNKXL/AaZBfsB
 E0MxwWgqJCAxP3/pBKJvgCa+TFF0M0xI2bXl2OGINj8RiK4uLo/19EgPLrWMgXf/8FWJgMp/V
 G+uZLd1SIq2Xt6cPEzdZZINte1ljtdJtVxGo1fLV96KEdjmO8vfWI9/SCyU8qTCFAv0xcoJ8f
 5CQSSyyucnoroPX1B5vFq98mhM+QkouDbSRfoPuYUJ01BoeNfxmp3byXY7lOOt1UvyE1OUAkF
 xmF7UkuvfMrR0S+rBxVPaMHncKEdw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x7S2tlB6bsNu0CHJf6SZO2f4Vvif2FSTF
Content-Type: multipart/mixed; boundary="DJoz9K1W4g9iLQcG6ICaIvLq9h4HnmTuh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1bd8d0f1-76e1-1bda-867e-3fadc35c30a2@gmx.com>
Subject: Re: Kernel crash related to LZO compression
References: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
In-Reply-To: <63eaecce7b60646b7322146ea3f707ba@mail.ru>

--DJoz9K1W4g9iLQcG6ICaIvLq9h4HnmTuh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/25 =E4=B8=8B=E5=8D=8811:56, Dmitry Katsubo wrote:
> Dear btrfs community,
>=20
> My excuses for the dumps for rather old kernel (4.9.25), nevertheless I=

> wonder
> about your opinion about the below reported kernel crashes.
>=20
> As I could understand the situation (correct me if I am wrong), it happ=
ened
> that some data block became corrupted which resulted the following
> kernel trace
> during the boot:
>=20
> kernel BUG at /build/linux-fB36Cv/linux-4.9.25/fs/btrfs/extent_io.c:231=
8!
> invalid opcode: 0000 [#1] SMP
> Call Trace:
> =C2=A0[<f8c63739>] ? end_bio_extent_readpage+0x4e9/0x680 [btrfs]
> =C2=A0[<f8c951eb>] ? end_compressed_bio_read+0x3b/0x2d0 [btrfs]
> =C2=A0[<f8c771de>] ? btrfs_scrubparity_helper+0xce/0x2d0 [btrfs]
> =C2=A0[<de07ebb1>] ? process_one_work+0x141/0x380
> =C2=A0[<de07ee31>] ? worker_thread+0x41/0x460
> =C2=A0[<de0840e4>] ? kthread+0xb4/0xd0
> =C2=A0[<de07edf0>] ? process_one_work+0x380/0x380
> =C2=A0[<de084030>] ? kthread_park+0x50/0x50
> =C2=A0[<de5aae03>] ? ret_from_fork+0x1b/0x28
>=20
> The problematic file turned out to be the one used by systemd-journald
> /var/log/journal/c496cea41ebc4700a0dfaabf64a21be4/system.journal
> which was trying to read it (or append to it) during the boot and that =
was
> causing the system crash (see attached bootN_dmesg.txt).
>=20
> I've rebooted in safe mode and tried to copy the data from this
> partition to
> another location using btrfs-restore, however kernel was crashing as
> well with
> a bit different symphom (see attached copyN_dmesg.txt):
>=20
> Call Trace:
> =C2=A0[<f8b4c760>] ? lzo_decompress_biovec+0x1b0/0x2b0 [btrfs]
> =C2=A0[<d71a8828>] ? vmalloc+0x38/0x40
> =C2=A0[<f8b4d415>] ? end_compressed_bio_read+0x265/0x2d0 [btrfs]
> =C2=A0[<f8b2f1de>] ? btrfs_scrubparity_helper+0xce/0x2d0 [btrfs]
> =C2=A0[<d707ebb1>] ? process_one_work+0x141/0x380
> =C2=A0[<d707ee31>] ? worker_thread+0x41/0x460
> =C2=A0[<d70840e4>] ? kthread+0xb4/0xd0
> =C2=A0[<d75aae03>] ? ret_from_fork+0x1b/0x28
>=20
> Just to keep away from the problem, I've removed this file and also rem=
oved
> "compress=3Dlzo" mount option.
>=20
> Are there any updates / fixes done in that area? Is lzo option safe to =
use?

Yes, we have commits to harden lzo decompress code in v4.18:

de885e3ee281a88f52283c7e8994e762e3a5f6bd btrfs: lzo: Harden inline lzo
compressed extent decompression
314bfa473b6b6d3efe68011899bd718b349f29d7 btrfs: lzo: Add header length
check to avoid potential out-of-bounds acc

And for the root cause, it's compressed data without csum, then scrub
could make it corrupted.

It's also fixed in v4.18:

665d4953cde6d9e75c62a07ec8f4f8fd7d396ade btrfs: scrub: Don't use inode
page cache in scrub_handle_errored_block()
ac0b4145d662a3b9e34085dea460fb06ede9b69b btrfs: scrub: Don't use inode
pages for device replace

Thanks,
Qu

>=20
> P.S. Perhaps relative issue is in "Warnings" section:
>=20
> https://wiki.debian.org/Btrfs#Warnings /
> https://www.spinics.net/lists/linux-btrfs/msg56563.html
>=20


--DJoz9K1W4g9iLQcG6ICaIvLq9h4HnmTuh--

--x7S2tlB6bsNu0CHJf6SZO2f4Vvif2FSTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvSW0YACgkQwj2R86El
/qgpTgf+KISQxWSrmJ/poA2KbL9nz9hjMF5IG32+GcG4WsNHqFbZgL+VwNodN7AI
g/MuHo3H+AW4sWR1AjbJNPGMOGUcG19Q0YPxCMjwL5a3M78nzOdlGAEEkdsOpc3j
UErQeI6ER/nG+8FhBqZ4d0lOhRdQMvWvPKfJcx2vHB3HeaaSXU7NMiIphPK3Mn0P
3Y3LRWj1Pp8qwrjIWCrbzNFJPMvijd8alOTrlGZelL7mAqjPlrxLLS1R2Wx9V9s/
8V3bFw3g7HI8xaD39HAGuNBaNofCI/zZaiMAMnFiIDQKaKC5rsH43qcNiGngwnSA
vDwGFOKCxQNjXoHeRIgoD3qcMYYqBA==
=b1so
-----END PGP SIGNATURE-----

--x7S2tlB6bsNu0CHJf6SZO2f4Vvif2FSTF--
