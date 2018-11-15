Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51ECC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 01:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAB4D2089F
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 01:30:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAB4D2089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbeKOLgh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 06:36:37 -0500
Received: from mout.gmx.net ([212.227.17.20]:37125 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbeKOLgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 06:36:36 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M6vSj-1fZgpu3e9V-00wnXP; Thu, 15
 Nov 2018 02:30:48 +0100
Subject: Re: [PATCH 0/6] btrfs: fix compiler warning with make W=1
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181114133520.16069-1-jthumshirn@suse.de>
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
Message-ID: <2b491534-6071-131f-1d87-4239ee9c42ec@gmx.com>
Date:   Thu, 15 Nov 2018 09:30:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181114133520.16069-1-jthumshirn@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QY8btIaiy70L03Nlil7U9dN8acjBFPM7q"
X-Provags-ID: V03:K1:uEWUGjcOzdwDU9UjiA4/GxfPLTMT8unbE29xdebRrGeI13aZWoh
 8rqlmhmk1sIWAYvGXSFlYR/fg5uDcH4eJziWCKyFG2WC7ALRGu/1lYP6MhZsn0JKCq05ndw
 WCWgNThfmfV7oHVwvsZUgs3WVHsB4zsc04TS60YpcmNnRVIVPIaMiBlLElYdKhyvnsoEb1k
 PbaIZ57La3Eba9nKCx8Lw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:gpcl5pxKkgQ=:JgFfiuExVU4zC5k6T2rp1I
 t9sKolMCYEBbh2OuT0s5lt827JdUSN1YV8H9ftEHS6xayz8KZd+D5sdjZDCFLtK3QFm0JVxNI
 XPDJHkIlPHBTHM9ZGoFVXk/84Nd1n8yFvlDlHeCsgYFwT3ZYt7T1IZUXWI5b0qiNqk7Ru2tSN
 apALMbSrw7xV2eEJf6kDab/V9C5qusotjv8nSlmxdX4TqARvjBsk9TwHt7PqfNaa/sldO2W66
 6Z0X9fQxm7RDQsApqY+Xuw39illRoJTkzwOaKLpqB7cr16/USlII31pzn4wq2RowJ4hS6qazf
 2vx7cMmUlpgB08+RevYMGmVZFGCooVNiSSkPFB467fO6cDiO3h/B7VNSE2AKQ59DvYmj6wwOR
 0QnKyblL/sqO78SD2qi8+C3rl3cBpTOjp46pVC5q5F1Yzr2zFhU9BFtzY1Wzwt+9ui7KzGp9Y
 OCULY/xFP5aeA+//RG7SEj8etycmJMMq1sc7X2+3NdtWspjssHNfzleDf5u7NS30esCVWnyyw
 715AoGz0+Ef4mkwsnTJHgf858yvwv6FfI5P2GXGqHZz1hS1Mpi54BeyxYkHZnzFp1QGS5lBvm
 BHPc31DDjoFVr2oQzyN+YGY5101IATRRy6iGR0fKU3WuRvc9mPW2SjnEvMBCwg1urxnybAXA8
 Zskda1PfPJ+WvXhXMR0crXPOJHqOn9rn+CSClGneCTMKs8PBKAiKCLVip58hR7vp8ASyXRfBS
 ncY09YCjfs6eCgv+0T8G8Bw1skF/dN5xqfRYXvR5Pi2+cGtowU48VvUlqp+BaOeGWYmtJ9kZq
 xslPqfqO/2hwRpK6krZWm5xpSlVyKkjmJJyFVtrVZCA2mz0q09fzUeJETk6MnFKTmr3FNlcBq
 Sen/i6zwq56JMdM/3Q/URNMKbffuQLiGZ82UaxI5xUmjOvILr39RZjMjwgrA+8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QY8btIaiy70L03Nlil7U9dN8acjBFPM7q
Content-Type: multipart/mixed; boundary="n4pNh6TxXYzdPQidDpmVcA9CqYH8eyi3g";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Thumshirn <jthumshirn@suse.de>, David Sterba <dsterba@suse.com>
Cc: Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Message-ID: <2b491534-6071-131f-1d87-4239ee9c42ec@gmx.com>
Subject: Re: [PATCH 0/6] btrfs: fix compiler warning with make W=1
References: <20181114133520.16069-1-jthumshirn@suse.de>
In-Reply-To: <20181114133520.16069-1-jthumshirn@suse.de>

--n4pNh6TxXYzdPQidDpmVcA9CqYH8eyi3g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/14 =E4=B8=8B=E5=8D=889:35, Johannes Thumshirn wrote:
> This patchset fixes most of the compiler warnings encountered when buil=
ding
> btrfs with make W=3D1.
>=20
> There are two more compiler warnings left in raid56.c:
>   CC [M]  fs/btrfs/raid56.o
> fs/btrfs/raid56.c: In function =E2=80=98finish_rmw=E2=80=99:
> fs/btrfs/raid56.c:1185:6: warning: variable =E2=80=98p_stripe=E2=80=99 =
set but not used [-Wunused-but-set-variable]
>   int p_stripe =3D -1;
>       ^
> fs/btrfs/raid56.c: In function =E2=80=98finish_parity_scrub=E2=80=99:
> fs/btrfs/raid56.c:2343:6: warning: variable =E2=80=98p_stripe=E2=80=99 =
set but not used [-Wunused-but-set-variable]
>   int p_stripe =3D -1;
>       ^
> but I'm currently unsure how an appropriate fix would look like. As far=
 as I
> can tell these variables have always been unused since they have been
> introduced.
>=20
> There are still warnings left emitted by kernel-doc but these are subje=
ct to
> another patchset, this one only addresses the warnings generated by gcc=
=2E

Looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

BTW, could we just make "-Wunused-but-set-variable" default for btrfs
module instead of following the global setting?

Thanks,
Qu


>=20
> Johannes Thumshirn (6):
>   btrfs: remove unused drop_on_err in btrfs_mkdir()
>   btrfs: remove set but not used variable err in btrfs_add_link
>   btrfs: remove unused function btrfs_sysfs_feature_update()
>   btrfs: remove unused variable tree in bio_readpage_error()
>   btrfs: remove unused variable tree in end_compressed_bio_write()
>   btrfs: unconditionally provide function prototypes from
>     free-space-tree.h
>=20
>  fs/btrfs/compression.c     |  2 --
>  fs/btrfs/extent_io.c       |  3 ---
>  fs/btrfs/free-space-tree.h |  2 --
>  fs/btrfs/inode.c           | 16 ++++++----------
>  fs/btrfs/sysfs.c           | 33 ---------------------------------
>  fs/btrfs/sysfs.h           |  2 --
>  6 files changed, 6 insertions(+), 52 deletions(-)
>=20


--n4pNh6TxXYzdPQidDpmVcA9CqYH8eyi3g--

--QY8btIaiy70L03Nlil7U9dN8acjBFPM7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvszEMACgkQwj2R86El
/qjwkgf/Q+oxFmJLiepuGTNbH/w1/khSJkz6zIjuCmcKh/RbR9azvwihfoMk/NU3
sV/RqcQbY6sREtVoKLTSKsim1i/aW5CwX+AfmHdWU70HdWNR3KYdUwCq3juttjm3
jyA14hE+FWeQ/ddAWYK1gfvnGH2N58cjpbCekZkGJ9tO/H2cY3GgvulQLMZBIA6M
jAmN4bdawx9dwWzLUX2fgK7t1D2kD/uAGQfPQ7rL0fywamNWs4rqsrlCiXipTZOz
OVOSyfC2DTdwKBSO9aUguC2zTblut5v5Di5TIk1yEpdqxY0Vt5XnHmuqMJb+/dBD
0Sjajz6bA1oNFyZjT+VqJLX5gIxG9Q==
=9cam
-----END PGP SIGNATURE-----

--QY8btIaiy70L03Nlil7U9dN8acjBFPM7q--
